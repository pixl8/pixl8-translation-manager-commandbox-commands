/**
 * @singleton      true
 */
component {

	property name="configService" inject="configService";

// CONSTRUCTOR
	public any function init() {
		return this;
	}

// PUBLIC API METHODS
	public struct function push(
		  required string projectSlug
		, required string projectVersion
		, required string sourceDirectory
	) {
		var directoryFiles = DirectoryList( arguments.sourceDirectory, true, "path", "*.properties" );
		var filesToPush    = [];

		for( var filePath in directoryFiles ) {
			ArrayAppend( filesToPush, {
				  filename = Right( filePath, Len( filePath )-Len( arguments.sourceDirectory ) )
				, content = FileRead( filePath )
			} );
		}

		return _apiCall(
			  uri    = "/project/#arguments.projectSlug#/#arguments.projectVersion#/"
			, method = "POST"
			, body   = filesToPush
		);

	}

	public struct function pull(
		  required string projectSlug
		, required string projectVersion
		, required string targetDirectory
		, required string languages
	) {
		var filesToWrite = _apiCall(
			  uri = "/project/#arguments.projectSlug#/#arguments.projectVersion#/"
			, params = { languages=arguments.languages }
			, method = "GET"
		);
		var report = { fileCount=ArrayLen( filesToWrite ), files=[] };

		for( var fileToWrite in filesToWrite ) {
			var fullPath = arguments.targetDirectory & fileToWrite.filename;
			DirectoryCreate( GetDirectoryFromPath( fullPath ), true, true );
			FileWrite( fullPath, fileToWrite.content );
			ArrayAppend( report.files, fullPath );
		}

		return report;
	}

	public boolean function checkSettings() {
		var endpoint = configService.getSetting( "pixl8.translation.manager.endpoint" );
		var apiKey   = configService.getSetting( "pixl8.translation.manager.apikey" );

		return Len( Trim( endpoint ) ) && Len( Trim( apiKey ) );
	}

// PRIVATE HELPERS
	private any function _apiCall(
		  required string uri
		,          string method = "GET"
		,          struct params = {}
		,          any    body
	) {
		var apiCallUrl = configService.getSetting( "pixl8.translation.manager.endpoint" ) & arguments.uri;
		var apiKey     = configService.getSetting( "pixl8.translation.manager.apikey" );
		var paramType  = arguments.method == "GET" ? "url" : "formfield";
		var response   = "";

		http url=apiCallUrl throwonerror=true timeout=60 result="response" method="#arguments.method#" {
			httpparam type="header" name="Authorization" value="Basic #toBase64( ":#apiKey#" )#";
			for( var key in arguments.params ) {
				httpparam type=paramType name=key value=arguments.params[ key ];
			}
			if ( StructKeyExists( arguments, "body" ) ) {
				httpparam type="header" name="Content-Type" value="application/json; charset=UTF-8";
				httpparam type="body" value=SerializeJson( arguments.body );
			}
		}

		return DeserializeJson( response.fileContent ?: "" );
	}

// GETTERS AND SETTERS

}
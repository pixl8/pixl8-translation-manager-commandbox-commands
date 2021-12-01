/**
 * Pushes translation files for a project
 * to the Translation Manager.
 *
 **/
component {

	property name="apiService" inject="Pixl8TranslationManagerApiService@pixl8-translation-manager-commandbox-commands";

	/**
	 * @projectSlug.hint     i.e. package name, such as preside-ext-admin-dashboards
	 * @projectVersion.hint  current build version, e.g. 5.3.0
	 * @sourceDirectory.hint Source directory containing i18n .properties files
	 **/
	function run(
		  required string projectSlug
		, required string projectVersion
		, required string sourceDirectory
	) {
		if ( !apiService.checkSettings() ) {
			return _printError( "Translation manager API connection is not configured. Please configure by running the *pixl8 translations setCredentials* and *pixl8 translations setEndpoint* commands." );
		}

		if ( !Len( Trim( arguments.projectSlug ) ) ) {
			return _printError( "You must enter a project slug" );

		}

		if ( !DirectoryExists( arguments.sourceDirectory ) ) {
			return _printError( "Source directory does not exist: [#arguments.sourceDirectory#]" );

		}

		if ( !ReFindNoCase( "^[0-9]+\.[0-9]+\.[0-9]+", arguments.projectVersion ) ) {
			return _printError( "Project version must be in semver format, e.g. 4.0.2, or 0.9.0-rc2, etc." );
		}

		var report = apiService.push(
			  projectSlug     = arguments.projectSlug
			, projectVersion  = arguments.projectVersion
			, sourceDirectory = arguments.sourceDirectory
		);

		print.line();
		print.greenLine( "push success: " & SerializeJson( report ) );
		print.line();
	}

// PRIVATE HELPERS
	private void function _printError( required string errorMessage ) {
		print.line();
		print.redLine( arguments.errorMessage );
		print.line();
	}
}
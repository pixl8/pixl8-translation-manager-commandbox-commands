/**
 * Pulls translation files into a Preside project,
 * automatically looping through extensions, etc.
 * to get all the translation projects associated with the project
 **/
component {

	property name="apiService" inject="Pixl8TranslationManagerApiService@pixl8-translation-manager-commandbox-commands";

	/**
	 * @projectSlug.hint     i.e. package name, such as preside-ext-admin-dashboards
	 * @projectVersion.hint  Project version to fetch
	 * @rootDirectory.hint   Root directory of the Preside project
	 * @languages.hint       Comma list of ISO language codes to pull, e.g. fr,de,es
	 * @includePreside       Whether or not to pull translations down for Preside itself
	 * @includeExtensions    Whether or not to pull translations down for extensions
	 * @includeProject       Whether or not to pull translations for the project itself
	 **/
	function run(
		  required string  projectSlug
		, required string  projectVersion
		, required string  rootDirectory
		, required string  languages
		,          boolean includePreside    = true
		,          boolean includeExtensions = true
		,          boolean includeProject    = true
	) {
		if ( !apiService.checkSettings() ) {
			return _printError( "Translation manager API connection is not configured. Please configure by running the *pixl8 translations setCredentials* and *pixl8 translations setEndpoint* commands." );
		}

		if ( !Len( Trim( arguments.projectSlug ) ) ) {
			return _printError( "You must enter a project slug" );

		}

		if ( !DirectoryExists( arguments.rootDirectory ) ) {
			return _printError( "Root directory does not exist: [#arguments.targetDirectory#]" );
		}

		if ( !FileExists( arguments.rootDirectory & "/Application.cfc" ) || !DirectoryExists( arguments.rootDirectory & "/application" ) ) {
			return _printError( "Root directory does not appear to be for a Preside application: [#arguments.targetDirectory#]. Check that this is the correct directory and try again." );
		}

		if ( !ReFindNoCase( "^[0-9]+\.[0-9]+\.[0-9]+", arguments.projectVersion ) ) {
			return _printError( "Project version must be in semver format, e.g. 4.0.2, or 0.9.0-rc2, etc." );
		}

		if ( arguments.includeProject ) {
			print.line();
			print.greenLine( "Pulling translations for the project: #arguments.projectSlug#@#arguments.projectVersion# " );
			print.line();

			try {
				command( "pixl8 translations pull" ).params(
					  projectSlug     = arguments.projectSlug
					, projectVersion  = arguments.projectVersion
					, targetDirectory = arguments.rootDirectory & "/application/i18n"
					, languages       = arguments.languages
				).run();
			} catch( any e ) {
				print.yellowLine( "Error pulling files (possibly no project in Translation Manager): [#e.message#]" );
			}
		}

		if ( arguments.includePreside ) {
			var presideVersion = _readVersion( arguments.rootDirectory & "/preside/box.json" );

			print.line();
			print.greenLine( "Pulling translations for Preside core @ #presideVersion#..." );
			print.line();

			try {
				command( "pixl8 translations pull" ).params(
					  projectSlug     = presidecms
					, projectVersion  = presideVersion
					, targetDirectory = arguments.rootDirectory & "/preside/system/i18n"
					, languages       = arguments.languages
				).run();
			} catch( any e ) {
				print.yellowLine( "Error pulling files (possibly no project in Translation Manager): [#e.message#]" );
			}
		}

		if ( arguments.includeExtensions ) {
			var extensionDirs = DirectoryList( arguments.rootDirectory & "/application/extensions", false, "path" );
			for( var extensionDir in extensionDirs ) {
				var slug = ListLast( extensionDir, "\/" );
				var version = _readVersion( extensionDir & "/box.json" );

				print.line();
				print.greenLine( "Pulling translations for #slug#@#version#..." );
				print.line();

				DirectoryCreate( extensionDir & "/i18n", false, true );

				try {
					command( "pixl8 translations pull" ).params(
						  projectSlug     = slug
						, projectVersion  = version
						, targetDirectory = extensionDir & "/i18n"
						, languages       = arguments.languages
					).run();
				} catch( any e ) {
					print.yellowLine( "Error pulling files (possibly no project in Translation Manager): [#e.message#]" );
				}
			}
		}

		print.line();
		print.greenLine( "Finished!" );
		print.line();
	}

// PRIVATE HELPERS
	private void function _printError( required string errorMessage ) {
		print.line();
		print.redLine( arguments.errorMessage );
		print.line();
	}

	private string function _readVersion( boxJsonPath ) {
		var version = "1000000.0.0";
		try {
			version = DeserializeJson( FileRead( arguments.boxJsonPath ) ).version;
		} catch( any e ) {
			print.yellowLine( "could not read version from #boxJsonPath#. Using #version# instead." );
		}

		if ( !ReFindNoCase( "^[0-9]+\.[0-9]+\.[0-9]+", version ) ) {
			print.yellowLine( "Version not in semver format ([#version#]). Using [1000000.0.0] instead to force latest version pull." );
			version = "1000000.0.0";
		}

		return ReReplace( version, "^([0-9]+\.[0-9]+\.[0-9]+).*", "\1" );
	}
}
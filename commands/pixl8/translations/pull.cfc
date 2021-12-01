/**
 * Pulls translation files down from Translation Manager
 *
 **/
component {

	property name="apiService" inject="Pixl8TranslationManagerApiService@pixl8-translation-manager-commandbox-commands";

	/**
	 * @projectSlug.hint     i.e. package name, such as preside-ext-admin-dashboards
	 * @projectVersion.hint  Project version to fetch
	 * @targetDirectory.hint Target directory where i18n files will be written
	 * @languages.hint       Comma list of ISO language codes to pull, e.g. fr,de,es
	 **/
	function run(
		  required string projectSlug
		, required string projectVersion
		, required string targetDirectory
		, required string languages
	) {
		if ( !apiService.checkSettings() ) {
			return _printError( "Translation manager API connection is not configured. Please configure by running the *pixl8 translations setCredentials* and *pixl8 translations setEndpoint* commands." );
		}

		if ( !Len( Trim( arguments.projectSlug ) ) ) {
			return _printError( "You must enter a project slug" );

		}

		if ( !DirectoryExists( arguments.targetDirectory ) ) {
			return _printError( "Target directory does not exist: [#arguments.targetDirectory#]" );

		}

		if ( !ReFindNoCase( "^[0-9]+\.[0-9]+\.[0-9]+", arguments.projectVersion ) ) {
			return _printError( "Project version must be in semver format, e.g. 4.0.2, or 0.9.0-rc2, etc." );
		}

		var report = apiService.pull(
			  projectSlug     = arguments.projectSlug
			, projectVersion  = arguments.projectVersion
			, targetDirectory = arguments.targetDirectory
			, languages       = arguments.languages
		);

		print.line();
		print.greenLine( "Pull success, imported [#NumberFormat( report.fileCount )#]  files."  );
		print.line();
	}

// PRIVATE HELPERS
	private void function _printError( required string errorMessage ) {
		print.line();
		print.redLine( arguments.errorMessage );
		print.line();
	}
}
/**
 * Register credentials for Pixl8 MIS API
 * Calls (i.e. private package management)
 *
 **/
component {

	property name="configService" inject="configService";

	/**
	 * @apiKey.hint Access key
	 **/
	function run( string apiKey="" ) {
		while( !arguments.apiKey.len() ) {
			arguments.apiKey = shell.ask( "Enter your Translation Manager API key: " );
		}


		configService.setSetting( "pixl8.translation.manager.apikey", arguments.apiKey );
		print.greenLine( "Thank you, credentials have been set." );

		return;
	}

}
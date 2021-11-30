/**
 * Register credentials for Pixl8 MIS API
 * Calls (i.e. private package management)
 *
 **/
component {

	property name="pixl8Utils" inject="Pixl8Utils@pixl8-commandbox-commands";

	/**
	 * @endpoint.hint Endpoint. URL with no trailing slash. e.g. https://translations.mycompany.com/api/translations/v1
	 **/
	function run( string endpoint="" ) {
		while( !arguments.endpoint.len() ) {
			arguments.endpoint = shell.ask( "Enter your translation manager endpoint, no trailing slash (e.g. https://translations.mycompany.com/api/translations/v1): " );
		}

		pixl8Utils.storeMisEndpoint( argumentCollection=arguments );
		configService.setSetting( "pixl8.translation.manager.endpoint", arguments.endpoint );

		print.greenLine( "Thank you, endpoint has been set." );

		return;
	}

}

(getText(configFile >> "CfgMasterServer" >> "serverCommandPassword")) servercommand "#lock";

[
	"lilse_common_afterDatabaseInitialization",
	{
		[] spawn lils_common_fnc_waitUntilRestart;
	}
] call CBA_fnc_addEventHandler;

lils_database_defaultProtocolName = (["database_defaultProtocolName", "STRING", "LiveInLifeDatabase", (configFile >> "CfgMasterServer")] call lilc_common_fnc_getSetting);

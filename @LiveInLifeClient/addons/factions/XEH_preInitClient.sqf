
[
	"lilce_login_postAccountInit",
	{
		call lilc_common_fnc_setObjectLocks;
	}
] call CBA_fnc_addEventHandler;

lilc_factions_factions = [];
{
	private _c = getArray(_x >> "color");
	for "_i" from 0 to ((count _c) - 1) do
	{
		if ((_c select _i) isEqualType "") then
		{
			diag_log str (parseNumber (_c select _i));
			_c set [_i, (parseNumber (_c select _i))];
		};
	};
	diag_log str _c;
	lilc_factions_factions pushBack [
		getNumber(_x >> "id"),
		getText(_x >> "title"),
		getText(_x >> "description"),
		getArray(_x >> "respawn"),
		_c,
		(_c call BIS_fnc_colorRGBAToHTML),
		(getNumber(_x >> "nameVisible")),
		getNumber(_x >> "markers"),
		getText(_x >> "markerColorUnit"),
		getText(_x >> "markerTypeUnit"),
		getText(_x >> "markerColorGroup"),
		getText(_x >> "markerTypeGroup"),
		getText(_x >> "markerColorGroupUnit"),
		getText(_x >> "markerTypeGroupUnit")
	];
	true;
} count ("true" configClasses (missionConfigFile >> "CfgFactions"));

[
	"set_lil_factions_faction",
	{
		private _fCfg = ([_this] call lilc_factions_fnc_getFactionConfig);
		lilc_player_faction = [
			_this,
			getText(_fCfg >> "title"),
			getText(_fCfg >> "color")
		];
	}
] call lilc_login_fnc_addPackage;


params [
    ["_unit", objNull, [objNull]],
    ["_rankID", 0, [0]]
];

if (isNull _unit || _rankID <= -1) exitWith {};

private _factionID = _unit getVariable ["lilc_factionID", -1];
if (_factionID <= -1) exitWith {};

private _rankPermissions = [[
    "faction_ranks",
    [
        ["permissions"]
    ],
    [
        ["rid", _rankID],
        ["fid", _factionID]
    ]
] call lils_database_fnc_generateFetchQuery] call lils_database_fnc_fetchObjects;

try {
    if ((count _rankPermissions) <= 0) throw [];
    _rankPermissions = _rankPermissions select 0;

    throw ([_rankPermissions select 0] call lils_common_fnc_arrayDecode);
} catch {
    [_exception, "lilc_factions_interface_fnc_rankSetPermissions", _unit] call lilc_common_fnc_send;
};

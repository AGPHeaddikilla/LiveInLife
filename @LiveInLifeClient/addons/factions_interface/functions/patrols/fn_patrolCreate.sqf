
if !(["factions_interface.patrols.create"] call lilc_permissions_fnc_have) exitWith {};

private _factionID = player getVariable ["lilc_factionID", -1];
if (_factionID <= -1) exitWith {};

private _newGroup = createGroup civilian;
_newGroup setVariable ["lilc_factionID", _factionID, true];

[player] joinSilent _newGroup;

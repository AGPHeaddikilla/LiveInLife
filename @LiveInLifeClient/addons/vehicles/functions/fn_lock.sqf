
params [
    ["_vehicle", objNull, [objNull]],
    ["_status", 0, [0, false]],
    ["_receiving", false, [false]]
];

if (isNull _vehicle) exitWith {};
if (_receiving || (local _vehicle)) then {
    _vehicle lock _status;
} else {
    [_vehicle, _status, true] remoteExecCall ["lilc_vehicles_fnc_lock", 0];
};

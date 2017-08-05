
params [
    ["_vehicle", objNull, [objNull]],
    ["_unit", objNull, [objNull]]
];

try {
    if (isNull _vehicle) throw false;
    if (isNull _unit) throw false;
    if !(isPlayer _unit) throw false;
    if ((typeOf _vehicle) == "") throw false;

    
    private _vehicleID = (_vehicle getVariable ["lilc_vehicleID", 0]);
    if (_vehicleID <= 0) throw false;

    if !([
<<<<<<< HEAD:LiveInLifeClient/lilc_keys/functions/fn_add.sqf
        "lilcvi_key_F",
        [
            (format["Key %1", getText(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName")])
        ],
=======
        player,
        "lilcvi_key_F",
        (format["Key %1", getText(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName")]),
>>>>>>> 57e476db94a41457d9f7cb5bca8da2e830fd3063:@LiveInLifeClient/addons/keys/functions/fn_add.sqf
        _vehicleID
    ] call lilc_virtualInventory_fnc_add) throw false;

    throw true;
} catch {
    _exception;
};

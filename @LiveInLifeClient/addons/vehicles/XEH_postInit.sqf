
if (lilc_vehicles_locked_getOut_enable) then {
    player addAction ["Aussteigen", {
        player action ["GetOut", (vehicle player)];
        [(vehicle player), 0] call lilc_vehicles_fnc_lock;
    }, nil, 0, false, false, "", "((vehicle player) != player) && !([(vehicle player)] call lilc_keys_fnc_have) && (locked (vehicle player)) in [2, 3] && !((vehicle player) isKindOf 'Air') && !((vehicle player) isKindOf 'Plane')"];
};

player addEventHandler ["GetInMan", {
    params [
        ["_unit", objNull, [objNull]],
        ["_position", "", [""]],
        ["_vehicle", objNull, [objNull]]
    ];

    if (_position == "driver") then {
        lilc_vehicles_lastVehicle = _vehicle;
    };

    lilc_vehicles_engineEHIndex = (_vehicle addEventHandler ["Engine", {
        params [
            "_vehicle",
            "_status"
        ];

        if (
            !([_vehicle] call lilc_keys_fnc_have) &&
            ((_vehicle getVariable ["lilc_picklock_picklocked", 0]) <= 0) &&
            isMultiplayer &&
            ((_vehicle getVariable ["lilc_vehicleID", 0]) > 0) &&
            _status &&
            (player isEqualTo (driver _vehicle)) &&
            ((player getVariable ["lilc_factionID", -1]) <= -1)
        ) then {
            _vehicle engineOn false;
        };
    }]);

    if ([_vehicle, ["Air", "Aircraft", "Plane", "Helicopter"]] call lilc_common_fnc_isKindOf) then
    {
        call lilc_ui_fnc_enableAircraftInfo;
    };
}];

player addEventHandler ["GetOutMan", {
    params [
        "_unit",
        "_position",
        "_vehicle"
    ];

    if ([_vehicle, ["Air", "Aircraft", "Plane", "Helicopter"]] call lilc_common_fnc_isKindOf) then {
        call lilc_ui_fnc_disableAircraftInfo;
    };

    _vehicle removeEventHandler ["Engine", lilc_vehicles_engineEHIndex];
}];

player addEventHandler["WeaponAssembled", {
    params [
        ["_unit",objNull,[objNull]],
        ["_object",objNull,[objNull]]
    ];

    [_object] call lilc_inventory_fnc_clearVehicleCargo;
}];

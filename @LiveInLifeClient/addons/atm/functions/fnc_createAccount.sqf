#include "..\script_component.hpp"

params ["_unit", "_bank"];

private _profileID = _unit getVariable [QEGVAR(profiles,profileID), 0];

INFO(format[QUOTE(creating bank account for profile %1), _profileID]);

private _req = [
    _profileID,
    10000,
    1000,
    _bank
] call EFUNC(api_banks,createAccount);

if REQ_IS_OK(_req) then {
    private _body = REQ_GET_BODY(_req);

    [QGVAR(selectCreateAccountCompletedPage), [[_body, "id"] call a3uf_json_fnc_get]] call CBA_fnc_targetEvent;
} else {
    [QGVAR(selectCreateAccountFailedPage)] call CBA_fnc_targetEvent;
};

DIALOG_ATM_ACTIVE_BUTTONS([]);


disableSerialization;
private _ui = (findDisplay 1301);
params [
    ["_licenseName", "", [""]],
    ["_target", (_ui getVariable ["lilc_licenses_target", objNull]), [objNull]]
];

try
{
    if !([_target] call lilc_common_fnc_isAlive) throw false;
    private _itemConfig = ([_licenseName] call lilc_virtual_inventory_fnc_getVirtualItemConfig);
    if (isNull _itemConfig) throw false;

    private _itemTypes = getArray(_itemConfig >> "types");
    if !("license" in _itemTypes) throw false;

    if !([(["licenses", _licenseName, "add"] call lilc_permissions_fnc_bindPermissionTree)] call lilc_permissions_fnc_have) throw false;

    [
        _target,
        _licenseName,
        "",
        -1
    ] call lilc_virtual_inventory_fnc_add;
    ["Lizenz erfolgreich verteilt."] call lilc_ui_fnc_hint;
    [false, "lilc_licenses_fnc_licenseAdded", _target] call lilc_common_fnc_send;

    lbClear 1501;
    {
        private _itemConfig = ([_x select 0] call lilc_virtual_inventory_fnc_getVirtualItemConfig);
        if !(isNull _itemConfig) then
        {
            private _index = (lbAdd [1501, getText(_itemConfig >> "displayName")]);
            lbSetData [1501, _index, _x select 0];
            lbSetPicture [1501, _index, getText(_itemConfig >> "picture")];
            lbSetValue [1501, _index, _x select 2];
        };
    } forEach ((_target getVariable ["lilc_virtual_inventory_inventory", []]) select {
        ([(["licenses", _x select 0, "remove"] call lilc_permissions_fnc_bindPermissionTree)] call lilc_permissions_fnc_have) && (_x select 0) in _applicableLicenses;
    });
}
catch
{
    if !(_exception) then {
        ["Die Lizenz konnte nicht verteilt werden.", "ERROR"] call lilc_ui_fnc_hint;
    };
    _exception;
};

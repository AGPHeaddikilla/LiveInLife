
private _shopName = param [0, "", [""]];

try {
    private _factionID = (player getVariable ["lilc_factionID", -1]);
    if (isNull player) throw false;
    if (!alive player) throw false;
    if (!isPlayer player) throw false;

    private _factionConfig = ([_factionID] call lilc_factions_fnc_getFactionConfig);
    if (isNull _factionConfig && _shopname == "") throw false;
    
    private _shopConfig = [];
    if (lilc_shops_currentShopname == "" && _factionID > -1) then {
        _shopConfig = [getText(([_factionID] call lilc_factions_fnc_getFactionConfig) >> "title"), [_factionID]];
    } else {
        _shopConfig = ([lilc_shops_currentShopname] call lilc_shops_fnc_getShopConfig);
    };
    if (!(_factionID in (_shopConfig select 1)) && (count (_shopConfig select 1)) != 0) throw false;

    lilc_shops_currentShopname = _shopname;

    disableSerialization;
    if !(createDialog "lilcm_shops_buyItems") throw false;
    
    private _ui = (findDisplay 1205);
    private _uiTitle = (_ui displayCtrl 1206);
    private _uiTextSumOf = (_ui displayCtrl 1210);
    private _uiButtonRemove = (_ui displayCtrl 1213);
    
    _uiTitle ctrlSetText (_shopConfig select 0);
    _uiButtonRemove ctrlSetText "<<";
    _uiTextSumOf ctrlSetStructuredText parseText format["<t align='left' font='PuristaMedium'>Summe: 0$</t>"];

    call lilc_shops_fnc_updateBuyItemsMenu;
} catch {
    _exception;
};

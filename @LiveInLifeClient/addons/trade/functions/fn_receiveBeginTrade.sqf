
private _unit = param [0, objNull, [objNull]];

try
{
    if (isNull _unit) throw false;
    if !(isPlayer _unit) throw false;

    lilc_trade_tradePartner = _unit;
    player setVariable ["lilc_trade_isTrading", true, true];

    if !(createDialog "lilcm_trade") then
    {
        call lilc_trade_fnc_cancelTrade;
        throw false;
    };
    
    (findDisplay 1640) displayAddEventHandler ["KeyDown", {
        if ((_this select 1) == 1) then
        {
            true;
        }
        else
        {
            false;
        };
    }];

    lilc_trade_availableMoney = lilc_player_cash;

    call lilc_trade_fnc_updateMyInventory;
    call lilc_trade_fnc_updateOfferTradePartner;
}
catch
{
    _exception;
};

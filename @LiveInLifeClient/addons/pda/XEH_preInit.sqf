
lilc_pda_currentAccountData = [];

[
    "LiveInLife",
    "lilck_openPDAMenu",
    "Open PDA (Personal Digital Assistant)",
    {
        call lilc_pda_fnc_openMenu;
    },
    {},
    [39, [false, false, false]]
] call CBA_fnc_addKeybind;


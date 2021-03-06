#include "..\script_component.hpp"

params [
    ["_count", 0, [0]],
    ["_page", 0, [0]]
];

if (_count <= 0) exitWith { []; };
if (_page <= 0) exitWith { []; };

[
    "exchange/accounts?count=%1&page=%2",
    [
        _count,
        _page
    ],
    "GET",
    [
        QUSERS_ACCESS_TOKEN_HEADER, EGVAR(api_users,token)
    ],
    []
] call EFUNC(api,request);

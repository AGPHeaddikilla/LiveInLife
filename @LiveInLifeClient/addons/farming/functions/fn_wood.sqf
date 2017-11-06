
params [
    ["_wood", objNull, [objNull]]
];

if (isNull _wood) exitWith {}; 
if ((_wood distance2D player) > 5) exitWith {};
if !(([_wood] call lilc_farming_fnc_isTree)) exitWith {};
if ((damage _wood) > 0) exitWith { hint "Der Baum ist schon gefällt."; };
if (lilc_action_active) exitWith {};
lilc_action_active = true; 
 
private _amount = (round (random [2, 6, 10])); 
 
for "_i" from 1 to 3 do { 
    lilc_action_animDone = false; 
    player playMoveNow "Acts_Executioner_Forehand"; 
    lilc_action_animIndex = player addEventHandler ["AnimDone", { 
        player removeEventHandler ["AnimDone", lilc_action_animIndex]; 
        player switchMove ""; 
        lilc_action_animIndex = nil; 
        lilc_action_animDone = true; 
    }]; 
    waitUntil { lilc_action_animDone || (damage _wood) == 1 };
    if ((damage _wood) == 1) exitWith {};
};

if ((damage _wood) == 1) exitWith { player switchMove ""; };
 
private _groundWeaponHolder = "GroundWeaponHolder" createVehicle [0, 0, 0];
_groundWeaponHolder addItemCargoGlobal ["lilci_woodpile_F", _amount];
_groundWeaponHolder setPos [((getPos _wood) select 0), ((getPos _wood) select 1), 0];

lilc_action_active = false;
_wood setDamage 1;

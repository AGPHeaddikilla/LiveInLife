
/*
    Filename:
        fn_setObjectDamage.sqf
    Author:
        Vincent Heins
    Description:
        Sets the given BIS standard hitpoints array at given object.
    Param(s):
        (_this select 0) : the object to handle the damage to : <OBJECTNULL>
		(_this select 1) : the hitpoints array for the object : <ARRAY>
    Result(s):
        true = success; false != true : <BOOL>
*/

params [
    ["_object", objNull, [objNull]],
    ["_damage", [], [[]]]
];

if (isNull _object || (count _damage) <= 0) exitWith {};

{ _object setHitPointDamage [_x, ((_damage select 2) select _forEachIndex)]; } forEach (_damage select 0);

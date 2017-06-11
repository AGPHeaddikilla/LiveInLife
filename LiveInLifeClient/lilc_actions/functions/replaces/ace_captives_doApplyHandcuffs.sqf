/*
 * Author: PabstMirror
 * Checks the conditions for being able to apply handcuffs
 *
 * Arguments:
 * 0: caller (player) <OBJECT>
 * 1: target <OBJECT>
 *
 * Return Value:
 * The return value <BOOL>
 *
 * Example:
 * [player, bob] call ACE_captives_fnc_doApplyHandcuffs;
 *
 * Public: No
 */
#include "\z\ace\addons\captives\script_component.hpp"

params ["_unit", "_target"];

playSound3D [QUOTE(PATHTO_R(sounds\cable_tie_zipping.ogg)), objNull, false, (getPosASL _target), 1, 1, 10];

[QGVAR(setHandcuffed), [_target, true, 0], [_target]] call CBA_fnc_targetEvent;

_unit removeItem "ACE_CableTie";
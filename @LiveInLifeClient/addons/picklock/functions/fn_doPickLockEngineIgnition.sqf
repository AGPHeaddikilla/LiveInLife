
try
{
    if (isNil "lilc_picklock_doPickLockEngineIgnition_task") then
    {
        lilc_picklock_doPickLockEngineIgnition_task = scriptNull;
    };
    if !(isNull lilc_picklock_doPickLockEngineIgnition_task) throw false;

    lilc_picklock_doPickLockEngineIgnition_task = (_this spawn {
        params [
            ["_vehicle", objNull, [objNull]],
            ["_eventTime", [], [[]]],
            ["_eventChance", -1, [0]]
        ];

        private _eventHandlerIndex = ((findDisplay 46) displayAddEventHandler [
            "KeyDown",
            {
                if ((_this select 1) in ((actionKeys "MoveBack") + (actionKeys "MoveForward") + (actionKeys "MoveFastForward") + (actionKeys "TurnLeft") + (actionKeys "TurnRight") + (actionKeys "GetOver"))) then
                {
                    lilc_action_interrupted = true;
                };
                false;
            }
        ]);

        lilc_action_interrupted = false;
        try
        {
            if (isNull _vehicle) throw false;
            if !(alive _vehicle) throw false;
            if !([player] call lilc_common_fnc_isAlive) throw false;

            if (_eventChance <= -1) throw false;

            if ((["lilci_drill_F", player] call lilc_inventory_fnc_itemCount) <= 0) throw false;
            if ((["lilci_screwdriver_F", player] call lilc_inventory_fnc_itemCount) <= 0) throw false;

            private _randomEventTime = (random _eventTime);
            private _randomEventChance = (random 1);

            private _startTime = (time + _randomEventTime);

            player playMoveNow "Acts_carFixingWheel";

            while
            {
                (_startTime > time)
            }
            do
            {
                if (lilc_action_interrupted) exitWith {};
                if ((animationState player) != "Acts_carFixingWheel") then
                {
                    player playMoveNow "Acts_carFixingWheel";
                };

                titleText["Zündung starten...", "PLAIN", 2];

                sleep 0.1;
            };

            titleText["", "PLAIN", 0.01];
            player playMoveNow "AmovPercMstpSnonWnonDnon";

            if (lilc_action_interrupted) then
            {
                ["Die Aktion wurde abgebrochen", "ERROR"] call lilc_ui_fnc_hint;
                throw false;
            };

            if (_randomEventChance <= _eventChance) then
            {
                ["Der Motor wurde gestartet."] call lilc_ui_fnc_hint;

                _vehicle engineOn true;
                _vehicle setVariable ["lilc_picklock_engineIgnitionPicklocked", (player getVariable ["lilc_accountID", 0]), true];
            }
            else
            {
                ["Die Zündung konnte nicht gestartet werden.", "ERROR"] call lilc_ui_fnc_hint;
            };

            if ((["lilci_disposableGloves_F", player] call lilc_inventory_fnc_itemCount) > 0) then
            {
                if ((random 1) < 0.05) then
                {
                    ["Deine Handschuhe sind kaputt gegangen.", "WARNING"] call lilc_ui_fnc_hint;
                    [player, "lilci_disposableGloves_F"] call lilc_inventory_fnc_remove;
                    [_vehicle, "fingerprint", (player getVariable ["lilc_accountID", 0])] call lilc_proofs_fnc_addProof;
                };
            }
            else
            {
                [_vehicle, "fingerprint", (player getVariable ["lilc_accountID", 0])] call lilc_proofs_fnc_addProof;
            };

            if ((headgear player) != "") then
            {
                if ((random 1) < 0.1) then
                {
                    [_vehicle, "hair", (player getVariable ["lilc_accountID", 0])] call lilc_proofs_fnc_addProof;
                };
            }
            else
            {
                if ((random 1) < 0.6) then
                {
                    [_vehicle, "hair", (player getVariable ["lilc_accountID", 0])] call lilc_proofs_fnc_addProof;
                };
            };

            throw true;
        }
        catch
        {
            _exception;
        };
    });
}
catch
{
    _exception;
};

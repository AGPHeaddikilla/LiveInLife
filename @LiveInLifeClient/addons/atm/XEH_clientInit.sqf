#include "script_component.hpp"

[QGVAR(selectMenuPage), {
    [QGVAR(selectMenuLoadingPage)] call CBA_fnc_localEvent;

    DIALOG_ATM_ACCOUNT_LIST ctrlShow false;

    (DIALOG_ATM_DISPLAY getVariable [QGVAR(bankAccountID), 0]) spawn {
        params ["_bankAccountID"];

        private _req = _bankAccountID call EFUNC(api_banks,getAccount);

        if REQ_IS_OK(_req) then {
            private _body = REQ_GET_BODY(_req);

            [QGVAR(selectMenuCompletedPage), [_body]] call CBA_fnc_localEvent;
        } else {
            [QGVAR(selectMenuFailedPage)] call CBA_fnc_localEvent;
        };
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(selectMenuLoadingPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Lade Informationen...</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t shadow='0' align='center' size='1.1'>Bitte warten Sie...</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([]);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectMenuFailedPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Laden fehlgeschlagen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t shadow='0' align='center' size='1.1'>Ihr Bankkonto konnte nicht geladen werden.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([8]);

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Erneut versuchen</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectMenuPage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectMenuCompletedPage), {
    params ["_body"];

    DIALOG_ATM_TITLE ctrlSetStructuredText parseText format[
        "<t shadow='0' align='left' size='1.2'>Übersicht - Kontonummer %1</t><br /><t size='1' font='PuristaLight' shadow='0'>%2 $</t>",
        [_body, "id"] call a3uf_json_fnc_get,
        [_body, "balance"] call a3uf_json_fnc_get
    ];
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "";
    DIALOG_ATM_ACCOUNT_LIST ctrlShow false;
    DIALOG_ATM_ACTIVE_BUTTONS([ARR_2(1,5)]);

    DIALOG_ATM_BUTTON_1_TEXT ctrlSetStructuredText parseText "<t align='right' shadow='0' color='#176a37' font='PuristaSemibold'>Geld einzahlen</t>";
    DIALOG_ATM_BUTTON_1 buttonSetAction QUOTE([QQGVAR(selectDepositPage)] call CBA_fnc_localEvent);

    DIALOG_ATM_BUTTON_5_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Geld auszahlen</t>";
    DIALOG_ATM_BUTTON_5 buttonSetAction QUOTE([QQGVAR(selectDisbursePage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectAccountsPage), {
    DIALOG_ATM_ACCOUNT_LIST ctrlShow false;
    DIALOG_ATM_PROFILE_LIST ctrlShow false;
    DIALOG_ATM_EDIT_VALUE_SHOW(false);

    [QGVAR(selectAccountsLoadingPage)] call CBA_fnc_localEvent;

    0 spawn {
        private _req = [2, [
            ["profile_id", player getVariable [QEGVAR(profiles,profileID), 0]],
            ["bank", DIALOG_ATM_DISPLAY getVariable [QGVAR(bank), ""]]
        ]] call EFUNC(api_banks,getAccounts);

        if REQ_IS_OK(_req) then {
            private _body = REQ_GET_BODY(_req);

            private _accountCount = count ARG_1(_body,1);
            if (_accountCount == 0) then {
                [QGVAR(selectCreateAccountPage)] call CBA_fnc_localEvent;
            } else {
                if (_accountCount == 1) then {
                    DIALOG_ATM_DISPLAY setVariable [QGVAR(bankAccountID), [ARG_2(_body,1,0), "id"] call a3uf_json_fnc_get];
                    [QGVAR(selectMenuPage)] call CBA_fnc_localEvent;
                } else {
                    [QGVAR(selectAccountsCompletedPage), [_body]] call CBA_fnc_localEvent;
                };
            };
        };
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(selectAccountsLoadingPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Lade Informationen...</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t shadow='0' align='center' size='1.1'>Bitte warten Sie...</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([]);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectAccountsFailedPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Laden fehlgeschlagen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t shadow='0' align='center' size='1.1'>Es konnten keine Bankkonten festgestellt werden.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([8]);

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Erneut versuchen</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectAccountsPage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectAccountsCompletedPage), {
    params ["_body"];

    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Lade Informationen...</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t shadow='0' align='center' size='1.1'>Bitte warten Sie...</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([8]);

    lbClear DIALOG_ATM_ACCOUNT_LIST;
    DIALOG_ATM_ACCOUNT_LIST ctrlShow true;
    {
        private _id = [_x, "id"] call a3uf_json_fnc_get;
        private _index = DIALOG_ATM_ACCOUNT_LIST lbAdd str _id;
        DIALOG_ATM_ACCOUNT_LIST lbSetValue [_index, _id];
    } forEach ARG_1(_body,1);

    DIALOG_ATM_ACCOUNT_LIST lbSetCurSel 0;

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Auswaehlen</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectMenuPage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectCreateAccountPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Bankkonto erstellen</t>";

    private _nearUnits = ((player nearEntities ["Man", 10]) - [player]) select { isPlayer _x && !(_x in EGVAR(headless,headlessClients)) && [_x] call EFUNC(common,isAlive); };

    DIALOG_ATM_ACTIVE_BUTTONS([8]);

    if (count _nearUnits > 0) then {
        DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t shadow='0' align='center' size='1.1'>Erstellen Sie ein Bankkonto.<br />Wer hat Ihnen unsere Bank empfohlen? (optional)</t>";

        lbClear DIALOG_ATM_PROFILE_LIST;
        DIALOG_ATM_PROFILE_LIST lbAdd "Niemand";
        DIALOG_ATM_PROFILE_LIST ctrlShow true;
        {
            private _index = DIALOG_ATM_PROFILE_LIST lbAdd str (_x getVariable [QEGVAR(profiles,profileID), 0]);
            DIALOG_ATM_PROFILE_LIST lbSetData [_index, _x call BIS_fnc_netId];
        } forEach _nearUnits;

        DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([ARR_2(QQGVAR(selectCreateAccountCompletePage),QUOTE("bonus"))] call CBA_fnc_localEvent);
    } else {
        DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t shadow='0' align='center' size='1.1'>Erstellen Sie ein Bankkonto.</t>";
        DIALOG_ATM_PROFILE_LIST ctrlShow false;
        DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([ARR_2(QQGVAR(selectCreateAccountCompletePage),QUOTE("normal"))] call CBA_fnc_localEvent);
    };

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Bankkonto erstellen</t>";
}] call CBA_fnc_addEventHandler;

[QGVAR(selectCreateAccountCompletePage), {
    params ["_name"];

    DIALOG_ATM_ACTIVE_BUTTONS([]);
    DIALOG_ATM_PROFILE_LIST ctrlShow false;

    [QGVAR(selectCreateAccountLoadingPage)] call CBA_fnc_localEvent;
    switch (_name) do {
        case "bonus": {
            TARGET_ENDPOINT_CBA_EVENT(QGVAR(createAccountWithBonus),[ARR_3(player,DIALOG_ATM_DISPLAY getVariable [ARR_2(QGVAR(bank),"")],(DIALOG_ATM_PROFILE_LIST lbData lbCurSel DIALOG_ATM_PROFILE_LIST) call BIS_fnc_objectFromNetId)]);
        };

        default {
            TARGET_ENDPOINT_CBA_EVENT(QGVAR(createAccount),[ARR_2(player,DIALOG_ATM_DISPLAY getVariable [ARR_2(QGVAR(bank),"")])]);
        };
    };
}] call CBA_fnc_addEventHandler;

[QGVAR(selectCreateAccountLoadingPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Bankkonto erstellen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Ihr Bankkonto wird erstellt. Wird warten Sie...</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([]);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectCreateAccountFailedPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Bankkonto erstellen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Ihr Bankkonto konnte nicht erstellt werden.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([8]);

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Erneut versuchen</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectCreateAccountPage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectCreateAccountCompletedPage), {
    params ["_bankAccountID"];

    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Bankkonto erstellen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Ihr Bankkonto wurde erstellt.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([8]);

    DIALOG_ATM_DISPLAY setVariable [QGVAR(bankAccountID), _bankAccountID];

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Loslegen</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectMenuPage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDepositPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Geld einzahlen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Bei uns sichern Sie Ihr Geld.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([ARR_3(4,7,8)]);
    DIALOG_ATM_EDIT_VALUE_SHOW(false);

    DIALOG_ATM_BUTTON_4_TEXT ctrlSetStructuredText parseText "<t align='right' shadow='0' color='#176a37' font='PuristaSemibold'>Alles Einzahlen</t>";
    DIALOG_ATM_BUTTON_4 buttonSetAction QUOTE([ARR_2(QQGVAR(selectDepositCompletePage),player getVariable [ARR_2(QQEGVAR(cash,balance),0)])] call CBA_fnc_localEvent);

    DIALOG_ATM_BUTTON_7_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Anderer Betrag</t>";
    DIALOG_ATM_BUTTON_7 buttonSetAction QUOTE([QQGVAR(selectDepositMorePage)] call CBA_fnc_localEvent);

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Zurück</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectMenuPage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDepositCompletePage), {
    params ["_value"];

    [QGVAR(selectDepositLoadingPage)] call CBA_fnc_localEvent;

    TARGET_ENDPOINT_CBA_EVENT(QGVAR(depositBalance),[ARR_3(player,DIALOG_ATM_DISPLAY getVariable [ARR_2(QGVAR(bankAccountID),0)],_value)]);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDepositMorePage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Geld einzahlen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Bei uns sichern Sie Ihr Geld.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([ARR_2(4,8)]);
    DIALOG_ATM_EDIT_VALUE ctrlSetText "";
    DIALOG_ATM_EDIT_VALUE_SHOW(true);

    DIALOG_ATM_BUTTON_4_TEXT ctrlSetStructuredText parseText "<t align='right' shadow='0' color='#176a37' font='PuristaSemibold'>Einzahlen</t>";
    DIALOG_ATM_BUTTON_4 buttonSetAction QUOTE([ARR_2(QQGVAR(selectDepositCompletePage),parseNumber (ctrlText DIALOG_ATM_EDIT_VALUE))] call CBA_fnc_localEvent);

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Zurück</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectDepositPage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDepositLoadingPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Geld einzahlen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Ihr Geld wird eingezahlt. Bitte warten...</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([]);
    DIALOG_ATM_EDIT_VALUE_SHOW(false);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDepositFailedPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Geld einzahlen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Ihr Bargeld konnte nicht eingezahlt werden.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([8]);

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Zurück</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectDepositPage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDepositCompletedPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Geld einzahlen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Ihr Bargeld wurde eingezahlt.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([8]);

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Zurück</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectDepositPage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDisbursePage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Geld auszahlen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Nehmen Sie sich Ihr Geld.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([ARR_7(1,2,3,4,5,7,8)]);
    DIALOG_ATM_EDIT_VALUE_SHOW(false);

    DIALOG_ATM_BUTTON_1_TEXT ctrlSetStructuredText parseText "<t align='right' shadow='0' color='#176a37' font='PuristaSemibold'>10 $</t>";
    DIALOG_ATM_BUTTON_1 buttonSetAction QUOTE([ARR_2(QQGVAR(selectDisburseCompletePage),10)] call CBA_fnc_localEvent);

    DIALOG_ATM_BUTTON_2_TEXT ctrlSetStructuredText parseText "<t align='right' shadow='0' color='#176a37' font='PuristaSemibold'>50 $</t>";
    DIALOG_ATM_BUTTON_2 buttonSetAction QUOTE([ARR_2(QQGVAR(selectDisburseCompletePage),50)] call CBA_fnc_localEvent);

    DIALOG_ATM_BUTTON_3_TEXT ctrlSetStructuredText parseText "<t align='right' shadow='0' color='#176a37' font='PuristaSemibold'>100 $</t>";
    DIALOG_ATM_BUTTON_3 buttonSetAction QUOTE([ARR_2(QQGVAR(selectDisburseCompletePage),100)] call CBA_fnc_localEvent);

    DIALOG_ATM_BUTTON_4_TEXT ctrlSetStructuredText parseText "<t align='right' shadow='0' color='#176a37' font='PuristaSemibold'>1000 $</t>";
    DIALOG_ATM_BUTTON_4 buttonSetAction QUOTE([ARR_2(QQGVAR(selectDisburseCompletePage),1000)] call CBA_fnc_localEvent);

    DIALOG_ATM_BUTTON_5_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>5000 $</t>";
    DIALOG_ATM_BUTTON_5 buttonSetAction QUOTE([ARR_2(QQGVAR(selectDisburseCompletePage),5000)] call CBA_fnc_localEvent);

    DIALOG_ATM_BUTTON_7_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Anderer Betrag</t>";
    DIALOG_ATM_BUTTON_7 buttonSetAction QUOTE([QQGVAR(selectDisburseMorePage)] call CBA_fnc_localEvent);

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Zurück</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectMenuPage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDisburseMorePage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Geld auszahlen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Nehmen Sie sich Ihr Geld.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([ARR_2(4,8)]);
    DIALOG_ATM_EDIT_VALUE ctrlSetText "";
    DIALOG_ATM_EDIT_VALUE_SHOW(true);

    DIALOG_ATM_BUTTON_4_TEXT ctrlSetStructuredText parseText "<t align='right' shadow='0' color='#176a37' font='PuristaSemibold'>Auszahlen</t>";
    DIALOG_ATM_BUTTON_4 buttonSetAction QUOTE([ARR_2(QQGVAR(selectDisburseCompletePage),parseNumber (ctrlText DIALOG_ATM_EDIT_VALUE))] call CBA_fnc_localEvent);

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Zurück</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectDisbursePage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDisburseCompletePage), {
    params ["_value"];

    [QGVAR(selectDisburseLoadingPage)] call CBA_fnc_localEvent;

    TARGET_ENDPOINT_CBA_EVENT(QGVAR(disburseBalance),[ARR_3(player,DIALOG_ATM_DISPLAY getVariable [ARR_2(QGVAR(bankAccountID),0)],_value)]);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDisburseLoadingPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Geld auszahlen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Ihr Geld wird ausgezahlt. Bitte warten...</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([]);
    DIALOG_ATM_EDIT_VALUE_SHOW(false);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDisburseFailedPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Geld auszahlen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Ihr gewünschter Betrag konnte nicht ausgezahlt werden.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([8]);

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Zurück</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectDisbursePage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

[QGVAR(selectDisburseCompletedPage), {
    DIALOG_ATM_TITLE ctrlSetStructuredText parseText "<t shadow='0' align='left' size='1.2'>Geld auszahlen</t>";
    DIALOG_ATM_DESCRIPTION ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Ihr gewünschter Betrag wurde ausgezahlt.</t>";

    DIALOG_ATM_ACTIVE_BUTTONS([8]);

    DIALOG_ATM_BUTTON_8_TEXT ctrlSetStructuredText parseText "<t align='left' shadow='0' color='#176a37' font='PuristaSemibold'>Zurück</t>";
    DIALOG_ATM_BUTTON_8 buttonSetAction QUOTE([QQGVAR(selectDisbursePage)] call CBA_fnc_localEvent);
}] call CBA_fnc_addEventHandler;

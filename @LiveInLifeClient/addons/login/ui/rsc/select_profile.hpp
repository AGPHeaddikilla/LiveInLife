
class GVAR(select_profile) {
    idd = IDD_select_profile;
    enableSimulation = true;
    movingEnable = true;
    onLoad = QUOTE([ARR_2(QQGVAR(select_profile), _this)] spawn FUNC(onSelectProfileLoad));
    //onKeyDown = QUOTE([ARR_2(QQGVAR(select_profile), _this)] call FUNC(onKeyDown));

    class controlsBackground {
        class Title: RscText {
            idc = -1;
            text = "$STR_lilc_login_select_profile_title"; //--- ToDo: Localize;
            x = 0.381407 * safezoneW + safezoneX;
            y = 0.258 * safezoneH + safezoneY;
            w = 0.237187 * safezoneW;
            h = 0.022 * safezoneH;
            colorBackground[] = {0, 0, 0, 0.95};
        };

        class Background: RscText {
            idc = -1;
            x = 0.381406 * safezoneW + safezoneX;
            y = 0.28 * safezoneH + safezoneY;
            w = 0.237187 * safezoneW;
            h = 0.286 * safezoneH;
            colorBackground[] = {0, 0, 0, 0.8};
        };
    };

    class controls {
        class LogInButton: RscButton {
            idc = 1600;
            text = "$STR_lilc_login_select_profile_loginButton"; //--- ToDo: Localize;
            x = 0.391719 * safezoneW + safezoneX;
            y = 0.522 * safezoneH + safezoneY;
            w = 0.113437 * safezoneW;
            h = 0.033 * safezoneH;
            colorBackground[] = {0, 0, 0, 0.95};
        };

        class ProfilesTitle: RscText {
            idc = -1;
            text = "$STR_lilc_login_select_profile_profilesTitle"; //--- ToDo: Localize;
            x = 0.386562 * safezoneW + safezoneX;
            y = 0.37263 * safezoneH + safezoneY;
            w = 0.226875 * safezoneW;
            h = 0.022 * safezoneH;
        };

        class CurrentUserDescription: RscStructuredText {
            idc = 1100;
            text = "$STR_lilc_login_select_profile_currentUserDescriptionText"; //<t size=""0.7""><t size=""1"">Current User:</t><br /> SteamID64: <a valign=""middle"" underline=""true"" color=""#FF6600"" href=""http://steamcommunity.com/profiles/76561198040411592"">76561198040411592</a><br /> Username: TheMysteriousVincent<br /> Email: vincent.heins@allgameplay.de</t>
            x = 0.386562 * safezoneW + safezoneX;
            y = 0.291 * safezoneH + safezoneY;
            w = 0.221719 * safezoneW;
            h = 0.077 * safezoneH;
            colorBackground[] = {0, 0, 0, 0};
        };

        class ListProfiles: RscListbox {
            idc = 1500;
            x = 0.391719 * safezoneW + safezoneX;
            y = 0.401 * safezoneH + safezoneY;
            w = 0.113437 * safezoneW;
            h = 0.11 * safezoneH;
            onLBSelChanged = QUOTE([ARR_2(QQGVAR(select_profile), _this)] spawn FUNC(onSelectProfileLBSelChanged));
        };

        class ProfileInfo: RscStructuredText {
            idc = 1101;
            text = "$STR_lilc_login_select_profile_profileInfoText"; //<t size=""0.7""><t size=""1"">Profile Info:</t><br /> Firstname: Vincent<br /> Lastname: Eins<br /> Sex: Male<br /> Cash: $100<br /> Status: Active</t>
            x = 0.510312 * safezoneW + safezoneX;
            y = 0.401 * safezoneH + safezoneY;
            w = 0.103125 * safezoneW;
            h = 0.11 * safezoneH;
            colorBackground[] = {0, 0, 0, 0};
        };
    };
};

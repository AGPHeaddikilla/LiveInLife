
class CfgPatches {
    #include "CfgPatches.cpp"
};

class CfgFunctions {
    #include "CfgFunctions.cpp"
};

class Extended_PreInit_EventHandlers
{
    class lils_locker_preInit
    {
        serverInit = "call compile preProcessFileLineNumbers '\x\lils\addons\locker\XEH_serverPreInit.sqf';";
    };
};

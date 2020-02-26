#include <sourcemod>
#include <sdktools_sound>
public Plugin myinfo =
{
    name = "Ear-Raper",
    author = "WEEGEE",
    description = "Allow an admin to earrape players",
    version = "1.0",
    url = "https://steamcommunity.com/groups/reachhl2"
}

public void OnPluginStart()
{
    RegAdminCmd("sm_earrape", Command_Earrape, ADMFLAG_ROOT, "sm_earrape <#userid|name> <filename> <number of time the file will play at once>");
}

public Action Command_Earrape(int client, int args)
{
    if(args < 3){
        ReplyToCommand(client, "Usage: sm_earrape <#userid|name> <filename> <number of time it plays simutaneously>");
        return Plugin_Handled;
    }
    
    //Player, File, Time of the sound to be played
    char arg1[32], arg2[64], arg3[32];

    GetCmdArg(1, arg1, sizeof(arg1)); //Player
    GetCmdArg(2, arg2, sizeof(arg2)); //Sound File
    GetCmdArg(3, arg3, sizeof(arg3)); //Time the sound file will be played

    char target_name[MAX_TARGET_LENGTH];
    int target_list[MAXPLAYERS],target_count;
    bool tn_is_ml;
    if((target_count=ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_NO_BOTS,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		/* This function replies to the admin with a failure message */
		ReplyToTargetError(client,target_count);
		return Plugin_Handled;
	}
    PrecacheSound(arg2);
    for(int i = 0;i < target_count;i++)
	{
        for(int a = 0;a < StringToInt(arg3);a++)
            {
                EmitSoundToClient(target_list[i],arg2);
            }
        LogAction(client, target_list[i],"\"%L\" earraped \"%L\"",client,target_list[i]);
	}

    if(tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "Earraped %t", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "Earraped %s", target_name);
	}

    return  Plugin_Handled;
}
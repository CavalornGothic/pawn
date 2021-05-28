/**********************************
 *   	zcmd                      *
 *   @Author:      ZeeX           *
 *   @Version:     0.3.1          *
 *   @Released:    22/09/2013     *
 
 *     fastCommands  			  *
 *   @Author:      mrdrifter      *
 *   @Version:     0.4.2b         *
 *   @Released:    05/04/2014     *
 
 **********************************/
 
 
/*
	native ARG<slot>;
	native ARG_FLOAT<slot>;
	native ARG_INT<slot>;
	native ARG_COUNT<>;
	native SPLIT<slot>;
	native Command_Alt(fromCmd, toCmd);

*/
//#include sscanf2
#if defined _fastCmd_included
	#endinput
#endif	
#define _fastCmd_included

#define MAX_FUNC_NAME (42)
#define MAX_ARGPARAMETRS (9)

#define CMD:%1(%2)      \
			forward cmd_%1(%2); \
			public cmd_%1(%2)		

			
#define Command_Alt(%0,%1); \
				forward cmd_%0(fastCmd_p, fastCmd_data[]); \
				public cmd_%0(fastCmd_p, fastCmd_data[]){ return cmd_%1(fastCmd_p, fastCmd_data); }

#if !defined isnull
	#define isnull(%1) \
				((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif
 
#define ARG<%1> argData[playerid][%1]
#define ARG_FLOAT<%1> floatstr(argData[playerid][%1])
#define ARG_INT<%1> strval(argData[playerid][%1])
#define ARG_COUNT<> argCount[playerid]

stock 
	argCount[MAX_PLAYERS],   
	argData[MAX_PLAYERS][MAX_ARGPARAMETRS][96];
	
static
	bool:fastCmd_g_HasOPCS = false,
	bool:fastCmd_g_HasOPCE = false;

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	fastCmd_g_HasOPCS = funcidx("OnPlayerCommandReceived") != -1;
	fastCmd_g_HasOPCE = funcidx("OnPlayerCommandPerformed") != -1;
    return CallLocalFunction("fastCmd_OnFilterScriptInit", "");
}

#if defined _ALS_OnFilterScriptInit
    #undef OnFilterScriptInit
#else
    #define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit fastCmd_OnFilterScriptInit
forward fastCmd_OnFilterScriptInit();

#else 

public OnGameModeInit()
{
	fastCmd_g_HasOPCS = funcidx("OnPlayerCommandReceived") != -1;
	fastCmd_g_HasOPCE = funcidx("OnPlayerCommandPerformed") != -1;
	if (funcidx("fastCmd_OnGameModeInit") != -1)
	{
		return CallLocalFunction("fastCmd_OnGameModeInit", "");
	}	
	return 1;
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit fastCmd_OnGameModeInit
forward fastCmd_OnGameModeInit();

#endif  
forward OnPlayerCommandPerformed(playerid, cmdtext[], success);
forward OnPlayerCommandReceived(playerid, cmdtext[]);

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!cmdtext[0]) return 1;
    if (fastCmd_g_HasOPCS && !CallLocalFunction("OnPlayerCommandReceived", "is", playerid, cmdtext))
		return 1;
    

	static 
		iPos,
		iCmd[64],
		iParams[128];
		
	iPos = 0;
	iCmd[0] = EOS;
	iParams[0] = EOS;
	
	//sscanf(cmdtext[1], "p< >s[59]s[128]", iCmd, iParams);
	
	iPos = strfind(cmdtext[1], " ");
	
	if(iPos++>0)
	{
		strins(iParams, cmdtext[iPos+1], 0);
		strdel(cmdtext, iPos, strlen(cmdtext));
		
	}	
	

	for(new i;i<MAX_ARGPARAMETRS;i++)
		argData[playerid][i][0] = EOS;
	ARG_COUNT<> = 0;

	iCmd = "cmd_";
	strcat(iCmd, cmdtext);
	
	iPos = 3;  
	while (iCmd[iPos++] != EOS) iCmd[iPos] = tolower(iCmd[iPos+1]);
	 
	ARG_COUNT<> = K_split(iParams, argData[playerid]);
	if(isnull(iCmd)) return 0;
	if (isnull(iParams))
	{
		if (fastCmd_g_HasOPCE)
		{
			return CallLocalFunction("OnPlayerCommandPerformed", "isi", playerid, cmdtext, CallLocalFunction(iCmd, "is", playerid, "\1"));
		}
		return CallLocalFunction(iCmd, "is", playerid, "\1");	
	}
	
	if (fastCmd_g_HasOPCE)
	{
		return CallLocalFunction("OnPlayerCommandPerformed", "isi", playerid, cmdtext, CallLocalFunction(iCmd, "is", playerid, iParams));
	}
	return CallLocalFunction(iCmd, "is", playerid, iParams);
}

//Author unknown modyfiket mrdrifter
stock K_split(const strsrc[], strdest[][])
{
    new i=1, li, srcLen = strlen(strsrc), aNum, len;
    while(i <= srcLen)
    {
		if(aNum>=MAX_ARGPARAMETRS) break;
        if(strsrc[i] == ' ' || i == srcLen)
        {
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
        }
        i++;
    }
    return aNum;
}

#if defined _ALS_OnPlayerCommandText
    #undef OnPlayerCommandText
#else
    #define _ALS_OnPlayerCommandText
#endif
#define OnPlayerCommandText fastCmd_OnPlayerCommandText
forward fastCmd_OnPlayerCommandText(playerid, cmdtext[]);


 
 

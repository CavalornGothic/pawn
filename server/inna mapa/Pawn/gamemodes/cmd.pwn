
	//==================================================[ADMINISTRATOR COMMANDS]=================================================
	if(strcmp(cmd, "/gmx", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
				GameModeRestart();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[Error:] Nie jesteœ administratorem!");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/asetleader", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /asetleader [playerid/PartOfName] [FactionID]");
				return 1;
			}
			new para1;
			new level;
			para1 = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			level = strval(tmp);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /asetleader [playerid/PartOfName] [FactionID]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
			    if(IsPlayerConnected(para1))
			    {
			        if(para1 != INVALID_PLAYER_ID)
			        {
						PlayerInfo[para1][pFaction] = level;
						PlayerInfo[para1][pRank] = 1;
						SetPlayerSpawn(para1);

						format(string, sizeof(string), "[INFO:] %s dosta³ przywódctwo frakcji ID: %d (%s).", GetPlayerNameEx(para1),level,DynamicFactions[level][fName]);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);

						format(string, sizeof(string), "[INFO:] Dosta³eœ lidera %s dziêki %s.", DynamicFactions[level][fName],GetPlayerNameEx(playerid));
						SendClientMessage(para1, COLOR_LIGHTBLUE, string);

						if(DynamicFactions[level][fUseSkins] == 1)
						{
							SetPlayerSkin(para1,DynamicFactions[level][fSkin1]);
						}
					}
				}//not connected
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem lub masz za niski poziom.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/ogloszenie", true) == 0 || strcmp(cmd, "/ogl", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(gPlayerLogged[playerid] == 0)
	        {
	            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ zalogowany");
	            return 1;
	        }
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
   			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] (/ogl)oszenie <treœæ>");
				return 1;
			}
   	    	for(new i = 0; i < sizeof(Businesses); i++)
			{
				if (PlayerToPoint(1.0, playerid,Businesses[i][EnterX], Businesses[i][EnterY], Businesses[i][EnterZ]) || PlayerToPoint(25.0, playerid,Businesses[i][ExitX], Businesses[i][ExitY], Businesses[i][ExitZ]))
				{
					if(GetPlayerVirtualWorld(playerid) == i)
					{
			    		if(Businesses[i][BizType] == 5)
			    		{
				        	if(Businesses[i][Products] != 0)
				        	{
								if ((!adds) && (PlayerInfo[playerid][pAdmin] < 1))
								{
									format(string, sizeof(string), "[Error:] Najpierw odczekaj %d sekund.",  (addtimer/1000));
									SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
									return 1;

								}
								new payout = idx * 25;
								if(GetPlayerCash(playerid) < payout)
						        {
						            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle pieniêdzy.");
						            return 1;
						        }
						        GivePlayerCash(playerid, - payout);
								Businesses[i][Till] += payout;
								Businesses[i][Products] --;
								format(string, sizeof(string), "---------------------------------[Og³oszenie (%s)]---------------------------------",  Businesses[i][BusinessName]);
								SendClientMessageToAll(COLOR_LIGHTGREEN,string);
								format(string, sizeof(string), "[OGL:] %s",  result);
								SendClientMessageToAll(COLOR_WHITE,string);
								format(string, sizeof(string), "[OGL:]Nadawca: %s - Telefon: %d.",  GetPlayerNameEx(playerid),PlayerInfo[playerid][pPhoneNumber],Businesses[i][BusinessName]);
								SendClientMessageToAll(COLOR_WHITE,string);
								SendClientMessageToAll(COLOR_LIGHTGREEN,"-----------------------------------------------------------------------------------------------------------------------");
						        if (PlayerInfo[playerid][pAdmin] < 1){SetTimer("AddsOn", addtimer, 0);adds = 0;}
						        format(string, sizeof(string), "[INFO:] Liter: %d - Koszt: $%d - Nadane dziêki %s", idx,payout,Businesses[i][BusinessName]);
								SendClientMessage(playerid,COLOR_WHITE,string);
								PlayerActionMessage(playerid,15.0,"nadaje og³oszenie w mediach.");
								SaveBusinesses();
								return 1;
							}
							else
							{
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[Error:] Nie ma produktów.");
							}
						}
						else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[Error:] Ten biznes to nie og³oszenia.");
						}
					}
	   			}
	   			else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[Error:] Nie jesteœ w biznesie.");
				}
			}
		}
		return 1;
	}
	//====================================================[DYNAMIC BUSINESS SYSTEM]==============================================
	if(strcmp(cmd, "/agotobusiness", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /agotobusiness [id]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				SetPlayerPos(playerid,Businesses[id][EnterX],Businesses[id][EnterY],Businesses[id][EnterZ]);
				SetPlayerInterior(playerid,Businesses[id][EnterInterior]);
				SetPlayerVirtualWorld(playerid,Businesses[id][EnterWorld]);
				new form[128];
				format(form, sizeof(form), "[INFO:] Teleportowa³eœ siê do biznesu ID: %d.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
   	if(strcmp(cmd, "/abusinessproducts", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abusinessproducts [businessid] [amount]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abusinessproducts [businessid] [amount]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					Businesses[id][Products] = id2;
					new form[128];
					format(form, sizeof form, "Da³eœ biznesowi ID: %d nastêpuj¹c¹ ilosæ produktów %d.", id,id2);
					SendClientMessage(playerid, COLOR_ADMINCMD,form);
					SaveBusinesses();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
  	if(strcmp(cmd, "/abusinessprice", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abusinessprice [businessid] [price]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abusinessprice [businessid] [price]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					Businesses[id][BizPrice] = id2;
					new form[128];
					format(form, sizeof form, "Biznes ID: %d kosztuje teraz %d $.", id,id2);
					SendClientMessage(playerid, COLOR_ADMINCMD,form);
					SaveBusinesses();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
   	if(strcmp(cmd, "/abusinesstype", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"[BUSINESS TYPES:]");
			    SendClientMessage(playerid, COLOR_ADMINCMD,BUSINESS_TYPES);
				SendClientMessage(playerid, COLOR_ADMINCMD,BUSINESS_TYPES2);
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abusinesstype [businessid] [type]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
					new id;
					new form[128];
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"[BUSINESS TYPES:]");
						SendClientMessage(playerid, COLOR_ADMINCMD,BUSINESS_TYPES);
						SendClientMessage(playerid, COLOR_ADMINCMD,BUSINESS_TYPES2);
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abusinesstype [businessid] [type]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					Businesses[id][BizType] = id2;
					format(form, sizeof form, "Biznes ID: %d jest ma teraz typ nr %d.", id,id2);
					SendClientMessage(playerid, COLOR_ADMINCMD,form);
					SaveBusinesses();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/abusinessentrance", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abusinessentrance [bizid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
			    new pmodel;
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid, x, y, z);
				Businesses[id][EnterX] = x;
				Businesses[id][EnterY] = y;
				Businesses[id][EnterZ] = z;
				Businesses[id][EnterWorld] = GetPlayerVirtualWorld(playerid);
				Businesses[id][EnterInterior] = GetPlayerInterior(playerid);
  				new Float:angle;
				GetPlayerFacingAngle(playerid, angle);
				Businesses[id][EnterAngle] = angle;
				switch(Businesses[id][Owned])
				{
				    case 0: pmodel = 1272;
				    case 1: pmodel = 1239;
				}
				ChangeStreamPickupModel(Businesses[id][PickupID],pmodel);
    			MoveStreamPickup(Businesses[id][PickupID],Businesses[id][EnterX], Businesses[id][EnterY], Businesses[id][EnterZ]);

				SaveBusinesses();
				new form[128];
				format(form, sizeof(form), "[INFO:] Przenios³eœ biznes ID: %d.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/abusinessexit", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abusinessexit [bizid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid, x, y, z);
				Businesses[id][ExitX] = x;
				Businesses[id][ExitY] = y;
				Businesses[id][ExitZ] = z;
				Businesses[id][ExitInterior] = GetPlayerInterior(playerid);
  				new Float:angle;
				GetPlayerFacingAngle(playerid, angle);
				Businesses[id][ExitAngle] = angle;
				SaveBusinesses();
				new form[128];
				format(form, sizeof(form), "[INFO:] Biznes ID: %d ma now¹ lokacje wyjœcia.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	//===================================================[DYNAMIC HOUSES SYSTEM]=================================================
 	if(strcmp(cmd, "/agotohouse", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /agotohouse [id]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				SetPlayerPos(playerid,Houses[id][EnterX],Houses[id][EnterY],Houses[id][EnterZ]);
				SetPlayerInterior(playerid,Houses[id][EnterInterior]);
				SetPlayerVirtualWorld(playerid,Houses[id][EnterWorld]);
				new form[128];
				format(form, sizeof(form), "[INFO:] Teleportowa³eœ siê do domu ID: %d.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/ahouseint", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ahouseint [houseid] [id (1-42)]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ahouseint [houseid] [id (1-42)]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);
					if(id2 < 1 || id2 > 42) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Interior ID's 1-42."); return 1; }

					if(id2 == 1)
					{
						Houses[id][ExitX] = 235.508994;
						Houses[id][ExitY] = 1189.169897;
						Houses[id][ExitZ] = 1080.339966;
						Houses[id][ExitInterior] = 3;
						format(string, sizeof string, "House ID: %d - Description: Large/2 story/3 bedrooms/clone of House 9.", id,id2);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 2)
					{
						Houses[id][ExitX] = 225.756989;
						Houses[id][ExitY] = 1240.000000;
						Houses[id][ExitZ] = 1082.149902;
						Houses[id][ExitInterior] = 2;
						format(string, sizeof string, "House ID: %d - Description: Medium/1 story/1 bedroom.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
					else if(id2 == 3)
					{
						Houses[id][ExitX] = 223.043991;
						Houses[id][ExitY] = 1289.259888;
						Houses[id][ExitZ] = 1082.199951;
						Houses[id][ExitInterior] = 1;
						format(string, sizeof string, "House ID: %d - Description: Small/1 story/1 bedroom.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 4)
					{
						Houses[id][ExitX] = 225.630997; Houses[id][ExitY] = 1022.479980; Houses[id][ExitZ] = 1084.069946;
						Houses[id][ExitInterior] = 7;
						format(string, sizeof string, "House ID: %d - Description: VERY Large/2 story/4 bedrooms.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 5)
					{
						Houses[id][ExitX] = 295.138977; Houses[id][ExitY] = 1474.469971; Houses[id][ExitZ] = 1080.519897;
						Houses[id][ExitInterior] = 15;
						format(string, sizeof string, "House ID: %d - Description: Small/1 story/2 bedrooms.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 6)
					{
						Houses[id][ExitX] = 328.493988; Houses[id][ExitY] = 1480.589966; Houses[id][ExitZ] = 1084.449951;
						Houses[id][ExitInterior] = 15;
						format(string, sizeof string, "House ID: %d - Description: Small/1 story/2 bedrooms.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 7)
					{
						Houses[id][ExitX] = 385.803986; Houses[id][ExitY] = 1471.769897; Houses[id][ExitZ] = 1080.209961;
						Houses[id][ExitInterior] = 15;
						format(string, sizeof string, "House ID: %d - Description: Small/1 story/1 bedroom/NO BATHROOM.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 8)
					{
						Houses[id][ExitX] = 375.971985; Houses[id][ExitY] = 1417.269897; Houses[id][ExitZ] = 1081.409912;
						Houses[id][ExitInterior] = 15;
						format(string, sizeof string, "House ID: %d - Description: Small/1 story/1 bedroom.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 9)
					{
						Houses[id][ExitX] = 490.810974; Houses[id][ExitY] = 1401.489990; Houses[id][ExitZ] = 1080.339966;
						Houses[id][ExitInterior] = 2;
						format(string, sizeof string, "House ID: %d - Description: Large/2 story/3 bedrooms.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     			 	else if(id2 == 10)
					{
						Houses[id][ExitX] = 447.734985; Houses[id][ExitY] = 1400.439941; Houses[id][ExitZ] = 1084.339966;
						Houses[id][ExitInterior] = 2;
						format(string, sizeof string, "House ID: %d - Description: Medium/1 story/2 bedrooms.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 11)
					{
						Houses[id][ExitX] = 227.722992; Houses[id][ExitY] = 1114.389893; Houses[id][ExitZ] = 1081.189941;
						Houses[id][ExitInterior] = 5;
						format(string, sizeof string, "House ID: %d - Description: Large/2 story/4 bedrooms.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 12)
					{
						Houses[id][ExitX] = 260.983978; Houses[id][ExitY] = 1286.549927; Houses[id][ExitZ] = 1080.299927;
						Houses[id][ExitInterior] = 4;
						format(string, sizeof string, "House ID: %d - Description: Small/1 story/1 bedroom.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 13)
					{
						Houses[id][ExitX] = 221.666992; Houses[id][ExitY] = 1143.389893; Houses[id][ExitZ] = 1082.679932;
						Houses[id][ExitInterior] = 4;
						format(string, sizeof string, "House ID: %d - Description: Small/1 story/1 bedroom/NO BATHROOM!", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 14)
					{
						Houses[id][ExitX] = 27.132700; Houses[id][ExitY] = 1341.149902; Houses[id][ExitZ] = 1084.449951;
						Houses[id][ExitInterior] = 10;
						format(string, sizeof string, "House ID: %d - Description: Medium/2 story/1 bedroom.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 15)
					{
						Houses[id][ExitX] = -262.601990; Houses[id][ExitY] = 1456.619995; Houses[id][ExitZ] = 1084.449951;
						Houses[id][ExitInterior] = 4;
						format(string, sizeof string, "House ID: %d - Description: Large/2 story/1 bedroom/NO BATHROOM!", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 16)
					{
						Houses[id][ExitX] = 22.778299; Houses[id][ExitY] = 1404.959961; Houses[id][ExitZ] = 1084.449951;
						Houses[id][ExitInterior] = 5;
						format(string, sizeof string, "House ID: %d - Description: Medium/1 story/2 bedrooms/NO BATHROOM or DOORS!", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 17)
					{
						Houses[id][ExitX] = 140.278000; Houses[id][ExitY] = 1368.979980; Houses[id][ExitZ] = 1083.969971;
						Houses[id][ExitInterior] = 5;
						format(string, sizeof string, "House ID: %d - Description: Large/2 story/4 bedrooms/NO BATHROOM!", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 18)
					{
						Houses[id][ExitX] = 234.045990; Houses[id][ExitY] = 1064.879883; Houses[id][ExitZ] = 1084.309937;
						Houses[id][ExitInterior] = 6;
						format(string, sizeof string, "House ID: %d - Description: Large/2 story/3 bedrooms.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 19)
					{
						Houses[id][ExitX] = -68.294098; Houses[id][ExitY] = 1353.469971; Houses[id][ExitZ] = 1080.279907;
						Houses[id][ExitInterior] = 6;
						format(string, sizeof string, "House ID: %d - Description: Small/1 story/NO BEDROOM!", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 20)
					{
						Houses[id][ExitX] = -285.548981; Houses[id][ExitY] = 1470.979980; Houses[id][ExitZ] = 1084.449951;
						Houses[id][ExitInterior] = 15;
						format(string, sizeof string, "House ID: %d - Description: 1 bedroom/living room/kitchen/NO BATHROOM", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 21)
					{
						Houses[id][ExitX] = -42.581997; Houses[id][ExitY] = 1408.109985; Houses[id][ExitZ] = 1084.449951;
						Houses[id][ExitInterior] = 8;
						format(string, sizeof string, "House ID: %d - Description: Small/1 story/NO BEDROOM!", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 22)
					{
						Houses[id][ExitX] = 83.345093; Houses[id][ExitY] = 1324.439941; Houses[id][ExitZ] = 1083.889893;
						Houses[id][ExitInterior] = 9;
						format(string, sizeof string, "House ID: %d - Description: Medium/2 story/2 bedrooms", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 23)
					{
						Houses[id][ExitX] = 260.941986; Houses[id][ExitY] = 1238.509888; Houses[id][ExitZ] = 1084.259888;
						Houses[id][ExitInterior] = 9;
						format(string, sizeof string, "House ID: %d - Description: Small/1 story/1 bedroom", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 24)
					{
						Houses[id][ExitX] = 244.411987; Houses[id][ExitY] = 305.032990; Houses[id][ExitZ] = 999.231995;
						Houses[id][ExitInterior] = 1;
						format(string, sizeof string, "House ID: %d - Description: Denise's Bedroom", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 25)
					{
						Houses[id][ExitX] = 271.884979; Houses[id][ExitY] = 306.631989; Houses[id][ExitZ] = 999.325989;
						Houses[id][ExitInterior] = 2;
						format(string, sizeof string, "House ID: %d - Description: Katie's Bedroom", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
      		 		else if(id2 == 26)
					{
						Houses[id][ExitX] = 291.282990; Houses[id][ExitY] = 310.031982; Houses[id][ExitZ] = 999.154968;
						Houses[id][ExitInterior] = 3;
						format(string, sizeof string, "House ID: %d - Description: Helena's Bedroom (barn) - limited movement.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 27)
					{
						Houses[id][ExitX] = 302.181000; Houses[id][ExitY] = 300.722992; Houses[id][ExitZ] = 999.231995;
						Houses[id][ExitInterior] = 4;
						format(string, sizeof string, "House ID: %d - Description: Michelle's Bedroom.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 28)
					{
						Houses[id][ExitX] = 322.197998; Houses[id][ExitY] = 302.497986; Houses[id][ExitZ] = 999.231995;
						Houses[id][ExitInterior] = 5;
						format(string, sizeof string, "House ID: %d - Description: Barbara's Bedroom.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 29)
					{
						Houses[id][ExitX] = 346.870025; Houses[id][ExitY] = 309.259033; Houses[id][ExitZ] = 999.155700;
						Houses[id][ExitInterior] = 6;
						format(string, sizeof string, "House ID: %d - Description: Millie's Bedroom.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 30)
					{
						Houses[id][ExitX] = 2496.049805; Houses[id][ExitY] = -1693.929932; Houses[id][ExitZ] = 1014.750000;
						Houses[id][ExitInterior] = 3;
						format(string, sizeof string, "House ID: %d - Description: CJ's Mom's House.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 31)
					{
						Houses[id][ExitX] = 1263.079956; Houses[id][ExitY] = -785.308960; Houses[id][ExitZ] = 1091.959961;
						Houses[id][ExitInterior] = 5;
						format(string, sizeof string, "House ID: %d - Description: Madd Dogg's Mansion (West door).", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 32)
					{
						Houses[id][ExitX] = 2464.109863; Houses[id][ExitY] = -1698.659912; Houses[id][ExitZ] = 1013.509949;
						Houses[id][ExitInterior] = 2;
						format(string, sizeof string, "House ID: %d - Description: Ryder's house.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 33)
					{
						Houses[id][ExitX] = 2526.459961; Houses[id][ExitY] = -1679.089966; Houses[id][ExitZ] = 1015.500000;
						Houses[id][ExitInterior] = 1;
						format(string, sizeof string, "House ID: %d - Description: Sweet's House (South side of house is fucked).", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 34)
					{
						Houses[id][ExitX] = 2543.659912; Houses[id][ExitY] = -1303.629883; Houses[id][ExitZ] = 1025.069946;
						Houses[id][ExitInterior] = 2;
						format(string, sizeof string, "House ID: %d - Description: Big Smoke's Crack Factory (Ground Floor).", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 35)
					{
						Houses[id][ExitX] = 744.542969; Houses[id][ExitY] = 1437.669922; Houses[id][ExitZ] = 1102.739990;
						Houses[id][ExitInterior] = 6;
						format(string, sizeof string, "House ID: %d - Description: Fanny Batter's Whore House.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 36)
					{
						Houses[id][ExitX] = 964.106995; Houses[id][ExitY] = -53.205498; Houses[id][ExitZ] = 1001.179993;
						Houses[id][ExitInterior] = 3;
						format(string, sizeof string, "House ID: %d - Description: Tiger Skin Rug Brothel.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 37)
					{
						Houses[id][ExitX] = 2350.339844; Houses[id][ExitY] = -1181.649902; Houses[id][ExitZ] = 1028.000000;
						Houses[id][ExitInterior] = 5;
						format(string, sizeof string, "House ID: %d - Description: Burning Desire Gang House.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 38)
					{
						Houses[id][ExitX] = 2807.619873; Houses[id][ExitY] = -1171.899902; Houses[id][ExitZ] = 1025.579956;
						Houses[id][ExitInterior] = 8;
						format(string, sizeof string, "House ID: %d - Description: Colonel Furhberger's House.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 39)
					{
						Houses[id][ExitX] = 318.564972; Houses[id][ExitY] = 1118.209961; Houses[id][ExitZ] = 1083.979980;
						Houses[id][ExitInterior] = 5;
						format(string, sizeof string, "House ID: %d - Description: Crack Den.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 40)
					{
						Houses[id][ExitX] = 2324.419922; Houses[id][ExitY] = -1147.539917; Houses[id][ExitZ] = 1050.719971;
						Houses[id][ExitInterior] = 12;
						format(string, sizeof string, "House ID: %d - Description: Unused Safe House.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 41)
					{
						Houses[id][ExitX] = 446.622986; Houses[id][ExitY] = 509.318970; Houses[id][ExitZ] = 1001.419983;
						Houses[id][ExitInterior] = 12;
						format(string, sizeof string, "House ID: %d - Description: Budget Inn Motel Room.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 42)
					{
						Houses[id][ExitX] = 2216.339844; Houses[id][ExitY] = -1150.509888; Houses[id][ExitZ] = 1025.799927;
						Houses[id][ExitInterior] = 15;
						format(string, sizeof string, "House ID: %d - Description: Jefferson Motel. (REALLY EXPENSIVE)", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
					SaveHouses();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
  	if(strcmp(cmd, "/abuildingint", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_WHITE, "[USAGE:] /abuildingint [buildingid] [id (1-17)]");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 1: Sherman Dam - 2: Planning Department - 3: Ganton Gym - 4: Cobra Gym - 5: Below The Belt Gym");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 6: RC Battlefield - 7-9: Police Departments - 10-12: Schools - 13: 8 Track Stadium");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 14: Bloodbowl Stadium - 15: Dirtbike Stadium - 16: Kickstart Stadium - 17: Vice Stadium");
				return 1;
			}
   			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_WHITE, "[USAGE:] /abuildingint [buildingid] [id (1-33)]");
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 1: Sherman Dam - 2: Planning Department - 3: Ganton Gym - 4: Cobra Gym - 5: Below The Belt Gym");
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 6: RC Battlefield - 7-9: Police Departments - 10-12: Schools - 13: 8 Track Stadium");
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 14: Bloodbowl Stadium - 15: Dirtbike Stadium - 16: Kickstart Stadium - 17: Vice Stadium");
						return 1;
					}
					new id2;
					id2 = strval(tmp);
					if(id2 < 1 || id2 > 17) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Interior ID's 1-17."); return 1; }

					if(id2 == 1)
					{
						Building[id][ExitX] = -959.873962;
						Building[id][ExitY] = 1952.000000;
						Building[id][ExitZ] = 9.044310;
						Building[id][ExitInterior] = 17;
						format(string, sizeof string, "Building ID: %d - Description: Sherman Dam.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 2)
					{
						Building[id][ExitX] = 388.871979;
						Building[id][ExitY] = 173.804993;
						Building[id][ExitZ] = 1008.389954;
						Building[id][ExitInterior] = 3;
						format(string, sizeof string, "Building ID: %d - Description: Planning Department.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 3)
					{
						Building[id][ExitX] = 772.112000;
						Building[id][ExitY] = -3.898650;
						Building[id][ExitZ] = 1000.687988;
						Building[id][ExitInterior] = 5;
						format(string, sizeof string, "Building ID: %d - Description: Ganton Gym.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 4)
					{
						Building[id][ExitX] = 774.213989;
						Building[id][ExitY] = -48.924297;
						Building[id][ExitZ] = 1000.687988;
						Building[id][ExitInterior] = 6;
						format(string, sizeof string, "Building ID: %d - Description: Cobra Gym.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 5)
					{
						Building[id][ExitX] = 773.579956;
						Building[id][ExitY] = -77.096695;
						Building[id][ExitZ] = 1000.687988;
						Building[id][ExitInterior] = 7;
						format(string, sizeof string, "Building ID: %d - Description: Below The Belt Gym.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 6)
					{
						Building[id][ExitX] = -972.4957;
						Building[id][ExitY] = 1060.983;
						Building[id][ExitZ] = 1345.669;
						Building[id][ExitInterior] = 10;
						format(string, sizeof string, "Building ID: %d - Description: RC Battlefield.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 7)
					{
						Building[id][ExitX] = 246.783997;
						Building[id][ExitY] = 63.900200;
						Building[id][ExitZ] = 1003.639954;
						Building[id][ExitInterior] = 6;
						format(string, sizeof string, "Building ID: %d - Description: LSPD.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 8)
					{
						Building[id][ExitX] = 246.375992;
						Building[id][ExitY] = 109.245995;
						Building[id][ExitZ] = 1003.279968;
						Building[id][ExitInterior] = 10;
						format(string, sizeof string, "Building ID: %d - Description: SFPD.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 9)
					{
						Building[id][ExitX] = 238.661987;
						Building[id][ExitY] = 141.051987;
						Building[id][ExitZ] = 1003.049988;
						Building[id][ExitInterior] = 3;
						format(string, sizeof string, "Building ID: %d - Description: LVPD.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 10)
					{
						Building[id][ExitX] = 1494.429932;
						Building[id][ExitY] = 1305.629883;
						Building[id][ExitZ] = 1093.289917;
						Building[id][ExitInterior] = 3;
						format(string, sizeof string, "Building ID: %d - Description: Bike School.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 11)
					{
						Building[id][ExitX] = -2029.719971;
						Building[id][ExitY] = -115.067993;
						Building[id][ExitZ] = 1035.169922;
						Building[id][ExitInterior] = 3;
						format(string, sizeof string, "Building ID: %d - Description: Driving School.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 12)
					{
						Building[id][ExitX] = 420.484985;
						Building[id][ExitY] = 2535.589844;
						Building[id][ExitZ] = 10.020289;
						Building[id][ExitInterior] = 10;
						format(string, sizeof string, "Building ID: %d - Description: School (None).", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 13)
					{
						Building[id][ExitX] = -1397.782470;
						Building[id][ExitY] = -203.723114;
						Building[id][ExitZ] = 1051.346801;
						Building[id][ExitInterior] = 7;
						format(string, sizeof string, "Building ID: %d - Description: 8 Track Stadium.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 14)
					{
						Building[id][ExitX] = -1398.103515;
						Building[id][ExitY] = 933.445434;
						Building[id][ExitZ] = 1041.531250;
						Building[id][ExitInterior] = 15;
						format(string, sizeof string, "Building ID: %d - Description: Bloodbowl Stadium.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 15)
					{
						Building[id][ExitX] = -1428.809448;
						Building[id][ExitY] = -663.595886;
						Building[id][ExitZ] = 1060.219848;
						Building[id][ExitInterior] = 4;
						format(string, sizeof string, "Building ID: %d - Description: Dirtbike Stadium.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 16)
					{
						Building[id][ExitX] = -1486.861816;
						Building[id][ExitY] = 1642.145996;
						Building[id][ExitZ] = 1060.671875;
						Building[id][ExitInterior] = 14;
						format(string, sizeof string, "Building ID: %d - Description: Kickstart Stadium.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 17)
					{
						Building[id][ExitX] = -1401.830000;
						Building[id][ExitY] = 107.051300;
						Building[id][ExitZ] = 1032.273000;
						Building[id][ExitInterior] = 1;
						format(string, sizeof string, "Building ID: %d - Description: Vice Stadium (Only center is solid).", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
					SaveBuildings();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/abusinessint", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_WHITE, "[USAGE:] /abusinessint [bizid] [id (1-33)]");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 1: Marcos Bistro (Eat) - 2: Big Spread Ranch (Bar) - 3: Burger Shot (Eat) - 4: Cluckin Bell (EAT)");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 5: Well Stacked Pizza (Eat) - 6: Rusty Browns Dohnuts (Eat) - 7: Jays Diner (Eat) - 8: Pump Truck Stop Diner (Eat)");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 9: Alhambra (Drink) - 10: Mistys (Drink) - 11: Lil' Probe Inn (Drink) - 12: Exclusive (Clothes) - 13: Binco (Clothes)");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 14: ProLaps (Clothes) - 15: SubUrban (Clothes) - 16: Victim (Clothes) - 17: Zip (Clothes) - 18: Redsands Casino");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 19: Off Track Betting - 20: Sex Shop - 21: Zeros RC Shop - 22-25: Ammunations (Gun) - 26: Ammu Shooting Range (DONT USE)");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 27: Jizzys (Drink) - 27-33: 24-7's (Buy)");
				return 1;
			}
   			if (PlayerInfo[playerid][pAdmin] >= 7)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_WHITE, "[USAGE:] /abusinessint [bizid] [id (1-33)]");
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 1: Marcos Bistro (Eat) - 2: Big Spread Ranch (Bar) - 3: Burger Shot (Eat) - 4: Cluckin Bell (EAT)");
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 5: Well Stacked Pizza (Eat) - 6: Rusty Browns Dohnuts (Eat) - 7: Jays Diner (Eat) - 8: Pump Truck Stop Diner (Eat)");
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 9: Alhambra (Drink) - 10: Mistys (Drink) - 11: Lil' Probe Inn (Drink) - 12: Exclusive (Clothes) - 13: Binco (Clothes)");
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 14: ProLaps (Clothes) - 15: SubUrban (Clothes) - 16: Victim (Clothes) - 17: Zip (Clothes) - 18: Redsands Casino");
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 19: Off Track Betting - 20: Sex Shop - 21: Zeros RC Shop - 22-25: Ammunations (Gun) - 26: Ammu Shooting Range (DONT USE)");
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INTS:] 27: Jizzys (Drink) - 27-33: 24-7's (Buy)");
						return 1;
					}
					new id2;
					id2 = strval(tmp);
					if(id2 < 1 || id2 > 33) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Interior ID's 1-33."); return 1; }

					if(id2 == 1)
					{
						Businesses[id][ExitX] = 794.8064;
						Businesses[id][ExitY] = 491.6866;
						Businesses[id][ExitZ] = 1376.195;
						Businesses[id][ExitInterior] = 1;
						format(string, sizeof string, "Business ID: %d - Description: Marcos Bistro.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
					else if(id2 == 2)
					{
						Businesses[id][ExitX] = 1212.019897;
						Businesses[id][ExitY] = -28.663099;
						Businesses[id][ExitZ] = 1001.089966;
						Businesses[id][ExitInterior] = 3;
						format(string, sizeof string, "Business ID: %d - Description: Big Spread Ranch Strip Club.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 3)
					{
						Businesses[id][ExitX] = 366.923980;
						Businesses[id][ExitY] = -72.929359;
						Businesses[id][ExitZ] = 1001.507812;
						Businesses[id][ExitInterior] = 10;
						format(string, sizeof string, "Business ID: %d - Description: Burger Shot.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 4)
					{
						Businesses[id][ExitX] = 365.672974;
						Businesses[id][ExitY] = -10.713200;
						Businesses[id][ExitZ] = 1001.869995;
						Businesses[id][ExitInterior] = 9;
						format(string, sizeof string, "Business ID: %d - Description: Cluckin Bell.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 5)
					{
						Businesses[id][ExitX] = 372.351990;
						Businesses[id][ExitY] = -131.650986;
						Businesses[id][ExitZ] = 1001.449951;
						Businesses[id][ExitInterior] = 5;
						format(string, sizeof string, "Business ID: %d - Description: Well Stacked Pizza.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 6)
					{
						Businesses[id][ExitX] = 377.098999;
						Businesses[id][ExitY] = -192.439987;
						Businesses[id][ExitZ] = 1000.643982;
						Businesses[id][ExitInterior] = 17;
						format(string, sizeof string, "Business ID: %d - Description: Rusty Brown Dohnuts.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 7)
					{
						Businesses[id][ExitX] = 460.099976;
						Businesses[id][ExitY] = -88.428497;
						Businesses[id][ExitZ] = 999.621948;
						Businesses[id][ExitInterior] = 4;
						format(string, sizeof string, "Business ID: %d - Description: Jays Diner.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 8)
					{
						Businesses[id][ExitX] = 681.474976;
						Businesses[id][ExitY] = -451.150970;
						Businesses[id][ExitZ] = -25.616798;
						Businesses[id][ExitInterior] = 1;
						format(string, sizeof string, "Business ID: %d - Description: Pump Truck Stop Diner.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 9)
					{
						Businesses[id][ExitX] = 476.068328;
						Businesses[id][ExitY] = -14.893922;
						Businesses[id][ExitZ] = 1003.695312;
						Businesses[id][ExitInterior] = 17;
						format(string, sizeof string, "Business ID: %d - Description: Alhambra.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 10)
					{
						Businesses[id][ExitX] = 501.980988;
						Businesses[id][ExitY] = -69.150200;
						Businesses[id][ExitZ] = 998.834961;
						Businesses[id][ExitInterior] = 11;
						format(string, sizeof string, "Business ID: %d - Description: Mistys.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 11)
					{
						Businesses[id][ExitX] = -227.028000;
						Businesses[id][ExitY] = 1401.229980;
						Businesses[id][ExitZ] = 27.769798;
						Businesses[id][ExitInterior] = 18;
						format(string, sizeof string, "Business ID: %d - Description: Lil' Probe Inn.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 12)
					{
						Businesses[id][ExitX] = 204.332993;
						Businesses[id][ExitY] = -166.694992;
						Businesses[id][ExitZ] = 1000.578979;
						Businesses[id][ExitInterior] = 14;
						format(string, sizeof string, "Business ID: %d - Description: EXcLusive.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 13)
					{
						Businesses[id][ExitX] = 207.737991;
						Businesses[id][ExitY] = -109.019997;
						Businesses[id][ExitZ] = 1005.269958;
						Businesses[id][ExitInterior] = 15;
						format(string, sizeof string, "Business ID: %d - Description: Binco.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 14)
					{
						Businesses[id][ExitX] = 207.054993;
						Businesses[id][ExitY] = -138.804993;
						Businesses[id][ExitZ] = 1003.519958;
						Businesses[id][ExitInterior] = 3;
						format(string, sizeof string, "Business ID: %d - Description: ProLaps.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 15)
					{
						Businesses[id][ExitX] = 203.778000;
						Businesses[id][ExitY] = -48.492397;
						Businesses[id][ExitZ] = 1001.799988;
						Businesses[id][ExitInterior] = 1;
						format(string, sizeof string, "Business ID: %d - Description: SubUrban.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 16)
					{
						Businesses[id][ExitX] = 226.293991;
						Businesses[id][ExitY] = -7.431530;
						Businesses[id][ExitZ] = 1002.259949;
						Businesses[id][ExitInterior] = 5;
						format(string, sizeof string, "Business ID: %d - Description: Victim.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 17)
					{
						Businesses[id][ExitX] = 161.391006;
						Businesses[id][ExitY] = -93.159156;
						Businesses[id][ExitZ] = 1001.804687;
						Businesses[id][ExitInterior] = 18;
						format(string, sizeof string, "Business ID: %d - Description: Zip.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 18)
					{
						Businesses[id][ExitX] = 1133.069946;
						Businesses[id][ExitY] = -9.573059;
						Businesses[id][ExitZ] = 1000.750000;
						Businesses[id][ExitInterior] = 12;
						format(string, sizeof string, "Business ID: %d - Description: Small Casino in Redsands West.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 19)
					{
						Businesses[id][ExitX] = 833.818970;
						Businesses[id][ExitY] = 7.418000;
						Businesses[id][ExitZ] = 1004.179993;
						Businesses[id][ExitInterior] = 3;
						format(string, sizeof string, "Business ID: %d - Description: Off Track Betting.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 20)
					{
						Businesses[id][ExitX] = -100.325996;
						Businesses[id][ExitY] = -22.816500;
						Businesses[id][ExitZ] = 1000.741943;
						Businesses[id][ExitInterior] = 3;
						format(string, sizeof string, "Business ID: %d - Description: Sex Shop.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 21)
					{
						Businesses[id][ExitX] = -2239.569824;
						Businesses[id][ExitY] = 130.020996;
						Businesses[id][ExitZ] = 1035.419922;
						Businesses[id][ExitInterior] = 6;
						format(string, sizeof string, "Business ID: %d - Description: Zero's RC Shop.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 22)
					{
						Businesses[id][ExitX] = 286.148987;
						Businesses[id][ExitY] = -40.644398;
						Businesses[id][ExitZ] = 1001.569946;
						Businesses[id][ExitInterior] = 1;
						format(string, sizeof string, "Business ID: %d - Description: Ammunation 1.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 23)
					{
						Businesses[id][ExitX] = 286.800995;
						Businesses[id][ExitY] = -82.547600;
						Businesses[id][ExitZ] = 1001.539978;
						Businesses[id][ExitInterior] = 4;
						format(string, sizeof string, "Business ID: %d - Description: Ammunation 2.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
	 				else if(id2 == 24)
					{
						Businesses[id][ExitX] = 296.919983;
						Businesses[id][ExitY] = -108.071999;
						Businesses[id][ExitZ] = 1001.569946;
						Businesses[id][ExitInterior] = 6;
						format(string, sizeof string, "Business ID: %d - Description: Ammunation 3.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 25)
					{
						Businesses[id][ExitX] = 316.524994;
						Businesses[id][ExitY] = -167.706985;
						Businesses[id][ExitZ] = 999.661987;
						Businesses[id][ExitInterior] = 6;
						format(string, sizeof string, "Business ID: %d - Description: Ammunation 4.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 26)
					{
						Businesses[id][ExitX] = 302.292877;
						Businesses[id][ExitY] = -143.139099;
						Businesses[id][ExitZ] = 1004.062500;
						Businesses[id][ExitInterior] = 7;
						format(string, sizeof string, "Business ID: %d - Description: Ammunation Shooting Range.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 27)
					{
						Businesses[id][ExitX] = -2637.449951;
						Businesses[id][ExitY] = 1404.629883;
						Businesses[id][ExitZ] = 906.457947;
						Businesses[id][ExitInterior] = 3;
						format(string, sizeof string, "Business ID: %d - Description: Jizzys.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 28)
					{
						Businesses[id][ExitX] = -25.884499;
						Businesses[id][ExitY] = -185.868988;
						Businesses[id][ExitZ] = 1003.549988;
						Businesses[id][ExitInterior] = 17;
						format(string, sizeof string, "Business ID: %d - Description: 24-7 1.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 29)
					{
						Businesses[id][ExitX] = 6.091180;
						Businesses[id][ExitY] = -29.271898;
						Businesses[id][ExitZ] = 1003.549988;
						Businesses[id][ExitInterior] = 10;
						format(string, sizeof string, "Business ID: %d - Description: 24-7 2.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 30)
					{
						Businesses[id][ExitX] = -30.946699;
						Businesses[id][ExitY] = -89.609596;
						Businesses[id][ExitZ] = 1003.549988;
						Businesses[id][ExitInterior] = 18;
						format(string, sizeof string, "Business ID: %d - Description: 24-7 3.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 31)
					{
						Businesses[id][ExitX] = -25.132599;
						Businesses[id][ExitY] = -139.066986;
						Businesses[id][ExitZ] = 1003.549988;
						Businesses[id][ExitInterior] = 16;
						format(string, sizeof string, "Business ID: %d - Description: 24-7 4.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
     				else if(id2 == 32)
					{
						Businesses[id][ExitX] = -27.312300;
						Businesses[id][ExitY] = -29.277599;
						Businesses[id][ExitZ] = 1003.549988;
						Businesses[id][ExitInterior] = 4;
						format(string, sizeof string, "Business ID: %d - Description: 24-7 5.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
         			else if(id2 == 33)
					{
						Businesses[id][ExitX] = -26.691599;
						Businesses[id][ExitY] = -55.714897;
						Businesses[id][ExitZ] = 1003.549988;
						Businesses[id][ExitInterior] = 6;
						format(string, sizeof string, "Business ID: %d - Description: 24-7 6.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,string);
     				}
					SaveBusinesses();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/ahouseprice", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ahouseprice [houseid] [price]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ahouseprice [houseid] [price]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					Houses[id][HousePrice] = id2;
					new form[128];
					format(form, sizeof form, "Dom ID: %d kosztuje %d $.", id,id2);
					SendClientMessage(playerid, COLOR_ADMINCMD,form);
					SaveHouses();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/abusinessname", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abusinessname [bizid] [name]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[128];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abusinessname [bizid] [name]");
					return 1;
				}
				if(strfind( result , "|" , true ) == -1)
    			{
		   			strmid(Businesses[id][BusinessName], (result), 0, strlen((result)), 128);
					format(string, sizeof(string), "[INFO:] Biznes ID: %d od teraz ma nazwê %s", id,(result));
					SendClientMessage(playerid, COLOR_ADMINCMD, string);
					SaveBusinesses();
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nieprawid³owy znak!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/abusinesssell", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abusinesssell [businessid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				Businesses[id][Locked] = 1;
				Businesses[id][Owned] = 0;
				strmid(Businesses[id][Owner], "None", 0, strlen("None"), 255);
				ChangeStreamPickupModel(Businesses[id][PickupID],1272);
    			MoveStreamPickup(Businesses[id][PickupID],Businesses[id][EnterX], Businesses[id][EnterY], Businesses[id][EnterZ]);
				SaveBusinesses();
				new form[128];
				format(form, sizeof(form), "[INFO:] Sprzeda³eœ biznes ID: %d.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/ahousesell", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ahousesell [houseid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				Houses[id][Locked] = 1;
				Houses[id][Owned] = 0;
				strmid(Houses[id][Owner], "None", 0, strlen("None"), 255);
				ChangeStreamPickupModel(Houses[id][PickupID],1273);
    			MoveStreamPickup(Houses[id][PickupID],Houses[id][EnterX], Houses[id][EnterY], Houses[id][EnterZ]);
				SaveHouses();
				new form[128];
				format(form, sizeof(form), "[INFO:] Sprzeda³eœ dom ID: %d.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/ahouseentrance", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ahouseentrance [houseid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
			    new pmodel;
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid, x, y, z);
				Houses[id][EnterX] = x;
				Houses[id][EnterY] = y;
				Houses[id][EnterZ] = z;
				Houses[id][EnterWorld] = GetPlayerVirtualWorld(playerid);
				Houses[id][EnterInterior] = GetPlayerInterior(playerid);
  				new Float:angle;
				GetPlayerFacingAngle(playerid, angle);
				Houses[id][EnterAngle] = angle;

				switch(Houses[id][Owned])
				{
				    case 0: pmodel = 1273;
				    case 1: pmodel = 1239;
				}
				ChangeStreamPickupModel(Houses[id][PickupID],pmodel);
    			MoveStreamPickup(Houses[id][PickupID],Houses[id][EnterX], Houses[id][EnterY], Houses[id][EnterZ]);
				SaveHouses();
				new form[128];
				format(form, sizeof(form), "[INFO:] Dom ID: %d ma now¹ lokacje.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/ahouseexit", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ahouseexit [houseid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid, x, y, z);
				Houses[id][ExitX] = x;
				Houses[id][ExitY] = y;
				Houses[id][ExitZ] = z;
				Houses[id][ExitInterior] = GetPlayerInterior(playerid);
  				new Float:angle;
				GetPlayerFacingAngle(playerid, angle);
				Houses[id][ExitAngle] = angle;
				SaveHouses();
				new form[128];
				format(form, sizeof(form), "[INFO:] Dom ID: %d ma now¹ lokacje wyjœciow¹.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/ahousedescription", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ahousedescription [houseid] [discription]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[128];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ahousedescription [houseid] [discription]");
					return 1;
				}
				if(strfind( result , "|" , true ) == -1)
    			{
		   			strmid(Houses[id][Description], (result), 0, strlen((result)), 128);
					format(string, sizeof(string), "[INFO:] Dom ID: %d ma opis: %s", id,(result));
					SendClientMessage(playerid, COLOR_ADMINCMD, string);
					SaveHouses();
				}
 				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nieprawid³owy symbol!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ administratorem!");
			}
		}
		return 1;
	}
	//===========================================================================================================================

	//===========================================[DYNAMIC BUILDINGS SYSTEM]=====================================================
	if(strcmp(cmd, "/abuildingentrance", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abuildingentrance [buildingid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid, x, y, z);
				Building[id][EnterX] = x;
				Building[id][EnterY] = y;
				Building[id][EnterZ] = z;
				Building[id][EnterWorld] = GetPlayerVirtualWorld(playerid);
				Building[id][EnterInterior] = GetPlayerInterior(playerid);
  				new Float:angle;
				GetPlayerFacingAngle(playerid, angle);
				Building[id][EnterAngle] = angle;
				MoveStreamPickup(Building[id][PickupID],Building[id][EnterX], Building[id][EnterY], Building[id][EnterZ]);
				SaveBuildings();
				new form[128];
				format(form, sizeof(form), "[INFO:] Budynek ID: %d ma now¹ lokacje.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if (strcmp(cmd, "/ksiazkatelefoniczna", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (PlayerInfo[giveplayerid][pPhoneBook])
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[U¿ycie:] /ksiazkatelefoniczna <id>");
					return 1;
				}
				//giveplayerid = strval(tmp);
				giveplayerid = ReturnUser(tmp);
				if(IsPlayerConnected(giveplayerid))
				{
				    if(giveplayerid != INVALID_PLAYER_ID)
				    {
				        if(gPlayerLogged[giveplayerid])
						{
					        if(PlayerInfo[giveplayerid][pListNumber])
					        {
								format(string, 128, "[Telefon:] Nick: %s, Telefon: %d.",GetPlayerNameEx(giveplayerid),PlayerInfo[giveplayerid][pPhoneNumber]);
								SendClientMessage(playerid, COLOR_LIGHTGREEN, string);
							}
							else
							{
							    SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ERROR:] Ten gracz nie udostêpnia swojego numeru telefonu.");
							}
						}
      					else
						{
    						SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ERROR:] Ten gracz nie jest zalogowany.");
						}
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID/Nick.");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie posiadasz ksi¹zki telefonicznej! Kup j¹ w 24/7.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/agotobuilding", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /agotobuilding [buildingid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				SetPlayerPos(playerid,Building[id][EnterX],Building[id][EnterY],Building[id][EnterZ]);
				SetPlayerInterior(playerid,Building[id][EnterInterior]);
				SetPlayerVirtualWorld(playerid,Building[id][EnterWorld]);
				new form[128];
				format(form, sizeof(form), "[INFO:] Teleportowa³eœ sie do budynku ID: %d.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/abuildinglock", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abuildinglock [buildingid]");
				return 1;
			}
			new id = strval(tmp);
			new form[128];
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
			    if(Building[id][Locked] == 0)
			    {
			    	Building[id][Locked] = 1;
   					format(form, sizeof(form), "[INFO:] Zmakn¹³eœ budynek ID: %d.", id);
					SendClientMessage(playerid, COLOR_ADMINCMD, form);
			    }
			    else
			    {
			    	Building[id][Locked] = 0;
   					format(form, sizeof(form), "[INFO:] Otworzy³eœ budynek ID: %d.", id);
					SendClientMessage(playerid, COLOR_ADMINCMD, form);
			    }
				SaveBuildings();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/abuildingexit", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abuildingexit [buildingid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid, x, y, z);
				Building[id][ExitX] = x;
				Building[id][ExitY] = y;
				Building[id][ExitZ] = z;
				Building[id][ExitInterior] = GetPlayerInterior(playerid);
  				new Float:angle;
				GetPlayerFacingAngle(playerid, angle);
				Building[id][ExitAngle] = angle;
				SaveBuildings();
				new form[128];
				format(form, sizeof(form), "[INFO:] Budynek ID: %d ma now¹ lokacje wyjœcia.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/abuildingname", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abuildingname [buildingid] [name]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[64];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abuildingname [buildingid] [name]");
					return 1;
				}
				if(strfind( result , "|" , true ) == -1)
    			{
		   			strmid(Building[id][BuildingName], (result), 0, strlen((result)), 128);
					format(string, sizeof(string), "[INFO:] Budynek ID: %d ma teraz nazwê %s", id,(result));
					SendClientMessage(playerid, COLOR_ADMINCMD, string);
					SaveBuildings();
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nieprawid³owy symbol!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/abuildingfee", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abuildingfee [buildingid] [amount]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 10)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /abuildingfee [buildingid] [amount]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					Building[id][EntranceFee] = id2;
					new form[128];
					format(form, sizeof form, "Budynek ID: %d ma od teraz ustawiony koszt wejœcia na %d $.", id,id2);
					SendClientMessage(playerid, COLOR_ADMINCMD,form);
					SaveBuildings();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	//===========================================================================================================================
	if(strcmp(cmd, "/agotobank", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerPos(playerid,BankPosition[X],BankPosition[Y],BankPosition[Z]);
			SetPlayerInterior(playerid,BankPosition[Interior]);
			SetPlayerVirtualWorld(playerid,BankPosition[World]);
			SetPlayerFacingAngle(playerid,BankPosition[Angle]);
			SendClientMessage(playerid, COLOR_ADMINCMD, "[INFO:] Teleportowa³eœ siê do banku.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
		}
		return 1;
	}
   	if(strcmp(cmd, "/agotodrivingtestpos", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerPos(playerid,DrivingTestPosition[X],DrivingTestPosition[Y],DrivingTestPosition[Z]);
			SetPlayerInterior(playerid,DrivingTestPosition[Interior]);
			SetPlayerVirtualWorld(playerid,DrivingTestPosition[World]);
			SetPlayerFacingAngle(playerid,DrivingTestPosition[Angle]);
			SendClientMessage(playerid, COLOR_ADMINCMD, "[INFO:] Teleportowa³eœ siê do lokacji testu na prawojazdy.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
		}
		return 1;
	}
	if(strcmp(cmd, "/agotoflyingtestpos", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerPos(playerid,FlyingTestPosition[X],FlyingTestPosition[Y],FlyingTestPosition[Z]);
			SetPlayerInterior(playerid,FlyingTestPosition[Interior]);
			SetPlayerVirtualWorld(playerid,FlyingTestPosition[World]);
			SetPlayerFacingAngle(playerid,FlyingTestPosition[Angle]);
			SendClientMessage(playerid, COLOR_ADMINCMD, "[INFO:] Teleportowa³eœ siê do lokacji licencji pilota.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
		}
		return 1;
	}
 	if(strcmp(cmd, "/agotopolicearrestpos", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerPos(playerid,PoliceArrestPosition[X],PoliceArrestPosition[Y],PoliceArrestPosition[Z]);
			SetPlayerInterior(playerid,PoliceArrestPosition[Interior]);
			SetPlayerVirtualWorld(playerid,PoliceArrestPosition[World]);
			SetPlayerFacingAngle(playerid,PoliceArrestPosition[Angle]);
			SendClientMessage(playerid, COLOR_ADMINCMD, "[INFO:] Teleportowa³eœ siê do lokacji aresztu.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
		}
		return 1;
	}
  	if(strcmp(cmd, "/agotopolicedutypos", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerPos(playerid,PoliceDutyPosition[X],PoliceDutyPosition[Y],PoliceDutyPosition[Z]);
			SetPlayerInterior(playerid,PoliceDutyPosition[Interior]);
			SetPlayerVirtualWorld(playerid,PoliceDutyPosition[World]);
			SetPlayerFacingAngle(playerid,PoliceDutyPosition[Angle]);
			SendClientMessage(playerid, COLOR_ADMINCMD, "[INFO:] Teleportowa³eœ siê do lokacji policyjnej s³u¿by.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
		}
		return 1;
	}
	//===============================================[DYNAMIC FACTION MATERIALS & DRUGS STORAGE]=================================
  	if(strcmp(cmd, "/agotofmatsstorage", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerPos(playerid,FactionMaterialsStorage[X],FactionMaterialsStorage[Y],FactionMaterialsStorage[Z]);
			SetPlayerInterior(playerid,FactionMaterialsStorage[Interior]);
			SetPlayerVirtualWorld(playerid,FactionMaterialsStorage[World]);
			SetPlayerFacingAngle(playerid,FactionMaterialsStorage[Angle]);
			SendClientMessage(playerid, COLOR_ADMINCMD, "[INFO:] Teleportowa³eœ siê do frakcyjnego magazynu materia³ów na broñ.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
		}
		return 1;
	}
	if(strcmp(cmd, "/afactionmatsstorage", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		FactionMaterialsStorage[X] = x;
		FactionMaterialsStorage[Y] = y;
		FactionMaterialsStorage[Z] = z;
		FactionMaterialsStorage[World] = GetPlayerVirtualWorld(playerid);
		FactionMaterialsStorage[Interior] = GetPlayerInterior(playerid);
		FactionMaterialsStorage[Angle] = angle;
  		MoveStreamPickup(FactionMaterialsStorage[PickupID],FactionMaterialsStorage[X],FactionMaterialsStorage[Y],FactionMaterialsStorage[Z]);
		SaveFactionMaterialsStorage();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustanowi³eœ lokacje magazynu frakcyjnych materia³ów na broñ.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
 	if(strcmp(cmd, "/agotofdrugsstorage", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerPos(playerid,FactionDrugsStorage[X],FactionDrugsStorage[Y],FactionDrugsStorage[Z]);
			SetPlayerInterior(playerid,FactionDrugsStorage[Interior]);
			SetPlayerVirtualWorld(playerid,FactionDrugsStorage[World]);
			SetPlayerFacingAngle(playerid,FactionDrugsStorage[Angle]);
			SendClientMessage(playerid, COLOR_ADMINCMD, "[INFO:] Teleportowa³eœ siê do frakcyjnego magazynu dragów.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
		}
		return 1;
	}
 	if(strcmp(cmd, "/afactiondrugsstorage", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		FactionDrugsStorage[X] = x;
		FactionDrugsStorage[Y] = y;
		FactionDrugsStorage[Z] = z;
		FactionDrugsStorage[World] = GetPlayerVirtualWorld(playerid);
		FactionDrugsStorage[Interior] = GetPlayerInterior(playerid);
		FactionDrugsStorage[Angle] = angle;
  		MoveStreamPickup(FactionDrugsStorage[PickupID],FactionDrugsStorage[X],FactionDrugsStorage[Y],FactionDrugsStorage[Z]);
		SaveFactionDrugsStorage();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustanowi³eœ lokacje maganyzu frakcyjnych dragów.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
	//===================================================================================================================================

	//===================================================[BANK POSITION]=================================================================
	if(strcmp(cmd, "/abankpos", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		BankPosition[X] = x;
		BankPosition[Y] = y;
		BankPosition[Z] = z;
		BankPosition[World] = GetPlayerVirtualWorld(playerid);
		BankPosition[Interior] = GetPlayerInterior(playerid);
		BankPosition[Angle] = angle;
  		MoveStreamPickup(BankPosition[PickupID],BankPosition[X],BankPosition[Y],BankPosition[Z]);
		SaveBankPosition();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokacje banku.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
 	if(strcmp(cmd, "/adetectivejobpos", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		DetectiveJobPosition[X] = x;
		DetectiveJobPosition[Y] = y;
		DetectiveJobPosition[Z] = z;
		DetectiveJobPosition[World] = GetPlayerVirtualWorld(playerid);
		DetectiveJobPosition[Interior] = GetPlayerInterior(playerid);
		DetectiveJobPosition[Angle] = angle;
  		MoveStreamPickup(DetectiveJobPosition[PickupID],DetectiveJobPosition[X],DetectiveJobPosition[Y],DetectiveJobPosition[Z]);
		SaveDetectiveJob();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ pozycjê pracy detektywa.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
  	if(strcmp(cmd, "/alawyerjobpos", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		LawyerJobPosition[X] = x;
		LawyerJobPosition[Y] = y;
		LawyerJobPosition[Z] = z;
		LawyerJobPosition[World] = GetPlayerVirtualWorld(playerid);
		LawyerJobPosition[Interior] = GetPlayerInterior(playerid);
		LawyerJobPosition[Angle] = angle;
  		MoveStreamPickup(LawyerJobPosition[PickupID],LawyerJobPosition[X],LawyerJobPosition[Y],LawyerJobPosition[Z]);
		SaveLawyerJob();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokacje pracy adwokata.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
	if(strcmp(cmd, "/adrugjobpos", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		DrugJob[TakeJobX] = x;
		DrugJob[TakeJobY] = y;
		DrugJob[TakeJobZ] = z;
		DrugJob[TakeJobWorld] = GetPlayerVirtualWorld(playerid);
		DrugJob[TakeJobInterior] = GetPlayerInterior(playerid);
		DrugJob[TakeJobAngle] = angle;
  		MoveStreamPickup(DrugJob[TakeJobPickupID],DrugJob[TakeJobX],DrugJob[TakeJobY],DrugJob[TakeJobZ]);
		SaveDrugJob();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokacje pracy dilera dragów.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
   	if(strcmp(cmd, "/adrugjobpos2", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		DrugJob[BuyDrugsX] = x;
		DrugJob[BuyDrugsY] = y;
		DrugJob[BuyDrugsZ] = z;
		DrugJob[BuyDrugsWorld] = GetPlayerVirtualWorld(playerid);
		DrugJob[BuyDrugsInterior] = GetPlayerInterior(playerid);
		DrugJob[BuyDrugsAngle] = angle;
  		MoveStreamPickup(DrugJob[BuyDrugsPickupID],DrugJob[BuyDrugsX],DrugJob[BuyDrugsY],DrugJob[BuyDrugsZ]);
		SaveDrugJob();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokacje pracy dilera dragów(2).");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
   	if(strcmp(cmd, "/adrugjobpos3", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		DrugJob[DeliverX] = x;
		DrugJob[DeliverY] = y;
		DrugJob[DeliverZ] = z;
		DrugJob[DeliverWorld] = GetPlayerVirtualWorld(playerid);
		DrugJob[DeliverInterior] = GetPlayerInterior(playerid);
		DrugJob[DeliverAngle] = angle;
  		MoveStreamPickup(DrugJob[DeliverPickupID],DrugJob[DeliverX],DrugJob[DeliverY],DrugJob[DeliverZ]);
		SaveDrugJob();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokacje pracy dilera dragów(3).");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
  	if(strcmp(cmd, "/aproductjobpos", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		ProductsSellerJob[TakeJobX] = x;
		ProductsSellerJob[TakeJobY] = y;
		ProductsSellerJob[TakeJobZ] = z;
		ProductsSellerJob[TakeJobWorld] = GetPlayerVirtualWorld(playerid);
		ProductsSellerJob[TakeJobInterior] = GetPlayerInterior(playerid);
		ProductsSellerJob[TakeJobAngle] = angle;
  		MoveStreamPickup(ProductsSellerJob[TakeJobPickupID],ProductsSellerJob[TakeJobX],ProductsSellerJob[TakeJobY],ProductsSellerJob[TakeJobZ]);
		SaveProductsSellerJob();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokacje pracy dostawcy.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
   	if(strcmp(cmd, "/aproductjobpos2", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		ProductsSellerJob[BuyProductsX] = x;
		ProductsSellerJob[BuyProductsY] = y;
		ProductsSellerJob[BuyProductsZ] = z;
		ProductsSellerJob[BuyProductsWorld] = GetPlayerVirtualWorld(playerid);
		ProductsSellerJob[BuyProductsInterior] = GetPlayerInterior(playerid);
		ProductsSellerJob[BuyProductsAngle] = angle;
    	MoveStreamPickup(ProductsSellerJob[BuyProductsPickupID],ProductsSellerJob[BuyProductsX],ProductsSellerJob[BuyProductsY],ProductsSellerJob[BuyProductsZ]);
		SaveProductsSellerJob();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokacje zakupu produktów dla pracy dostawcy.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
 	if(strcmp(cmd, "/agunjobpos", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		GunJob[TakeJobX] = x;
		GunJob[TakeJobY] = y;
		GunJob[TakeJobZ] = z;
		GunJob[TakeJobWorld] = GetPlayerVirtualWorld(playerid);
		GunJob[TakeJobInterior] = GetPlayerInterior(playerid);
		GunJob[TakeJobAngle] = angle;
  		MoveStreamPickup(GunJob[TakeJobPickupID],GunJob[TakeJobX],GunJob[TakeJobY],GunJob[TakeJobZ]);
		SaveGunJob();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokacje pracy dilera broni.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
  	if(strcmp(cmd, "/agunjobpos2", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		GunJob[BuyPackagesX] = x;
		GunJob[BuyPackagesY] = y;
		GunJob[BuyPackagesZ] = z;
		GunJob[BuyPackagesWorld] = GetPlayerVirtualWorld(playerid);
		GunJob[BuyPackagesInterior] = GetPlayerInterior(playerid);
		GunJob[BuyPackagesAngle] = angle;
  		MoveStreamPickup(GunJob[BuyPackagesPickupID],GunJob[BuyPackagesX],GunJob[BuyPackagesY],GunJob[BuyPackagesZ]);
		SaveGunJob();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokacje pracy dilera broni(2).");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
  	if(strcmp(cmd, "/agunjobpos3", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		GunJob[DeliverX] = x;
		GunJob[DeliverY] = y;
		GunJob[DeliverZ] = z;
		GunJob[DeliverWorld] = GetPlayerVirtualWorld(playerid);
		GunJob[DeliverInterior] = GetPlayerInterior(playerid);
		GunJob[DeliverAngle] = angle;
  		MoveStreamPickup(GunJob[DeliverPickupID],GunJob[DeliverX],GunJob[DeliverY],GunJob[DeliverZ]);
		SaveGunJob();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokacje pracy dilera broni(3).");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
	//===============================================[FLYING & DRIVING TEST POS]==========================================================
	if(strcmp(cmd, "/agotoweaponlicpos", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SetPlayerPos(playerid,WeaponLicensePosition[X],WeaponLicensePosition[Y],WeaponLicensePosition[Z]);
			SetPlayerInterior(playerid,WeaponLicensePosition[Interior]);
			SetPlayerVirtualWorld(playerid,WeaponLicensePosition[World]);
			SetPlayerFacingAngle(playerid,WeaponLicensePosition[Angle]);
			SendClientMessage(playerid, COLOR_ADMINCMD, "[INFO:] Teleportowa³eœ siê do pozycji licencji na broñ.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
		}
		return 1;
	}
	if(strcmp(cmd, "/aweaponlicensepos", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		WeaponLicensePosition[X] = x;
		WeaponLicensePosition[Y] = y;
		WeaponLicensePosition[Z] = z;
		WeaponLicensePosition[World] = GetPlayerVirtualWorld(playerid);
		WeaponLicensePosition[Interior] = GetPlayerInterior(playerid);
		WeaponLicensePosition[Angle] = angle;
  		MoveStreamPickup(WeaponLicensePosition[PickupID],WeaponLicensePosition[X],WeaponLicensePosition[Y],WeaponLicensePosition[Z]);
		SaveWeaponLicensePosition();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokalizacje licencji na broñ.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
   	if(strcmp(cmd, "/aflyingtestpos", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		FlyingTestPosition[X] = x;
		FlyingTestPosition[Y] = y;
		FlyingTestPosition[Z] = z;
		FlyingTestPosition[World] = GetPlayerVirtualWorld(playerid);
		FlyingTestPosition[Interior] = GetPlayerInterior(playerid);
		FlyingTestPosition[Angle] = angle;
  		MoveStreamPickup(FlyingTestPosition[PickupID],FlyingTestPosition[X],FlyingTestPosition[Y],FlyingTestPosition[Z]);
		SaveFlyingTestPosition();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokalizacje licencji pilota.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
  	if(strcmp(cmd, "/adrivingtestpos", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		DrivingTestPosition[X] = x;
		DrivingTestPosition[Y] = y;
		DrivingTestPosition[Z] = z;
		DrivingTestPosition[World] = GetPlayerVirtualWorld(playerid);
		DrivingTestPosition[Interior] = GetPlayerInterior(playerid);
		DrivingTestPosition[Angle] = angle;
		MoveStreamPickup(DrivingTestPosition[PickupID],DrivingTestPosition[X],DrivingTestPosition[Y],DrivingTestPosition[Z]);
		SaveDrivingTestPosition();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokalizacje testu na prawojazdy.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
 	if(strcmp(cmd, "/apolicearrestpos", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		PoliceArrestPosition[X] = x;
		PoliceArrestPosition[Y] = y;
		PoliceArrestPosition[Z] = z;
		PoliceArrestPosition[World] = GetPlayerVirtualWorld(playerid);
		PoliceArrestPosition[Interior] = GetPlayerInterior(playerid);
		PoliceArrestPosition[Angle] = angle;
		SavePoliceArrestPosition();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokalizacje aresztu.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
  	if(strcmp(cmd, "/apolicedutypos", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		PoliceDutyPosition[X] = x;
		PoliceDutyPosition[Y] = y;
		PoliceDutyPosition[Z] = z;
		PoliceDutyPosition[World] = GetPlayerVirtualWorld(playerid);
		PoliceDutyPosition[Interior] = GetPlayerInterior(playerid);
		PoliceDutyPosition[Angle] = angle;
		SavePoliceDutyPosition();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokalizacje policyjnej s³u¿by.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
	//===============================================[DYNAMIC CIVILIAN SPAWN]====================================================
	if(strcmp(cmd, "/acivilianspawn", true) == 0)
	{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
  		new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		CivilianSpawn[X] = x;
		CivilianSpawn[Y] = y;
		CivilianSpawn[Z] = z;
		CivilianSpawn[World] = GetPlayerVirtualWorld(playerid);
		CivilianSpawn[Interior] = GetPlayerInterior(playerid);
		CivilianSpawn[Angle] = angle;
		SaveCivilianSpawn();
		SendClientMessage(playerid, COLOR_ADMINCMD, "Ustawi³eœ lokalizacje pocz¹tkowego spawnu graczy.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
	}
	return 1;
	}
	//================================================[DYNAMIC FACTION SYSTEM]======================================================
 	if(strcmp(cmd, "/afactionspawn", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionspawn [factionid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid, x, y, z);
				DynamicFactions[id][fX] = x;
				DynamicFactions[id][fY] = y;
				DynamicFactions[id][fZ] = z;
				SaveDynamicFactions();
				format(string, sizeof(string), "[INFO:] Frakcja ID: %d ma now¹ pozycje spawnu.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, string);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/aresetfaction", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "USAGE: /aresetfaction [factionid]");
				return 1;
			}
			new factionid = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
				new rank;
				format(string, sizeof(string), "Faction%d",factionid);
				strmid(DynamicFactions[factionid][fName], string, 0, strlen(string), 255);
				DynamicFactions[factionid][fX] = 0.0;
				DynamicFactions[factionid][fY] = 0.0;
				DynamicFactions[factionid][fZ] = 0.0;
				DynamicFactions[factionid][fMaterials] = 0;
				DynamicFactions[factionid][fDrugs] = 0;
				DynamicFactions[factionid][fBank] = 0;
				rank = 1; format(string, sizeof(string), "Rank%d",rank); strmid(DynamicFactions[factionid][fRank1], string, 0, strlen(string), 255);
				rank ++; format(string, sizeof(string), "Rank%d",rank); strmid(DynamicFactions[factionid][fRank2], string, 0, strlen(string), 255);
				rank ++; format(string, sizeof(string), "Rank%d",rank); strmid(DynamicFactions[factionid][fRank3], string, 0, strlen(string), 255);
				rank ++; format(string, sizeof(string), "Rank%d",rank); strmid(DynamicFactions[factionid][fRank4], string, 0, strlen(string), 255);
				rank ++; format(string, sizeof(string), "Rank%d",rank); strmid(DynamicFactions[factionid][fRank5], string, 0, strlen(string), 255);
				rank ++; format(string, sizeof(string), "Rank%d",rank); strmid(DynamicFactions[factionid][fRank6], string, 0, strlen(string), 255);
				rank ++; format(string, sizeof(string), "Rank%d",rank); strmid(DynamicFactions[factionid][fRank7], string, 0, strlen(string), 255);
				rank ++; format(string, sizeof(string), "Rank%d",rank); strmid(DynamicFactions[factionid][fRank8], string, 0, strlen(string), 255);
				rank ++; format(string, sizeof(string), "Rank%d",rank); strmid(DynamicFactions[factionid][fRank9], string, 0, strlen(string), 255);
				rank ++; format(string, sizeof(string), "Rank%d",rank); strmid(DynamicFactions[factionid][fRank10], string, 0, strlen(string), 255);
				DynamicFactions[factionid][fSkin1] = 0;
				DynamicFactions[factionid][fSkin2] = 0;
				DynamicFactions[factionid][fSkin3] = 0;
				DynamicFactions[factionid][fSkin4] = 0;
				DynamicFactions[factionid][fSkin5] = 0;
				DynamicFactions[factionid][fSkin6] = 0;
				DynamicFactions[factionid][fSkin7] = 0;
				DynamicFactions[factionid][fSkin8] = 0;
				DynamicFactions[factionid][fSkin9] = 0;
				DynamicFactions[factionid][fSkin10] = 0;
				DynamicFactions[factionid][fJoinRank] = 0;
				DynamicFactions[factionid][fUseSkins] = 0;
				DynamicFactions[factionid][fType] = 0;
				DynamicFactions[factionid][fRankAmount] = 0;
				DynamicFactions[factionid][fUseColor] = 0;
				format(string, sizeof(string), "0xFFFFFFFF");
				strmid(DynamicFactions[factionid][fColor], string, 0, strlen(string), 255);
				format(string, sizeof(string), "[INFO:] Frakcja ID: %d zosta³¹ wyzerowana.", factionid);
				SendClientMessage(playerid, COLOR_ADMINCMD, string);
				SaveDynamicFactions();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem lub masz za ma³y poziom.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/report", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[U¿ycie:] /report <id> <treœæ>");
				return 1;
			}
			new id = strval(tmp);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[U¿ycie:] /report <id> <treœæ>");
				return 1;
			}
			if(IsPlayerConnected(id))
	    	{
	    		if(id != INVALID_PLAYER_ID)
			    {
					format(string, sizeof(string), "[REPORT:] %s zg³asza %s (ID:%d), Powód: %s",GetPlayerNameEx(playerid),GetPlayerNameEx(id),id,result);
					AdministratorMessage(COLOR_ADMINCMD, string,1);
					format(string, sizeof(string), "Zg³osi³eœ %s (ID:%d), Powód: %s",GetPlayerNameEx(id),id,result);
					SendClientMessage(playerid, COLOR_WHITE, string);
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[Sukces] Zg³oszenie wys³ane.");
					ReportLog(string);
				}
			}
			else
			{
			    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Error:] Ta osoba nie jest zalogowana.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/admin", true) == 0 || strcmp(cmd, "/a", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] (/a)dmin [message]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				format(string, sizeof(string), "[ACHAT:] (%d) %s: %s", PlayerInfo[playerid][pAdmin], GetPlayerNameEx(playerid), result);
				AdministratorMessage(COLOR_YELLOW, string,1);
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/listenchat", true) == 0 && PlayerInfo[playerid][pAdmin] >= 1)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (!BigEar[playerid])
			{
				BigEar[playerid] = 1;
			}
			else if (BigEar[playerid])
			{
				(BigEar[playerid] = 0);
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/afactioncolor", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactioncolor [factionid] [hex]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[128];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactioncolour [factionid] [hex]");
					return 1;
				}
				if(strfind( result , "|" , true ) == -1)
    			{
		   			strmid(DynamicFactions[id][fColor], (result), 0, strlen((result)), 128);
					format(string, sizeof(string), "[INFO:] Frakcja ID: %d otrzyma³a kolor %s.", id,(result));
					SendClientMessage(playerid, COLOR_ADMINCMD, string);
					SaveDynamicFactions();
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nieprawid³owy symbol!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/afactionname", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionname [factionid] [name]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[128];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionname [factionid] [name]");
					return 1;
				}
				if(strfind( result , "|" , true ) == -1)
    			{
		   			strmid(DynamicFactions[id][fName], (result), 0, strlen((result)), 128);
					format(string, sizeof(string), "[INFO:] Frakcja ID: %d nowa nazwa: %s", id,(result));
					SendClientMessage(playerid, COLOR_ADMINCMD, string);
					SaveDynamicFactions();
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nieprawid³owy symbol!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
  	if(strcmp(cmd, "/agotofaction", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /agotofaction [id]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				SetPlayerPos(playerid,DynamicFactions[id][fX],DynamicFactions[id][fY],DynamicFactions[id][fZ]);
				SetPlayerInterior(playerid,0);
				SetPlayerVirtualWorld(playerid,0);
				new form[128];
				format(form, sizeof(form), "[INFO:] Teleportowa³eœ siê do frakcji ID: %d.", id);
				SendClientMessage(playerid, COLOR_ADMINCMD, form);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/afactiontype", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactiontype [factionid] [type (Numeric)]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactiontype [factionid] [type (Numeric)]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					DynamicFactions[id][fType] = id2;
					new form[128];
					format(form, sizeof form, "Frakcja ID: %d | ID nowego typu: %d.", id,id2);
					SendClientMessage(playerid, COLOR_ADMINCMD,form);
					SaveDynamicFactions();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/afactionjoinrank", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionjoinrank [factionid] [2-10]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionjoinrank [factionid] [2-10]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					if(id2 >= 2 && id2 <= 10)
					{
	  					DynamicFactions[id][fJoinRank] = id2;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Pocz¹tkowa ranga: %d.", id,id2);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/afactionbank", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionbank [factionid] [amount]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionbank [factionid] [amount]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					DynamicFactions[id][fBank] = id2;
					new form[128];
					format(form, sizeof form, "Frakcja ID: %d | Gotówka w banku: %d.", id,id2);
					SendClientMessage(playerid, COLOR_ADMINCMD,form);
					SaveDynamicFactions();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/afactiondrugs", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactiondrugs [factionid] [amount]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactiondrugs [factionid] [amount]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					DynamicFactions[id][fDrugs] = id2;
					new form[128];
					format(form, sizeof form, "Frakcja ID: %d | Iloœæ dragów:  %d.", id,id2);
					SendClientMessage(playerid, COLOR_ADMINCMD,form);
					SaveDynamicFactions();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/afactionmats", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionmats [factionid] [amount]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionmats [factionid] [amount]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					DynamicFactions[id][fMaterials] = id2;
					new form[128];
					format(form, sizeof form, "Frakcja ID: %d | Iloœæ materia³ów: %d.", id,id2);
					SendClientMessage(playerid, COLOR_ADMINCMD,form);
					SaveDynamicFactions();
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/afactionrankamount", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionrankamount [factionid] [2-10]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionrankamount [factionid] [2-10]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					if(id2 >= 2 && id2 <= 10)
					{
	  					DynamicFactions[id][fRankAmount] = id2;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Iloœæ rang: %d.", id,id2);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/afactionrankname", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionrankname [factionid] [Rank ID - 1-10] [Name]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionrankname [factionid] [Rank ID - 1-10] [Name]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);

					new length = strlen(cmdtext);
					while ((idx < length) && (cmdtext[idx] <= ' '))
					{
						idx++;
					}
					new offset = idx;
					new result[64];
					while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
					{
						result[idx - offset] = cmdtext[idx];
						idx++;
					}
					result[idx - offset] = EOS;
					if(!strlen(result))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionrankname [factionid] [Rank ID - 1-10] [Name]");
						return 1;
					}
  					if(strfind( result , "|" , true ) == -1)
    				{
						if(id2 == 1)
						{
				   			strmid(DynamicFactions[id][fRank1], (result), 0, strlen((result)), 128);
							format(string, sizeof(string), "[INFO:] Frakcja: %d | Ranga: %d | Nazwa: %s", id,id2,result);
							SendClientMessage(playerid, COLOR_ADMINCMD, string);
							SaveDynamicFactions();
						}
						else if(id2 == 2)
						{
				   			strmid(DynamicFactions[id][fRank2], (result), 0, strlen((result)), 128);
							format(string, sizeof(string), "[INFO:] Frakcja: %d | Ranga: %d | Nazwa: %s", id,id2,result);
							SendClientMessage(playerid, COLOR_ADMINCMD, string);
							SaveDynamicFactions();
						}
						else if(id2 == 3)
						{
				   			strmid(DynamicFactions[id][fRank3], (result), 0, strlen((result)), 128);
							format(string, sizeof(string), "[INFO:] Frakcja: %d | Ranga: %d | Nazwa: %s", id,id2,result);
							SendClientMessage(playerid, COLOR_ADMINCMD, string);
							SaveDynamicFactions();
						}
						else if(id2 == 4)
						{
				   			strmid(DynamicFactions[id][fRank4], (result), 0, strlen((result)), 128);
							format(string, sizeof(string), "[INFO:] Frakcja: %d | Ranga: %d | Nazwa: %s", id,id2,result);
							SendClientMessage(playerid, COLOR_ADMINCMD, string);
							SaveDynamicFactions();
						}
						else if(id2 == 5)
						{
				   			strmid(DynamicFactions[id][fRank5], (result), 0, strlen((result)), 128);
							format(string, sizeof(string), "[INFO:] Frakcja: %d | Ranga: %d | Nazwa: %s", id,id2,result);
							SendClientMessage(playerid, COLOR_ADMINCMD, string);
							SaveDynamicFactions();
						}
						else if(id2 == 6)
						{
				   			strmid(DynamicFactions[id][fRank6], (result), 0, strlen((result)), 128);
							format(string, sizeof(string), "[INFO:] Frakcja: %d | Ranga: %d | Nazwa: %s", id,id2,result);
							SendClientMessage(playerid, COLOR_ADMINCMD, string);
							SaveDynamicFactions();
						}
						else if(id2 == 7)
						{
				   			strmid(DynamicFactions[id][fRank7], (result), 0, strlen((result)), 128);
							format(string, sizeof(string), "[INFO:] Frakcja: %d | Ranga: %d | Nazwa: %s", id,id2,result);
							SendClientMessage(playerid, COLOR_ADMINCMD, string);
							SaveDynamicFactions();
						}
						else if(id2 == 8)
						{
				   			strmid(DynamicFactions[id][fRank8], (result), 0, strlen((result)), 128);
							format(string, sizeof(string), "[INFO:] Frakcja: %d | Ranga: %d | Nazwa: %s", id,id2,result);
							SendClientMessage(playerid, COLOR_ADMINCMD, string);
							SaveDynamicFactions();
						}
						else if(id2 == 9)
						{
				   			strmid(DynamicFactions[id][fRank9], (result), 0, strlen((result)), 128);
							format(string, sizeof(string), "[INFO:] Frakcja: %d | Ranga: %d | Nazwa: %s", id,id2,result);
							SendClientMessage(playerid, COLOR_ADMINCMD, string);
							SaveDynamicFactions();
						}
						else if(id2 == 10)
						{
				   			strmid(DynamicFactions[id][fRank10], (result), 0, strlen((result)), 128);
							format(string, sizeof(string), "[INFO:] Frakcja: %d | Ranga: %d | Nazwa: %s", id,id2,result);
							SendClientMessage(playerid, COLOR_ADMINCMD, string);
							SaveDynamicFactions();
						}
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nieprawid³owy symbol!");
					}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ administratorem!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/afactionskin", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionskin [factionid] [Rank ID - 1-10] [Skinid]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
					new id;
					id = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionskin [factionid] [Rank ID - 1-10] [Skinid]");
						return 1;
					}
					new id2;
					id2 = strval(tmp);
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionskin [factionid] [Rank ID - 1-10] [Skinid]");
						return 1;
					}
					new id3;
					id3 = strval(tmp);

					if(id2 == 1)
					{
	  					DynamicFactions[id][fSkin1] = id3;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Ranga: %d | Skinid:  %d.", id,id2,id3);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
					else if(id2 == 2)
					{
	  					DynamicFactions[id][fSkin2] = id3;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Ranga: %d | Skinid:  %d.", id,id2,id3);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
					else if(id2 == 3)
					{
	  					DynamicFactions[id][fSkin3] = id3;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Ranga: %d | Skinid:  %d.", id,id2,id3);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
					else if(id2 == 4)
					{
	  					DynamicFactions[id][fSkin4] = id3;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Ranga: %d | Skinid:  %d.", id,id2,id3);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
					else if(id2 == 5)
					{
	  					DynamicFactions[id][fSkin5] = id3;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Ranga: %d | Skinid:  %d.", id,id2,id3);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
					else if(id2 == 6)
					{
	  					DynamicFactions[id][fSkin6] = id3;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Ranga: %d | Skinid:  %d.", id,id2,id3);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
					else if(id2 == 7)
					{
	  					DynamicFactions[id][fSkin7] = id3;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Ranga: %d | Skinid:  %d.", id,id2,id3);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
					else if(id2 == 8)
					{
	  					DynamicFactions[id][fSkin8] = id3;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Ranga: %d | Skinid:  %d.", id,id2,id3);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
					else if(id2 == 9)
					{
	  					DynamicFactions[id][fSkin9] = id3;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Ranga: %d | Skinid:  %d.", id,id2,id3);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
					else if(id2 == 10)
					{
	  					DynamicFactions[id][fSkin10] = id3;
						new form[128];
						format(form, sizeof form, "Frakcja ID: %d | Ranga: %d | Skinid:  %d.", id,id2,id3);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SaveDynamicFactions();
					}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/afactionusecolor", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionusecolor [factionid]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
					new id;
					id = strval(tmp);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionusecolor [factionid]");
						return 1;
					}
					if(DynamicFactions[id][fUseColor])
					{
	  					DynamicFactions[id][fUseColor] = 0;
						new form[128];
						format(form, sizeof form, "[INFO:] Frakcja ID: %d - kolor wy³¹czony.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
				    	SendFactionMessage(id, COLOR_FACTIONCHAT, "[FACTION:] Frakcyjny kolor wy³¹czony przez administratora.");
						SaveDynamicFactions();

						for(new i=0;i<MAX_PLAYERS;i++)
						{
					    	if(IsPlayerConnected(i))
					       	{
								if(PlayerInfo[i][pFaction] == id)
								{
									SetPlayerColor(i,COLOR_CIVILIAN);
								}
					       	}
				       	}
					}
					else
					{
	  					DynamicFactions[id][fUseColor] = 1;
						new form[128];
						format(form, sizeof form, "[INFO:] Frakcja ID: %d - kolor w³¹czony.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SendFactionMessage(id, COLOR_FACTIONCHAT, "[FACTION:] Frakcyjny kolor w³¹czony przez administratora.");
						SaveDynamicFactions();

  						for(new i=0;i<MAX_PLAYERS;i++)
						{
					    	if(IsPlayerConnected(i))
					       	{
								if(PlayerInfo[i][pFaction] == id)
								{
         							SetPlayerToFactionColor(i);
								}
					       	}
				       	}
					}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/afactionuseskins", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionuseskins [factionid]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
					new id;
					id = strval(tmp);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionuseskins [factionid]");
						return 1;
					}

					if(DynamicFactions[id][fUseSkins])
					{
	  					DynamicFactions[id][fUseSkins] = 0;
						new form[128];
						format(form, sizeof form, "[INFO:] Frakcja ID: %d - skiny wy³¹czone.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
				    	SendFactionMessage(id, COLOR_FACTIONCHAT, "[FACTION:] Frakcyjne skiny wy³¹czone przez administratora.");
						SaveDynamicFactions();

					}
					else
					{
	  					DynamicFactions[id][fUseSkins] = 1;
						new form[128];
						format(form, sizeof form, "[INFO:] Frakcja ID: %d - skiny w³¹czone.", id);
						SendClientMessage(playerid, COLOR_ADMINCMD,form);
						SendFactionMessage(id, COLOR_FACTIONCHAT, "[FACTION:] Frakcyjne skiny w³¹czone przez administratora.");
						SaveDynamicFactions();

						for(new i=0;i<MAX_PLAYERS;i++)
						{
					    	if(IsPlayerConnected(i))
					       	{
								if(PlayerInfo[i][pFaction] == id)
								{
									SetPlayerToFactionSkin(i);
								}
					       	}
				       	}
					}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	//--------------------------------------------------------------------------------------------------------------------------
	//---------------------------------------[NORMAL ADMINISTRATOR COMMANDS]-------------------------------------------
 	if(strcmp(cmd, "/bankonto", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[U¿ycie:] /bankonto <id> <powód>");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerConnected(giveplayerid))
				{
				    if(giveplayerid != INVALID_PLAYER_ID)
				    {
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[128];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result))
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[U¿ycie:] /bankonto <id> <powód>");
							return 1;
						}
						BanPlayerAccount(giveplayerid,GetPlayerNameEx(playerid),(result));
						return 1;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
			}
		}
		return 1;
	}
    if(strcmp(cmd, "/ban", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ban <id/nick> <powód>");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				if(IsPlayerConnected(giveplayerid))
				{
				    if(giveplayerid != INVALID_PLAYER_ID)
				    {
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[128];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result))
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ban <id/nick> <powód>");
							return 1;
						}
						BanPlayer(giveplayerid,GetPlayerNameEx(playerid),(result));
						return 1;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/afactionkick", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionkick [playerid/partofname] [reason]");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerConnected(giveplayerid))
				{
				    if(giveplayerid != INVALID_PLAYER_ID)
				    {
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[128];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result))
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /afactionkick [playerid/partofname] [reason]");
							return 1;
						}
						new form[128];
						format(form,sizeof(form),"%s zosta³ wyrzucony z frakcji przez %s, Powód: %s ",GetPlayerNameEx(giveplayerid),GetPlayerNameEx(playerid),(result));
						SendClientMessageToAll(COLOR_ADMINCMD,form);
						PlayerInfo[giveplayerid][pFaction] = 255;
						SetPlayerSpawn(giveplayerid);
						return 1;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Invalid ID.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/sluzba", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
				if (PlayerToPoint(5.0, playerid,PoliceDutyPosition[X],PoliceDutyPosition[Y],PoliceDutyPosition[Z]))
				{
				    if(GetPlayerVirtualWorld(playerid) == PoliceDutyPosition[World])
				    {
						if(CopOnDuty[playerid] == 0)
				        {
				            if(PlayerInfo[playerid][pSex] == 1)
				            {
								PlayerActionMessage(playerid,15.0,"przebiera siê w strój s³u¿bowy i zak³ada ekwipunek.");
							}
							else
							{
							    PlayerActionMessage(playerid,15.0,"przebiera siê w strój s³u¿bowy i zak³ada ekwipunek.");
							}
							GivePlayerWeapon(playerid, 24, 70);
							GivePlayerWeapon(playerid, 3, 0);
							GivePlayerWeapon(playerid, 41, 700);
							CopOnDuty[playerid] = 1;
							SetPlayerToFactionSkin(playerid);
							SetPlayerToFactionColor(playerid);
							format(string, sizeof(string), "[LSPD:] %s jest teraz na s³u¿bie.",GetPlayerNameEx(playerid));
		    				SendFactionTypeMessage(1, COLOR_LSPD, string);
							return 1;
						}
						else
						{
      						if(PlayerInfo[playerid][pSex] == 1)
				            {
								PlayerActionMessage(playerid,15.0,"odk³ada strój s³u¿bowy i ekwipunek.");
							}
							else
							{
							    PlayerActionMessage(playerid,15.0,"odk³ada strój s³u¿bowy i ekwipunek.");
							}
							ResetPlayerWeapons(playerid);
							CopOnDuty[playerid] = 0;
							SetPlayerToFactionSkin(playerid);
							SetPlayerToFactionColor(playerid);
							return 1;
						}
					}
				}
    			else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] To nie jest pozycja s³u¿by!");
					return 1;
				}
			}
   			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
				return 1;
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/poszukiwani", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	   	{
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
			    if(CopOnDuty[playerid])
			    {
			        new count = 0;
					SendClientMessage(playerid, COLOR_LIGHTGREEN, "-----------[Poszukiwani]-----------");
				    for(new i=0; i < MAX_PLAYERS; i++)
					{
						if(IsPlayerConnected(i))
						{
						    if(WantedLevel[i] >= 1)
						    {
						        format(string, sizeof(string), "[WANTED:] %s (ID:%d) -  Poziom poszukiwania: %d.",GetPlayerNameEx(i),i,WantedLevel[i]);
								SendClientMessage(playerid,COLOR_WHITE,string);
								count++;
							}
						}
					}
					if(count == 0)
					{
			    		SendClientMessage(playerid,COLOR_WHITE,"[INFO:] Brak poszukiwanych w bazie danych.");
					}
					SendClientMessage(playerid, COLOR_LIGHTGREEN, "------------------------------------------------");
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ na s³u¿bie!");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
			}
		}//not connected
		return 1;
	}
	if(strcmp(cmd, "/skuj", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
			    tmp = strtok(cmdtext, idx);
				if(!strlen(tmp)) {
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /kajdanki <id>");
					return 1;
				}
				if(CopOnDuty[playerid] == 0)
    			{
	        		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ na s³u¿bie.");
	        		return 1;
    			}
				giveplayerid = ReturnUser(tmp);
			    if(IsPlayerConnected(giveplayerid))
				{
				    if(giveplayerid != INVALID_PLAYER_ID)
				    {
					    if(PlayerCuffed[giveplayerid] == 1)
					    {
					        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz jest ju¿ skuty w kajdanki.");
					        return 1;
					    }
						if (ProxDetectorS(8.0, playerid, giveplayerid))
						{
						    if(giveplayerid == playerid) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿esz skuæ samego siebie w kajdanki!"); return 1; }
        					format(string, sizeof(string), "[INFO:] Skuty w kajdanki przez %s.", GetPlayerNameEx(playerid));
							SendClientMessage(giveplayerid, COLOR_RED, string);
							format(string, sizeof(string), "[INFO:] %s zosta³ skuty w kajdanki.", GetPlayerNameEx(giveplayerid));
							SendClientMessage(playerid, COLOR_WHITE, string);
							PlayerPlayerActionMessage(playerid,giveplayerid,15.0,"skuwa w kajdanki");
							TogglePlayerControllable(giveplayerid, 0);
							PlayerCuffed[giveplayerid] = 1;
						}
						else
						{
						    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz nie jest obok Ciebie!");
						    return 1;
						}
					}
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
				    return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/odkuj", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
			    tmp = strtok(cmdtext, idx);
				if(!strlen(tmp)) {
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /odkuj <id>");
					return 1;
				}
				if(CopOnDuty[playerid] == 0)
    			{
	        		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ na s³u¿bie.");
	        		return 1;
    			}
				giveplayerid = ReturnUser(tmp);
			    if(IsPlayerConnected(giveplayerid))
				{
				    if(giveplayerid != INVALID_PLAYER_ID)
				    {
					    if(PlayerCuffed[giveplayerid] == 0)
					    {
					        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz nie jest skuty w kajdanki.");
					        return 1;
					    }
						if (ProxDetectorS(8.0, playerid, giveplayerid))
						{
						    if(giveplayerid == playerid) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿esz odkuæ samego siebie"); return 1; }
        					format(string, sizeof(string), "[INFO:] Odkuty z kajdanek przez %s.", GetPlayerNameEx(playerid));
							SendClientMessage(giveplayerid, COLOR_RED, string);
							format(string, sizeof(string), "[INFO:] %s zosta³ odkuty z kajdanek.", GetPlayerNameEx(giveplayerid));
							SendClientMessage(playerid, COLOR_WHITE, string);
							PlayerPlayerActionMessage(playerid,giveplayerid,15.0,"odkuwa z kajdanek");
							TogglePlayerControllable(giveplayerid, 1);
							PlayerCuffed[giveplayerid] = 0;
						}
						else
						{
						    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz nie jest obok Ciebie!");
						    return 1;
						}
					}
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
				    return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
			}
		}
		return 1;
	}
  	if(strcmp(cmd,"/przeszukaj",true)==0)
    {
        if(IsPlayerConnected(playerid))
	    {
	        tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /przeszukaj <id>");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if(IsPlayerConnected(giveplayerid))
			{
				if(giveplayerid != INVALID_PLAYER_ID)
				{
				    if (ProxDetectorS(8.0, playerid, giveplayerid))
					{
					    if(giveplayerid == playerid) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿esz przeszukaæ samego siebie!"); return 1; }
					    if(CopOnDuty[playerid] == 0) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ na s³u¿bie."); return 1; }
					    new text1[128], text2[128];
					    if(PlayerInfo[giveplayerid][pDrugs] > 0) { text1 = "[FRISK:] Znaleziono narkotyki."; } else { text1 = "[FRISK:] Nie znaleziono narkotyków."; }
					    if(PlayerInfo[giveplayerid][pMaterials] > 0) { text2 = "[FRISK] Znaleziono materia³y na broñ."; } else { text2 = "[FRISK:] Nie znaleziono materia³ów na broñ."; }
					    format(string, sizeof(string), "-------------------[%s]-------------------", GetPlayerNameEx(giveplayerid));
				        SendClientMessage(playerid, COLOR_LIGHTGREEN, string);
				        format(string, sizeof(string), "%s", text1);
						SendClientMessage(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "%s", text2);
						SendClientMessage(playerid, COLOR_WHITE, string);
						new Player_Weapons[13];
						new Player_Ammos[13];
						new i;

						for(i = 1;i <= 12;i++)
						{
							GetPlayerWeaponData(giveplayerid,i,Player_Weapons[i],Player_Ammos[i]);
							if(Player_Weapons[i] != 0)
							{
								new weaponName[128];
								GetWeaponName(Player_Weapons[i],weaponName,255);
								format(string,255,"[FRISK:] Znaleziona broñ: %s.",weaponName);
								SendClientMessage(playerid,COLOR_WHITE,string);
							}
						}
						PlayerPlayerActionMessage(playerid,giveplayerid,15.0,"przeszukuje osobê");
					}
					else
					{
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Za daleko!");
					    return 1;
					}
				}
			}
	        else
	        {
	            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
	            return 1;
	        }
		}
	    return 1;
 	}
	if(strcmp(cmd, "/zabierz", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
	        {
	            new x_nr[256];
				x_nr = strtok(cmdtext, idx);
				if(!strlen(x_nr)) {
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /zabierz <przedmiot> <id>");
			  		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ITEM:] prawojazdy, lickapilot, lickabron, narkotyki, materialy, bron");
					return 1;
				}
			    if(strcmp(x_nr,"prawojazdy",true) == 0)
				{
				    tmp = strtok(cmdtext, idx);
					if(!strlen(tmp)) {
						SendClientMessage(playerid, COLOR_WHITE, "[USAGE:] /zabierz prawojazdy <id>");
						return 1;
					}
					giveplayerid = ReturnUser(tmp);
					if(IsPlayerConnected(giveplayerid))
					{
					    if(giveplayerid != INVALID_PLAYER_ID)
					    {
					        if (ProxDetectorS(8.0, playerid, giveplayerid))
							{
						        format(string, sizeof(string), "[INFO:] Prawojazdy %s zosta³o pomyœlnie zabrane.", GetPlayerNameEx(giveplayerid));
						        SendClientMessage(playerid, COLOR_WHITE, string);
						        format(string, sizeof(string), "[INFO:] %s zabra³ Ci prawojazdy.", GetPlayerNameEx(playerid));
						        SendClientMessage(giveplayerid, COLOR_RED, string);
						        PlayerInfo[giveplayerid][pCarLic] = 0;
							}
							else
							{
							    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz jest za daleko od Ciebie.");
							    return 1;
							}
					    }
					}
					else
					{
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
					    return 1;
					}
				}
				else if(strcmp(x_nr,"lickapilot",true) == 0)
				{
				    tmp = strtok(cmdtext, idx);
					if(!strlen(tmp)) {
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /zabierz lickapilot <id>");
						return 1;
					}
					giveplayerid = ReturnUser(tmp);
					if(IsPlayerConnected(giveplayerid))
					{
					    if(giveplayerid != INVALID_PLAYER_ID)
					    {
					        if (ProxDetectorS(8.0, playerid, giveplayerid))
							{
              					format(string, sizeof(string), "[INFO:] Zabra³eœ %s licencje pilota.", GetPlayerNameEx(giveplayerid));
						        SendClientMessage(playerid, COLOR_WHITE, string);
						        format(string, sizeof(string), "[INFO:] %s odebra³ Ci licencje pilota.", GetPlayerNameEx(playerid));
						        SendClientMessage(giveplayerid, COLOR_RED, string);
						        PlayerInfo[giveplayerid][pFlyLic] = 0;
							}
							else
							{
							    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz nie jest obok Ciebie.");
							    return 1;
							}
					    }
					}
					else
					{
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
					    return 1;
					}
				}
				else if(strcmp(x_nr,"lickabron",true) == 0)
				{
				    tmp = strtok(cmdtext, idx);
					if(!strlen(tmp)) {
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /zabierz lickabron <id>");
						return 1;
					}
					giveplayerid = ReturnUser(tmp);
					if(IsPlayerConnected(giveplayerid))
					{
					    if(giveplayerid != INVALID_PLAYER_ID)
					    {
					        if (ProxDetectorS(8.0, playerid, giveplayerid))
							{
						        format(string, sizeof(string), "[INFO:] Zabra³eœ licencje na broñ gracza %s .", GetPlayerNameEx(giveplayerid));
						        SendClientMessage(playerid, COLOR_WHITE, string);
						        format(string, sizeof(string), "[INFO:] %s zabra³Ci licencje na broñ.", GetPlayerNameEx(playerid));
						        SendClientMessage(giveplayerid, COLOR_RED, string);
						        PlayerInfo[giveplayerid][pWepLic] = 0;
					        }
					        else
							{
							    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz nie jest obok Ciebie.");
							    return 1;
							}
					    }
					}
					else
					{
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
					    return 1;
					}
				}
				else if(strcmp(x_nr,"narkotyki",true) == 0)
				{
				    tmp = strtok(cmdtext, idx);
					if(!strlen(tmp)) {
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /zabierz narkotyki <id>");
						return 1;
					}
					giveplayerid = ReturnUser(tmp);
					if(IsPlayerConnected(giveplayerid))
					{
					    if(giveplayerid != INVALID_PLAYER_ID)
					    {
					        if (ProxDetectorS(8.0, playerid, giveplayerid))
							{
							    format(string, sizeof(string), "[INFO:] Narkotyki gracza %s zabrane.", GetPlayerNameEx(giveplayerid));
						        SendClientMessage(playerid, COLOR_WHITE, string);
						        format(string, sizeof(string), "[INFO:] %s zabra³ Twoje narkotyki.", GetPlayerNameEx(playerid));
						        SendClientMessage(giveplayerid, COLOR_RED, string);
						        PlayerInfo[giveplayerid][pDrugs] = 0;
							}
					        else
							{
							    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz jest za daleko od Ciebie.");
							    return 1;
							}
					    }
					}
					else
					{
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
					    return 1;
					}
				}
				else if(strcmp(x_nr,"materialy",true) == 0)
				{
				    tmp = strtok(cmdtext, idx);
					if(!strlen(tmp)) {
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /zabierz materialy <id>");
						return 1;
					}
					giveplayerid = ReturnUser(tmp);
					if(IsPlayerConnected(giveplayerid))
					{
					    if(giveplayerid != INVALID_PLAYER_ID)
					    {
					        if (ProxDetectorS(8.0, playerid, giveplayerid))
							{
							    format(string, sizeof(string), "[INFO:] Materia³y na broñ gracza %s zabrane.", GetPlayerNameEx(giveplayerid));
						        SendClientMessage(playerid, COLOR_WHITE, string);
						        format(string, sizeof(string), "[INFO:] %s zabra³ Twoje materia³y na broñ.", GetPlayerNameEx(playerid));
						        SendClientMessage(giveplayerid, COLOR_RED, string);
						        PlayerInfo[giveplayerid][pMaterials] = 0;
							}
					        else
							{
							    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz jest za daleko od Ciebie.");
							    return 1;
							}
					    }
					}
					else
					{
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
					    return 1;
					}
				}
				else if(strcmp(x_nr,"bron",true) == 0)
				{
				    tmp = strtok(cmdtext, idx);
					if(!strlen(tmp)) {
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /zabierz bron <id>");
						return 1;
					}
					giveplayerid = ReturnUser(tmp);
					if(IsPlayerConnected(giveplayerid))
					{
					    if(giveplayerid != INVALID_PLAYER_ID)
					    {
					        if (ProxDetectorS(8.0, playerid, giveplayerid))
							{
							    format(string, sizeof(string), "[INFO:] Broñ gracza %s zabrana.", GetPlayerNameEx(giveplayerid));
						        SendClientMessage(playerid, COLOR_WHITE, string);
						        format(string, sizeof(string), "[INFO:] %s zabra³ Twoje bronie.", GetPlayerNameEx(playerid));
						        SendClientMessage(giveplayerid, COLOR_RED, string);
						        ResetPlayerWeapons(giveplayerid);
							}
					        else
							{
							    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz jest za daleko od Ciebie.");
							    return 1;
							}
					    }
					}
					else
					{
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
					    return 1;
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³y nick.");
					return 1;
				}
	        }
	        else
	        {
	            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
	            return 1;
	        }
	    }
	    return 1;
	}
	if(strcmp(cmd, "/par", true) ==0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
			    if(CopOnDuty[playerid] == 0)
			    {
			    	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ na s³u¿bie!");
			        return 1;
			    }
			    if(IsPlayerInAnyVehicle(playerid))
			    {
			        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿esz tego u¿yæ bêd¹c w samochodzie!");
			        return 1;
			    }
			    new suspect = GetClosestPlayer(playerid);
			    if(IsPlayerConnected(suspect))
				{
				    if(PlayerCuffed[suspect] == 1)
				    {
				        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ta osoba jest skuta!");
				        return 1;
				    }
				    if(GetDistanceBetweenPlayers(playerid,suspect) < 5)
					{
					    if(IsPlayerInAnyVehicle(suspect))
					    {
					        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz jest w pojeŸdzie!");
					        return 1;
					    }
						format(string, sizeof(string), "[INFO:] Sparali¿owany przez %s na 7 sekund.", GetPlayerNameEx(playerid));
						SendClientMessage(suspect, COLOR_RED, string);
						format(string, sizeof(string), "[INFO:] Sparali¿owa³eœ %s na 7 sekund.", GetPlayerNameEx(suspect));
						SendClientMessage(playerid, COLOR_WHITE, string);
						TogglePlayerControllable(suspect, 0);
						PlayerTazed[suspect] = 1;
						SetTimerEx("UntazePlayer", 7000, false, "i", suspect);
						PlayerPlayerActionMessage(playerid,suspect,15.0,"paralizuje");
		            }
					else
					{
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz jest za daleko.");
					    return 1;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
			}
		}//not connected
	    return 1;
	}
	if(strcmp(cmd, "/mandat", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
		        if(CopOnDuty[playerid] == 0)
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ na s³u¿bie!");
				    return 1;
				}
		    	tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /mandat <id> <koszt> <powód>");
					return 1;
				}
				giveplayerid = ReturnUser(tmp);
	            tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /mandat <id> <koszt> <powód>");
					return 1;
				}
				new moneys;
				moneys = strval(tmp);
				if(moneys < 1 || moneys > 99999) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a kwota."); return 1; }
				if(IsPlayerConnected(giveplayerid))
				{
				    if(giveplayerid != INVALID_PLAYER_ID)
				    {
				        if (ProxDetectorS(8.0, playerid, giveplayerid))
						{
							new length = strlen(cmdtext);
							while ((idx < length) && (cmdtext[idx] <= ' '))
							{
								idx++;
							}
							new offset = idx;
							new result[128];
							while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
							{
								result[idx - offset] = cmdtext[idx];
								idx++;
							}
							result[idx - offset] = EOS;
							if(!strlen(result))
							{
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /mandat <id> <koszt> <powód>");
								return 1;
							}
							format(string, sizeof(string), "[INFO:] Wypisa³eœ mandat graczowi %s za %d $ - Powód: %s.", GetPlayerNameEx(giveplayerid), moneys, (result));
							SendClientMessage(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "[INFO:] %s wypisa³ Ci mandat za %d $ - Powód: %s.", GetPlayerNameEx(playerid), moneys, (result));
							SendClientMessage(giveplayerid, COLOR_RED, string);
							SendClientMessage(giveplayerid, COLOR_LIGHTYELLOW2, "[INFO:] Wpisz /akceptuj mandat.");
							TicketOffer[giveplayerid] = playerid;
							TicketMoney[giveplayerid] = moneys;
							return 1;
						}
						else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz jest za daleko!");
							return 1;
						}
					}
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
				    return 1;
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/government", true) == 0 || strcmp(cmd, "/gov", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	    	if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
				if(PlayerInfo[playerid][pRank] != 1)
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Tylko lider mo¿e tego u¿yæ.");
				    return 1;
				}
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[64];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] [/gov]ernment <treœæ>");
					return 1;
				}
				if(CopOnDuty[playerid])
				{
					new faction = PlayerInfo[playerid][pFaction];
					SendClientMessageToAll(COLOR_LIGHTGREEN, "-----------------[Og³oszenie rz¹dowe]-----------------");
					format(string, sizeof(string), "%s %s: %s", DynamicFactions[faction][fRank1],GetPlayerNameEx(playerid), result);
					SendClientMessageToAll(COLOR_LSPD, string);
					SendClientMessageToAll(COLOR_LIGHTGREEN, "-------------------------------------------------------");
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ na s³u¿bie!");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/uwolnij", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
		    if(PlayerInfo[playerid][pJob] != 4)
		    {
		        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ adwokatem!");
		        return 1;
		    }
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /uwolnij <id>");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
            if(IsPlayerConnected(giveplayerid))
            {
                if(giveplayerid != INVALID_PLAYER_ID)
                {
                    if(giveplayerid == playerid) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿esz uwolniæ samego siebie."); return 1; }
					if(PlayerInfo[giveplayerid][pJailed] == 1)
					{
							if(GetDistanceBetweenPlayers(playerid,giveplayerid) < 5)
							{
								new jailtime = PlayerInfo[giveplayerid][pJailTime] / 60;
			    				if(jailtime < 7)
								{
									PlayerInfo[giveplayerid][pJailed] = 0;
									format(string, sizeof(string), "[INFO:] Zosta³eœ uwolniony przez %s.", GetPlayerNameEx(playerid));
									SendClientMessage(giveplayerid,COLOR_LIGHTYELLOW2, string);
									format(string, sizeof(string), "[INFO:] Uwolni³eœ %s.", GetPlayerNameEx(giveplayerid));
									SendClientMessage(playerid,COLOR_LIGHTYELLOW2, string);
									SetPlayerVirtualWorld(giveplayerid,2);
								    SetPlayerInterior(giveplayerid, 6);
									SetPlayerPos(giveplayerid,268.0903,77.6489,1001.0391);
								}
								else
								{
									SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Czas gracza w wiêzieniu musi wynosiæ 7 minut lub wy¿ej.");
								}
							}
							else
							{
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz nie jest obok Ciebie.");
							}
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz nie jest uwiêziony.");
					}
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/aresztuj", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	   	{
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
				if(CopOnDuty[playerid] == 0)
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ na s³u¿bie!");
				    return 1;
				}
		        if(!PlayerToPoint(15.0, playerid, PoliceArrestPosition[X],PoliceArrestPosition[Y],PoliceArrestPosition[Z]) || GetPlayerVirtualWorld(playerid) != PoliceArrestPosition[World])
				{// Jail spot
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Musisz byæ obok komisariatu!");
				    return 1;
				}
				tmp = strtok(cmdtext, idx);
				new time = strval(tmp);
				if(time < 1 || time > 45) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INFO:] Czas nie mo¿e byæ wy¿szy ni¿ 45 minut!"); return 1; }
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /aresztuj <czas>");
					return 1;
				}
				new suspect = GetClosestPlayer(playerid);
				if(IsPlayerConnected(suspect))
				{
					if(GetDistanceBetweenPlayers(playerid,suspect) < 5)
					{
						format(string, sizeof(string), "[INFO:] %s zosta³ aresztowany.", GetPlayerNameEx(suspect));
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
						ResetPlayerWeapons(suspect);
					    SetPlayerVirtualWorld(suspect,2); //BUILDING ID 2, MAKE SURE PD IS ID 2
					    SetPlayerInterior(suspect, 6);
						SetPlayerPos(suspect,264.5743,77.5118,1001.0391);
						PlayerInfo[suspect][pJailTime] = time * 60;
						format(string, sizeof(string), "[INFO:] Aresztowany - Czas: %d sekund.", PlayerInfo[suspect][pJailTime]);
						SendClientMessage(suspect, COLOR_LIGHTYELLOW2, string);
						format(string, sizeof(string), "[PD:] %s zaaresztowa³ kryminaliste %s.",GetPlayerNameEx(playerid), GetPlayerNameEx(suspect));
		    			SendFactionTypeMessage(1, COLOR_LSPD, string);
						PlayerInfo[suspect][pJailed] = 1;
						WantedPoints[suspect] = 0;
						ResetPlayerWantedLevelEx(suspect);
						new faction = PlayerInfo[playerid][pFaction];
						DynamicFactions[faction][fBank] += PlayerInfo[suspect][pJailTime];
						SaveDynamicFactions();
					}//distance
				}//not connected
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ obok kryminalisty!");
				    return 1;
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
			    return 1;
			}
		}//not connected
		return 1;
	}
	if(strcmp(cmd, "/megaphone", true) == 0 || strcmp(cmd, "/m", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			new tmpcar = GetPlayerVehicleID(playerid) - 1;
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "USAGE: [/m]egaphone <treœæ>");
				return 1;
			}
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
			    if(!IsPlayerInAnyVehicle(playerid))
			    {
			    	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w pojeŸdzie.");
					return 1;
			    }
		    	if(!CopOnDuty[playerid])
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ na s³u¿bie!");
					return 1;
				}
				if(DynamicCars[tmpcar][FactionCar] != PlayerInfo[playerid][pFaction])
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w frakcyjnym wozie.");
					return 1;
				}
				new rank = PlayerInfo[playerid][pRank];
				if(rank == 1)
				{
					format(string, sizeof(string), "[MEGAFON:] %s %s: %s!!", DynamicFactions[PlayerInfo[playerid][pFaction]][fRank1],GetPlayerNameEx(playerid), result);
					ProxDetector(60.0, playerid, string,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD);
					return 1;
				}
				else if(rank == 2)
				{
					format(string, sizeof(string), "[MEGAFON:] %s %s: %s!!", DynamicFactions[PlayerInfo[playerid][pFaction]][fRank2],GetPlayerNameEx(playerid), result);
					ProxDetector(60.0, playerid, string,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD);
					return 1;
				}
				else if(rank == 3)
				{
					format(string, sizeof(string), "[MEGAFON:] %s %s: %s!!", DynamicFactions[PlayerInfo[playerid][pFaction]][fRank3],GetPlayerNameEx(playerid), result);
					ProxDetector(60.0, playerid, string,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD);
					return 1;
				}
    			else if(rank == 4)
				{
					format(string, sizeof(string), "[MEGAFON:] %s %s: %s!!", DynamicFactions[PlayerInfo[playerid][pFaction]][fRank4],GetPlayerNameEx(playerid), result);
					ProxDetector(60.0, playerid, string,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD);
					return 1;
				}
				else if(rank == 5)
				{
					format(string, sizeof(string), "[MEGAFON:] %s %s: %s!!", DynamicFactions[PlayerInfo[playerid][pFaction]][fRank5],GetPlayerNameEx(playerid), result);
					ProxDetector(60.0, playerid, string,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD);
					return 1;
				}
    			else if(rank == 6)
				{
					format(string, sizeof(string), "[MEGAFON:] %s %s: %s!!", DynamicFactions[PlayerInfo[playerid][pFaction]][fRank6],GetPlayerNameEx(playerid), result);
					ProxDetector(60.0, playerid, string,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD);
					return 1;
				}
    			else if(rank == 7)
				{
					format(string, sizeof(string), "[MEGAFON:] %s %s: %s!!", DynamicFactions[PlayerInfo[playerid][pFaction]][fRank7],GetPlayerNameEx(playerid), result);
					ProxDetector(60.0, playerid, string,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD);
					return 1;
				}
    			else if(rank == 8)
				{
					format(string, sizeof(string), "[MEGAFON:] %s %s: %s!!", DynamicFactions[PlayerInfo[playerid][pFaction]][fRank8],GetPlayerNameEx(playerid), result);
					ProxDetector(60.0, playerid, string,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD);
					return 1;
				}
    			else if(rank == 9)
				{
					format(string, sizeof(string), "[MEGAFON:] %s %s: %s!!", DynamicFactions[PlayerInfo[playerid][pFaction]][fRank9],GetPlayerNameEx(playerid), result);
					ProxDetector(60.0, playerid, string,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD);
					return 1;
				}
    			else if(rank == 10)
				{
					format(string, sizeof(string), "[MEGAFON:] %s %s: %s!!", DynamicFactions[PlayerInfo[playerid][pFaction]][fRank10],GetPlayerNameEx(playerid), result);
					ProxDetector(60.0, playerid, string,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD,COLOR_LSPD);
					return 1;
				}
				return 1;
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
				return 1;
			}
		}
		return 1;
	}
	//=================================================[FACTION SYSTEM COMMANDS]================================================
 	if(strcmp(cmd, "/radio", true) == 0 || strcmp(cmd, "/r", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			new wstring[128];
			new faction = PlayerInfo[playerid][pFaction];
			new rank = PlayerInfo[playerid][pRank];
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] (/r)adio");
				return 1;
			}
			if(Muted[playerid])
			{
				SendClientMessage(playerid, COLOR_RED, "[ERROR:] Nie mo¿esz pisaæ, jesteœ uciszony.");
				return 1;
			}
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
					if(CopOnDuty[playerid])
					{
				 		if(rank == 1)
						{
						    format(wstring, sizeof(wstring), "[RADIO:] %s %s: %s, over.",DynamicFactions[faction][fRank1],GetPlayerNameEx(playerid),result);
						    SendFactionTypeMessage(1, COLOR_LSPD, wstring);
						    FactionChatLog(wstring);
						    PhoneAnimation(playerid);
						}
				 		else if(rank == 2)
						{
						    format(wstring, sizeof(wstring), "[RADIO:] %s %s: %s, over.",DynamicFactions[faction][fRank2],GetPlayerNameEx(playerid),result);
						    SendFactionTypeMessage(1, COLOR_LSPD, wstring);
						    FactionChatLog(wstring);
						    PhoneAnimation(playerid);
						}
				 		else if(rank == 3)
						{
						    format(wstring, sizeof(wstring), "[RADIO:] %s %s: %s, over.",DynamicFactions[faction][fRank3],GetPlayerNameEx(playerid),result);
						    SendFactionTypeMessage(1, COLOR_LSPD, wstring);
						    FactionChatLog(wstring);
						    PhoneAnimation(playerid);
						}
				 		else if(rank == 4)
						{
							format(wstring, sizeof(wstring), "[RADIO:] %s %s: %s, over.",DynamicFactions[faction][fRank4],GetPlayerNameEx(playerid),result);
						    SendFactionTypeMessage(1, COLOR_LSPD, wstring);
						    FactionChatLog(wstring);
						    PhoneAnimation(playerid);
						}
				 		else if(rank == 5)
						{
						    format(wstring, sizeof(wstring), "[RADIO:] %s %s: %s, over.",DynamicFactions[faction][fRank5],GetPlayerNameEx(playerid),result);
						    SendFactionTypeMessage(1, COLOR_LSPD, wstring);
						    FactionChatLog(wstring);
						    PhoneAnimation(playerid);
						}
				 		else if(rank == 6)
						{
						    format(wstring, sizeof(wstring), "[RADIO:] %s %s: %s, over.",DynamicFactions[faction][fRank6],GetPlayerNameEx(playerid),result);
						    SendFactionTypeMessage(1, COLOR_LSPD, wstring);
						    FactionChatLog(wstring);
						    PhoneAnimation(playerid);
						}
				 		else if(rank == 7)
						{
						    format(wstring, sizeof(wstring), "[RADIO:] %s %s: %s, over.",DynamicFactions[faction][fRank7],GetPlayerNameEx(playerid),result);
						    SendFactionTypeMessage(1, COLOR_LSPD, wstring);
						    FactionChatLog(wstring);
						    PhoneAnimation(playerid);
						}
				 		else if(rank == 8)
						{
						    format(wstring, sizeof(wstring), "[RADIO:] %s %s: %s, over.",DynamicFactions[faction][fRank8],GetPlayerNameEx(playerid),result);
						    SendFactionTypeMessage(1, COLOR_LSPD, wstring);
						    FactionChatLog(wstring);
						    PhoneAnimation(playerid);
						}
				 		else if(rank == 9)
						{
						    format(wstring, sizeof(wstring), "[RADIO:] %s %s: %s, over.",DynamicFactions[faction][fRank9],GetPlayerNameEx(playerid),result);
						    SendFactionTypeMessage(1, COLOR_LSPD, wstring);
						    FactionChatLog(wstring);
						    PhoneAnimation(playerid);
						}
				 		else if(rank == 10)
						{
						    format(wstring, sizeof(wstring), "[RADIO:] %s %s: %s, over.",DynamicFactions[faction][fRank10],GetPlayerNameEx(playerid),result);
						    SendFactionTypeMessage(1, COLOR_LSPD, wstring);
						    FactionChatLog(wstring);
						    PhoneAnimation(playerid);
						}
					}
		     		else
					{
						SendClientMessage(playerid,COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ na s³u¿bie!");
     				}
			}
			else
			{
				SendClientMessage(playerid,COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ cz³onkiem odpowiedniej frakcji.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/faction", true) == 0 || strcmp(cmd, "/f", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			new wstring[128];
			new faction = PlayerInfo[playerid][pFaction];
			new rank = PlayerInfo[playerid][pRank];
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] (/f)action");
				return 1;
			}
			if(Muted[playerid])
			{
				SendClientMessage(playerid, COLOR_RED, "[ERROR:] Nie mo¿esz mówiæ jesteœ uciszony.");
				return 1;
			}
			if(PlayerInfo[playerid][pFaction] != 255)
			{
			 		if(rank == 1)
					{
					    format(wstring, sizeof(wstring), "(( [F-OOC:] %s %s: %s ))",DynamicFactions[faction][fRank1],GetPlayerNameEx(playerid),result);
					    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, wstring);
					    FactionChatLog(wstring);
					    PhoneAnimation(playerid);
					}
			 		else if(rank == 2)
					{
					    format(wstring, sizeof(wstring), "(( [F-OOC:] %s %s: %s ))",DynamicFactions[faction][fRank2],GetPlayerNameEx(playerid),result);
					    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, wstring);
					    FactionChatLog(wstring);
					    PhoneAnimation(playerid);
					}
			 		else if(rank == 3)
					{
					    format(wstring, sizeof(wstring), "(( [F-OOC:] %s %s: %s ))",DynamicFactions[faction][fRank3],GetPlayerNameEx(playerid),result);
					    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, wstring);
					    FactionChatLog(wstring);
					    PhoneAnimation(playerid);
					}
			 		else if(rank == 4)
					{
					    format(wstring, sizeof(wstring), "(( [F-OOC:] %s %s: %s ))",DynamicFactions[faction][fRank4],GetPlayerNameEx(playerid),result);
					    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, wstring);
					    FactionChatLog(wstring);
					    PhoneAnimation(playerid);
					}
			 		else if(rank == 5)
					{
					    format(wstring, sizeof(wstring), "(( [F-OOC:] %s %s: %s ))",DynamicFactions[faction][fRank5],GetPlayerNameEx(playerid),result);
					    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, wstring);
					    FactionChatLog(wstring);
					    PhoneAnimation(playerid);
					}
			 		else if(rank == 6)
					{
					    format(wstring, sizeof(wstring), "(( [F-OOC:] %s %s: %s ))",DynamicFactions[faction][fRank6],GetPlayerNameEx(playerid),result);
					    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, wstring);
					    FactionChatLog(wstring);
					    PhoneAnimation(playerid);
					}
			 		else if(rank == 7)
					{
					    format(wstring, sizeof(wstring), "(( [F-OOC:] %s %s: %s ))",DynamicFactions[faction][fRank7],GetPlayerNameEx(playerid),result);
					    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, wstring);
					    FactionChatLog(wstring);
					    PhoneAnimation(playerid);
					}
			 		else if(rank == 8)
					{
					    format(wstring, sizeof(wstring), "(( [F-OOC:] %s %s: %s ))",DynamicFactions[faction][fRank8],GetPlayerNameEx(playerid),result);
					    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, wstring);
					    FactionChatLog(wstring);
					    PhoneAnimation(playerid);
					}
			 		else if(rank == 9)
					{
					    format(wstring, sizeof(wstring), "(( [F-OOC:] %s %s: %s ))",DynamicFactions[faction][fRank9],GetPlayerNameEx(playerid),result);
					    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, wstring);
					    FactionChatLog(wstring);
					    PhoneAnimation(playerid);
					}
			 		else if(rank == 10)
					{
					    format(wstring, sizeof(wstring), "(( [F-OOC:] %s %s: %s ))",DynamicFactions[faction][fRank10],GetPlayerNameEx(playerid),result);
					    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, wstring);
					    FactionChatLog(wstring);
                        PhoneAnimation(playerid);
					}
			}
			else
			{
				SendClientMessage(playerid,COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ cz³onkiem frakcji!");
			}
		}
		return 1;
	}
    if(strcmp(cmd, "/zapros", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /zapros <id/nick>");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if (PlayerInfo[playerid][pRank] == 1 && PlayerInfo[playerid][pFaction] != 255)
			{
			    if(PlayerInfo[giveplayerid][pFaction] == 255)
			    {
					if(IsPlayerConnected(giveplayerid))
					{
					    if(giveplayerid != INVALID_PLAYER_ID)
					    {
					        new form[128];
					        new faction = PlayerInfo[playerid][pFaction];
							if(gPlayerLogged[giveplayerid])
							{
						        if(DynamicFactions[faction][fJoinRank] == 0)
						        {
						            SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Nie ma ustalonej rangi pocz¹tkowej, skontaktuj siê z administratorem poziomu 3.");
						        }
						        else
						        {
									FactionRequest[giveplayerid] = faction;
									format(form,sizeof(form),"Zosta³eœ zaproszony do frakcji %s przez %s. (Wpisz /akceptuj frakcja - jeœli chcesz do³¹czyæ do frakcji.) ",DynamicFactions[faction][fName],GetPlayerNameEx(playerid));
									SendClientMessage(giveplayerid,COLOR_LIGHTBLUE,form);
									format(form,sizeof(form),"Zaprosi³eœ %s do do³¹czenia do %s. ",GetPlayerNameEx(giveplayerid),DynamicFactions[faction][fName]);
									SendClientMessage(playerid,COLOR_LIGHTBLUE,form);
								}
								return 1;
							}
							else
							{
							    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Ten gracz nie jest zalogowany!");
							}
						}
					}
		 			else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
					}
				}
 				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz ma zaproszenie od innej frakcji lub ma ju¿ frakcje.");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ liderem!");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/wyrzuc", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /wyrzuc <id/nick>");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if (PlayerInfo[playerid][pRank] == 1 && PlayerInfo[playerid][pFaction] != 255)
			{
			    if(PlayerInfo[giveplayerid][pFaction] == PlayerInfo[playerid][pFaction])
				{
					if(IsPlayerConnected(giveplayerid))
					{
     					if(gPlayerLogged[giveplayerid])
     					{
						    if(giveplayerid != INVALID_PLAYER_ID)
						    {
						        new form[128];
						        new faction = PlayerInfo[playerid][pFaction];
								format(form,sizeof(form),"Zosta³eœ wyrzucony z %s przez %s.",DynamicFactions[faction][fName],GetPlayerNameEx(playerid));
								SendClientMessage(giveplayerid,COLOR_LIGHTBLUE,form);
								format(form,sizeof(form),"Wyrzuci³eœ %s z %s.",GetPlayerNameEx(giveplayerid),DynamicFactions[faction][fName]);
								SendClientMessage(playerid,COLOR_LIGHTBLUE,form);
								PlayerInfo[giveplayerid][pFaction] = 255;
								PlayerInfo[giveplayerid][pRank] = 0;
								SetPlayerSpawn(giveplayerid);
								format(form, sizeof(form), "[FACTION:] %s zosta³ wyrzucony z frakcji przez %s.",GetPlayerNameEx(giveplayerid),GetPlayerNameEx(playerid));
								SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, form);
								return 1;
							}
						}
	      				else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz nie jest zalogowany.");
						}
					}
		 			else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
					}
				}
 				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz nie jest w Twojej frakcji.");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ liderem!");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/zmienrange", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /zmienrange <id/nick> <ranga>");
				return 1;
			}
			new para1;
			new level;
			para1 = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			level = strval(tmp);
			if (PlayerInfo[playerid][pRank] == 1 && PlayerInfo[playerid][pFaction] != 255)
			{
				if (PlayerInfo[para1][pFaction] == PlayerInfo[playerid][pFaction])
				{
					new faction = PlayerInfo[playerid][pFaction];
					if (level)
					{
		   				if(level > 1 && level <= DynamicFactions[faction][fRankAmount])
					    {
		  					if(IsPlayerConnected(para1))
			    			{
								if(gPlayerLogged[para1])
								{
									if(para1 != INVALID_PLAYER_ID)
									{
										PlayerInfo[para1][pRank] = level;
										format(string, sizeof(string), "[INFO:] Twoja ranga zosta³a zmieniona przez: %s, od teraz jesteœ: %d.", GetPlayerNameEx(playerid),level);
										SendClientMessage(para1, COLOR_LIGHTBLUE, string);
										format(string, sizeof(string), "[INFO:] Zmieni³eœ range %s, od teraz jego ranga to: %d.", GetPlayerNameEx(para1),level);
										SendClientMessage(playerid, COLOR_YELLOW, string);
										SetPlayerToFactionSkin(para1);

										if(PlayerInfo[para1][pSex] == 1)
										{
											format(string, sizeof(string), "[FACTION:] %s otrzyma³ now¹ range, od teraz ma range poziomu: %d.",GetPlayerNameEx(para1), level);
											SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, string);
										}
										else
										{
											format(string, sizeof(string), "[FACTION:] %s otrzyma³a now¹ range, od teraz ma range poziomu: %d.",GetPlayerNameEx(para1), level);
											SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, string);
										}
									}
								}
								else
								{
									SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz nie jest zalogowany!");
								}
							}
							else
							{
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID lub gracz nie jest zalogowany.");
							}
						}
						else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie ma takiej rangi.");
						}
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Podaj jak¹œ wartoœæ!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ten gracz nie jest w Twojej frakcji.");
				}
			}
			else
   			{

				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ liderem.");
			}
		}
		return 1;
	}
	//==========================================================================================================================
    if(strcmp(cmd, "/kick", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /kick <id/nick> <powód>");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				if(IsPlayerConnected(giveplayerid))
				{
				    if(giveplayerid != INVALID_PLAYER_ID)
				    {
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[128];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result))
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /kick <id/nick> <powód>");
							return 1;
						}
						KickPlayer(giveplayerid,GetPlayerNameEx(playerid),(result));
						return 1;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/alistfaction", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /alistfaction <id>");
				return 1;
			}
			new text = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
			 	new wstring[128];
			    format(wstring, sizeof(wstring), "[ID:%d] Nazwa: %s - Materia³y: %d - Narkotyki: %d - Pieni¹dze: $%d - pRanga: %d - uSkiny: %d - Typ: %d",text, DynamicFactions[text][fName],DynamicFactions[text][fMaterials],DynamicFactions[text][fDrugs],DynamicFactions[text][fBank],DynamicFactions[text][fJoinRank],DynamicFactions[text][fUseSkins],DynamicFactions[text][fType]);
			    SendClientMessage(playerid,COLOR_ADMINCMD, wstring);
			    format(wstring, sizeof(wstring), "[ID:%d] Skiny: %d|%d|%d|%d|%d|%d|%d|%d|%d|%d - Iloœæ rang: %d - uKolor: %d", text,DynamicFactions[text][fSkin1],DynamicFactions[text][fSkin2],DynamicFactions[text][fSkin3],DynamicFactions[text][fSkin4],DynamicFactions[text][fSkin5],DynamicFactions[text][fSkin6],DynamicFactions[text][fSkin7],DynamicFactions[text][fSkin8],DynamicFactions[text][fSkin9],DynamicFactions[text][fSkin10],DynamicFactions[text][fRankAmount],DynamicFactions[text][fUseColor]);
			    SendClientMessage(playerid,COLOR_ADMINCMD, wstring);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED,"Nie jesteœ administratorem lub masz za ma³y poziom.");
			}
		}
		return 1;
	}
	//---------------------------------------------------[DYNAMIC CAR SYSTEM]------------------------------------------------
	/*
  	if(strcmp(cmd, "/resetallbusinesses", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] < 1338)
			return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Your not an administrator.");
		new	i, pmodel,
			Float:distance = 1.5,
			Float:metres = distance;
		for(; i < sizeof(Businesses); i++, metres += distance)
		{
		    new Float:a;
			GetPlayerPos(playerid, Businesses[i][EnterX], Businesses[i][EnterY], Businesses[i][EnterZ]);
			GetPlayerFacingAngle(playerid, a);
			Businesses[i][EnterX] += (metres * floatsin(-a, degrees));
			Businesses[i][EnterY] += (metres * floatcos(-a, degrees));
			Businesses[i][EnterWorld] = 0;
			Businesses[i][EnterInterior] = 0;
			Businesses[i][EnterAngle] = a;
			Businesses[i][ExitX] = 0.0;
			Businesses[i][ExitY] = 0.0;
			Businesses[i][ExitZ] = 0.0;
			Businesses[i][ExitInterior] = 0;
			Businesses[i][ExitAngle] = 0.0;
			Businesses[i][Owned] = 0;
			Businesses[i][Enterable] = 0;
			Businesses[i][BizPrice] = 0;
			Businesses[i][Till] = 0;
			Businesses[i][Locked] = 1;
			Businesses[i][BizType] = 0;
			Businesses[i][Products] = 0;
			strmid(Businesses[i][BusinessName], "None", 0, strlen("None"), 255);
			strmid(Businesses[i][Owner], "None", 0, strlen("None"), 255);
			Businesses[i][EnterInterior] = 0;
			switch(Businesses[i][Owned])
			{
				case 0: pmodel = 1272;
				case 1: pmodel = 1239;
			}
			ChangeStreamPickupModel(Businesses[i][PickupID],pmodel);
		}
		SaveBusinesses();
		return 1;
	}
  	if(strcmp(cmd, "/resetallbuildings", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] < 1338)
			return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Your not an administrator.");
		new	i,
			Float:distance = 1.5,
			Float:metres = distance;
		for(; i < sizeof(Building); i++, metres += distance)
		{
		    new Float:a;
			GetPlayerPos(playerid, Building[i][EnterX], Building[i][EnterY], Building[i][EnterZ]);
			GetPlayerFacingAngle(playerid, a);
			strmid(Building[i][BuildingName], "None", 0, strlen("None"), 255);
			Building[i][EnterX] += (metres * floatsin(-a, degrees));
			Building[i][EnterY] += (metres * floatcos(-a, degrees));
			Building[i][EnterAngle] = a;
			Building[i][EnterWorld] = 0;
			Building[i][EnterInterior] = 0;
			Building[i][EntranceFee] = 0;
			Building[i][ExitX] = 0.0;
			Building[i][ExitY] = 0.0;
			Building[i][ExitZ] = 0.0;
			Building[i][ExitInterior] = 0;
			Building[i][ExitAngle] = 0.0;
			Building[i][Locked] = 1;
			ChangeStreamPickupModel(Building[i][PickupID],1239);
		}
		SaveBuildings();
		return 1;
	}
 	if(strcmp(cmd, "/resetallhouses", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] < 1338)
			return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Your not an administrator.");
		new	i, pmodel,
			Float:distance = 1.5,
			Float:metres = distance;
		for(; i < sizeof(Houses); i++, metres += distance)
		{
		    new Float:a;
			GetPlayerPos(playerid, Houses[i][EnterX], Houses[i][EnterY], Houses[i][EnterZ]);
			GetPlayerFacingAngle(playerid, a);
			Houses[i][EnterX] += (metres * floatsin(-a, degrees));
			Houses[i][EnterY] += (metres * floatcos(-a, degrees));
			Houses[i][EnterWorld] = 0;
			Houses[i][EnterInterior] = 0;
			Houses[i][EnterAngle] = a;
			Houses[i][ExitX] = 0.0;
			Houses[i][ExitY] = 0.0;
			Houses[i][ExitZ] = 0.0;
			Houses[i][ExitInterior] = 0;
			Houses[i][ExitAngle] = 0.0;
			Houses[i][Owned] = 0;
			Houses[i][Rentable] = 0;
			Houses[i][RentCost] = 0;
			Houses[i][HousePrice] = 0;
			Houses[i][Materials] = 0;
			Houses[i][Drugs] = 0;
			Houses[i][Money] = 0;
			Houses[i][Locked] = 1;

			strmid(Houses[i][Description], "None", 0, strlen("None"), 255);
			strmid(Houses[i][Owner], "None", 0, strlen("None"), 255);
			switch(Houses[i][Owned])
			{
				case 0: pmodel = 1273;
				case 1: pmodel = 1239;
			}
			ChangeStreamPickupModel(Houses[i][PickupID],pmodel);
		}
		SaveHouses();
		return 1;
	}
  	if(strcmp(cmd, "/resetallvehicles", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] < 1338)
			return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Your not an administrator.");
		new	i,
			Float:distance = 6.0,
			Float:metres = distance;
		for(; i < sizeof(DynamicCars); i++, metres += distance)
		{
			GetPlayerPos(playerid, DynamicCars[i][CarX], DynamicCars[i][CarY], DynamicCars[i][CarZ]);
			new Float:a;
			GetPlayerFacingAngle(playerid, a);
			DynamicCars[i][CarColor1] = -1;
			DynamicCars[i][CarColor2] = -1;
			DynamicCars[i][FactionCar] = 255;
			DynamicCars[i][CarType] = 0;
			DynamicCars[i][CarAngle] = a;
			DynamicCars[i][CarModel] = 400; //Jeep
			DynamicCars[i][CarX] += (metres * floatsin(-a, degrees));
			DynamicCars[i][CarY] += (metres * floatcos(-a, degrees));
			DestroyVehicle(i);
			CreateVehicle(DynamicCars[i][CarModel],DynamicCars[i][CarX],DynamicCars[i][CarY],DynamicCars[i][CarZ],DynamicCars[i][CarAngle],DynamicCars[i][CarColor1],DynamicCars[i][CarColor2], -1);
			Fuel[i] = GasMax;
			EngineStatus[i] = 0;
			VehicleLocked[i] = 0;
			CarWindowStatus[i] = 1; //1 = up, 0 = down.
		}
		SaveDynamicCars();
		return 1;
	}
 	if(strcmp(cmd, "/masscarmodelrandom", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] < 1338)
			return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Your not an administrator.");
			new i;
		for(; i < sizeof(DynamicCars); i++)
		{
		    new rand = random(sizeof(RandomStableModels));
			DynamicCars[i][CarModel] = RandomStableModels[rand][0];
			DestroyVehicle(i);
			CreateVehicle(DynamicCars[i][CarModel],DynamicCars[i][CarX],DynamicCars[i][CarY],DynamicCars[i][CarZ],DynamicCars[i][CarAngle],DynamicCars[i][CarColor1],DynamicCars[i][CarColor2], -1);
			Fuel[i] = GasMax;
			EngineStatus[i] = 0;
			VehicleLocked[i] = 0;
			CarWindowStatus[i] = 1; //1 = up, 0 = down.
		}
		SaveDynamicCars();
		return 1;
	}
	if(strcmp(cmd, "/masscarmove", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] < 1338)
			return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Your not an administrator.");
		new	i,
			Float:distance = 6.0,
			Float:metres = distance;
		for(; i < sizeof(DynamicCars); i++, metres += distance)
		{
			GetPlayerPos(playerid, DynamicCars[i][CarX], DynamicCars[i][CarY], DynamicCars[i][CarZ]);
			GetPlayerFacingAngle(playerid, DynamicCars[i][CarAngle]);
			DynamicCars[i][CarX] += (metres * floatsin(-DynamicCars[i][CarAngle], degrees));
			DynamicCars[i][CarY] += (metres * floatcos(-DynamicCars[i][CarAngle], degrees));
			DestroyVehicle(i);
			CreateVehicle(DynamicCars[i][CarModel],DynamicCars[i][CarX],DynamicCars[i][CarY],DynamicCars[i][CarZ],DynamicCars[i][CarAngle],DynamicCars[i][CarColor1],DynamicCars[i][CarColor2], -1);
			Fuel[i] = GasMax;
			EngineStatus[i] = 0;
			VehicleLocked[i] = 0;
			CarWindowStatus[i] = 1; //1 = up, 0 = down.
		}
		SaveDynamicCars();
		return 1;
	}
	if(strcmp(cmd, "/masshousemove", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] < 1338)
			return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Your not an administrator.");
		new	i, pmodel,
			Float:distance = 1.5,
			Float:metres = distance;
		for(; i < sizeof(Houses); i++, metres += distance)
		{
		    new Float:a;
			GetPlayerPos(playerid, Houses[i][EnterX], Houses[i][EnterY], Houses[i][EnterZ]);
			GetPlayerFacingAngle(playerid, a);
			Houses[i][EnterX] += (metres * floatsin(-a, degrees));
			Houses[i][EnterY] += (metres * floatcos(-a, degrees));
			Houses[i][EnterWorld] = GetPlayerVirtualWorld(playerid);
			Houses[i][EnterInterior] = GetPlayerInterior(playerid);
			switch(Houses[i][Owned])
			{
				case 0: pmodel = 1273;
				case 1: pmodel = 1239;
			}
			ChangeStreamPickupModel(Houses[i][PickupID],pmodel);
		}
		SaveHouses();
		return 1;
	}
 	if(strcmp(cmd, "/massbuildingmove", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] < 1338)
			return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Your not an administrator.");
		new	i,
			Float:distance = 1.5,
			Float:metres = distance;
		for(; i < sizeof(Building); i++, metres += distance)
		{
		    new Float:a;
			GetPlayerPos(playerid, Building[i][EnterX], Building[i][EnterY], Building[i][EnterZ]);
			GetPlayerFacingAngle(playerid, a);
			Building[i][EnterX] += (metres * floatsin(-a, degrees));
			Building[i][EnterY] += (metres * floatcos(-a, degrees));
			Building[i][EnterWorld] = GetPlayerVirtualWorld(playerid);
			Building[i][EnterInterior] = GetPlayerInterior(playerid);
			ChangeStreamPickupModel(Building[i][PickupID],1239);
		}
		SaveBuildings();
		return 1;
	}
 	if(strcmp(cmd, "/massbusinessmove", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] < 1338)
			return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Your not an administrator.");
		new	i, pmodel,
			Float:distance = 1.5,
			Float:metres = distance;
		for(; i < sizeof(Businesses); i++, metres += distance)
		{
		    new Float:a;
			GetPlayerPos(playerid, Businesses[i][EnterX], Businesses[i][EnterY], Businesses[i][EnterZ]);
			GetPlayerFacingAngle(playerid, a);
			Businesses[i][EnterX] += (metres * floatsin(-a, degrees));
			Businesses[i][EnterY] += (metres * floatcos(-a, degrees));
			Businesses[i][EnterWorld] = GetPlayerVirtualWorld(playerid);
			Businesses[i][EnterInterior] = GetPlayerInterior(playerid);
			switch(Businesses[i][Owned])
			{
				case 0: pmodel = 1272;
				case 1: pmodel = 1239;
			}
			ChangeStreamPickupModel(Businesses[i][PickupID],pmodel);
		}
		SaveBusinesses();
		return 1;
	}*/
	if(strcmp(cmd, "/acarsetpos", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /acarsetpos <carid>");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
			    if(id != INVALID_VEHICLE_ID)
			    {
					new Float:x,Float:y,Float:z;
					new Float:a;
					GetPlayerPos(playerid, x, y, z);
					if(IsPlayerInAnyVehicle(playerid))
					{
						GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
					}
					else
					{
					    GetPlayerFacingAngle(playerid, a);
					}
					DynamicCars[id-1][CarX] = x;
					DynamicCars[id-1][CarY] = y;
					DynamicCars[id-1][CarZ] = z;
					DynamicCars[id-1][CarAngle] = a;
					DestroyVehicle(id);
					CreateVehicle(DynamicCars[id-1][CarModel],DynamicCars[id-1][CarX],DynamicCars[id-1][CarY],DynamicCars[id-1][CarZ],DynamicCars[id-1][CarAngle],DynamicCars[id-1][CarColor1],DynamicCars[id-1][CarColor2], -1);
					SaveDynamicCars();
					//PutPlayerInVehicle(playerid,id,0);
				 	new wstring[128];
				    format(wstring, sizeof(wstring), "Pojazd ID: %d ma now¹ pozycje.", id);
				    SendClientMessage(playerid,COLOR_ADMINCMD, wstring);
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/respawnvehicles", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			for(new i=0;i<MAX_VEHICLES;i++)
			{
			    if(IsVehicleOccupied(i) == 0)
			    {
			        SetVehicleToRespawn(i);
			    }
			}
			format(string, sizeof(string), "[INFO:] Pojazdy przywrócone na swoje poczatkowe pozycje przez %s.", GetPlayerNameEx(playerid));
   			SendClientMessageToAll(COLOR_ADMINCMD, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
		}
		return 1;
	}
	if(strcmp(cmd, "/acarenter", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /acarenter [carid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(id != INVALID_VEHICLE_ID)
			    {
					PutPlayerInVehicle(playerid,id,0);
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/acarpark", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
			    if(IsPlayerInAnyVehicle(playerid))
			    {
				    new vehicleid = GetPlayerVehicleID(playerid);
				    new car = GetPlayerVehicleID(playerid) - 1;
					new Float:x,Float:y,Float:z;
					new Float:a;
					GetVehiclePos(vehicleid, x, y, z);
					GetVehicleZAngle(vehicleid, a);
					DynamicCars[car][CarX] = x;
					DynamicCars[car][CarY] = y;
					DynamicCars[car][CarZ] = z;
					DynamicCars[car][CarAngle] = a;
					DestroyVehicle(vehicleid);
					CreateVehicle(DynamicCars[car][CarModel],DynamicCars[car][CarX],DynamicCars[car][CarY],DynamicCars[car][CarZ],DynamicCars[car][CarAngle],DynamicCars[car][CarColor1],DynamicCars[car][CarColor2], -1);
					PutPlayerInVehicle(playerid,vehicleid,0);
					SaveDynamicCars();

				 	new wstring[128];
				    format(wstring, sizeof(wstring), "Zaparkowano pojazd ID: %d.", vehicleid);
				    SendClientMessage(playerid,COLOR_ADMINCMD, wstring);
	    		}
    			else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ w pojeŸdzie!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/acarfaction", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "USAGE: /acarfaction [faction]");
				return 1;
			}
			new thecar = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
 					if(thecar < 11 || 255)
 					{
						new car = GetPlayerVehicleID(playerid) - 1;
						new vehicleid = GetPlayerVehicleID(playerid);
						DynamicCars[car][FactionCar] = thecar;
			 			new wstring[128];
					    format(wstring, sizeof(wstring), "Pojazd ID %d ma frakcje ID: %d.", vehicleid,thecar);
					    SendClientMessage(playerid,COLOR_ADMINCMD, wstring);
					    SaveDynamicCars();
				    }
		   			else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Z³e ID frakcji.");
					}
				}
 				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ w pojeŸdzie!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/acartype", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "USAGE: /acartype [type]");
				return 1;
			}
			new thecar = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
					new car = GetPlayerVehicleID(playerid) - 1;
					new vehicleid = GetPlayerVehicleID(playerid);
					DynamicCars[car][CarType] = thecar;
		 			new wstring[128];
				    format(wstring, sizeof(wstring), "Pojazd ID %d | Typ: %d.", vehicleid,thecar);
				    SendClientMessage(playerid,COLOR_ADMINCMD, wstring);
		    		SaveDynamicCars();
				}
 				else
				{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ w pojeŸdzie!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/acarmodel", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "USAGE: /acarmodel [modelid]");
				return 1;
			}
			new thecar = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
 					if(thecar > 399 && thecar < 612)
 					{
					new car = GetPlayerVehicleID(playerid) - 1;
					new vehicleid = GetPlayerVehicleID(playerid);
					DynamicCars[car][CarModel] = thecar;
		 			new wstring[128];
				    format(wstring, sizeof(wstring), "PojazdID %d | Model: %d.", vehicleid,thecar);
				    SendClientMessage(playerid,COLOR_ADMINCMD, wstring);
   					new Float:cx,Float:cy,Float:cz;
   					GetVehiclePos(vehicleid,cx,cy,cz);
   					new Float:angle;
   					GetVehicleZAngle(vehicleid, angle);
					DestroyVehicle(vehicleid);
					CreateVehicle(DynamicCars[car][CarModel],DynamicCars[car][CarX],DynamicCars[car][CarY],DynamicCars[car][CarZ],DynamicCars[car][CarAngle],DynamicCars[car][CarColor1],DynamicCars[car][CarColor2], -1);
					PutPlayerInVehicle(playerid,vehicleid,0);
					SetVehiclePos(vehicleid, cx, cy, cz);
     				SetVehicleZAngle(vehicleid, angle);
				    SaveDynamicCars();
				    }
		   			else
					{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nieprawid³owy model, wpisz ID: 400-611.");
					}
				}
 				else
				{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ w pojeŸdzie!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/acarcolor", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "USAGE: /acarcolor [colorid] [colorid]");
				return 1;
			}
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
					new color1;
					color1 = strval(tmp);
					if(color1 < 0 || color1 > 126) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] 0-126 - to prawid³owe id kolorów."); return 1; }
					tmp = strtok(cmdtext, idx);
					if(!strlen(tmp))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "USAGE: /acarcolor [colorid] [colorid]");
						return 1;
					}
					new color2;
					color2 = strval(tmp);
					if(color2 < 0 || color2 > 126) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] 0-126 - to prawid³owe id kolorów."); return 1; }

					new car = GetPlayerVehicleID(playerid) - 1;
					new vehicleid = GetPlayerVehicleID(playerid);
					DynamicCars[car][CarColor1] = color1;
					DynamicCars[car][CarColor2] = color2;
					new wstring[128];
		   			format(wstring, sizeof(wstring), "Pojazd %d | Kolor: %d | Kolor2: %d.", vehicleid,color1,color2);
				    SendClientMessage(playerid,COLOR_ADMINCMD, wstring);
   					new Float:cx,Float:cy,Float:cz;
   					GetVehiclePos(vehicleid,cx,cy,cz);
   					new Float:angle;
   					GetVehicleZAngle(vehicleid, angle);
        			DestroyVehicle(vehicleid);
					CreateVehicle(DynamicCars[car][CarModel],DynamicCars[car][CarX],DynamicCars[car][CarY],DynamicCars[car][CarZ],DynamicCars[car][CarAngle],DynamicCars[car][CarColor1],DynamicCars[car][CarColor2], -1);
					PutPlayerInVehicle(playerid,vehicleid,0);
					SetVehiclePos(vehicleid, cx, cy, cz);
     				SetVehicleZAngle(vehicleid, angle);
				    SaveDynamicCars();
				}
 				else
				{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ w pojeŸdzie!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
//--------------------------------------------------------------------------------------------------------------------------
//=====================================================================================================================
	if(strcmp(cmd,"/akceptuj",true)==0)
	{
 	if(IsPlayerConnected(playerid))
 	{
		new x_info[128];
		x_info = strtok(cmdtext, idx);
	    new wstring[128];

		if(!strlen(x_info)) {
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /akceptuj <czynnoœæ>");
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGES:] frakcja - mandat - produkty");
			return 1;
		}
		if(strcmp(x_info,"faction",true) == 0)
		{
		    new faction = FactionRequest[playerid];
			if (FactionRequest[playerid] != 255)
			{
				if(PlayerInfo[playerid][pFaction] == 255)
				{
	   				format(wstring, sizeof(wstring), "[INFO:] Gratulacje! Jesteœ cz³onkiem: %s.",DynamicFactions[faction][fName]);
				    SendClientMessage(playerid,COLOR_LIGHTBLUE, wstring);
					PlayerInfo[playerid][pFaction] = FactionRequest[playerid];
					PlayerInfo[playerid][pRank] = DynamicFactions[faction][fJoinRank];
					SetPlayerSpawn(playerid);
					FactionRequest[playerid] = 255;
					format(wstring, sizeof(wstring), "[FACTION:] %s do³¹czy³ do frakcji.",GetPlayerNameEx(playerid));
					SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, wstring);
				}
				else
				{
					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Jesteœ ju¿ cz³onkiem frakcji!");
				}
			}
			else
			{
			    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Nie masz oferty do³¹czenia do frakcji!");
			}
		}
  		else if(strcmp(x_info,"mandat",true) == 0)
				{
			    if(TicketOffer[playerid] < 999)
			    {
			        if(IsPlayerConnected(TicketOffer[playerid]))
			        {
			            if (ProxDetectorS(5.0, playerid, TicketOffer[playerid]))
						{
							if(GetPlayerCash(playerid) >= TicketMoney[playerid])
						    {
								format(string, sizeof(string), "[INFO:] Mandat - Koszt: %d $.", TicketMoney[playerid]);
								SendClientMessage(playerid, COLOR_WHITE, string);
								format(string, sizeof(string), "[INFO:] %s wystawia mandat - Koszt: %d $.", GetPlayerNameEx(playerid), TicketMoney[playerid]);
								SendClientMessage(TicketOffer[playerid], COLOR_LIGHTYELLOW2, string);
								new faction = PlayerInfo[TicketOffer[playerid]][pFaction];
								DynamicFactions[faction][fBank] += TicketMoney[playerid];
								GivePlayerCash(playerid, - TicketMoney[playerid]);
								TicketOffer[playerid] = 999;
								TicketMoney[playerid] = 0;
								return 1;
							}
							else
							{
							    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle pieniêdzy!");
							    return 1;
							}
						}
						else
						{
						    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Musisz byæ obok policjanta!");
						    return 1;
						}
			        }
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz mandatu do zap³aty!");
				    return 1;
				}
			}
     		else if(strcmp(x_info,"produkty",true) == 0)
				{
			    if(ProductsOffer[playerid] < 999)
			    {
			        if(IsPlayerConnected(ProductsOffer[playerid]))
			        {
			            if (ProxDetectorS(5.0, playerid, ProductsOffer[playerid]))
						{
						    if(GetPlayerCash(playerid) >= ProductsCost[playerid])
						    {
								if(PlayerInfo[playerid][pBizKey] != 255)
								{
									format(string, sizeof(string), "[INFO:] Produkty - Koszt: %d $.", ProductsCost[playerid]);
									SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
									format(string, sizeof(string), "[INFO:] %s oferuje produkty do biznesu - Koszt: %d $.", GetPlayerNameEx(playerid), ProductsCost[playerid]);
									SendClientMessage(ProductsOffer[playerid], COLOR_LIGHTYELLOW2, string);
									new bizkey = PlayerInfo[playerid][pBizKey];
									Businesses[bizkey][Products] += ProductsAmount[playerid];
									GivePlayerCash(playerid, -ProductsCost[playerid]);
									GivePlayerCash(ProductsOffer[playerid], ProductsCost[playerid]);
									PlayerInfo[ProductsOffer[playerid]][pProducts] -= ProductsAmount[playerid];
									ProductsOffer[playerid] = 999;
									ProductsCost[playerid] = 0;
									ProductsAmount[playerid] = 0;
									SaveBusinesses();
									return 1;
								}
							}
							else
							{
							    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle pieniêdzy!");
							    return 1;
							}
						}
						else
						{
						    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz biznesu!");
						    return 1;
						}
			        }
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nikt nie oferuje Ci produktów!");
				    return 1;
				}
			}
	}
	return 1;
}
//========================================[HELP & INFORMATION COMMANDS]===================================================
 	if(strcmp(cmd, "/fwyplac", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerInfo[playerid][pFaction] != 255)
	        {
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /fwyplac <iloœæ>");
					return 1;
				}
				new cashdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /fwyplac <iloœæ>");
					return 1;
				}
				if(PlayerToPoint(5.0,playerid,BankPosition[X],BankPosition[Y],BankPosition[Z]))
				{
				    if(PlayerInfo[playerid][pRank] == 1)
				    {
						if(DynamicFactions[PlayerInfo[playerid][pFaction]][fBank] >= cashdeposit)
						{
							GivePlayerCash(playerid,cashdeposit);
							DynamicFactions[PlayerInfo[playerid][pFaction]][fBank]=DynamicFactions[PlayerInfo[playerid][pFaction]][fBank]-cashdeposit;
							format(string, sizeof(string), "[INFO:] Wyp³aci³eœ %d $ z konta frakcyjnego, nowy stan konta: %d $", cashdeposit,DynamicFactions[PlayerInfo[playerid][pFaction]][fBank]);
							SendClientMessage(playerid, COLOR_WHITE, string);
		                    PlayerActionMessage(playerid,15.0,"wyci¹ga pieni¹dze z konta bankowego.");
 							format(string, sizeof(string), "[FACTION:] %s wyp³aci³ %d $ z frakcyjnego konta.",GetPlayerNameEx(playerid),cashdeposit);
							SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, string);
		                    SaveDynamicFactions();
							return 1;
						}
	 					else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie macie tyle na koncie!");
						}
					}
 					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ liderem!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w banku!");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
			}
		}
		return 1;
	}
  	if(strcmp(cmd, "/bwyplac", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			new bouse = PlayerInfo[playerid][pBizKey];
			if(bouse != 255 && strcmp(playername, Businesses[bouse][Owner], true) == 0)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /bwyplac <iloœæ gotówki>");
					return 1;
				}
				new cashdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /bwyplac <iloœæ gotówki>");
					return 1;
				}
				if (PlayerToPoint(20.0, playerid,Businesses[bouse][ExitX],Businesses[bouse][ExitY],Businesses[bouse][ExitZ]))
				{
				    if(Businesses[bouse][Till] >= cashdeposit)
				    {
					    if(GetPlayerVirtualWorld(playerid) == bouse)
					    {
							GivePlayerCash(playerid,cashdeposit);
							Businesses[bouse][Till]=Businesses[bouse][Till]-cashdeposit;
							format(string, sizeof(string), "[INFO:] Wyp³acono %d $ z konta biznesu, nowy stan konta: %d $", cashdeposit,Businesses[bouse][Till]);
							SendClientMessage(playerid, COLOR_WHITE, string);
	                    	PlayerActionMessage(playerid,15.0,"otwiera sejf i wyci¹ga gotówke.");
							SaveBusinesses();
							return 1;
						}
					}
 					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle w sejfie!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w swoim biznesie!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] To nie Twój biznes!");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/bwplac", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	    	new bizkey = PlayerInfo[playerid][pBizKey];
	    	new playername[MAX_PLAYER_NAME];
	    	GetPlayerName(playerid,playername,sizeof(playername));
	        if(bizkey != 255 && strcmp(playername, Businesses[bizkey][Owner], true) == 0)
	        {
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /bwplac <iloœæ>");
					return 1;
				}
				new cashdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /bwplac <iloœæ>");
					return 1;
				}
				if(PlayerToPoint(5.0,playerid,Businesses[bizkey][ExitX],Businesses[bizkey][ExitY],Businesses[bizkey][ExitZ]))
				{
						if(GetPlayerCash(playerid) >= cashdeposit)
						{
					        if(Businesses[bizkey][Till] < 500000)
					        {
					            if(cashdeposit < 500001)
					            {
									GivePlayerCash(playerid,-cashdeposit);
									Businesses[bizkey][Till]=cashdeposit+Businesses[bizkey][Till];
									format(string, sizeof(string), "[INFO:] Wp³acono %d $ do sejfu w biznesie, stan konta: %d $", cashdeposit,Businesses[bizkey][Till]);
									SendClientMessage(playerid, COLOR_WHITE, string);
				                    PlayerActionMessage(playerid,15.0,"otwiera sejf i wk³ada gotówke.");
				                    SaveBusinesses();
									return 1;
								}
								else
								{
									SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] W depozycie nie mo¿e byæ wiêcej ni¿ 500,000 $.");
								}
							}
							else
							{
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Iloœæ przekracza 500,000 $.");
							}
						}
						else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz takiej gotówki!");
						}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w swoim biznesie!");
				}
   			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz swojego biznesu!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/fwplac", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerInfo[playerid][pFaction] != 255)
	        {
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /fwplac <iloœæ>");
					return 1;
				}
				new cashdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /fwplac <iloœæ>");
					return 1;
				}
				if(PlayerToPoint(5.0,playerid,BankPosition[X],BankPosition[Y],BankPosition[Z]))
				{
					if(GetPlayerCash(playerid) >= cashdeposit)
					{
						GivePlayerCash(playerid,-cashdeposit);
						DynamicFactions[PlayerInfo[playerid][pFaction]][fBank]=cashdeposit+DynamicFactions[PlayerInfo[playerid][pFaction]][fBank];
						format(string, sizeof(string), "[INFO:] Wp³acono %d $ na frakcyjne konto, nowy stan konta: $%d", cashdeposit,DynamicFactions[PlayerInfo[playerid][pFaction]][fBank]);
						SendClientMessage(playerid, COLOR_WHITE, string);
	                    PlayerActionMessage(playerid,15.0,"wp³aca pieni¹dze do banku.");
						format(string, sizeof(string), "[FACTION:] %s wp³aci³ %d $ na frakcyjne konto.",GetPlayerNameEx(playerid),cashdeposit);
						SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, string);
	                    SaveDynamicFactions();
						return 1;
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz takich pieniêdzy!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w banku!");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w frakcji!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/wplac", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerToPoint(5.0,playerid,BankPosition[X],BankPosition[Y],BankPosition[Z]))
	        {
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /wplac <iloœæ>");
					return 1;
				}
				new cashdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /wplac <iloœæ>");
					return 1;
				}
				if(GetPlayerCash(playerid) >= cashdeposit)
				{
					GivePlayerCash(playerid,-cashdeposit);
					PlayerInfo[playerid][pBank]=cashdeposit+PlayerInfo[playerid][pBank];
					format(string, sizeof(string), "[INFO:] Wp³acono %d $, nowy stan konta: $%d", cashdeposit,PlayerInfo[playerid][pBank]);
					SendClientMessage(playerid, COLOR_WHITE, string);
                    PlayerActionMessage(playerid,15.0,"wp³aca pieni¹dze na konto.");
                    OnPlayerDataSave(playerid);
					return 1;
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tylu pieniêdzy!");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w banku!");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/wyplac", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerToPoint(5.0,playerid,BankPosition[X],BankPosition[Y],BankPosition[Z]))
	        {
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /wyplac <iloœæ>");
					return 1;
				}
				new cashdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /wyplac <iloœæ>");
					return 1;
				}
				if(PlayerInfo[playerid][pBank] >= cashdeposit)
				{
					GivePlayerCash(playerid,cashdeposit);
					PlayerInfo[playerid][pBank]=PlayerInfo[playerid][pBank]-cashdeposit;
					format(string, sizeof(string), "[INFO:] Wyp³acono %d $, nowy stan konta: %d $", cashdeposit,PlayerInfo[playerid][pBank]);
					SendClientMessage(playerid, COLOR_WHITE, string);
                    PlayerActionMessage(playerid,15.0,"wyp³aca pieni¹dze z konta.");
                    OnPlayerDataSave(playerid);
					return 1;
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle na koncie!");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w banku!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/przelew", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /przelew <id/nick> <iloœæ>");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /przelew <id/nick> <iloœæ>");
				return 1;
			}
   			if(PlayerToPoint(5.0,playerid,BankPosition[X],BankPosition[Y],BankPosition[Z]))
   			{
				new moneys = strval(tmp);
				if (IsPlayerConnected(giveplayerid))
				{
				    if(giveplayerid != INVALID_PLAYER_ID)
				    {
						new playermoney = PlayerInfo[playerid][pBank] ;
						if (moneys > 0 && playermoney >= moneys)
						{
						    if(giveplayerid != playerid)
						    {
								PlayerInfo[playerid][pBank] -= moneys;
								PlayerInfo[giveplayerid][pBank] += moneys;
								format(string, sizeof(string), "[INFO:] Przelano %d $ na konto %s.", moneys, GetPlayerNameEx(giveplayerid),giveplayerid);
								SendClientMessage(playerid, COLOR_WHITE, string);
								format(string, sizeof(string), "[INFO:] Przelano %d $ od %s.", moneys, GetPlayerNameEx(playerid), playerid);
								SendClientMessage(giveplayerid, COLOR_YELLOW, string);
			                    PlayerActionMessage(playerid,15.0,"przelewa pieni¹dze w banku.");
							}
							else
							{
							    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Samemu sobie nie mo¿esz!");
							}
						}
						else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a iloœæ.");
						}
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w banku!");
			}
		}
		return 1;
	}
  	if(strcmp(cmd, "/stankonta", true) == 0)
	{
 		if(PlayerToPoint(5.0,playerid,BankPosition[X],BankPosition[Y],BankPosition[Z]))
		{
			format(string, sizeof(string), "[INFO:] Stan konta: %d $.", PlayerInfo[playerid][pBank]);
			SendClientMessage(playerid, COLOR_WHITE, string);
   			PlayerActionMessage(playerid,15.0,"sprawdza stan konta.");
		}
		else
		{
  			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w banku!");
		}
		return 1;
	}
   	if(strcmp(cmd, "/fstankonta", true) == 0)
	{
		if(PlayerInfo[playerid][pFaction] != 255)
	    {
	 		if(PlayerToPoint(5.0,playerid,BankPosition[X],BankPosition[Y],BankPosition[Z]))
			{
				format(string, sizeof(string), "[INFO:] Stan konta frakcji: $%d.", DynamicFactions[PlayerInfo[playerid][pFaction]][fBank]);
				SendClientMessage(playerid, COLOR_WHITE, string);
	   			PlayerActionMessage(playerid,15.0,"sprawdza stan konta.");
			}
			else
			{
	  			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w banku!");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
		}
		return 1;
	}
	if(strcmp(cmd, "/fmaterialy", true) == 0)
	{
	    if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] != 1)
	    {
	 		if(PlayerToPoint(5.0,playerid,FactionMaterialsStorage[X],FactionMaterialsStorage[Y],FactionMaterialsStorage[Z]))
			{
				format(string, sizeof(string), "[INFO:] Iloœæ materia³ów: %d.", DynamicFactions[PlayerInfo[playerid][pFaction]][fMaterials]);
				SendClientMessage(playerid, COLOR_WHITE, string);
	   			PlayerActionMessage(playerid,15.0,"sprawdza coœ w kartonach.");
			}
			else
			{
	  			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w magazynie!");
			}
		}
		else
		{
  			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
		}
		return 1;
	}
 	if(strcmp(cmd, "/fdragi", true) == 0)
	{
	    if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] != 1)
	    {
	 		if(PlayerToPoint(5.0,playerid,FactionDrugsStorage[X],FactionDrugsStorage[Y],FactionDrugsStorage[Z]))
			{
				format(string, sizeof(string), "[INFO:] Iloœæ dragów: %d.", DynamicFactions[PlayerInfo[playerid][pFaction]][fDrugs]);
				SendClientMessage(playerid, COLOR_WHITE, string);
	   			PlayerActionMessage(playerid,15.0,"sprawdza coœ w kartonach.");
			}
			else
			{
	  			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w magazynie!");
			}
		}
  		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a frakcja.");
		}
		return 1;
	}
 	if(strcmp(cmd, "/dwyplac", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			new bouse = PlayerInfo[playerid][pHouseKey];
			if(PlayerInfo[playerid][pHouseKey] != 255 && strcmp(playername, Houses[PlayerInfo[playerid][pHouseKey]][Owner], true) == 0)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dwyplac <iloœæ>");
					return 1;
				}
				new cashdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dwyplac <iloœæ>");
					return 1;
				}
				if (PlayerToPoint(20.0, playerid,Houses[bouse][ExitX],Houses[bouse][ExitY],Houses[bouse][ExitZ]))
				{
				    if(Houses[bouse][Money] >= cashdeposit)
				    {
					    if(GetPlayerVirtualWorld(playerid) == bouse)
					    {
							GivePlayerCash(playerid,cashdeposit);
							Houses[bouse][Money]=Houses[bouse][Money]-cashdeposit;
							format(string, sizeof(string), "[INFO:] Wyp³acono %d $ z domowego sejfu, pozosta³o: %d $", cashdeposit,Houses[bouse][Money]);
							SendClientMessage(playerid, COLOR_WHITE, string);
	                    	PlayerActionMessage(playerid,15.0,"wyci¹ga pieni¹dze z skrytki.");
							SaveHouses();
							return 1;
						}
					}
 					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w swoim domu!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz domu!");
			}
		}
		return 1;
	}
  	if(strcmp(cmd, "/dwplac", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			new bouse = PlayerInfo[playerid][pHouseKey];
			if(bouse != 255 && strcmp(playername, Houses[bouse][Owner], true) == 0)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dwplac <iloœæ>");
					return 1;
				}
				new cashdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dwplac <iloœæ>");
					return 1;
				}
				if (PlayerToPoint(20.0, playerid,Houses[bouse][ExitX],Houses[bouse][ExitY],Houses[bouse][ExitZ]))
				{
				    if(GetPlayerCash(playerid) >= cashdeposit)
				    {
					    if(GetPlayerVirtualWorld(playerid) == bouse)
					    {
					        if(Houses[bouse][Money] < 150000)
					        {
					            if(cashdeposit < 150001)
					            {
									GivePlayerCash(playerid,-cashdeposit);
									Houses[bouse][Money]=Houses[bouse][Money]+cashdeposit;
									format(string, sizeof(string), "[INFO:] Wp³acono %d $, nowy stan: $%d ", cashdeposit,Houses[bouse][Money]);
									SendClientMessage(playerid, COLOR_WHITE, string);
			                    	PlayerActionMessage(playerid,15.0,"wk³ada pieni¹dze do skrytki.");
									SaveHouses();
								}
 								else
								{
	                                SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿esz mieæ w domu wiêcej ni¿ 150 000 $.");
								}
							}
							else
							{
                                SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a wartoœæ");
							}
							return 1;
						}
					}
 					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w swoim domu!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz domu!");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/dwezdragi", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			new bouse = PlayerInfo[playerid][pHouseKey];
			if(PlayerInfo[playerid][pHouseKey] != 255 && strcmp(playername, Houses[PlayerInfo[playerid][pHouseKey]][Owner], true) == 0)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dwezdragi <iloœæ>");
					return 1;
				}
				new materialsdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dwezdragi <iloœæ>");
					return 1;
				}
				if (PlayerToPoint(100.0, playerid,Houses[bouse][ExitX],Houses[bouse][ExitY],Houses[bouse][ExitZ]))
				{
				    if(Houses[bouse][Drugs] >= materialsdeposit)
				    {
					    if(GetPlayerVirtualWorld(playerid) == bouse)
					    {
							PlayerInfo[playerid][pDrugs] += materialsdeposit;
							Houses[bouse][Drugs]=Houses[bouse][Drugs]-materialsdeposit;
							format(string, sizeof(string), "[INFO:] Wziêto %d dragów z domu, nowy stan: %d ", materialsdeposit,Houses[bouse][Materials]);
							SendClientMessage(playerid, COLOR_WHITE, string);
	       					PlayerActionMessage(playerid,15.0,"wyci¹ga coœ z skrytki.");
							SaveHouses();
							return 1;
						}
					}
 					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] To nie Twój dom!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz domu!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/ddajdragi", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			new bouse = PlayerInfo[playerid][pHouseKey];
			if(PlayerInfo[playerid][pHouseKey] != 255 && strcmp(playername, Houses[PlayerInfo[playerid][pHouseKey]][Owner], true) == 0)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ddajdragi <iloœæ>");
					return 1;
				}
				new materialsdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ddajdragi <iloœæ>");
					return 1;
				}
				if (PlayerToPoint(100.0, playerid,Houses[bouse][ExitX],Houses[bouse][ExitY],Houses[bouse][ExitZ]))
				{
				    if(PlayerInfo[playerid][pDrugs] >= materialsdeposit)
				    {
					    if(GetPlayerVirtualWorld(playerid) == bouse)
					    {
					        if(Houses[bouse][Drugs] < 500)
					        {
					            if(materialsdeposit < 501)
					            {
									PlayerInfo[playerid][pDrugs] -= materialsdeposit;
									Houses[bouse][Drugs]=Houses[bouse][Drugs]+materialsdeposit;
									format(string, sizeof(string), "[INFO:] Umieœci³eœ %d dragów w domu, nowy stan: %d ", materialsdeposit,Houses[bouse][Materials]);
									SendClientMessage(playerid, COLOR_WHITE, string);
			                    	PlayerActionMessage(playerid,15.0,"wk³ada coœ do skrytki.");
									SaveHouses();
								}
								else
								{
	                                SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie wiêcej ni¿ 500!");
								}
							}
							else
							{
                                SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] W domu mo¿e byæ tylko 500 sztuk");
							}
							return 1;
						}
					}
 					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w swoim domu!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz domu!");
			}
		}
		return 1;
	}
   	if(strcmp(cmd, "/ddajmaterialy", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			new bouse = PlayerInfo[playerid][pHouseKey];
			if(PlayerInfo[playerid][pHouseKey] != 255 && strcmp(playername, Houses[PlayerInfo[playerid][pHouseKey]][Owner], true) == 0)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ddajmaterialy <ilosæ>");
					return 1;
				}
				new materialsdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ddajmaterialy <ilosæ>");
					return 1;
				}
				if (PlayerToPoint(100.0, playerid,Houses[bouse][ExitX],Houses[bouse][ExitY],Houses[bouse][ExitZ]))
				{
				    if(PlayerInfo[playerid][pMaterials] >= materialsdeposit)
				    {
					    if(GetPlayerVirtualWorld(playerid) == bouse)
					    {
					        if(Houses[bouse][Materials] < 2000)
					        {
					            if(materialsdeposit < 2001)
					            {
									PlayerInfo[playerid][pMaterials] -= materialsdeposit;
									Houses[bouse][Materials]=Houses[bouse][Materials]+materialsdeposit;
									format(string, sizeof(string), "[INFO:] Umieœci³eœ %d materia³ów do broni w domu, nowy stan: %d ", materialsdeposit,Houses[bouse][Materials]);
									SendClientMessage(playerid, COLOR_WHITE, string);
			                    	PlayerActionMessage(playerid,15.0,"wk³ada coœ do skrytki.");
									SaveHouses();
								}
								else
								{
	                                SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿na umieœciæ wiêcej materia³ów ni¿ 2000!");
								}
							}
							else
							{
                                SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿na umieœciæ wiêcej materia³ów ni¿ 2000.");
							}
							return 1;
						}
					}
 					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w swoim domu!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz domu!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/dwezmaterialy", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			new bouse = PlayerInfo[playerid][pHouseKey];
			if(PlayerInfo[playerid][pHouseKey] != 255 && strcmp(playername, Houses[PlayerInfo[playerid][pHouseKey]][Owner], true) == 0)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dwezmaterialy <iloœæ>");
					return 1;
				}
				new materialsdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dwezmaterialy <iloœæ>");
					return 1;
				}
				if (PlayerToPoint(100.0, playerid,Houses[bouse][ExitX],Houses[bouse][ExitY],Houses[bouse][ExitZ]))
				{
				    if(Houses[bouse][Materials] >= materialsdeposit)
				    {
					    if(GetPlayerVirtualWorld(playerid) == bouse)
					    {
							PlayerInfo[playerid][pMaterials] += materialsdeposit;
							Houses[bouse][Materials]=Houses[bouse][Materials]-materialsdeposit;
							format(string, sizeof(string), "[INFO:] Wzi¹³eœ %d materia³ów na broñ z domu, nowy stan: %d ", materialsdeposit,Houses[bouse][Materials]);
							SendClientMessage(playerid, COLOR_WHITE, string);
	       					PlayerActionMessage(playerid,15.0,"wyci¹ga coœ z skrytki.");
							SaveHouses();
							return 1;
						}
					}
 					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] To nie Twój dom!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz domu!");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/silnik", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    if(EngineStatus[GetPlayerVehicleID(playerid)] == 0)
			{
				TogglePlayerControllable(playerid,1);
				EngineStatus[GetPlayerVehicleID(playerid)] = 1;
				if(PlayerInfo[playerid][pSex] == 1)
				{
	   				PlayerActionMessage(playerid,15.0,"uruchamia silnik.");
	   			}
	   			else
	   			{
					PlayerActionMessage(playerid,15.0,"uruchamia silnik.");
	   			}
			}
			else
			{
				TogglePlayerControllable(playerid,0);
				EngineStatus[GetPlayerVehicleID(playerid)] = 0;

	   			if(PlayerInfo[playerid][pSex] == 1)
				{
	   				PlayerActionMessage(playerid,15.0,"gasi silnik.");
	   			}
	   			else
	   			{
					PlayerActionMessage(playerid,15.0,"gasi silnik.");
	   			}
			}
		}
		else
		{
		    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Nie jesteœ w pojeŸdzie!");
		}
		return 1;
	}
 	if(strcmp(cmd, "/dajkase", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dajkase <id/nick> <iloœæ>");
				return 1;
			}
			//giveplayerid = strval(tmp);
	        giveplayerid = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dajkase <id/nick> <iloœæ>");
				return 1;
			}
			new moneys,playermoney;
			moneys = strval(tmp);
			if(moneys < 1 || moneys > 90000)
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Maksymalna jednorazowa iloœæ przekazywanej gotówki to 90 000$, minimalna 1$.");
			    return 1;
			}
			if (IsPlayerConnected(giveplayerid))
			{
			    if(giveplayerid != INVALID_PLAYER_ID)
			    {
					if (ProxDetectorS(5.0, playerid, giveplayerid))
					{
					    if(giveplayerid != playerid)
					    {
							playermoney = GetPlayerCash(playerid);
							if (moneys > 0 && playermoney >= moneys)
							{
	       						GivePlayerCash(playerid, (0 - moneys));
								GivePlayerCash(giveplayerid, moneys);
								format(string, sizeof(string), "[INFO:] %s (ID:%d) otrzyma³ %d$.", GetPlayerNameEx(giveplayerid),giveplayerid, moneys);
								SendClientMessage(playerid, COLOR_WHITE, string);
								format(string, sizeof(string), "[INFO:] %s (ID:%d) przekaza³ Tobie %d$.",GetPlayerNameEx(playerid), playerid,moneys);
								SendClientMessage(giveplayerid, COLOR_WHITE, string);
								PlayerPlayerActionMessage(playerid,giveplayerid,5.0,"przekazuje pieni¹dze");
							}
							else
							{
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a iloœæ.");
							}
						}
      					else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿esz samemu sobie przekazaæ pieniêdzy!");
						}
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Zbyt daleko.");
					}
				}//invalid id
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd,"/licencje",true)==0)
    {
        if(IsPlayerConnected(playerid))
	    {
	        new text1[20];
	        new text2[20];
	        new text3[20];
	        if(PlayerInfo[playerid][pCarLic]) { text1 = "Tak"; } else { text1 = "Nie"; }
            if(PlayerInfo[playerid][pFlyLic]) { text2 = "Tak"; } else { text2 = "Nie"; }
			if(PlayerInfo[playerid][pWepLic]) { text3 = "Tak"; } else { text3= "Nie"; }

		 	SendClientMessage(playerid, COLOR_LIGHTGREEN, "----------------------[LICENCJE:]----------------------");
	        format(string, sizeof(string), "** Prawojazdy: %s - Licencja pilota: %s - Licencja na broñ: %s.", text1,text2,text3);
			SendClientMessage(playerid, COLOR_WHITE, string);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "---------------------------------------------------------");
		}
	    return 1;
 	}
	if(strcmp(cmd, "/oocstatus", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(OOCStatus)
			    {
			        OOCStatus = 0;
			        format(string, sizeof(string), "[GLOBAL OOC:] Wy³¹czone przez %s.", GetPlayerNameEx(playerid));
					SendClientMessageToAll(COLOR_ADMINCMD, string);
				}
				else
				{
					OOCStatus = 1;
					format(string, sizeof(string), "[GLOBAL OOC:] W³¹czone przez %s.", GetPlayerNameEx(playerid));
					SendClientMessageToAll(COLOR_ADMINCMD, string);
				}
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/zamknij", true) == 0)
	{
		new carid=GetPlayerVehicleID(playerid);
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
	        if(VehicleLocked[carid] == 0)
	  		{
   			if(PlayerInfo[playerid][pSex] == 1)
			{
				PlayerActionMessage(playerid,15.0,"zamyka pojazd.");
			}
			else
			{
				PlayerActionMessage(playerid,15.0,"zamyka pojazd.");
			}
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] Pojazd zamkniêty.");
			VehicleLocked[carid] = 1;
			VehicleLockedPlayer[playerid] = carid;
			}
		}
		else if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
   			new Float:x,Float:y,Float:z;
   			if(VehicleLockedPlayer[playerid] != 999)
   			{
				GetVehiclePos(VehicleLockedPlayer[playerid], x, y, z);
			}
			if(VehicleLocked[VehicleLockedPlayer[playerid]])
			{
   				if(PlayerToPoint(5.0,playerid,x,y,z))
			    {
					if(PlayerInfo[playerid][pSex] == 1)
					{
						PlayerActionMessage(playerid,15.0,"otweira pojazd.");
					}
					else
					{
						PlayerActionMessage(playerid,15.0,"otwiera pojazd.");
					}
					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] Pojazd otwarty.");
					VehicleLocked[VehicleLockedPlayer[playerid]] = 0;
					VehicleLockedPlayer[playerid] = 999;
				}
				else
				{
				    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] Nie jesteœ w pojeŸdzie!");
				}
			}
  		}
		return 1;
	}
	if(strcmp(cmd,"/clearanims",true)==0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        ClearAnimations(playerid);
	    }
	    return 1;
	}
  	if(strcmp(cmd, "/local", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /local <treœæ>");
				return 1;
			}
			format(string, sizeof(string), "%s says: %s", GetPlayerNameEx(playerid), result);
			ProxDetector(3.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
		}
		return 1;
	}
   	if(strcmp(cmd, "/krzycz", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /krzycz <treœæ>");
				return 1;
			}
			format(string, sizeof(string), "%s krzyczy: %s!!!", GetPlayerNameEx(playerid), result);
			ProxDetector(3.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
		}
		return 1;
	}
	if(strcmp(cmd, "/szept", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /szept <id> <treœæ>");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if (IsPlayerConnected(giveplayerid))
			{
			    if(giveplayerid != INVALID_PLAYER_ID)
			    {
					new length = strlen(cmdtext);
					while ((idx < length) && (cmdtext[idx] <= ' '))
					{
						idx++;
					}
					new offset = idx;
					new result[128];
					while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
					{
						result[idx - offset] = cmdtext[idx];
						idx++;
					}
					result[idx - offset] = EOS;
					if(!strlen(result))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /szept <id> <treœæ>");
						return 1;
					}
					if (ProxDetectorS(3.0, playerid, giveplayerid))
					{
						if(giveplayerid != playerid)
						{
							format(string, sizeof(string), "%s szepcze: %s", GetPlayerNameEx(playerid), result);
							SendClientMessage(giveplayerid, COLOR_YELLOW, string);
							SendClientMessage(playerid, COLOR_YELLOW, string);
							PlayerActionMessage(playerid,5.0,"szepcze.");
						}
						else
						{
						SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Nie mo¿esz do siebie samego.");
						}

					}
					else
					{
							SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Zbyt daleko.");
					}
					return 1;
				}
			}
			else
			{
                SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Z³e ID.");
			}
		}
		return 1;
	}
  	if(strcmp(cmd, "/znajdz", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /znajdz <id>");
				return 1;
			}
			if(TrackingPlayer[playerid] == 1)
			{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ju¿ szukasz kogoœ.");
			return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pJob] == 3)
			{
			    if(IsPlayerConnected(id))
			    {
			        if(playerid != id)
			        {
					    if(id != INVALID_PLAYER_ID)
					    {
							if(PhoneOnline[id] == 0)
							{
								format(string, sizeof(string), "[INFO:] Szukasz %s, CP usuwany po 60 sekundach.", GetPlayerNameEx(id));
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
								new Float:x,Float:y,Float:z;
								GetPlayerPos(id,x,y,z);
								SetPlayerCheckpoint(playerid,x,y,z,10.0);
								SetTimerEx("ClearCheckpointsForPlayer", 60000, false, "i", playerid);
								TrackingPlayer[playerid] = 1;

							}
							else
							{
								SendClientMessage(id, COLOR_LIGHTYELLOW2, "[ERROR:] Ma wy³¹czony telefon.");
							}
						}
					}
					else
					{
						SendClientMessage(id, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mozesz szukaæ samego siebie.");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ detektywem!");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/adonator", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /adonator [playerid]");
				return 1;
			}
			new id = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 3)
			{
			    if(IsPlayerConnected(id))
			    {
				    if(id != INVALID_PLAYER_ID)
				    {
						if(PlayerInfo[id][pDonator] == 1)
						{
							format(string, sizeof(string), "[INFO:] Konto premium zabrane przez: %s.", GetPlayerNameEx(playerid));
							SendClientMessage(id, COLOR_ADMINCMD, string);
							DonatorLog(string);
							format(string, sizeof(string), "[INFO:] Zabra³eœ %s konto premium.", GetPlayerNameEx(id));
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
							PlayerInfo[id][pDonator] = 0;
						}
						else
						{
							format(string, sizeof(string), "[INFO:] Otrzyma³eœ konto premium od: %s.", GetPlayerNameEx(playerid));
							SendClientMessage(id, COLOR_ADMINCMD, string);
							DonatorLog(string);
							format(string, sizeof(string), "[INFO:] Da³eœ konto premium graczowi: %s.", GetPlayerNameEx(id));
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
							PlayerInfo[id][pDonator] = 1;
						}
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Nie jesteœ administratorem.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/poszukuj", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /poszukuj <id> <powód>");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if (PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
				if(IsPlayerConnected(giveplayerid))
				{
				    if(giveplayerid != INVALID_PLAYER_ID)
				    {
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[128];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result))
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /poszukuj <id> <powód>");
							return 1;
						}
      					if(CopOnDuty[playerid])
						{
							if(giveplayerid != playerid)
							{
								if(WantedPoints[giveplayerid] == 0) { WantedPoints[giveplayerid] = 3; }
								else { WantedPoints[giveplayerid]+= 2; }
								format(string, sizeof(string), "[INFO:] Jesteœ poszukiwany przez %s, Powód: %s.", GetPlayerNameEx(playerid),result);
								SendClientMessage(giveplayerid, COLOR_RED, string);
								format(string, sizeof(string), "[INFO:] Poszukujesz %s, Powód: %s.", GetPlayerNameEx(giveplayerid),result);
								SendClientMessage(playerid, COLOR_WHITE, string);
								format(string, sizeof(string), "[PD:] %s poszukuje %s, Powód: %s.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid),result);
								SendFactionTypeMessage(1,COLOR_LSPD,string);
								new location[MAX_ZONE_NAME];
								GetPlayer2DZone(giveplayerid, location, MAX_ZONE_NAME);
								format(string, sizeof(string), "[PD:] Do wszystkich jednostek, osoba: %s by³a ostanio widziana w %s.", GetPlayerNameEx(giveplayerid),location);
								SendFactionTypeMessage(1,COLOR_LSPD,string);
							}
							else
							{
	                            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿esz poszukiwaæ samego siebie!");
							}
						}
      					else
						{
      						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ na s³u¿bie!");
						}
						return 1;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ w odpowiedniej frakcji.");
				return 1;
			}
		}
  		else
		{
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
			return 1;
		}
		return 1;
	}
 	if(strcmp(cmd, "/okna", true) == 0)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			if(IsABike(GetPlayerVehicleID(playerid)))
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie prawid³owy pojazd.");
			    return 1;
			}
		    if(CarWindowStatus[GetPlayerVehicleID(playerid)] == 1)
		    {
		    	if(PlayerInfo[playerid][pSex] == 1)
				{
					PlayerActionMessage(playerid,15.0,"opuszcza okna w dó³.");
				}
				else
				{
					PlayerActionMessage(playerid,15.0,"opuszcza okna w dó³.");
				}
				CarWindowStatus[GetPlayerVehicleID(playerid)] = 0;
		    }
		    else if(CarWindowStatus[GetPlayerVehicleID(playerid)] == 0)
		    {
		    	if(PlayerInfo[playerid][pSex] == 1)
				{
					PlayerActionMessage(playerid,15.0,"zamyka okno.");
				}
				else
				{
					PlayerActionMessage(playerid,15.0,"zamyka okno.");
				}
				CarWindowStatus[GetPlayerVehicleID(playerid)] = 1;
		    }
		}
		else
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Nie jesteœ w pojeŸdzie!");
		}
		return 1;
	}
	if(strcmp(cmd, "/pdcmd", true) == 0)
	{
	if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
	{
		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[PD:] /sluzba - /poszukiwani - /skuj - /odkuj - /przeszukaj - /zabierz - /par - /mandat");
        SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[PD:] /gov(tylko liderzy) - /aresztuj - /m -/r -/poszukuj");
	}
 	else
 	{
 	    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Nie jesteœ w PD.");
 	}
	return 1;
	}
	if(strcmp(cmd, "/wezprace", true) == 0)
	{
	    if(PlayerInfo[playerid][pJob] == 0)
	    {
     		if(PlayerToPoint(1.0, playerid,GunJob[TakeJobX],GunJob[TakeJobY],GunJob[TakeJobZ]))
			{
   				if(GetPlayerVirtualWorld(playerid) == GunJob[TakeJobWorld])
			    {
					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[SUCCESS:] Gratulacje! Zosta³eœ dilerem broni, wpisz /pracacmd.");
					PlayerInfo[playerid][pJob] = 1; //Gun Job
				}
			}
 			else if(PlayerToPoint(1.0, playerid,DrugJob[TakeJobX],DrugJob[TakeJobY],DrugJob[TakeJobZ]))
			{
   				if(GetPlayerVirtualWorld(playerid) == DrugJob[TakeJobWorld])
			    {
					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[SUCCESS:] Gratulacje! Zosta³eœ dilerem narkotyków, wpisz /pracacmd.");
					PlayerInfo[playerid][pJob] = 2; //Drug Job
				}
			}
			else if(PlayerToPoint(1.0, playerid,DetectiveJobPosition[X],DetectiveJobPosition[Y],DetectiveJobPosition[Z]))
			{
   				if(GetPlayerVirtualWorld(playerid) == DetectiveJobPosition[World])
			    {
					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[SUCCESS:] Gratulacje! Zosta³eœ detektywem, wpisz /pracacmd.");
					PlayerInfo[playerid][pJob] = 3; //Detective Job
				}
			}
			else if(PlayerToPoint(1.0, playerid,LawyerJobPosition[X],LawyerJobPosition[Y],LawyerJobPosition[Z]))
			{
   				if(GetPlayerVirtualWorld(playerid) == LawyerJobPosition[World])
			    {
					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[SUCCESS:] Gratulacje! Zosta³eœ adwokatem, wpisz /pracacmd.");
					PlayerInfo[playerid][pJob] = 4; //Lawyer Job
				}
			}
			else if(PlayerToPoint(1.0, playerid,ProductsSellerJob[TakeJobX],ProductsSellerJob[TakeJobY],ProductsSellerJob[TakeJobZ]))
			{
   				if(GetPlayerVirtualWorld(playerid) == ProductsSellerJob[TakeJobWorld])
			    {
					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[SUCCESS:] Gratulacje! Zosta³eœ dostawc¹ produktów, wpisz /pracacmd.");
					PlayerInfo[playerid][pJob] = 5; //Products Seller Job
				}
			}
	    }
	    else
	    {
	    	SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Masz ju¿ prace!");
	    }
		return 1;
	}
 	if(strcmp(cmd, "/opuscprace", true) == 0)
	{
	    if(PlayerInfo[playerid][pJob] != 0)
	    {
     		PlayerInfo[playerid][pJob] = 0;
     		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Opuœci³eœ prace.");
	    }
	    else
	    {
	    	SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Nie masz pracy!");
	    }
		return 1;
	}
 	if(strcmp(cmd, "/pracacmd", true) == 0)
	{
	    if(PlayerInfo[playerid][pJob] != 0)
	    {
	   		if (PlayerInfo[playerid][pJob] == 1)
			{
				SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[JOB:] - [DILER BRONI:] /materialy - /sprzedajbron");
			}
			else if(PlayerInfo[playerid][pJob] == 2)
			{
				SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[JOB:] - [DILER NARKOTYKÓW] - /dragi - /sprzedajdragi");
			}
			else if(PlayerInfo[playerid][pJob] == 3)
			{
				SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[JOB:] - [DETEKTYW] - /znajdz");
			}
			else if(PlayerInfo[playerid][pJob] == 4)
			{
				SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[JOB:] - [ADWOKAT] - /uwolnij");
			}
			else if(PlayerInfo[playerid][pJob] == 5)
			{
				SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[JOB:] - [DOSTAWCA] - /produkty");
			}
	    }
	    else
	    {
	    	SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Nie masz pracy!");
	    }
		return 1;
	}
 	if(strcmp(cmd, "/sprzedajdragi", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
		    if(PlayerInfo[playerid][pJob] != 2)
		    {
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie jesteœ dilerem!");
				return 1;
		    }
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /sprzedajdragi <id> <iloœæ>");
				return 1;
			}
			new playa;
			new needed;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) { return 1; }
			needed = strval(tmp);
			if(needed < 1 || needed > 50) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Mo¿esz sprzedaæ na raz tylko 1-50 sztuk dragów."); return 1; }
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) { return 1; }
			if(needed > PlayerInfo[playerid][pDrugs]) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz tyle!"); return 1; }
			if(IsPlayerConnected(playa))
			{
			    if(playa != INVALID_PLAYER_ID)
			    {
					if (ProxDetectorS(8.0, playerid, playa))
					{
					    if(playa != playerid)
					    {
						    format(string, sizeof(string), "[INFO:] Sprzeda³eœ %s %d gram dragów.", GetPlayerNameEx(playa), needed);
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
							format(string, sizeof(string), "[INFO:] %s da³ Tobie %d gram dragów.", GetPlayerNameEx(playerid), needed);
							SendClientMessage(playa, COLOR_LIGHTYELLOW2, string);
							PlayerInfo[playa][pDrugs] += needed;
							PlayerInfo[playerid][pDrugs] -= needed;
							PlayerPlayerActionMessage(playerid,playa,15.0,"przekazuje coœ ukratkiem");
						}
						else
						{
						    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿esz sprzedaæ samemu sobie!");
						}
					}
					else
					{
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Za daleko!");
					}
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd,"/sprzedajbron",true)==0)
    {
        if(IsPlayerConnected(playerid))
	    {
		    if (PlayerInfo[playerid][pJob] != 1)
			{
			    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You are not an arms dealer.");
			    return 1;
			}
			new x_weapon[256],weapon[MAX_PLAYERS],ammo[MAX_PLAYERS],price[MAX_PLAYERS];
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /sprzedajbron <id> <nazwa broni>");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[Bronie:] knife[50] - silenced[150] - eagle[150] - mp5[200] shotgun[200] - ak47[600] m4[600] - rifle [600]");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if (IsPlayerConnected(giveplayerid))
			{
			    if(giveplayerid != INVALID_PLAYER_ID)
			    {
					x_weapon = strtok(cmdtext, idx);
					if(!strlen(x_weapon))
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /sprzedajbron <id> <nazwa broni>");
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[Bronie:] knife[50] - silenced[150] - eagle[150] - mp5[200] shotgun[200] - ak47[600] m4[600] - rifle [600]");
						return 1;
					}
				}
				if(strcmp(x_weapon,"knife",true) == 0) { if(PlayerInfo[playerid][pMaterials] > 49) { weapon[playerid] = 4; price[playerid] = 50; ammo[playerid] = 1; } else { SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough materials!"); return 1; } }
				else if(strcmp(x_weapon,"silenced",true) == 0) { if(PlayerInfo[playerid][pMaterials] > 149) { weapon[playerid] = 23; price[playerid] = 125; ammo[playerid] = 50; } else { SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough materials!"); return 1; } }
				else if(strcmp(x_weapon,"eagle",true) == 0) { if(PlayerInfo[playerid][pMaterials] > 199) { weapon[playerid] = 24; price[playerid] = 150; ammo[playerid] = 50; } else { SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough materials!"); return 1; } }
				else if(strcmp(x_weapon,"mp5",true) == 0) {	if(PlayerInfo[playerid][pMaterials] > 199) { weapon[playerid] = 29; price[playerid] = 200; ammo[playerid] = 200; } else { SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough materials!"); return 1; } }
				else if(strcmp(x_weapon,"shotgun",true) == 0) {	if(PlayerInfo[playerid][pMaterials] > 199) { weapon[playerid] = 25; price[playerid] = 200; ammo[playerid] = 50; } else { SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough materials!"); return 1; } }
				else if(strcmp(x_weapon,"ak47",true) == 0) { if(PlayerInfo[playerid][pMaterials] > 599) { weapon[playerid] = 30; price[playerid] = 600; ammo[playerid] = 250; } else { SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough materials!"); return 1; } }
				else if(strcmp(x_weapon,"m4",true) == 0) { if(PlayerInfo[playerid][pMaterials] > 599) { weapon[playerid] = 31; price[playerid] = 600; ammo[playerid] = 250; } else { SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough materials!"); return 1; } }
				else if(strcmp(x_weapon,"rifle",true) == 0) { if(PlayerInfo[playerid][pMaterials] > 599) { weapon[playerid] = 33; price[playerid] = 600; ammo[playerid] = 50; } else { SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough materials!"); return 1; } }
				else { SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Nie prawid³owa nazwa broni."); return 1; }
				if (ProxDetectorS(5.0, playerid, giveplayerid))
				{
					format(string, sizeof(string), "[INFO:] Da³eœ %s broñ %s z %d sztuk amunicji, dla %d materia³ów.", GetPlayerNameEx(giveplayerid),x_weapon, ammo[playerid], price[playerid]);
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
					format(string, sizeof(string), "[INFO:] %s otrzymano - Amunicja: %d - od %s.", x_weapon, ammo[playerid], GetPlayerNameEx(playerid));
					SendClientMessage(giveplayerid, COLOR_LIGHTYELLOW2, string);
					PlayerPlayerActionMessage(playerid,giveplayerid,15.0,"przekazuje coœ ukratkiem");
					GivePlayerWeapon(giveplayerid,weapon[playerid],ammo[playerid]);
					PlayerInfo[playerid][pMaterials] -= price[playerid];
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Za dakeko!");
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
			}
		}
		return 1;
	}
 	if(strcmp(cmdtext, "/zazyjdragow", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	   	{
			if(PlayerInfo[playerid][pDrugs] > 1)
			{
			    new Float:armour;
			    GetPlayerArmour(playerid, armour);
			    if(armour < 100.0)
			    {
                	SetPlayerArmour(playerid, armour + 15.0);
                }
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INFO:] U¿yto 2 gramy.");
			    PlayerInfo[playerid][pDrugs] -= 2;
			    PlayerActionMessage(playerid,15.0,"za¿ywa dragi.");
			    DrugsIntake[playerid] += 2;
			    if(DrugsIntake[playerid] >= 8)
			    {
			    	SetTimerEx("DrugEffect", 1000, false, "i", playerid);
			    }
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz przy sobie dragów.");
			}
		}//not connected
		return 1;
	}
	if(strcmp(cmd,"/produkty",true)==0)
    {
        if(IsPlayerConnected(playerid))
	    {
		    if (PlayerInfo[playerid][pJob] != 5)
			{
			    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Nie jesteœ dostawc¹!");
			    return 1;
			}
			new x_nr[256];
			x_nr = strtok(cmdtext, idx);
			if(!strlen(x_nr)) {
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /produkty <czynnoœæ>");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] kup, sprzedaj.");
				return 1;
			}
			if(strcmp(x_nr,"kup",true) == 0)
			{
			    if(PlayerToPoint(3.0,playerid,ProductsSellerJob[BuyProductsX],ProductsSellerJob[BuyProductsY],ProductsSellerJob[BuyProductsZ]))
			    {
			        if(PlayerInfo[playerid][pProducts] >= 500)
			        {
			            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿esz kupiæ wiêcej ni¿ 500.");
				        return 1;
			        }
			        tmp = strtok(cmdtext, idx);
			        if(!strlen(tmp)) {
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /produkty <kup> <iloœæ>");
						return 1;
					}
					new moneys;
					moneys = strval(tmp);
					if(moneys < 1 || moneys > 500) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Maksymalna iloœæ do kupienia to 500 sztuk."); return 1; }
					new price = moneys * PRODUCT_PRICE;
					if(GetPlayerCash(playerid) > price)
					{
					    format(string, sizeof(string), "[INFO:] Kupi³eœ %d produktów - Koszt: $%d.", moneys, price);
					    SendClientMessage(playerid, COLOR_WHITE, string);
					    SendClientMessage(playerid, COLOR_WHITE, "[INFO:] Mo¿esz teraz komuœ sprzedaæ produkty do biznesu.");
					    GivePlayerCash(playerid, - price);
					    PlayerInfo[playerid][pProducts] = moneys;
					}
					else
					{
					    format(string, sizeof(string), "[ERROR:] Nie masz przy sobie %d $.", price);
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
					}
			    }
			    else
			    {
			        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Jesteœ w z³ym miejscu.");
			        return 1;
			    }
			}
			else if(strcmp(x_nr,"sprzedaj",true) == 0)
			{
			    tmp = strtok(cmdtext, idx);
       			if(!strlen(tmp)) {
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /produkty <sprzedaj> <id> <iloœæ> <koszt>");
					return 1;
				}
				new id;
				id = ReturnUser(tmp);
				if(id == playerid) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie mo¿esz sobie sprzedaæ produktów!"); return 1;}

                tmp = strtok(cmdtext, idx);
				new amount;
				amount = strval(tmp);
				if(!strlen(tmp)) {
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /produkty <sprzedaj> <id> <iloœæ> <koszt>");
					return 1;
				}

				tmp = strtok(cmdtext, idx);
				new cost;
				cost = strval(tmp);
				if(!strlen(tmp)) {
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /produkty <sprzedaj> <id> <iloœæ> <koszt>");
					return 1;
				}
				if(cost < 1 || cost > 99999) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Iloœæ powinna mieœciæ siê w przedziale 1-99999."); return 1; }

				if(IsPlayerConnected(id))
				{
					if(id != INVALID_PLAYER_ID)
					{
						if(GetDistanceBetweenPlayers(playerid,id) < 5)
						{
							ProductsOffer[id] = playerid;
							ProductsAmount[id] = amount;
							ProductsCost[id] = cost;
							format(string, sizeof(string), "[INFO:] Zaoferowano Ci %d sztuk produktów za %d$, oferuj¹cy: %s. (/akceptuj produkty)", ProductsAmount[id], ProductsCost[id], GetPlayerNameEx(playerid));
						    SendClientMessage(id, COLOR_LIGHTYELLOW2, string);
						    format(string, sizeof(string), "[INFO:] Zaoferowa³eœ graczowi %s, %d sztuk produktów, za %d$.", GetPlayerNameEx(id), amount, cost);
						    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
							return 1;
						}
						else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Za daleko!");
						}
	    			}
    			}
    			else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³e ID.");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a czynnoœæ.");
			    return 1;
			}
		}
		return 1;
	}
	if(strcmp(cmd,"/dragi",true)==0)
    {
        if(IsPlayerConnected(playerid))
	    {
		    if (PlayerInfo[playerid][pJob] != 2)
			{
			    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Nie jesteœ dilerem!");
			    return 1;
			}
			new x_nr[256];
			x_nr = strtok(cmdtext, idx);
			if(!strlen(x_nr)) {
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dragi <czynnoœæ>");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGES:] kup, dostarcz.");
				return 1;
			}
			if(strcmp(x_nr,"kup",true) == 0)
			{
			    if(PlayerToPoint(3.0,playerid,DrugJob[BuyDrugsX],DrugJob[BuyDrugsY],DrugJob[BuyDrugsZ]))
			    {
			        if(DrugsHolding[playerid] >= 50)
			        {
			            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Wiêcej nie mo¿esz kupiæ.");
				        return 1;
			        }
			        tmp = strtok(cmdtext, idx);
			        if(!strlen(tmp)) {
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /dragi kup <iloœæ>");
						return 1;
					}
					new moneys;
					moneys = strval(tmp);
					if(moneys < 1 || moneys > 50) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Maksymalna iloœæ to 50."); return 1; }
					new price = moneys * 50;
					if(GetPlayerCash(playerid) > price)
					{
					    format(string, sizeof(string), "[INFO:] Kupiono %d gram - Koszt: %d$.", moneys, price);
					    SendClientMessage(playerid, COLOR_WHITE, string);
					    SendClientMessage(playerid, COLOR_WHITE, "[INFO:] Teraz musisz dostarczyæ te dragi.");
					    GivePlayerCash(playerid, - price);
					    DrugsHolding[playerid] = moneys;
					}
					else
					{
					    format(string, sizeof(string), "[ERROR:] Nie masz przy sobie %d$.", price);
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
					}
			    }
			    else
			    {
			        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Jesteœ w z³ym miejscu!");
			        return 1;
			    }
			}
			else if(strcmp(x_nr,"dostarcz",true) == 0)
			{
			    if(PlayerToPoint(3.0,playerid,DrugJob[DeliverX],DrugJob[DeliverY],DrugJob[DeliverZ]))
			    {
			        if(DrugsHolding[playerid] > 0)
			        {
			            new payout = DrugsHolding[playerid];
			            format(string, sizeof(string), "{INFO:] %d dragów dostarczono.", payout);
					    SendClientMessage(playerid, COLOR_WHITE, string);
			            PlayerInfo[playerid][pDrugs] += payout;
			            DrugsHolding[playerid] = 0;
			        }
			        else
			        {
			            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie masz przy sobie dragów!");
				        return 1;
			        }
			    }
			    else
			    {
			        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "{ERROR:] Jesteœ w z³ym miejscu.");
			        return 1;
			    }
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Z³a czynnoœæ.");
			    return 1;
			}
		}
		return 1;
	}
	if(strcmp(cmd,"/materials",true)==0)
    {
        if(IsPlayerConnected(playerid))
	    {
		    if (PlayerInfo[playerid][pJob] != 1)
			{
			    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Your not an arms dealer!");
			    return 1;
			}
			new x_nr[256];
			x_nr = strtok(cmdtext, idx);
			if(!strlen(x_nr)) {
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /materials [usage]");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGES:] buy, dropoff.");
				return 1;
			}
			if(strcmp(x_nr,"buy",true) == 0)
			{
			    if(PlayerToPoint(3.0,playerid,GunJob[BuyPackagesX],GunJob[BuyPackagesY],GunJob[BuyPackagesZ]))
			    {
			        if(MatsHolding[playerid] >= 10)
			        {
			            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You can't hold any more packages.");
				        return 1;
			        }
			        tmp = strtok(cmdtext, idx);
			        if(!strlen(tmp)) {
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /materials [usage]");
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGES:] buy, dropoff.");
						return 1;
					}
					new moneys;
					moneys = strval(tmp);
					if(moneys < 1 || moneys > 10) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Maximum number of packages is 10."); return 1; }
					new price = moneys * 100;
					if(GetPlayerCash(playerid) > price)
					{
					    format(string, sizeof(string), "[INFO:] You got %d materials packages - Cost: $%d.", moneys, price);
					    SendClientMessage(playerid, COLOR_WHITE, string);
					    GivePlayerCash(playerid, - price);
					    MatsHolding[playerid] = moneys;
					}
					else
					{
					    format(string, sizeof(string), "[ERROR:] You don't have $%d.", price);
					    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
					}
			    }
			    else
			    {
			        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are not at the materials package place!");
			        return 1;
			    }
			}
			else if(strcmp(x_nr,"dropoff",true) == 0)
			{
			    if(PlayerToPoint(3.0,playerid,GunJob[DeliverX],GunJob[DeliverY],GunJob[DeliverZ]))
			    {
			        if(MatsHolding[playerid] > 0)
			        {
			            new payout = (50)*(MatsHolding[playerid]);
			            format(string, sizeof(string), "{INFO:] Materials packages delivered, you got %d materials.", payout);
					    SendClientMessage(playerid, COLOR_WHITE, string);
			            PlayerInfo[playerid][pMaterials] += payout;
			            MatsHolding[playerid] = 0;
			        }
			        else
			        {
			            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't even have any packages!");
				        return 1;
			        }
			    }
			    else
			    {
			        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "{ERROR:] You are not at the materials dropoff place.");
			        return 1;
			    }
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Invalid Usage.");
			    return 1;
			}
		}
		return 1;
	}
	if (strcmp(cmd, "/admins", true) == 0)
	{
        if(IsPlayerConnected(playerid))
	    {
	        new count = 0;
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "----------[ADMINISTRATORS ON DUTY]----------");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
				    if(PlayerInfo[i][pAdmin] >= 1 && AdminDuty[i] == 1)
				    {
						format(string, 256, "Administrator: %s - [Administrator Level: %d]", GetPlayerNameEx(i),PlayerInfo[i][pAdmin]);
						SendClientMessage(playerid, COLOR_WHITE, string);
						count++;
					}
				}
			}
			if(count == 0)
			{
				SendClientMessage(playerid,COLOR_WHITE,"[INFO:] Currently no administrators on duty.");
			}
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "----------------------------------------------------------");
		}
		return 1;
	}
 	if(strcmp(cmd, "/changepass", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (gPlayerLogged[playerid])
			{
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[128];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /changepass [newpass]");
					return 1;
				}
				if(strfind( result , "," , true ) == -1)
    			{
		   			strmid(PlayerInfo[playerid][pKey], (result), 0, strlen((result)), 128);
					format(string, sizeof(string), "[INFO:] You have set your password to: %s.", (result));
					SendClientMessage(playerid, COLOR_ADMINCMD, string);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Invalid Symbol , is not allowed!");
				}
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/commands", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_YELLOW,"____________________________________________________");
		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[General:] /time - /stats - /toggle - /refuel - /spawnpoint - /withdraw - /deposit - /balance - /engine - /eat");
		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[General:] /phonecmds - /buy - /buyweapon - /advertise - /pay - /licenses - /showid - /buyclothes - /gooc - /id");
		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[General:] /accept - /report - /eject - /lock - /clearanims - /low - /local - /shout - /whisper - /me - /attempt - /carwindows");
		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[General:] /takejob - /quitjob - /jobcmds - /buydrink - /usedrugs - /pm - /donate - /admins - /changepass");
		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Houses - Businesses - Buildings:] /housecmds - /businesscmds");

        if (PlayerInfo[playerid][pFaction] != 255)
		{
			if(DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
			{
			    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[POLICE:] /policecmds");
			}
			if (PlayerInfo[playerid][pRank] == 1)
			{
				SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Leader:] /leadercmds");
			}
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Faction:] /factioncmds");
		}
		SendClientMessage(playerid,COLOR_YELLOW,"____________________________________________________");
		return 1;
	}
 	if(strcmp(cmd, "/answer", true) == 0)
	{
        if(IsPlayerConnected(playerid))
		{
			if(Mobile[playerid] != 255)
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are already on a phone call! (/hangup).");
				return 1;
			}
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(Mobile[i] == playerid)
					{
						Mobile[playerid] = i;
						SendClientMessage(i,  COLOR_LIGHTBLUE, "[INFO:] The person has answered your phone call.");
						if(!IsPlayerInAnyVehicle(playerid))
						{
							SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
						}

						if(PlayerInfo[playerid][pSex] == 1)
						{
							PlayerActionMessage(playerid,15.0,"has just answered his mobile phone.");
						}
						else
						{
							PlayerActionMessage(playerid,15.0,"has just answered her mobile phone.");
						}
					}

				}
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/attempt", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_GRAD2, "[USAGE:] /attempt [action]");
				return 1;
			}
			new succeed = 1 + random(2);
			if(succeed == 1)
			{
				format(string, sizeof(string), "[ATTEMPT:] %s attempted to %s and succeeded.", GetPlayerNameEx(playerid), result);
				ProxDetector(10.0, playerid, string, COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE);
			}
			else if(succeed == 2)
			{
				format(string, sizeof(string), "[ATTEMPT:] %s attempted to %s and failed.", GetPlayerNameEx(playerid), result);
				ProxDetector(10.0, playerid, string, COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE);
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/me", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /me [action]");
				return 1;
			}
			new form[128];
			format(form, sizeof(form), "%s.",result);
			PlayerActionMessage(playerid,15.0,form);
		}
		return 1;
	}
 	if(strcmp(cmd, "/txt", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /txt [phonenumber] [txt message]");
				return 1;
			}
			if(PlayerInfo[playerid][pPhoneNumber] == 0)
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:]  You don't have a mobile phone, you can buy one from a phone shop/network.");
				return 1;
			}
			if(PlayerInfo[playerid][pSex] == 1)
			{
				PlayerActionMessage(playerid,15.0,"takes out his mobile phone and starts txting.");
			}
			else
			{
				PlayerActionMessage(playerid,15.0,"takes out her mobile phone and starts txting.");
			}
			new phonenumb = strval(tmp);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /txt [phonenumber] [txt message]");
				return 1;
			}
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(PlayerInfo[i][pPhoneNumber] == phonenumb && phonenumb != 0)
					{
						giveplayerid = i;
						if(IsPlayerConnected(giveplayerid))
						{
						    if(giveplayerid != INVALID_PLAYER_ID)
						    {
						        if(PhoneOnline[giveplayerid])
						        {
						            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] That players phone is turned off.");
						            return 1;
						        }
								format(string, sizeof(string), "[TXT:] From: %s (%d), Message: %s", GetPlayerNameEx(playerid),PlayerInfo[playerid][pPhoneNumber],result);
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INFO:] Text message sent.");
								SendClientMessage(giveplayerid, COLOR_LIGHTGREEN, string);
								format(string, sizeof(string), "[TXT:] Sent To: %s (%d), Message: %s", GetPlayerNameEx(giveplayerid),PlayerInfo[giveplayerid][pPhoneNumber],result);
								SendClientMessage(playerid,  COLOR_LIGHTGREEN, string);
								PhoneAnimation(playerid);
								SMSLog(string);
								GivePlayerCash(playerid,-txtcost);
								Businesses[PlayerInfo[playerid][pPhoneC]][Till] += txtcost;
								return 1;
							}
						}
					}
				}
			}
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Message not sent.");
		}
		return 1;
	}
 	if(strcmp(cmd, "/listnumber", true) == 0 )
	{
	if(PlayerInfo[playerid][pPhoneNumber] != 0)
	{
		if(PlayerInfo[playerid][pListNumber])
		{
		    SendClientMessage(playerid,  COLOR_LIGHTYELLOW2, "[PHONE:] Your number will no longer be shown publicly.");
		    PlayerInfo[playerid][pListNumber] = 0;
		}
		else
		{
			SendClientMessage(playerid,  COLOR_LIGHTYELLOW2, "[PHONE:] Your number will now be shown publicly.");
		 	PlayerInfo[playerid][pListNumber] = 1;
		}
	}
	else
	{
		SendClientMessage(playerid,  COLOR_LIGHTYELLOW2, "[ERROR:] You don't have a phone, how could you have a number?");
	}
	return 1;
	}
	if(strcmp(cmd, "/speakerphone", true) == 0 )
	{
	if(PlayerInfo[playerid][pPhoneNumber] != 0 && PlayerInfo[playerid][pPhoneC] != 255)
	{
		if(SpeakerPhone[playerid])
		{
			SendClientMessage(playerid,  COLOR_LIGHTYELLOW2, "[PHONE:] SpeakerPhone disabled.");
			SpeakerPhone[playerid] = 0;
		}
		else
		{
			SendClientMessage(playerid,  COLOR_LIGHTYELLOW2, "[PHONE:] SpeakerPhone enabled.");
			SpeakerPhone[playerid] = 1;
		}
	}
	else
	{
		SendClientMessage(playerid,  COLOR_LIGHTYELLOW2, "[ERROR:] You don't have a phone!");
	}
	return 1;
	}
 	if(strcmp(cmd, "/hangup", true) == 0 )
	{
	    if(IsPlayerConnected(playerid))
		{
			new caller = Mobile[playerid];
			if(IsPlayerConnected(caller))
			{
			    if(caller != INVALID_PLAYER_ID)
			    {
					if(caller != 255)
					{
						if(caller < 255)
						{
							SendClientMessage(caller,  COLOR_LIGHTGREEN, "[PHONE:] They hung up.");
							SendClientMessage(playerid,  COLOR_LIGHTGREEN, "[PHONE:]  You hung up.");

							if(GetPlayerSpecialAction(playerid == SPECIAL_ACTION_USECELLPHONE))
							{
							    if(!IsPlayerInAnyVehicle(playerid))
       							{
									SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
								}
							}
							if(GetPlayerSpecialAction(caller == SPECIAL_ACTION_USECELLPHONE))
							{
							    if(!IsPlayerInAnyVehicle(playerid))
       							{
									SetPlayerSpecialAction(caller,SPECIAL_ACTION_STOPUSECELLPHONE);
								}
							}

							if(PlayerInfo[playerid][pSex] == 1)
							{
								PlayerActionMessage(playerid,15.0,"has put his phone in his pocket.");
							}
							else
							{
								PlayerActionMessage(playerid,15.0,"has put her phone in her pocket.");
							}
							if(PlayerInfo[caller][pSex] == 1)
							{
								PlayerActionMessage(playerid,15.0,"has put his phone in his pocket.");
							}
							else
							{
								PlayerActionMessage(playerid,15.0,"has put her phone in her pocket.");
							}
							Mobile[caller] = 255;

							if(StartedCall[playerid])
							{
								new callcost = random(100);
								GivePlayerCash(playerid,-callcost);
								Businesses[PlayerInfo[playerid][pPhoneC]][Till] += callcost;
								StartedCall[playerid] = 0;
							}
							else if(StartedCall[caller])
							{
								new callcost = random(100);
								GivePlayerCash(caller,-callcost);
								Businesses[PlayerInfo[caller][pPhoneC]][Till] += callcost;
								StartedCall[caller] = 0;
							}
						}
						Mobile[playerid] = 255;
						return 1;
					}
				}
			}
			SendClientMessage(playerid,  COLOR_LIGHTYELLOW2, "[ERROR:] You are not in a phone call!");
		}
		return 1;
	}
 	if(strcmp(cmd, "/call", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /call [phonenumber]");
				return 1;
			}
			if(PlayerInfo[playerid][pPhoneNumber] == 0)
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't even have a phone!");
				return 1;
			}
			if(PlayerInfo[playerid][pSex] == 1)
			{
				PlayerActionMessage(playerid,15.0,"takes a cell phone from his pocket and dials a number.");
			}
			else
			{
				PlayerActionMessage(playerid,15.0,"takes a cell phone from her pocket and dials a number.");
			}
			new phonenumb = strval(tmp);
			if(phonenumb == 911)
			{
				SendClientMessage(playerid, COLOR_WHITE, "Operator says: Hello, LSPD how may i be of assistance.");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INFO:] Please keep your call vivid, and all in once sentence.");
				Mobile[playerid] = 911;
				return 1;
			}
			if(phonenumb == PlayerInfo[playerid][pPhoneNumber])
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] That line is being used.");
				return 1;
			}
			if(Mobile[playerid] != 255)
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your already on a call.");
				return 1;
			}
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(PlayerInfo[i][pPhoneNumber] == phonenumb && phonenumb != 0)
					{
						giveplayerid = i;
						Mobile[playerid] = giveplayerid; //caller connecting
						if(IsPlayerConnected(giveplayerid))
						{
						    if(giveplayerid != INVALID_PLAYER_ID)
						    {
						        if(PhoneOnline[giveplayerid])
						        {
						            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] That user's phone is turned off.");
						            return 1;
						        }
								if (Mobile[giveplayerid] == 255)
								{
									format(string, sizeof(string), "[PHONE:] Ring... Ring... -  ContactID: %s (%d)", GetPlayerNameEx(playerid),PlayerInfo[playerid][pPhoneNumber]);
									SendClientMessage(giveplayerid, COLOR_LIGHTGREEN, string);
									PlayerActionMessage(giveplayerid,15.0,"'s phone starts ringing.");
                                    StartedCall[playerid] = 1;
                                    if(!IsPlayerInAnyVehicle(playerid))
                                    {
                                    	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
                                    }
                                    StartedCall[giveplayerid] = 0;
									return 1;
								}
							}
						}
						else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] That person is on another phonecall.");
						}
					}
				}
			}
		}
		return 1;
	}
 	if(strcmp(cmd,"/buy",true)==0)
	{
 	if(IsPlayerConnected(playerid))
 	{
  		for(new i = 0; i < sizeof(Businesses); i++)
		{
			if (PlayerToPoint(25.0, playerid,Businesses[i][ExitX], Businesses[i][ExitY], Businesses[i][ExitZ]))
			{
				if(GetPlayerVirtualWorld(playerid) == i)
	   			{
				    if(Businesses[i][BizType] == 3) //24-7
			    	{
		        		if(Businesses[i][Products] != 0)
		        		{
							new x_info[128];
							x_info = strtok(cmdtext, idx);
						    new wstring[128];

							if(!strlen(x_info)) {
								format(wstring, sizeof(wstring), "[------------------------[%s]------------------------]", Businesses[i][BusinessName]);
								SendClientMessage(playerid, COLOR_LIGHTGREEN, wstring);
								SendClientMessage(playerid, COLOR_RED, "(Type name, no spaces. Example. baseballbat)");
								SendClientMessage(playerid, COLOR_WHITE, "* Baseball Bat - Price: $200.");
								SendClientMessage(playerid, COLOR_WHITE, "* Shovel - Price: $100.");
								SendClientMessage(playerid, COLOR_WHITE, "* Chainsaw - Price: $5000.");
								SendClientMessage(playerid, COLOR_WHITE, "* Phone Book - Price: $5000. (/phonebook)");
								SendClientMessage(playerid, COLOR_WHITE, "* Flowers - Price: $25.");
								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[-------------------------------------------------------------------------------------] ");
								return 1;
							}
							if(strcmp(x_info,"baseballbat",true) == 0)
							{
								if(GetPlayerCash(playerid) >= 200)
								{
								    GivePlayerWeapon(playerid,5,1);
								    GivePlayerCash(playerid,-200);
								    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought a baseball bat.");
								    Businesses[i][Products]--;
								    Businesses[i][Till]+=200;
								    SaveBusinesses();
								    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets an item back in return.");
								    return 1;

								}
								else
								{
								    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
								}
							}
							else if(strcmp(x_info,"shovel",true) == 0)
							{
								if(GetPlayerCash(playerid) >= 100)
								{
								    GivePlayerWeapon(playerid,6,1);
								    GivePlayerCash(playerid,-100);
								    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought a shovel.");
								    Businesses[i][Products]--;
								    Businesses[i][Till]+=100;
								    SaveBusinesses();
								    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets an item back in return.");
								    return 1;

								}
								else
								{
								    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
								}
							}
							else if(strcmp(x_info,"chainsaw",true) == 0)
							{
								if(GetPlayerCash(playerid) >= 5000)
								{
								    GivePlayerWeapon(playerid,9,1);
								    GivePlayerCash(playerid,-5000);
								    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought a chainsaw.");
								    Businesses[i][Products]--;
								    Businesses[i][Till]+=5000;
								    SaveBusinesses();
								    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets an item back in return.");
								    return 1;

								}
								else
								{
								    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
								}
							}
       						else if(strcmp(x_info,"phonebook",true) == 0)
							{
								if(GetPlayerCash(playerid) >= 5000)
								{
								    GivePlayerCash(playerid,-5000);
								    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought a phone book (/phonebook).");
								    Businesses[i][Products]--;
								    Businesses[i][Till]+=5000;
								    PlayerInfo[playerid][pPhoneBook] = 1;
								    SaveBusinesses();
								    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets an item back in return.");
								    return 1;

								}
								else
								{
								    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
								}
							}
							else if(strcmp(x_info,"flowers",true) == 0)
							{
								if(GetPlayerCash(playerid) >= 25)
								{
								    GivePlayerWeapon(playerid,14,1);
								    GivePlayerCash(playerid,-25);
								    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought flowers.");
								    Businesses[i][Products]--;
								    Businesses[i][Till]+=25;
								    SaveBusinesses();
								    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets an item back in return.");
                                    return 1;
								}
							}
						}
					}
				}
			}
		}
	}
	return 1;
}
 	if(strcmp(cmd,"/buyweapon",true)==0)
	{
 	if(IsPlayerConnected(playerid))
 	{
  		for(new i = 0; i < sizeof(Businesses); i++)
		{
			if (PlayerToPoint(25.0, playerid,Businesses[i][ExitX], Businesses[i][ExitY], Businesses[i][ExitZ]))
			{
				if(GetPlayerVirtualWorld(playerid) == i)
	   			{
				    if(Businesses[i][BizType] == 4) //Ammunation
			    	{
		        		if(Businesses[i][Products] != 0)
		        		{
							new x_info[128];
							x_info = strtok(cmdtext, idx);
						    new wstring[128];

							if(!strlen(x_info)) {
								format(wstring, sizeof(wstring), "[------------------------[%s]------------------------]", Businesses[i][BusinessName]);
								SendClientMessage(playerid, COLOR_LIGHTGREEN, wstring);
								SendClientMessage(playerid, COLOR_RED, "(Type name, no spaces, no capitals. Example. deagle)");
								SendClientMessage(playerid, COLOR_WHITE, "* Deagle - Price: $3500 - 200 Ammo.");
								SendClientMessage(playerid, COLOR_WHITE, "* MP5 - Price: $5000 - 500 Ammo.");
								SendClientMessage(playerid, COLOR_WHITE, "* M4 - Price: $5000 - 500 Ammo.");
								SendClientMessage(playerid, COLOR_WHITE, "* Country Rifle - Price: $8000 - 500 Ammo.");
								SendClientMessage(playerid, COLOR_WHITE, "* Sniper Rifle - Price: $12000 - 500 Ammo.");
								SendClientMessage(playerid, COLOR_WHITE, "* Silenced Pistol - Price: $3500 - 200 Ammo.");
								SendClientMessage(playerid, COLOR_WHITE, "* Shotgun - Price: $4500 - 200 Ammo.");
								SendClientMessage(playerid, COLOR_WHITE, "* Pepperspray - Price:$1000 - 500 Ammo.");
								SendClientMessage(playerid, COLOR_WHITE, "* Body Armour - Price: $1500.");
								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[-------------------------------------------------------------------------------------] ");
								return 1;
							}
							if(PlayerInfo[playerid][pWepLic])
							{
								if(strcmp(x_info,"deagle",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 3500)
									{
									    GivePlayerWeapon(playerid,24,200);
									    GivePlayerCash(playerid,-3500);
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought a Desert Eagle.");
									    Businesses[i][Products]--;
									    Businesses[i][Till]+=3500;
									    SaveBusinesses();
									    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets a weapon back in return.");
									    return 1;

									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
									    return 1;
									}
								}
								else if(strcmp(x_info,"mp5",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 5000)
									{
									    GivePlayerWeapon(playerid,29,500);
									    GivePlayerCash(playerid,-5000);
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought a MP5.");
									    Businesses[i][Products]--;
									    Businesses[i][Till]+=5000;
									    SaveBusinesses();
									    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets a weapon back in return.");
									    return 1;

									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
									    return 1;
									}
								}
	       						else if(strcmp(x_info,"m4",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 5000)
									{
									    GivePlayerWeapon(playerid,31,500);
									    GivePlayerCash(playerid,-5000);
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought a M4.");
									    Businesses[i][Products]--;
									    Businesses[i][Till]+=5000;
									    SaveBusinesses();
									    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets a weapon back in return.");
									    return 1;

									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
									    return 1;
									}
								}
	 							else if(strcmp(x_info,"countryrifle",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 8000)
									{
									    GivePlayerWeapon(playerid,33,500);
									    GivePlayerCash(playerid,-8000);
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought a Country Rifle.");
									    Businesses[i][Products]--;
									    Businesses[i][Till]+=8000;
									    SaveBusinesses();
									    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets a weapon back in return.");
									    return 1;

									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
									    return 1;
									}
								}
								else if(strcmp(x_info,"sniperrifle",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 12000)
									{
									    GivePlayerWeapon(playerid,34,500);
									    GivePlayerCash(playerid,-12000);
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought a Sniper Rifle.");
									    Businesses[i][Products]--;
									    Businesses[i][Till]+=12000;
									    SaveBusinesses();
									    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets a weapon back in return.");
									    return 1;

									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
									    return 1;
									}
								}
								else if(strcmp(x_info,"silencedpistol",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 3500)
									{
									    GivePlayerWeapon(playerid,23,200);
									    GivePlayerCash(playerid,-3500);
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought a 9MM Silenced Pistol.");
									    Businesses[i][Products]--;
									    Businesses[i][Till]+=3500;
									    SaveBusinesses();
									    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets a weapon back in return.");
									    return 1;

									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
									    return 1;
									}
								}
								else if(strcmp(x_info,"shotgun",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 4500)
									{
									    GivePlayerWeapon(playerid,25,200);
									    GivePlayerCash(playerid,-4500);
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought a Shotgun.");
									    Businesses[i][Products]--;
									    Businesses[i][Till]+=4500;
									    SaveBusinesses();
									    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets a weapon back in return.");
									    return 1;

									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
									    return 1;
									}
								}
							}
							else
							{
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have a weapon license, you can only buy:");
								SendClientMessage(playerid, COLOR_RED, "(Type name, no spaces, no capitals. Example. deagle)");
								SendClientMessage(playerid, COLOR_WHITE, "* Pepperspray - Price: $1000 - 500 Ammo.");
								SendClientMessage(playerid, COLOR_WHITE, "* Body Armour - Price: $1500.");
							}
							if(strcmp(x_info,"pepperspray",true) == 0)
							{
								if(GetPlayerCash(playerid) >= 1000)
								{
								    GivePlayerWeapon(playerid,41,500);
								    GivePlayerCash(playerid,-1000);
								    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought Pepperspray.");
								    Businesses[i][Products]--;
								    Businesses[i][Till]+=1000;
								    SaveBusinesses();
								    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets a weapon back in return.");
								    return 1;

								}
								else
								{
								    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
								    return 1;
								}
							}
							else if(strcmp(x_info,"bodyarmour",true) == 0)
							{
								if(GetPlayerCash(playerid) >= 1500)
								{
								    new Float:armour;
								    GetPlayerArmour(playerid,armour);
								    if(armour != 100.0)
								    {
									    GivePlayerCash(playerid,-1500);
									    SetPlayerArmour(playerid,100);
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] You have successfully bought Body Armour.");
									    Businesses[i][Products]--;
									    Businesses[i][Till]+=1500;
									    SaveBusinesses();
									    PlayerActionMessage(playerid,15.0,"gives the store clerk some money and gets body armour back in return.");
									    return 1;
								    }
								    else
								    {
								    	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your armour's full!");
								    	return 1;
								    }
								}
							}
						}
					}
				}
			}
		}
	}
	return 1;
}
	if(strcmp(cmd, "/buyclothes", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /buyclothes [skinid]");
				return 1;
			}
			new id = strval(tmp);
		    for(new i = 0; i < sizeof(Businesses); i++)
			{
				if (PlayerToPoint(25.0, playerid,Businesses[i][ExitX], Businesses[i][ExitY], Businesses[i][ExitZ]))
				{
					if(GetPlayerVirtualWorld(playerid) == i)
		   			{
					    if(Businesses[i][BizType] == 6)
					    {
					        if(Businesses[i][Products] != 0)
					        {
					            if(GetPlayerCash(playerid) >= 100)
					            {
					                if(IsACopSkin(id) == 0)
									{
										if(IsValidSkin(id))
										{
											SetPlayerSkin(playerid,id);
											GivePlayerCash(playerid,-100);
											Businesses[i][Products]--;
											Businesses[i][Till]+=100;
											SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INFO:] Clothes purchased, $-100.");
											SaveBusinesses();
											return 1;
										}
			        				}
								}
	        				}
	    				}
	   				}
				}
	   		}
		}
		return 1;
	}
	if(strcmp(cmd, "/buyphone", true) == 0)
	{
	    for(new i = 0; i < sizeof(Businesses); i++)
		{
			if (PlayerToPoint(25.0, playerid,Businesses[i][ExitX], Businesses[i][ExitY], Businesses[i][ExitZ]))
			{
				if(GetPlayerVirtualWorld(playerid) == i)
	   			{
				    if(Businesses[i][BizType] == 2)
				    {
				        if(Businesses[i][Products] != 0)
				        {
					        if(GetPlayerCash(playerid) >= 500)
					        {
				    			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
           						SendClientMessage(playerid,COLOR_WHITE,"[FOOD:] You have just purchased a phone! $-500");
                 				GivePlayerCash(playerid,-500);
                     			Businesses[i][Till] += 500;
                        		Businesses[i][Products]--;
                          		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
 								PlayerActionMessage(playerid,15.0,"has just gave the clerk $500 and gotten a phone in return.");
 								new randphone = 9999 + random(999999);//minimum 9999  max 999999
								PlayerInfo[playerid][pPhoneNumber] = randphone;
								PlayerInfo[playerid][pPhoneC] = i;
 								SaveBusinesses();
 								return 1;
							}
						}
					}
				}
			}
		}
		return 1;
	}
	if(strcmp(cmd,"/buydrink",true)==0)
	{
	 	if(IsPlayerConnected(playerid))
	 	{
   			for(new i = 0; i < sizeof(Businesses); i++)
			{
				if (PlayerToPoint(25.0, playerid,Businesses[i][ExitX], Businesses[i][ExitY], Businesses[i][ExitZ]))
				{
					if(GetPlayerVirtualWorld(playerid) == i)
					{
			    		if(Businesses[i][BizType] == 7)
			    		{
			    			new x_info[128];
							x_info = strtok(cmdtext, idx);

							if(!strlen(x_info)) {
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /buydrink [item]");
								SendClientMessage(playerid, COLOR_WHITE, "[ITEM:] Beer - Price: $7.");
								SendClientMessage(playerid, COLOR_WHITE, "[ITEM:] Vodka - Price: $10.");
								SendClientMessage(playerid, COLOR_WHITE, "[ITEM:] Cola - Price: $3.");
								SendClientMessage(playerid, COLOR_WHITE, "[ITEM:] Water - Price: $3.");
								SendClientMessage(playerid, COLOR_WHITE, "[ITEM:] Whiskey - Price: $10.");
								SendClientMessage(playerid, COLOR_WHITE, "[ITEM:] Brandy - Price: $15.");
								SendClientMessage(playerid, COLOR_WHITE, "[ITEM:] Soda - Price: $3.");
								return 1;
							}
				        	if(Businesses[i][Products] != 0)
				        	{
				        	    new Float:HP;
				        	    GetPlayerHealth(playerid,HP);
								if(strcmp(x_info,"beer",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 7)
									{
	           						GivePlayerCash(playerid,-7);
                     		       	Businesses[i][Till] += 7;
                        		    Businesses[i][Products]--;
                              		if(HP < 100)
                        		    {
                          		  		SetPlayerHealth(playerid,HP+15.0);
                          		  	}
							  		PlayerActionMessage(playerid,15.0,"has just bought a beer, then drinks it.");
							  		SaveBusinesses();
							  		return 1;
									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money.");
									    return 1;
									}
								}
        						if(strcmp(x_info,"vodka",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 10)
									{
	           						GivePlayerCash(playerid,-10);
                     		       	Businesses[i][Till] += 10;
                        		    Businesses[i][Products]--;
                              		if(HP < 100)
                        		    {
                          		  		SetPlayerHealth(playerid,HP+20.0);
                          		  	}
							  		PlayerActionMessage(playerid,15.0,"has just bought a shot of vodka, then drinks it.");
							  		SaveBusinesses();
							  		return 1;
									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money.");
									    return 1;
									}
								}
        						if(strcmp(x_info,"cola",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 3)
									{
	           						GivePlayerCash(playerid,-3);
                     		       	Businesses[i][Till] += 3;
                        		    Businesses[i][Products]--;
                              		if(HP < 100)
                        		    {
                          		  		SetPlayerHealth(playerid,HP+2.0);
                          		  	}
							  		PlayerActionMessage(playerid,15.0,"has just bought a cola, then drinks it.");
							  		SaveBusinesses();
							  		return 1;
									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money.");
									    return 1;
									}
								}
       	 						if(strcmp(x_info,"water",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 1)
									{
	           						GivePlayerCash(playerid,-1);
                     		       	Businesses[i][Till] += 1;
                        		    Businesses[i][Products]--;
                              		if(HP < 100)
                        		    {
                          		  		SetPlayerHealth(playerid,HP+1.0);
                          		  	}
							  		PlayerActionMessage(playerid,15.0,"has just bought a glass of water, then drinks it.");
							  		SaveBusinesses();
							  		return 1;
									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money.");
									    return 1;
									}
								}
        						if(strcmp(x_info,"whiskey",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 10)
									{
	           						GivePlayerCash(playerid,-10);
                     		       	Businesses[i][Till] += 10;
                        		    Businesses[i][Products]--;
                              		if(HP < 100)
                        		    {
                          		  		SetPlayerHealth(playerid,HP+20.0);
                          		  	}
							  		PlayerActionMessage(playerid,15.0,"has just bought a glass of whiskey, then drinks it.");
							  		SaveBusinesses();
							  		return 1;
									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money.");
									    return 1;
									}
								}
								if(strcmp(x_info,"brandy",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 15)
									{
	           						GivePlayerCash(playerid,-15);
                     		       	Businesses[i][Till] += 15;
                        		    Businesses[i][Products]--;
                              		if(HP < 100)
                        		    {
                          		  		SetPlayerHealth(playerid,HP+25.0);
                          		  	}
							  		PlayerActionMessage(playerid,15.0,"has just bought a glass of brandy, then drinks it.");
							  		SaveBusinesses();
							  		return 1;
									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money.");
									    return 1;
									}
								}
        						if(strcmp(x_info,"soda",true) == 0)
								{
									if(GetPlayerCash(playerid) >= 3)
									{
	           						GivePlayerCash(playerid,-3);
                     		       	Businesses[i][Till] += 3;
                        		    Businesses[i][Products]--;
                              		if(HP < 100)
                        		    {
                          		  		SetPlayerHealth(playerid,HP+2.0);
                          		  	}
							  		PlayerActionMessage(playerid,15.0,"has just bought a soda, then drinks it.");
							  		SaveBusinesses();
							  		return 1;
									}
									else
									{
									    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money.");
									    return 1;
									}
								}
							}
						}
					}
				}
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/eat", true) == 0)
	{
	    for(new i = 0; i < sizeof(Businesses); i++)
		{
			if (PlayerToPoint(25.0, playerid,Businesses[i][ExitX], Businesses[i][ExitY], Businesses[i][ExitZ]))
			{
				if(GetPlayerVirtualWorld(playerid) == i)
	   			{
				    if(Businesses[i][BizType] == 1)
				    {
				        if(Businesses[i][Products] != 0)
				        {
					        if(GetPlayerCash(playerid) >= 15)
					        {
						        if(PlayerToPoint(25.0,playerid,377.0869,-68.1940,1001.5151))//Burger Shot
						        {
				    				SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
           		                 	SendClientMessage(playerid,COLOR_WHITE,"[FOOD:] You have just eaten a hamburger and fries. -$15");
	           						GivePlayerCash(playerid,-15);
                     		       	Businesses[i][Till] += 15;
                        		    Businesses[i][Products]--;
                          		  	SetPlayerHealth(playerid,100);
        							SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
							  		PlayerActionMessage(playerid,15.0,"has just eaten a hamburger and fries.");
							  		SaveBusinesses();
									return 1;
        						}
		      					else if(PlayerToPoint(25.0,playerid,369.6264,-6.5964,1001.8589))//Cluckin Bell
						        {
								    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
		          					SendClientMessage(playerid,COLOR_WHITE,"[FOOD:] You have just eaten a chickenburger and fries. -$15");
		          					GivePlayerCash(playerid,-15);
		          					Businesses[i][Till] += 15;
		          					Businesses[i][Products]--;
		          					SetPlayerHealth(playerid,100);
		          					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
	   								PlayerActionMessage(playerid,15.0,"has just eaten a chickenburger and fries.");
	   								SaveBusinesses();
									return 1;
								}
	  							else if(PlayerToPoint(25.0,playerid,375.7379,-119.1621,1001.4995))//Well Stacked Pizza
						        {
								    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
		          					SendClientMessage(playerid,COLOR_WHITE,"[FOOD:] You have just eaten a large pizza and drunk a large drink. -$15");
		          					GivePlayerCash(playerid,-15);
		          					Businesses[i][Till] += 15;
		          					Businesses[i][Products]--;
		          					SetPlayerHealth(playerid,100);
		          					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
	   								PlayerActionMessage(playerid,15.0,"has just eaten a large pizza and drunk a large drink.");
	   								SaveBusinesses();
									return 1;
								}
								else if(PlayerToPoint(25.0,playerid,378.7731,-186.7205,1000.6328))//Rusty Browns Dohnuts
						        {
								    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
		          					SendClientMessage(playerid,COLOR_WHITE,"[FOOD:] You have just eaten two dohnuts and had a large drink. -$15");
		          					GivePlayerCash(playerid,-15);
		          					Businesses[i][Till] += 15;
		          					Businesses[i][Products]--;
		          					SetPlayerHealth(playerid,100);
		          					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
	   								PlayerActionMessage(playerid,15.0,"has just eaten two dohnuts and had a large drink.");
	   								SaveBusinesses();
									return 1;
								}
								else
								{
								    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
		          					SendClientMessage(playerid,COLOR_WHITE,"[FOOD:] You have just eaten some food. -$15");
		          					GivePlayerCash(playerid,-15);
		          					Businesses[i][Till] += 15;
		          					Businesses[i][Products]--;
		          					SetPlayerHealth(playerid,100);
		          					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"____________________________________________________");
	   								PlayerActionMessage(playerid,15.0,"has just eaten some food.");
	   								SaveBusinesses();
									return 1;
        						}
							}
						}
					}
				}
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/factiondrugstake", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			new bouse = PlayerInfo[playerid][pFaction];
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] != 1)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /factiondrugstake [amount]");
					return 1;
				}
				new materialsdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /factiondrugstake [amount]");
					return 1;
				}
				if(PlayerInfo[playerid][pRank] == 1)
				{
					if (PlayerToPoint(1.0, playerid,FactionDrugsStorage[X],FactionDrugsStorage[Y],FactionDrugsStorage[Z]))
					{
					    if(DynamicFactions[bouse][fDrugs] >= materialsdeposit)
					    {
							PlayerInfo[playerid][pDrugs] += materialsdeposit;
							DynamicFactions[bouse][fDrugs]=DynamicFactions[bouse][fDrugs]-materialsdeposit;
							format(string, sizeof(string), "[INFO:] You have taken %d materials from the storage facility, Materials Total: %d ", materialsdeposit,DynamicFactions[bouse][fDrugs]);
							SendClientMessage(playerid, COLOR_WHITE, string);
   							PlayerActionMessage(playerid,15.0,"takes out drugs from storage.");
							format(string, sizeof(string), "[FACTION:] %s has just taken %d drugs from the faction storage facility.",GetPlayerNameEx(playerid),materialsdeposit);
							SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, string);
							SaveDynamicFactions();
							return 1;
						}
	 					else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] There isn't that much drugs in storage!");
						}
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are not at the faction storage facility!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are not the leader of the faction!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are not in a faction!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/factiondrugsput", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			new bouse = PlayerInfo[playerid][pFaction];
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] != 1)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /factiondrugsput [amount]");
					return 1;
				}
				new materialsdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /factiondrugsput [amount]");
					return 1;
				}
				if (PlayerToPoint(1.0, playerid,FactionDrugsStorage[X],FactionDrugsStorage[Y],FactionDrugsStorage[Z]))
				{
				    if(PlayerInfo[playerid][pDrugs] >= materialsdeposit)
				    {
						PlayerInfo[playerid][pDrugs] -= materialsdeposit;
						DynamicFactions[bouse][fDrugs]=DynamicFactions[bouse][fDrugs]+materialsdeposit;
						format(string, sizeof(string), "[INFO:] You have put %d drugs into your faction storage, Materials Total: %d ", materialsdeposit,DynamicFactions[bouse][fDrugs]);
						SendClientMessage(playerid, COLOR_WHITE, string);
        				PlayerActionMessage(playerid,15.0,"puts drugs into storage.");
						format(string, sizeof(string), "[FACTION:] %s has just put %d drugs in the faction storage facility.",GetPlayerNameEx(playerid),materialsdeposit);
						SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, string);
						SaveDynamicFactions();
						return 1;
					}
 					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have that much drugs!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are not at the faction storage facility!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Invalid Faction.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/factionmatstake", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			new bouse = PlayerInfo[playerid][pFaction];
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] != 1)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /factionmatstake [amount]");
					return 1;
				}
				new materialsdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /factionmatstake [amount]");
					return 1;
				}
				if(PlayerInfo[playerid][pRank] == 1)
				{
					if (PlayerToPoint(1.0, playerid,FactionMaterialsStorage[X],FactionMaterialsStorage[Y],FactionMaterialsStorage[Z]))
					{
					    if(DynamicFactions[bouse][fMaterials] >= materialsdeposit)
					    {
							PlayerInfo[playerid][pMaterials] += materialsdeposit;
							DynamicFactions[bouse][fMaterials]=DynamicFactions[bouse][fMaterials]-materialsdeposit;
							format(string, sizeof(string), "[INFO:] You have taken %d materials from the storage facility, Materials Total: %d ", materialsdeposit,DynamicFactions[bouse][fMaterials]);
							SendClientMessage(playerid, COLOR_WHITE, string);
   							PlayerActionMessage(playerid,15.0,"takes out some weapon materials from the boxes.");
							format(string, sizeof(string), "[FACTION:] %s has just taken %d weapon materials from the faction storage facility.",GetPlayerNameEx(playerid),materialsdeposit);
							SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, string);
							SaveDynamicFactions();
							return 1;
						}
	 					else
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] There isn't that much materials in storage!");
						}
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are not at the faction storage facility!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are not the leader of the faction!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are not in a faction!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/factionmatsput", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			new bouse = PlayerInfo[playerid][pFaction];
			if(PlayerInfo[playerid][pFaction] != 255 && DynamicFactions[PlayerInfo[playerid][pFaction]][fType] != 1)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /factionmatsput [amount]");
					return 1;
				}
				new materialsdeposit = strval(tmp);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /factionmatsput [amount]");
					return 1;
				}
				if (PlayerToPoint(1.0, playerid,FactionMaterialsStorage[X],FactionMaterialsStorage[Y],FactionMaterialsStorage[Z]))
				{
				    if(PlayerInfo[playerid][pMaterials] >= materialsdeposit)
				    {
						PlayerInfo[playerid][pMaterials] -= materialsdeposit;
						DynamicFactions[bouse][fMaterials]=DynamicFactions[bouse][fMaterials]+materialsdeposit;
						format(string, sizeof(string), "[INFO:] You have put %d materials into your faction storage, Materials Total: %d ", materialsdeposit,DynamicFactions[bouse][fMaterials]);
						SendClientMessage(playerid, COLOR_WHITE, string);
        				PlayerActionMessage(playerid,15.0,"puts weapon materials into the boxes.");
						format(string, sizeof(string), "[FACTION:] %s has just put %d weapon materials in the faction storage facility.",GetPlayerNameEx(playerid),materialsdeposit);
						SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_FACTIONCHAT, string);
						SaveDynamicFactions();
						return 1;
					}
 					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have that much materials!");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are not at the faction storage facility!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Invalid Faction.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/sellhouse", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			if(PlayerInfo[playerid][pHouseKey] != 255 && strcmp(playername, Houses[PlayerInfo[playerid][pHouseKey]][Owner], true) == 0)
			{
			    new house = PlayerInfo[playerid][pHouseKey];
				if(PlayerToPoint(1.0,playerid,Houses[house][EnterX],Houses[house][EnterY],Houses[house][EnterZ]))
				{
					Houses[house][Locked] = 1;
					Houses[house][Owned] = 0;
					strmid(Houses[house][Owner], "None", 0, strlen("None"), 255);
					GivePlayerCash(playerid,Houses[house][HousePrice]);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "[INFO:] You have sold your house for $%d.", Houses[house][HousePrice]);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					ChangeStreamPickupModel(Houses[house][PickupID],1273);
					PlayerInfo[playerid][pHouseKey] = 255;
					OnPlayerDataSave(playerid);
       				PlayerActionMessage(playerid,15.0,"takes out his house key and hands it to the real estate agent.");
					SaveHouses();
					return 1;
				}
				else
				{
				    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You must be at your house entrance to sell it!");
				}
			}
			else
			{
    			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't even own a house!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/openhouse", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        for(new i = 0; i < sizeof(Houses); i++)
			{
				if (PlayerToPoint(3.0, playerid,Houses[i][EnterX], Houses[i][EnterY], Houses[i][EnterZ]) || PlayerToPoint(3.0, playerid,Houses[i][ExitX], Houses[i][ExitY], Houses[i][ExitZ]))
				{
					if(PlayerInfo[playerid][pHouseKey] == i)
					{
						if(Houses[i][Locked] == 1)
						{
							Houses[i][Locked] = 0;
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"[INFO:] Door Unlocked.");
		                    PlayerActionMessage(playerid,15.0,"puts in there key and opens the door.");
		                    SaveHouses();
							return 1;
						}
						if(Houses[i][Locked] == 0)
						{
							Houses[i][Locked] = 1;
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"[INFO:] Door Locked.");
		                    PlayerActionMessage(playerid,15.0,"puts in there key and locks the door.");
		                    SaveHouses();
							return 1;
						}
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"[ERROR:] You don't have a key for this house!");
						return 1;
					}
				}
			}
	    }
	    return 1;
	}
 	if(strcmp(cmd, "/openbusiness", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        for(new i = 0; i < sizeof(Businesses); i++)
			{
				if (PlayerToPoint(3.0, playerid,Businesses[i][EnterX], Businesses[i][EnterY], Businesses[i][EnterZ]) || PlayerToPoint(3.0, playerid,Businesses[i][ExitX], Businesses[i][ExitY], Businesses[i][ExitZ]))
				{
					new playername[MAX_PLAYER_NAME];
					GetPlayerName(playerid,playername,sizeof(playername));
					if(PlayerInfo[playerid][pBizKey] == i && strcmp(playername, Businesses[PlayerInfo[playerid][pBizKey]][Owner], true) == 0)
					{
						if(Businesses[i][Locked] == 1)
						{
			    			if(PlayerInfo[playerid][pSex] == 1)
						    {
								Businesses[i][Locked] = 0;
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"[INFO:] Door Unlocked.");
			                    PlayerActionMessage(playerid,15.0,"puts in his key and opens the door.");
			                    SaveBusinesses();
		                    }
		                    else
						    {
								Businesses[i][Locked] = 0;
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"[INFO:] Door Unlocked.");
			                    PlayerActionMessage(playerid,15.0,"puts in her key and opens the door.");
			                    SaveBusinesses();
		                    }
							return 1;
						}
						if(Businesses[i][Locked] == 0)
						{
						    if(PlayerInfo[playerid][pSex] == 1)
						    {
								Businesses[i][Locked] = 1;
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"[INFO:] Door Locked.");
			                    PlayerActionMessage(playerid,15.0,"puts in his key and locks the door.");
			                    SaveBusinesses();
		                    }
		                    else
						    {
								Businesses[i][Locked] = 1;
								SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"[INFO:] Door Locked.");
			                    PlayerActionMessage(playerid,15.0,"puts in her key and locks the door.");
			                    SaveBusinesses();
		                    }
							return 1;
						}
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"[ERROR:] You don't have a key for this business!");
						return 1;
					}
				}
			}
	    }
	    return 1;
	}
 	if(strcmp(cmd, "/renthouse", true) == 0)
	{
		if(IsPlayerConnected(playerid))
		{
			new Float:oldposx, Float:oldposy, Float:oldposz;
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			GetPlayerPos(playerid, oldposx, oldposy, oldposz);
			for(new h = 0; h < sizeof(Houses); h++)
			{
				if(PlayerToPoint(2.0, playerid, Houses[h][EnterX], Houses[h][EnterY], Houses[h][EnterZ]) && Houses[h][Owned] == 1 &&  Houses[h][Rentable] == 1)
				{
					if(PlayerInfo[playerid][pHouseKey] != 255 && strcmp(playername, Houses[PlayerInfo[playerid][pHouseKey]][Owner], true) == 0)
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You already own a house!");
						return 1;
					}
					if(GetPlayerCash(playerid) >= Houses[h][RentCost])
					{
						PlayerInfo[playerid][pHouseKey] = h;
						GivePlayerCash(playerid,-Houses[h][RentCost]);
						Houses[h][Money] = Houses[h][Money]+Houses[h][RentCost];
						SetPlayerInterior(playerid,Houses[h][ExitInterior]);
						SetPlayerPos(playerid,Houses[h][ExitX],Houses[h][ExitY],Houses[h][ExitZ]);
						SetPlayerVirtualWorld(playerid,h);
						SendClientMessage(playerid, COLOR_GREEN, "[INFO:] House successfully rented, the money you paid is a one time fee.");
						OnPlayerDataSave(playerid);
						return 1;
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INFO:] You can't afford it!");
						return 1;
					}
				}
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/rentfee", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
			new bouse = PlayerInfo[playerid][pHouseKey];
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			if (bouse != 255 && strcmp(playername, Houses[PlayerInfo[playerid][pHouseKey]][Owner], true) == 0)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /rentfee [amount]");
					return 1;
				}
				if(strval(tmp) < 1 || strval(tmp) > 99999)
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Please enter an amount between $1-99999.");
					return 1;
				}
				Houses[bouse][RentCost] = strval(tmp);
				SaveHouses();
				format(string, sizeof(string), "[INFO:] You have set the rent fee to: $%d", Houses[bouse][RentCost]);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't even own a house!");
				return 1;
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/editrenting", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			if (PlayerInfo[playerid][pHouseKey] != 255 && strcmp(playername, Houses[PlayerInfo[playerid][pHouseKey]][Owner], true) == 0)
			{
				if(Houses[PlayerInfo[playerid][pHouseKey]][Rentable] == 0)
				{
    				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INFO:] Renting enabled.");
				    Houses[PlayerInfo[playerid][pHouseKey]][Rentable] = 1;
				    SaveHouses();
				}
				else if(Houses[PlayerInfo[playerid][pHouseKey]][Rentable] == 1)
				{
    				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INFO:] Renting disabled.");
				    Houses[PlayerInfo[playerid][pHouseKey]][Rentable] = 0;
				    SaveHouses();
				}
				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "   You don't own a house !");
				return 1;
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/buyhouse", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			new Float:oldposx, Float:oldposy, Float:oldposz;
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			GetPlayerPos(playerid, oldposx, oldposy, oldposz);
			for(new h = 0; h < sizeof(Houses); h++)
			{
				if(PlayerToPoint(2.0, playerid, Houses[h][EnterX], Houses[h][EnterY], Houses[h][EnterZ]) && Houses[h][Owned] == 0)
				{
				    if(Houses[h][HousePrice] == 0)
				    {
				        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] A price isn't set for this house, it's possibly not ment to be used.");
						return 1;
				    }
					if(PlayerInfo[playerid][pHouseKey] != 255 && strcmp(playername, Houses[PlayerInfo[playerid][pHouseKey]][Owner], true) == 0)
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You can only own one house, please sell your original house first.");
						return 1;
					}
					if(GetPlayerCash(playerid) > Houses[h][HousePrice])
					{
      					PlayerInfo[playerid][pHouseKey] = h;
						Houses[h][Owned] = 1;
						strmid(Houses[h][Owner], playername, 0, strlen(playername), 255);
						GivePlayerCash(playerid,-Houses[h][HousePrice]);
						SetPlayerInterior(playerid,Houses[h][ExitInterior]);
						SetPlayerVirtualWorld(playerid,h);
						SetPlayerPos(playerid,Houses[h][ExitX],Houses[h][ExitY],Houses[h][ExitZ]);
						SendClientMessage(playerid, COLOR_WHITE, "[INFO:] You have successfully purchased this property!");
	       				PlayerActionMessage(playerid,15.0,"hands a package full of money to the estate agent, who then give returns with a key.");
						ChangeStreamPickupModel(Houses[h][PickupID],1239);
						SaveHouses();
						OnPlayerDataSave(playerid);
						return 1;
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
						return 1;
					}
				}
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/businessfee", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
			new bouse = PlayerInfo[playerid][pBizKey];
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid,playername,sizeof(playername));
			if (bouse != 255 && strcmp(playername, Businesses[PlayerInfo[playerid][pBizKey]][Owner], true) == 0)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /businessfee [amount]");
				}
				if(strval(tmp) < 0 || strval(tmp) > 99999)
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Minimum entrance is fee $0, Maximum entrance is fee $99999.");
					return 1;
				}
				Businesses[bouse][EntranceCost] = strval(tmp);
				format(string, sizeof(string), "[INFO:] Business Entrance fee set to $%d.", Businesses[bouse][EntranceCost]);
				SendClientMessage(playerid, COLOR_WHITE, string);
				SaveBusinesses();
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't even own a business!");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/businessname", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
			new bouse = PlayerInfo[playerid][pBizKey];
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid,playername,sizeof(playername));
			if (bouse != 255 && strcmp(playername, Businesses[PlayerInfo[playerid][pBizKey]][Owner], true) == 0)
			{
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[64];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /businessname [name]");
				}
				if(PlayerToPoint(1.0,playerid,Businesses[bouse][EnterX],Businesses[bouse][EnterY],Businesses[bouse][EnterZ]) || PlayerToPoint(25.0,playerid,Businesses[bouse][ExitX],Businesses[bouse][ExitY],Businesses[bouse][ExitZ]))
				{
				    if(strfind( result , "|" , true ) == -1)
				    {
						strmid(Businesses[bouse][BusinessName], result, 0, 64, 255);
						format(string, sizeof(string), "[INFO:} You have set your business name to: %s.",Businesses[bouse][BusinessName]);
						SendClientMessage(playerid, COLOR_WHITE, string);
						SaveBusinesses();
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Invalid Symbol, the symbol | is not allowed.");
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You must be at your business entrance/inside your business to change it's name!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't even own a business!");
			}
		}
		return 1;
	}
 	if (strcmp(cmd, "/businessinfo", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
			new bouse = PlayerInfo[playerid][pBizKey];
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid,playername,sizeof(playername));
			if(bouse != 255 && strcmp(playername, Businesses[PlayerInfo[playerid][pBizKey]][Owner], true) == 0)
			{
 				if(PlayerToPoint(1.0,playerid,Businesses[bouse][EnterX],Businesses[bouse][EnterY],Businesses[bouse][EnterZ]) || PlayerToPoint(20.0,playerid,Businesses[bouse][ExitX],Businesses[bouse][ExitY],Businesses[bouse][ExitZ]))
				{
					format(string, sizeof(string), "[INFO:] Business Name: %s - Till: $%d - Locked: %d - Products: %d - Entrance Fee: $%d.", Businesses[bouse][BusinessName],Businesses[bouse][Till],Businesses[bouse][Locked],Businesses[bouse][Products],Businesses[bouse][EntranceCost]);
					SendClientMessage(playerid, COLOR_WHITE, string);
					return 1;
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are not in your business!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't even own a business!");
			}
		}
		return 1;
	}
  	if(strcmp(cmd, "/sellbusiness", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			if(PlayerInfo[playerid][pBizKey] != 255 && strcmp(playername, Businesses[PlayerInfo[playerid][pBizKey]][Owner], true) == 0)
			{
			    new biz = PlayerInfo[playerid][pBizKey];
				if(PlayerToPoint(1.0,playerid,Businesses[biz][EnterX],Businesses[biz][EnterY],Businesses[biz][EnterZ]))
				{
					Businesses[biz][Locked] = 1;
					Businesses[biz][Owned] = 0;
					strmid(Businesses[biz][Owner], "None", 0, strlen("None"), 255);
					GivePlayerCash(playerid,Businesses[biz][BizPrice]);
					format(string, sizeof(string), "[INFO:] You have sold your business for $%d.", Businesses[biz][BizPrice]);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					ChangeStreamPickupModel(Businesses[biz][PickupID],1272);
					PlayerInfo[playerid][pBizKey] = 255;
					OnPlayerDataSave(playerid);
  					PlayerActionMessage(playerid,15.0,"tears up the business contract, and then gives away the key.");
					SaveBusinesses();
					return 1;
				}
				else
				{
				    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You must be at your business entrance to sell it!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't even own a business!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/buybusiness", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			new Float:oldposx, Float:oldposy, Float:oldposz;
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			GetPlayerPos(playerid, oldposx, oldposy, oldposz);
			for(new h = 0; h < sizeof(Businesses); h++)
			{
				if(PlayerToPoint(2.0, playerid, Businesses[h][EnterX], Businesses[h][EnterY], Businesses[h][EnterZ]) && Businesses[h][Owned] == 0)
				{
				    if(Businesses[h][BizPrice] == 0)
				    {
				        SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] A price isn't set for this business, it's possibly not ment to be used.");
						return 1;
				    }
					if(PlayerInfo[playerid][pBizKey] != 255 && strcmp(playername, Businesses[PlayerInfo[playerid][pBizKey]][Owner], true) == 0)
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You can only own one business, sell your original business first!");
						return 1;
					}
					if(GetPlayerCash(playerid) > Businesses[h][BizPrice])
					{
						PlayerInfo[playerid][pBizKey] = h;
						Businesses[h][Owned] = 1;
						strmid(Businesses[h][Owner], playername, 0, strlen(playername), 255);
						GivePlayerCash(playerid,-Businesses[h][BizPrice]);
						SetPlayerInterior(playerid,Businesses[h][ExitInterior]);
						SetPlayerVirtualWorld(playerid,h);
						SetPlayerPos(playerid,Businesses[h][ExitX],Businesses[h][ExitY],Businesses[h][ExitZ]);
						SendClientMessage(playerid, COLOR_WHITE, "[INFO:] You have successfully purchased this business!");
	       				PlayerActionMessage(playerid,15.0,"takes out some money and signs a contract, then recieves a key.");
						ChangeStreamPickupModel(Businesses[h][PickupID],1239);
						SaveBusinesses();
						OnPlayerDataSave(playerid);
						return 1;
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have enough money!");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/takedrivingtest", true) == 0)
	{
		if(PlayerToPoint(1.0,playerid,DrivingTestPosition[X],DrivingTestPosition[Y],DrivingTestPosition[Z]))
		{
		    if(PlayerInfo[playerid][pCarLic] == 0)
		    {
				if(GetPlayerCash(playerid) >= 500)
				{
					GivePlayerCash(playerid,-500);
					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] Your driving test has started, go outside and get in a car!");
					TakingDrivingTest[playerid] = 1;
				}
				else
				{
					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough money!");
				}
			}
			else
			{
				SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You already have a license!");
			}
		}
		else
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You are not at the driving school!");
		}
		return 1;
	}
 	if(strcmp(cmd, "/buyflyinglicense", true) == 0)
	{
		if(PlayerToPoint(1.0,playerid,FlyingTestPosition[X],FlyingTestPosition[Y],FlyingTestPosition[Z]))
		{
		    if(GetPlayerVirtualWorld(playerid) == FlyingTestPosition[World])
		    {
		        if(PlayerInfo[playerid][pFlyLic] == 0)
		        {
					if(GetPlayerCash(playerid) >= 20000)
					{
						GivePlayerCash(playerid,-20000);
						SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] You can now fly planes!");
						PlayerInfo[playerid][pFlyLic] = 1;
						OnPlayerDataSave(playerid);
					}
					else
					{
						SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough money!");
					}
				}
				else
				{
					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You already have a license!");
				}
			}
		}
		else
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You are not at the license location!");
		}
		return 1;
	}
  	if(strcmp(cmd, "/buyweaponlicense", true) == 0)
	{
		if(PlayerToPoint(1.0,playerid,WeaponLicensePosition[X],WeaponLicensePosition[Y],WeaponLicensePosition[Z]))
		{
		    if(GetPlayerVirtualWorld(playerid) == WeaponLicensePosition[World])
		    {
		        if(PlayerInfo[playerid][pWepLic] == 0)
		        {
					if(GetPlayerCash(playerid) >= 50000)
					{
						GivePlayerCash(playerid,-50000);
						SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] You can now use weapons legally, within reason of course.");
						PlayerInfo[playerid][pWepLic] = 1;
						OnPlayerDataSave(playerid);
					}
					else
					{
						SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough money!");
					}
				}
				else
				{
					SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You already have a license!");
				}
			}
		}
		else
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You are not at the license location!");
		}
		return 1;
	}
	if(strcmp(cmd, "/refuel", true) == 0)
	{
		if(IsAtGasStation(playerid))
		{
			new vehicle = GetPlayerVehicleID(playerid);
			new refillprice;
			if(Fuel[vehicle] <= 30)
			{
				refillprice = random(100);
			}
			else if(Fuel[vehicle] >= 40)
			{
				refillprice = random(70);
			}
			else if(Fuel[vehicle] >= 55)
			{
				refillprice = random(40);
			}
   			if(GetPlayerCash(playerid) >= refillprice)
   			{
   			    if(Fuel[vehicle] <= 99)
   			    {
	      			new form[128];
		        	format(form, sizeof(form), "[INFO:] Your car has been refueled for $%d, have a nice day.",refillprice);
		        	SendClientMessage(playerid,COLOR_LIGHTBLUE,form);
			        GivePlayerCash(playerid,-refillprice);
			        Fuel[vehicle] = 100;
		        }
		        else
		        {
		        	SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Your fuel is full!");
		        }
		    }
      		else
      		{
       			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have enough money!");
      		}
		}
		else
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You are not at a Gas Station!");
		}
 		return 1;
	}
	if(strcmp(cmd, "/stats", true) == 0)
	{
		ShowStats(playerid,playerid);
		return 1;
	}
	if(strcmp(cmd, "/spawnpoint", true) == 0)
	{
		if(PlayerInfo[playerid][pSpawnPoint] == 1)
		{
		    PlayerInfo[playerid][pSpawnPoint] = 0;
   		 	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INFO:] You will now spawn at your normal place.");
		}
		else
		{
			PlayerInfo[playerid][pSpawnPoint] = 1;
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[INFO:] You will now spawn at your home.");
		}
		return 1;
	}
	if(strcmp(cmd, "/afactioncmds", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 5:] - /afactionkick");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 10:] - /afactioncolor - /afactionspawn - /afactionname - /afactionuseskins - /afactionrankamount - /afactiontype");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 10:] - /afactionjoinrank - /afactiondrugs - /afactionbank - /afactionmats - /afactionskin");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 10:] - /afactionrankname - /agotofaction - /afactionusecolor - /afactiondrugsstorage - /afactionmatsstorage");
		}
		else
		{
			SendClientMessage(playerid,COLOR_RED,"[ERROR:] Your not an administrator!");
		}
		return 1;
	}
 	if(strcmp(cmd, "/abusinesscmds", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 7:] - /abusinessentrance - /abusinessexit - /abusinessprice - /agotobusiness - /abusinessproducts - /abusinesssell");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 7:] - /abusinessint");
		}
		else
		{
			SendClientMessage(playerid,COLOR_RED,"[ERROR:] Your not an administrator!");
		}
		return 1;
	}
	if(strcmp(cmd, "/abuildingcmds", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 10:] - /abuildingname - /abuildingentrance - /abuildingexit - /abuildingfee - /abuildinglock - /agotobuilding");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 10:] - /abuildingint");
		}
		else
		{
			SendClientMessage(playerid,COLOR_RED,"[ERROR:] Your not an administrator!");
		}
		return 1;
	}
 	if(strcmp(cmd, "/ajobcmds", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 20)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[GUN JOB:] /agunjobpos (/takejob) - /agunjobpos2 (/materials buy) - /agunjobpos3 (/materials dropoff) ");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[DRUG JOB:] /adrugjobpos (/takejob) - /adrugjobpos2 (/drugs buy) - /agunjobpos3 (/drugs dropoff) ");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[DETECTIVE JOB:] /adetectivejobpos (/takejob) ");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[LAWYER JOB:] /alawyerjobpos (/takejob");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[PRODUCTS SELLER JOB:] /aproductjobpos (/takejob) - /aproductjobpos2 (/products buy)");
		}
		else
		{
			SendClientMessage(playerid,COLOR_RED,"[ERROR:] Your not an administrator!");
		}
		return 1;
	}
 	if(strcmp(cmd, "/housecmds", true) == 0)
	{
		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[House:] /enter - /exit - /buyhouse - /sellhouse - /editrenting - /rentfee - /renthouse - /openhouse - /housewithdraw - /housedeposit");
		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[House:] /housematsput - /housematstake - /housedrugsput - /housedrugstake");
		return 1;
	}
	if(strcmp(cmd, "/factioncmds", true) == 0)
	{
	    if(PlayerInfo[playerid][pFaction] != 255)
	    {
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Faction:] /f(action) - /fcheckmats - /fcheckdrugs - /factionmatsput - /factionmatstake - /factiondrugsput - /factiondrugstake");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Faction:] /fwithdraw - /fdeposit - /fbalance");
		}
		else
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Invalid Faction.");
		}
		return 1;
	}
 	if(strcmp(cmd, "/leadercmds", true) == 0)
	{
	    if(PlayerInfo[playerid][pFaction] != 255 && PlayerInfo[playerid][pRank] == 1)
	    {
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Leader:] /invite - /uninvite - /setrank");
		}
		else
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Your not a leader!");
		}
		return 1;
	}
	if(strcmp(cmd, "/phonecmds", true) == 0)
	{
		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Phone:] /buyphone - /call - /answer - /hangup - /speakerphone - /txt - /phonebook");
		return 1;
	}
	if(strcmp(cmd, "/businesscmds", true) == 0)
	{
		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Business:] /buybusiness - /sellbusiness - /businessinfo - /businessfee - /businessname - /openbusiness");
		SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Business:] /businessdeposit - /businesswithdraw");
		return 1;
	}
	if(strcmp(cmd, "/acarcmds", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 5:] - /acarpark - /acarmodel - /acarcolor - /acarfaction - /acarenter - /acartype - /acarsetpos");
		}
		else
		{
			SendClientMessage(playerid,COLOR_RED,"[ERROR:] Your not an administrator!");
		}
		return 1;
	}
 	if(strcmp(cmd, "/ahousecmds", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 7:] - /ahouseentrance - /ahouseexit - /ahousedescription - /agotohouse - /ahouseprice - /ahousesell - /ahouseint");
		}
		else
		{
			SendClientMessage(playerid,COLOR_RED,"[ERROR:] Your not an administrator!");
		}
		return 1;
	}
	if(strcmp(cmd, "/apositioncmds", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 1:] - [TELEPORTS] /agotobuilding - /agotohouse - /agotobusiness - /agotofmatsstorage - /agotofdrugsstorage");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 1:] - [TELEPORTS] /agotodrivingtestpos - /agotoflyingtestpos - /agotobank - /agotoweaponlicpos - /agotopolicearrestpos");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 1:] - [TELEPORTS] /agotopolicedutypos");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 10:] - adrivingtestpos - /aflyingtestpos - /abankpos - /aweaponlicensepos - /apolicearrestpos - /apolicedutypos");
		}
		else
		{
			SendClientMessage(playerid,COLOR_RED,"[ERROR:] Your not an administrator!");
		}
		return 1;
	}
 	if(strcmp(cmd, "/gooc", true) == 0 || strcmp(cmd, "/go", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if ((OOCStatus) == 0 && PlayerInfo[playerid][pAdmin] < 1)
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Global OOC is currently disabled.");
				return 1;
			}
			if(Muted[playerid])
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You can't speak, your muted!");
				return 1;
			}
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] [/go]oc [message]");
				return 1;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && AdminDuty[playerid] == 1)
			{
				format(string, sizeof(string), "(( [G-OOC:] Admin %s: %s ))", GetPlayerNameEx(playerid), result);
				SendClientMessageToAll(COLOR_ADMINDUTY,string);
				OOCLog(string);
				return 1;
			}
			else if(PlayerInfo[playerid][pDonator] == 1)
			{
				format(string, sizeof(string), "(( [G-OOC:] Donator %s: %s ))", GetPlayerNameEx(playerid), result);
				SendClientMessageToAll(COLOR_NEWOOC,string);
				OOCLog(string);
			}
			else
			{
				format(string, sizeof(string), "(( [G-OOC:] %s: %s ))", GetPlayerNameEx(playerid), result);
				SendClientMessageToAll(COLOR_NEWOOC,string);
				OOCLog(string);
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/eject", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	   	{
	        new State;
	        if(IsPlayerInAnyVehicle(playerid))
	        {
         		State=GetPlayerState(playerid);
		        if(State!=PLAYER_STATE_DRIVER)
		        {
		        	SendClientMessage(playerid,COLOR_GREY,"[ERROR:] You can only eject a user as the driver!");
		            return 1;
		        }
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /eject [playerid/PartOfName]");
					return 1;
				}
				new playa;
				playa = ReturnUser(tmp);
				new test;
				test = GetPlayerVehicleID(playerid);
				if(IsPlayerConnected(playa))
				{
				    if(playa != INVALID_PLAYER_ID)
				    {
				        if(playa == playerid) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You can't eject yourself!"); return 1; }
				        if(IsPlayerInVehicle(playa,test))
				        {
							format(string, sizeof(string), "[INFO:] You have thrown out: %s.", GetPlayerNameEx(playa));
							SendClientMessage(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "[INFO:] You have been thrown out of the car by: %s.", GetPlayerNameEx(playerid));
							SendClientMessage(playa, COLOR_WHITE, string);
							RemovePlayerFromVehicle(playa);
						}
						else
						{
						    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] That user is not even in your car!");
						    return 1;
						}
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Invalid ID.");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You are not in a vehicle!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/adminduty", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			new faction = PlayerInfo[playerid][pFaction];
		    if(AdminDuty[playerid] == 1)
		    {
			    format(string, sizeof(string), "[ADMIN:] %s (ID:%d) is now off duty.", GetPlayerNameEx(playerid),playerid);
				SendClientMessageToAll(COLOR_ADMINDUTY,string);
				AdminDuty[playerid] = 0;
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,0);

			    if(PlayerInfo[playerid][pFaction] != 255)
			    {
		    		if(DynamicFactions[faction][fUseColor])
		    		{
		    			SetPlayerToFactionColor(playerid);//Setting the players color.
		    		}
        			else
			     	{
			     	    SetPlayerColor(playerid,COLOR_CIVILIAN);
			     	}
		     	}
		     	else
		     	{
		     	    SetPlayerColor(playerid,COLOR_CIVILIAN);
		     	}
		    }
		    else
		    {
		    	format(string, sizeof(string), "[ADMIN:] %s (ID:%d) is now an on duty administrator.", GetPlayerNameEx(playerid),playerid);
				SendClientMessageToAll(COLOR_ADMINDUTY,string);
				AdminDuty[playerid] = 1;
				SetPlayerColor(playerid,COLOR_ADMINDUTY);
				SetPlayerHealth(playerid,99999);
				SetPlayerArmour(playerid,99999);
		    }
		}
		else
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] Your not an administrator.");
		}
		return 1;
	}
 	if (strcmp(cmd, "/check", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /check [playerid]");
					return 1;
				}
	            giveplayerid = ReturnUser(tmp);
				if(IsPlayerConnected(giveplayerid))
				{
				    if(giveplayerid != INVALID_PLAYER_ID)
				    {
						ShowStats(playerid,giveplayerid);
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Invalid ID.");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/donate", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /donate [amount]");
				return 1;
			}
			new moneys;
			moneys = strval(tmp);
			if(moneys < 0)
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Invalid Amount.");
				return 1;
			}
			if(GetPlayerCash(playerid) < moneys)
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] You don't have that much!");
				return 1;
			}
			GivePlayerCash(playerid, -moneys);
			format(string, sizeof(string), "[INFO:] %s has donated $%d.",GetPlayerNameEx(playerid), moneys);
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
			PayLog(string);
		}
		return 1;
	}
 	if(strcmp(cmd, "/up", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz+2);
				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/mute", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /mute [playerid]");
				return 1;
			}
			new playa;
			playa = ReturnUser(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						if(Muted[playerid] == 0)
						{
							Muted[playerid] = 1;
							format(string, sizeof(string), "[INFO:] You muted %s.",GetPlayerNameEx(playa));
							SendClientMessage(playerid,COLOR_ADMINCMD,string);
							format(string, sizeof(string), "[INFO:] You have been muted by %s.",GetPlayerNameEx(playerid));
							SendClientMessage(playa,COLOR_ADMINCMD,string);
						}
						else
						{
							Muted[playerid] = 0;
							format(string, sizeof(string), "[INFO:] You unmuted %s.",GetPlayerNameEx(playa));
							SendClientMessage(playerid,COLOR_ADMINCMD,string);
							format(string, sizeof(string), "[INFO:] You have been unmuted by %s.",GetPlayerNameEx(playerid));
							SendClientMessage(playa,COLOR_ADMINCMD,string);
						}
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/warn", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /warn [playerid] [reason]");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(IsPlayerConnected(giveplayerid))
			    {
			        if(giveplayerid != INVALID_PLAYER_ID)
			        {
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[128];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result))
						{
							SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /warn [playerid] [reason]");
							return 1;
						}
						PlayerInfo[giveplayerid][pWarnings] += 1;
						if(PlayerInfo[giveplayerid][pWarnings] >= 5)
						{
							format(string, sizeof(string), "[BAN:] %s has just been banned, had 5+ warnings.", GetPlayerNameEx(giveplayerid));
							BanLog(string);
							BanPlayerAccount(giveplayerid,GetPlayerNameEx(playerid),(result));
							return 1;
						}
						format(string, sizeof(string), "[INFO:] You warned %s, reason: %s.", GetPlayerNameEx(giveplayerid), (result));
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
						format(string, sizeof(string), "[INFO:] You where warned by %s, reason: %s.", GetPlayerNameEx(playerid), (result));
						SendClientMessage(giveplayerid, COLOR_LIGHTYELLOW2, string);
						return 1;
					}
				}//not connected
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Invalid ID.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/goto", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /goto [playerid]");
				return 1;
			}
			new Float:plocx,Float:plocy,Float:plocz;
			new plo;
			plo = ReturnUser(tmp);
			if (IsPlayerConnected(plo))
			{
			    if(plo != INVALID_PLAYER_ID)
			    {
					if (PlayerInfo[playerid][pAdmin] >= 1)
					{
						GetPlayerPos(plo, plocx, plocy, plocz);
						new interior = GetPlayerInterior(plo);
						new world = GetPlayerVirtualWorld(plo);

						if (GetPlayerState(playerid) == 2)
						{
							new tmpcar = GetPlayerVehicleID(playerid);
							SetVehiclePos(tmpcar, plocx, plocy+4, plocz);
							SetPlayerVirtualWorld(playerid,world);
							SetPlayerInterior(playerid,interior);
						}
						else
						{
							SetPlayerPos(playerid,plocx,plocy+2, plocz);
							SetPlayerVirtualWorld(playerid,world);
							SetPlayerInterior(playerid,interior);
						}
						format(string, sizeof(string), "[INFO:] You teleported to %s.", GetPlayerNameEx(plo));
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD1, "[ERROR:] Invalid ID.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/gotols", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 1529.6,-1691.2,13.3);
				}
				else
				{
					SetPlayerPos(playerid, 1529.6,-1691.2,13.3);
				}
				SetPlayerInterior(playerid,0);
				SetPlayerVirtualWorld(playerid,0);
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD1, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/gotolv", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 1699.2, 1435.1, 10.7);
				}
				else
				{
					SetPlayerPos(playerid, 1699.2,1435.1, 10.7);
				}
				SetPlayerInterior(playerid,0);
				SetPlayerVirtualWorld(playerid,0);
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD1, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/gotosf", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, -1417.0,-295.8,14.1);
				}
				else
				{
					SetPlayerPos(playerid, -1417.0,-295.8,14.1);
				}
				SetPlayerInterior(playerid,0);
				SetPlayerVirtualWorld(playerid,0);
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD1, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
  	if(strcmp(cmd, "/gethere", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /gethere [playerid]");
				return 1;
			}
			new Float:plocx,Float:plocy,Float:plocz;
			new plo;
			plo = ReturnUser(tmp);
			if (IsPlayerConnected(plo))
			{
			    if(plo != INVALID_PLAYER_ID)
			    {
					if (PlayerInfo[playerid][pAdmin] >= 1)
					{
						GetPlayerPos(playerid, plocx, plocy, plocz);
						new interior = GetPlayerInterior(playerid);
						new world = GetPlayerVirtualWorld(playerid);

						if (GetPlayerState(playerid) == 2)
						{
							new tmpcar = GetPlayerVehicleID(plo);
							SetVehiclePos(tmpcar, plocx, plocy+4, plocz);
							SetPlayerVirtualWorld(plo,world);
							SetPlayerInterior(plo,interior);
						}
						else
						{
							SetPlayerPos(plo,plocx,plocy+2, plocz);
							SetPlayerVirtualWorld(plo,world);
							SetPlayerInterior(plo,interior);
						}
						format(string, sizeof(string), "[INFO:] You teleported %s to you.", GetPlayerNameEx(plo));
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
					}
				}
			}
			else
			{
				format(string, sizeof(string), "   %d is not an active player.", plo);
				SendClientMessage(playerid, COLOR_GRAD1, string);
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/freeze", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /freeze [playerid]");
				return 1;
			}
			new playa;
			playa = ReturnUser(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						TogglePlayerControllable(playa, 0);
						format(string, sizeof(string), "[INFO:] You where froze by %s.",GetPlayerNameEx(playerid));
						SendClientMessage(playa,COLOR_LIGHTYELLOW2,string);
						format(string, sizeof(string), "[INFO:] You froze %s.",GetPlayerNameEx(playa));
						SendClientMessage(playerid,COLOR_LIGHTYELLOW2,string);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}

	if(strcmp(cmd, "/unfreeze", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /unfreeze [playerid]");
				return 1;
			}
			new playa;
			playa = ReturnUser(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						TogglePlayerControllable(playa, 1);
						format(string, sizeof(string), "[INFO:] You where unfroze by %s.",GetPlayerNameEx(playerid));
						SendClientMessage(playa,COLOR_LIGHTYELLOW2,string);
						format(string, sizeof(string), "[INFO:] You unfroze %s.",GetPlayerNameEx(playa));
						SendClientMessage(playerid,COLOR_LIGHTYELLOW2,string);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/gametext", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (PlayerInfo[playerid][pAdmin] >= 1)
			{
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[64];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /gametext [textformat ~n~=Newline ~r~=Red ~g~=Green ~b~=Blue ~w~=White ~y~=Yellow]");
					return 1;
				}
				format(string, sizeof(string), "~b~%s: ~w~%s",GetPlayerNameEx(playerid),result);
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						GameTextForPlayer(i, string, 5000, 6);
					}
				}
				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator!");
				return 1;
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/ajail", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /ajail [playerid] [minutes]");
				return 1;
			}
			new playa;
			new money;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			money = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 2)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						format(string, sizeof(string), "[INFO:] You jailed %s.", GetPlayerNameEx(playa));
						SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
						format(string, sizeof(string), "[INFO:] You where jailed by %s for %d minutes.", GetPlayerNameEx(playerid),money);
						SendClientMessage(playa, COLOR_LIGHTYELLOW2, string);
						ResetPlayerWeapons(playa);
						WantedPoints[playa] = 0;
						PlayerInfo[playa][pJailed] = 1;
						PlayerInfo[playa][pJailTime] = money*60;
						SetPlayerInterior(playa, 6);
						SetPlayerPos(playa, 264.6288,77.5742,1001.0391);
						SetPlayerVirtualWorld(playerid,2);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
 	if (strcmp(cmd, "/logoutall", true) ==0 )
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (PlayerInfo[playerid][pAdmin] >= 10)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						OnPlayerDataSave(i);
						gPlayerLogged[i] = 0;
					}
				}
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[SUCCESS:] All players logged out.");
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/unknowngametext", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			if (PlayerInfo[playerid][pAdmin] >= 10)
			{
				tmp = strtok(cmdtext, idx);
				new txtid;
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /unknowngametext ");
					return 1;
				}
				txtid = strval(tmp);
				if(txtid == 2)
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:]");
					return 1;
				}
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[128];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /unknowngametext <type> [cnnc textformat ~n~=Newline ~r~=Red ~g~=Green ~b~=Blue ~w~=White ~y~=Yellow]");
					return 1;
				}
				format(string, sizeof(string), "~w~%s",result);
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i) == 1)
					{
						GameTextForPlayer(i, string, 5000, txtid);
					}
				}
				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator!");
				return 1;
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/fixveh", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerInfo[playerid][pAdmin] >= 1)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
				    SetVehicleHealth(GetPlayerVehicleID(playerid), 1000.0);
				}
   				return 1;
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/money", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /money [playerid] [money]");
				return 1;
			}
			new playa;
			new money;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			money = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 5)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						SetPlayerCash(playa, money);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/agiveproducts", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /agiveproducts [playerid] [products]");
				return 1;
			}
			new playa;
			new money;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			money = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 4)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						PlayerInfo[playerid][pProducts] += money;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/asetproducts", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /asetproducts [playerid] [products]");
				return 1;
			}
			new playa;
			new money;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			money = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 4)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						PlayerInfo[playerid][pProducts] = money;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/agivemats", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /agivemats [playerid] [mats]");
				return 1;
			}
			new playa;
			new money;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			money = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 4)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						PlayerInfo[playerid][pMaterials] += money;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/asetmats", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /asetmats [playerid] [mats]");
				return 1;
			}
			new playa;
			new money;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			money = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 4)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						PlayerInfo[playerid][pMaterials] = money;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/asetdrugs", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /asetdrugs [playerid] [drugs]");
				return 1;
			}
			new playa;
			new money;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			money = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 4)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						PlayerInfo[playerid][pDrugs] = money;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/agivedrugs", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /agivedrugs [playerid] [drugs]");
				return 1;
			}
			new playa;
			new money;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			money = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 4)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						PlayerInfo[playerid][pDrugs] += money;
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/givemoney", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /givemoney [playerid] [money]");
				return 1;
			}
			new playa;
			new money;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			money = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 5)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						GivePlayerCash(playa, money);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/weatherall", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerInfo[playerid][pAdmin] < 20)
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			    return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
			    SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /weatherall [weatherid]");
			    return 1;
			}
			new weather;
			weather = strval(tmp);
			if(weather < 0||weather > 45) { SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] 0-45."); return 1; }
			SetWeather(weather);
		}
		return 1;
	}
 	if(strcmp(cmd, "/sethp", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /sethp [playerid] [health]");
				return 1;
			}
			new playa;
			new health;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			health = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 4)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						SetPlayerHealth(playa, health);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/setarmour", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /setarmour [playerid] [armour]");
				return 1;
			}
			new playa;
			new health;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			health = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 4)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						SetPlayerArmour(playa, health);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/givegun", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /givegun [playerid/PartOfName] [weaponid] [ammo]");
				return 1;
			}
			new playa;
			new gun;
			new ammo;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			gun = strval(tmp);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "USAGE: /givegun [playerid/PartOfName] [weaponid] [ammo]");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "3(Club) 4(knife) 5(bat) 6(Shovel) 7(Cue) 8(Katana) 10-13(Dildo) 14(Flowers) 16(Grenades) 18(Molotovs) 22(Pistol) 23(SPistol)");
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "24(Eagle) 25(shotgun) 29(MP5) 30(AK47) 31(M4) 33(Rifle) 34(Sniper) 37(Flamethrower) 41(spray) 42(exting) 43(Camera) 46(Parachute)");
				return 1;
			}
			if(gun > 1||gun < 47)
			{
			tmp = strtok(cmdtext, idx);
			ammo = strval(tmp);
			if(ammo <1||ammo > 999)
			{ SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Ammo must be , 1-999."); return 1; }
			if (PlayerInfo[playerid][pAdmin] >= 5)
			{
			    if(IsPlayerConnected(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						GivePlayerWeapon(playa, gun, ammo);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
			}
		}
		}
		return 1;
	}
	if(strcmp(cmd, "/fuelcars", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerInfo[playerid][pAdmin] >= 4)
	        {
	            for(new c=0;c<MAX_VEHICLES;c++)
				{
					Fuel[c] = GasMax;
				}
				SendClientMessageToAll(COLOR_ADMINCMD, "[INFO:] All cars refueled by an administrator.");
	        }
	        else
	        {
	            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
	            return 1;
	        }
	    }
	    return 1;
	}
 	if(strcmp(cmd, "/unlockcars", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerInfo[playerid][pAdmin] >= 7)
	        {
	            for(new c=0;c<MAX_VEHICLES;c++)
				{
					VehicleLocked[c] = 0;
				}
				for(new i=0;i<MAX_PLAYERS;i++)
				{
				    if(IsPlayerConnected(i))
				    {
						VehicleLockedPlayer[i] = 999;
					}
				}
				SendClientMessageToAll(COLOR_ADMINCMD, "[INFO:] All cars unlocked by an administrator.");
	        }
	        else
	        {
	            SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator.");
	            return 1;
	        }
	    }
	    return 1;
	}
 	if(strcmp(cmd, "/setadmin", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /setadmin [playerid] [adminlevel]");
				return 1;
			}
			new para1;
			new level;
			para1 = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			level = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 20)
			{
			    if(IsPlayerConnected(para1))
			    {
			        if(para1 != INVALID_PLAYER_ID)
			        {
						PlayerInfo[para1][pAdmin] = level;
						format(string, sizeof(string), "[INFO:] %s has just made you administrator level: %d.", GetPlayerNameEx(playerid),level);
						SendClientMessage(para1, COLOR_WHITE, string);
						format(string, sizeof(string), "[INFO:] You have made %s an administrator - Level: %d.", GetPlayerNameEx(para1),level);
						SendClientMessage(playerid, COLOR_WHITE, string);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD1, "[ERROR:] Your not an administrator/correct level.");
			}
		}
		return 1;
	}
 	if(strcmp(cmd, "/tod", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[USAGE:] /tod [timeofday] (0-23)");
				return 1;
			}
			new hour;
			hour = strval(tmp);
			if (PlayerInfo[playerid][pAdmin] >= 20)
			{
	            SetWorldTime(hour);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Your not an administrator/correct level.");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/acommands", true) == 0 || strcmp(cmd, "/acmds", true) == 0)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 1:] - (/a)dmin - /goto - /gethere - /warn - /mute - /check - /adminduty - /kick - /asuicide - /aserverinfo - /apositioncmds - /up");
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 1:] - /freeze - /unfreeze - /gametext - /gotolv - /gotosf - /gotols - /fixveh");
		}
		if (PlayerInfo[playerid][pAdmin] >= 2)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 2:] /ban - /banaccount - /oocstatus - /listenchat - /ajail");
		}
		if (PlayerInfo[playerid][pAdmin] >= 3)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 3:] /alistfaction");
		}
		if (PlayerInfo[playerid][pAdmin] >= 4)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 4:] /sethp - /setarmour - /fuelcars - /agivedrugs - /asetdrugs - /agivemats - /asetmats - /agiveproducts - /asetproducts");
		}
		if (PlayerInfo[playerid][pAdmin] >= 5)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 5:] /adonator - /acarcmds - /money - /givemoney - /givegun - /respawnvehicles");
		}
		if (PlayerInfo[playerid][pAdmin] >= 6)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 6:] ");
		}
		if (PlayerInfo[playerid][pAdmin] >= 7)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 7:] - /ahousecmds - /abusinesscmds - /unlockcars");
		}
		if (PlayerInfo[playerid][pAdmin] >= 8)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 8:] ");
		}
		if (PlayerInfo[playerid][pAdmin] >= 9)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 9:] ");
		}
		if (PlayerInfo[playerid][pAdmin] >= 10)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Level 10:] - /logoutall - /unknowngametext - /abuildingcmds - /afactioncmds - /apositioncmds");
		}
		if (PlayerInfo[playerid][pAdmin] >= 20)
		{
			SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[Owner:] - /gmx - /setadmin - /asetleader - /aresetfaction - /acivilianspawn - /ajobcmds - /weatherall - /tod");
		}
		return 1;
	}
//==========================================[NORMAL COMMANDS]=========================================================
	if(strcmp(cmd, "/enter", true) == 0)
	{
		for(new i = 0; i < sizeof(Houses); i++)
		{
				if (PlayerToPoint(1.0, playerid,Houses[i][EnterX], Houses[i][EnterY], Houses[i][EnterZ]))
				{
				if(GetPlayerVirtualWorld(playerid) == Houses[i][EnterWorld])
			    {
					if(PlayerInfo[playerid][pHouseKey] == i || Houses[i][Locked] == 0 || PlayerInfo[playerid][pAdmin] >= 1)
					{
						SetPlayerInterior(playerid,Houses[i][ExitInterior]);
						SetPlayerPos(playerid,Houses[i][ExitX],Houses[i][ExitY],Houses[i][ExitZ]);
						SetPlayerVirtualWorld(playerid,i);
						SetPlayerFacingAngle(playerid,Houses[i][ExitAngle]);
					}
 					else
					{
						GameTextForPlayer(playerid, "~r~Locked", 5000, 1);
					}
				}
			}
		}
		for(new i = 0; i < sizeof(Building); i++)
		{
			if (PlayerToPoint(1.0, playerid,Building[i][EnterX], Building[i][EnterY], Building[i][EnterZ]))
			{
			    if(GetPlayerVirtualWorld(playerid) == Building[i][EnterWorld])
			    {
					if(Building[i][Locked] == 0 || PlayerInfo[playerid][pAdmin] >=  1)
					{
					    if(GetPlayerCash(playerid) >= Building[i][EntranceFee])
					    {
							SetPlayerInterior(playerid,Building[i][ExitInterior]);
							SetPlayerVirtualWorld(playerid,i);
							SetPlayerPos(playerid,Building[i][ExitX],Building[i][ExitY],Building[i][ExitZ]);
							SetPlayerFacingAngle(playerid,Building[i][ExitAngle]);
							GivePlayerCash(playerid,-Building[i][EntranceFee]);
						}
						else
						{
							GameTextForPlayer(playerid, "~r~You don't have enough money!", 5000, 1);
						}
					}
					else
					{
					GameTextForPlayer(playerid, "~r~Locked", 5000, 1);
					}
				}
			}
		}
		for(new i = 0; i < sizeof(Businesses); i++)
			{
				if (PlayerToPoint(1.0, playerid,Businesses[i][EnterX], Businesses[i][EnterY], Businesses[i][EnterZ]))
				{
				 	if(GetPlayerVirtualWorld(playerid) == Businesses[i][EnterWorld])
				    {
						if(PlayerInfo[playerid][pBizKey] == i || GetPlayerCash(playerid) >= Businesses[i][EntranceCost])
						{
							if(PlayerInfo[playerid][pBizKey] != i)
							{
								if(Businesses[i][Locked] == 1 && PlayerInfo[playerid][pAdmin] == 0)
								{
									GameTextForPlayer(playerid, "~r~Business Locked.", 5000, 1);
									return 1;
								}
								if(Businesses[i][Products] == 0)
								{
									GameTextForPlayer(playerid, "~r~No Products.", 5000, 1);
									return 1;
								}
								GivePlayerCash(playerid,-Businesses[i][EntranceCost]);
								format(string, sizeof(string), "[INFO:] You where charged $%d to enter %s.", Businesses[i][EntranceCost],Businesses[i][BusinessName]);
								SendClientMessage(playerid,COLOR_LIGHTYELLOW2,string);
								Businesses[i][Till] += Businesses[i][EntranceCost];
								Businesses[i][Products]--;
								SetPlayerInterior(playerid,Businesses[i][ExitInterior]);
								SetPlayerPos(playerid,Businesses[i][ExitX],Businesses[i][ExitY],Businesses[i][ExitZ]);
								SetPlayerVirtualWorld(playerid,i);
								SetPlayerFacingAngle(playerid,Businesses[i][ExitAngle]);
								SaveBusinesses();
							}
							else
							{
								SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] Free entrance for the boss.");
								SetPlayerInterior(playerid,Businesses[i][ExitInterior]);
								SetPlayerPos(playerid,Businesses[i][ExitX],Businesses[i][ExitY],Businesses[i][ExitZ]);
								SetPlayerVirtualWorld(playerid,i);
								SetPlayerFacingAngle(playerid,Businesses[i][ExitAngle]);
							}
						}
						else
						{
							SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR:] You don't have that much money!");
						}
					}
				}
			}
		return 1;
	}
	if(strcmp(cmd, "/exit", true) == 0)
	{
 		for(new i = 0; i < sizeof(Houses); i++)
		{
			if (PlayerToPoint(3.0, playerid,Houses[i][ExitX], Houses[i][ExitY], Houses[i][ExitZ]))
			{
   				if(GetPlayerVirtualWorld(playerid) == i)
			    {
			        if(Houses[i][Locked] == 0 || PlayerInfo[playerid][pAdmin] >=  1)
					{
						SetPlayerInterior(playerid,Houses[i][EnterInterior]);
						SetPlayerPos(playerid,Houses[i][EnterX],Houses[i][EnterY],Houses[i][EnterZ]);
						SetPlayerVirtualWorld(playerid,Houses[i][EnterWorld]);
						SetPlayerFacingAngle(playerid,Houses[i][EnterAngle]);
					}
					else
					{
						GameTextForPlayer(playerid, "~r~Door Locked.", 5000, 1);
					}
				}
			}
		}
		for(new i = 0; i < sizeof(Building); i++)
		{
			if (PlayerToPoint(3, playerid,Building[i][ExitX], Building[i][ExitY], Building[i][ExitZ]))
			{
			    if(GetPlayerVirtualWorld(playerid) == i)
			    {
					if(Building[i][Locked] == 0 || PlayerInfo[playerid][pAdmin] >=  1)
					{
						SetPlayerInterior(playerid,Building[i][EnterInterior]);
						SetPlayerVirtualWorld(playerid,Building[i][EnterWorld]);
						SetPlayerPos(playerid,Building[i][EnterX],Building[i][EnterY],Building[i][EnterZ]);
						SetPlayerFacingAngle(playerid,Building[i][EnterAngle]);
					}
					else
					{
						GameTextForPlayer(playerid, "~r~Door Locked.", 5000, 1);
					}
				}
			}
		}
  		for(new i = 0; i < sizeof(Businesses); i++)
		{
			if (PlayerToPoint(3, playerid,Businesses[i][ExitX], Businesses[i][ExitY], Businesses[i][ExitZ]))
			{
			    if(GetPlayerVirtualWorld(playerid) == i)
			    {
					if(Businesses[i][Locked] == 0 || PlayerInfo[playerid][pAdmin] >=  1)
					{
						SetPlayerInterior(playerid,Businesses[i][EnterInterior]);
						SetPlayerVirtualWorld(playerid,Businesses[i][EnterWorld]);
						SetPlayerPos(playerid,Businesses[i][EnterX],Businesses[i][EnterY],Businesses[i][EnterZ]);
						SetPlayerFacingAngle(playerid,Businesses[i][EnterAngle]);
					}
					else
					{
						GameTextForPlayer(playerid, "~r~Door Locked.", 5000, 1);
					}
				}
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/time", true) == 0)
		{
		    if(IsPlayerConnected(playerid))
			{
			    new mtext[20];
				new year, month,day;
				getdate(year, month, day);
				if(month == 1) { mtext = "January"; }
				else if(month == 2) { mtext = "February"; }
				else if(month == 3) { mtext = "March"; }
				else if(month == 4) { mtext = "April"; }
				else if(month == 5) { mtext = "May"; }
				else if(month == 6) { mtext = "June"; }
				else if(month == 7) { mtext = "July"; }
				else if(month == 8) { mtext = "August"; }
				else if(month == 9) { mtext = "September"; }
				else if(month == 10) { mtext = "October"; }
				else if(month == 11) { mtext = "November"; }
				else if(month == 12) { mtext = "December"; }
			    new hour,minuite,second;
				gettime(hour,minuite,second);
				FixHour(hour);
				hour = shifthour;

				format(string, sizeof(string), "~y~%d %s~n~~g~|~w~%d:%d:%d~g~|", day, mtext, hour, minuite,second);
				GameTextForPlayer(playerid, string, 5000, 1);
			}
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED,"[INFO:] Nie jesteœ zalogowany, nie mo¿esz u¿yæ komend.");
		return 1;
	}
	SendClientMessage(playerid,COLOR_LIGHTBLUE,"[INFO:] Nieprawid³owa komenda, wpisz /komendy.");
	return 1;
}

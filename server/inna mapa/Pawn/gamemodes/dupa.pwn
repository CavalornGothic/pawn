/*
		*
		*   PolskiSerwerRPG
		*       by Thorus
		
do zrobienia v1

- rejestracja ok
- logowanie - ok
- zapis danych gracza ok
- payday
- system exp i lvl
- system pojazdow
- system organizacji
- pogody, pór dnia
- komendy gracza i adminsitratora
- czat lokalny i globalny
- prace
- licencje
*/

#include <a_samp>
#include <fcmd>

#define CZAT1 0xE6E6E6E6
#define CZAT2 0xC8C8C8C8
#define CZAT3 0xAAAAAAAA
#define CZAT4 0x8C8C8C8C
#define CZAT5 0x6E6E6E6E
#define zolty 0xF5FF7CAA
#define zielony 0x71D642AA
#define niebieski 0x3AC8F5AA

#define logowanie 2312
#define rejestracja 2112
#define zmienh 662

forward OnPlayerRegister(playerid, password[]);
forward OnPlayerLogin(playerid, password[]);
forward zhash(playerid, npassword[]);
forward thorus_savePlayer(playerid);
forward thorus_resetStats(playerid);

new DB:dbh;
new DBResult:dbr;

new sq[64];
new mq[128];
new bq[256];

enum g
{
	id,
	haslo[24],
	kasa,
	exp,
	wexp,
	level,
	ranga,
	rangaf,
	skin,
	praca,
	materialy,
	dragi,
	prawko,
	pilotaz,
	motor,
	lickabron,
	zalogowany,
	fid,
}

new p[MAX_PLAYERS][g];

main()
{
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	SendRconCommand("mapname FortCarson[PL]");
	SendRconCommand("gamemodetext PS-RPG[Pl]");
	if((dbh = db_open("psrpg.db")) == DB:0)
	{
	    print("[SQL]Brak polaczenia");
	}
	else
	{
		print("[SQL]Polaczono");
	}
	return 1;
}

public OnGameModeExit()
{
    if(dbh) db_close(dbh);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	format(sq, sizeof sq, "SELECT `id` FROM `players` WHERE `login`='%s'", PlayerName(playerid));
	dbr = db_query(dbh, sq);
	if(db_num_rows(dbr))
	{
	    ShowPlayerDialog(playerid, logowanie, DIALOG_STYLE_PASSWORD, "Logowanie", "Witaj!\nPodaj has³o do konta:", "Zaloguj", "Anuluj");
	}
	else
	{
	    ShowPlayerDialog(playerid, rejestracja, DIALOG_STYLE_PASSWORD, "Rejestracja", "Jesteœ nowym graczem?\nRejestruj¹c siê na serwerze akceptujesz nasz regulamin dostêpny na naszej stronei internetowej.\nPodaj has³o:", "Zarejestruj", "Anuluj");
	}
	db_free_result(dbr);
	SetPlayerCameraPos(playerid, 77.9485, 1010.7545, 145.9319);
	SetPlayerCameraLookAt(playerid, 77.2622, 1011.4880, 144.8123);
	return 1;
}

public OnPlayerConnect(playerid)
{
	p[playerid][zalogowany] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    thorus_savePlayer(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    new a[128];
	format(a, sizeof(a), "[%d][%s:] %s", playerid, PlayerName(playerid), text);
	SendClientLocalMessage(20.0, playerid, a, CZAT1, CZAT2, CZAT3, CZAT4, CZAT5);
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case rejestracja:
	    {
	        switch(response)
	        {
	            case 0: return Kick(playerid);
	            case 1: return OnPlayerRegister(playerid, inputtext);
			}
		}
		case logowanie:
		{
		    switch(response)
		    {
		        case 0: return Kick(playerid);
		        case 1: OnPlayerLogin(playerid, inputtext);
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerLogin(playerid, password[])
{
	format(sq, sizeof sq, "SELECT `haslo` FROM `players` WHERE `login`='%s'", PlayerName(playerid));
	dbr = db_query(dbh, sq);
	db_get_field_assoc(dbr, "haslo", p[playerid][haslo], 24);
	db_free_result(dbr);
	if(!strcmp(password, p[playerid][haslo], true))
	{
	    format(sq, sizeof sq, "SELECT * FROM `players` WHERE `login`='%s'", PlayerName(playerid));
	    dbr = db_query(dbh, sq);
	    db_get_field_assoc(dbr, "id", p[playerid][id], 9);
    	db_get_field_assoc(dbr, "kasa", p[playerid][kasa], 9);
    	db_get_field_assoc(dbr, "exp", p[playerid][exp], 9);
    	db_get_field_assoc(dbr, "wexp", p[playerid][wexp], 9);
    	db_get_field_assoc(dbr, "level", p[playerid][level], 9);
    	db_get_field_assoc(dbr, "ranga", p[playerid][ranga], 1);
    	db_get_field_assoc(dbr, "rangaf", p[playerid][rangaf], 4);
    	db_get_field_assoc(dbr, "skin", p[playerid][skin], 3);
    	db_get_field_assoc(dbr, "praca", p[playerid][praca], 1);
    	db_get_field_assoc(dbr, "materialy", p[playerid][materialy], 9);
    	db_get_field_assoc(dbr, "dragi", p[playerid][dragi], 9);
    	db_get_field_assoc(dbr, "prawko", p[playerid][prawko], 1);
    	db_get_field_assoc(dbr, "pilotaz", p[playerid][pilotaz], 1);
    	db_get_field_assoc(dbr, "motor", p[playerid][motor], 1);
    	db_get_field_assoc(dbr, "lickabron", p[playerid][prawko], 1);
    	db_get_field_assoc(dbr, "fid", p[playerid][prawko], 4);
	    db_free_result(dbr);
	    p[playerid][zalogowany] = 1;
	    GiveCash(playerid, p[playerid][kasa]);
	    SetPlayerScore(playerid, p[playerid][level]);
	    SendClientMessage(playerid, zielony, "[Serwer:] Zalogowano pomyœlnie!");
	    SendClientMessage(playerid, zielony, "[Serwer:] WejdŸ na nasze forum www.ps-rpg.cba.pl - adres forum tymczasowy");
	    SendClientMessage(playerid, zielony, "[Serwer:] /komendy - lista komend na serwerze");
	    return 1;
	}
	else
	{
	    ShowPlayerDialog(playerid, logowanie, DIALOG_STYLE_PASSWORD, "Logowanie", "Wyst¹pi³ b³¹d!\nPoda³eœ z³e has³o!\nWpisz has³o jeszcze raz:", "Zaloguj", "Anuluj");
	}
	return 1;
}

public OnPlayerRegister(playerid, password[])
{
	if(strlen(password) < 3 || strlen(password) > 24)
	    return ShowPlayerDialog(playerid, rejestracja, DIALOG_STYLE_PASSWORD, "Rejestracja", "Wyst¹pi³ b³¹d!\nHas³o musi siê sk³adaæ minimum z 3 znaków, maksimum 24.\nPodaj jeszcze raz has³o:", "Zarejestruj", "Anuluj");
	    
	format(mq, sizeof mq, "INSERT INTO `players` (`login`, `haslo`) VALUES ('%s', '%s')", PlayerName(playerid), password);
	db_query(dbh, mq);
	thorus_resetStats(playerid);
	OnPlayerLogin(playerid, password);
	return 1;
}

public thorus_resetStats(playerid)
{
    p[playerid][kasa] = 1500;
	p[playerid][exp] = 0;
    p[playerid][wexp] = 4;
    p[playerid][level] = 1;
    p[playerid][ranga] = 0;
    p[playerid][rangaf] = 0;
    p[playerid][skin] = 72;
    p[playerid][praca] = 0;
    p[playerid][materialy] = 0;
    p[playerid][dragi] = 0;
    p[playerid][prawko] = 0;
    p[playerid][pilotaz] = 0;
    p[playerid][motor] = 0;
    p[playerid][lickabron] = 0;
    p[playerid][fid] = 0;
    return 1;
}

public thorus_savePlayer(playerid)
{
	format(bq, sizeof bq, "UPDATE `players` SET `kasa`='%d', `exp`='%d', `wexp`='%d', `level`='%d', `ranga`='%d'`, `rangaf`='%d', `skin`='%d', `praca`='%d', `materialy`='%d', `dragi`='%d', `prawko`='%d', `pilotaz`='%d', `motor`='%d', `lickabron`='%d', `fid`='%d' WHERE `login`='%s'",
	p[playerid][kasa],
	p[playerid][exp],
    p[playerid][wexp],
    p[playerid][level],
    p[playerid][ranga],
    p[playerid][rangaf],
    p[playerid][skin],
    p[playerid][praca],
    p[playerid][materialy],
    p[playerid][dragi],
    p[playerid][prawko],
    p[playerid][pilotaz],
    p[playerid][motor],
    p[playerid][lickabron],
    p[playerid][fid]);
    dbr = db_query(dbh, bq);
	return 1;
}

public zhash(playerid, npassword[])
{
    if(strlen(npassword) < 3 || strlen(npassword) > 24)
	    return ShowPlayerDialog(playerid, zmienh, DIALOG_STYLE_PASSWORD, "Zmiana has³a", "Wyst¹pi³ b³¹d!\nHas³o musi siê sk³adaæ minimum z 3 znaków, maksimum 24.\nPodaj jeszcze raz has³o:", "Zmieñ", "Anuluj");

	format(sq, sizeof sq, "UPDATE `players` SET `haslo`='%s' WHERE `login`='%s'", PlayerName(playerid));
	db_query(dbh, sq);
	SendClientMessage(playerid, niebieski, "[Serwer:] Zmieniono has³o! Obowi¹zuje one od nastêpnego logowania! ");
	return 1;
}

stock PlayerName(playerid)
{
	new name[24];
	GetPlayerName(playerid, name, 24);
	return name;
}

// AntyMoneyHack

stock GetCash(playerid)
	return p[playerid][kasa];
	
stock GiveCash(playerid, gcash)
	return p[playerid][kasa] += gcash & UpdateCash(playerid);
	
stock UpdateCash(playerid)
	return ResetPlayerMoney(playerid) & GivePlayerMoney(playerid, p[playerid][kasa]);
	
stock ResetCash(playerid)
	return p[playerid][kasa] = 0 & Updatecash(playerid);

stock SetCash(playerid, scash)
	return p[playerid][kasa] = scash & UpdateCash(playerid);
	
// reszta funkcji
	
stock SendClientLocalMessage(Float:radius, playerid, string[], col1, col2, col3, col4, col5)
{
	new Float:pos[3], Float:oldpos[3], Float:temppos[3];
	GetPlayerPos(playerid, oldpos[0], oldpos[1], oldpos[2]);
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		GetPlayerPos(i, pos[0], pos[1], pos[2]);
		temppos[0] = (oldpos[0] - pos[0]);
		temppos[1] = (oldpos[1] - pos[1]);
		temppos[2] = (oldpos[2] - pos[2]);
		if(((temppos[0] < radius/16) && (temppos[0] > -radius/16)) && ((temppos[1] < radius/16) && (temppos[1] > -radius/16)) && ((temppos[2] < radius/16) && (temppos[2] > -radius/16))) SendClientMessage(i,col1,string);
		else if(((temppos[0] < radius/8) && (temppos[0] > -radius/8)) && ((temppos[1] < radius/8) && (temppos[1] > -radius/8)) && ((temppos[2] < radius/8) && (temppos[2] > -radius/8))) SendClientMessage(i,col2,string);
		else if(((temppos[0] < radius/4) && (temppos[0] > -radius/4)) && ((temppos[1] < radius/4) && (temppos[1] > -radius/4)) && ((temppos[2] < radius/4) && (temppos[2] > -radius/4))) SendClientMessage(i,col3,string);
		else if(((temppos[0] < radius/2) && (temppos[0] > -radius/2)) && ((temppos[1] < radius/2) && (temppos[1] > -radius/2)) && ((temppos[2] < radius/2) && (temppos[2] > -radius/2))) SendClientMessage(i,col4,string);
		else if(((temppos[0] < radius) && (temppos[0] > -radius)) && ((temppos[1] < radius) && (temppos[1] > -radius)) && ((temppos[2] < radius) && (temppos[2] > -radius))) SendClientMessage(i,col5,string);
	}
	return 1;
}

// komendy

CMD:komendy(playerid, params[])
{
	SendClientMessage(playerid, zolty, "[CMD] - /statystyki - /zmienhaslo - /admini");
	return 1;
}

/*
	*
	*   System organizacji
	*       stworzony przez
	*           Thorus
	*               wersja: 0.5
	*
	
	CREATE TABLE `members` (
   `id` mediumint(9) not null auto_increment,
   `login` varchar(24) not null,
   `orgid` mediumint(9) not null default '0',
   `idrangi` mediumint(9) not null default '0',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

CREATE TABLE `organizacje` (
   `id` mediumint(9) not null auto_increment,
   `nazwa` varchar(32) not null default 'default',
   `zalozyciel` varchar(24) not null,
   `typ` smallint(6) not null default '0',
   `x` double not null default '0',
   `y` double not null default '0',
   `z` double not null default '0',
   `a` double not null default '0',
   `konto` int(11) not null default '0',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

CREATE TABLE `rangi` (
   `id` int(11) not null auto_increment,
   `idorg` int(11) not null default '0',
   `nazwa` varchar(16) not null,
   `skinid` smallint(6) not null default '72',
   `typ` tinyint(4) not null default '0',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

*/
#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <zcmd>

// ** ustawienia bazy danych
#define host "localhost" // host
#define user "admin" // u¿ytkownik
#define pass "admin" // has³o
#define db "test" // nazwa bazy danych

// ** kolory
#define org_chat 0x9BFFFFCC
#define org_error 0xF9FC5DCC
#define org_info 0x56B534CC


// ** limity
#define MAX_ORGS    100
#define MAX_RANGI   100

// ** funkcje - forward
forward thorus_loadMember(playerid);
forward thorus_loadOrg();
forward thorus_loadRan();
forward thorus_addMember(playerid);
forward thorus_saveMember(playerid);
forward thorus_saveOrg(org_id);
forward thorus_saveRan(ran_id);
forward thorus_deleteOrg(org_id);
forward thorus_deleteRan(ran_id);
forward thorus_addOrg(nazwa_o[32], zalozyciel_o[24]);
forward thorus_orgchat(playerid, chat[]);

// ** zmienne globalne

new query[300];
new ileorg;
new sdata[128];
new zapakt[MAX_PLAYERS] = false;
new zaproid[MAX_PLAYERS] = 0;

enum o
{
	o_id,
	o_nazwa[32],
	o_zalozyciel[24],
	o_typ,
	Float:o_x,
	Float:o_y,
	Float:o_z,
 	Float:o_a,
 	o_konto,
}

new org[MAX_ORGS][o];

enum r
{
	r_id,
	r_idorg,
	r_nazwa[16],
	r_skinid,
	r_typ,
}

new ranga[MAX_RANGI][r];

enum m
{
	m_id,
	m_nick[24],
	m_orgid,
	m_idrangi,
}

new mem[MAX_PLAYERS][m];


public OnFilterScriptInit()
{
	mysql_connect(host, user, db, pass);
	if(mysql_ping() == 1)
	{
	    printf("\n[sORG:] Polaczylem sie z %s, user: %s i host: %s", db, user, host);
	}
	else
	{
		print("\n[sORG:] Brak polaczenia.. sprawdz ustawienia !");
	}
	thorus_loadOrg();
	thorus_loadRan();
	return 1;
}

public OnFilterScriptExit()
{
	mysql_close();
	for(new h; h < MAX_ORGS; h++)
	{
	    thorus_saveOrg(h);
	}
	for(new a; a < MAX_RANGI; a++)
	{
	    thorus_saveRan(a);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	format(query, sizeof(query), "select `id` from `members` where `login`='%s'", PlayerName(playerid));
	mysql_query(query);
	mysql_store_result();
	if(mysql_num_rows())
	{
	    thorus_loadMember(playerid);
	}
	else
	{
	    thorus_addMember(playerid);
	}
	mysql_free_result();
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	thorus_saveMember(playerid);
	zapakt[playerid] = false;
	zaproid[playerid] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(mem[playerid][m_orgid] != 0)
	{
		SetPlayerSkin(playerid, ranga[mem[playerid][m_idrangi]][r_skinid]);
		SetPlayerPos(playerid, org[mem[playerid][m_orgid]][o_x],  org[mem[playerid][m_orgid]][o_y],  org[mem[playerid][m_orgid]][o_z]);
		SetPlayerFacingAngle(playerid, org[mem[playerid][m_orgid]][o_a]);
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

public thorus_addOrg(nazwa_o[32], zalozyciel_o[24])
{
	format(query, sizeof(query), "insert into `organizacje` (`nazwa`, `zalozyciel`) values ('%s', '%s')", nazwa_o, zalozyciel_o);
	mysql_query(query);
	new oid = mysql_insert_id();
	mysql_free_result();
	org[oid][o_id] = oid;
	org[oid][o_nazwa] = nazwa_o;
	org[oid][o_zalozyciel] = zalozyciel_o;
	org[oid][o_typ] = 0;
	org[oid][o_x] = 0;
	org[oid][o_y] = 0;
	org[oid][o_z] = 0;
	org[oid][o_a] = 0;
	org[oid][o_konto] = 0;
	return oid;
}

public thorus_deleteRan(ran_id)
{
    format(query, sizeof(query), "delete from `rangi` where `id`='%d'", ran_id);
	mysql_query(query);
	mysql_free_result();
	format(query, sizeof(query), "update `members` set `idrangi`='0' where `idrangi`='%d'", ran_id);
	mysql_query(query);
	mysql_free_result();
	printf("\n[sOrg:] Usunalem range o id %d", ran_id);
	return 1;
}

public thorus_deleteOrg(org_id)
{
	format(query, sizeof(query), "delete from `organizacje` where `id`='%d'", org_id);
	mysql_query(query);
	mysql_free_result();
	format(query, sizeof(query), "delete from `rangi` where `idorg`='%d'", org_id);
	mysql_query(query);
	mysql_free_result();
	format(query, sizeof(query), "update `members` set `orgid`='0', `idrangi`='0' where `orgid`='%d'", org_id);
	mysql_query(query);
	mysql_free_result();
	printf("\n[sOrg:] Usunalem organizacje id %d", org_id);
	return 1;
}
public thorus_saveRan(ran_id)
{
	format(query, sizeof(query), "update `rangi` set `idorg`='%d', `nazwa`='%s', `skinid`='%d', `typ`='%d'",
	ranga[ran_id][r_idorg],
	ranga[ran_id][r_nazwa],
	ranga[ran_id][r_skinid],
	ranga[ran_id][r_typ]);
	mysql_query(query);
	mysql_free_result();
	printf("\n[sOrg:] Nadpisalem dane %s", ranga[ran_id][r_nazwa]);
	return 1;
}

public thorus_saveOrg(org_id)
{
    format(query, sizeof(query), "update `organizacje` set `nazwa`='%s', `zalozyciel`='%s', `typ`='%d', `x`='%f', `y`='%f', `z`='%f', `a`='%f', `konto`='%d' where `id`='%d'",
    org[org_id][o_nazwa],
    org[org_id][o_zalozyciel],
    org[org_id][o_typ],
    org[org_id][o_x],
    org[org_id][o_y],
    org[org_id][o_z],
    org[org_id][o_a],
    org[org_id][o_konto],
	org_id);
	mysql_query(query);
	mysql_free_result();
	printf("\n[sOrg:] Nadpisalem dane %s", org[org_id][o_nazwa]);
	return 1;
}

public thorus_saveMember(playerid)
{
	format(query, sizeof(query), "update `members` set `orgid`='%d', `idrangi`='%d' where `login`='%s'",
	mem[playerid][m_orgid],
	mem[playerid][m_idrangi],
	PlayerName(playerid));
	mysql_query(query);
	mysql_free_result();
	return 1;
}

public thorus_loadRan()
{
    print("\n[sOrg:] Zaczynam wczytywac rangi....");
	new ile;
	mysql_query("select * from `rangi`");
	mysql_store_result();
	while(mysql_fetch_row_format(query, "|"))
	{
	    new uid;
	    sscanf(query, "p<|>d", uid);
	    sscanf(query, "p<|>dds[16]dd",
        ranga[uid][r_id],
        ranga[uid][r_idorg],
        ranga[uid][r_nazwa],
        ranga[uid][r_skinid],
        ranga[uid][r_typ]
		);
        ranga[uid][r_id] = uid;
        printf("\n[sOrg:] %s - UID: %d - OID: %d", ranga[uid][r_nazwa], uid, ranga[uid][r_id]);
        ile++;
	}
	mysql_free_result();
	printf("\n[sOrg:] Wczytano %d rangi", ile);
	print("\n[sOrg:] Koniec wczytywania rang !");
	return 1;
}

public thorus_loadOrg()
{
	print("\n[sOrg:] Zaczynam wczytywac organizacje....");
	mysql_query("select * from `organizacje`");
	mysql_store_result();
	while(mysql_fetch_row_format(query, "|"))
	{
	    new uid;
	    sscanf(query, "p<|>d", uid);
	    sscanf(query, "p<|>ds[32]s[24]dffffd",
	    org[uid][o_id],
        org[uid][o_nazwa],
        org[uid][o_zalozyciel],
        org[uid][o_typ],
        org[uid][o_x],
        org[uid][o_y],
        org[uid][o_z],
        org[uid][o_a],
        org[uid][o_konto]);
        org[uid][o_id] = uid;
        printf("\n[sOrg:] %s - UID: %d - OID: %d", org[uid][o_nazwa], uid, org[uid][o_id]);
        ileorg++;
	}
	mysql_free_result();
	printf("\n[sOrg:] Wczytano %d organizacji", ileorg);
	print("\n[sOrg:] Koniec wczytywania organizacji !");
	return 1;
}

public thorus_loadMember(playerid)
{
	format(query, sizeof(query), "select * from `members` where `login`='%s'", PlayerName(playerid));
	mysql_query(query);
	mysql_store_result();
	mysql_fetch_row_format(query, "|");
	sscanf(query, "p<|>ds[24]dd",
	mem[playerid][m_id],
	mem[playerid][m_nick],
	mem[playerid][m_orgid],
	mem[playerid][m_idrangi]);
	printf("\n[sORG:] %s - [%d] - wczytany", mem[playerid][m_nick], mem[playerid][m_id]);
	mysql_free_result();
	return 1;
}

public thorus_addMember(playerid)
{
	format(query, sizeof(query), "insert into `members` (`login`) values ('%s')", PlayerName(playerid));
	mysql_query(query);
	printf("\n[sORG:] %s zostal dodany do bazy danych!", PlayerName(playerid));
	mysql_free_result();
	return 1;
}

stock PlayerName(playerid)
{
  new name[24];
  GetPlayerName(playerid, name, 24);
  return name;
}

public thorus_orgchat(playerid, chat[])
{
	for(new p; p <= MAX_PLAYERS; p++)
 	{
  		if(mem[p][m_orgid] == mem[playerid][m_orgid])
  		{
  		    format(query, sizeof(query), "(%s)%s: %s", ranga[mem[playerid][m_idrangi]][r_nazwa], PlayerName(playerid), chat);
  		    SendClientMessage(p, org_chat, query);
		}
 	}
}

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	return 1;
}

CMD:o(playerid, params[])
{
	if(sscanf(params, "s[128]", query))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /o [treœæ wiadomoœci]");

	if(strlen(query) > 128 || strlen(query) < 1)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Wiadomoœæ wynosi od 1-128 znaków");
	    
    thorus_orgchat(playerid, query);
    return 1;
}


CMD:addorg(playerid, params[])
{
	if(!IsPlayerAdmin(playerid))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");

	new n[32], z[24];
    if(sscanf(params, "s[32]s[24]", n, z))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /addorg [nazwa organizacji] [nick za³o¿yciela]");
	    
	if(strlen(n) > 32 || strlen(n) < 3)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nazwa organizacji musi wynosiæ od 3-32 znaków.");
	    
    if(strlen(z) > 24 || strlen(z) < 1)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nick za³o¿yciela nie mo¿e przekraczaæ 24 znaków.");

	format(sdata, 128, "select `id` from `members` where `login`='%s'", z);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie ma takiego gracza w bazie danych.");
	    
	mysql_free_result();
	
	format(sdata, 128, "select `id` from `organizacje` where `zalozyciel`='%s'", z);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() > 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Ten gracz za³o¿y³ ju¿ organizacje.");

	mysql_free_result();
	thorus_addOrg(n, z);
	format(sdata, 128, "[sOrg:] Stworzy³eœ organizacje %s - za³o¿yciel: %s", n, z);
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

CMD:delorg(playerid, params[])
{
	if(!IsPlayerAdmin(playerid))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");

	new ido;
	if(sscanf(params, "d", ido))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /delorg [id organizacji]");
	    
	format(sdata, 128, "select `id` from `organizacje` where `id`='%d'", ido);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Organizacja o takim ID nie istnieje w bazie danych.");

	mysql_free_result();
	thorus_deleteOrg(ido);
	format(sdata, 128, "[sOrg:] Usun¹³eœ organizacje o id %d", ido);
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

CMD:norg(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");
	    
	new n[32], ido;
	if(sscanf(params, "ds[32]", ido, n))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /norg [id organizacji] [nowa nazwa organizacji]");
	    
    format(sdata, 128, "select `id` from `organizacje` where `id`='%d'", ido);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Organizacja o takim ID nie istnieje w bazie danych.");
	    
    mysql_free_result();
	    
	if(strlen(n) > 32 || strlen(n) < 3)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nazwa organizacji musi wynosiæ od 3-32 znaków.");
	    
    format(sdata, 128, "select `id` from `organizacje` where `nazwa`='%s'", n);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() > 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Organizacja o takiej nazwie istnieje ju¿ w bazie danych.");

    mysql_free_result();
    org[ido][o_nazwa] = n;
    format(sdata, 128, "[sOrg:] Zmieni³eœ nazwê organizacji o id %d, na %s", ido, n);
	SendClientMessage(playerid, org_info, sdata);
    return 1;
}

CMD:zorg(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");

	new z[24], ido;
	if(sscanf(params, "ds[24]", ido, z))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /zorg [id organizacji] [nick nowego za³o¿yciela organizacji]");
	    
	format(sdata, 128, "select `id` from `members` where `login`='%s'", z);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie ma takiego gracza w bazie danych.");

    mysql_free_result();
	    
    format(sdata, 128, "select `id` from `organizacje` where `zalozyciel`='%s'", z);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() > 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Ten gracz za³o¿y³ ju¿ organizacje.");
	    
	mysql_free_result();
    org[ido][o_zalozyciel] = z;
    format(sdata, 128, "[sOrg:] Zmieni³eœ za³ozyciela organizacji o id %d, na %s", ido, z);
	SendClientMessage(playerid, org_info, sdata);
    return 1;
}

CMD:torg(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");

	new ido, typ;
	if(sscanf(params, "dd", ido, typ))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /torg [id organizacji] [id typu]");

	format(sdata, 128, "select `id` from `organizacje` where `id`='%d'", ido);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Organizacja o takim ID nie istnieje w bazie danych.");

	mysql_free_result();
	org[ido][o_typ] = typ;
	format(sdata, 128, "[sOrg:] Zmieni³eœ typ organizacji o ID %d, na typ id %d", ido, typ);
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

CMD:porg(playerid, params[])
{
	if(!IsPlayerAdmin(playerid))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");

	new ido;
	if(sscanf(params, "d", ido))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /porg [id organizacji]");
	    
    format(sdata, 128, "select `id` from `organizacje` where `id`='%d'", ido);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Organizacja o takim ID nie istnieje w bazie danych.");
	    
	new Float:posX, Float:posY, Float:posZ, Float:posA;
	GetPlayerPos(playerid, posX, posY, posZ);
	GetPlayerFacingAngle(playerid, posA);
	org[ido][o_x] = posX;
	org[ido][o_y] = posY;
	org[ido][o_z] = posZ;
	org[ido][o_a] = posA;
	format(sdata, 128, "[sOrg:] Zmieni³eœ spawn organizacji o ID %d", ido);
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

CMD:korg(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");

	new ido, konto;
	if(sscanf(params, "dd", ido, konto))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /korg [id organizacji] [nowy stan konta]");

    format(sdata, 128, "select `id` from `organizacje` where `id`='%d'", ido);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Organizacja o takim ID nie istnieje w bazie danych.");
	    
	if(konto > 900000000)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Zbyt du¿a wartoœæ.");
	    
    org[ido][o_konto] = konto;
    format(sdata, 128, "[sOrg:] Zmieni³eœ iloœæ pieniêdzy na koncie organizacji o ID %d, nowy stan konta: %d$", ido, konto);
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

CMD:odejdz(playerid, params[])
{
	if(mem[playerid][m_orgid] == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ w organizacji.");
	    
    thorus_orgchat(playerid, "-----> opuœci³ organizacje");
    mem[playerid][m_orgid] = 0;
    mem[playerid][m_idrangi] = 0;
    thorus_saveMember(playerid);
    SendClientMessage(playerid, org_info, "[sOrg:] Odszed³eœ z organizacji");
    return 1;
}
/*
CMD:wplacorg(playerid, params[])
{
    if(mem[playerid][m_orgid] == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ w organizacji.");
	    
	new kwota;
	if(sscanf(params, "d", kwota))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /wplacorg [iloœæ gotówki]");
	    
	if(kwota < GetPlayerMoney(playerid))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie masz tyle gotówki");
	    
	GivePlayerMoney(playerid, -kwota);
	org[mem[playerid][m_orgid]][o_konto] += kwota;
	format(sdata, sizeof(sdata), "-----> wp³aci³ %d $", kwota);
	thorus_orgchat(playerid, sdata);
	return 1;
}
*/
CMD:aorg(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");
	    
    SendClientMessage(playerid, org_info, "[sOrg:] /addorg - dodaje organizacje");
    SendClientMessage(playerid, org_info, "[sOrg:] /delorg - usuwa organizacje");
    SendClientMessage(playerid, org_info, "[sOrg:] /norg - zmienia nazwê organizacji");
    SendClientMessage(playerid, org_info, "[sOrg:] /zorg - zmienia za³o¿yciela organizacji");
    SendClientMessage(playerid, org_info, "[sOrg:] /torg - zmienia typ organizacji");
    SendClientMessage(playerid, org_info, "[sOrg:] /porg - zmienia pozycje spawnu organizacji");
    SendClientMessage(playerid, org_info, "[sOrg:] /korg - zmienia stan konta organizacji");
    return 1;
}

CMD:rorg(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");
	    
    SendClientMessage(playerid, org_info, "[sOrg:] /addrank - dodaje range");
    SendClientMessage(playerid, org_info, "[sOrg:] /delrank - usuwa range");
    SendClientMessage(playerid, org_info, "[sOrg:] /nrank - zmienia nazwê rangi");
    SendClientMessage(playerid, org_info, "[sOrg:] /srank - zmienia id skinu rangi");
    SendClientMessage(playerid, org_info, "[sOrg:] /trank - zmienia typ rangi");
    return 1;
}

CMD:lorg(playerid, params[])
{
    if(mem[playerid][m_orgid] == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ w organizacji.");

    if(mem[playerid][m_idrangi] == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie masz jeszcze przyznanej rangi.");

	if(ranga[mem[playerid][m_idrangi]][r_typ] != 1)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ liderem.");
	    
    SendClientMessage(playerid, org_info, "[sOrg:] /zapros - zapraszasz gracza do organizacji");
    SendClientMessage(playerid, org_info, "[sOrg:] /wyrzuc - wyrzucasz gracza z organizacji");
    SendClientMessage(playerid, org_info, "[sOrg:] /zmienrange - zmieniasz rangê graczowi z Twojej organizacji");
	return 1;
}

CMD:gorg(playerid, params[])
{
    SendClientMessage(playerid, org_info, "[sOrg:] /akceptuj - akceptujesz zaproszenie do organizacji");
    SendClientMessage(playerid, org_info, "[sOrg:] /odejdz - odchodzisz z organizacji");
	return 1;
}

CMD:addrank(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");
	    
	new n[16], ido, ids, idt;
	if(sscanf(params, "s[16]ddd", n, ido, ids, idt))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /addrank [nazwa] [id organizacji] [id skinu] [typ]");
	    
	if(strlen(n) > 16 || strlen(n) < 1)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nazwa musi wynosiæ od 1 do 16 znaków.");
	    
    format(sdata, 128, "select `id` from `organizacje` where `id`='%d'", ido);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Organizacja o takim ID nie istnieje w bazie danych.");
	    
	mysql_free_result();
	if(ids < 1 || ids > 399)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nieprawid³owe id skinu.");
	    
	if(idt < 1 || idt > 9999)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nieprawid³owe id typu, musi byæ w przedziale 1-9999");
	    
	format(sdata, sizeof(sdata), "INSERT INTO `rangi` (`idorg`, `nazwa`, `skinid`, `typ`) values ('%d', '%s', '%d', '%d')", ido, n, ids, idt);
	mysql_query(sdata);
	new idr = mysql_affected_rows();
	ranga[idr][r_nazwa] = n;
	ranga[idr][r_skinid] = ids;
	ranga[idr][r_typ] = idt;
	ranga[idr][r_idorg] = ido;
	mysql_free_result();
	format(sdata, sizeof(sdata), "[sOrg:] Doda³eœ now¹ rangê do bazy danych: %s - idOrg: %d - skinId: %d - typId: %d", n, ido, ids, idt);
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

CMD:delrank(playerid, params[])
{
	if(!IsPlayerAdmin(playerid))
 		return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");
	    
	new idrxx;
	if(sscanf(params, "d", idrxx))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /delrank [id rangi]");
	    
	format(sdata, sizeof(sdata), "select `id` from `rangi` where `id`='%d'", idrxx);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie ma rangi o takim ID w bazie danych.");
	    
	thorus_deleteRan(idrxx);
	mysql_free_result();
	format(sdata, sizeof(sdata), "[sOrg:] Usun¹³eœ rangê o ID: %d", idrxx);
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

CMD:nrank(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
 		return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");
 		
	new n[16], idr;
	if(sscanf(params, "ds[16]", n, idr))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /nrank [id rangi] [nowa nazwa]");
	    
    if(strlen(n) > 16 || strlen(n) < 1)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nazwa musi wynosiæ od 1 do 16 znaków.");
	    
    format(sdata, 128, "select `id` from `rangi` where `id`='%d'", idr);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Ranga o takim ID nie istnieje w bazie danych.");
	    
	mysql_free_result();
	ranga[idr][r_nazwa] = n;
	thorus_saveRan(idr);
	format(sdata, sizeof(sdata), "[sOrg:] Zmieni³eœ nazwê rangi o ID: %d, na %s", idr, n);
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

CMD:srank(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
 		return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");
 		
	new idr, ids;
	if(sscanf(params, "dd", idr, ids))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /srank [id rangi] [id skinu]");
	    
	if(ids > 399 || ids < 1)
	    return SendClientMessage(playerid, org_error, "[sOrg:] ID skinu to liczba w przedziale 1-399.");
	    
    format(sdata, 128, "select `id` from `rangi` where `id`='%d'", idr);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Ranga o takim ID nie istnieje w bazie danych.");

	mysql_free_result();
	ranga[idr][r_skinid] = ids;
	thorus_saveRan(idr);
    format(sdata, sizeof(sdata), "[sOrg:] Zmieni³eœ skin rangi o ID: %d, na id skinu: %d", idr, ids);
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

CMD:trank(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
 		return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ upowa¿niony do u¿ycia tej komendy.");

	new idr, idt;
	if(sscanf(params, "dd", idr, idt))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /trank [id rangi] [typ]");
	    
    if(idt > 9999 || idt < 1)
	    return SendClientMessage(playerid, org_error, "[sOrg:] ID typu to liczba w przedziale 1-399.");

    format(sdata, 128, "select `id` from `rangi` where `id`='%d'", idr);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Ranga o takim ID nie istnieje w bazie danych.");

	mysql_free_result();
	ranga[idr][r_typ] = idt;
	thorus_saveRan(idr);
	format(sdata, sizeof(sdata), "[sOrg:] Zmieni³eœ typ rangi o ID: %d, na id typu: %d", idr, idt);
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

CMD:zmienrange(playerid, params[])
{
	if(mem[playerid][m_orgid] == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ w organizacji.");
	    
    if(mem[playerid][m_idrangi] == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie masz jeszcze przyznanej rangi.");

	if(ranga[mem[playerid][m_idrangi]][r_typ] != 1)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ liderem.");
	    
	new n[16], idg;
	if(sscanf(params, "ds[16]", idg, n))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /zmienrange [id gracza] [nazwa rangi]");
	    
	if(!IsPlayerConnected(idg))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Ten gracz nie jest zalogowany.");
	    
	if(idg == playerid)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie mo¿esz samemu sobie zmieniæ rangi.");
	    
	if(strlen(n) > 16 || strlen(n) < 1)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nazwa rangi musi mieœciæ siê w przedziale od 1-16 znaków.");
	    
	format(sdata, sizeof(sdata), "SELECT `id` FROM `rangi` WHERE `nazwa`='%s' AND `idorg`='%d' ", n, mem[playerid][m_orgid]);
	mysql_query(sdata);
	mysql_store_result();
	if(mysql_num_rows() == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Ranga o takiej nazwie nie istnieje w naszej bazie danych."),mysql_free_result();
	    
	mysql_fetch_row_format(sdata, "|");
	new idr;
	sscanf(sdata, "d", idr);
	mysql_free_result();
	mem[idg][m_idrangi] = idr;
	format(sdata, sizeof(sdata), "[sOrg:] Zmieni³eœ graczowi %s rangê w organizacji, na %s", PlayerName(idg), ranga[idr][r_nazwa]);
	SendClientMessage(playerid, org_info, sdata);
	format(sdata, sizeof(sdata), "[sOrg:] Gracz %s zmieni³ Ci rangê na %s", PlayerName(playerid), ranga[idr][r_nazwa]);
	SendClientMessage(idg, org_info, sdata);
	thorus_saveMember(idg);
	thorus_orgchat(idg, "-----> otrzyma³ now¹ rangê");
	return 1;
}

CMD:wyrzuc(playerid, params[])
{
    if(mem[playerid][m_orgid] == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ w organizacji.");

    if(mem[playerid][m_idrangi] == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie masz jeszcze przyznanej rangi.");

	if(ranga[mem[playerid][m_idrangi]][r_typ] != 1)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ liderem.");
	    
	new idg;
	if(sscanf(params, "d", idg))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /wyrzuc [id gracza]");
	    
    if(!IsPlayerConnected(idg))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Ten gracz nie jest zalogowany.");

	if(idg == playerid)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie mo¿esz wyrzuciæ samego siebie.");
	    
    thorus_orgchat(idg, "-----> zosta³ wyrzucony z organizacji");
	mem[idg][m_orgid] = 0;
	mem[idg][m_idrangi] = 0;
	thorus_saveMember(idg);
	format(sdata, sizeof(sdata), "[sOrg:] Wyrzuci³eœ %s z organizacji", PlayerName(idg));
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

CMD:zapros(playerid, params[])
{
    if(mem[playerid][m_orgid] == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ w organizacji.");

    if(mem[playerid][m_idrangi] == 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie masz jeszcze przyznanej rangi.");

	if(ranga[mem[playerid][m_idrangi]][r_typ] != 1)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie jesteœ liderem.");

	new idg;
	if(sscanf(params, "d", idg))
	    return SendClientMessage(playerid, org_error, "[sOrg:] /zapros [id gracza]");

    if(!IsPlayerConnected(idg))
	    return SendClientMessage(playerid, org_error, "[sOrg:] Ten gracz nie jest zalogowany.");

	if(idg == playerid)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie mo¿esz zaprosiæ samego siebie.");
	    
	if(mem[idg][m_orgid] != 0 && mem[idg][m_idrangi] != 0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] ten gracz ma ju¿ organizacje.");
	    
	zapakt[idg] = true;
	zaproid[idg] = mem[playerid][m_orgid];
	format(sdata, sizeof(sdata), "[sOrg:] Zaprosi³eœ %s do organizacji", PlayerName(idg));
	SendClientMessage(playerid, org_info, sdata);
	format(sdata, sizeof(sdata), "[sOrg:] %s wysy³a Ci zaproszenie do organizacji. Wpisz /akceptuj aby do³¹czyæ do organizacji i zaakceptowaæ zaproszenie.", PlayerName(playerid));
	SendClientMessage(idg, org_info, sdata);
	return 1;
}

CMD:akceptuj(playerid, params[])
{
	if(!zapakt[playerid])
	    return SendClientMessage(playerid, org_error, "[sOrg:] Nie masz aktywnego zaproszenia.");
	    
    if(zaproid[playerid] == 0)
        return SendClientMessage(playerid, org_error, "[sOrg:] Nie masz zaproszenia do organizacji.");
        
	if(mem[playerid][m_orgid] != 0 || mem[playerid][m_idrangi] !=0)
	    return SendClientMessage(playerid, org_error, "[sOrg:] Masz ju¿ organizacje i rangê.");

	mem[playerid][m_orgid] = zaproid[playerid];
	thorus_saveMember(playerid);
	format(sdata, sizeof(sdata), "[sOrg:] Akceptowa³eœ zaproszenie i do³aczy³eœ do %s", org[zaproid[playerid]][o_nazwa]);
	SendClientMessage(playerid, org_info, sdata);
	return 1;
}

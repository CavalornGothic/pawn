/*
	*
	* 	PS-RPG
	* 		by Thorus
	
*/
#define MAX_REMOVED_OBJECTS 700

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <zcmd>
#include <time>
#include <streamer>

#undef MAX_PLAYERS
#define MAX_PLAYERS 20

#define max_veh 40
#define MAX_TYP_BIZ 7
#define max_biz 50
#define max_org 50

#define org_chat 0x9BFFFFCC
#define org_error 0xF9FC5DCC
#define org_info 0x56B534CC

#define MAX_RANGI   100

// gracze
#define logowanie 743
#define rejestracja 351
#define zmienhaslo 912
#define statystyki 164
#define pomoc 100
// pojazdy
#define ppanel 5001
#define ppanel2 5002
#define ppanelkolor 5003
#define ppanelkolor2 5004
#define ppanelteleport 5005
// biznesy 
#define bizskleppanel 7001
#define bizammunationpanel 7002
#define bizbarclubpanel 7003
#define bizsklepubraniapanel 7004
#define bizsspanel 7005
#define bizerror 7006
#define bizownpanel 7007
#define biznamedialog 7008
#define bizsejfdialog 7009
#define bizdrzwidialog 7010
#define bizproduktydialog 7011
#define bizsellpanel 7012

#define CZAT1 0xE6E6E6E6
#define CZAT2 0xC8C8C8C8
#define CZAT3 0xAAAAAAAA
#define CZAT4 0x8C8C8C8C
#define CZAT5 0x6E6E6E6E
#define zolty 0xF5FF7CAA
#define zielony 0x71D642AA
#define niebieski 0x3AC8F5AA
#define rozowy 0xFF7CA7FF
#define pomaranczowy 0xFFCE51AA
#define admincolor 0xc4ff63FF
#define czerwony 0xff3030

forward thorus_OnPlayerLogin(playerid, password[]);
forward thorus_OnPlayerRegister(playerid, password[]);
forward thorus_resetStats(playerid);
forward thorus_OnPlayerDataSave(playerid);
forward thorus_ShowStatsPlayer(playerid);
forward thorus_ChangePassword(playerid, password[]);
forward thorus_AdminMessage(who[], message[]);
forward thorus_loadVeh();
forward thorus_CreateVehicleFromDB(uid);
forward thorus_saveVeh(idv);
forward thorus_listVeh(playerid);
forward thorus_loadOrg();
forward thorus_saveOrg(orgid);
forward thorus_orgChat(playerid, text[]);
forward thorus_orgMessage(o_id, text[]);
forward thorus_orgAdd(o_name[24], o_typ, Float:o_x, Float:o_y, Float:o_z, Float:o_a);
forward thorus_orgDel(idorg);
forward ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
forward thorus_loadBuilding();
forward thorus_buildingCreate(playerid, b_name[24]);
forward thorus_saveBuilding(b_id);
forward thorus_loadBusiness();
forward thorus_createBusiness(playerid, b_name[24], b_typ);
forward thorus_saveBusiness(uid);
forward WH(playerid);
forward Drunk(playerid, drunklevel);
forward unDrunk(playerid);

new gstatus;
new ile=0;
new vehicleuid[MAX_PLAYERS];
new ileorg=0;
new BigEar[MAX_PLAYERS];
new chat=1;
new pkwota[MAX_PLAYERS] = 0;
new	opojazd[MAX_PLAYERS] = 0;
new	p_id[MAX_PLAYERS] = 0;
new p_uid[MAX_PLAYERS] = 0;
new oorg[MAX_PLAYERS] = 0;
new ooid[MAX_PLAYERS] = 0;
new ilebud=0;
new ilebiz=0;
new biz_index[MAX_PLAYERS];
new timer_wh;

enum g
{
	id,
	login[24],
	haslo[24],
	zalogowany,
	kasa,
	level,
	exp,
	wexp,
	skin,
	prawko,
	pilotaz,
	motor,
	lickabron,
	admin,
	vip,
	praca,
	idf,
	ranga,
	plog,
	slot, // 0-1
	slot1, // 2-9
	slot2,
	ammo2,
	slot3,
	ammo3,
	slot4,
	ammo4,
	slot5,
	ammo5,
	slot6,
	ammo6,
	slot9,
	ammo9,
	slot10,
}

new p[MAX_PLAYERS][g];

enum ghgh
{
	vid,
	model,
	Float:vx,
	Float:vz,
	Float:vy,
	Float:va,
	kolor,
	kolor2,
	typ,
	fid,
	cena,
	ido,
}

new v[max_veh][ghgh];

enum o
{
	oid,
	onazwa[24],
	typ,
	Float:ox,
	Float:oy,
	Float:oz,
	Float:oa,
	r_skin,
	r_nazwa[12],
	r_skin2,
	r_nazwa2[12],
	r_skin3,
	r_nazwa3[12],
	r_skin4,
	r_nazwa4[12],
	r_skin5,
	r_nazwa5[12],
	r_skin6,
	r_nazwa6[12],
	r_skin7,
	r_nazwa7[12],
	r_skin8,
	r_nazwa8[12],
	r_skin9,
	r_nazwa9[12],
	r_skin10,
	r_nazwa10[12],
}

new org[max_org][o];

enum huuu
{
	bid,
	nazwa[24],
	Float:ex,
	Float:ey,
	Float:ez,
	Float:ea,
	eint,
	Float:ex2,
	Float:ey2,
	Float:ez2,
	Float:ea2,
	eint2,
	pickupid2,
	index_t,
}

new bud[100][huuu];

enum guuu
{
	bizid,
	nazwa[24],
	typ,
	Float:ex,
	Float:ey,
	Float:ez,
	eint,
	Float:ex2,
	Float:ey2,
	Float:ez2,
	eint2,
	konto,
	produkty,
	zamkniety,
	idown,
	pickupid3,
	cena,
	index_t,
}

new biz[max_biz][guuu];

new sq[64];
new mq[128];
new bq[256];
new txt[128];

new carname[212][32] =

{

	{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},{"Dumper"},{"Firetruck"},{"Trashmaster"},{"Stretch"},

	{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},{"Washington"},

	{"Bobcat"},{"Mr Whoopee"},{"BF Injection"},{"Hunter"},{"Premier"},{"Enforcer"},{"Securicar"},{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},

	{"Hotknife"},{"Trailer 1"},{"Previon"},{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},{"Admiral"},

	{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Trailer 2"},{"Turismo"},{"Speeder"},{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},

	{"Solair"},{"Berkley's RC Van"},{"Skimmer"},{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},{"Sanchez"},

	{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},{"Rustler"},{"ZR-350"},{"Walton"},{"Regina"},{"Comet"},{"BMX"},

	{"Burrito"},{"Camper"},{"Marquis"},{"Baggage"},{"Dozer"},{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},

	{"Jetmax"},{"Hotring"},{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},{"Mesa"},{"RC Goblin"},{"Hotring Racer A"},

	{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},{"Super GT"},{"Elegant"},{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},

	{"Stunt"},{"Tanker"},{"Roadtrain"},{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},{"NRG-500"},{"HPV1000"},{"Cement Truck"},

	{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},{"Willard"},{"Forklift"},{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},

	{"Blade"},{"Freight"},{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},{"Firetruck LA"},{"Hustler"},{"Intruder"},{"Primo"},

	{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},{"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},{"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},

	{"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},{"Bandito"},{"Freight Flat"},{"Streak Carriage"},

	{"Kart"},{"Mower"},{"Duneride"},{"Sweeper"},{"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},

	{"Tug"},{"Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},{"Freight Carriage"},{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},

	{"Launch"},{"Police Car (LSPD)"},{"Police Car (SFPD)"},{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},{"Alpha"},{"Phoenix"},

	{"Glendale"},{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},{"Boxville"},{"Farm Plow"},{"Utility Trailer"}

};

main()
{
	print("[system] --------- URUCHAMIANIE GAMEMODE ---------");
    ShowPlayerMarkers(0);
	EnableStuntBonusForAll(0); 
    DisableInteriorEnterExits();
    AllowInteriorWeapons(1);
	AllowAdminTeleport(1);
	UsePlayerPedAnims();
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
//mysql_connect("sdc2.netshoot.pl", "baza_19496", "baza_19496", "sfyvqfidaj");
	mysql_connect("localhost", "thorus", "psrpg", "thorus");
	//mysql_connect("localhost", "sql7", "sql7", "uxvZTVbn3PtDJihg3W6c");
	if(mysql_ping() == 1)
	{
	    print("[system] Polaczono!");
	}
	else
	{
	    print("[system] Brak polaczenia!");
	}
	SendRconCommand("mapname FortCarson[PL][RPG]");
	SendRconCommand("gamemodetext PS-RPG[PL][RPG]");
	gstatus = 1;
	thorus_loadVeh();
	thorus_loadOrg();
	thorus_loadBuilding();
	thorus_loadBusiness();
	mysql_debug();
	CreateDynamicObject(869,-226.2000000,1004.8000000,19.6000000,0.0000000,0.0000000,2.0000000); //object(veg_pflowerswee) (1)
	CreateDynamicObject(869,-226.7000000,1004.9000000,19.6000000,0.0000000,0.0000000,2.0000000); //object(veg_pflowerswee) (2)
	CreateDynamicObject(869,-227.7000000,1006.1000000,19.6000000,0.0000000,0.0000000,2.0000000); //object(veg_pflowerswee) (3)
	CreateDynamicObject(869,-227.7000000,1003.8000000,19.6000000,0.0000000,0.0000000,2.0000000); //object(veg_pflowerswee) (4)
	CreateDynamicObject(869,-225.1000100,1003.6000000,19.6000000,0.0000000,0.0000000,2.0000000); //object(veg_pflowerswee) (5)
	CreateDynamicObject(869,-225.3000000,1006.0000000,19.6000000,0.0000000,0.0000000,2.0000000); //object(veg_pflowerswee) (6)
	CreateDynamicObject(869,-211.8999900,1006.1000000,19.7000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (7)
	CreateDynamicObject(869,-210.5000000,1006.0000000,19.7000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (8)
	CreateDynamicObject(869,-208.8000000,1006.2000000,19.7000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (9)
	CreateDynamicObject(869,-207.8999900,1005.8000000,19.7000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (10)
	CreateDynamicObject(869,-207.6000100,1003.9000000,19.7000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (11)
	CreateDynamicObject(869,-208.8000000,1003.7000000,19.7000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (12)
	CreateDynamicObject(869,-211.6000100,1004.0000000,19.7000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (13)
	CreateDynamicObject(869,-211.8000000,1003.6000000,19.7000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (14)
	CreateDynamicObject(4048,-215.3000000,1060.3000000,30.7000000,0.0000000,0.0000000,90.0000000); //object(lacityhall4_lan) (1)
	CreateDynamicObject(4176,-168.7000000,1039.4000000,24.2000000,0.0000000,0.0000000,270.0000000); //object(bailbonds2_lan) (1)
	CreateDynamicObject(4594,-169.3000000,983.7999900,17.7000000,0.0000000,0.0000000,180.0000000); //object(lan2buildblk02) (1)
	CreateDynamicObject(5017,-141.2000000,1078.4000000,22.3000000,0.0000000,0.0000000,90.0000000); //object(lastripx1_las) (1)
	CreateDynamicObject(1337,-173.6064500,1082.1143000,19.2421900,0.0000000,0.0000000,0.0000000); //object(binnt07_la) (2)
	CreateDynamicObject(5189,-168.8000000,1072.9000000,24.3000000,0.0000000,0.0000000,0.0000000); //object(ctddwwnblk_las2) (1)
	CreateDynamicObject(16480,-173.1000100,963.2999900,19.2000000,0.0000000,0.0000000,281.9960000); //object(ftcarson_sign) (1)
	CreateDynamicObject(4857,-98.5000000,1081.7000000,21.1000000,0.0000000,0.0000000,90.0000000); //object(snpedmtsp1_las) (1)
	CreateDynamicObject(4021,-212.8999900,1141.2000000,25.2000000,0.0000000,0.0000000,90.0000000); //object(officessml1_lan) (1)
	CreateDynamicObject(8131,-296.8999900,1079.8000000,29.4000000,0.0000000,0.0000000,0.0000000); //object(vgschurch02_lvs) (1)
	CreateDynamicObject(10631,-214.5000000,1118.2000000,23.4000000,0.0000000,0.0000000,270.0000000); //object(ammunation_sfs) (1)
	CreateDynamicObject(17543,-191.3999900,1215.4000000,21.2000000,0.0000000,0.0000000,90.0000000); //object(gangshops5_lae2) (1)
	CreateDynamicObject(17536,-171.5000000,1122.3000000,30.7000000,0.0000000,0.0000000,0.0000000); //object(dambuild1_lae2) (1)
	CreateDynamicObject(17521,-143.5000000,1159.6000000,22.2000000,0.0000000,0.0000000,180.0000000); //object(pawnshp_lae2) (1)
	CreateDynamicObject(16361,-174.5000000,1173.3000000,18.7000000,0.0000000,0.0000000,270.0000000); //object(desn2_tsblock) (1)
	CreateDynamicObject(16065,-222.5000000,1222.6000000,22.2000000,0.0000000,0.0000000,270.0000000); //object(des_stwnshop01) (1)
	CreateDynamicObject(18241,-231.3000000,1181.8000000,18.7000000,0.0000000,0.0000000,180.0000000); //object(cuntw_weebuild) (1)
	CreateDynamicObject(18240,-210.3999900,1165.2000000,18.7000000,0.0000000,0.0000000,90.0000000); //object(cuntw_liquor01) (1)
	CreateDynamicObject(17699,-148.6000100,1037.8000000,23.5000000,0.0000000,0.0000000,90.0000000); //object(mcstraps_lae2) (1)
	CreateDynamicObject(17697,-121.0996100,1038.7998000,23.5000000,0.0000000,0.0000000,90.0000000); //object(carlshou1_lae2) (1)
	CreateDynamicObject(17573,-102.6000000,1050.8000000,20.6000000,0.0000000,0.0000000,2.0000000); //object(rydhou01_lae2) (1)
	CreateDynamicObject(17551,-116.8000000,1122.9000000,29.1000000,0.0000000,0.0000000,270.0000000); //object(beachblok02_lae2) (1)
	CreateDynamicObject(13681,-92.0000000,1179.3000000,23.7000000,0.0000000,0.0000000,180.0000000); //object(tcehilhouse03) (1)
	CreateDynamicObject(9324,-85.1000000,1154.9000000,25.0000000,0.0000000,0.0000000,90.0000000); //object(preshoosbig02_sfn02) (1)
	CreateDynamicObject(9275,-103.9000000,1148.9000000,22.6000000,0.0000000,0.0000000,180.0000000); //object(preshoosml02_sfn01) (1)
	CreateDynamicObject(7932,-250.8999900,1056.0000000,21.7000000,0.0000000,0.0000000,0.0000000); //object(vgsnotxrefhse02) (1)
	CreateDynamicObject(7929,-248.8000000,1078.5000000,25.4000000,0.0000000,0.0000000,270.0000000); //object(vgwsavehse2) (1)
	CreateDynamicObject(7533,-241.3999900,1036.3000000,21.6000000,0.0000000,0.0000000,314.0000000); //object(newaprtmntsvgn08) (1)
	CreateDynamicObject(3639,-124.2002000,965.4003900,23.6000000,0.0000000,0.0000000,0.0000000); //object(glenphouse01_lax) (1)
	CreateDynamicObject(3640,-86.2998000,998.2998000,23.2000000,0.0000000,0.0000000,0.0000000); //object(glenphouse02_lax) (1)
	CreateDynamicObject(3641,-110.0000000,1012.9004000,21.1000000,0.0000000,0.0000000,0.0000000); //object(glenphouse04_lax) (1)
	CreateDynamicObject(3486,-250.8000000,1171.4000000,25.7000000,0.0000000,0.0000000,179.9950000); //object(vegasxrexhse05) (1)
	CreateDynamicObject(3484,-248.8999900,1139.0000000,25.4000000,0.0000000,0.0000000,270.0000000); //object(vegasxrexhse03) (2)
	CreateDynamicObject(3446,-251.1000100,1115.2000000,22.2000000,0.0000000,0.0000000,270.0000000); //object(vegasxrexhse10) (1)
	CreateDynamicObject(3483,-302.2000100,1123.3000000,25.7000000,0.0000000,0.0000000,90.0000000); //object(vegasxrexhse09) (1)
	CreateDynamicObject(3445,-326.5000000,1124.1000000,21.8000000,0.0000000,0.0000000,180.0000000); //object(vegasxrexhse08) (1)
	CreateDynamicObject(3444,-298.6000100,1172.7000000,21.3000000,0.0000000,0.0000000,90.0000000); //object(shabbyhouse02_lvs) (1)
	CreateDynamicObject(3443,-332.6000100,1168.6000000,21.5000000,0.0000000,0.0000000,0.0000000); //object(vegasxrexhse2) (1)
	CreateDynamicObject(4022,-332.0000000,1077.5000000,21.8000000,0.0000000,0.0000000,90.0000000); //object(foodmart1_lan) (1)
	CreateDynamicObject(14819,-327.6000100,1079.2000000,19.9000000,0.0000000,0.0000000,90.0000000); //object(og_door) (1)
	CreateDynamicObject(621,-351.2999900,1091.3000000,18.7000000,0.0000000,0.0000000,0.0000000); //object(veg_palm02) (1)
	CreateDynamicObject(1419,-304.8999900,1073.5000000,19.3000000,0.0000000,0.0000000,0.0000000); //object(dyn_f_iron_1) (1)
	CreateDynamicObject(1419,-300.7999900,1073.5000000,19.3000000,0.0000000,0.0000000,0.0000000); //object(dyn_f_iron_1) (2)
	CreateDynamicObject(1419,-296.7000100,1073.5000000,19.3000000,0.0000000,0.0000000,0.0000000); //object(dyn_f_iron_1) (3)
	CreateDynamicObject(1419,-292.6000100,1073.5000000,19.3000000,0.0000000,0.0000000,0.0000000); //object(dyn_f_iron_1) (4)
	CreateDynamicObject(1419,-288.5000000,1073.5000000,19.3000000,0.0000000,0.0000000,0.0000000); //object(dyn_f_iron_1) (5)
	CreateDynamicObject(1419,-286.5000000,1075.5000000,19.3000000,0.0000000,0.0000000,90.0000000); //object(dyn_f_iron_1) (6)
	CreateDynamicObject(1419,-286.5000000,1079.5000000,19.3000000,0.0000000,0.0000000,90.0000000); //object(dyn_f_iron_1) (7)
	CreateDynamicObject(1419,-286.5000000,1083.5996000,19.3000000,0.0000000,0.0000000,90.0000000); //object(dyn_f_iron_1) (8)
	CreateDynamicObject(1419,-288.5000000,1085.7000000,19.3000000,0.0000000,0.0000000,180.0000000); //object(dyn_f_iron_1) (9)
	CreateDynamicObject(1419,-292.6000100,1085.7000000,19.3000000,0.0000000,0.0000000,179.9950000); //object(dyn_f_iron_1) (11)
	CreateDynamicObject(1419,-296.6000100,1085.7000000,19.3000000,0.0000000,0.0000000,179.9950000); //object(dyn_f_iron_1) (12)
	CreateDynamicObject(1419,-300.7000100,1085.7000000,19.3000000,0.0000000,0.0000000,179.9950000); //object(dyn_f_iron_1) (13)
	CreateDynamicObject(1419,-304.7999900,1085.6000000,19.3000000,0.0000000,0.0000000,179.9950000); //object(dyn_f_iron_1) (14)
	CreateDynamicObject(1419,-306.7999900,1083.6000000,19.3000000,0.0000000,0.0000000,270.0000000); //object(dyn_f_iron_1) (15)
	CreateDynamicObject(1419,-306.7999900,1079.5000000,19.3000000,0.0000000,0.0000000,270.0000000); //object(dyn_f_iron_1) (17)
	CreateDynamicObject(1419,-306.7999900,1075.5000000,19.3000000,0.0000000,0.0000000,270.0000000); //object(dyn_f_iron_1) (18)
	CreateDynamicObject(949,-285.7999900,1073.9000000,19.4000000,0.0000000,0.0000000,0.0000000); //object(plant_pot_4) (1)
	CreateDynamicObject(949,-285.7999900,1085.5000000,19.4000000,0.0000000,0.0000000,0.0000000); //object(plant_pot_4) (2)
	CreateDynamicObject(949,-307.1000100,1085.4000000,19.4000000,0.0000000,0.0000000,0.0000000); //object(plant_pot_4) (3)
	CreateDynamicObject(949,-307.2000100,1073.7000000,19.4000000,0.0000000,0.0000000,0.0000000); //object(plant_pot_4) (4)
	CreateDynamicObject(1280,-289.0000000,1088.0000000,19.1000000,0.0000000,0.0000000,270.0000000); //object(parkbench1) (1)
	CreateDynamicObject(1280,-295.7000100,1088.0000000,19.1000000,0.0000000,0.0000000,270.0000000); //object(parkbench1) (2)
	CreateDynamicObject(1280,-303.2999900,1088.0000000,19.1000000,0.0000000,0.0000000,270.0000000); //object(parkbench1) (3)
	CreateDynamicObject(1280,-285.8999900,1080.2000000,19.1000000,0.0000000,0.0000000,180.0000000); //object(parkbench1) (4)
	CreateDynamicObject(887,-287.9003900,1074.9004000,18.5000000,0.0000000,0.0000000,0.0000000); //object(elmtreegrn2_po) (1)
	CreateDynamicObject(1493,-149.8999900,1042.9000000,19.6000000,0.0000000,0.0000000,0.0000000); //object(gen_doorshop01) (1)
	CreateDynamicObject(2904,-116.6000000,1037.5000000,21.2000000,0.0000000,0.0000000,90.0000000); //object(warehouse_door1) (1)
	CreateDynamicObject(7940,10.0000000,1079.0000000,21.6000000,0.0000000,0.0000000,180.0000000); //object(vegirlfrhouse02) (1)
	CreateDynamicObject(887,-288.1000100,1084.0000000,18.7000000,0.0000000,0.0000000,0.0000000); //object(elmtreegrn2_po) (2)
	CreateDynamicObject(887,-305.5000000,1084.4000000,18.7000000,0.0000000,0.0000000,0.0000000); //object(elmtreegrn2_po) (3)
	CreateDynamicObject(887,-305.7999900,1075.6000000,18.7000000,0.0000000,0.0000000,0.0000000); //object(elmtreegrn2_po) (4)
	CreateDynamicObject(3639,-12.1000000,993.7999900,23.3000000,0.0000000,0.0000000,0.0000000); //object(glenphouse01_lax) (2)
	CreateDynamicObject(3641,6.9000000,943.4000200,21.0000000,0.0000000,0.0000000,0.0000000); //object(glenphouse04_lax) (2)
	CreateDynamicObject(3640,55.5000000,962.2999900,21.6000000,0.0000000,0.0000000,0.0000000); //object(glenphouse02_lax) (2)
	CreateDynamicObject(3641,-100.9000000,897.5000000,21.8000000,0.0000000,0.0000000,90.0000000); //object(glenphouse04_lax) (3)
	CreateDynamicObject(5520,-55.2000000,965.0000000,24.0000000,0.0000000,0.0000000,0.0000000); //object(bdupshouse_lae) (1)
	CreateDynamicObject(18239,-210.6000100,1181.8000000,18.7000000,0.0000000,0.0000000,180.0000000); //object(cuntw_restrnt1) (1)
	CreateDynamicObject(869,-193.0000000,1032.9000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (15)
	CreateDynamicObject(869,-193.0000000,1035.6000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (16)
	CreateDynamicObject(869,-193.0000000,1038.0000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (17)
	CreateDynamicObject(869,-193.0000000,1039.8000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (18)
	CreateDynamicObject(869,-193.0000000,1041.9000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (19)
	CreateDynamicObject(869,-193.0000000,1043.9000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (20)
	CreateDynamicObject(869,-193.0000000,1045.6000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (21)
	CreateDynamicObject(869,-193.0000000,1047.3000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (22)
	CreateDynamicObject(869,-192.8999900,1048.8000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (23)
	CreateDynamicObject(869,-192.8999900,1050.1000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (24)
	CreateDynamicObject(869,-192.8999900,1052.3000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (25)
	CreateDynamicObject(869,-192.8999900,1054.5000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (26)
	CreateDynamicObject(869,-192.8999900,1056.4000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (27)
	CreateDynamicObject(869,-192.8000000,1058.5000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (28)
	CreateDynamicObject(869,-192.8000000,1060.4000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (29)
	CreateDynamicObject(869,-192.8000000,1062.1000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (30)
	CreateDynamicObject(869,-192.8999900,1063.6000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (31)
	CreateDynamicObject(869,-192.8000000,1066.0000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (32)
	CreateDynamicObject(869,-192.8999900,1068.3000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (33)
	CreateDynamicObject(869,-192.8999900,1070.7000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (34)
	CreateDynamicObject(869,-193.0000000,1072.7000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (35)
	CreateDynamicObject(869,-193.1000100,1074.6000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (36)
	CreateDynamicObject(869,-193.0000000,1076.6000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (37)
	CreateDynamicObject(869,-192.8999900,1078.4000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (38)
	CreateDynamicObject(869,-192.8999900,1080.0000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (39)
	CreateDynamicObject(869,-193.1000100,1081.4000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (40)
	CreateDynamicObject(869,-193.0000000,1084.1000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (41)
	CreateDynamicObject(869,-193.1000100,1083.2000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (42)
	CreateDynamicObject(869,-192.8999900,1112.9000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (43)
	CreateDynamicObject(869,-192.8999900,1115.3000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (44)
	CreateDynamicObject(869,-193.0000000,1117.1000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (45)
	CreateDynamicObject(869,-192.8999900,1119.0000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (46)
	CreateDynamicObject(869,-192.8000000,1120.8000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (47)
	CreateDynamicObject(869,-192.8999900,1122.4000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (48)
	CreateDynamicObject(869,-192.8000000,1123.7000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (49)
	CreateDynamicObject(869,-192.8999900,1125.2000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (50)
	CreateDynamicObject(869,-192.8999900,1127.1000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (51)
	CreateDynamicObject(869,-192.8000000,1128.4000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (52)
	CreateDynamicObject(869,-192.8000000,1129.9000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (53)
	CreateDynamicObject(869,-192.8000000,1132.3000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (54)
	CreateDynamicObject(869,-192.8000000,1134.8000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (55)
	CreateDynamicObject(869,-192.8000000,1136.6000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (56)
	CreateDynamicObject(869,-192.8000000,1138.8000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (57)
	CreateDynamicObject(869,-192.7000000,1140.6000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (58)
	CreateDynamicObject(869,-192.7000000,1142.4000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (59)
	CreateDynamicObject(869,-192.7000000,1144.1000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (60)
	CreateDynamicObject(869,-192.8000000,1145.7000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (61)
	CreateDynamicObject(869,-192.8000000,1147.2000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (62)
	CreateDynamicObject(869,-192.8000000,1148.7000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (63)
	CreateDynamicObject(869,-192.8000000,1149.8000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (64)
	CreateDynamicObject(869,-192.8000000,1152.1000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (65)
	CreateDynamicObject(869,-192.8000000,1154.1000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (66)
	CreateDynamicObject(869,-192.8000000,1155.7000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (67)
	CreateDynamicObject(869,-192.8000000,1157.3000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (68)
	CreateDynamicObject(869,-192.8000000,1158.9000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (69)
	CreateDynamicObject(869,-192.7000000,1160.8000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (70)
	CreateDynamicObject(869,-192.8000000,1162.1000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (71)
	CreateDynamicObject(869,-192.8999900,1163.7000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (72)
	CreateDynamicObject(869,-192.8999900,1165.3000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (73)
	CreateDynamicObject(869,-193.0000000,1167.2000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (74)
	CreateDynamicObject(869,-193.0000000,1168.5000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (75)
	CreateDynamicObject(869,-193.0000000,1170.3000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (76)
	CreateDynamicObject(869,-192.8999900,1172.0000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (77)
	CreateDynamicObject(869,-193.0000000,1173.6000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (78)
	CreateDynamicObject(869,-193.0000000,1175.2000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (79)
	CreateDynamicObject(869,-193.0000000,1176.8000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (80)
	CreateDynamicObject(869,-193.0000000,1178.4000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (81)
	CreateDynamicObject(869,-193.0000000,1180.0000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (82)
	CreateDynamicObject(869,-193.1000100,1181.3000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (83)
	CreateDynamicObject(869,-192.8999900,1183.1000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (84)
	CreateDynamicObject(869,-193.0000000,1184.5000000,19.2000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee) (85)
	CreateDynamicObject(789,-340.3999900,1206.4000000,32.3000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (1)
	CreateDynamicObject(649,12.2000000,971.5999800,18.8000000,0.0000000,0.0000000,0.0000000); //object(sjmpalm) (1)
	CreateDynamicObject(649,-0.4000000,957.5000000,18.6000000,0.0000000,0.0000000,0.0000000); //object(sjmpalm) (2)
	CreateDynamicObject(649,67.4000000,975.2999900,14.6000000,0.0000000,0.0000000,0.0000000); //object(sjmpalm) (3)
	CreateDynamicObject(649,29.7000000,1021.3000000,16.3000000,0.0000000,0.0000000,0.0000000); //object(sjmpalm) (4)
	CreateDynamicObject(649,-26.0000000,966.9000200,18.7000000,0.0000000,0.0000000,0.0000000); //object(sjmpalm) (5)
	CreateDynamicObject(649,-84.9000000,913.5999800,20.3000000,0.0000000,0.0000000,0.0000000); //object(sjmpalm) (6)
	CreateDynamicObject(649,-146.0000000,970.5000000,17.8000000,0.0000000,0.0000000,0.0000000); //object(sjmpalm) (7)
	CreateDynamicObject(649,-101.5000000,1039.3000000,18.7000000,0.0000000,0.0000000,0.0000000); //object(sjmpalm) (8)
	CreateDynamicObject(649,-96.6000000,1011.0000000,18.7000000,0.0000000,0.0000000,0.0000000); //object(sjmpalm) (9)
	CreateDynamicObject(649,-153.8999900,938.0999800,18.3000000,0.0000000,0.0000000,0.0000000); //object(sjmpalm) (10)
	CreateDynamicObject(2923,-184.8999900,1069.8000000,18.7000000,0.0000000,0.0000000,180.0000000); //object(bottle_bank) (1)
	CreateDynamicObject(9824,43.3000000,1218.4000000,21.0000000,0.0000000,0.0000000,0.0000000); //object(diner_sfw) (1)
	CreateDynamicObject(1566,42.4000000,1210.1000000,19.9000000,0.0000000,0.0000000,0.0000000); //object(cj_ws_door) (1)
	CreateDynamicObject(1556,-149.5000000,1082.4000000,19.1000000,0.0000000,0.0000000,0.0000000); //object(gen_doorext18) (1)
	return 1;
}

public OnGameModeExit()
{
    printf("[system] ----------- ZAMYKANIE GAMEMODE -----------");
    KillTimer(timer_wh);
	print("[system] zaczynam zapisywac systemy..");
	new zapis=1;
	while(biz[zapis][bizid] != 0)
	{
 		thorus_saveBusiness(zapis);
   	    zapis++;
	}
	printf("[system] zapisano %d biznesow", zapis-1);
	zapis=1;
	while(v[zapis][vid] != 0)
	{
	    thorus_saveVeh(zapis);
	    zapis++;
	}
	printf("[system] zapisano %d pojazdow", zapis-1);
	zapis=1;
	while(bud[zapis][bid] != 0)
	{
	    thorus_saveBuilding(zapis);
	    zapis++;
	}
	printf("[system] zapisano %d budynkow", zapis-1);
	print("[system] koniec zapisu systemow.");
	mysql_close();
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	for(new i; i < max_biz; i++)
	{
		if(bud[i][bid] != 0)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.0, bud[i][ex], bud[i][ey], bud[i][ez]))
			{
				format(txt, sizeof txt, "~y~%s", bud[i][nazwa]);
				GameTextForPlayer(playerid, txt, 3000, 3);

				break;
			}
		}
		if(biz[i][bizid] != 0)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.0, biz[i][ex], biz[i][ey], biz[i][ez]))
			{
				new typ33[24];
				switch(biz[i][typ])
				{
					case 1: typ33 = "24/7";
					case 2: typ33 = "Ammunation";
					case 3: typ33 = "Restauracja";
					case 4: typ33 = "Bar/Club";
					case 5: typ33 = "Sklep z ubraniami";
					case 6: typ33 = "Sex Shop";
					case 7: typ33 = "Ogloszenia";
					default: typ33 = "Brak";
				}
				if(biz[i][idown] != 0)
				{
					new nick_gracza[24];
					format(sq, sizeof sq, "select `login` from `players` where `id`='%d'", biz[i][idown]);
					mysql_query(sq);
					mysql_store_result();
					mysql_fetch_row_format(sq, "|");
					sscanf(sq, "p<|>s[24]", nick_gracza);
					mysql_free_result();
					format(txt, sizeof txt, "~y~Nazwa: %s~n~Typ: %s~n~Wlasciciel: %s", biz[i][nazwa], typ33, nick_gracza);
					GameTextForPlayer(playerid, txt, 3000, 3);
				}
				else if(biz[i][idown] == 0)
				{
					format(txt, sizeof txt, "~g~Biznes na sprzedaz!~y~~n~Wpisz /kupbiznes~n~Nazwa: %s~g~~n~Cena: %d$~y~~n~Typ: %s",biz[i][nazwa],biz[i][cena], typ33);
					GameTextForPlayer(playerid,txt, 3000, 3);
				}

				break;
			}
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    PlayerPlaySound(playerid,1187,0.0,0.0,0.0);
	InterpolateCameraPos(playerid,-189.5944, 1001.4731, 20.8584,-188.3908, 1174.6870, 20.3283, 30000);
	p[playerid][zalogowany] = 0;
	p[playerid][plog] = 1;
	vehicleuid[playerid] = 0;
	format(sq, sizeof sq, "select `id` from `players` where `login`='%s'", PlayerName(playerid));
	mysql_query(sq);
	mysql_store_result();
	if(mysql_num_rows())
	{
	    ShowPlayerDialog(playerid, logowanie, DIALOG_STYLE_PASSWORD, "Logowanie", "Witaj!\nJesteœ ju¿ cz³onkiem naszej spo³ecznoœci.\nPodaj has³o do konta.", "Zaloguj", "Anuluj");
	}
	else
	{
	    ShowPlayerDialog(playerid, rejestracja, DIALOG_STYLE_PASSWORD, "Rejestracja", "Witaj!\nZarejestruj siê, aby móc graæ na naszym serwerze.\nRejestruj¹c konto zgadzasz siê na przestrzeganie regulaminu dostêpnego na naszym forum.", "Zarejestruj", "Anuluj");
        //ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Informacja", "Rejestracja wy³¹czona.\nJeœli chcesz do³¹czyæ do testów mapy wejdŸ na nasze forum.\nNapisz do administratora Thorus i oczekuj na dane do konta.", "OK", "Ok");
	}
	mysql_free_result();
	CreateDynamicMapIcon(662.0267,1716.1154,7.1875, 27, 0); //mechanik
	CreateDynamicMapIcon(-320.4509,1048.8623,20.3403, 22, 0); //szpital
	CreateDynamicMapIcon(-216.7513,979.3900,19.4985, 30, 0); //policja
	CreateDynamic3DTextLabel("Wpisz /ulecz aby odzyskaæ punkty zdrowia.\nKoszt: 250$", pomaranczowy, -320.4509,1048.8623,20.3403, 17.0);
    SetPlayerColor(playerid, 0xFFFFFF);
    RemoveBuildingForPlayer(playerid, 16412, -215.2344, 1119.1953, 18.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 16413, -174.2109, 1120.4531, 24.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 16433, -177.4375, 1056.3906, 22.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 16435, -209.6641, 1066.5234, 22.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 16443, -161.1719, 1179.5313, 22.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 16447, -219.3750, 1176.6563, 22.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 3344, -235.8594, 1051.3047, 18.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3360, -362.0625, 1198.6563, 18.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 3365, -95.3125, 1121.3047, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 3371, -298.0547, 1120.8594, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3371, -253.0547, 1150.8828, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3373, -253.0547, 1175.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3373, -323.0547, 1125.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3373, -253.0547, 1050.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 16617, -122.7422, 1122.7500, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 16618, -117.7656, 1079.4609, 22.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3372, -331.3906, 1170.8594, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3372, -253.0625, 1125.8750, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3372, -253.0391, 1075.8906, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3372, -298.0234, 1170.8672, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 769, -229.2266, 908.2578, 10.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 769, -383.8594, 964.4922, 9.1328, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -394.4609, 978.4844, 8.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -271.2813, 980.9609, 18.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -294.9688, 1000.9141, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 769, -287.8281, 976.1328, 17.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -244.8281, 976.8359, 19.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -313.7422, 1010.2500, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -321.7031, 1005.2734, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -301.8203, 1001.6563, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -342.6797, 1024.2891, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -264.2891, 1029.3047, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -230.8594, 957.8672, 15.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -238.2578, 981.3438, 18.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 780, -209.1641, 1005.5625, 18.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -234.9531, 1007.6250, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -238.0625, 1030.9063, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 16738, -217.4922, 1026.8203, 27.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -204.4141, 971.7109, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -206.5000, 1000.9063, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 774, -178.8516, 949.6172, 15.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -169.9766, 1027.1953, 19.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -170.4609, 1029.3672, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -353.6875, 1049.7656, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -286.1406, 1053.2344, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -258.8281, 1036.1250, 18.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3171, -235.8594, 1051.3047, 18.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -228.8281, 1050.7500, 18.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -240.0625, 1050.6328, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 3303, -253.0547, 1050.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -220.4375, 1056.5547, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 16061, -193.3750, 1055.2891, 18.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 16007, -177.4375, 1056.3906, 22.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1522, -180.3125, 1035.5859, 18.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -176.6094, 1052.0625, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -351.9688, 1062.1719, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 774, -372.7422, 1066.2813, 17.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -233.1172, 1061.6563, 18.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 16005, -209.6641, 1066.5234, 22.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 1500, -206.5703, 1061.4375, 18.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -332.4063, 1072.2422, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -239.3359, 1070.2813, 18.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -179.8984, 1069.4297, 19.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -289.0625, 1074.9766, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 3304, -253.0391, 1075.8906, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -342.0781, 1078.4609, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -169.3594, 1077.4766, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -264.8125, 1078.2734, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -227.4844, 1077.2891, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 16737, -94.6172, 923.2891, 26.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -161.0156, 1011.1953, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -165.5625, 1000.7656, 18.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -154.1953, 1012.9453, 18.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -161.0156, 1021.7500, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -161.0156, 1016.4766, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -161.0156, 1027.0234, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -127.8750, 1058.6641, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -161.0156, 1032.3047, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 780, -147.2500, 1055.5156, 18.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -120.4766, 1061.2109, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -160.5156, 1066.0703, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -139.3984, 1067.3516, 19.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -164.3750, 1078.3906, 17.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -334.4531, 1085.9922, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -291.2578, 1085.0938, 17.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 780, -325.9609, 1109.5625, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -265.2266, 1112.9609, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -228.3828, 1111.8750, 18.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 774, -245.7500, 1111.2813, 17.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 16434, -180.7109, 1081.0781, 27.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 1411, -146.9297, 1108.2344, 20.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -166.7500, 1107.9688, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 3305, -298.0547, 1120.8594, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3303, -323.0547, 1125.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3304, -253.0625, 1125.8750, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 16006, -215.2344, 1119.1953, 18.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -225.3125, 1127.2109, 18.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 16070, -174.2109, 1120.4531, 24.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -160.2656, 1122.5391, 19.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 1692, -161.7656, 1115.8516, 27.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 16760, -178.2031, 1122.3203, 28.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -286.1250, 1137.8750, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -332.1953, 1137.8125, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1447, -154.8281, 1137.1406, 20.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1447, -160.0703, 1137.1406, 20.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -162.1953, 1136.2266, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -232.8125, 1139.4063, 18.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 16740, -152.3203, 1144.0703, 30.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -364.8438, 1149.0234, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 16739, -297.1016, 1152.9688, 27.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -309.8359, 1158.8359, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -239.8594, 1148.9609, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 3305, -253.0547, 1150.8828, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -264.3516, 1162.6328, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -229.4375, 1156.6250, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 16060, -192.0469, 1147.3906, 17.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -161.9297, 1162.0781, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -170.1719, 1169.0547, 19.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -218.0313, 1164.9219, 19.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -149.8203, 1164.1094, 19.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 3304, -298.0234, 1170.8672, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3303, -331.3906, 1170.8594, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3303, -253.0547, 1175.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -162.0938, 1175.1406, 19.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 769, -232.3594, 1174.4766, 18.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 16064, -161.1719, 1179.5313, 22.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 16065, -219.3750, 1176.6563, 22.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 1692, -174.2422, 1177.8984, 22.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3286, -230.2031, 1185.7734, 23.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -159.8594, 1187.8281, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -250.6172, 1187.9453, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 16500, -360.7656, 1194.2578, 20.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 3359, -362.0625, 1198.6563, 18.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -162.7266, 1209.3359, 18.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -154.4844, 1209.6328, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -225.7344, 1208.8125, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 16066, -186.4844, 1217.6250, 20.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -191.5781, 1210.2422, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 16386, -117.7656, 1079.4609, 22.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -123.8125, 1079.3984, 19.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -111.7422, 1087.5000, 19.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 1411, -136.5391, 1108.2344, 20.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 1411, -141.7344, 1108.2344, 20.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 3294, -100.0000, 1111.4141, 21.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, -133.9844, 1111.0781, 20.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -120.8750, 1110.4219, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 3292, -95.3125, 1121.3047, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 3293, -100.0000, 1118.6250, 21.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 16385, -122.7422, 1122.7500, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -90.6016, 1128.2188, 19.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, -133.8516, 1134.4141, 20.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -133.3594, 1137.5938, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -106.6719, 1140.0234, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 780, -84.8906, 1143.4375, 18.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -81.0859, 1149.6406, 18.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -50.5078, 1160.9141, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -126.1719, 1159.0703, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -127.0000, 1173.4219, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -132.0703, 1187.4609, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -128.2734, 1232.8438, 18.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -127.2656, 1222.5156, 18.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -97.5938, 1241.0781, 16.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 16412, -215.2344, 1119.1953, 18.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 16413, -174.2109, 1120.4531, 24.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 16433, -177.4375, 1056.3906, 22.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 16435, -209.6641, 1066.5234, 22.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 16443, -161.1719, 1179.5313, 22.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3298, 23.3750, 964.8984, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3298, -120.8672, 919.7578, 19.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3301, -155.1484, 884.4531, 19.1328, 0.25);
	RemoveBuildingForPlayer(playerid, 3300, 61.9141, 1000.5313, 14.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 3300, 26.2188, 925.9063, 24.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3300, -62.3047, 968.3984, 20.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 3300, -82.1719, 912.4219, 21.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3301, -95.3438, 967.4375, 20.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 3299, 64.2813, 976.8047, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3299, -15.5547, 968.7344, 18.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3299, -89.1250, 936.0000, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3297, 20.5391, 906.3594, 24.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 3297, -1.9453, 947.9219, 20.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3297, -130.3750, 972.1172, 20.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 3339, -152.8828, 909.1875, 17.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 3339, -123.2734, 872.6953, 17.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3339, -56.6250, 933.1563, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3339, 20.5000, 946.7266, 18.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3341, -90.2734, 885.8203, 19.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 3341, -52.9609, 892.0547, 20.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3341, -121.1641, 855.4063, 17.1328, 0.25);
	RemoveBuildingForPlayer(playerid, 3342, -15.2266, 936.3906, 19.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 3342, -39.7813, 962.6172, 18.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 3342, -54.8203, 916.6172, 20.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3342, -151.0781, 936.0859, 18.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16447, -219.3750, 1176.6563, 22.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 3344, -235.8594, 1051.3047, 18.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 16476, -98.1953, 1180.0703, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 16482, 171.3516, 1220.0469, 23.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3360, -362.0625, 1198.6563, 18.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 3365, -95.3125, 1121.3047, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 3371, -298.0547, 1120.8594, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3371, -253.0547, 1150.8828, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3373, -253.0547, 1175.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3373, -323.0547, 1125.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3373, -253.0547, 1050.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 16617, -122.7422, 1122.7500, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 16618, -117.7656, 1079.4609, 22.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3372, -331.3906, 1170.8594, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3372, -253.0625, 1125.8750, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3372, -253.0391, 1075.8906, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3372, -298.0234, 1170.8672, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 769, -229.2266, 908.2578, 10.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 769, -383.8594, 964.4922, 9.1328, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -394.4609, 978.4844, 8.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -271.2813, 980.9609, 18.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -294.9688, 1000.9141, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 769, -287.8281, 976.1328, 17.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -244.8281, 976.8359, 19.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -313.7422, 1010.2500, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -321.7031, 1005.2734, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -301.8203, 1001.6563, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -342.6797, 1024.2891, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -264.2891, 1029.3047, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -230.8594, 957.8672, 15.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -238.2578, 981.3438, 18.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 780, -209.1641, 1005.5625, 18.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -234.9531, 1007.6250, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -238.0625, 1030.9063, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 16738, -217.4922, 1026.8203, 27.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -204.4141, 971.7109, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -206.5000, 1000.9063, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 774, -178.8516, 949.6172, 15.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -169.9766, 1027.1953, 19.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -170.3750, 977.8984, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -170.4609, 1029.3672, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -353.6875, 1049.7656, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -286.1406, 1053.2344, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -258.8281, 1036.1250, 18.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3171, -235.8594, 1051.3047, 18.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -228.8281, 1050.7500, 18.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -240.0625, 1050.6328, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 3303, -253.0547, 1050.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -220.4375, 1056.5547, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 16061, -193.3750, 1055.2891, 18.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 16007, -177.4375, 1056.3906, 22.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1522, -180.3125, 1035.5859, 18.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -176.6094, 1052.0625, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -351.9688, 1062.1719, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 774, -372.7422, 1066.2813, 17.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -233.1172, 1061.6563, 18.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 16005, -209.6641, 1066.5234, 22.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 1500, -206.5703, 1061.4375, 18.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -332.4063, 1072.2422, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -239.3359, 1070.2813, 18.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -179.8984, 1069.4297, 19.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -289.0625, 1074.9766, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 3304, -253.0391, 1075.8906, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -342.0781, 1078.4609, 18.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -169.3594, 1077.4766, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -264.8125, 1078.2734, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -227.4844, 1077.2891, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -143.3828, 859.4141, 17.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3170, -121.1641, 855.4063, 17.1328, 0.25);
	RemoveBuildingForPlayer(playerid, 769, -102.8125, 861.6875, 17.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 3169, -123.2734, 872.6953, 17.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3284, -155.1484, 884.4531, 19.1328, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -143.8125, 880.7969, 17.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 3169, -152.8828, 909.1875, 17.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -122.6484, 889.3047, 18.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -109.0547, 903.1641, 19.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -133.3594, 902.4141, 18.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3241, -120.8672, 919.7578, 19.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -110.2813, 925.6797, 19.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -143.7500, 917.4844, 18.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3170, -90.2734, 885.8203, 19.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 3252, -99.9844, 919.2656, 19.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -85.1328, 902.1016, 20.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 16737, -94.6172, 923.2891, 26.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 3285, -82.1719, 912.4219, 21.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -75.2969, 924.3906, 19.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -76.3438, 891.0156, 20.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -63.0781, 925.6563, 18.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 3173, -151.0781, 936.0859, 18.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -135.3047, 934.3594, 18.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3283, -89.1250, 936.0000, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -92.2500, 946.9609, 18.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -66.7109, 946.1016, 18.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -77.9922, 957.8750, 19.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -114.1953, 956.3359, 20.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -136.9063, 955.5078, 18.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -158.8672, 955.9141, 16.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3284, -95.3438, 967.4375, 20.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 3242, -130.3750, 972.1172, 20.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -103.9766, 977.0625, 20.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -103.9766, 971.7891, 20.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -161.0156, 1011.1953, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -165.5625, 1000.7656, 18.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -154.1953, 1012.9453, 18.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -161.0156, 1021.7500, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -161.0156, 1016.4766, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -161.0156, 1027.0234, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -93.0313, 987.8828, 18.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -114.5000, 980.4063, 19.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -101.2656, 979.6563, 20.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -95.8906, 979.6563, 19.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -70.5313, 987.7500, 18.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -64.0313, 1009.6719, 18.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 774, -82.9688, 1022.7813, 18.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -127.8750, 1058.6641, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -161.0156, 1032.3047, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 780, -147.2500, 1055.5156, 18.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -120.4766, 1061.2109, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -82.2969, 1060.2734, 18.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 769, -96.9453, 1054.9297, 18.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -160.5156, 1066.0703, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -139.3984, 1067.3516, 19.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -164.3750, 1078.3906, 17.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 3173, -54.8203, 916.6172, 20.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3170, -52.9609, 892.0547, 20.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -48.8516, 906.8594, 20.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -62.1484, 905.4609, 21.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -59.7969, 884.5078, 19.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -0.4141, 917.2422, 21.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 774, -22.7891, 904.9141, 22.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 3169, -56.6250, 933.1563, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3173, -15.2266, 936.3906, 19.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 3252, -2.1016, 936.1875, 20.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -36.6563, 940.9609, 18.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3242, -1.9453, 947.9219, 20.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -42.8672, 946.6641, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -20.8203, 947.1797, 18.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 3285, -62.3047, 968.3984, 20.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 3173, -39.7813, 962.6172, 18.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 3283, -15.5547, 968.7344, 18.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -20.8281, 953.9844, 14.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -8.0547, 987.6250, 18.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -27.0781, 987.4844, 18.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -48.6328, 987.5234, 18.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 691, -51.3516, 1006.5781, 18.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -39.0938, 999.8672, 19.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -19.9297, 1006.3672, 18.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -1.4609, 998.1094, 18.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -5.0156, 1017.7266, 18.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -51.6875, 1042.5938, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -51.1484, 1052.1094, 18.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -51.1406, 1064.8125, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 3242, 20.5391, 906.3594, 24.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 3285, 26.2188, 925.9063, 24.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3169, 20.5000, 946.7266, 18.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 32.3984, 948.8281, 19.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 31.9922, 929.8906, 22.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 3241, 23.3750, 964.8984, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 30.3594, 967.9063, 18.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 16736, 11.0156, 959.8828, 24.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 30.8984, 987.3984, 18.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 11.6250, 987.4453, 18.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 1.2578, 1027.0938, 18.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 11.8594, 1009.8125, 17.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 780, 26.6094, 1030.3281, 16.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 27.4297, 1056.7656, 18.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 773, 4.9453, 1052.8906, 14.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 42.2422, 958.3516, 18.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 53.9766, 947.2656, 18.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 44.5469, 1003.7813, 15.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 769, 53.2188, 1039.1484, 13.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 3283, 64.2813, 976.8047, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 780, 60.4844, 966.2266, 15.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 3285, 61.9141, 1000.5313, 14.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 74.5938, 947.0703, 17.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -334.4531, 1085.9922, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -291.2578, 1085.0938, 17.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 780, -325.9609, 1109.5625, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -265.2266, 1112.9609, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -228.3828, 1111.8750, 18.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 774, -245.7500, 1111.2813, 17.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 16434, -180.7109, 1081.0781, 27.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 1411, -146.9297, 1108.2344, 20.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -166.7500, 1107.9688, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 3305, -298.0547, 1120.8594, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3303, -323.0547, 1125.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3304, -253.0625, 1125.8750, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 16006, -215.2344, 1119.1953, 18.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -225.3125, 1127.2109, 18.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 16070, -174.2109, 1120.4531, 24.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -160.2656, 1122.5391, 19.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 1692, -161.7656, 1115.8516, 27.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 16760, -178.2031, 1122.3203, 28.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -286.1250, 1137.8750, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -332.1953, 1137.8125, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1447, -154.8281, 1137.1406, 20.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1447, -160.0703, 1137.1406, 20.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -149.8516, 1133.7656, 19.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -162.1953, 1136.2266, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -232.8125, 1139.4063, 18.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 16740, -152.3203, 1144.0703, 30.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -364.8438, 1149.0234, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 16739, -297.1016, 1152.9688, 27.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -309.8359, 1158.8359, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -239.8594, 1148.9609, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 3305, -253.0547, 1150.8828, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -264.3516, 1162.6328, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -229.4375, 1156.6250, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 16060, -192.0469, 1147.3906, 17.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -161.9297, 1162.0781, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -170.1719, 1169.0547, 19.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -218.0313, 1164.9219, 19.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -149.8203, 1164.1094, 19.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 3304, -298.0234, 1170.8672, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3303, -331.3906, 1170.8594, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 3303, -253.0547, 1175.8828, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -162.0938, 1175.1406, 19.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 769, -232.3594, 1174.4766, 18.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 16064, -161.1719, 1179.5313, 22.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 16065, -219.3750, 1176.6563, 22.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 1692, -174.2422, 1177.8984, 22.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3286, -230.2031, 1185.7734, 23.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -159.8594, 1187.8281, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -250.6172, 1187.9453, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 16500, -360.7656, 1194.2578, 20.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 3359, -362.0625, 1198.6563, 18.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -162.7266, 1209.3359, 18.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -154.4844, 1209.6328, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -225.7344, 1208.8125, 17.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 16066, -186.4844, 1217.6250, 20.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -191.5781, 1210.2422, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 16386, -117.7656, 1079.4609, 22.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -123.8125, 1079.3984, 19.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -111.7422, 1087.5000, 19.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -86.8438, 1088.4141, 19.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 1411, -136.5391, 1108.2344, 20.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 1447, -83.4766, 1108.3750, 20.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1447, -78.2344, 1108.3750, 20.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1411, -141.7344, 1108.2344, 20.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 3294, -100.0000, 1111.4141, 21.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, -133.9844, 1111.0781, 20.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -120.8750, 1110.4219, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -75.9453, 1109.1250, 19.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -45.7344, 1109.0234, 19.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3292, -95.3125, 1121.3047, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 3293, -100.0000, 1118.6250, 21.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 16385, -122.7422, 1122.7500, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -90.6016, 1128.2188, 19.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -53.2656, 1135.5781, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -45.2031, 1130.4141, 17.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, -133.8516, 1134.4141, 20.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -133.3594, 1137.5938, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -106.6719, 1140.0234, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 16735, -49.2422, 1137.7031, 28.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 780, -84.8906, 1143.4375, 18.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -81.0859, 1149.6406, 18.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -50.5078, 1160.9141, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -41.8125, 1160.0781, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -126.1719, 1159.0703, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, -88.8594, 1165.3828, 19.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -96.7188, 1164.3516, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -127.0000, 1173.4219, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 16475, -98.1953, 1180.0703, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -46.6953, 1179.5703, 18.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -132.0703, 1187.4609, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -76.5313, 1187.6406, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -95.1250, 1208.9453, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -128.2734, 1232.8438, 18.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -127.2656, 1222.5156, 18.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -97.5938, 1241.0781, 16.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -26.7422, 1080.1719, 18.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -26.4766, 1087.5859, 19.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 700, -5.2188, 1112.5703, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -13.2969, 1112.2656, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -4.3125, 1108.9453, 19.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 652, -31.8672, 1118.8359, 17.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -36.4922, 1136.0703, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 652, 1.5000, 1133.8984, 17.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 773, -18.3906, 1136.8203, 18.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 1.1484, 1137.7578, 19.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 3.8281, 1159.2969, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -26.4141, 1159.4844, 19.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 669, -31.3203, 1160.6875, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, -25.7813, 1188.0313, 18.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 5.5547, 1209.1016, 18.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 19.8281, 1085.3984, 19.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 774, 39.5547, 1087.0938, 18.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 17.1406, 1136.5938, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 33.6094, 1152.6953, 19.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 30.4922, 1157.7891, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 22.2578, 1158.4766, 18.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 35.9922, 1157.1875, 18.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 40.5625, 1188.6875, 17.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 65.0313, 1148.2344, 18.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 652, 45.0547, 1231.8281, 18.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 68.7969, 1117.5781, 17.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 773, 72.9063, 1137.3281, 14.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 66.7969, 1207.1563, 18.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 72.0859, 1206.8828, 18.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 73.0938, 1228.0391, 19.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 77.3594, 1206.8828, 18.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 76.9297, 1187.2969, 17.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 82.5156, 971.5078, 15.1328, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 82.5938, 998.1484, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 90.0859, 1147.8828, 16.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 16479, 86.2422, 1214.0391, 17.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 16480, 171.3516, 1220.0469, 23.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 78.2578, 1226.8516, 19.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 83.2813, 1225.2656, 19.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 3371, 6.9453, 1075.8828, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3305, 6.9453, 1075.8828, 21.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -90.9922, 1141.0000, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -90.9922, 1146.2734, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -90.9922, 1151.5469, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 16478, 55.5625, 1220.6797, 17.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -227.3906, 1063.3047, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -232.6641, 1063.3047, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -237.9375, 1063.3047, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, -222.1094, 1063.3047, 19.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3286, -230.2031, 1185.7734, 23.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 16477, 55.5625, 1220.6797, 17.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 66.7969, 1207.1563, 18.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 72.0859, 1206.8828, 18.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 73.0938, 1228.0391, 19.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 77.3594, 1206.8828, 18.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 16479, 86.2422, 1214.0391, 17.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 78.2578, 1226.8516, 19.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 83.2813, 1225.2656, 19.8203, 0.25);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	thorus_OnPlayerDataSave(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
    PlayerPlaySound(playerid,1063,0.0,0.0,0.0);
    SetTimerEx("WH", 1000, true, "d", playerid);
	if(p[playerid][plog] == 1)
	{
	    if(p[playerid][slot] == 0 || p[playerid][slot] == 1) // slot 0
		{
			GivePlayerWeapon(playerid, p[playerid][slot], 1);
		}
	    if(p[playerid][slot1] >= 2 && p[playerid][slot1] <= 9) // slot 1
		{
			GivePlayerWeapon(playerid, p[playerid][slot1], 1);
		}
		if(p[playerid][slot2] >= 22 && p[playerid][slot2] <= 24) // slot 2
		{
			GivePlayerWeapon(playerid, p[playerid][slot2], p[playerid][ammo2]);
		}
		if(p[playerid][slot3] >= 25 && p[playerid][slot3] <= 27) // slot 3
		{
			GivePlayerWeapon(playerid, p[playerid][slot3], p[playerid][ammo3]);
		}
		if(p[playerid][slot4] == 28 || p[playerid][slot4] == 29 || p[playerid][slot4] == 32) // slot 4
		{
			GivePlayerWeapon(playerid, p[playerid][slot4], p[playerid][ammo4]);
		}
		if(p[playerid][slot5] == 30 && p[playerid][slot5] == 31) // slot 5
		{
			GivePlayerWeapon(playerid, p[playerid][slot5], p[playerid][ammo5]);
		}
		if(p[playerid][slot6] == 33 && p[playerid][slot6] == 34) // slot 6
		{
			GivePlayerWeapon(playerid, p[playerid][slot6], p[playerid][ammo6]);
		}
		if(p[playerid][slot9] >= 41 && p[playerid][slot9] <= 43) // slot 9
		{
			GivePlayerWeapon(playerid, p[playerid][slot9], p[playerid][ammo9]);
		}
		if(p[playerid][slot10] >= 10 && p[playerid][slot10] <= 15) // slot 10
		{
			GivePlayerWeapon(playerid, p[playerid][slot10], 1);
		}
		p[playerid][plog] = 0;
	}
	if(p[playerid][idf] != 0 && p[playerid][ranga] != 0)
	{
	    SetPlayerPos(playerid, org[p[playerid][idf]][ox], org[p[playerid][idf]][oy], org[p[playerid][idf]][oz]);
	    SetPlayerFacingAngle(playerid, org[p[playerid][idf]][oa]);
	    switch(p[playerid][ranga])
	    {
	        case 1:
	        {
	            SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin]);
			}
			case 2:
	        {
	            SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin2]);
			}
			case 3:
	        {
	            SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin3]);
			}
			case 4:
	        {
	            SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin4]);
			}
			case 5:
	        {
	            SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin5]);
			}
			case 6:
	        {
	            SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin6]);
			}
			case 7:
	        {
	            SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin7]);
			}
			case 8:
	        {
	            SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin8]);
			}
			case 9:
	        {
	            SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin9]);
			}
			case 10:
	        {
	            SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin10]);
			}
		}
	}
	else
	{
 		SetPlayerSkin(playerid, p[playerid][skin]);
 		SetPlayerPos(playerid, -316.4186,1056.1381,19.7422);
 		SetPlayerFacingAngle(playerid,1.3154);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(chat)
	{
		new string[128];
		format(string, sizeof string, "%s mówi: %s", PlayerName(playerid), text);
		ProxDetector(20.0, playerid,string, CZAT1, CZAT2, CZAT3, CZAT4, CZAT5);
	}
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case 1:
	    {
	        switch(response)
	        {
	            case 0: Kick(playerid);
	            case 1: Kick(playerid);
			}
		}
	    case rejestracja:
		{
		    switch(response)
		    {
		        case 0: return Kick(playerid);
		        case 1: return thorus_OnPlayerRegister(playerid, inputtext);
			}
		}
		case logowanie:
		{
  			switch(response)
		    {
		        case 0: return Kick(playerid);
		        case 1: return thorus_OnPlayerLogin(playerid, inputtext);
			}
		}
		case zmienhaslo:
		{
		    switch(response)
		    {
		        case 1: return thorus_ChangePassword(playerid, inputtext);
			}
		}
		case ppanel:
		{
		    switch(response)
		    {
		        case 1:
		        {

					new dupa[128];
					sscanf(inputtext, "p<:>d{s[128]}", vehicleuid[playerid], dupa);
					ShowPlayerDialog(playerid, ppanel2, DIALOG_STYLE_LIST, "Co chcesz zrobiæ?", "Zmiania koloru pierwszego\nZmiana koloru drugiego\nZaparkowanie pojazdu\nTeleport", "Wybierz", "Anuluj");
				}
			}
		}
		case ppanel2:
		{
		    switch(response)
		    {
				case 1:
				{
				    switch(listitem)
				    {
		        		case 0:
		        		{
		            		ShowPlayerDialog(playerid, ppanelkolor, DIALOG_STYLE_INPUT, "Zmiana koloru", "Podaj ID koloru ( 0-255 )", "Zmieñ", "Anuluj");
						}
						case 1:
						{
				    		ShowPlayerDialog(playerid, ppanelkolor, DIALOG_STYLE_INPUT, "Zmiana koloru", "Podaj ID koloru ( 0-255 )", "Zmieñ", "Anuluj");
						}
						case 2:
						{
				    		new Float:px, Float:py, Float:pz, Float:pa;
			    			GetVehiclePos(vehicleuid[playerid], px, py, pz);
				    		GetVehicleZAngle(vehicleuid[playerid], pa);
				    		v[vehicleuid[playerid]][vx] = px;
				    		v[vehicleuid[playerid]][vy] = py;
				    		v[vehicleuid[playerid]][vz] = pz;
				    		v[vehicleuid[playerid]][va] = pa;
				    		thorus_saveVeh(vehicleuid[playerid]);
							SendClientMessage(playerid, pomaranczowy, "[INFO] Zaparkowano pojazd pomyœlnie.");
						}
						case 3:
						{
				    		ShowPlayerDialog(playerid, ppanelteleport, DIALOG_STYLE_MSGBOX, "Teleport pojazdu", "Wybierz formê teleportu.", "Do mnie", "Do niego");
						}
					}
				}
			}
		}
		case ppanelkolor:
		{
		    switch(response)
		    {
		        case 1:
		        {
					if(strval(inputtext) < 0 || strval(inputtext) > 255)
					    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID koloru.");
					    
					v[vehicleuid[playerid]][kolor] = strval(inputtext);
					ChangeVehicleColor(vehicleuid[playerid], v[vehicleuid[playerid]][kolor], v[vehicleuid[playerid]][kolor2]);
					thorus_saveVeh(vehicleuid[playerid]);
                    SendClientMessage(playerid, pomaranczowy, "[INFO] Zmieniono kolor pojazdu pomyœlnie.");
				}
			}
		}
		case ppanelkolor2:
		{
		    switch(response)
		    {
		        case 1:
		        {
					if(strval(inputtext) < 0 || strval(inputtext) > 255)
					    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID koloru.");

					v[vehicleuid[playerid]][kolor2] = strval(inputtext);
					ChangeVehicleColor(vehicleuid[playerid], v[vehicleuid[playerid]][kolor], v[vehicleuid[playerid]][kolor2]);
					thorus_saveVeh(vehicleuid[playerid]);
                    SendClientMessage(playerid, pomaranczowy, "[INFO] Zmieniono kolor pojazdu pomyœlnie.");
				}
			}
		}
		case ppanelteleport:
		{
		    switch(response)
		    {
		        case 0:
		        {
		            new Float:px, Float:py, Float:pz, Float:pa;
		            GetVehiclePos(vehicleuid[playerid], px, py, pz);
		            GetVehicleZAngle(vehicleuid[playerid], pa);
		            SetPlayerPos(playerid, px, py, pz);
		            SetPlayerFacingAngle(playerid, pa);
		            PutPlayerInVehicle(playerid, vehicleuid[playerid], 0);
		            SendClientMessage(playerid, pomaranczowy, "[INFO] Teleportowano pomyœlnie.");
				}
				case 1:
				{
				    new Float:px, Float:py, Float:pz, Float:pa;
				    GetPlayerPos(playerid, px, py, pz);
				    GetPlayerFacingAngle(playerid, pa);
				    SetVehiclePos(vehicleuid[playerid], px, py, pz);
				    SetVehicleZAngle(vehicleuid[playerid], pa);
				    SendClientMessage(playerid, pomaranczowy, "[INFO] Teleportowano pomyœlnie.");
				}
			}
		}
		case bizownpanel:
		{
		    switch(response)
		    {
				case 1:
				{
				    switch(listitem)
				    {
				        case 0:
				        {
				            ShowPlayerDialog(playerid, biznamedialog, DIALOG_STYLE_INPUT, "Zmiana nazwy biznesu.", "Podaj now¹ nazwe dla biznesu(3-24 znaków).", "Zmieñ", "Anuluj");
						}
						case 1:
						{
						    ShowPlayerDialog(playerid, bizsejfdialog, DIALOG_STYLE_INPUT, "Sejf - wyci¹ganie gotówki.", "Ile chcesz wyci¹gn¹æ pieniêdzy z sejfu?", "Zabierz", "Anuluj");
						}
						case 2:
						{
						    ShowPlayerDialog(playerid, bizdrzwidialog, DIALOG_STYLE_MSGBOX, "Informacja.", "Chcesz drzwi zamkn¹æ czy otworzyæ?", "Otwórz", "Zamknij");
						}
						case 3:
						{
						    ShowPlayerDialog(playerid, bizproduktydialog, DIALOG_STYLE_INPUT, "Produkty.", "Ile chcesz kupiæ produktów?\nKoszt jednego produktu to 3$.", "Kup", "Anuluj");
						}
						case 4:
						{
						    format(txt, sizeof txt, "Na pewno chcesz sprzedaæ swój biznes za cene pocz¹tkow¹?\nCena pocz¹tkowa: %d$", biz[biz_index[playerid]][cena]);
						    ShowPlayerDialog(playerid, bizsellpanel, DIALOG_STYLE_MSGBOX, "Pytanie", txt, "Tak", "Nie");
						}
						default: biz_index[playerid] = 0;
					}
				}
			}
		}
		case bizsellpanel:
		{
		    switch(response)
			{
				case 0:
				{
				    if(biz[biz_index[playerid]][idown] != p[playerid][id])
				        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie jesteœ w³aœcicielem tego biznesu.", "Ok", ""), biz_index[playerid]=0;

					p[playerid][kasa] += biz[biz_index[playerid]][cena];
					GivePlayerMoney(playerid, biz[biz_index[playerid]][cena]);
                    biz[biz_index[playerid]][idown] = 0;
					format(txt, sizeof txt, "[INFO] Sprzedano biznes za %d$.", biz[biz_index[playerid]][cena]);
					SendClientMessage(playerid, niebieski, txt);
					biz_index[playerid] = 0;
				}
			}
		}
		case bizproduktydialog:
		{
		    switch(response)
		    {
		        case 1:
		        {
					if(!IsNumeric(inputtext))
					    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Podany ci¹g nie jest liczb¹.", "Ok", ""), biz_index[playerid]=0;

					new ilosc=strval(inputtext);
					new koszt=ilosc*3;
					if(p[playerid][kasa] < koszt)
					    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki.", "Ok", ""), biz_index[playerid]=0;

					biz[biz_index[playerid]][produkty] += ilosc;
					GivePlayerMoney(playerid, -koszt);
					p[playerid][kasa] -= koszt;
					Action(playerid, "zamawia produkty do swojego biznesu.");
					format(txt, sizeof txt, "[INFO] Zamówiono %d produktów za %d$.", ilosc, koszt);
					SendClientMessage(playerid, niebieski, txt);
				}
			}
		}
		case bizdrzwidialog:
		{
			switch(response)
			{
			    case 0:
			    {
			        if(biz[biz_index[playerid]][zamkniety] == 0)
			            return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes jest ju¿ otwarty.", "Ok", ""), biz_index[playerid]=0;

					biz[biz_index[playerid]][zamkniety] = 0;
					biz_index[playerid] = 0;
					Action(playerid, "otwiera drzwi lokalu.");
					SendClientMessage(playerid, niebieski, "[INFO] Otwarto drzwi lokalu.");
				}
				case 1:
			    {
			        if(biz[biz_index[playerid]][zamkniety] == 1)
			            return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes jest ju¿ otwarty.", "Ok", ""), biz_index[playerid]=0;

					biz[biz_index[playerid]][zamkniety] = 1;
					biz_index[playerid] = 0;
					Action(playerid, "zamyka drzwi lokalu.");
					SendClientMessage(playerid, niebieski, "[INFO] Zamkniêto drzwi lokalu.");
				}
			}
		}
		case bizsejfdialog:
		{
		    switch(response)
		    {
				case 1:
				{
				    if(!IsNumeric(inputtext))
					    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Podany ci¹g nie jest liczb¹.", "Ok", ""), biz_index[playerid]=0;

				    new kwota = strval(inputtext);
				    if(biz[biz_index[playerid]][konto] < kwota)
				        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz tyle w sejfie.", "Ok", ""), biz_index[playerid]=0;

                    biz[biz_index[playerid]][konto] -= kwota;
                    p[playerid][kasa] += kwota;
                    GivePlayerMoney(playerid, kwota);
                    biz_index[playerid] = 0;
                    format(txt, sizeof txt, "[INFO] Wyp³acono %d$ z sejfu biznesu, nowa iloœc pieniêdzy w sejfie: %d$.", kwota, biz[biz_index[playerid]][konto]);
                    SendClientMessage(playerid, niebieski, txt);
                    Action(playerid, "wyci¹ga gotówke z sejfu.");
				}
			}
		}
		case biznamedialog:
		{
		    switch(response)
		    {
				case 1:
				{
				    if(strlen(inputtext) < 3 || strlen(inputtext) > 24)
				        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nieprawid³owa d³ugoœæ nazwy.", "Ok", ""), biz_index[playerid]=0;

					new nazabiznesu[24];
					strcat(nazabiznesu, inputtext, 24);
					biz[biz_index[playerid]][nazwa] = nazabiznesu;
					biz_index[playerid] = 0;
					format(txt, sizeof txt, "[INFO] Zmieniono nazwe biznesu na %s", nazabiznesu);
					SendClientMessage(playerid, niebieski, txt);
				}
			}
		}
		case bizsspanel:
		{
		    switch(response)
		    {
		        case 1:
		        {
		            switch(listitem)
		            {
		                case 0:
		                {
		                    if(p[playerid][kasa] < 200)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 10)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;
							    
                            GivePlayerWeapon(playerid, 10, 1);
							GivePlayerMoney(playerid, -200);
							p[playerid][kasa] -= 200;
							biz[biz_index[playerid]][produkty] -= 10;
							biz[biz_index[playerid]][konto] += 200;
							biz_index[playerid] = 0;
							p[playerid][slot10] = 10;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono fioletowe dildo za 200$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 1:
		                {
		                    if(p[playerid][kasa] < 150)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 10)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerWeapon(playerid, 11, 1);
							GivePlayerMoney(playerid, -150);
							p[playerid][kasa] -= 150;
							biz[biz_index[playerid]][produkty] -= 10;
							biz[biz_index[playerid]][konto] += 150;
							biz_index[playerid] = 0;
							p[playerid][slot10] = 11;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono dildo za 150$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 2:
		                {
		                    if(p[playerid][kasa] < 200)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 10)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerWeapon(playerid, 12, 1);
							GivePlayerMoney(playerid, -200);
							p[playerid][kasa] -= 200;
							biz[biz_index[playerid]][produkty] -= 10;
							biz[biz_index[playerid]][konto] += 200;
							biz_index[playerid] = 0;
							p[playerid][slot10] = 12;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono wibrator za 200$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 3:
		                {
		                    if(p[playerid][kasa] < 300)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 10)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerWeapon(playerid, 13, 1);
							GivePlayerMoney(playerid, -300);
							p[playerid][kasa] -= 300;
							biz[biz_index[playerid]][produkty] -= 10;
							biz[biz_index[playerid]][konto] += 300;
							biz_index[playerid] = 0;
							p[playerid][slot10] = 13;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono srebrny wibrator za 300$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
					}
				}
			}
		}
		case bizsklepubraniapanel:
		{
		    switch(response)
		    {
		        case 1:
		        {
		            new ids = strval(inputtext);
		            if(p[playerid][kasa] < 150)
		            	return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

					if(biz[biz_index[playerid]][produkty] < 10)
	    				return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

		            if(ids < 0 || ids > 299)
		                return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Z³e ID.", "Ok", ""), biz_index[playerid]=0;

					p[playerid][skin] = ids;
					p[playerid][kasa] -= 150;
					GivePlayerMoney(playerid, -150);
					biz[biz_index[playerid]][konto] += 150;
					biz[biz_index[playerid]][produkty] -= 10;
					SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono nowe ubranie za 150$.");
					Action(playerid, "podchodzi do kasy i p³aci za produkt.");
				}
			}
		}
		case bizbarclubpanel:
		{
		    switch(response)
		    {
		        case 1:
		        {
		            switch(listitem)
		            {
		                case 0:
		                {
		                    if(p[playerid][kasa] < 5)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerMoney(playerid, -5);
							p[playerid][kasa] -= 5;
							biz[biz_index[playerid]][produkty] -= 1;
							biz[biz_index[playerid]][konto] += 5;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono piwo za 5$.");
							Action(playerid, "podchodzi do baru i kupuje napój.");
							Drunk(playerid, 500);
						}
						case 1:
		                {
		                    if(p[playerid][kasa] < 8)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerMoney(playerid, -8);
							p[playerid][kasa] -= 8;
							biz[biz_index[playerid]][produkty] -= 1;
							biz[biz_index[playerid]][konto] += 8;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono 100ml wódki za 8$.");
							Action(playerid, "podchodzi do baru i kupuje napój.");
							Drunk(playerid, 1000);
						}
						case 2:
		                {
		                    if(p[playerid][kasa] < 50)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerMoney(playerid, -50);
							p[playerid][kasa] -= 50;
							biz[biz_index[playerid]][produkty] -= 1;
							biz[biz_index[playerid]][konto] += 50;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono whisky za 50$.");
							Action(playerid, "podchodzi do baru i kupuje napój.");
							Drunk(playerid, 1000);
						}
						case 3:
		                {
		                    if(p[playerid][kasa] < 35)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerMoney(playerid, -35);
							p[playerid][kasa] -= 35;
							biz[biz_index[playerid]][produkty] -= 1;
							biz[biz_index[playerid]][konto] += 35;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono wino za 35$.");
							Action(playerid, "podchodzi do baru i kupuje napój.");
							Drunk(playerid, 750);
						}
						case 4:
		                {
		                    if(p[playerid][kasa] < 40)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerMoney(playerid, -40);
							p[playerid][kasa] -= 40;
							biz[biz_index[playerid]][produkty] -= 1;
							biz[biz_index[playerid]][konto] += 40;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono brandy za 40$.");
							Action(playerid, "podchodzi do baru i kupuje napój.");
							Drunk(playerid, 750);
						}
						case 5:
		                {
		                    if(p[playerid][kasa] < 10)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerMoney(playerid, -10);
							p[playerid][kasa] -= 10;
							biz[biz_index[playerid]][produkty] -= 1;
							biz[biz_index[playerid]][konto] += 10;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono sode za 10$.");
							Action(playerid, "podchodzi do baru i kupuje napój.");
							Drunk(playerid, -250);
						}
					}
				}
			}
		}
		case bizammunationpanel:
		{
		    switch(response)
		    {
		        case 1:
		        {
		            switch(listitem)
		            {
		                case 0:
		                {
		                    if(p[playerid][kasa] < 900)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 30)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            if(p[playerid][lickabron] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie posiadasz licencji na broñ.\nKup j¹ w urzêdzie Fort Carson.", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerWeapon(playerid, 22, 50);
							GivePlayerMoney(playerid, -900);
							p[playerid][kasa] -= 900;
							biz[biz_index[playerid]][produkty] -= 30;
							biz[biz_index[playerid]][konto] += 900;
							biz_index[playerid] = 0;
							p[playerid][slot2] = 22;
							p[playerid][ammo2] += 50;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono pistolet 9mm za 900$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 1:
		                {
		                    if(p[playerid][kasa] < 1200)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 40)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            if(p[playerid][lickabron] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie posiadasz licencji na broñ.\nKup j¹ w urzêdzie Fort Carson.", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerWeapon(playerid, 23, 50);
							GivePlayerMoney(playerid, -1200);
							p[playerid][kasa] -= 1200;
							biz[biz_index[playerid]][produkty] -= 40;
							biz[biz_index[playerid]][konto] += 1200;
							biz_index[playerid] = 0;
							p[playerid][slot2] = 23;
							p[playerid][ammo2] += 50;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono pistolet z t³umikiem(9mm) za 1200$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 2:
		                {
		                    if(p[playerid][kasa] < 1500)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 50)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            if(p[playerid][lickabron] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie posiadasz licencji na broñ.\nKup j¹ w urzêdzie Fort Carson.", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerWeapon(playerid, 25, 20);
							GivePlayerMoney(playerid, -1500);
							p[playerid][kasa] -= 1500;
							biz[biz_index[playerid]][produkty] -= 50;
							biz[biz_index[playerid]][konto] += 1500;
							biz_index[playerid] = 0;
							p[playerid][slot3] = 25;
							p[playerid][ammo3] += 20;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono shotgun za 1500$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 3:
		                {
		                    if(p[playerid][kasa] < 2000)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 60)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            if(p[playerid][lickabron] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie posiadasz licencji na broñ.\nKup j¹ w urzêdzie Fort Carson.", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerWeapon(playerid, 33, 25);
							GivePlayerMoney(playerid, -2000);
							p[playerid][kasa] -= 2000;
							biz[biz_index[playerid]][produkty] -= 60;
							biz[biz_index[playerid]][konto] += 2000;
							biz_index[playerid] = 0;
							p[playerid][slot6] = 33;
							p[playerid][ammo6] += 25;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono Country Rifle za 2000$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 4:
		                {
		                    if(p[playerid][kasa] < 1450)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 30)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            if(p[playerid][lickabron] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie posiadasz licencji na broñ.\nKup j¹ w urzêdzie Fort Carson.", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerWeapon(playerid, 24, 20);
							GivePlayerMoney(playerid, -1450);
							p[playerid][kasa] -= 1450;
							biz[biz_index[playerid]][produkty] -= 30;
							biz[biz_index[playerid]][konto] += 1450;
							biz_index[playerid] = 0;
							p[playerid][slot2] = 24;
							p[playerid][ammo2] += 20;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono Desert Eagle za 1450$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 5:
		                {
		                    if(p[playerid][kasa] < 1000)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 20)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            if(p[playerid][lickabron] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie posiadasz licencji na broñ.\nKup j¹ w urzêdzie Fort Carson.", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerWeapon(playerid, 32, 300);
							GivePlayerMoney(playerid, -1000);
							p[playerid][kasa] -= 1000;
							biz[biz_index[playerid]][produkty] -= 20;
							biz[biz_index[playerid]][konto] += 1000;
							biz_index[playerid] = 0;
							p[playerid][slot4] = 32;
							p[playerid][ammo4] += 300;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono Tec-9 za 1000$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 6:
		                {
		                    if(p[playerid][kasa] < 2000)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 60)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            if(p[playerid][lickabron] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie posiadasz licencji na broñ.\nKup j¹ w urzêdzie Fort Carson.", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerWeapon(playerid, 30, 200);
							GivePlayerMoney(playerid, -2000);
							p[playerid][kasa] -= 2000;
							biz[biz_index[playerid]][produkty] -= 50;
							biz[biz_index[playerid]][konto] += 2000;
							biz_index[playerid] = 0;
							p[playerid][slot4] = 30;
							p[playerid][ammo4] += 200;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono MP5 za 2000$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 7:
		                {
		                    if(p[playerid][kasa] < 500)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 10)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            if(p[playerid][lickabron] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie posiadasz licencji na broñ.\nKup j¹ w urzêdzie Fort Carson.", "Ok", ""), biz_index[playerid]=0;

                            GivePlayerWeapon(playerid, 46, 1);
							GivePlayerMoney(playerid, -500);
							p[playerid][kasa] -= 500;
							biz[biz_index[playerid]][produkty] -= 10;
							biz[biz_index[playerid]][konto] += 500;
							biz_index[playerid] = 0;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono spadochron za 500$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 8:
		                {
		                    if(p[playerid][kasa] < 1000)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 20)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

                            if(p[playerid][lickabron] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie posiadasz licencji na broñ.\nKup j¹ w urzêdzie Fort Carson.", "Ok", ""), biz_index[playerid]=0;

                            SetPlayerArmour(playerid, 100.0);
							GivePlayerMoney(playerid, -1000);
							p[playerid][kasa] -= 1000;
							biz[biz_index[playerid]][produkty] -= 20;
							biz[biz_index[playerid]][konto] += 1000;
							biz_index[playerid] = 0;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono kamizelke kuloodporn¹ za 1000$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
					}
				}
			}
		}
		case bizskleppanel:
		{
		    switch(response)
		    {
		        case 1:
		        {
		            switch(listitem)
		            {
		                case 0:
		                {
		                    if(p[playerid][kasa] < 150)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;
		                        
							if(biz[biz_index[playerid]][produkty] < 15)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

							GivePlayerWeapon(playerid, 2, 1);
							GivePlayerMoney(playerid, -150);
							p[playerid][kasa] -= 150;
							biz[biz_index[playerid]][produkty] -= 15;
							biz[biz_index[playerid]][konto] += 150;
							biz_index[playerid] = 0;
							p[playerid][slot1] = 2;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono kij golfowy za 150$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 1:
		                {
		                    if(p[playerid][kasa] < 5)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

							GivePlayerWeapon(playerid, 4, 1);
							GivePlayerMoney(playerid, -5);
							biz[biz_index[playerid]][konto] += 5;
							p[playerid][kasa] -= 5;
							p[playerid][slot1] = 4;
							biz[biz_index[playerid]][produkty] -= 1;
							biz_index[playerid] = 0;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono nó¿ za 5$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 2:
		                {
		                    if(p[playerid][kasa] < 125)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 12)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

							GivePlayerWeapon(playerid, 5, 1);
							GivePlayerMoney(playerid, -125);
							biz[biz_index[playerid]][konto] += 125;
							p[playerid][kasa] -= 125;
							biz[biz_index[playerid]][produkty] -= 12;
							biz_index[playerid] = 0;
							p[playerid][slot1] = 5;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono baseball za 125$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
      					}
						case 3:
		                {
		                    if(p[playerid][kasa] < 10)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

							GivePlayerWeapon(playerid, 6, 1);
							GivePlayerMoney(playerid, -10);
							p[playerid][kasa] -= 10;
							biz[biz_index[playerid]][produkty] -= 1;
							biz[biz_index[playerid]][konto] += 10;
							biz_index[playerid] = 0;
							p[playerid][slot1] = 6;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono ³opate za 10$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 4:
		                {
		                    if(p[playerid][kasa] < 60)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 6)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

							GivePlayerWeapon(playerid, 7, 1);
							GivePlayerMoney(playerid, -60);
							p[playerid][kasa] -= 60;
							biz[biz_index[playerid]][produkty] -= 6;
							biz[biz_index[playerid]][konto] += 60;
							biz_index[playerid] = 0;
							p[playerid][slot1] = 7;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono kij bilardowy za 60$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 5:
		                {
		                    if(p[playerid][kasa] < 955)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 50)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

							GivePlayerWeapon(playerid, 9, 1);
							GivePlayerMoney(playerid, -955);
							p[playerid][kasa] -= 955;
							biz[biz_index[playerid]][produkty] -= 50;
							biz[biz_index[playerid]][konto] += 955;
							biz_index[playerid] = 0;
							p[playerid][slot1] = 9;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono pi³e ³añcuchow¹ za 955$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 6:
		                {
		                    if(p[playerid][kasa] < 10)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

							GivePlayerWeapon(playerid, 14, 1);
							GivePlayerMoney(playerid, -10);
							p[playerid][kasa] -= 10;
							biz[biz_index[playerid]][produkty] -= 1;
							biz[biz_index[playerid]][konto] += 10;
							biz_index[playerid] = 0;
							p[playerid][slot10] = 14;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono kwiaty za 10$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 7:
		                {
		                    if(p[playerid][kasa] < 5)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

							GivePlayerWeapon(playerid, 15, 1);
							GivePlayerMoney(playerid, -5);
							p[playerid][kasa] -= 5;
							biz[biz_index[playerid]][produkty] -= 1;
							biz[biz_index[playerid]][konto] += 5;
							biz_index[playerid] = 0;
							p[playerid][slot10] = 15;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono laske za 5$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 8:
		                {
		                    if(p[playerid][kasa] < 15)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 1)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

							GivePlayerWeapon(playerid, 41, 50);
							GivePlayerMoney(playerid, -15);
							p[playerid][kasa] -= 15;
							biz[biz_index[playerid]][produkty] -= 1;
							biz[biz_index[playerid]][konto] += 15;
							biz_index[playerid] = 0;
							p[playerid][slot9] = 41;
							p[playerid][ammo9] = 50;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono spray za 15$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 9:
		                {
		                    if(p[playerid][kasa] < 450)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 15)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

							GivePlayerWeapon(playerid, 43, 50);
							GivePlayerMoney(playerid, -450);
							p[playerid][kasa] -= 450;
							biz[biz_index[playerid]][produkty] -= 15;
							biz[biz_index[playerid]][konto] += 50;
							biz_index[playerid] = 0;
							p[playerid][slot9] = 43;
							p[playerid][ammo9] = 50;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono aparat za 450$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
						case 10:
		                {
		                    if(p[playerid][kasa] < 300)
		                        return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Nie masz przy sobie tyle gotówki!", "Ok", ""), biz_index[playerid]=0;

							if(biz[biz_index[playerid]][produkty] < 15)
							    return ShowPlayerDialog(playerid, bizerror, DIALOG_STYLE_MSGBOX, "Error!", "Biznes ma za ma³o produktów!", "Ok", ""), biz_index[playerid]=0;

							GivePlayerWeapon(playerid, 42, 150);
							GivePlayerMoney(playerid, -300);
							p[playerid][kasa] -= 300;
							biz[biz_index[playerid]][produkty] -= 15;
							biz[biz_index[playerid]][konto] += 300;
							biz_index[playerid] = 0;
							p[playerid][slot9] = 42;
							p[playerid][ammo9] = 150;
							SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono gaœnice za 150$.");
							Action(playerid, "podchodzi do kasy i p³aci za produkt.");
						}
					}
				}
			}
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new Float:px, Float:py, Float:pz, Float:pa;
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, pa);
	if(p[playerid][admin] != 0)
	{
	    format(txt, sizeof txt, "[INFO] Wsiadasz do pojazdu UID: %d | sampID: %d", v[vehicleid][vid], vehicleid);
	    SendClientMessage(playerid, admincolor, txt);
	}
	if(v[vehicleid][typ] == 3 && v[vehicleid][ido] == 0 && v[vehicleid][cena] != 0)
	{
	    format(txt, sizeof txt, "[INFO] Pojazd jest na sprzeda¿ za %d$.", v[vehicleid][cena]);
	    SendClientMessage(playerid, niebieski, txt);
	    SendClientMessage(playerid, niebieski, "[INFO] Wpisz /kuppojazd - aby dokonaæ zakupu.");
	}
	if(v[vehicleid][typ] == 2 && v[vehicleid][ido] != 0)
	{
		if(v[vehicleid][ido] != p[playerid][id])
		{
		    SetPlayerPos(playerid, px, py, pz);
		    SetPlayerFacingAngle(playerid, pa);
		    SendClientMessage(playerid, niebieski, "[INFO] Ten pojazd jest prywatny i nie nale¿y do Ciebie!");
		}
	}
	if(v[vehicleid][typ] == 2 && v[vehicleid][ido] == p[playerid][id])
	{
	    SendClientMessage(playerid, niebieski, "[INFO] Wpisz /ppanel aby uzyskaæ dostêp do panelu pojazdów prywatnych.");
	}
	if(v[vehicleid][typ] == 1 && v[vehicleid][fid] != 0)
	{
	    if(p[playerid][idf] != v[vehicleid][fid])
	    {
	        SetPlayerPos(playerid, px, py, pz);
		    SetPlayerFacingAngle(playerid, pa);
		    format(txt, sizeof txt, "[INFO] Ten pojazd nale¿y do organizacji %s", org[v[vehicleid][fid]][onazwa]);
		    SendClientMessage(playerid, niebieski, txt);
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public thorus_saveOrg(orgid)
{
	new orgdata[256];
	format(orgdata, sizeof orgdata, "update `org` set `nazwa`='%s', `typ`='%d', `x`='%f', `y`='%f', `z`='%f', `a`='%f' where `id`='%d'",
	org[orgid][onazwa],
	org[orgid][typ],
	org[orgid][ox],
	org[orgid][oy],
	org[orgid][oz],
	org[orgid][oa],
	orgid);
	mysql_query(orgdata);
	return 1;
}

public thorus_loadBusiness()
{
    new query[256];
    print("[system] wczytywanie biznesow..");
	mysql_query("select * from `biz`");
	mysql_store_result();
	while(mysql_fetch_row_format(query, "|"))
	{
	    ilebiz++;
	    sscanf(query, "p<|>ds[24]dfffdfffddddddd",
	    biz[ilebiz][bizid],
	    biz[ilebiz][nazwa],
	    biz[ilebiz][typ],
	    biz[ilebiz][ex],
	    biz[ilebiz][ey],
	    biz[ilebiz][ez],
	    biz[ilebiz][eint],
	    biz[ilebiz][ex2],
	    biz[ilebiz][ey2],
	    biz[ilebiz][ez2],
	    biz[ilebiz][eint2],
	    biz[ilebiz][konto],
	    biz[ilebiz][produkty],
	    biz[ilebiz][zamkniety],
		biz[ilebiz][pickupid3],
		biz[ilebiz][idown],
		biz[ilebiz][cena]);
		biz[ilebiz][index_t] = ilebiz;
		if(biz[ilebiz][idown] == 0)
		{
			biz[ilebiz][pickupid3] = CreateDynamicPickup(1272, 1, biz[ilebiz][ex], biz[ilebiz][ey], biz[ilebiz][ez]);
		}
		else if(biz[ilebiz][idown] != 0)
		{
		    biz[ilebiz][pickupid3] = CreateDynamicPickup(1273, 1, biz[ilebiz][ex], biz[ilebiz][ey], biz[ilebiz][ez]);
		}
	}
	printf("[system] %d biznesow wczytano", ilebiz);
	mysql_free_result();
	return 1;
}

public thorus_saveBusiness(uid)
{
	new datasave[500];
	format(datasave, sizeof datasave, "update `biz` set `nazwa`='%s', `typ`='%d', `ex`='%f', `ey`='%f', `ez`='%f', `eint`='%d', `ex2`='%f', `ey2`='%f', `ez2`='%f', `eint2`='%d', `konto`='%d', `produkty`='%d', `zamkniety`='%d', `pickupid`='%d', `idown`='%d', `cena`='%d' where `id`='%d'",
 	biz[uid][nazwa],
  	biz[uid][typ],
   	biz[uid][ex],
    biz[uid][ey],
    biz[uid][ez],
    biz[uid][eint],
    biz[uid][ex2],
    biz[uid][ey2],
    biz[uid][ez2],
    biz[uid][eint2],
    biz[uid][konto],
    biz[uid][produkty],
    biz[uid][zamkniety],
	biz[uid][pickupid3],
	biz[uid][idown],
	biz[uid][cena],
	biz[uid][bizid]);
	mysql_query(datasave);
	return 1;
}

public thorus_createBusiness(playerid, b_name[24], b_typ)
{
	new Float:px, Float:py, Float:pz;
	GetPlayerPos(playerid, px, py, pz);
	new insertdata[340];
	format(insertdata, sizeof insertdata, "insert into `biz` (`nazwa`, `typ`, `ex`, `ey`, `ez`) values ('%s', '%d', '%f', '%f', '%f')",
	b_name,
	b_typ,
	px,
	py,
	pz);
	mysql_query(insertdata);
	new uid = ilebiz++;
	new iddata = mysql_insert_id();
	biz[uid][bizid] = iddata;
	biz[uid][nazwa] = b_name;
	biz[uid][typ] = b_typ;
	biz[uid][ex] = px;
	biz[uid][ey] = py;
	biz[uid][ez] = pz;
	biz[uid][eint] = 0;
	biz[uid][ex2] = 0;
	biz[uid][ey2] = 0;
	biz[uid][ez2] = 0;
	biz[uid][eint2] = 0;
	biz[uid][idown] = 0;
	biz[uid][konto] = 0;
	biz[uid][produkty] = 100;
	biz[uid][zamkniety] = 0;
	biz[uid][cena] = 100;
	biz[uid][pickupid3] = CreateDynamicPickup(1272, 1, biz[uid][ex], biz[uid][ey], biz[uid][ez]);
	thorus_saveBusiness(biz[uid][index_t]);
	format(txt, sizeof txt, "[INFO] Dodano biznes: index: %d | idDB: %d", uid, biz[uid][bizid]);
	SendClientMessage(playerid, admincolor, txt);
	return 1;
}

public thorus_loadBuilding()
{
	new query[256];
    print("[system] wczytuje budynki..");
	mysql_query("select * from `bud`");
	mysql_store_result();
	while(mysql_fetch_row_format(query, "|"))
	{
	    ilebud++;
	    sscanf(query, "p<|>ds[24]ffffdffffdd",
	    bud[ilebud][bid],
	    bud[ilebud][nazwa],
	    bud[ilebud][ex],
	    bud[ilebud][ey],
	    bud[ilebud][ez],
	    bud[ilebud][ea],
	    bud[ilebud][eint],
	    bud[ilebud][ex2],
	    bud[ilebud][ey2],
	    bud[ilebud][ez2],
	    bud[ilebud][ea2],
	    bud[ilebud][eint2],
	    bud[ilebud][pickupid2]);
	    bud[ilebud][index_t] = ilebud;
	    bud[ilebud][pickupid2] = CreateDynamicPickup(1239, 1, bud[ilebud][ex], bud[ilebud][ey], bud[ilebud][ez]);
	}
	mysql_free_result();
	printf("[system] wczytano %d budynkow", ilebud);
	return 1;
}

public thorus_buildingCreate(playerid, b_name[24])
{
	new Float:px, Float:py, Float:pz;
	GetPlayerPos(playerid, px, py, pz);
	new insert[128];
	format(insert, sizeof insert, "insert into `bud` (`nazwa`, `ex`, `ey`, `ez`, `eint`) values ('%s', '%f', '%f', '%f', '0')",
	b_name,
	px,
	py,
	pz);
	mysql_query(insert);
	new ins_id = mysql_insert_id();
	new idbud = ilebud++;
	bud[idbud][nazwa] = b_name;
	bud[idbud][ex] = px;
	bud[idbud][ey] = py;
	bud[idbud][ez] = pz;
	bud[idbud][ea] = 0;
	bud[idbud][eint] = 0;
	bud[idbud][ex2] = 0;
	bud[idbud][ey2] = 0;
	bud[idbud][ez2] = 0;
	bud[idbud][ea2] = 0;
	bud[idbud][eint2] = 0;
	bud[idbud][pickupid2] = CreateDynamicPickup(1239, 1, bud[ins_id][ex], bud[ins_id][ey], bud[ins_id][ez]);
	thorus_saveBuilding(idbud);
	format(txt, sizeof txt, "[INFO] Dodano budynek: index: %d | idDB: %d", idbud, ins_id);
	SendClientMessage(playerid, admincolor, txt);
	return 1;
}

public thorus_saveBuilding(b_id)
{
	new datasave[256];
	format(datasave, sizeof datasave, "update `bud` set `nazwa`='%s', `ex`='%f', `ey`='%f', `ez`='%f', `ea`='%f', `eint`='%d', `ex2`='%f', `ey2`='%f', `ez2`='%f', `ea2`='%f', `eint2`='%d', `pickupid`='%d' where `id`='%d'",
	bud[b_id][nazwa],
	bud[b_id][ex],
	bud[b_id][ey],
	bud[b_id][ez],
	bud[b_id][ea],
	bud[b_id][eint],
	bud[b_id][ex2],
	bud[b_id][ey2],
	bud[b_id][ez2],
	bud[b_id][ea2],
	bud[b_id][eint2],
	bud[b_id][pickupid2],
	b_id);
	mysql_query(datasave);
	return 1;
}

public thorus_loadOrg()
{
	new query[256];
	print("[System:] Zaczynam wczytywac organizacje....");
	mysql_query("select * from `org`");
	mysql_store_result();
	while(mysql_fetch_row_format(query, "|"))
	{
	    new uid;
	    sscanf(query, "p<|>d", uid);
	    sscanf(query, "p<|>ds[24]dffffds[12]ds[12]ds[12]ds[12]ds[12]ds[12]ds[12]ds[12]ds[12]ds[12]",
	    org[uid][oid],
        org[uid][onazwa],
        org[uid][typ],
        org[uid][ox],
        org[uid][oy],
        org[uid][oz],
        org[uid][oa],
        org[uid][r_skin],
        org[uid][r_nazwa],
        org[uid][r_skin2],
        org[uid][r_nazwa2],
        org[uid][r_skin3],
        org[uid][r_nazwa3],
        org[uid][r_skin4],
        org[uid][r_nazwa4],
        org[uid][r_skin5],
        org[uid][r_nazwa5],
        org[uid][r_skin6],
        org[uid][r_nazwa6],
        org[uid][r_skin7],
        org[uid][r_nazwa7],
        org[uid][r_skin8],
        org[uid][r_nazwa8],
        org[uid][r_skin9],
        org[uid][r_nazwa9],
        org[uid][r_skin10],
        org[uid][r_nazwa10]);
        org[uid][oid] = uid;
        ileorg++;
	}
	mysql_free_result();
	printf("[System] Wczytano %d organizacji", ileorg);
	return 1;
}

public thorus_resetStats(playerid)
{
	p[playerid][kasa] = 150;
	p[playerid][level] = 1;
	p[playerid][exp] = 0;
	p[playerid][wexp] = 4;
	p[playerid][skin] = 72;
	p[playerid][prawko] = 0;
	p[playerid][pilotaz] = 0;
	p[playerid][motor] = 0;
	p[playerid][lickabron] = 0;
	p[playerid][admin] = 0;
	p[playerid][vip] = 0;
	p[playerid][praca] = 0;
	p[playerid][idf] = 0;
	p[playerid][ranga] = 0;
	p[playerid][plog] = 0;
	p[playerid][zalogowany] = 0;
	p[playerid][slot1] = 0;
	p[playerid][slot] = 0;
	p[playerid][slot10] = 0;
	p[playerid][slot2] = 0;
	p[playerid][ammo2] = 0;
	p[playerid][slot3] = 0;
	p[playerid][ammo3] = 0;
	p[playerid][slot4] = 0;
	p[playerid][ammo4] = 0;
	p[playerid][slot5] = 0;
	p[playerid][ammo5] = 0;
	p[playerid][slot6] = 0;
	p[playerid][ammo6] = 0;
	p[playerid][slot9] = 0;
	p[playerid][ammo9] = 0;
	return 1;
}
public thorus_OnPlayerRegister(playerid, password[])
{
	if(strlen(password) < 4 || strlen(password) > 24)
	    return ShowPlayerDialog(playerid, rejestracja, DIALOG_STYLE_PASSWORD, "Rejestracja", "Wyst¹pi³ b³¹d!\nHas³o nie spe³nia warunku min/max d³ugoœci -> od 4 do 24 znaków\nPodaj has³o spe³niaj¹ce warunek:", "Zarejestruj", "Anuluj");

	format(mq, sizeof mq, "INSERT INTO `players` (`login`, `haslo`) VALUES ('%s', '%s')", PlayerName(playerid), password);
	mysql_query(mq);
	mysql_free_result();
	thorus_resetStats(playerid);
	thorus_OnPlayerLogin(playerid, password);
	return 1;
}

public thorus_OnPlayerLogin(playerid, password[])
{
	if(strlen(password) < 3 || strlen(password) > 24)
	    return ShowPlayerDialog(playerid, logowanie, DIALOG_STYLE_PASSWORD, "Logowanie", "Wyst¹pi³ b³¹d!\nPoda³eœ nieprawid³owe has³o do konta\nSpróbuj ponownie!", "Zaloguj", "Anuluj");
	    
	new scc[24];
	format(mq, sizeof(mq), "select `haslo` from `players` where `login`='%s' ", PlayerName(playerid));
	mysql_query(mq);
	mysql_store_result();
	mysql_fetch_row_format(scc, "|");
	mysql_free_result();
	sscanf(scc, "p<|>s[24]", p[playerid][haslo]);
	if(!strcmp(p[playerid][haslo], password, true))
	{
	    new data[256];
	    format(bq, sizeof bq, "select `id`, `kasa`,`level`,`exp`,`wexp`,`skin`,`prawko`,`pilotaz`,`motor`,`lickabron`,`admin`,`vip`,`praca`,`idf`,`ranga` from `players` where `login`='%s'  ", PlayerName(playerid));
	    mysql_query(bq);
		mysql_store_result();
		mysql_fetch_row_format(data, "|");
		mysql_free_result();
		sscanf(data, "p<|>ddddddddddddddd",
		p[playerid][id],
		p[playerid][kasa],
		p[playerid][level],
		p[playerid][exp],
		p[playerid][wexp],
        p[playerid][skin],
        p[playerid][prawko],
        p[playerid][pilotaz],
        p[playerid][motor],
        p[playerid][lickabron],
        p[playerid][admin],
        p[playerid][vip],
        p[playerid][praca],
        p[playerid][idf],
        p[playerid][ranga]);
        format(bq, sizeof bq, "select `slot`,`slot1`, `slot2`, `ammo2`, `slot3`,`ammo3`, `slot4`,`ammo4`,`slot5`,`ammo5`,`slot6`,`ammo6`,`slot9`,`ammo9`,`slot10` from `players` where `login`='%s'", PlayerName(playerid));
        mysql_query(bq);
		mysql_store_result();
		mysql_fetch_row_format(data, "|");
		mysql_free_result();
		sscanf(data, "p<|>ddddddddddddddd",
		p[playerid][slot],
		p[playerid][slot1],
		p[playerid][slot2],
		p[playerid][ammo2],
		p[playerid][slot3],
		p[playerid][ammo3],
		p[playerid][slot4],
		p[playerid][ammo4],
		p[playerid][slot5],
		p[playerid][ammo5],
		p[playerid][slot6],
		p[playerid][ammo6],
		p[playerid][slot9],
		p[playerid][ammo9],
		p[playerid][slot10]);
		GivePlayerMoney(playerid, p[playerid][kasa]);
		SetPlayerScore(playerid, p[playerid][level]);
		p[playerid][zalogowany] = 1;
		p[playerid][plog] = 1;
	    SendClientMessage(playerid, niebieski, "[Serwer] Zalogowano pomyœlnie!");
	    SpawnPlayer(playerid);
   		return 1;
	}
	else
	{
		ShowPlayerDialog(playerid, logowanie, DIALOG_STYLE_PASSWORD, "Logowanie", "Wyst¹pi³ b³¹d!\nPoda³eœ nieprawid³owe has³o do konta\nSpróbuj ponownie!", "Zaloguj", "Anuluj");
	}
	return 1;
}

public ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;

		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		//radi = 2.0; //Trigger Radius
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(!BigEar[i])
				{
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
					{
					    if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
					    {
							SendClientMessage(i, col1, string);
						}
					}
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
					{
                        if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
                        {
							SendClientMessage(i, col2, string);
						}
					}
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
					{
					    if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
					    {
							SendClientMessage(i, col3, string);
						}
					}
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
					{
					    if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
					    {
							SendClientMessage(i, col4, string);
						}
					}
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
					{
                        if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
                        {
							SendClientMessage(i, col5, string);
						}
					}
    	}
				else
				{
					SendClientMessage(i, col1, string);
				}
			}
		}
	}//not connected
	return 1;
}

public thorus_OnPlayerDataSave(playerid)
{
	format(bq, sizeof bq, "update `players` set `kasa`='%d',`level`='%d',`exp`='%d',`wexp`='%d', `skin`='%d',`prawko`='%d',`pilotaz`='%d',`motor`='%d',`lickabron`='%d',`admin`='%d',`vip`='%d',`praca`='%d',`idf`='%d',`ranga`='%d' where `login`='%s'",
    p[playerid][kasa],
	p[playerid][level],
	p[playerid][exp],
	p[playerid][wexp],
 	p[playerid][skin],
    p[playerid][prawko],
    p[playerid][pilotaz],
    p[playerid][motor],
    p[playerid][lickabron],
    p[playerid][admin],
    p[playerid][vip],
    p[playerid][praca],
    p[playerid][idf],
    p[playerid][ranga],
    PlayerName(playerid));
    mysql_query(bq);
    // zapis broni
    new wammo, wammo2,wammo3;
    GetPlayerWeaponData(playerid, 0, p[playerid][slot], wammo);
    GetPlayerWeaponData(playerid, 1, p[playerid][slot1], wammo2);
    GetPlayerWeaponData(playerid, 2, p[playerid][slot2], p[playerid][ammo2]);
    GetPlayerWeaponData(playerid, 3, p[playerid][slot3], p[playerid][ammo3]);
    GetPlayerWeaponData(playerid, 4, p[playerid][slot4], p[playerid][ammo4]);
    GetPlayerWeaponData(playerid, 5, p[playerid][slot5], p[playerid][ammo5]);
    GetPlayerWeaponData(playerid, 6, p[playerid][slot6], p[playerid][ammo6]);
    GetPlayerWeaponData(playerid, 9, p[playerid][slot9], p[playerid][ammo9]);
    GetPlayerWeaponData(playerid, 10, p[playerid][slot10], wammo3);
    if(wammo == 0)
    {
        p[playerid][slot] = 0;
	}
	if(wammo2 == 0)
	{
	    p[playerid][slot1] = 0;
	}
	if(p[playerid][ammo2] == 0)
	{
	    p[playerid][slot2] = 0;
	}
	if(p[playerid][ammo3] == 0)
	{
	    p[playerid][slot3] = 0;
	}
	if(p[playerid][ammo4] == 0)
	{
	    p[playerid][slot4] = 0;
	}
	if(p[playerid][ammo5] == 0)
	{
	    p[playerid][slot5] = 0;
	}
	if(p[playerid][ammo6] == 0)
	{
	    p[playerid][slot6] = 0;
	}
	if(p[playerid][ammo9] == 0)
	{
	    p[playerid][slot9] = 0;
	}
	if(wammo3 == 0)
	{
	    p[playerid][slot10] = 0;
	}
    format(bq, sizeof bq, "update `players` set `slot`='%d',`slot1`='%d',`slot2`='%d',`ammo2`='%d',`slot3`='%d',`ammo3`='%d',`slot4`='%d',`ammo4`='%d',`slot5`='%d',`ammo5`='%d',`slot6`='%d',`ammo6`='%d',`slot9`='%d',`ammo9`='%d',`slot10`='%d' where `login`='%s'",
    p[playerid][slot],
    p[playerid][slot1],
    p[playerid][slot2],
    p[playerid][ammo2],
    p[playerid][slot3],
    p[playerid][ammo3],
    p[playerid][slot4],
    p[playerid][ammo4],
    p[playerid][slot5],
    p[playerid][ammo5],
    p[playerid][slot6],
    p[playerid][ammo6],
    p[playerid][slot9],
    p[playerid][ammo9],
    p[playerid][slot10],
    PlayerName(playerid));
    mysql_query(bq);
	return 1;
}

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
forward pds(Float:radi, playerid, targetid);
public pds(Float:radi, playerid, targetid)
{
    if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		//radi = 2.0; //Trigger Radius
		GetPlayerPos(targetid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
		    if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid))
		    {
				return 1;
			}
		}
	}
	return 0;
}

stock PlayerName(playerid)
{
	new name[24];
	GetPlayerName(playerid, name, 24);
	return name;
}

public thorus_ShowStatsPlayer(playerid)
{
	new prac[20];
	switch(p[playerid][praca])
	{
	    case 0: prac = "Bezrobotny";
	    case 1:	prac = "Diler broni";
	    case 2: prac = "Diler dragów";
	    case 3: prac = "Medyk";
	}
	new premium[4];
	switch(p[playerid][vip])
	{
	    case 0: premium = "Nie";
	    case 1: premium = "Tak";
	}
	new praw[4];
	switch(p[playerid][prawko])
	{
	    case 0: praw = "Nie";
	    case 1: praw = "Tak";
	}
	new mot[4];
	switch(p[playerid][motor])
	{
	    case 0: mot = "Nie";
	    case 1: mot = "Tak";
	}
	new licka[4];
	switch(p[playerid][lickabron])
	{
	    case 0: licka = "Nie";
	    case 1: licka = "Tak";
	}
	new pil[4];
	switch(p[playerid][pilotaz])
	{
	    case 0: pil = "Nie";
	    case 1: pil = "Tak";
	}
	new statys[256];
	format(sq, sizeof sq, "-=-=-=-=-=-=-=-=-=-=-=-= | %s | -=-=-=-=-=-=-=-=-=-=-=-=", PlayerName(playerid));
	SendClientMessage(playerid, zielony, sq);
	format(statys, sizeof statys, "Poziom: %d - Doœwiadczenie: %d - Wymagane doœwiadczenie: %d - Gotówka: %d - Praca: %s - Konto premium: %s",
	p[playerid][level], p[playerid][exp], p[playerid][wexp], p[playerid][kasa], prac, premium);
	SendClientMessage(playerid, zolty, statys);
	format(statys, sizeof statys, "Prawojazdy kat. B: %s - Prawojazdy kat. A: %s - Pozwolenie na broñ: %s - Mo¿liwoœæ pilota¿u: %s", praw, mot, licka, pil);
	SendClientMessage(playerid, zolty, statys);
	return 1;
}

stock IsNumeric(const str[])
{

	new len = strlen(str);

	for(new x = len - 1; x > 0; x--)

		if(str[x] > '9' || str[x] < '0')

			return 0;



    if(str[0] > '9' || str[0] <'0')

        return (len > 1 && (str[0] == '-' || str[0] == '+'));



    return 1;

}

public thorus_ChangePassword(playerid, password[])
{
	if(strlen(password) < 4 || strlen(password) > 24)
	    return ShowPlayerDialog(playerid, zmienhaslo, DIALOG_STYLE_PASSWORD, "Zmiana has³a", "Wyst¹pi³ b³¹d!\nHas³o nie spe³nia wymagañ dotycz¹cych d³ugoœci(4-24 znaki)\nPodaj jeszcze raz", "Zmieñ", "Anuluj");

	format(mq, sizeof mq, "update `haslo` set `haslo`='%s' where `login`='%s'", password, PlayerName(playerid));
	mysql_query(mq);
	mysql_free_result();
	SendClientMessage(playerid, zielony, "[Serwer] Zmieni³eœ has³o, obowi¹zuje one od nastêpnego logowania.");
	return 1;
}

public thorus_AdminMessage(who[], message[])
{
	new g2,m,s;
	gettime(g2,m,s);
	for(new y=1; y <= MAX_PLAYERS; y++)
	{
	    if(p[y][admin] >= 1)
	    {
	        format(mq, sizeof mq, "[ADMIN] [%d:%d:%d] %s: %s", g2,m,s,who, message);
	        SendClientMessage(y, admincolor, mq);
		}
	}
	return 1;
}

public thorus_loadVeh()
{
	new vid3 = 1;
	print("[system] wczytywanie pojazdow..");
	mysql_query("SELECT * FROM `veh`");
	mysql_store_result();
	vid3++;
	new fetch[128];
	while(mysql_fetch_row_format(fetch, "|"))
	{
	    new uid;
	    sscanf(fetch, "p<|>d", uid);
	    sscanf(fetch, "p<|>ddffffdddddd",
	    uid,
	    v[uid][model],
	    v[uid][vx],
	    v[uid][vy],
	    v[uid][vz],
	    v[uid][va],
	    v[uid][kolor],
	    v[uid][kolor2],
	    v[uid][typ],
	    v[uid][fid],
	    v[uid][cena],
	    v[uid][ido]
		);
	 	v[uid][vid] = uid;
		if(v[uid][model] != 0)
		{
		    thorus_CreateVehicleFromDB(uid);
		}
		ile++;
	}
	mysql_free_result();
	printf("[system] %d pojazd(ow) wczytanych", ile);
	return 1;
}

public thorus_CreateVehicleFromDB(uid)
{
	new pointer = CreateVehicle(v[uid][model],v[uid][vx],v[uid][vy],v[uid][vz],v[uid][va],v[uid][kolor],v[uid][kolor2], -1);
	v[uid][vid] = uid;
	return pointer;
}

public thorus_saveVeh(idv)
{
	new savedane[256];
	format(savedane, sizeof savedane, "update `veh` set `model`='%d', `vx`='%f', `vy`='%f', `vz`='%f', `va`='%f', `kolor`='%d', `kolor2`='%d', `typ`='%d', `fid`='%d', `cena`='%d', `ido`='%d' where `id`='%d'",
	v[idv][model],
	v[idv][vx],
	v[idv][vy],
	v[idv][vz],
	v[idv][va],
	v[idv][kolor],
	v[idv][kolor2],
	v[idv][typ],
	v[idv][fid],
	v[idv][cena],
	v[idv][ido],
	idv);
	mysql_query(savedane);
	return 1;
}

public thorus_listVeh(playerid)
{
	new dgui[512];
	new query[32];
	new ile2 = 0;
	for(new i = 1; i <= ile; i++)
	{
		if(v[i][ido] == p[playerid][id] && v[i][typ] == 2)
		{
			format(query, sizeof(query), "%d - %s\n", v[i][vid], carname[v[i][model]-400]);
 			strcat(dgui, query);
  			ile2++;
		}
	}
	if(!ile2)
	{
	    strcat(dgui, "Nie posiadasz ¿adnego samochodu.");
	    return 1;
	}
	ShowPlayerDialog(playerid, ppanel, DIALOG_STYLE_LIST, "Panel pojazdów", dgui, "Wybierz", "Anuluj");
	return 1;
}

public thorus_orgChat(playerid, text[])
{
	new ff[128];
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(p[i][idf] == p[playerid][idf])
	    {
	        switch(p[playerid][ranga])
	        {
	            case 1:
	            {
	                format(ff, sizeof ff, "[ORG-CHAT] %s %s: %s", org[p[playerid][idf]][r_nazwa], PlayerName(playerid), text);
	                SendClientMessage(i, org_chat, ff);
				}
				case 2:
				{
	                format(ff, sizeof ff, "[ORG-CHAT] %s %s: %s", org[p[playerid][idf]][r_nazwa2], PlayerName(playerid), text);
	                SendClientMessage(i, org_chat, ff);
				}
				case 3:
				{
	                format(ff, sizeof ff, "[ORG-CHAT] %s %s: %s", org[p[playerid][idf]][r_nazwa3], PlayerName(playerid), text);
	                SendClientMessage(i, org_chat, ff);
				}
				case 4:
				{
	                format(ff, sizeof ff, "[ORG-CHAT] %s %s: %s", org[p[playerid][idf]][r_nazwa4], PlayerName(playerid), text);
	                SendClientMessage(i, org_chat, ff);
				}
				case 5:
				{
	                format(ff, sizeof ff, "[ORG-CHAT] %s %s: %s", org[p[playerid][idf]][r_nazwa5], PlayerName(playerid), text);
	                SendClientMessage(i, org_chat, ff);
				}
				case 6:
				{
	                format(ff, sizeof ff, "[ORG-CHAT] %s %s: %s", org[p[playerid][idf]][r_nazwa6], PlayerName(playerid), text);
	                SendClientMessage(i, org_chat, ff);
				}
				case 7:
				{
	                format(ff, sizeof ff, "[ORG-CHAT] %s %s: %s", org[p[playerid][idf]][r_nazwa7], PlayerName(playerid), text);
	                SendClientMessage(i, org_chat, ff);
				}
				case 8:
				{
	                format(ff, sizeof ff, "[ORG-CHAT] %s %s: %s", org[p[playerid][idf]][r_nazwa8], PlayerName(playerid), text);
	                SendClientMessage(i, org_chat, ff);
				}
				case 9:
				{
	                format(ff, sizeof ff, "[ORG-CHAT] %s %s: %s", org[p[playerid][idf]][r_nazwa9], PlayerName(playerid), text);
	                SendClientMessage(i, org_chat, ff);
				}
				case 10:
				{
	                format(ff, sizeof ff, "[ORG-CHAT] %s %s: %s", org[p[playerid][idf]][r_nazwa10], PlayerName(playerid), text);
	                SendClientMessage(i, org_chat, ff);
				}
				default:
				{
	                format(ff, sizeof ff, "[ORG-CHAT] %s: %s", PlayerName(playerid), text);
	                SendClientMessage(i, org_chat, ff);
				}
			}
		}
	}
	return 1;
}

public thorus_orgMessage(o_id, text[])
{
	for(new i; i <= MAX_PLAYERS; i++)
	{
	    if(p[i][idf] != 0 && p[i][ranga] != 0)
	    {
	        if(p[i][idf] == o_id)
	        {
	            SendClientMessage(i, org_info, text);
			}
		}
	}
}

public thorus_orgAdd(o_name[24], o_typ, Float:o_x, Float:o_y, Float:o_z, Float:o_a)
{
	new insert[128];
	format(insert, sizeof insert, "INSERT INTO `org` (`nazwa`,`typ`,`x`,`y`,`z`,`a`) VALUES ('%s', '%d', '%f', '%f', '%f', '%f')",
	o_name,
	o_typ,
	o_x,
	o_y,
	o_z,
	o_a);
	mysql_query(insert);
	new uid = mysql_insert_id();
	org[uid][oid] = uid;
	org[uid][onazwa] = o_name;
	org[uid][typ] = o_typ;
	org[uid][ox] = o_x;
	org[uid][oy] = o_y;
	org[uid][oz] = o_z;
	org[uid][oa] = o_a;
	printf("[System] Stworzono organizacje o ID: %d | Nazwa: %s", uid, o_name);
	return 1;
}

public thorus_orgDel(idorg)
{
	new del[128];
	format(del, sizeof del, "delete from `org` where `id`='%d'", idorg);
	mysql_query(del);
	for(new i; i <= MAX_PLAYERS; i++)
	{
	    if(p[i][idf] == idorg)
	    {
	        p[i][idf] = 0;
	        p[i][ranga] = 0;
	        SendClientMessage(i, org_info, "[ORG-INFO] Organizacja zosta³a usuniêta przez administratora.");
		}
	}
	format(del, sizeof del, "update `players` set `idf`='0', `ranga`='0' where `idf`='%d'", idorg);
	mysql_query(del);
	format(del, sizeof del, "update `veh` set `fid`='0', `typ`='0' where `fid`='%d'", idorg);
	mysql_query(del);
	org[idorg][oid] = 0;
	org[idorg][onazwa] = 0;
	org[idorg][typ] = 0;
	org[idorg][ox] = 0;
	org[idorg][oy] = 0;
	org[idorg][oz] = 0;
	org[idorg][oa] = 0;
	printf("[System] Usunieto organizacje ID: %d", idorg);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	switch(newkeys)
	{
	    case KEY_SPRINT:
	    {
	        return cmd_drzwi(playerid, "");
		}
	}
	return 1;
}

Action(playerid, akcja[])
{
	new tresc[128];
    format(tresc, sizeof(tresc), "[Akcja] %s %s", PlayerName(playerid), akcja);
    SendClientLocalMessage(30.0, playerid, tresc, rozowy, rozowy,rozowy,rozowy,rozowy);
    return 1;
}

public WH(playerid)
{
	new wslot, wslot1, wslot2, wslot3, wslot4, wslot5, wslot6, wslot7, wslot8, wslot9, wslot10, wslot11, wslot12;
	new wammo;
	GetPlayerWeaponData(playerid, 0, wslot, wammo);
	GetPlayerWeaponData(playerid, 1, wslot1, wammo);
	GetPlayerWeaponData(playerid, 2, wslot2, wammo);
	GetPlayerWeaponData(playerid, 3, wslot3, wammo);
	GetPlayerWeaponData(playerid, 4, wslot4, wammo);
	GetPlayerWeaponData(playerid, 5, wslot5, wammo);
	GetPlayerWeaponData(playerid, 6, wslot6, wammo);
	GetPlayerWeaponData(playerid, 7, wslot7, wammo);
	GetPlayerWeaponData(playerid, 8, wslot8, wammo);
	GetPlayerWeaponData(playerid, 9, wslot9, wammo);
	GetPlayerWeaponData(playerid, 10, wslot10, wammo);
	GetPlayerWeaponData(playerid, 11, wslot11, wammo);
	GetPlayerWeaponData(playerid, 12, wslot12, wammo);
	if(wslot != p[playerid][slot] || wslot1 != p[playerid][slot1] || wslot2 != p[playerid][slot2] || wslot3 != p[playerid][slot3] || wslot4 != p[playerid][slot4] || wslot5 != p[playerid][slot5] || wslot6 != p[playerid][slot6] || wslot7 != 0 || wslot8 != 0 || wslot9 != p[playerid][slot9] || wslot10 != p[playerid][slot10] || wslot11 != 0 || wslot12 != 0)
	{
	    format(txt, sizeof txt, "[UWAGA] %s zespawnowa³ broñ wykryt¹ przez skrypt jako WH.", PlayerName(playerid));
	    SendClientMessageToAll(0xff3030, txt);
	    ResetPlayerWeapons(playerid);
	}
	return 1;
}

public Drunk(playerid, drunklevel)
{
	new czas;
	SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid)+drunklevel);
	if(GetPlayerDrunkLevel(playerid) >= 2000)
	{
		SendClientMessage(playerid, pomaranczowy, "[INFO] Jesteœ pijany!");
	}
	if(GetPlayerDrunkLevel(playerid) < 48000)
	{
 		czas = 2000+GetPlayerDrunkLevel(playerid);
	}
	if(GetPlayerDrunkLevel(playerid) > 48000)
	{
	    Action(playerid, "jest zbyt pijany, ¿eby wypiæ coœ wiêcej.");
	    SendClientMessage(playerid, zolty, "[INFO] Barman Ci ju¿ nie naleje!");
	    return 0;
	}
	SetTimerEx("UnDrunk", czas, false, "d", playerid);
	return 1;
}

public unDrunk(playerid)
{
    SetPlayerDrunkLevel(playerid, 0);
    SendClientMessage(playerid, zolty, "[INFO] WytrzeŸwia³eœ!");
    return 1;
}

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

public OnPlayerCommandReceived(playerid, cmdtext[]) // przed
{
	if(p[playerid][zalogowany] == 0)
	{
	    SendClientMessage(playerid, zolty, "[Serwer] Najpierw musisz siê zalogowaæ! ");
	}
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success) 
{
	if(!success)
	{
	    SendClientMessage(playerid, zolty, "[Serwer] Taka komenda nie istnieje! Wpisz /komendy ");
	}
	return 1;
}

CMD:komendy(playerid, params[])
{
	SendClientMessage(playerid, zielony, "------------------------------------------------- | Lista Komend | -------------------------------------------------");
	SendClientMessage(playerid, zolty, "/statystyki - /zmienhaslo - /me - /pw - /do - /b - /go - /report - /dajkase - /orgcmd - /drzwi -/sprzedajpojazd");
	SendClientMessage(playerid, zielony, "---------------------------------------------------------------------------------------------------------------------");
	return 1;
}

CMD:orgcmd(playerid, params[])
{
    SendClientMessage(playerid, zielony, "------------------------------------------------- | Lista Komend | -------------------------------------------------");
	SendClientMessage(playerid, zolty, "/o - czat organizacji.");
	SendClientMessage(playerid, zolty, "/odejdz - opuszczasz organizacje.");
	SendClientMessage(playerid, zolty, "/zmienrange - tylko dla liderów, zmienia rangê gracza w organizacji.");
	SendClientMessage(playerid, zolty, "/wyrzuc - tylko dla liderów, wyrzuca gracza z organizacji.");
	SendClientMessage(playerid, zolty, "/zapros - tylko dla liderów, wysy³a zaproszenie do gracza.");
	return 1;
}

CMD:o(playerid, params[])
{
	if(p[playerid][idf] == 0|| p[playerid][ranga] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nie nale¿ysz do organizacji.");
	new tresc[128];
	if(sscanf(params, "s[128]", tresc))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /o <treœæ>");
	    
	thorus_orgChat(playerid, tresc);
	return 1;
}

CMD:odejdz(playerid, params[])
{
	if(p[playerid][idf] == 0 || p[playerid][ranga] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nie jesteœ w organizacji.");

	if(p[playerid][ranga] == 1)
        return SendClientMessage(playerid, zolty, "[B£¥D] Nie mo¿esz opuœciæ organizacji dopóki jesteœ jej liderem.");
        
	new ide = p[playerid][idf];
	p[playerid][idf] = 0;
	p[playerid][ranga] = 0;
	SendClientMessage(playerid, zolty, "[INFO] Opuœci³eœ organizacje.");
	format(txt, sizeof txt, "[ORG-INFO] %s opuœci³ organizacje.", PlayerName(playerid));
	thorus_orgMessage(ide, txt);
	return 1;
}

CMD:dajkase(playerid, params[])
{
	new ids, kwota;
	if(sscanf(params, "dd", ids, kwota))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /dajkase <id> <kwota>");
	    
	if(IsPlayerConnected(id) == 0)
        return SendClientMessage(playerid, zolty, "[B£¥D] Ten gracz nie jest zalogowany.");
        
	if(p[playerid][kasa] < kwota)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nie masz tyle gotówki.");
	    
	if(pds(5.0, playerid, ids))
	{
		GivePlayerMoney(playerid, -kwota);
		GivePlayerMoney(id, kwota);
		format(mq, sizeof mq, "%s podaje gotówkê innej osobie.", PlayerName(playerid));
    	SendClientLocalMessage(30.0, playerid, mq, rozowy, rozowy,rozowy,rozowy,rozowy);
    	format(mq, sizeof mq, "%s da³ Ci %d$.", PlayerName(playerid), kwota);
    	SendClientMessage(ids, niebieski, mq);
    	format(mq, sizeof mq, "Da³eœ graczowi %s kwote %d$.", PlayerName(ids), kwota);
    	SendClientMessage(playerid, niebieski, mq);
	}
	else
	{
	    SendClientMessage(playerid, zolty, "[B£¥D] Jesteœ za daleko od tego gracza!");
	}
	return 1;
}

CMD:report(playerid, params[])
{
	new rep[128], pid;
	if(sscanf(params, "ds[128]", pid, rep))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /report <id> <treœæ>");
	    
	if(p[pid][zalogowany] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Ten gracz nie jest zalogowany.");
	    
	format(txt, 128, "%s(%d) reportuje %s(%d), powód: %s", PlayerName(playerid), playerid, PlayerName(pid), pid, rep);
	thorus_AdminMessage("System", txt);
	SendClientMessage(playerid, zielony, "[System] Zg³oszenie zosta³o wys³ane.");
	return 1;
}

CMD:go(playerid, params[])
{
    new mee[128];
	if(sscanf(params, "s[128]", mee))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /go <treœæ>");
	    
	if(gstatus == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Globalne OOC jest wy³¹czone!");
	    
	format(mq, sizeof mq, "[Global OOC] %s: %s.", PlayerName(playerid), mee);
	SendClientMessageToAll(0x3A4EFFCC, mq);
	return 1;
}

CMD:b(playerid, params[])
{
	new mee[128];
	if(sscanf(params, "s[128]", mee))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /b <treœæ>");

	format(mq, sizeof mq, "[Lokalne OOC]%s: %s.", PlayerName(playerid), mee);
    SendClientLocalMessage(20.0, playerid, mq, pomaranczowy, pomaranczowy,pomaranczowy,pomaranczowy,pomaranczowy);
    return 1;
}


CMD:do(playerid, params[])
{
	new mee[128];
	if(sscanf(params, "s[128]", mee))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /do <akcja>");

	format(mq, sizeof mq, "[%s] %s.", PlayerName(playerid), mee);
    SendClientLocalMessage(30.0, playerid, mq, pomaranczowy, pomaranczowy,pomaranczowy,pomaranczowy,pomaranczowy);
    return 1;
}

CMD:pw(playerid, params[])
{
	new pww[128], pid;
	if(sscanf(params, "us[128]", pid, pww))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /pw <id/Nick> <treœæ wiadomoœci>");
	    
	if(p[pid][zalogowany] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Ten gracz nie jest zalogowany.");
	    
	if(strlen(pww) < 1 || strlen(pww) > 128)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Wiadomoœæ musi siê mieœciæ w przedziale 1-128 znaków.");
	    
	new min2,god,sek;
	gettime(god, min2, sek);
	format(mq, sizeof mq, "[%d:%d:%d] %s(ID:%d) : %s.",god,min2,sek,PlayerName(playerid), playerid, pww);
	SendClientMessage(pid, zielony, mq);
	format(mq, sizeof mq, "[%d:%d:%d] %s(ID:%d) : %s.",god,min2,sek,PlayerName(pid), id, pww);
	SendClientMessage(playerid, pomaranczowy, mq);
	return 1;
}

CMD:me(playerid, params[])
{
	new mee[128];
	if(sscanf(params, "s[128]", mee))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /me <akcja>");
	    
    format(mq, sizeof mq, "%s %s", PlayerName(playerid), mee);
    SendClientLocalMessage(30.0, playerid, mq, rozowy, rozowy,rozowy,rozowy,rozowy);
    return 1;
}

CMD:zmienhaslo(playerid, params[])
{
    ShowPlayerDialog(playerid, zmienhaslo, DIALOG_STYLE_PASSWORD, "Zmiana has³a", "Podaj nowe has³o do konta:", "Zmieñ", "Anuluj");
	return 1;
}

CMD:statystyki(playerid, params[])
{
    thorus_ShowStatsPlayer(playerid);
    return 1;
}

CMD:stats(playerid, params[])
{
	return cmd_statystyki(playerid, params);
}

CMD:stat(playerid, params[])
{
	return cmd_statystyki(playerid, params);
}

CMD:staty(playerid, params[])
{
	return cmd_statystyki(playerid, params);
}

CMD:sprzedajpojazd(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Musisz byæ w pojeŸdzie.");

    new uid = GetPlayerVehicleID(playerid);
	if(v[uid][ido] != p[playerid][id])
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nie jesteœ w³aœcicielem tego pojazdu.");

	new idg, kwota;
	if(sscanf(params, "dd", idg, kwota))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /sprzedajpojazd <id gracza> <kwota>");
	    
	if(kwota < 1 || kwota > 99999999)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owa kwota.");
	    
	pkwota[idg] = kwota;
	opojazd[idg] = 1;
	p_id[idg] = uid;
	p_uid[idg] = playerid;
	format(txt, sizeof txt, "[INFO] %s oferuje Ci pojazd %s za kwote %d$. Jeœli chcesz kupiæ pojazd wpisz /akceptuj pojazd",
	PlayerName(playerid),
	carname[uid],
	kwota);
	SendClientMessage(idg, niebieski, txt);
	return 1;
}

CMD:akceptuj(playerid, params[])
{
	if(isnull(params))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /akceptuj <czynnoœæ>"), SendClientMessage(playerid, zolty, "Czynnoœci: pojazd | organizacja");
	    
	if(!strcmp(params, "pojazd"))
	{
	    if(p_id[playerid] == 0 || opojazd[playerid] == 0 || pkwota[playerid] == 0 || p_uid[playerid] == 0)
	        return SendClientMessage(playerid, zolty, "[B£¥D] Brak oferty.");
	        
		if(p[playerid][kasa] < pkwota[playerid])
		    return SendClientMessage(playerid, zolty, "[B£¥D] Nie masz przy sobie tyle gotówki.");
		    
		if(!IsPlayerConnected(p_uid[playerid]))
		    return SendClientMessage(playerid, zolty, "[B£¥D] Gracz nie jest zalogowany.");
		    
  		GivePlayerMoney(playerid, -pkwota[playerid]);
		p[playerid][kasa] -= pkwota[playerid];
		GivePlayerMoney(p_uid[playerid], pkwota[playerid]);
		p[p_uid[playerid]][kasa] -= pkwota[playerid];
		v[p_id[playerid]][ido] = p[playerid][id];
		thorus_saveVeh(p_id[playerid]);
		SendClientMessage(p_uid[playerid], niebieski, "[INFO] Sprzedano pojazd.");
		pkwota[playerid] = 0;
		opojazd[playerid] = 0;
		p_id[playerid] = 0;
		p_uid[playerid] = 0;
		SendClientMessage(playerid, niebieski, "[INFO] Kupiono pojazd.");
	}
	else if(!strcmp(params, "organizacja"))
	{
	    if(ooid[playerid] == 0 || oorg[playerid] == 0)
	        return SendClientMessage(playerid, zolty, "[B£¥D] Brak oferty.");
	        
		p[playerid][idf] = ooid[playerid];
		p[playerid][ranga] = 2;
		format(txt, sizeof txt, "[ORG-INFO] %s do³¹czy³ do frakcji.", PlayerName(playerid));
        thorus_orgMessage(ooid[playerid], txt);
		SetPlayerSkin(playerid, org[ooid[playerid]][r_skin2]);
		SetPlayerPos(playerid, org[ooid[playerid]][ox], org[ooid[playerid]][oy], org[ooid[playerid]][oz]);
		SetPlayerFacingAngle(playerid, org[ooid[playerid]][oa]);
		oorg[playerid] = 0;
		ooid[playerid] = 0;
		SendClientMessage(playerid, pomaranczowy, "[INFO] Do³¹czono do organizacji.");
	}
	return 1;
}

CMD:kuppojazd(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Musisz byæ w pojeŸdzie.");

    new uid = GetPlayerVehicleID(playerid);
    
    if(v[uid][typ] != 3 && v[uid][cena] == 0 && v[uid][ido] != 0)
        return SendClientMessage(playerid, zolty, "[B£¥D] Ten pojazd nie jest na sprzeda¿! ");
        
	if(p[playerid][kasa] < v[uid][cena])
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nie masz tyle gotówki.");
	    
	GivePlayerMoney(playerid, -v[uid][cena]);
	v[uid][ido] = p[playerid][id];
	v[uid][typ] = 2;
	v[uid][cena] = 0;
	SendClientMessage(playerid, niebieski, "[INFO] Kupiono pojazd. Wpisz /ppanel - uzyskasz dostêp do panelu swoich pojazdów.");
	return 1;
}

CMD:ppanel(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
	    if(v[GetPlayerVehicleID(playerid)][ido] == p[playerid][id])
	    {
	    	vehicleuid[playerid] = GetPlayerVehicleID(playerid);
	    	ShowPlayerDialog(playerid, ppanel2, DIALOG_STYLE_LIST, "Co chcesz zrobiæ?", "Zmiania koloru pierwszego\nZmiana koloru drugiego\nZaparkowanie pojazdu\nTeleport do pojazdu\nPrzywo³anie pojazdu", "Wybierz", "Anuluj");
		}
	}
	else
	{
		thorus_listVeh(playerid);
	}
	return 1;
}

// CMD moderator

CMD:mstat(playerid, params[])
{
	if(p[playerid][admin] < 1)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	new ids = strval(params);
	if(IsPlayerConnected(ids) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nie ma takiego gracza.");
	    
    thorus_ShowStatsPlayer(ids);
    return 1;
}

CMD:kick(playerid, params[])
{
    if(p[playerid][admin] < 1)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
    new ids = strval(params);
	if(IsPlayerConnected(ids) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nie ma takiego gracza.");
	    
	Kick(ids);
	format(txt, sizeof txt, "%s wyrzuci³ z serwera %s.", PlayerName(playerid), PlayerName(ids));
    SendClientMessageToAll(admincolor, txt);
    return 1;
}

// CMD administrator

CMD:acmd(playerid, params[])
{
    if(p[playerid][admin] < 2)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	SendClientMessage(playerid, zielony, " -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= | Admin system CMD | =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
    SendClientMessage(playerid, admincolor, "/acarcmd - lista komend dla systemu pojazdów v2.");
    SendClientMessage(playerid, admincolor, "/aorgcmd - lista komend dla systemu organizacji v2.");
    SendClientMessage(playerid, admincolor, "/abudcmd - lista komend dla systemu budynków v2.");
    SendClientMessage(playerid, admincolor, "/abizcmd - lista komend dla systemu biznesów v3.");
    return 1;
}

CMD:acarcmd(playerid, params[])
{
    if(p[playerid][admin] < 2)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	SendClientMessage(playerid, zielony, " -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= | Car system CMD | =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
 	SendClientMessage(playerid, admincolor, "/agotocar - teleportuje do pojazdu");
 	SendClientMessage(playerid, admincolor, "/agetherecar - teleportuje do nas pojazd");
 	SendClientMessage(playerid, admincolor, "/acarinfo - pokazuje szczegó³owe informacje o pojeŸdzie");
 	SendClientMessage(playerid, admincolor, "/acarpark - zapisuje pozycje pojazdu(parkuje go)");
 	SendClientMessage(playerid, admincolor, "/acarcolor - zmienia kolor nr 1");
 	SendClientMessage(playerid, admincolor, "/acarcolor2 - zmienia kolor nr 2");
 	SendClientMessage(playerid, admincolor, "/acarprice - ustawia cene pojazdu");
 	SendClientMessage(playerid, admincolor, "/acartyp - ustawia typ pojazdu");
 	SendClientMessage(playerid, admincolor, "/acarmodel - ustawia model pojazdu");
	SendClientMessage(playerid, admincolor, "/acaradd - dodaje pojazd z ustawieniami domyœlnymi");
	SendClientMessage(playerid, admincolor, "/acarsell - wystawia pojazd na sprzeda¿");
	SendClientMessage(playerid, admincolor, "/acarido - ustawia id w³aœciciela");
	SendClientMessage(playerid, admincolor, "/acarorg - zmienia id organizacji pojazdu.");
 	return 1;
}

CMD:acarido(playerid, params[])
{
    if(p[playerid][admin] < 2)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

    if(IsPlayerInAnyVehicle(playerid) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Musisz byæ w pojeŸdzie.");

    new uid = GetPlayerVehicleID(playerid);
    new ids;
	if(sscanf(params, "d", ids))
 		return SendClientMessage(playerid, zolty, "[U¯YCIE] /acarido <id w³aœciciela> .");
 		
	format(sq, sizeof sq, "select `id` from `players` where `id`='%d'", ids);
	mysql_query(sq);
	mysql_store_result();
	if(!mysql_num_rows())
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nie ma takiego gracza.");
	    
	mysql_free_result();
	v[uid][ido] = ids;
	return 1;
}

CMD:acarsell(playerid, params[])
{
    if(p[playerid][admin] < 2)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

    if(IsPlayerInAnyVehicle(playerid) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Musisz byæ w pojeŸdzie.");

    new uid = GetPlayerVehicleID(playerid);
    new ids;
	if(sscanf(params, "d", ids))
 		return SendClientMessage(playerid, zolty, "[U¯YCIE] /acarsell <cena> .");
 		
    if(ids < 1 || ids > 99999999)
		return SendClientMessage(playerid, zolty, "[B£¥D] Cena musi mieœciæ siê w zakresie 1-99999999$.");
		
	v[uid][typ] = 3;
	v[uid][cena] = ids;
	v[uid][ido] = 0;
	SendClientMessage(playerid, admincolor, "[INFO] Wystawiono pojazd na sprzeda¿.");
	return 1;
}
 		
CMD:acaradd(playerid, params[])
{
    if(p[playerid][admin] < 2)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
    	
	new Float:px, Float:py, Float:pz, Float:pa;
	new uid;
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, pa);
	new addcar[128];
	format(addcar, sizeof addcar, "insert into `veh` (`vx`, `vy`,`vz`,`va`) values ('%f', '%f', '%f', '%f')");
	mysql_query(addcar);
	uid = mysql_insert_id();
	v[uid][vid] = uid;
	v[uid][model] = 481;
    v[uid][vx] = px;
    v[uid][vy] = py;
    v[uid][vz] = px;
    v[uid][va] = pa;
    v[uid][kolor] = 1;
    v[uid][kolor2] = 2;
    v[uid][typ] = 0;
    v[uid][fid] = 0;
    v[uid][cena] = 0;
    v[uid][ido] = 0;
    new sid = CreateVehicle(v[uid][model], v[uid][vx], v[uid][vy], v[uid][vz], v[uid][va], v[uid][kolor], v[uid][kolor2], -1);
    PutPlayerInVehicle(playerid, uid, 0);
    format(addcar, sizeof addcar, "[INFO] Stworzono pojazd: UID: %d | sampID: %d", uid, sid);
    SendClientMessage(playerid, admincolor, addcar);
    return 1;
}
CMD:acarmodel(playerid, params[])
{
    if(p[playerid][admin] < 2)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

    if(IsPlayerInAnyVehicle(playerid) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Musisz byæ w pojeŸdzie.");
	    
    new uid = GetPlayerVehicleID(playerid);
    new ids;
	if(sscanf(params, "d", ids))
 		return SendClientMessage(playerid, zolty, "[U¯YCIE] /acarmodel <id modelu> .");
 		
	if(ids < 400 || ids > 611 )
	    return SendClientMessage(playerid, zolty, "[B£¥D] ID modelu: 400-611.");
	    
	if(ids == 441 || ids == 449 || ids == 450 || ids == 464 || ids == 465 || ids == 501 || ids == 537 || ids == 538 || ids == 564 || ids == 569 || ids == 570 || ids == 584 || ids == 590 || ids == 591 || ids == 594 || ids == 606 || ids == 607 || ids == 608 || ids == 610 || ids == 611)
	    return SendClientMessage(playerid, zolty, "[B£¥D] ID tego pojazdu jest nie dozwolone.");

	DestroyVehicle(uid);
	v[uid][model] = ids;
	new Float:px, Float:py, Float:pz, Float:pa;
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, pa);
	CreateVehicle(v[uid][model],px,py,pz,pa,v[uid][kolor],v[uid][kolor2], -1 );
	PutPlayerInVehicle(playerid, uid, 0);
	SendClientMessage(playerid, admincolor, "[INFO] Ustawiono model.");
	return 1;
}

CMD:acarprice(playerid, params[])
{
    if(p[playerid][admin] < 2)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
    	
    if(IsPlayerInAnyVehicle(playerid) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Musisz byæ w pojeŸdzie.");
	    
    new uid = GetPlayerVehicleID(playerid);
    new ids;
	if(sscanf(params, "d", ids))
 		return SendClientMessage(playerid, zolty, "[U¯YCIE] /acarprice <cena> .");

	if(ids < 1 || ids > 99999999)
		return SendClientMessage(playerid, zolty, "[B£¥D] Cena musi mieœciæ siê w zakresie 1-99999999$.");
		
	v[uid][cena] = ids;
	SendClientMessage(playerid, admincolor, "[INFO] Ustawiono cene.");
	return 1;
}

CMD:acartyp(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	if(IsPlayerInAnyVehicle(playerid) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Musisz byæ w pojeŸdzie.");

    new ids;
    if(sscanf(params, "d", ids))
        return SendClientMessage(playerid, zolty, "[U¯YCIE] /acartyp <id typu>.");
        
	if(ids < 0 || ids > 9)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Zakres ID: 0-9.");

	new uid = GetPlayerVehicleID(playerid);
	v[uid][typ] = ids;
	SendClientMessage(playerid, admincolor, "[INFO]Ustawiono typ.");
	return 1;
}

CMD:acarcolor(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	if(IsPlayerInAnyVehicle(playerid) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Musisz byæ w pojeŸdzie.");
	    
    new ids;
    if(sscanf(params, "d", ids))
        return SendClientMessage(playerid, zolty, "[U¯YCIE] /acarcolor <id color>.");
        
	if(ids < 0 || ids > 255)
		return SendClientMessage(playerid, zolty, "[B£¥D] ID kolorów: 0-255.");
		
	new uid = GetPlayerVehicleID(playerid);
	ChangeVehicleColor(uid, ids, v[uid][kolor2]);
	v[uid][kolor] = ids;
	SendClientMessage(playerid, admincolor, "[INFO]Ustawiono kolor.");
	return 1;
}

CMD:acarcolor2(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	if(IsPlayerInAnyVehicle(playerid) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Musisz byæ w pojeŸdzie.");

    new ids;
    if(sscanf(params, "d", ids))
        return SendClientMessage(playerid, zolty, "[U¯YCIE] /acarcolor <id color>.");
        
    if(ids < 0 || ids > 255)
		return SendClientMessage(playerid, zolty, "[B£¥D] ID kolorów: 0-255.");

	new uid = GetPlayerVehicleID(playerid);
	ChangeVehicleColor(uid, v[uid][kolor], ids);
	v[uid][kolor2] = ids;
	SendClientMessage(playerid, admincolor, "[INFO] Ustawiono kolor2.");
	return 1;
}

CMD:acarorg(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	    
    if(IsPlayerInAnyVehicle(playerid) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Musisz byæ w pojeŸdzie.");
	    
	new uid = GetPlayerVehicleID(playerid);
 	new ids;
    if(sscanf(params, "d", ids))
        return SendClientMessage(playerid, zolty, "[U¯YCIE] /acarorg <id org>.");
        
	if(org[ids][oid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Organizacja o takim ID nie istnieje.");
	    
	v[uid][fid] = ids;
	v[uid][typ] = 1;
	SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie zmieniono id organizacji pojazdu.");
	return 1;
}

CMD:acarinfo(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

    new ids;
    if(sscanf(params, "d", ids))
        return SendClientMessage(playerid, zolty, "[U¯YCIE] /acarinfo <id>.");

    if(ids > max_veh)
        return SendClientMessage(playerid, zolty, "[B£¥D] Za du¿e ID.");

	format(txt, sizeof txt, "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= | vehID: %d | =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
	SendClientMessage(playerid, zielony, txt);
	format(txt, sizeof txt, "Model ID: %d | X: %f | Y: %f | Z: %f | A: %f | kolor: %d | kolor2: %d | typ: %d | fid: %d | cena: %d | ido: %d",
	v[ids][model],
    v[ids][vx],
    v[ids][vy],
    v[ids][vz],
    v[ids][va],
    v[ids][kolor],
    v[ids][kolor2],
    v[ids][typ],
    v[ids][fid],
    v[ids][cena],
    v[ids][ido]);
    SendClientMessage(playerid, admincolor, txt);
	return 1;
}

CMD:agetherecar(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

    new ids;
    if(sscanf(params, "d", ids))
        return SendClientMessage(playerid, zolty, "[U¯YCIE] /agetherecar <id>.");

    if(ids > max_veh)
        return SendClientMessage(playerid, zolty, "[B£¥D] Za du¿e ID.");

	new Float:px, Float:py, Float:pz, Float:pa;
	GetPlayerPos(playerid,px,py,pz);
	GetPlayerFacingAngle(playerid, pa);
	SetVehiclePos(ids, px, py, pz);
	SetVehicleZAngle(ids, pa);
	PutPlayerInVehicle(playerid, ids, 0);
	SendClientMessage(playerid, admincolor, "[INFO] Teleportowano.");
	return 1;
}

CMD:agotocar(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	    
    new ids;
    if(sscanf(params, "d", ids))
        return SendClientMessage(playerid, zolty, "[U¯YCIE] /agotocar <id>.");
        
    if(ids > max_veh)
        return SendClientMessage(playerid, zolty, "[B£¥D] Za du¿e ID.");
        
	SetPlayerPos(playerid, v[ids][vx], v[ids][vy], v[ids][vz]+1);
	SendClientMessage(playerid, admincolor, "[INFO] Teleportowano.");
	return 1;
}

CMD:acarpark(playerid, params[])
{
	if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	    
	if(IsPlayerInAnyVehicle(playerid) == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Musisz byæ w pojeŸdzie.");
	    
	new uid = GetPlayerVehicleID(playerid);
	new Float:px, Float:py, Float:pz, Float:pa;
	GetVehiclePos(uid, px, py, pz);
	GetVehicleZAngle(uid, pa);
	v[uid][vx] = px;
	v[uid][vy] = py;
	v[uid][vz] = pz;
	v[uid][va] = pa;
	SendClientMessage(playerid, admincolor, "[INFO] Zapisano pozycje pojazdu.");
    return 1;
}

CMD:aorgcmd(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	    
    SendClientMessage(playerid, zielony, "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= | Org system CMD | =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
    SendClientMessage(playerid, admincolor, "/aorgname - zmiana nazwy organizacji.");
    SendClientMessage(playerid, admincolor, "/aorgtyp - zmiania typu organizacji.");
    SendClientMessage(playerid, admincolor, "/aorgpos - zmienia pozycje spawnu organizacji.");
    SendClientMessage(playerid, admincolor, "/aorginfo - pokazuje szczego³owe informacje o organizacji.");
    SendClientMessage(playerid, admincolor, "/aorgid - sprawdza czy istnieje organziacja o podanym ID.");
    SendClientMessage(playerid, admincolor, "/aorgskin - ustawia skin dla rangi.");
    SendClientMessage(playerid, admincolor, "/aorgrname - ustawia nazwe rangi.");
    SendClientMessage(playerid, admincolor, "/asetleader - nadaje uprawnienia lidera organizacji.");
    SendClientMessage(playerid, admincolor, "/akickorg - wyrzuca gracza z organizacji.");
    SendClientMessage(playerid, admincolor, "/aorgadd - dodaje organizacje(miejsce spawnu Twoja pozycja).");
    SendClientMessage(playerid, admincolor, "/aorgdel - usuwa organizacje z bazy danych.");
    SendClientMessage(playerid, admincolor, "/aorgzr - zmienia range gracza.");
	return 1;
}

CMD:aorgname(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	    
	new ids, nowa_nazwa[24];
	if(sscanf(params, "ds[24]", ids, nowa_nazwa))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /aorgname <id> <nazwa>");
	    
	if(org[ids][oid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Organizacja o tym ID nie istnieje.");
	    
	org[ids][onazwa] = nowa_nazwa;
	thorus_saveOrg(org[ids][oid]);
    SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie zmieniono nazwe organizacji.");
    return 1;
}

CMD:aorgtyp(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids, idt;
	if(sscanf(params, "dd", ids, idt))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /aorgtyp <id> <id typu>");

	if(org[ids][oid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Organizacja o tym ID nie istnieje.");
	    
	if(idt < 0 || idt > 9)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Z³e ID typu, prawid³owe musi mieœciæ siê w przedziale 0-9.");
	    
	org[ids][typ] = idt;
	thorus_saveOrg(org[ids][oid]);
    SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie zmieniono typ organizacji.");
    return 1;
}

CMD:aorgpos(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids;
	if(sscanf(params, "d", ids))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /aorgpos <id>");

	if(org[ids][oid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Organizacja o tym ID nie istnieje.");
	    
	GetPlayerPos(playerid, org[ids][ox], org[ids][oy], org[ids][oz]);
	GetPlayerFacingAngle(playerid, org[ids][oa]);
	thorus_saveOrg(org[ids][oid]);
    SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie zapisano now¹ pozycje organizacji.");
    return 1;
}

CMD:aorginfo(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids;
	if(sscanf(params, "d", ids))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /aorginfo <id>");

	if(org[ids][oid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Organizacja o tym ID nie istnieje.");
	    
	format(txt, sizeof txt, "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= | %s | =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-", org[ids][onazwa]);
	SendClientMessage(playerid, admincolor, txt);
	format(txt, sizeof txt, "dbID: %d | typ: %d | x: %f | y: %f | z: %f | a: %f",
	org[ids][oid],
	org[ids][typ],
	org[ids][ox],
	org[ids][oy],
	org[ids][oz],
	org[ids][oa]);
	SendClientMessage(playerid, niebieski, txt);
	return 1;
}

CMD:aorgid(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids;
	if(sscanf(params, "d", ids))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /aorgid <id>");
	    
	format(mq, sizeof mq, "select `id` from `org` where `id`='%d'", ids);
	mysql_query(mq);
	mysql_store_result();
	if(!mysql_num_rows())
	    return SendClientMessage(playerid, zolty, "[B£¥D] Organizacja o tym ID nie istnieje.");

    SendClientMessage(playerid, zolty, "[INFO] Organizacja o takim ID istnieje.");
	mysql_free_result();
	return 1;
}

CMD:aorgskin(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids, idr, ido2;
	if(sscanf(params, "ddd", ido2, idr, ids))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /aorgskin <id organizacji> <nr rangi> <nr skina>");
	    
    if(org[ido2][oid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Organizacja o tym ID nie istnieje.");
	    
	if(ids < 0 || ids > 299)
	    SendClientMessage(playerid, zolty, "[B£¥D] Z³e ID skina(0-299).");
	    
	switch(idr)
	{
	    case 1:
	    {
	        format(mq, sizeof mq, "update `org` set `rskin`='%d' where `id`='%d'", ids, org[ido2][oid]);
	        mysql_query(mq);
	        org[ido2][r_skin] = ids;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono skin rangi.");
		}
		case 2:
	    {
	        format(mq, sizeof mq, "update `org` set `rskin2`='%d' where `id`='%d'", ids, ido2);
	        mysql_query(mq);
	        org[ido2][r_skin2] = ids;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono skin rangi.");
		}
		case 3:
	    {
	        format(mq, sizeof mq, "update `org` set `rskin3`='%d' where `id`='%d'", ids, ido2);
	        mysql_query(mq);
	        org[ido2][r_skin3] = ids;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono skin rangi.");
		}
		case 4:
	    {
	        format(mq, sizeof mq, "update `org` set `rskin4`='%d' where `id`='%d'", ids, ido2);
	        mysql_query(mq);
	        org[ido2][r_skin4] = ids;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono skin rangi.");
		}
		case 5:
	    {
	        format(mq, sizeof mq, "update `org` set `rskin5`='%d' where `id`='%d'", ids, ido2);
	        mysql_query(mq);
	        org[ido2][r_skin5] = ids;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono skin rangi.");
		}
		case 6:
	    {
	        format(mq, sizeof mq, "update `org` set `rskin6`='%d' where `id`='%d'", ids, ido2);
	        mysql_query(mq);
	        org[ido2][r_skin6] = ids;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono skin rangi.");
		}
		case 7:
	    {
	        format(mq, sizeof mq, "update `org` set `rskin7`='%d' where `id`='%d'", ids, ido2);
	        mysql_query(mq);
	        org[ido2][r_skin7] = ids;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono skin rangi.");
		}
		case 8:
	    {
	        format(mq, sizeof mq, "update `org` set `rskin8`='%d' where `id`='%d'", ids, ido2);
	        mysql_query(mq);
	        org[ido2][r_skin8] = ids;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono skin rangi.");
		}
		case 9:
	    {
	        format(mq, sizeof mq, "update `org` set `rskin9`='%d' where `id`='%d'", ids, ido2);
	        mysql_query(mq);
	        org[ido2][r_skin9] = ids;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono skin rangi.");
		}
		case 10:
	    {
	        format(mq, sizeof mq, "update `org` set `rskin10`='%d' where `id`='%d'", ids, ido2);
	        mysql_query(mq);
	        org[ido2][r_skin10] = ids;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono skin rangi.");
		}
		default: SendClientMessage(playerid, zolty, "[B£¥D] Z³e ID rangi(1-10).");
	}
	return 1;
}

CMD:aorgrname(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ido2, idr, r_name[12];
	if(sscanf(params, "dds[12]", ido2, idr, r_name))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /aorgskin <id organizacji> <nr rangi> <nr skina>");

    if(org[ido2][oid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Organizacja o tym ID nie istnieje.");
	    
	if(strlen(r_name) < 3 || strlen(r_name) > 12)
	    return SendClientMessage(playerid, zolty, "[B£¥D] D³ugoœæ nazwy dla rangi powinna wynosiæ od 1-12 znaków.");

	switch(idr)
	{
	    case 1:
	    {
	        format(mq, sizeof mq, "update `org` set `rname`='%s' where `id`='%d'", r_name, org[ido2][oid]);
	        mysql_query(mq);
	        org[ido2][r_nazwa] = r_name;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono nazwe rangi.");
		}
		case 2:
	    {
	        format(mq, sizeof mq, "update `org` set `rname2`='%s' where `id`='%d'", r_name, org[ido2][oid]);
	        mysql_query(mq);
	        org[ido2][r_nazwa2] = r_name;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono nazwe rangi.");
		}
		case 3:
	    {
	        format(mq, sizeof mq, "update `org` set `rname3`='%s' where `id`='%d'", r_name, org[ido2][oid]);
	        mysql_query(mq);
	        org[ido2][r_nazwa3] = r_name;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono nazwe rangi.");
		}
		case 4:
	    {
	        format(mq, sizeof mq, "update `org` set `rname4`='%s' where `id`='%d'", r_name, org[ido2][oid]);
	        mysql_query(mq);
	        org[ido2][r_nazwa4] = r_name;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono nazwe rangi.");
		}
		case 5:
	    {
	        format(mq, sizeof mq, "update `org` set `rname5`='%s' where `id`='%d'", r_name, org[ido2][oid]);
	        mysql_query(mq);
	        org[ido2][r_nazwa5] = r_name;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono nazwe rangi.");
		}
		case 6:
	    {
	        format(mq, sizeof mq, "update `org` set `rname6`='%s' where `id`='%d'", r_name, org[ido2][oid]);
	        mysql_query(mq);
	        org[ido2][r_nazwa6] = r_name;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono nazwe rangi.");
		}
		case 7:
	    {
	        format(mq, sizeof mq, "update `org` set `rname7`='%s' where `id`='%d'", r_name, org[ido2][oid]);
	        mysql_query(mq);
	        org[ido2][r_nazwa7] = r_name;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono nazwe rangi.");
		}
		case 8:
	    {
	        format(mq, sizeof mq, "update `org` set `rname8`='%s' where `id`='%d'", r_name, org[ido2][oid]);
	        mysql_query(mq);
	        org[ido2][r_nazwa8] = r_name;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono nazwe rangi.");
		}
		case 9:
	    {
	        format(mq, sizeof mq, "update `org` set `rname9`='%s' where `id`='%d'", r_name, org[ido2][oid]);
	        mysql_query(mq);
	        org[ido2][r_nazwa9] = r_name;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono nazwe rangi.");
		}
		case 10:
	    {
	        format(mq, sizeof mq, "update `org` set `rname10`='%s' where `id`='%d'", r_name, org[ido2][oid]);
	        mysql_query(mq);
	        org[ido2][r_nazwa10] = r_name;
	        SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono nazwe rangi.");
		}
		default: SendClientMessage(playerid, zolty, "[B£¥D] Z³e ID rangi(1-10).");
	}
	thorus_saveOrg(ido2);
	return 1;
}

CMD:asetleader(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids, idg;
	if(sscanf(params, "dd", ids, idg))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /asetleader <id organizacji> <id gracza>");

	if(org[ids][oid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Organizacja o tym ID nie istnieje.");
	    
	if(p[idg][zalogowany] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Ten gracz nie jest zalogowany.");
	    
	p[idg][ranga] = 1;
	p[idg][idf] = ids;
	SetPlayerSkin(playerid, org[ids][r_skin]);
	format(txt, sizeof txt, "%s nada³ Ci uprawnienia lidera w organizacji %s.", PlayerName(playerid), org[ids][onazwa]);
	SendClientMessage(idg, admincolor, txt);
	format(txt, sizeof txt, "%s otrzyma³ uprawnienia lidera w organizacji %s.", PlayerName(idg), org[ids][onazwa]);
	SendClientMessage(playerid, admincolor, txt);
	return 1;
}

CMD:akickorg(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new idg;
	if(sscanf(params, "d", idg))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /akickorg <id gracza>");

	if(p[idg][zalogowany] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Ten gracz nie jest zalogowany.");
	    
    p[idg][ranga] = 0;
	p[idg][idf] = 0;
	format(txt, sizeof txt, "%s wyrzuci³ Ciê z organizacji.", PlayerName(playerid));
	SendClientMessage(idg, admincolor, txt);
	format(txt, sizeof txt, "%s zosta³ wyrzucony z organizacji.", PlayerName(idg));
	SendClientMessage(playerid, admincolor, txt);
	return 1;
}

CMD:aorgadd(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	    
	new nameo[24], typo, Float:px, Float:py, Float:pz, Float:pa;
	if(sscanf(params, "s[24]d", nameo, typo))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /aorgadd <nazwa> <typ>");
	    
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, pa);
	thorus_orgAdd(nameo, typo, px, py, pz, pa);
	format(txt, sizeof txt, "[INFO] Dodano organizacje - nazwa: %s | typ: %d | x: %f | y: %f | z: %f | a: %f",
	nameo,
	typo,
	px,
	py,
	pz,
	pa);
	SendClientMessage(playerid, admincolor, txt);
	return 1;
}

CMD:aorgdel(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids;
	if(sscanf(params, "d", ids))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /aorgdel <id organizacji>");

	if(org[ids][oid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Organizacja o tym ID nie istnieje.");
	    
	thorus_orgDel(ids);
	SendClientMessage(playerid, admincolor, "[INFO] Organizacja zosta³a usuniêta z bazy danych.");
	return 1;
}

CMD:aorgzr(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	    
	new idg, idr;
	if(sscanf(params, "dd", idg, idr))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /aorgzr <id gracza> <id rangi>");
	    
	if(idr < 0 || idr > 10)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID rangi (1-10)");
	    
	if(p[idg][zalogowany] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Ten gracz nie jest zalogowany.");
	    
	p[idg][ranga] = idr;
	format(txt, sizeof txt, "[ORG-INFO] %s zmieni³ range %s", PlayerName(playerid), PlayerName(idg));
	thorus_orgMessage(p[idg][idf], txt);
	SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie zmieniono range.");
	return 1;
}

CMD:ulecz(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, -320.4509,1048.8623,20.3403))
	    return SendClientMessage(playerid, zolty, "[B£¥D] Jesteœ za daleko od drzwi szpitala.");
	    
	if(p[playerid][kasa] < 250)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nie masz przy sobie tyle gotówki.");
	    
	GivePlayerMoney(playerid, -250);
	p[playerid][kasa] -= 250;
	SetPlayerHealth(playerid, 100.0);
	SendClientMessage(playerid, pomaranczowy, "[INFO] Wyleczono postaæ za 250$.");
	return 1;
}

CMD:zapros(playerid, params[])
{
	if(p[playerid][ranga] != 1 || p[playerid][idf] == 0)
		return SendClientMessage(playerid, zolty, "[B£¥D] Nie jesteœ liderem.");
		
	new idg = strval(params);
	if(isnull(params))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /zapros <id gracza>");
	    
	if(!IsPlayerConnected(idg))
	    return SendClientMessage(playerid, zolty, "[B£¥D] Gracz nie jest zalogowany.");
	    
	if(idg == playerid)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nie wolno!");
	    
	if(p[idg][idf] != 0 || p[idg][ranga] != 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Ten gracz nale¿y do organizacji.");
	    
	oorg[idg] = 1;
	ooid[idg] = p[playerid][idf];
	format(txt, sizeof txt, "[ORG-INV] %s zaprasza Ciebie do organizacji %s. Wpisz /akceptuj organizacja jeœli chcesz do³¹czyæ.",
	PlayerName(playerid),
	org[p[playerid][idf]][onazwa]);
	SendClientMessage(idg, org_info, txt);
	format(txt, sizeof txt, "[ORG-INV] %s zosta³ zaproszony do organizacji.", PlayerName(idg));
	SendClientMessage(playerid, org_info, txt);
	return 1;
}

CMD:wyrzuc(playerid, params[])
{
    if(p[playerid][ranga] != 1 || p[playerid][idf] == 0)
		return SendClientMessage(playerid, zolty, "[B£¥D] Nie jesteœ liderem.");

	new idg = strval(params);
	if(isnull(params))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /wyrzuc <id gracza>");
	    
	if(p[idg][idf] != p[playerid][idf])
	    return SendClientMessage(playerid, zolty, "[B£¥D] Ten gracz nie jest z Twojej organizacji.");
	    
	if(idg == playerid)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nie.");
	    
	p[idg][idf] = 0;
	p[idg][ranga] = 0;
	format(txt, sizeof txt, "[ORG-INFO] %s zosta³ wyrzucony z organizacji przez %s", PlayerName(idg), PlayerName(playerid));
	thorus_orgMessage(p[playerid][idf], txt);
	format(txt, sizeof txt, "[INFO] Zosta³eœ wyrzucony z %s przez %s", org[p[playerid][idf]][onazwa], PlayerName(playerid));
	SendClientMessage(idg, pomaranczowy, txt);
	format(txt, sizeof txt, "[INFO] Wyrzuci³eœ %s z organizacji.", PlayerName(idg));
	SendClientMessage(idg, pomaranczowy, txt);
	return 1;
}

CMD:zmienrange(playerid, params[])
{
    if(p[playerid][ranga] != 1 || p[playerid][idf] == 0)
		return SendClientMessage(playerid, zolty, "[B£¥D] Nie jesteœ liderem.");

	new idg, idr;
	if(sscanf(params, "dd", idg, idr))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /zmienrange <id gracza> <id rangi> -> ID rangi: 1-10");
	    
	if(idr < 1 || idr > 10)
		return SendClientMessage(playerid, zolty, "[B£¥D] Z³e ID rangi -> 1-10");
		
	if(p[idg][idf] != 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Ten gracz nie jest z Twojej organizacji.");
		
	p[idg][ranga] = idr;
	switch(p[playerid][ranga])
 	{
  		case 1:
    	{
     		SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin]);
		}
		case 2:
	    {
	        SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin2]);
		}
		case 3:
	    {
     		SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin3]);
		}
		case 4:
  		{
    		SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin4]);
		}
		case 5:
	    {
	        SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin5]);
		}
		case 6:
	    {
	        SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin6]);
		}
		case 7:
	    {
  			SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin7]);
		}
		case 8:
	    {
	        SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin8]);
		}
		case 9:
	    {
	       	SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin9]);
		}
		case 10:
	    {
	        SetPlayerSkin(playerid, org[p[playerid][idf]][r_skin10]);
		}
	}
	format(txt, sizeof txt, "[ORG-INFO] %s zmieni³ range %s", PlayerName(playerid), PlayerName(idg));
	thorus_orgMessage(p[playerid][idf], txt);
	return 1;
}

CMD:abudcmd(playerid, params[])
{
    if(p[playerid][admin] < 2)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	SendClientMessage(playerid, zielony, " -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= | Building system CMD | =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
    SendClientMessage(playerid, admincolor, "/abudadd - dodaje budynek w miejscu, w którym stoimy.");
    SendClientMessage(playerid, admincolor, "/abudgethere - teleportuje budynek do nas.");
    SendClientMessage(playerid, admincolor, "/abudint - zmiania interior budynku.");
    SendClientMessage(playerid, admincolor, "/abudgoto - teleportuje nas do wybranego budynku.");
    SendClientMessage(playerid, admincolor, "/abudname - zmienia nazwe budynku.");
    SendClientMessage(playerid, admincolor, "/abuddel - usuwa budynek.");
    return 1;
}

CMD:abudel(playerid, params[])
{
    if(p[playerid][admin] < 2)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
    	
	new ids = strval(params);
	if(!ids)
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abudel <id>");
	    
	if(bud[ids][bid] == 0)
		return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID.");
		
	new delbud[128];
	format(delbud, sizeof delbud, "delete from `bud` where `id`='%d'", bud[ids][bid]);
	mysql_query(delbud);
	bud[ids][bid] = 0;
	bud[ids][nazwa] = 0;
	bud[ids][ex] = 0;
	bud[ids][ey] = 0;
	bud[ids][ez] = 0;
	bud[ids][eint] = 0;
	bud[ids][ea] = 0;
	bud[ids][ex2] = 0;
	bud[ids][ey2] = 0;
	bud[ids][ez2] = 0;
	bud[ids][ea2] = 0;
	bud[ids][eint2] = 0;
	bud[ids][index_t] = 0;
	DestroyDynamicPickup(bud[ids][pickupid2]);
	bud[ids][pickupid2] = 0;
 	SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie usuniêto budynek.");
 	return 1;
}

CMD:abudname(playerid, params[])
{
    if(p[playerid][admin] < 2)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
    	
	new nazwabudynku[24], ids;
	if(sscanf(params, "ds[24]", ids, nazwabudynku))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abudname <nazwa> Nazwa: 1-24 znaki.");
	    
	if(strlen(nazwabudynku) < 1 || strlen(nazwabudynku) > 24)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Zbyt d³uga nazwa.");

	if(bud[ids][bid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID.");
	    
	bud[ids][nazwa] = nazwabudynku;
	return 1;
}

CMD:abudgoto(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	    
	new ids = strval(params);
	if(!ids)
		return SendClientMessage(playerid, zolty, "[U¯YCIE] /abudgoto <id>");
		
	if(bud[ids][bid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Taki budynek nie istnieje.");
	    
	SetPlayerPos(playerid, bud[ids][ex], bud[ids][ey], bud[ids][ez]);
	SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie teleportowano.");
	return 1;
}

CMD:abudadd(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new nazwabudynku[24];
	if(sscanf(params, "s[24]", nazwabudynku))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abudadd <nazwa> Nazwa: 1-24 znaki.");

    SendClientMessage(playerid, admincolor, "[INFO] Dodano budynek.");
    return 1;
}

CMD:abudgethere(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	    
	new bid2 = strval(params);
	if(!bid2)
		return SendClientMessage(playerid, zolty, "[U¯YCIE] /abudgethere <id>");
		
	if(bud[bid2][bid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID.");
	    
	new Float:px, Float:py, Float:pz;
	GetPlayerPos(playerid, px, py, pz);
	bud[bid2][ex] = px;
	bud[bid2][ey] = py;
	bud[bid2][ez] = pz;
	DestroyDynamicPickup(bud[bid2][pickupid2]);
	bud[bid2][pickupid2] = CreateDynamicPickup(1239, 1, bud[bid2][ex], bud[bid2][ey], bud[bid2][ez]);
	SendClientMessage(playerid, admincolor, "[INFO] Teleportowano budynek.");
	return 1;
}

CMD:abudint(playerid, params[])
{
    if(p[playerid][admin] < 2)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new inter, ids;
	if(sscanf(params, "dd", ids, inter))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abudint <id> <id int>");
	    
	if(bud[ids][bid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID.");
	    
	if(inter < 1 || inter > 4)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID interioru.");

	switch(inter)
	{
	    case 1:
	    {
			bud[ids][ex2] = 246.783997;
			bud[ids][ey2] = 63.900200;
			bud[ids][ez2] = 1003.639954;
			bud[ids][eint2] = 6;
			SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior LSPD.");
		}
		case 2:
		{
		    bud[ids][ex2] = 388.871979;
			bud[ids][ey2] = 173.804993;
			bud[ids][ez2] = 1008.389954;
			bud[ids][eint2] = 3;
			SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Planning Departament.");
		}
		case 3:
		{
		    bud[ids][ex2] = -959.873962;
			bud[ids][ey2] = 1952.000000;
			bud[ids][ez2] = 9.044310;
			bud[ids][eint2] = 17;
			SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Sherman Dam");
		}
		case 4:
		{
		    bud[ids][ex2] = -2029.719971;
			bud[ids][ey2] = -115.067993;
			bud[ids][ez2] = 1035.169922;
			bud[ids][eint2] = 3;
			SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Driving school.");
		}
		default:
		{
		    SendClientMessage(playerid, admincolor, "[INFO] Nieprawid³owe ID, lista interiorów:");
		    SendClientMessage(playerid, admincolor, "[INFO] 1. LSPD");
		    SendClientMessage(playerid, admincolor, "[INFO] 2. Planning Departament");
		    SendClientMessage(playerid, admincolor, "[INFO] 3. Sherman Dam");
		    SendClientMessage(playerid, admincolor, "[INFO] 4. Driving School.");
		}
	}
	return 1;
}

CMD:drzwi(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid) == 1)
	    return 0;
	    
    for(new i; i < 100; i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 1.0, bud[i][ex], bud[i][ey], bud[i][ez]))
	    {
	        SetPlayerInterior(playerid, bud[i][eint2]);
	        SetPlayerPos(playerid, bud[i][ex2], bud[i][ey2], bud[i][ez2]);
	        SetPlayerFacingAngle(playerid, bud[i][ea2]);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, bud[i][ex2], bud[i][ey2], bud[i][ez2]))
		{
		    SetPlayerInterior(playerid, bud[i][eint]);
	        SetPlayerPos(playerid, bud[i][ex], bud[i][ey], bud[i][ez]);
	        SetPlayerFacingAngle(playerid, bud[i][ea]);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1.0, biz[i][ex], biz[i][ey], biz[i][ez]))
		{
		    if(biz[i][zamkniety] == 1)
				return SendClientMessage(playerid, zolty, "[B£¥D] Biznes zamkniêty.");
				
		    SetPlayerInterior(playerid, biz[i][eint2]);
	        SetPlayerPos(playerid, biz[i][ex2], biz[i][ey2], biz[i][ez2]);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, biz[i][ex2], biz[i][ey2], biz[i][ez2]))
		{
		    SetPlayerInterior(playerid, biz[i][eint]);
	        SetPlayerPos(playerid, biz[i][ex], biz[i][ey], biz[i][ez]);
		}
	}
	return 1;
}

CMD:abizadd(playerid, params[])
{
    if(p[playerid][admin] < 3)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	    
	new nazwa_b[24], typ_b;
	if(sscanf(params, "s[24]d", nazwa_b, typ_b))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abizadd <nazwa> <typ>");
	    
	if(strlen(nazwa_b) < 1 || strlen(nazwa_b) > 24)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Zbyt d³uga nazwa(1-24)");
	    
	if(typ_b < 1 || typ_b > MAX_TYP_BIZ)
		return SendClientMessage(playerid, zolty, "[B£¥D] Z³e ID typu.");
		
	thorus_createBusiness(playerid, nazwa_b, typ_b);
	return 1;
}

CMD:abizint(playerid, params[])
{
    if(p[playerid][admin] < 3)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids, intb;
	if(sscanf(params, "dd", ids, intb))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abizint <id> <id int>");
	    
	if(biz[ids][bizid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID biznesu.");
	    
	switch(intb)
	{
	    case 1: //24-7
	    {
	        biz[ids][ex2] = -25.884499;
	        biz[ids][ey2] = -185.868988;
	        biz[ids][ez2] = 1003.549988;
	        biz[ids][eint2] = 17;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior 24-7.");
		}
		case 2: //24-7
	    {
	        biz[ids][ex2] = 6.091180;
	        biz[ids][ey2] = -29.271898;
	        biz[ids][ez2] = 1003.549988;
	        biz[ids][eint2] = 10;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior 24-7.");
		}
		case 3: //ammunation
	    {
	        biz[ids][ex2] = 286.148987;
	        biz[ids][ey2] = -40.644398;
	        biz[ids][ez2] = 1001.569946;
	        biz[ids][eint2] = 1;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Ammunation.");
		}
		case 4: //ammunation
	    {
	        biz[ids][ex2] = 296.919983;
	        biz[ids][ey2] = -108.071999;
	        biz[ids][ez2] = 1001.569946;
	        biz[ids][eint2] = 6;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Ammunation.");
		}
		case 5: //restauracja Cluckin' Bell
	    {
	        biz[ids][ex2] = 365.7158;
	        biz[ids][ey2] = -9.8873;
	        biz[ids][ez2] = 1001.8516;
	        biz[ids][eint2] = 9;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Cluckin' Bell.");
		}
		case 6: //pizza
	    {
	        biz[ids][ex2] = 372.3520;
	        biz[ids][ey2] = -131.6510;
	        biz[ids][ez2] = 1001.4922;
	        biz[ids][eint2] = 5;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Well Stacked Pizza.");
		}
		case 7: // Burger Shot
	    {
	        biz[ids][ex2] = 363.4129;
	        biz[ids][ey2] = -74.5786;
	        biz[ids][ez2] = 1001.5078;
	        biz[ids][eint2] = 10;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Well Stacked Pizza.");
		}
		case 8: // prolaps
	    {
	        biz[ids][ex2] = 207.054992;
	        biz[ids][ey2] = -138.804992;
	        biz[ids][ez2] = 1003.507812;
	        biz[ids][eint2] = 3;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Prolaps.");
		}
		case 9: // suburban
	    {
	        biz[ids][ex2] = 203.777999;
	        biz[ids][ey2] = -48.492397;
	        biz[ids][ez2] = 1001.804687;
	        biz[ids][eint2] = 1;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Suburban.");
		}
		case 10: // club
	    {
	        biz[ids][ex2] = 493.390991;
	        biz[ids][ey2] = -22.722799;
	        biz[ids][ez2] = 1000.679687;
	        biz[ids][eint2] = 17;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Club.");
		}
		case 11: // bar
	    {
	        biz[ids][ex2] = 501.980987;
	        biz[ids][ey2] = -69.150199;
	        biz[ids][ez2] = 998.757812;
	        biz[ids][eint2] = 17;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Bar.");
		}
		case 12: // ufo bar
	    {
	        biz[ids][ex2] = -227.027999;
	        biz[ids][ey2] = 1401.229980;
	        biz[ids][ez2] = 27.765625;
	        biz[ids][eint2] = 18;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior UFO Bar.");
		}
		case 13: // restauracja
	    {
	        biz[ids][ex2] = 457.304748;
	        biz[ids][ey2] = -88.428497;
	        biz[ids][ez2] = 999.554687;
	        biz[ids][eint2] = 4;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Restauracji.");
		}
		case 14: // restauracja
	    {
	        biz[ids][ex2] = 381.169189;
	        biz[ids][ey2] = -188.803024;
	        biz[ids][ez2] = 1000.632812;
	        biz[ids][eint2] = 17;
	        SendClientMessage(playerid, admincolor, "[INFO] Ustawiono interior Restauracji.");
		}
		default: SendClientMessage(playerid, admincolor, "[INFO] Podano z³e ID.");
	}
	return 1;
}

CMD:kupbiznes(playerid, params[])
{/*
	if(p[playerid][level] < 3)
		return SendClientMessage(playerid, zolty, "[B£¥D] Musisz najpierw zdobyæ 3 level.");*/
		
	for(new i; i < max_biz; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.0, biz[i][ex], biz[i][ey], biz[i][ez]) && biz[i][cena] != 0 && biz[i][idown] == 0)
		{
  			if(p[playerid][kasa] <= biz[i][cena])
		    {
      			SendClientMessage(playerid, zolty, "[B£¥D] Masz za ma³o gotówki.");
			}
   			GivePlayerMoney(playerid, -biz[i][cena]);
    		p[playerid][kasa] -= biz[i][cena];
      		biz[i][idown] = p[playerid][id];
			SendClientMessage(playerid, niebieski, "[INFO] Kupiono biznes, wejdŸ do œrodka i wpisz /bizpanel");
			DestroyDynamicPickup(biz[i][pickupid3]);
			biz[i][pickupid3] = CreateDynamicPickup(1273, 1, biz[i][ex], biz[i][ey], biz[i][ez]);
		}
	}
	return 1;
}

CMD:abizcmd(playerid, params[])
{
    if(p[playerid][admin] < 3)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	SendClientMessage(playerid, zielony, " -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= | Biznes system CMD | =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
    SendClientMessage(playerid, admincolor, "/abizadd - dodaje biznes.");
    SendClientMessage(playerid, admincolor, "/abizint - zmienia interior biznesu.");
    SendClientMessage(playerid, admincolor, "/abizgethere - teleportuje biznes do nas.");
    SendClientMessage(playerid, admincolor, "/abizgoto - teleportuje nas do biznesu.");
    SendClientMessage(playerid, admincolor, "/abizname - zmienia nazwe biznesu.");
    SendClientMessage(playerid, admincolor, "/abiztyp - zmienia typ biznesu.");
    SendClientMessage(playerid, admincolor, "/abizcena - ustawia cene biznesu.");
    SendClientMessage(playerid, admincolor, "/abizprodukty - ustawia ilosæ produktów w biznesie.");
    SendClientMessage(playerid, admincolor, "/abizdrzwi - zamyka, otwiera drzwi biznesu.");
    return 1;
}

CMD:abizdrzwi(playerid, params[])
{
    if(p[playerid][admin] < 3)
		return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids,cen;
	if(sscanf(params, "dd", ids, cen))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abizdrzwi <id> <0/1>");
	    
    if(cen < 0 || cen > 1)
		return SendClientMessage(playerid, zolty, "[B£¥D] 0 - zamkniete | 1 - otwarte.");

    if(biz[ids][bizid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID.");
	    
    biz[ids][zamkniety] = cen;
	SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie zmieniono status drzwi.");
	return 1;
}


CMD:abizprodukty(playerid, params[])
{
    if(p[playerid][admin] < 3)
		return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids,cen;
	if(sscanf(params, "dd", ids, cen))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abizprodukty <id> <iloœæ>");

	if(cen < 1 || cen > 10000000)
		return SendClientMessage(playerid, zolty, "[B£¥D] Zbyt du¿a liczba.");
		
    if(biz[ids][bizid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID.");
		
    biz[ids][produkty] = cen;
	SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono iloœæ produktów.");
	return 1;
}

CMD:abizcena(playerid, params[])
{
    if(p[playerid][admin] < 3)
		return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids,cen;
	if(sscanf(params, "dd", ids, cen))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abizcena <id> <cena>");
	    
	if(cen < 1 || cen > 10000000)
		return SendClientMessage(playerid, zolty, "[B£¥D] Zbyt wysoka cena!");
		
    if(biz[ids][bizid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID.");
	    
	biz[ids][cena] = cen;
	SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie ustawiono cene.");
	return 1;
}

CMD:abiztyp(playerid, params[])
{
    if(p[playerid][admin] < 3)
		return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	new ids,typ32;
	if(sscanf(params, "dd", ids, typ32))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abiztyp <id> <typ>");
	    
	if(typ32 < 1 || typ32 > MAX_TYP_BIZ)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID typu.");
	    
    if(biz[ids][bizid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID.");
	    
	biz[ids][typ] = typ32;
	SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie zmieniono typ.");
	return 1;
}

CMD:abizname(playerid, params[])
{
	if(p[playerid][admin] < 3)
		return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
    	
	new ids,nazwa_b[24];
	if(sscanf(params, "ds[24]", ids, nazwa_b))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abizname <id> <nazwa>");
	    
	if(strlen(nazwa_b) < 1 || strlen(nazwa_b) > 24)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owa d³ugoœæ nazwy(1-24).");
	    
	if(biz[ids][bizid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID.");
	    
	biz[ids][nazwa] = nazwa_b;
	SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie zmieniono nazwe.");
	return 1;
}

CMD:abizgoto(playerid, params[])
{
    if(p[playerid][admin] < 3)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
    	
    new uid = strval(params);
	if(!uid)
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abizgethere <id>");

	if(biz[uid][bizid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID.");

	SetPlayerPos(playerid, biz[uid][ex], biz[uid][ey], biz[uid][ez]);
	SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie teleportowano.");
	return 1;
}

CMD:abizgethere(playerid, params[])
{
    if(p[playerid][admin] < 3)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
    	
	new uid = strval(params);
	if(!uid)
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /abizgethere <id>");
	    
	if(biz[uid][bizid] == 0)
	    return SendClientMessage(playerid, zolty, "[B£¥D] Nieprawid³owe ID.");
	    
	new Float:px, Float:py, Float:pz;
	GetPlayerPos(playerid, px, py, pz);
	biz[uid][ex] = px;
	biz[uid][ey] = py;
	biz[uid][ez] = pz;
    DestroyDynamicPickup(biz[uid][pickupid3]);
    if(biz[uid][idown] == 0)
    {
    	biz[uid][pickupid3] = CreateDynamicPickup(1272, 1, biz[uid][ex], biz[uid][ey], biz[uid][ez]);
	}
	else if(biz[uid][idown] != 0)
	{
	    biz[uid][pickupid3] = CreateDynamicPickup(1273, 1, biz[uid][ex], biz[uid][ey], biz[uid][ez]);
	}
	SendClientMessage(playerid, admincolor, "[INFO] Pomyœlnie teleportowano.");
	return 1;
}

CMD:abizid(playerid, params[])
{
    if(p[playerid][admin] < 3)
    	return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");

	for(new i; i < max_biz; i++)
	{
    	if(IsPlayerInRangeOfPoint(playerid, 1.0, biz[i][ex], biz[i][ey], biz[i][ez]))
    	{
    	    format(txt, sizeof txt, "[INFO] Biznes w pobli¿u: index: %d", biz[i][index_t]);
    	    SendClientMessage(playerid, admincolor, txt);
		}
	}
	return 1;
}

CMD:kup(playerid, params[])
{
    for(new i; i < max_biz; i++)
	{
    	if(IsPlayerInRangeOfPoint(playerid, 20.0, biz[i][ex2], biz[i][ey2], biz[i][ez2]))
    	{
			switch(biz[i][typ])
			{
			    case 1:
			    {
			        ShowPlayerDialog(playerid, bizskleppanel, DIALOG_STYLE_LIST, "Co chcesz kupiæ?", "Kij golfowy(150$)\nNó¿(5$)\nBaseball(125$)\n£opata(10$)\nKij bilardowy(60$)\nPi³a ³añcuchowa(955$)\nKwiaty(10$)\nLaska(5$)\nSpray(15$)\nAparat(450$)\nGaœnica(300$)", "Kup", "Anuluj");
					biz_index[playerid] = i;
				}
				case 2:
				{
				    ShowPlayerDialog(playerid, bizammunationpanel, DIALOG_STYLE_LIST, "Co chcesz kupiæ?", "Pistolet 9mm(900$)\nPistolet 9mm z t³umikiem(1200$)\nShotgun(1500$)\nCountry Rifle(2000$)\nDeser Eagle(1450$)\nTec-9(1000$)\nMP5(2000$)\nSpadochron(500$)", "Kup", "Anuluj");
					biz_index[playerid] = i;
				}
				case 3:
				{
				    if(biz[i][produkty] < 5)
				        return SendClientMessage(playerid, zolty, "[B£¥D] Ten biznes ma za ma³o produktów!");

					if(p[playerid][kasa] < 15)
					    return SendClientMessage(playerid, zolty, "[B£¥D] Nie masz przy sobie 15$.");
				        
					biz[i][produkty] -= 5;
					biz[i][konto] += 15;
					p[playerid][kasa] -= 15;
					GivePlayerMoney(playerid, -15);
					SendClientMessage(playerid, pomaranczowy, "[INFO] Kupiono jedzenie za 15$.");
					Action(playerid, "zamawia jedzenie w lokalu.");
					new Float:hape;
					if(GetPlayerHealth(playerid, hape) < 97)
					{
					    SetPlayerHealth(playerid, hape+2);
					}
					biz_index[playerid] = i;
				}
				case 4:
				{
				    ShowPlayerDialog(playerid, bizbarclubpanel, DIALOG_STYLE_LIST, "Co chcesz kupiæ?", "Piwo(5$)\nWódke(20$)\nWhisky(50$)\nWino(35$)\nBrandy(40$)\nSoda(10$)", "Kup", "Anuluj");
                    biz_index[playerid] = i;
				}
				case 5:
				{
	 				ShowPlayerDialog(playerid, bizsklepubraniapanel, DIALOG_STYLE_INPUT, "Sklep z ubraniami", "Podaj ID ubrania(skina), które chcesz kupiæ.\nID: 0-299", "Kup", "Anuluj");
                    biz_index[playerid] = i;
				}
				case 6:
				{
				    ShowPlayerDialog(playerid, bizsspanel, DIALOG_STYLE_LIST, "Co chcesz kupiæ?", "Fioletowe dildo(200$)\nDildo(150$)\nVibrator(200$)\nSrebrny vibrator(300$)", "Kup", "Anuluj");
				}
				default:
				{
				    SendClientMessage(playerid, zolty, "[B£¥D] Jesteœ w z³ym miejscu.");
				}
			}
		}
	}
	return 1;
}

CMD:asetadmin(playerid, params[])
{
	if(strcmp(PlayerName(playerid), "Thorus", true, 6))
	    return SendClientMessage(playerid, zolty, "[B£¥D] Brak dostêpu.");
	    
	new ids, ida;
	if(sscanf(params, "dd", ids, ida))
	    return SendClientMessage(playerid, zolty, "[U¯YCIE] /asetadmin <id> <poziom admina>");
	    
	p[ids][admin] = ida;
	format(txt, sizeof txt, "[INFO] %s nada³ Ci uprawnienia administratora na poziomie %d.", PlayerName(playerid), ida);
	SendClientMessage(ids, admincolor, txt);
	format(txt, sizeof txt, "[INFO] %s otrzyma³ uprawnienia administratora na poziomie %d.", PlayerName(ids), ida);
	SendClientMessage(playerid, admincolor, txt);
	return 1;
}

CMD:ogloszenie(playerid, params[])
{
    for(new i; i < max_biz; i++)
	{
    	if(IsPlayerInRangeOfPoint(playerid, 20.0, biz[i][ex2], biz[i][ey2], biz[i][ez2]))
    	{
    	    if(biz[i][typ] != 7)
    	        return SendClientMessage(playerid, zolty, "[B£¥D] Nie jesteœ w biznesie typu og³oszenia.");
    	    
    	    if(biz[i][produkty] < 10)
    	        return SendClientMessage(playerid, zolty, "[B£¥D] Ten biznes nie ma wystarczaj¹cej iloœci produktów.");
    	        
			new ogl[128];
			if(sscanf(params, "s[128]", ogl))
			    return SendClientMessage(playerid, zolty, "[U¯YCIE] /ogloszenie <treœæ>");
			    
			if(strlen(ogl) < 10 || strlen(ogl) > 128)
			    return SendClientMessage(playerid, zolty, "[B£¥D] Za ma³o/du¿o znaków(10-128)");
			    
			new koszt = strlen(ogl)*5;
			if(p[playerid][kasa] < koszt)
			    return SendClientMessage(playerid, zolty, "[B£¥D] Nie masz tyle gotówki.");
			    
			format(txt, sizeof txt, "[OG£] %s", ogl);
			SendClientMessageToAll(czerwony, "------------------------------------------ | OG£OSZENIE | ------------------------------------------");
			SendClientMessageToAll(0xFFFFFFFF, txt);
			format(txt, sizeof txt, "------------------------------------------ | %s(%d) | ------------------------------------------", PlayerName(playerid), playerid);
			SendClientMessageToAll(czerwony, txt);
			format(txt, sizeof txt, "[INFO] Koszt: %d | Znaków: %d | Nadane dziêki %s ", koszt, strlen(ogl), biz[i][nazwa]);
			SendClientMessage(playerid, pomaranczowy, txt);
			biz[i][produkty] -= 10;
			biz[i][konto] += koszt;
			GivePlayerMoney(playerid, -koszt);
			p[playerid][kasa] -= koszt;
		}
	}
	return 1;
}

CMD:bizpanel(playerid, params[])
{
    for(new i; i < max_biz; i++)
	{
    	if(IsPlayerInRangeOfPoint(playerid, 20.0, biz[i][ex2], biz[i][ey2], biz[i][ez2]))
    	{
    	    if(biz[i][idown] != p[playerid][id])
				return SendClientMessage(playerid, zolty, "[B£¥D] Nie jesteœ w³aœcicielem.");
				
			biz_index[playerid] = i;
			format(txt, sizeof txt, "%s - Sejf: %d | Produkty: %d", biz[i][nazwa], biz[i][konto], biz[i][produkty]);
			ShowPlayerDialog(playerid, bizownpanel, DIALOG_STYLE_LIST, txt, "Zmiana nazwy\nSejf - zabranie gotówki\nDrzwi - zamkniêcie lub otwarcie lokalu\nDokup produkty\nSprzedaj biznes", "Wybierz", "Anuluj");
		}
	}
	return 1;
}

CMD:pomoc(playerid, params[])
{
	ShowPlayerDialog(playerid, pomoc, DIALOG_STYLE_LIST, "W czym mo¿emy pomóc?", "Co to jest czat lokalny i globalny?\nJakie s¹ komendy na serwerze?\nJak zdobywaæ poziomy postaci?\nBiznes,dom,pojazd - jak kupiæ?\nJak zdobyæ punkty premium?\nJak rozwin¹æ umiejêtnoœci postaci?", "Wybierz", "Anuluj");
	return 1;
}
			

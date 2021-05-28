#include <a_samp>
#include <core>
#include <float>
#include <time>
#include <file>
#include <Dini>
#include <a_mysql>
#include <md5>
#include <sscanf2>
#include <fCmd>

#include "CRP/kolory.inc"
#include "CRP/main.inc"

#define NU      SendClientMessage(playerid, COLOR_RED, "[ERROR:] Nie masz takich uprawnieñ!");

new ile = 0;
new vehicleuid[MAX_PLAYERS];
new Text:bank2[MAX_PLAYERS];

//=========================================================================================
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
new RandomStableModels[][2] = { //Total 87 Models
{400},//Landstalker
{401},//Bravura
{402},//Buffalo
{404},//Perenniel
{405},//Sentinel
{410},//Manana
{411},//Infernus
{412},//Voodoo
{413},//Pony
{415},//Cheetah
{418},//Moobream
{419},//Esperanto
{421},//Washington
{422},//Bobcat
{424},//BF Injection
{426},//Premier
{429},//Banshee
{436},//Previon
{439},//Stallion
{445},//Admiral
{451},//Turismo
{458},//Solair
{461},//PCJ-600
{462},//Faggio
{463},//Freeway
{466},//Glendale
{467},//Oceanic
{468},//Sanchez
{471},//Quad
{474},//Hermes
{475},//Sabre
{477},//ZR-350
{479},//Regina
{480},//Comet
{482},//Burrito
{483},//Camper
{491},//Virgo
{492},//Greenwood
{496},//Blista
{500},//Mesa
{506},//Super GT
{507},//Elegant
{516},//Nebula
{517},//Majestic
{518},//Buccaneer
{521},//FCR-900
{522},//NRG-500
{526},//Fortune
{527},//Cadrona
{529},//Willard
{533},//Feltzer
{534},//Remington
{535},//Slamvan
{536},//Blade
{540},//Vincent
{541},//Bullet
{542},//Clover
{543},//Sadler
{546},//Intruder
{547},//Primo
{549},//Tampa
{550},//Sunrise
{551},//Merit
{554},//Yosemite
{555},//Window
{558},//Uranus
{559},//Jester
{560},//Sultan
{561},//Stratum
{562},//Elegy
{565},//Flash
{566},//Tahoma
{567},//Savanna
{575},//Broadway
{576},//Tornado
{579},//Huntley
{580},//Stafford
{581},//BF-400
{585},//Emporer
{586},//Wayfarer
{587},//Euros
{589},//Club
{600},//Picador
{602},//Alpha
{604},//Glendale Shit
{603},//Phoenix
{605}//Sadler Shit
};
//===============================[PICKUP STREAMER]=========================================
enum pickupINFO
{
	pickupCreated,
	pickupVisible,
	pickupID,
	pickupRange,
	Float:pickupX,
	Float:pickupY,
	Float:pickupZ,
 	pickupType,
	pickupModel
}
new Pickup[MAX_PICKUPZ+1][pickupINFO];
//===============================[NEW VARIABLES]===========================================
new JoinCounter; //Join statistics store in this variable.
new gPlayerLogged[MAX_PLAYERS];
new realchat = 1;
new BigEar[MAX_PLAYERS];
new ghour = 0;
new shifthour;
new timeshift = -1;
new realtime = 1;
new intrate = 1;
new levelexp = 3;
new RegistrationStep[MAX_PLAYERS];
new TakingDrivingTest[MAX_PLAYERS];
new DrivingTestStep[MAX_PLAYERS];
new SpawnAttempts[MAX_PLAYERS];
new FactionRequest[MAX_PLAYERS];//Where information will be stored regarding faction invites.
new Fuel[MAX_VEHICLES];//Fuel Information
new EngineStatus[MAX_VEHICLES];
new ShowFuel[MAX_PLAYERS];
new OutOfFuel[MAX_PLAYERS];
new Mobile[MAX_PLAYERS]; //Mobile Phone information will be stored here.
new PhoneOnline[MAX_PLAYERS];
new Muted[MAX_PLAYERS];
new StartedCall[MAX_PLAYERS];
new SpeakerPhone[MAX_PLAYERS];
new adds = 1;
new addtimer = 60000;
new OOCStatus = 0;
new AdminDuty[MAX_PLAYERS];
new PMsEnabled[MAX_PLAYERS];
new VehicleLocked[MAX_VEHICLES];
new VehicleLockedPlayer[MAX_PLAYERS];
new WantedPoints[MAX_PLAYERS];
new CarWindowStatus[MAX_VEHICLES];
new WantedLevel[MAX_PLAYERS];
new CopOnDuty[MAX_PLAYERS];
new PlayerCuffed[MAX_PLAYERS];
new PlayerTazed[MAX_PLAYERS];
new TicketOffer[MAX_PLAYERS];
new TicketMoney[MAX_PLAYERS];
new MatsHolding[MAX_PLAYERS];
new DrugsHolding[MAX_PLAYERS];
new DrugsIntake[MAX_PLAYERS];
new TrackingPlayer[MAX_PLAYERS];
new ProductsOffer[MAX_PLAYERS];
new ProductsAmount[MAX_PLAYERS];
new ProductsCost[MAX_PLAYERS];
new tekst[128];
new fetch[1024];
//=========================================================================================
//=================================[ENUMS]=================================================
enum pInfo
{
	pID,
	pLogin[24],
	pKey[256],
	pLevel,
	pAdmin,
	pDonateRank,
	pRegistered,
	pSex,
	pAge,
	pExp,
	pCash,
	pBank,
	pSkin,
	pDrugs,
	pMaterials,
	pJob,
	pPlayingHours,
	pAllowedPayday,
	pPayCheck,
	pFaction,
	pRank,
	pHouseKey,
	pBizKey,
	pSpawnPoint,//If pSpawnPoint = 1, then the user will spawn at there normal place, if it's 0 then they will spawn at there home.
	pBanned,
	pWarnings,
	pCarLic,
	pFlyLic,
	pWepLic,
	pPhoneNumber,
	pPhoneC,//Phone Company (Business ID)
	pPhoneBook,
	pListNumber,
	pDonator,
	pJailed,
	pJailTime,
	pProducts,
	Float:pCrashX,
	Float:pCrashY,
	Float:pCrashZ,
	pCrashInt,
	pCrashW,
	pCrashed,
};
new PlayerInfo[MAX_PLAYERS][pInfo];

enum Cars
{
	CarID,
	CarModel,
	Float:CarX,
	Float:CarY,
	Float:CarZ,
	Float:CarAngle,
	CarColor1,
	CarColor2,
	FactionCar,
	CarType,
	Cena,
	OwnID,
};
new DynamicCars[140][Cars];

enum Factions
{
	fID,
	fName[32],
	Float:fX,
	Float:fY,
	Float:fZ,
	fMaterials,
	fDrugs,
	fBank,
	fRank1[16],
	fRank2[16],
	fRank3[16],
	fRank4[16],
	fRank5[16],
	fRank6[16],
	fRank7[16],
	fRank8[16],
	fRank9[16],
	fRank10[16],
	fSkin1,
	fSkin2,
	fSkin3,
	fSkin4,
	fSkin5,
	fSkin6,
	fSkin7,
	fSkin8,
	fSkin9,
	fSkin10,
	fJoinRank,
	fUseSkins,
	fType,//For Government factions etc
	fRankAmount,
	fColor[128],
	fUseColor,
};

new DynamicFactions[10][Factions];

enum CivilianSpawns
{
	Float:X,
	Float:Y,
	Float:Z,
	World,
	Interior,
	Float:Angle,
};
new CivilianSpawn[CivilianSpawns];

enum FactionMaterials
{
	Float:X,
	Float:Y,
	Float:Z,
	World,
	Interior,
	Float:Angle,
	PickupID,
};
new FactionMaterialsStorage[FactionMaterials];

enum FactionDrugs
{
	Float:X,
	Float:Y,
	Float:Z,
	World,
	Interior,
	Float:Angle,
	PickupID,
};
new FactionDrugsStorage[FactionDrugs];

enum DrivingTestLocation
{
	Float:X,
	Float:Y,
	Float:Z,
	World,
	Interior,
	Float:Angle,
	PickupID,
};
new DrivingTestPosition[DrivingTestLocation];

enum BankLocation
{
	Float:X,
	Float:Y,
	Float:Z,
	World,
	Interior,
	Float:Angle,
	PickupID,
};
new BankPosition[BankLocation];

enum ProductsSellerJobInfo
{
	Float:TakeJobX,
	Float:TakeJobY,
	Float:TakeJobZ,
	TakeJobWorld,
	TakeJobInterior,
	Float:TakeJobAngle,
	TakeJobPickupID,
 	Float:BuyProductsX,
	Float:BuyProductsY,
	Float:BuyProductsZ,
	BuyProductsWorld,
	BuyProductsInterior,
	Float:BuyProductsAngle,
	BuyProductsPickupID,
};
new ProductsSellerJob[ProductsSellerJobInfo];

enum GunJobInfo
{
	Float:TakeJobX,
	Float:TakeJobY,
	Float:TakeJobZ,
	TakeJobWorld,
	TakeJobInterior,
	Float:TakeJobAngle,
	TakeJobPickupID,
 	Float:BuyPackagesX,
	Float:BuyPackagesY,
	Float:BuyPackagesZ,
	BuyPackagesWorld,
	BuyPackagesInterior,
	Float:BuyPackagesAngle,
	BuyPackagesPickupID,
  	Float:DeliverX,
	Float:DeliverY,
	Float:DeliverZ,
	DeliverWorld,
	DeliverInterior,
	Float:DeliverAngle,
	DeliverPickupID,
};
new GunJob[GunJobInfo];

enum DrugJobInfo
{
	Float:TakeJobX,
	Float:TakeJobY,
	Float:TakeJobZ,
	TakeJobWorld,
	TakeJobInterior,
	Float:TakeJobAngle,
	TakeJobPickupID,
 	Float:BuyDrugsX,
	Float:BuyDrugsY,
	Float:BuyDrugsZ,
	BuyDrugsWorld,
	BuyDrugsInterior,
	Float:BuyDrugsAngle,
	BuyDrugsPickupID,
  	Float:DeliverX,
	Float:DeliverY,
	Float:DeliverZ,
	DeliverWorld,
	DeliverInterior,
	Float:DeliverAngle,
	DeliverPickupID,
};
new DrugJob[DrugJobInfo];

enum FlyingTestLocation
{
	Float:X,
	Float:Y,
	Float:Z,
	World,
	Interior,
	Float:Angle,
	PickupID,
};
new FlyingTestPosition[FlyingTestLocation];

enum WeaponLicenseLocation
{
	Float:X,
	Float:Y,
	Float:Z,
	World,
	Interior,
	Float:Angle,
	PickupID,
};
new WeaponLicensePosition[WeaponLicenseLocation];

enum PoliceArrestLocation
{
	Float:X,
	Float:Y,
	Float:Z,
	World,
	Interior,
	Float:Angle,
};
new PoliceArrestPosition[PoliceArrestLocation];

enum PoliceDutyLocation
{
	Float:X,
	Float:Y,
	Float:Z,
	World,
	Interior,
	Float:Angle,
};
new PoliceDutyPosition[PoliceDutyLocation];

enum DetectiveJobLocation
{
	Float:X,
	Float:Y,
	Float:Z,
	World,
	Interior,
	Float:Angle,
	PickupID,
};
new DetectiveJobPosition[DetectiveJobLocation];

enum LawyerJobLocation
{
	Float:X,
	Float:Y,
	Float:Z,
	World,
	Interior,
	Float:Angle,
	PickupID,
};
new LawyerJobPosition[LawyerJobLocation];

enum BuildingSystem
{
	buID,
	BuildingName[32],
	Float:EnterX,
	Float:EnterY,
	Float:EnterZ,
	EntranceFee,
	EnterWorld,
	EnterInterior,
	Float:EnterAngle,
	Float:ExitX,
	Float:ExitY,
	Float:ExitZ,
	ExitInterior,
	Float:ExitAngle,
	Locked,
	PickupID,
};
new Building[20][BuildingSystem];

enum BusinessSystem
{
	bID,
	BusinessName[128],
	Owner[MAX_PLAYER_NAME],
	Float:EnterX,
	Float:EnterY,
	Float:EnterZ,
	EnterWorld,
	EnterInterior,
	Float:EnterAngle,
	Float:ExitX,
	Float:ExitY,
	Float:ExitZ,
	ExitInterior,
	Float:ExitAngle,
	Owned,
	Enterable,
	BizPrice,
	EntranceCost,
	Till,
	Locked,
	BizType,
	Products,
	PickupID,
}

new Businesses[400][BusinessSystem];

enum HouseSystem
{
	hID,
	Description[128],
	Owner[MAX_PLAYER_NAME],
	Float:EnterX,
	Float:EnterY,
	Float:EnterZ,
	EnterWorld,
	EnterInterior,
	Float:EnterAngle,
	Float:ExitX,
	Float:ExitY,
	Float:ExitZ,
	ExitInterior,
	Float:ExitAngle,
	Owned,
	Rentable,
	RentCost,
	HousePrice,
	Materials,
	Drugs,
	Money,
	Locked,
	PickupID,
};
new Houses[100][HouseSystem];

enum SAZONE_MAIN {
		SAZONE_NAME[28],
		Float:SAZONE_AREA[6]
};

static const gSAZones[][SAZONE_MAIN] = {  // Majority of names and area coordinates adopted from Mabako's 'Zones Script' v0.2
	//	NAME                            AREA (Xmin,Ymin,Zmin,Xmax,Ymax,Zmax)
	{"The Big Ear",	                {-410.00,1403.30,-3.00,-137.90,1681.20,200.00}},
	{"Aldea Malvada",               {-1372.10,2498.50,0.00,-1277.50,2615.30,200.00}},
	{"Angel Pine",                  {-2324.90,-2584.20,-6.10,-1964.20,-2212.10,200.00}},
	{"Arco del Oeste",              {-901.10,2221.80,0.00,-592.00,2571.90,200.00}},
	{"Avispa Country Club",         {-2646.40,-355.40,0.00,-2270.00,-222.50,200.00}},
	{"Avispa Country Club",         {-2831.80,-430.20,-6.10,-2646.40,-222.50,200.00}},
	{"Avispa Country Club",         {-2361.50,-417.10,0.00,-2270.00,-355.40,200.00}},
	{"Avispa Country Club",         {-2667.80,-302.10,-28.80,-2646.40,-262.30,71.10}},
	{"Avispa Country Club",         {-2470.00,-355.40,0.00,-2270.00,-318.40,46.10}},
	{"Avispa Country Club",         {-2550.00,-355.40,0.00,-2470.00,-318.40,39.70}},
	{"Back o Beyond",               {-1166.90,-2641.10,0.00,-321.70,-1856.00,200.00}},
	{"Battery Point",               {-2741.00,1268.40,-4.50,-2533.00,1490.40,200.00}},
	{"Bayside",                     {-2741.00,2175.10,0.00,-2353.10,2722.70,200.00}},
	{"Bayside Marina",              {-2353.10,2275.70,0.00,-2153.10,2475.70,200.00}},
	{"Beacon Hill",                 {-399.60,-1075.50,-1.40,-319.00,-977.50,198.50}},
	{"Blackfield",                  {964.30,1203.20,-89.00,1197.30,1403.20,110.90}},
	{"Blackfield",                  {964.30,1403.20,-89.00,1197.30,1726.20,110.90}},
	{"Blackfield Chapel",           {1375.60,596.30,-89.00,1558.00,823.20,110.90}},
	{"Blackfield Chapel",           {1325.60,596.30,-89.00,1375.60,795.00,110.90}},
	{"Blackfield Intersection",     {1197.30,1044.60,-89.00,1277.00,1163.30,110.90}},
	{"Blackfield Intersection",     {1166.50,795.00,-89.00,1375.60,1044.60,110.90}},
	{"Blackfield Intersection",     {1277.00,1044.60,-89.00,1315.30,1087.60,110.90}},
	{"Blackfield Intersection",     {1375.60,823.20,-89.00,1457.30,919.40,110.90}},
	{"Blueberry",                   {104.50,-220.10,2.30,349.60,152.20,200.00}},
	{"Blueberry",                   {19.60,-404.10,3.80,349.60,-220.10,200.00}},
	{"Blueberry Acres",             {-319.60,-220.10,0.00,104.50,293.30,200.00}},
	{"Caligula's Palace",           {2087.30,1543.20,-89.00,2437.30,1703.20,110.90}},
	{"Caligula's Palace",           {2137.40,1703.20,-89.00,2437.30,1783.20,110.90}},
	{"Calton Heights",              {-2274.10,744.10,-6.10,-1982.30,1358.90,200.00}},
	{"Chinatown",                   {-2274.10,578.30,-7.60,-2078.60,744.10,200.00}},
	{"City Hall",                   {-2867.80,277.40,-9.10,-2593.40,458.40,200.00}},
	{"Come-A-Lot",                  {2087.30,943.20,-89.00,2623.10,1203.20,110.90}},
	{"Commerce",                    {1323.90,-1842.20,-89.00,1701.90,-1722.20,110.90}},
	{"Commerce",                    {1323.90,-1722.20,-89.00,1440.90,-1577.50,110.90}},
	{"Commerce",                    {1370.80,-1577.50,-89.00,1463.90,-1384.90,110.90}},
	{"Commerce",                    {1463.90,-1577.50,-89.00,1667.90,-1430.80,110.90}},
	{"Commerce",                    {1583.50,-1722.20,-89.00,1758.90,-1577.50,110.90}},
	{"Commerce",                    {1667.90,-1577.50,-89.00,1812.60,-1430.80,110.90}},
	{"Conference Center",           {1046.10,-1804.20,-89.00,1323.90,-1722.20,110.90}},
	{"Conference Center",           {1073.20,-1842.20,-89.00,1323.90,-1804.20,110.90}},
	{"Cranberry Station",           {-2007.80,56.30,0.00,-1922.00,224.70,100.00}},
	{"Creek",                       {2749.90,1937.20,-89.00,2921.60,2669.70,110.90}},
	{"Dillimore",                   {580.70,-674.80,-9.50,861.00,-404.70,200.00}},
	{"Doherty",                     {-2270.00,-324.10,-0.00,-1794.90,-222.50,200.00}},
	{"Doherty",                     {-2173.00,-222.50,-0.00,-1794.90,265.20,200.00}},
	{"Downtown",                    {-1982.30,744.10,-6.10,-1871.70,1274.20,200.00}},
	{"Downtown",                    {-1871.70,1176.40,-4.50,-1620.30,1274.20,200.00}},
	{"Downtown",                    {-1700.00,744.20,-6.10,-1580.00,1176.50,200.00}},
	{"Downtown",                    {-1580.00,744.20,-6.10,-1499.80,1025.90,200.00}},
	{"Downtown",                    {-2078.60,578.30,-7.60,-1499.80,744.20,200.00}},
	{"Downtown",                    {-1993.20,265.20,-9.10,-1794.90,578.30,200.00}},
	{"Downtown Los Santos",         {1463.90,-1430.80,-89.00,1724.70,-1290.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1430.80,-89.00,1812.60,-1250.90,110.90}},
	{"Downtown Los Santos",         {1463.90,-1290.80,-89.00,1724.70,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1384.90,-89.00,1463.90,-1170.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1250.90,-89.00,1812.60,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1170.80,-89.00,1463.90,-1130.80,110.90}},
	{"Downtown Los Santos",         {1378.30,-1130.80,-89.00,1463.90,-1026.30,110.90}},
	{"Downtown Los Santos",         {1391.00,-1026.30,-89.00,1463.90,-926.90,110.90}},
	{"Downtown Los Santos",         {1507.50,-1385.20,110.90,1582.50,-1325.30,335.90}},
	{"East Beach",                  {2632.80,-1852.80,-89.00,2959.30,-1668.10,110.90}},
	{"East Beach",                  {2632.80,-1668.10,-89.00,2747.70,-1393.40,110.90}},
	{"East Beach",                  {2747.70,-1668.10,-89.00,2959.30,-1498.60,110.90}},
	{"East Beach",                  {2747.70,-1498.60,-89.00,2959.30,-1120.00,110.90}},
	{"East Los Santos",             {2421.00,-1628.50,-89.00,2632.80,-1454.30,110.90}},
	{"East Los Santos",             {2222.50,-1628.50,-89.00,2421.00,-1494.00,110.90}},
	{"East Los Santos",             {2266.20,-1494.00,-89.00,2381.60,-1372.00,110.90}},
	{"East Los Santos",             {2381.60,-1494.00,-89.00,2421.00,-1454.30,110.90}},
	{"East Los Santos",             {2281.40,-1372.00,-89.00,2381.60,-1135.00,110.90}},
	{"East Los Santos",             {2381.60,-1454.30,-89.00,2462.10,-1135.00,110.90}},
	{"East Los Santos",             {2462.10,-1454.30,-89.00,2581.70,-1135.00,110.90}},
	{"Easter Basin",                {-1794.90,249.90,-9.10,-1242.90,578.30,200.00}},
	{"Easter Basin",                {-1794.90,-50.00,-0.00,-1499.80,249.90,200.00}},
	{"Easter Bay Airport",          {-1499.80,-50.00,-0.00,-1242.90,249.90,200.00}},
	{"Easter Bay Airport",          {-1794.90,-730.10,-3.00,-1213.90,-50.00,200.00}},
	{"Easter Bay Airport",          {-1213.90,-730.10,0.00,-1132.80,-50.00,200.00}},
	{"Easter Bay Airport",          {-1242.90,-50.00,0.00,-1213.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1213.90,-50.00,-4.50,-947.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1315.40,-405.30,15.40,-1264.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1354.30,-287.30,15.40,-1315.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1490.30,-209.50,15.40,-1264.40,-148.30,25.40}},
	{"Easter Bay Chemicals",        {-1132.80,-768.00,0.00,-956.40,-578.10,200.00}},
	{"Easter Bay Chemicals",        {-1132.80,-787.30,0.00,-956.40,-768.00,200.00}},
	{"El Castillo del Diablo",      {-464.50,2217.60,0.00,-208.50,2580.30,200.00}},
	{"El Castillo del Diablo",      {-208.50,2123.00,-7.60,114.00,2337.10,200.00}},
	{"El Castillo del Diablo",      {-208.50,2337.10,0.00,8.40,2487.10,200.00}},
	{"El Corona",                   {1812.60,-2179.20,-89.00,1970.60,-1852.80,110.90}},
	{"El Corona",                   {1692.60,-2179.20,-89.00,1812.60,-1842.20,110.90}},
	{"El Quebrados",                {-1645.20,2498.50,0.00,-1372.10,2777.80,200.00}},
	{"Esplanade East",              {-1620.30,1176.50,-4.50,-1580.00,1274.20,200.00}},
	{"Esplanade East",              {-1580.00,1025.90,-6.10,-1499.80,1274.20,200.00}},
	{"Esplanade East",              {-1499.80,578.30,-79.60,-1339.80,1274.20,20.30}},
	{"Esplanade North",             {-2533.00,1358.90,-4.50,-1996.60,1501.20,200.00}},
	{"Esplanade North",             {-1996.60,1358.90,-4.50,-1524.20,1592.50,200.00}},
	{"Esplanade North",             {-1982.30,1274.20,-4.50,-1524.20,1358.90,200.00}},
	{"Fallen Tree",                 {-792.20,-698.50,-5.30,-452.40,-380.00,200.00}},
	{"Fallow Bridge",               {434.30,366.50,0.00,603.00,555.60,200.00}},
	{"Fern Ridge",                  {508.10,-139.20,0.00,1306.60,119.50,200.00}},
	{"Financial",                   {-1871.70,744.10,-6.10,-1701.30,1176.40,300.00}},
	{"Fisher's Lagoon",             {1916.90,-233.30,-100.00,2131.70,13.80,200.00}},
	{"Flint Intersection",          {-187.70,-1596.70,-89.00,17.00,-1276.60,110.90}},
	{"Flint Range",                 {-594.10,-1648.50,0.00,-187.70,-1276.60,200.00}},
	{"Fort Carson",                 {-376.20,826.30,-3.00,123.70,1220.40,200.00}},
	{"Foster Valley",               {-2270.00,-430.20,-0.00,-2178.60,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-599.80,-0.00,-1794.90,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-1115.50,0.00,-1794.90,-599.80,200.00}},
	{"Foster Valley",               {-2178.60,-1250.90,0.00,-1794.90,-1115.50,200.00}},
	{"Frederick Bridge",            {2759.20,296.50,0.00,2774.20,594.70,200.00}},
	{"Gant Bridge",                 {-2741.40,1659.60,-6.10,-2616.40,2175.10,200.00}},
	{"Gant Bridge",                 {-2741.00,1490.40,-6.10,-2616.40,1659.60,200.00}},
	{"Ganton",                      {2222.50,-1852.80,-89.00,2632.80,-1722.30,110.90}},
	{"Ganton",                      {2222.50,-1722.30,-89.00,2632.80,-1628.50,110.90}},
	{"Garcia",                      {-2411.20,-222.50,-0.00,-2173.00,265.20,200.00}},
	{"Garcia",                      {-2395.10,-222.50,-5.30,-2354.00,-204.70,200.00}},
	{"Garver Bridge",               {-1339.80,828.10,-89.00,-1213.90,1057.00,110.90}},
	{"Garver Bridge",               {-1213.90,950.00,-89.00,-1087.90,1178.90,110.90}},
	{"Garver Bridge",               {-1499.80,696.40,-179.60,-1339.80,925.30,20.30}},
	{"Glen Park",                   {1812.60,-1449.60,-89.00,1996.90,-1350.70,110.90}},
	{"Glen Park",                   {1812.60,-1100.80,-89.00,1994.30,-973.30,110.90}},
	{"Glen Park",                   {1812.60,-1350.70,-89.00,2056.80,-1100.80,110.90}},
	{"Green Palms",                 {176.50,1305.40,-3.00,338.60,1520.70,200.00}},
	{"Greenglass College",          {964.30,1044.60,-89.00,1197.30,1203.20,110.90}},
	{"Greenglass College",          {964.30,930.80,-89.00,1166.50,1044.60,110.90}},
	{"Hampton Barns",               {603.00,264.30,0.00,761.90,366.50,200.00}},
	{"Hankypanky Point",            {2576.90,62.10,0.00,2759.20,385.50,200.00}},
	{"Harry Gold Parkway",          {1777.30,863.20,-89.00,1817.30,2342.80,110.90}},
	{"Hashbury",                    {-2593.40,-222.50,-0.00,-2411.20,54.70,200.00}},
	{"Hilltop Farm",                {967.30,-450.30,-3.00,1176.70,-217.90,200.00}},
	{"Hunter Quarry",               {337.20,710.80,-115.20,860.50,1031.70,203.70}},
	{"Idlewood",                    {1812.60,-1852.80,-89.00,1971.60,-1742.30,110.90}},
	{"Idlewood",                    {1812.60,-1742.30,-89.00,1951.60,-1602.30,110.90}},
	{"Idlewood",                    {1951.60,-1742.30,-89.00,2124.60,-1602.30,110.90}},
	{"Idlewood",                    {1812.60,-1602.30,-89.00,2124.60,-1449.60,110.90}},
	{"Idlewood",                    {2124.60,-1742.30,-89.00,2222.50,-1494.00,110.90}},
	{"Idlewood",                    {1971.60,-1852.80,-89.00,2222.50,-1742.30,110.90}},
	{"Jefferson",                   {1996.90,-1449.60,-89.00,2056.80,-1350.70,110.90}},
	{"Jefferson",                   {2124.60,-1494.00,-89.00,2266.20,-1449.60,110.90}},
	{"Jefferson",                   {2056.80,-1372.00,-89.00,2281.40,-1210.70,110.90}},
	{"Jefferson",                   {2056.80,-1210.70,-89.00,2185.30,-1126.30,110.90}},
	{"Jefferson",                   {2185.30,-1210.70,-89.00,2281.40,-1154.50,110.90}},
	{"Jefferson",                   {2056.80,-1449.60,-89.00,2266.20,-1372.00,110.90}},
	{"Julius Thruway East",         {2623.10,943.20,-89.00,2749.90,1055.90,110.90}},
	{"Julius Thruway East",         {2685.10,1055.90,-89.00,2749.90,2626.50,110.90}},
	{"Julius Thruway East",         {2536.40,2442.50,-89.00,2685.10,2542.50,110.90}},
	{"Julius Thruway East",         {2625.10,2202.70,-89.00,2685.10,2442.50,110.90}},
	{"Julius Thruway North",        {2498.20,2542.50,-89.00,2685.10,2626.50,110.90}},
	{"Julius Thruway North",        {2237.40,2542.50,-89.00,2498.20,2663.10,110.90}},
	{"Julius Thruway North",        {2121.40,2508.20,-89.00,2237.40,2663.10,110.90}},
	{"Julius Thruway North",        {1938.80,2508.20,-89.00,2121.40,2624.20,110.90}},
	{"Julius Thruway North",        {1534.50,2433.20,-89.00,1848.40,2583.20,110.90}},
	{"Julius Thruway North",        {1848.40,2478.40,-89.00,1938.80,2553.40,110.90}},
	{"Julius Thruway North",        {1704.50,2342.80,-89.00,1848.40,2433.20,110.90}},
	{"Julius Thruway North",        {1377.30,2433.20,-89.00,1534.50,2507.20,110.90}},
	{"Julius Thruway South",        {1457.30,823.20,-89.00,2377.30,863.20,110.90}},
	{"Julius Thruway South",        {2377.30,788.80,-89.00,2537.30,897.90,110.90}},
	{"Julius Thruway West",         {1197.30,1163.30,-89.00,1236.60,2243.20,110.90}},
	{"Julius Thruway West",         {1236.60,2142.80,-89.00,1297.40,2243.20,110.90}},
	{"Juniper Hill",                {-2533.00,578.30,-7.60,-2274.10,968.30,200.00}},
	{"Juniper Hollow",              {-2533.00,968.30,-6.10,-2274.10,1358.90,200.00}},
	{"K.A.C.C. Military Fuels",     {2498.20,2626.50,-89.00,2749.90,2861.50,110.90}},
	{"Kincaid Bridge",              {-1339.80,599.20,-89.00,-1213.90,828.10,110.90}},
	{"Kincaid Bridge",              {-1213.90,721.10,-89.00,-1087.90,950.00,110.90}},
	{"Kincaid Bridge",              {-1087.90,855.30,-89.00,-961.90,986.20,110.90}},
	{"King's",                      {-2329.30,458.40,-7.60,-1993.20,578.30,200.00}},
	{"King's",                      {-2411.20,265.20,-9.10,-1993.20,373.50,200.00}},
	{"King's",                      {-2253.50,373.50,-9.10,-1993.20,458.40,200.00}},
	{"LVA Freight Depot",           {1457.30,863.20,-89.00,1777.40,1143.20,110.90}},
	{"LVA Freight Depot",           {1375.60,919.40,-89.00,1457.30,1203.20,110.90}},
	{"LVA Freight Depot",           {1277.00,1087.60,-89.00,1375.60,1203.20,110.90}},
	{"LVA Freight Depot",           {1315.30,1044.60,-89.00,1375.60,1087.60,110.90}},
	{"LVA Freight Depot",           {1236.60,1163.40,-89.00,1277.00,1203.20,110.90}},
	{"Las Barrancas",               {-926.10,1398.70,-3.00,-719.20,1634.60,200.00}},
	{"Las Brujas",                  {-365.10,2123.00,-3.00,-208.50,2217.60,200.00}},
	{"Las Colinas",                 {1994.30,-1100.80,-89.00,2056.80,-920.80,110.90}},
	{"Las Colinas",                 {2056.80,-1126.30,-89.00,2126.80,-920.80,110.90}},
	{"Las Colinas",                 {2185.30,-1154.50,-89.00,2281.40,-934.40,110.90}},
	{"Las Colinas",                 {2126.80,-1126.30,-89.00,2185.30,-934.40,110.90}},
	{"Las Colinas",                 {2747.70,-1120.00,-89.00,2959.30,-945.00,110.90}},
	{"Las Colinas",                 {2632.70,-1135.00,-89.00,2747.70,-945.00,110.90}},
	{"Las Colinas",                 {2281.40,-1135.00,-89.00,2632.70,-945.00,110.90}},
	{"Las Payasadas",               {-354.30,2580.30,2.00,-133.60,2816.80,200.00}},
	{"Las Venturas Airport",        {1236.60,1203.20,-89.00,1457.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1203.20,-89.00,1777.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1143.20,-89.00,1777.40,1203.20,110.90}},
	{"Las Venturas Airport",        {1515.80,1586.40,-12.50,1729.90,1714.50,87.50}},
	{"Last Dime Motel",             {1823.00,596.30,-89.00,1997.20,823.20,110.90}},
	{"Leafy Hollow",                {-1166.90,-1856.00,0.00,-815.60,-1602.00,200.00}},
	{"Liberty City",                {-1000.00,400.00,1300.00,-700.00,600.00,1400.00}},
	{"Lil' Probe Inn",              {-90.20,1286.80,-3.00,153.80,1554.10,200.00}},
	{"Linden Side",                 {2749.90,943.20,-89.00,2923.30,1198.90,110.90}},
	{"Linden Station",              {2749.90,1198.90,-89.00,2923.30,1548.90,110.90}},
	{"Linden Station",              {2811.20,1229.50,-39.50,2861.20,1407.50,60.40}},
	{"Little Mexico",               {1701.90,-1842.20,-89.00,1812.60,-1722.20,110.90}},
	{"Little Mexico",               {1758.90,-1722.20,-89.00,1812.60,-1577.50,110.90}},
	{"Los Flores",                  {2581.70,-1454.30,-89.00,2632.80,-1393.40,110.90}},
	{"Los Flores",                  {2581.70,-1393.40,-89.00,2747.70,-1135.00,110.90}},
	{"Los Santos International",    {1249.60,-2394.30,-89.00,1852.00,-2179.20,110.90}},
	{"Los Santos International",    {1852.00,-2394.30,-89.00,2089.00,-2179.20,110.90}},
	{"Los Santos International",    {1382.70,-2730.80,-89.00,2201.80,-2394.30,110.90}},
	{"Los Santos International",    {1974.60,-2394.30,-39.00,2089.00,-2256.50,60.90}},
	{"Los Santos International",    {1400.90,-2669.20,-39.00,2189.80,-2597.20,60.90}},
	{"Los Santos International",    {2051.60,-2597.20,-39.00,2152.40,-2394.30,60.90}},
	{"Marina",                      {647.70,-1804.20,-89.00,851.40,-1577.50,110.90}},
	{"Marina",                      {647.70,-1577.50,-89.00,807.90,-1416.20,110.90}},
	{"Marina",                      {807.90,-1577.50,-89.00,926.90,-1416.20,110.90}},
	{"Market",                      {787.40,-1416.20,-89.00,1072.60,-1310.20,110.90}},
	{"Market",                      {952.60,-1310.20,-89.00,1072.60,-1130.80,110.90}},
	{"Market",                      {1072.60,-1416.20,-89.00,1370.80,-1130.80,110.90}},
	{"Market",                      {926.90,-1577.50,-89.00,1370.80,-1416.20,110.90}},
	{"Market Station",              {787.40,-1410.90,-34.10,866.00,-1310.20,65.80}},
	{"Martin Bridge",               {-222.10,293.30,0.00,-122.10,476.40,200.00}},
	{"Missionary Hill",             {-2994.40,-811.20,0.00,-2178.60,-430.20,200.00}},
	{"Montgomery",                  {1119.50,119.50,-3.00,1451.40,493.30,200.00}},
	{"Montgomery",                  {1451.40,347.40,-6.10,1582.40,420.80,200.00}},
	{"Montgomery Intersection",     {1546.60,208.10,0.00,1745.80,347.40,200.00}},
	{"Montgomery Intersection",     {1582.40,347.40,0.00,1664.60,401.70,200.00}},
	{"Mulholland",                  {1414.00,-768.00,-89.00,1667.60,-452.40,110.90}},
	{"Mulholland",                  {1281.10,-452.40,-89.00,1641.10,-290.90,110.90}},
	{"Mulholland",                  {1269.10,-768.00,-89.00,1414.00,-452.40,110.90}},
	{"Mulholland",                  {1357.00,-926.90,-89.00,1463.90,-768.00,110.90}},
	{"Mulholland",                  {1318.10,-910.10,-89.00,1357.00,-768.00,110.90}},
	{"Mulholland",                  {1169.10,-910.10,-89.00,1318.10,-768.00,110.90}},
	{"Mulholland",                  {768.60,-954.60,-89.00,952.60,-860.60,110.90}},
	{"Mulholland",                  {687.80,-860.60,-89.00,911.80,-768.00,110.90}},
	{"Mulholland",                  {737.50,-768.00,-89.00,1142.20,-674.80,110.90}},
	{"Mulholland",                  {1096.40,-910.10,-89.00,1169.10,-768.00,110.90}},
	{"Mulholland",                  {952.60,-937.10,-89.00,1096.40,-860.60,110.90}},
	{"Mulholland",                  {911.80,-860.60,-89.00,1096.40,-768.00,110.90}},
	{"Mulholland",                  {861.00,-674.80,-89.00,1156.50,-600.80,110.90}},
	{"Mulholland Intersection",     {1463.90,-1150.80,-89.00,1812.60,-768.00,110.90}},
	{"North Rock",                  {2285.30,-768.00,0.00,2770.50,-269.70,200.00}},
	{"Ocean Docks",                 {2373.70,-2697.00,-89.00,2809.20,-2330.40,110.90}},
	{"Ocean Docks",                 {2201.80,-2418.30,-89.00,2324.00,-2095.00,110.90}},
	{"Ocean Docks",                 {2324.00,-2302.30,-89.00,2703.50,-2145.10,110.90}},
	{"Ocean Docks",                 {2089.00,-2394.30,-89.00,2201.80,-2235.80,110.90}},
	{"Ocean Docks",                 {2201.80,-2730.80,-89.00,2324.00,-2418.30,110.90}},
	{"Ocean Docks",                 {2703.50,-2302.30,-89.00,2959.30,-2126.90,110.90}},
	{"Ocean Docks",                 {2324.00,-2145.10,-89.00,2703.50,-2059.20,110.90}},
	{"Ocean Flats",                 {-2994.40,277.40,-9.10,-2867.80,458.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-222.50,-0.00,-2593.40,277.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-430.20,-0.00,-2831.80,-222.50,200.00}},
	{"Octane Springs",              {338.60,1228.50,0.00,664.30,1655.00,200.00}},
	{"Old Venturas Strip",          {2162.30,2012.10,-89.00,2685.10,2202.70,110.90}},
	{"Palisades",                   {-2994.40,458.40,-6.10,-2741.00,1339.60,200.00}},
	{"Palomino Creek",              {2160.20,-149.00,0.00,2576.90,228.30,200.00}},
	{"Paradiso",                    {-2741.00,793.40,-6.10,-2533.00,1268.40,200.00}},
	{"Pershing Square",             {1440.90,-1722.20,-89.00,1583.50,-1577.50,110.90}},
	{"Pilgrim",                     {2437.30,1383.20,-89.00,2624.40,1783.20,110.90}},
	{"Pilgrim",                     {2624.40,1383.20,-89.00,2685.10,1783.20,110.90}},
	{"Pilson Intersection",         {1098.30,2243.20,-89.00,1377.30,2507.20,110.90}},
	{"Pirates in Men's Pants",      {1817.30,1469.20,-89.00,2027.40,1703.20,110.90}},
	{"Playa del Seville",           {2703.50,-2126.90,-89.00,2959.30,-1852.80,110.90}},
	{"Prickle Pine",                {1534.50,2583.20,-89.00,1848.40,2863.20,110.90}},
	{"Prickle Pine",                {1117.40,2507.20,-89.00,1534.50,2723.20,110.90}},
	{"Prickle Pine",                {1848.40,2553.40,-89.00,1938.80,2863.20,110.90}},
	{"Prickle Pine",                {1938.80,2624.20,-89.00,2121.40,2861.50,110.90}},
	{"Queens",                      {-2533.00,458.40,0.00,-2329.30,578.30,200.00}},
	{"Queens",                      {-2593.40,54.70,0.00,-2411.20,458.40,200.00}},
	{"Queens",                      {-2411.20,373.50,0.00,-2253.50,458.40,200.00}},
	{"Randolph Industrial Estate",  {1558.00,596.30,-89.00,1823.00,823.20,110.90}},
	{"Redsands East",               {1817.30,2011.80,-89.00,2106.70,2202.70,110.90}},
	{"Redsands East",               {1817.30,2202.70,-89.00,2011.90,2342.80,110.90}},
	{"Redsands East",               {1848.40,2342.80,-89.00,2011.90,2478.40,110.90}},
	{"Redsands West",               {1236.60,1883.10,-89.00,1777.30,2142.80,110.90}},
	{"Redsands West",               {1297.40,2142.80,-89.00,1777.30,2243.20,110.90}},
	{"Redsands West",               {1377.30,2243.20,-89.00,1704.50,2433.20,110.90}},
	{"Redsands West",               {1704.50,2243.20,-89.00,1777.30,2342.80,110.90}},
	{"Regular Tom",                 {-405.70,1712.80,-3.00,-276.70,1892.70,200.00}},
	{"Richman",                     {647.50,-1118.20,-89.00,787.40,-954.60,110.90}},
	{"Richman",                     {647.50,-954.60,-89.00,768.60,-860.60,110.90}},
	{"Richman",                     {225.10,-1369.60,-89.00,334.50,-1292.00,110.90}},
	{"Richman",                     {225.10,-1292.00,-89.00,466.20,-1235.00,110.90}},
	{"Richman",                     {72.60,-1404.90,-89.00,225.10,-1235.00,110.90}},
	{"Richman",                     {72.60,-1235.00,-89.00,321.30,-1008.10,110.90}},
	{"Richman",                     {321.30,-1235.00,-89.00,647.50,-1044.00,110.90}},
	{"Richman",                     {321.30,-1044.00,-89.00,647.50,-860.60,110.90}},
	{"Richman",                     {321.30,-860.60,-89.00,687.80,-768.00,110.90}},
	{"Richman",                     {321.30,-768.00,-89.00,700.70,-674.80,110.90}},
	{"Robada Intersection",         {-1119.00,1178.90,-89.00,-862.00,1351.40,110.90}},
	{"Roca Escalante",              {2237.40,2202.70,-89.00,2536.40,2542.50,110.90}},
	{"Roca Escalante",              {2536.40,2202.70,-89.00,2625.10,2442.50,110.90}},
	{"Rockshore East",              {2537.30,676.50,-89.00,2902.30,943.20,110.90}},
	{"Rockshore West",              {1997.20,596.30,-89.00,2377.30,823.20,110.90}},
	{"Rockshore West",              {2377.30,596.30,-89.00,2537.30,788.80,110.90}},
	{"Rodeo",                       {72.60,-1684.60,-89.00,225.10,-1544.10,110.90}},
	{"Rodeo",                       {72.60,-1544.10,-89.00,225.10,-1404.90,110.90}},
	{"Rodeo",                       {225.10,-1684.60,-89.00,312.80,-1501.90,110.90}},
	{"Rodeo",                       {225.10,-1501.90,-89.00,334.50,-1369.60,110.90}},
	{"Rodeo",                       {334.50,-1501.90,-89.00,422.60,-1406.00,110.90}},
	{"Rodeo",                       {312.80,-1684.60,-89.00,422.60,-1501.90,110.90}},
	{"Rodeo",                       {422.60,-1684.60,-89.00,558.00,-1570.20,110.90}},
	{"Rodeo",                       {558.00,-1684.60,-89.00,647.50,-1384.90,110.90}},
	{"Rodeo",                       {466.20,-1570.20,-89.00,558.00,-1385.00,110.90}},
	{"Rodeo",                       {422.60,-1570.20,-89.00,466.20,-1406.00,110.90}},
	{"Rodeo",                       {466.20,-1385.00,-89.00,647.50,-1235.00,110.90}},
	{"Rodeo",                       {334.50,-1406.00,-89.00,466.20,-1292.00,110.90}},
	{"Royal Casino",                {2087.30,1383.20,-89.00,2437.30,1543.20,110.90}},
	{"San Andreas Sound",           {2450.30,385.50,-100.00,2759.20,562.30,200.00}},
	{"Santa Flora",                 {-2741.00,458.40,-7.60,-2533.00,793.40,200.00}},
	{"Santa Maria Beach",           {342.60,-2173.20,-89.00,647.70,-1684.60,110.90}},
	{"Santa Maria Beach",           {72.60,-2173.20,-89.00,342.60,-1684.60,110.90}},
	{"Shady Cabin",                 {-1632.80,-2263.40,-3.00,-1601.30,-2231.70,200.00}},
	{"Shady Creeks",                {-1820.60,-2643.60,-8.00,-1226.70,-1771.60,200.00}},
	{"Shady Creeks",                {-2030.10,-2174.80,-6.10,-1820.60,-1771.60,200.00}},
	{"Sobell Rail Yards",           {2749.90,1548.90,-89.00,2923.30,1937.20,110.90}},
	{"Spinybed",                    {2121.40,2663.10,-89.00,2498.20,2861.50,110.90}},
	{"Starfish Casino",             {2437.30,1783.20,-89.00,2685.10,2012.10,110.90}},
	{"Starfish Casino",             {2437.30,1858.10,-39.00,2495.00,1970.80,60.90}},
	{"Starfish Casino",             {2162.30,1883.20,-89.00,2437.30,2012.10,110.90}},
	{"Temple",                      {1252.30,-1130.80,-89.00,1378.30,-1026.30,110.90}},
	{"Temple",                      {1252.30,-1026.30,-89.00,1391.00,-926.90,110.90}},
	{"Temple",                      {1252.30,-926.90,-89.00,1357.00,-910.10,110.90}},
	{"Temple",                      {952.60,-1130.80,-89.00,1096.40,-937.10,110.90}},
	{"Temple",                      {1096.40,-1130.80,-89.00,1252.30,-1026.30,110.90}},
	{"Temple",                      {1096.40,-1026.30,-89.00,1252.30,-910.10,110.90}},
	{"The Camel's Toe",             {2087.30,1203.20,-89.00,2640.40,1383.20,110.90}},
	{"The Clown's Pocket",          {2162.30,1783.20,-89.00,2437.30,1883.20,110.90}},
	{"The Emerald Isle",            {2011.90,2202.70,-89.00,2237.40,2508.20,110.90}},
	{"The Farm",                    {-1209.60,-1317.10,114.90,-908.10,-787.30,251.90}},
	{"The Four Dragons Casino",     {1817.30,863.20,-89.00,2027.30,1083.20,110.90}},
	{"The High Roller",             {1817.30,1283.20,-89.00,2027.30,1469.20,110.90}},
	{"The Mako Span",               {1664.60,401.70,0.00,1785.10,567.20,200.00}},
	{"The Panopticon",              {-947.90,-304.30,-1.10,-319.60,327.00,200.00}},
	{"The Pink Swan",               {1817.30,1083.20,-89.00,2027.30,1283.20,110.90}},
	{"The Sherman Dam",             {-968.70,1929.40,-3.00,-481.10,2155.20,200.00}},
	{"The Strip",                   {2027.40,863.20,-89.00,2087.30,1703.20,110.90}},
	{"The Strip",                   {2106.70,1863.20,-89.00,2162.30,2202.70,110.90}},
	{"The Strip",                   {2027.40,1783.20,-89.00,2162.30,1863.20,110.90}},
	{"The Strip",                   {2027.40,1703.20,-89.00,2137.40,1783.20,110.90}},
	{"The Visage",                  {1817.30,1863.20,-89.00,2106.70,2011.80,110.90}},
	{"The Visage",                  {1817.30,1703.20,-89.00,2027.40,1863.20,110.90}},
	{"Unity Station",               {1692.60,-1971.80,-20.40,1812.60,-1932.80,79.50}},
	{"Valle Ocultado",              {-936.60,2611.40,2.00,-715.90,2847.90,200.00}},
	{"Verdant Bluffs",              {930.20,-2488.40,-89.00,1249.60,-2006.70,110.90}},
	{"Verdant Bluffs",              {1073.20,-2006.70,-89.00,1249.60,-1842.20,110.90}},
	{"Verdant Bluffs",              {1249.60,-2179.20,-89.00,1692.60,-1842.20,110.90}},
	{"Verdant Meadows",             {37.00,2337.10,-3.00,435.90,2677.90,200.00}},
	{"Verona Beach",                {647.70,-2173.20,-89.00,930.20,-1804.20,110.90}},
	{"Verona Beach",                {930.20,-2006.70,-89.00,1073.20,-1804.20,110.90}},
	{"Verona Beach",                {851.40,-1804.20,-89.00,1046.10,-1577.50,110.90}},
	{"Verona Beach",                {1161.50,-1722.20,-89.00,1323.90,-1577.50,110.90}},
	{"Verona Beach",                {1046.10,-1722.20,-89.00,1161.50,-1577.50,110.90}},
	{"Vinewood",                    {787.40,-1310.20,-89.00,952.60,-1130.80,110.90}},
	{"Vinewood",                    {787.40,-1130.80,-89.00,952.60,-954.60,110.90}},
	{"Vinewood",                    {647.50,-1227.20,-89.00,787.40,-1118.20,110.90}},
	{"Vinewood",                    {647.70,-1416.20,-89.00,787.40,-1227.20,110.90}},
	{"Whitewood Estates",           {883.30,1726.20,-89.00,1098.30,2507.20,110.90}},
	{"Whitewood Estates",           {1098.30,1726.20,-89.00,1197.30,2243.20,110.90}},
	{"Willowfield",                 {1970.60,-2179.20,-89.00,2089.00,-1852.80,110.90}},
	{"Willowfield",                 {2089.00,-2235.80,-89.00,2201.80,-1989.90,110.90}},
	{"Willowfield",                 {2089.00,-1989.90,-89.00,2324.00,-1852.80,110.90}},
	{"Willowfield",                 {2201.80,-2095.00,-89.00,2324.00,-1989.90,110.90}},
	{"Willowfield",                 {2541.70,-1941.40,-89.00,2703.50,-1852.80,110.90}},
	{"Willowfield",                 {2324.00,-2059.20,-89.00,2541.70,-1852.80,110.90}},
	{"Willowfield",                 {2541.70,-2059.20,-89.00,2703.50,-1941.40,110.90}},
	{"Yellow Bell Station",         {1377.40,2600.40,-21.90,1492.40,2687.30,78.00}},
	// Main Zones
	{"Los Santos",                  {44.60,-2892.90,-242.90,2997.00,-768.00,900.00}},
	{"Las Venturas",                {869.40,596.30,-242.90,2997.00,2993.80,900.00}},
	{"Bone County",                 {-480.50,596.30,-242.90,869.40,2993.80,900.00}},
	{"Tierra Robada",               {-2997.40,1659.60,-242.90,-480.50,2993.80,900.00}},
	{"Tierra Robada",               {-1213.90,596.30,-242.90,-480.50,1659.60,900.00}},
	{"San Fierro",                  {-2997.40,-1115.50,-242.90,-1213.90,1659.60,900.00}},
	{"Red County",                  {-1213.90,-768.00,-242.90,2997.00,596.30,900.00}},
	{"Flint County",                {-1213.90,-2892.90,-242.90,44.60,-768.00,900.00}},
	{"Whetstone",                   {-2997.40,-2892.90,-242.90,-1213.90,-1115.50,900.00}}
};

//=========================================================================================

main()
{
	print("_________________________________________________________________________");
	printf("> %s - %s by %s loaded.", GAMEMODE,MAP_NAME,DEVELOPER);
	printf("> Server Name: %s", SERVER_NAME);
	if (!strcmp("Yes", GAMEMODE_USE_VERSION, true)) { printf("> Gamemode: %s - %s", GAMEMODE,VERSION); } else { printf("> Gamemode: %s", GAMEMODE); } // Checking the "GAMEMODE_USE_VERSION" define, if "Yes" then set the gamemode text to the gamemode name & version, else set it to just the gamemode name.
	printf("> Version: %s", VERSION);
	printf("> Map: %s", MAP_NAME);
	printf("> Website: %s", WEBSITE);
	printf("> Developer: %s", DEVELOPER);
	printf("> Last Update: %s", LAST_UPDATE);
	printf("> Current Script Lines: %d", SCRIPT_LINES);
 	printf("> Password: %s", ShowServerPassword());
	print("_________________________________________________________________________");
}


public OnGameModeInit()
{
	//mysql_connect("46.29.23.78", "rg2_s16545", "rg2_s16545", "rDAvzL");
	mysql_connect("localhost", "thorus", "piast", "thorus");
	if(mysql_ping() == 1)
	{
	    print("Serwer:] Polaczylem sie z baza danych!");
	}
	else
	{
	    print("Serwer:] Brak polaczenia z baza danych!");
	}
	if(fexist("CRP_Scriptfiles/Other/JoinCounter.cfg"))
	{
	    JoinCounter = dini_Int("CRP_Scriptfiles/Other/JoinCounter.cfg", "Connections");
	    printf("file \"JoinCounter.txt\" located, variable JoinCounter loaded (%d visitors)", JoinCounter);
	}
	else
	{
	    dini_Create("CRP_Scriptfiles/Other/JoinCounter.cfg");
	    dini_IntSet("CRP_Scriptfiles/Other/JoinCounter.cfg", "Connections", 0);
	    print("file \"CRP_Scriptfiles/Other/JoinCounter.cfg\" created with JoinCounter variable (0 visitors)");
	}
	//================================[SETTING FUEL AND TURNING ENGINES OFF]==============================
	for(new c=0;c<MAX_VEHICLES;c++)
	{
		Fuel[c] = GasMax;
		EngineStatus[c] = 0;
		VehicleLocked[c] = 0;
		CarWindowStatus[c] = 1; //1 = up, 0 = down.
	}
   	for(new i = 0; i < MAX_PLAYERS; i++)// 499.000000, 104.416679
    {
        bank2[i] = TextDrawCreate(499.000000, 104.416679, "");
		TextDrawLetterSize(bank2[i], 0.449999, 1.600000);
		TextDrawAlignment(bank2[i], 1);
		TextDrawColor(bank2[i], 8388863);
		TextDrawSetShadow(bank2[i], 0);
		TextDrawSetOutline(bank2[i], 1);
		TextDrawBackgroundColor(bank2[i], 51);
		TextDrawFont(bank2[i], 3);
		TextDrawSetProportional(bank2[i], 1);
	}
	mysql_debug(1);
	//=====================================================================================================
	
	//===============================[DISABLING STUFF]================================
	ShowPlayerMarkers(0);
	EnableStuntBonusForAll(0); //Disable stunt bonus.
    DisableInteriorEnterExits();//Disable Yellow Markers.
    AllowInteriorWeapons(1);//Allowing weapons inside.
	EnableTirePopping(1);
	EnableZoneNames(1);
	AllowAdminTeleport(1);
	UsePlayerPedAnims();
	new sendcmd[128];
	//================================================================================
	
	//=======================[Setting the servers stats]==============================
	if (!strcmp("Yes", GAMEMODE_USE_VERSION, true)) { format(sendcmd, sizeof(sendcmd), "%s - %s", GAMEMODE,VERSION); SetGameModeText(sendcmd); }
	else { SetGameModeText(GAMEMODE); }
	format(sendcmd, sizeof(sendcmd), "mapname %s", MAP_NAME);
	SendRconCommand(sendcmd);
	format(sendcmd, sizeof(sendcmd), "weburl %s", WEBSITE);
	SendRconCommand(sendcmd);
	if (strlen(PASSWORD) != 0) { format(sendcmd, sizeof(sendcmd), "password %s", PASSWORD); SendRconCommand(sendcmd); }
	//================================================================================
	
	//========================================[LOAD]==========================================
	LoadScript();
	//========================================================================================

	//====================================[NON DYNAMIC PICKUPS]===========================================
	
	//====================================================================================================
	
//===================================[WORLD TIME TO SERVER TIME]====================================
	if (realtime)
	{
		new tmphour;
		new tmpminute;
		new tmpsecond;
		gettime(tmphour, tmpminute, tmpsecond);
		FixHour(tmphour);
		tmphour = shifthour;
		SetWorldTime(tmphour);
	}
//===================================[TIMERS]===============================================
	SetTimer("UpdateData", 5000, 1);//Updates scores, and syncs time of day
	SetTimer("SaveAccounts", 1800000, 1); //30 mins every account saved
	SetTimer("Update", 300000, 1);//Update every 5 minutes
	SetTimer("UpdateMoney", 1000, 1);//AntiMoney hack timer
	SetTimer("PickupGametexts", 1000, 1); //Timer that shows gametexts if the player is on a pickup/location.
	SetTimer("FuelTimer", 15000, 1); //Car Fuel System
	SetTimer("OtherTimer", 15000, 1);
	SetTimer("JailTimer", 1000, 1);
	SetTimer("StreamPickups",1000,1);//Streaming pickups
	return 1;
}

public OnGameModeExit()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    TextDrawDestroy(bank2[i]);
	}
	return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	format(tekst, sizeof(tekst), "select `id` from `accounts` where `login`='%s'", PlayerName(playerid));
	mysql_query(tekst);
	mysql_store_result();
	if(mysql_num_rows())
	{
	    ShowPlayerDialog(playerid, logowanie, DIALOG_STYLE_PASSWORD, "Witaj - zaloguj siê na konto serwerowe", "Ju¿ istnieje konto z tak¹ nazw¹, jeœli to nie ty zarejestruj siê lub zmieñ nick.\nPodaj has³o do konta.", "Zaloguj", "Anuluj");
	}
	else
	{
	    ShowPlayerDialog(playerid, rejestracja, DIALOG_STYLE_PASSWORD, "Witaj - zarejestruj siê na naszym serwerze", "Rejestruj¹c sie akceptujesz regulamin naszego serwera, jest on dostepny na naszym forum.\nPodaj has³o do swojego konta.", "Dalej", "Anuluj");
	}
	mysql_free_result();
	if(gPlayerLogged[playerid])
	{
		SpawnPlayer(playerid);
		return 1;
	}
	SetPlayerCameraPos(playerid, 77.9485, 1010.7545, 145.9319);
	SetPlayerCameraLookAt(playerid, 77.2622, 1011.4880, 144.8123);
   	return 0;
}
public OnPlayerRequestSpawn(playerid)
{
	if(gPlayerLogged[playerid] == 1)
	{
		return 1;
	}
	else
	{
	    if(SpawnAttempts[playerid] >= MAX_SPAWN_ATTEMPTS)
	    {
	        KickPlayer(playerid,"System","kilka prób zalogowania siê bez podania has³a.");
			return 1;
	    }
		SendClientMessage(playerid,COLOR_RED,"[INFO:] Najpierw siê zaloguj!");
		SpawnAttempts[playerid] ++;
		return 0;
	}
}

public OnPlayerConnect(playerid)
{
	//==================[Join Counter]=========================
	JoinCounter = JoinCounter + 1;
	dini_IntSet("CRP_Scriptfiles/Other/JoinCounter.cfg", "Connections", JoinCounter);
	//=========================================================
	
	ResetStats(playerid);//Setting variables to 0.
	ClearScreen(playerid);//Clearing the users screen from SA-MP messages.
	ShowScriptStats(playerid);//Showing the script information.
	TextDrawShowForPlayer(playerid, bank2[playerid]);
	SetTimerEx("BankTD", 1000, true, "d", playerid);
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Witamy na serwerze!");
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Mapa jest jeszcze nie gotowa w 100%");
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Informacje o gamemodzie znajdziesz na naszym forum {f7749f}www.classicrpg.xaa.pl");
	return 1;
}
public LoadScript()
{
	LoadDynamicFactions();
	LoadDynamicCars();
	LoadCivilianSpawn();
	LoadBuildings();
	LoadHouses();
	LoadBusinesses();
	LoadFactionMaterialsStorage();
	LoadFactionDrugsStorage();
	LoadDrivingTestPosition();
	LoadFlyingTestPosition();
	LoadBankPosition();
	LoadWeaponLicensePosition();
	LoadPoliceArrestPosition();
	LoadPoliceDutyPosition();
	LoadGunJob();
	LoadDrugJob();
	LoadDetectiveJob();
	LoadLawyerJob();
	LoadProductsSellerJob();
	return 1;
}
public ResetStats(playerid)
{
	//============[Account Related Stuff]=============
	ProductsOffer[playerid] = 999;
	ProductsCost[playerid] = 0;
	ProductsAmount[playerid] = 0;
	TrackingPlayer[playerid] = 0;
	DrugsIntake[playerid] = 0;
	DrugsHolding[playerid] = 0;
	ResetPlayerWantedLevelEx(playerid);
	VehicleLockedPlayer[playerid] = 999;
	MatsHolding[playerid] = 0;
	TicketOffer[playerid] = 999;
	TicketMoney[playerid] = 0;
	PlayerTazed[playerid] = 0;
	PlayerCuffed[playerid] = 0;
	CopOnDuty[playerid] = 0;
	WantedLevel[playerid] = 0;
	WantedPoints[playerid] = 0;
	PMsEnabled[playerid] = 1;
	AdminDuty[playerid] = 0;
	SpeakerPhone[playerid] = 0;
	StartedCall[playerid] = 0;
	Muted[playerid] = 0; //Player is not muted.
	PhoneOnline[playerid] = 0;//Phone is turned off if 1.
	ShowFuel[playerid] = 1;//Will show fuel.
	TakingDrivingTest[playerid] = 0; //Player is not taking the driving test.
	DrivingTestStep[playerid] = 0; //Player has not started the driving test.
	SetPlayerColor(playerid,COLOR_NOTLOGGED);//Set colour to not logged in.
	SpawnAttempts[playerid] = 0; //Player hasn't attempted to spawn yet.
	PlayerInfo[playerid][pFaction] = 255;
	FactionRequest[playerid] = 255; //Player hasn't been asked to join a faction.
	PlayerInfo[playerid][pRank] = 0;
	PlayerInfo[playerid][pBizKey] = 255;
	PlayerInfo[playerid][pSpawnPoint] = 0;
	PlayerInfo[playerid][pBanned] = 0;
	PlayerInfo[playerid][pWarnings] = 0;
	PlayerInfo[playerid][pHouseKey] = 255;
	gPlayerLogged[playerid] = 0;//Player is not logged in.
	RegistrationStep[playerid] = 0;
	PlayerInfo[playerid][pLevel] = 0;
	PlayerInfo[playerid][pAdmin] = 0;
	PlayerInfo[playerid][pDonateRank] = 0;
	PlayerInfo[playerid][pRegistered] = 0;
	PlayerInfo[playerid][pSex] = 0;
	PlayerInfo[playerid][pAge] = 0;
	PlayerInfo[playerid][pExp] = 0;
	PlayerInfo[playerid][pCash] = 0; //Resetting the cash variable to 0.
	PlayerInfo[playerid][pBank] = 0;
	PlayerInfo[playerid][pSkin] = 0;
	PlayerInfo[playerid][pDrugs] = 0;
	PlayerInfo[playerid][pMaterials] = 0;
	PlayerInfo[playerid][pJob] = 0;
	PlayerInfo[playerid][pPlayingHours] = 0;
	PlayerInfo[playerid][pAllowedPayday] = 0;
	PlayerInfo[playerid][pPayCheck] = 0;
	PlayerInfo[playerid][pCarLic] = 0;
	PlayerInfo[playerid][pWepLic] = 0;
	PlayerInfo[playerid][pFlyLic] = 0;
	PlayerInfo[playerid][pPhoneNumber] = 0;
	PlayerInfo[playerid][pPhoneC] = 255;
	PlayerInfo[playerid][pPhoneBook] = 0;
	PlayerInfo[playerid][pListNumber] = 1;
	Mobile[playerid] = 255;
	PlayerInfo[playerid][pDonator] = 0;
	PlayerInfo[playerid][pJailed] = 0;
	PlayerInfo[playerid][pJailTime] = 0;
	PlayerInfo[playerid][pProducts] = 0;
	PlayerInfo[playerid][pCrashX] = 0.0000;
	PlayerInfo[playerid][pCrashY] = 0.0000;
	PlayerInfo[playerid][pCrashZ] = 0.0000;
	PlayerInfo[playerid][pCrashInt] = 0;
	PlayerInfo[playerid][pCrashW] = 0;
	PlayerInfo[playerid][pCrashed] = 0;
	//================================================
	return 0;
}
public OnPlayerDisconnect(playerid, reason)
{
    if(gPlayerLogged[playerid])
	{
	    if(reason == 0)
	    {
	        new Float:x,Float:y,Float:z;
	        GetPlayerPos(playerid,x,y,z);
		    PlayerInfo[playerid][pCrashX] = x;
			PlayerInfo[playerid][pCrashY] = y;
			PlayerInfo[playerid][pCrashZ] = z;
			PlayerInfo[playerid][pCrashInt] = GetPlayerInterior(playerid);
			PlayerInfo[playerid][pCrashW] = GetPlayerVirtualWorld(playerid);
			PlayerInfo[playerid][pCrashed] = 1;
			PlayerLocalMessage(playerid,15.0,"dosta³ crasha.");
	    }
		OnPlayerDataSave(playerid);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(gPlayerLogged[playerid])
	{
		SetPlayerSpawn(playerid);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new string[128];
	if(IsPlayerConnected(killerid))
	{
	    if(killerid != playerid)
	    {
	     	if(AdminDuty[playerid])
		    {
		        if(!AdminDuty[killerid])
		        {
					KickPlayer(killerid,"System","próba zabicia administratora na s³u¿bie.");
					format(string, sizeof(string), "[INFO:] System has kicked %s, Reason: Killing an administrator on duty with abuse. ", PlayerName(killerid));
					KickLog(string);
				}
		    }
	    	SetPlayerWantedLevelEx(killerid,GetPlayerWantedLevelEx(playerid)+1);
	    }
	}
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
	new string[256];
	new tmp[256];
	
	if(Muted[playerid])
	{
		SendClientMessage(playerid, COLOR_RED, "[ERROR:] Jesteœ uciszony.");
		return 0;
	}
 	new idx;
	tmp = strtok(text, idx);
 	if((strcmp("/b", tmp, true, strlen(tmp)) == 0) && (strlen(tmp) == strlen("(")))
	{
	    if(text[1] != 0)
	    {
		    format(string, sizeof(string), "(( [LOCAL OOC:] %s mówi: %s ))", PlayerName(playerid),text[1]);
			ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
			OOCLog(string);
	   		return 0;
   		}
	}
	if(Mobile[playerid] == 911)
	{
		format(string, sizeof(string), "[911 CALL:] %s(ID:%d) mówi: %s",GetPlayerNameEx(playerid),playerid,text);
		SendFactionTypeMessage(1, COLOR_LSPD, string);
		SendClientMessage(playerid,COLOR_WHITE,"Operator: Twoja rozmowa jest nagrana, oczekuj na pomoc.");
		Mobile[playerid] = 255;
		format(string, sizeof(string), "[Phone] %s mówi: %s", GetPlayerNameEx(playerid), text);
		ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
		TalkLog(string);
		return 0;
	}
	if(Mobile[playerid] != 255)
	{
		format(string, sizeof(string), "[Phone] %s mówi: %s", GetPlayerNameEx(playerid), text);
		ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
        TalkLog(string);
        
		if(IsPlayerConnected(Mobile[playerid]))
		{
		    if(Mobile[Mobile[playerid]] == playerid)
		    {
 	    		new Float:SpeakerX,Float:SpeakerY,Float:SpeakerZ;
			    GetPlayerPos(playerid,SpeakerX,SpeakerY,SpeakerZ);
			    if(!PlayerToPoint(20.0,Mobile[playerid],SpeakerX,SpeakerY,SpeakerZ))
			    {
					SendClientMessage(Mobile[playerid], COLOR_GREEN,string);
					SendClientMessage(playerid, COLOR_GREEN,string);
				}
				if(SpeakerPhone[Mobile[playerid]])
				{
					format(string, sizeof(string), "[Rozmówca] %s mówi: %s", GetPlayerNameEx(playerid), text);
					ProxDetector(20.0, Mobile[playerid], string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
				}
			}
		}
  		else
		{
			SendClientMessage(playerid, COLOR_RED,"[ERROR:] Nie ma nikogo na linii.");
		}
		return 0;
	}
	if (realchat)
	{
	    if(gPlayerLogged[playerid] == 0)
	    {
	        return 0;
      	}
      	if(!IsPlayerInAnyVehicle(playerid) || IsABike(GetPlayerVehicleID(playerid)))
      	{
			format(string, sizeof(string), "%s mówi: %s", GetPlayerNameEx(playerid), text);
			ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
			TalkLog(string);
		}
		else
		{
		    if(CarWindowStatus[GetPlayerVehicleID(playerid)] == 1)
		    {
				format(string, sizeof(string), "[Okna otwarte] %s mówi: %s", GetPlayerNameEx(playerid), text);
				ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
				TalkLog(string);
			}
			else
			{
				format(string, sizeof(string), "[Okna zamkniête] %s mówi: %s", GetPlayerNameEx(playerid), text);
				ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
				TalkLog(string);
			}
		}
		return 0;
	}
	return 1;
}

public OnPlayerRegister(playerid, password[])
{
	format(tekst, sizeof(tekst), "insert into `accounts` (`login`, `haslo`) values ('%s', '%s')", PlayerName(playerid), MD5_Hash(password));
	mysql_query(tekst);
	mysql_free_result();
	OnPlayerLogin(playerid, password);
	return 1;
}
public OnPlayerLogin(playerid,password[])
{
	format(tekst, sizeof(tekst), "select * from `accounts` where `login`='%s'", PlayerName(playerid));
	mysql_query(tekst);
	mysql_store_result();
	mysql_fetch_row_format(fetch, "|");
	sscanf(fetch, "p<|>ds[24]s[256]ddddddddddddddddddddddddddddddddddfffddd",
	PlayerInfo[playerid][pID],
	PlayerInfo[playerid][pLogin],
	PlayerInfo[playerid][pKey],
	PlayerInfo[playerid][pLevel],
	PlayerInfo[playerid][pAdmin],
	PlayerInfo[playerid][pDonateRank],
	PlayerInfo[playerid][pRegistered],
	PlayerInfo[playerid][pSex],
	PlayerInfo[playerid][pAge],
	PlayerInfo[playerid][pExp],
	PlayerInfo[playerid][pCash],
	PlayerInfo[playerid][pBank],
	PlayerInfo[playerid][pSkin],
	PlayerInfo[playerid][pDrugs],
	PlayerInfo[playerid][pMaterials],
	PlayerInfo[playerid][pJob],
	PlayerInfo[playerid][pPlayingHours],
	PlayerInfo[playerid][pAllowedPayday],
	PlayerInfo[playerid][pPayCheck],
	PlayerInfo[playerid][pFaction],
	PlayerInfo[playerid][pRank],
	PlayerInfo[playerid][pHouseKey],
	PlayerInfo[playerid][pBizKey],
	PlayerInfo[playerid][pSpawnPoint],
	PlayerInfo[playerid][pBanned],
	PlayerInfo[playerid][pWarnings],
	PlayerInfo[playerid][pCarLic],
	PlayerInfo[playerid][pFlyLic],
	PlayerInfo[playerid][pWepLic],
	PlayerInfo[playerid][pPhoneNumber],
	PlayerInfo[playerid][pPhoneC],
	PlayerInfo[playerid][pPhoneBook],
	PlayerInfo[playerid][pListNumber],
	PlayerInfo[playerid][pDonator],
	PlayerInfo[playerid][pJailed],
	PlayerInfo[playerid][pJailTime],
	PlayerInfo[playerid][pProducts],
	PlayerInfo[playerid][pCrashX],
	PlayerInfo[playerid][pCrashY],
	PlayerInfo[playerid][pCrashZ],
	PlayerInfo[playerid][pCrashInt],
	PlayerInfo[playerid][pCrashW],
	PlayerInfo[playerid][pCrashed]
	);
	mysql_free_result();
	if(!strcmp(MD5_Hash(password), PlayerInfo[playerid][pKey], true))
	{
		if(PlayerInfo[playerid][pFaction] != 255)
		{
    		if(DynamicFactions[PlayerInfo[playerid][pFaction]][fUseColor])
   			{
  				SetPlayerToFactionColor(playerid);
   			}
     		else
     		{
				SetPlayerColor(playerid,COLOR_CIVILIAN);
			}
		}
		if(PlayerInfo[playerid][pBanned])
		{
 			KickPlayer(playerid,"System","Konto jest zbanowane.");
		}
		if(PlayerInfo[playerid][pRegistered] == 0)
		{
			PlayerInfo[playerid][pLevel] = 1;
			PlayerInfo[playerid][pCash] = 2500;
			PlayerInfo[playerid][pBank] = 7500;
			PlayerInfo[playerid][pSkin] = 200;
			SetPlayerCash(playerid,PlayerInfo[playerid][pCash]);
			TogglePlayerControllable(playerid,0);
			ShowPlayerDialog(playerid, wiek, DIALOG_STYLE_INPUT, "Wiek postaci IC", "Ile Twoja postaæ bedzie mia³a lat? Wpisz liczbê od 0-99", "Dalej", "Anuluj");
			RegistrationStep[playerid] = 1;
		}
		SetPlayerCash(playerid,PlayerInfo[playerid][pCash]);
		SendClientMessage(playerid, COLOR_YELLOW2, "[INFO:] Zalogowano pomyœlnie.");
		gPlayerLogged[playerid] = 1;
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin],CivilianSpawn[X],CivilianSpawn[Y],CivilianSpawn[Z],0,0,0,0,0,0,0);
		SpawnPlayer(playerid);
 	}
	else
	{
		ShowPlayerDialog(playerid, logowanie, DIALOG_STYLE_PASSWORD, "Wyst¹pi³ b³¹d!", "Poda³eœ z³e has³o! Nie pasuje ono do konta! Podaj ponownie has³o.", "Zaloguj", "Anuluj");
 		return 1;
	}
	return 1;
}
public OnPlayerDataSave(playerid)
{
	format(fetch, sizeof(fetch), "update `accounts` set `level`='%d', `admin`='%d', `donaterank`='%d', `registered`='%d', `sex`='%d', `age`='%d', `exp`='%d', `cash`='%d', `bank`='%d', `skin`='%d', `drugs`='%d', `materials`='%d', `job`='%d', `playinghours`='%d', `allowedpayday`='%d', `paycheck`='%d', `faction`='%d', `rank`='%d', `housekey`='%d', `bizkey`='%d' where `login`='%s'",
	PlayerInfo[playerid][pLevel],
	PlayerInfo[playerid][pAdmin],
	PlayerInfo[playerid][pDonateRank],
	PlayerInfo[playerid][pRegistered],
	PlayerInfo[playerid][pSex],
	PlayerInfo[playerid][pAge],
	PlayerInfo[playerid][pExp],
	PlayerInfo[playerid][pCash],
	PlayerInfo[playerid][pBank],
	PlayerInfo[playerid][pSkin],
	PlayerInfo[playerid][pDrugs],
	PlayerInfo[playerid][pMaterials],
	PlayerInfo[playerid][pJob],
	PlayerInfo[playerid][pPlayingHours],
	PlayerInfo[playerid][pAllowedPayday],
	PlayerInfo[playerid][pPayCheck],
	PlayerInfo[playerid][pFaction],
	PlayerInfo[playerid][pRank],
	PlayerInfo[playerid][pHouseKey],
	PlayerInfo[playerid][pBizKey],
	PlayerName(playerid));
	mysql_query(fetch);
	mysql_free_result();
	format(fetch, sizeof(fetch), "update `accounts` set `spawnpoint`='%d', `banned`='%d', `warnings`='%d', `carlic`='%d', `flylic`='%d', `weplic`='%d', `phonenumber`='%d', `phonec`='%d', `phonebook`='%d', `listnumber`='%d', `donator`='%d', `jailed`='%d', `jailtime`='%d', `products`='%d', `crashx`='%f', `crashy`='%f', `crashz`='%f', `crashint`='%d', `crashw`='%d', `crashed`='%d' where `login`='%s'",
	PlayerInfo[playerid][pSpawnPoint],
	PlayerInfo[playerid][pBanned],
	PlayerInfo[playerid][pWarnings],
	PlayerInfo[playerid][pCarLic],
	PlayerInfo[playerid][pFlyLic],
	PlayerInfo[playerid][pWepLic],
	PlayerInfo[playerid][pPhoneNumber],
	PlayerInfo[playerid][pPhoneC],
	PlayerInfo[playerid][pPhoneBook],
	PlayerInfo[playerid][pListNumber],
	PlayerInfo[playerid][pDonator],
	PlayerInfo[playerid][pJailed],
	PlayerInfo[playerid][pJailTime],
	PlayerInfo[playerid][pProducts],
	PlayerInfo[playerid][pCrashX],
	PlayerInfo[playerid][pCrashY],
	PlayerInfo[playerid][pCrashZ],
	PlayerInfo[playerid][pCrashInt],
	PlayerInfo[playerid][pCrashW],
	PlayerInfo[playerid][pCrashed],
	PlayerName(playerid));
	mysql_query(fetch);
	mysql_free_result();
	return 1;
}
public Update()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(gPlayerLogged[i] == 1)
		    {
				if(PlayerInfo[i][pAllowedPayday] < 6)
				{
					PlayerInfo[i][pAllowedPayday] ++;
				}
			}
		}
	}
}
public PayDay()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(gPlayerLogged[i] == 1)
		    {
				if(PlayerInfo[i][pAllowedPayday] >= 5)
				{
				 		new wstring[256];
						new randcheck = 999 + random(250);
						new interest = (PlayerInfo[i][pBank]/1)*(intrate);
						new bonus = PlayerInfo[i][pPayCheck];
					    new newbank = PlayerInfo[i][pBank] + interest;
    					new randtax = 20 + random(50);
						SendClientMessage(i,COLOR_YELLOW,"____________________________________________________");
						SendClientMessage(i,COLOR_LIGHTBLUE2,"                                    Wyp³ata:                       ");
						format(wstring, sizeof(wstring), "~y~Wyplata~n~~w~Suma: ~g~%d",randcheck + bonus);
						GameTextForPlayer(i, wstring, 5000, 1);
					    format(wstring, sizeof(wstring), "Podstawa: $%d, Bonus: $%d.", randcheck, bonus);
					    SendClientMessage(i,COLOR_LIGHTBLUE2, wstring);
					    format(wstring, sizeof(wstring), "Saldo: $%d, Uzyskane odsetki: $%d, Now saldo: $%d, Oprocentowanie: 0.%d procent.", PlayerInfo[i][pBank], interest, newbank,intrate);
					    SendClientMessage(i,COLOR_LIGHTBLUE2, wstring);
					    format(wstring, sizeof(wstring), "Podatek: $%d.", randtax);
					    SendClientMessage(i,COLOR_LIGHTBLUE2, wstring);
					    PlayerInfo[i][pBank] += interest;
					    PlayerInfo[i][pBank] -= randtax;
					    PlayerInfo[i][pBank] += randcheck + bonus;
			    		PlayerInfo[i][pPayCheck] = 0;
						PlayerInfo[i][pAllowedPayday] = 0;
						PlayerInfo[i][pExp]++;
						PlayerInfo[i][pPlayingHours] += 1;
						SendClientMessage(i,COLOR_LIGHTBLUE2, "[INFO:] Pieni¹dze czekaj¹ na Ciebie w banku.");
						SendClientMessage(i,COLOR_YELLOW,"____________________________________________________");
						
						new nxtlevel = PlayerInfo[i][pLevel]+1;
						new expamount = nxtlevel*levelexp;
						if(PlayerInfo[i][pExp] < expamount)
						{
	   						format(wstring, sizeof(wstring), "Potrzebujesz %d/%d doœwiadczenia, posiadasz obecnie %d.", expamount,expamount,PlayerInfo[i][pExp]);
						    SendClientMessage(i,COLOR_LIGHTBLUE2, wstring);
						}
						else
						{
	   						format(wstring, sizeof(wstring), "Awansowa³eœ! - Nowy poziom: %d.", nxtlevel);
						    SendClientMessage(i,COLOR_LIGHTBLUE2, wstring);
							PlayerInfo[i][pLevel]++;
	   						format(wstring, sizeof(wstring), "Musisz zdobyæ %d/%d punktów doœwiadczenia.", expamount,expamount);
						    SendClientMessage(i,COLOR_LIGHTBLUE2, wstring);
						    PlayerInfo[i][pExp] = 0;
						}
				}
				else
				{
					SendClientMessage(i,COLOR_LIGHTBLUE2,"[INFO:] Wyp³ata nie zrealizowana, zbyt krótko gra³eœ.");
				}
			}
			else
			{
				SendClientMessage(i,COLOR_LIGHTBLUE2,"[INFO:] Nie jesteœ zalogowany, brak wyp³aty.");
			}
		}
	}
}
public SaveAccounts()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(gPlayerLogged[i])
		    {
				OnPlayerDataSave(i);
			}
		}
	}
}
public UpdateData()
{
	UpdateScore();
	SyncTime();
	return 1;
}
public UpdateMoney()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(gPlayerLogged[i])
		    {
			 	if(GetPlayerCash(i) != GetPlayerMoney(i))
			 	{
 	 				new hack = GetPlayerMoney(i) - GetPlayerCash(i);
			  		if(hack >= 5000)
			  		{
					  	new string[128];
					    format(string, sizeof(string), "[WARNING:] %s (ID:%d) tried to spawn $%d - This could be a money cheat.",GetPlayerNameEx(i),i, hack);
					    HackLog(string);
			  		}
			 		ResetMoneyBar(i);//Resets the money in the original moneybar, Do not remove!
					UpdateMoneyBar(i,PlayerInfo[i][pCash]);//Sets the money in the moneybar to the serverside cash, Do not remove!
				}
			}
		}
	}
	return 1;
}
public UpdateScore()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			SetPlayerScore(i, PlayerInfo[i][pLevel]);
		}
	}
	return 1;
}
stock ini_GetKey( line[] )
{
	new keyRes[256];
	keyRes[0] = 0;
    if ( strfind( line , "=" , true ) == -1 ) return keyRes;
    strmid( keyRes , line , 0 , strfind( line , "=" , true ) , sizeof( keyRes) );
    return keyRes;
}

stock ini_GetValue( line[] )
{
	new valRes[256];
	valRes[0]=0;
	if ( strfind( line , "=" , true ) == -1 ) return valRes;
	strmid( valRes , line , strfind( line , "=" , true )+1 , strlen( line ) , sizeof( valRes ) );
	return valRes;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    new Float:playerposx, Float:playerposy, Float:playerposz;
	GetPlayerPos(playerid, playerposx, playerposy, playerposz);
 	if(PlayerInfo[playerid][pAdmin] > 0)
	{
	    format(tekst, sizeof(tekst), "[ADMIN:] Wsiadasz do pojazdu UID: %d | SAMPID: %d", DynamicCars[vehicleid][CarID], vehicleid);
	    SendClientMessage(playerid, COLOR_GREEN, tekst);
	}
	switch(DynamicCars[vehicleid][CarType])
	{
	    case 0:
	    {
	        SendClientMessage(playerid, COLOR_WHITE, "[Info:] Mo¿esz wpisaæ /cbr, aby porozmawiaæ przez CB RADIO!");
		}
		case 1:
		{
            if(TakingDrivingTest[playerid] != 1)
			{
			    if(PlayerInfo[playerid][pAdmin] == 0)
				{
   					SetPlayerPos(playerid,playerposx, playerposy, playerposz);
				}
			}
			SendClientMessage(playerid,COLOR_WHITE,"[Error:] Nie zdajesz kursu prawa jazdy!");
		}
		case 2:
		{
		    if(DynamicCars[vehicleid][FactionCar] != 0)
			{
				format(tekst, sizeof(tekst), "[FACTION:] Ten pojazd nale¿y do %s.",DynamicFactions[DynamicCars[vehicleid][FactionCar]][fName]);
				SendClientMessage(playerid,COLOR_WHITE, tekst);
				if(PlayerInfo[playerid][pAdmin] == 0)
				{
					SetPlayerPos(playerid,playerposx, playerposy, playerposz);
		        }
			}
		}
		case 3:
		{
		    format(tekst, sizeof(tekst), "~r~Pojazd jest na sprzedaz za ~g~$%d~n~~r~Wpisz /kuppojazd", DynamicCars[vehicleid][Cena]);
   	    	GameTextForPlayer(playerid, tekst, 5000, 3);
		}
		case 4:
		{
		    if(DynamicCars[vehicleid][OwnID] != PlayerInfo[playerid][pID])
	    	{
	        	SetPlayerPos(playerid,playerposx, playerposy, playerposz);
	        	SendClientMessage(playerid, COLOR_WHITE, "[Error:] To nie Twój pojazd!");
 			}
		}
	}
	if(IsAPlane(vehicleid) || IsAHelicopter(vehicleid))
 	{
  		if(PlayerInfo[playerid][pFlyLic] == 0)
		{
  			SendClientMessage(playerid,COLOR_WHITE,"[ERROR:] Nie posiadasz licencji pilota!");
			if(PlayerInfo[playerid][pAdmin] == 0)
			{
   				SetPlayerPos(playerid,playerposx, playerposy, playerposz);
			}
		}
   	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    if(DynamicCars[GetPlayerVehicleID(playerid)-1][CarType] != 1)
		{
		    if(EngineStatus[GetPlayerVehicleID(playerid)] == 0)
			{
				SendClientMessage(playerid,COLOR_GREEN,"[STATUS:] Wpisz /silnik aby odpaliæ samochód.");
				TogglePlayerControllable(playerid,0);
			}
			else
			{
			    SendClientMessage(playerid,COLOR_GREEN,"[STATUS:] Pojazd odpalony, zostawiaj¹c go tracisz paliwo.");
			}
		}
	    if(DynamicCars[GetPlayerVehicleID(playerid)][FactionCar] != 0)
		{
		    if(DynamicFactions[DynamicCars[GetPlayerVehicleID(playerid)][FactionCar]][fType] == 1)
		    {
		        if(PlayerInfo[playerid][pFaction] != DynamicCars[GetPlayerVehicleID(playerid)][FactionCar])
		        {
					RemoveDriverFromVehicle(playerid);
		        }
		    }
		}
	    if(PlayerInfo[playerid][pCarLic] == 0 && IsAPlane(GetPlayerVehicleID(playerid))==0 && IsAHelicopter(GetPlayerVehicleID(playerid))==0)
	    {
	    	SendClientMessage(playerid,COLOR_WHITE,"[INFO:] JeŸdzisz bez prawa jazdy, uwa¿aj na PD.");
	    }
		new updatedvehicleid = GetPlayerVehicleID(playerid) - 1;
		if(DynamicCars[updatedvehicleid][CarType] == 1)
		{
			if(TakingDrivingTest[playerid] == 1)
			{
				SendClientMessage(playerid,COLOR_LIGHTBLUE2,"[INFO:] Ukoñcz egzamin, uwa¿aj na obra¿enia samochodu.");

				if(DrivingTestStep[playerid] == 0)
				{
			 		SetPlayerCheckpoint(playerid, 1328.8065,-1403.0996,13.2369, 5.0);
					DrivingTestStep[playerid] = 1;
				}
	   		}
			else
			{
				RemoveDriverFromVehicle(playerid);
			}
		}
	  	if(IsAPlane(GetPlayerVehicleID(playerid)) || IsAHelicopter(GetPlayerVehicleID(playerid)))
	 	{
	  		if(PlayerInfo[playerid][pFlyLic] == 0)
			{
				if(PlayerInfo[playerid][pAdmin] == 0)
				{
				   	RemoveDriverFromVehicle(playerid);
    			}
			}
	   	}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	//===================================================[DRIVING TEST]========================================================
	for(new h = 0; h < sizeof(DynamicCars); h++)
	{
			new updatedvehicleid = GetPlayerVehicleID(playerid) - 1;
			if(DynamicCars[updatedvehicleid][CarType] == 1)
			{
			if(TakingDrivingTest[playerid] == 1)
			{
				if(PlayerToPoint(5.0,playerid,1328.8065,-1403.0996,13.2369) && DrivingTestStep[playerid] == 1)
				{
	                DrivingTestStep[playerid] = 2;
	                SetPlayerCheckpoint(playerid, 1441.4253,-1443.6260,13.2652, 5.0);
				}
				else if(PlayerToPoint(5.0,playerid,1441.4253,-1443.6260,13.2652) && DrivingTestStep[playerid] == 2)
				{
	                DrivingTestStep[playerid] = 3;
	                SetPlayerCheckpoint(playerid, 1427.0172,-1578.5571,13.2460, 5.0);
				}
				else if(PlayerToPoint(5.0,playerid,1427.0172,-1578.5571,13.2460) && DrivingTestStep[playerid] == 3)
				{
	                DrivingTestStep[playerid] = 4;
	                SetPlayerCheckpoint(playerid, 1325.4891,-1570.3796,13.2504, 5.0);
				}
				else if(PlayerToPoint(5.0,playerid,1325.4891,-1570.3796,13.2504) && DrivingTestStep[playerid] == 4)
				{
	                DrivingTestStep[playerid] = 5;
	                SetPlayerCheckpoint(playerid, 1321.9575,-1392.0773,13.2449, 5.0);
				}
				else if(PlayerToPoint(5.0,playerid,1321.9575,-1392.0773,13.2449) && DrivingTestStep[playerid] == 5)
				{
				    new Float:health;
				    new veh;
				    veh = GetPlayerVehicleID(playerid);
				    GetVehicleHealth(veh, health);

				    if(health >= 600.0)
				    {
				    	SendClientMessage(playerid,COLOR_GREEN,"[INFO:] Gratulacje! Twój pojazd nie jest mocno zniszczony, zda³eœ!");
				    	PlayerInfo[playerid][pCarLic] = 1;
				    	OnPlayerDataSave(playerid);
				    	SetVehicleToRespawn(veh);
				    	TakingDrivingTest[playerid] = 0;
			    	 	DisablePlayerCheckpoint(playerid);
				    }
				    else
				    {
						SendClientMessage(playerid,COLOR_RED,"[INFO:] Obla³eœ! Spróbuj jeszcze raz.");
						SetVehicleToRespawn(veh);
						TakingDrivingTest[playerid] = 0;
						DisablePlayerCheckpoint(playerid);
				    }
	                DrivingTestStep[playerid] = 0;
				}
				return 1;
			}
		}
	}
	//==================================================================================================================
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

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}
public SetPlayerSpawn(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(PlayerInfo[playerid][pCrashed])
		{
		    SetPlayerPos(playerid,PlayerInfo[playerid][pCrashX],PlayerInfo[playerid][pCrashY],PlayerInfo[playerid][pCrashZ]);
		    SetPlayerInterior(playerid,PlayerInfo[playerid][pCrashInt]);
			SetPlayerVirtualWorld(playerid,PlayerInfo[playerid][pCrashW]);
			PlayerInfo[playerid][pCrashed] = 0;
			GameTextForPlayer(playerid, "~r~Crashed...~n~~g~powracasz na poprzednia pozycje.", 7000, 6);
			
			if(PlayerInfo[playerid][pSex] == 1)
			{
				PlayerLocalMessage(playerid,15.0,"powróci³ do poprzedniej pozycji.");
			}
			else
			{
			    PlayerLocalMessage(playerid,15.0,"powróci³ do poprzedniej pozycji.");
			}
			return 1;
		}
	    if(AdminDuty[playerid])
	    {
	    	SetPlayerColor(playerid,COLOR_ADMINDUTY);
			SetPlayerHealth(playerid,99999);
			SetPlayerArmour(playerid,99999);
	    }
	    if(PlayerInfo[playerid][pFaction] != 0)
	    {
			SetPlayerToFactionColor(playerid);
			SetPlayerToFactionSkin(playerid);
     	}
   		if(PlayerInfo[playerid][pJailed] == 1)
		{
		    SetPlayerVirtualWorld(playerid,2); //BUILDING ID 2, MAKE SURE PD IS ID 2
		    SetPlayerInterior(playerid, 6);
			SetPlayerPos(playerid,264.5743,77.5118,1001.0391);
			SendClientMessage(playerid, COLOR_RED, "[ERROR:] Masz jeszcze wyrok!");
			return 1;
		}
	    new house = PlayerInfo[playerid][pHouseKey];
   		if(house != 0)
		{
		    if(PlayerInfo[playerid][pSpawnPoint])
		    {
				SetPlayerInterior(playerid,Houses[house][ExitInterior]);
				SetPlayerPos(playerid, Houses[house][ExitX], Houses[house][ExitY],Houses[house][ExitZ]);
				SetPlayerVirtualWorld(playerid,house);
    			return 1;
			}
		}
  		if(PlayerInfo[playerid][pFaction] != 0)
		{
		    if(PlayerInfo[playerid][pSpawnPoint] == 0)
		    {
				SetPlayerPos(playerid,DynamicFactions[PlayerInfo[playerid][pFaction]][fX],DynamicFactions[PlayerInfo[playerid][pFaction]][fY],DynamicFactions[PlayerInfo[playerid][pFaction]][fZ]);
				SetPlayerInterior(playerid,0);
				SetPlayerVirtualWorld(playerid,0);
				return 1;
			}
		}
	    else
	    {
		    //====================[Setting Civilian Position]==========================
			SetPlayerPos(playerid,CivilianSpawn[X],CivilianSpawn[Y],CivilianSpawn[Z]);
			SetPlayerVirtualWorld(playerid, CivilianSpawn[World]);
			SetPlayerInterior(playerid, CivilianSpawn[Interior]);
			SetPlayerFacingAngle(playerid,CivilianSpawn[Angle]);
			//=========================================================================
			return 1;
		}
	}
	return 1;
}
public SetPlayerToFactionSkin(playerid)
{

  		new faction = PlayerInfo[playerid][pFaction];
		new rank = PlayerInfo[playerid][pRank];
		new rankamount = DynamicFactions[faction][fRankAmount];
		if(faction != 255)
		{
			if(DynamicFactions[faction][fUseSkins])
			{
				if(rank == 1 && rankamount >= 1)
				{
	   				if(DynamicFactions[faction][fType] == 1)
	    		    {
	    		        if(CopOnDuty[playerid])
	    		        {
	    		            SetPlayerSkin(playerid,DynamicFactions[faction][fSkin1]);
	    		        }
					}
					else
					{
						SetPlayerSkin(playerid,DynamicFactions[faction][fSkin1]);
					}
				}
				else if(rank == 2 && rankamount >= 2)
				{
	    			if(DynamicFactions[faction][fType] == 1)
	    		    {
	    		        if(CopOnDuty[playerid])
	    		        {
	    		            SetPlayerSkin(playerid,DynamicFactions[faction][fSkin2]);
	    		        }
					}
					else
					{
						SetPlayerSkin(playerid,DynamicFactions[faction][fSkin2]);
					}
				}
				else if(rank == 3 && rankamount >= 3)
				{
	    			if(DynamicFactions[faction][fType] == 1)
	    		    {
	    		        if(CopOnDuty[playerid])
	    		        {
	    		            SetPlayerSkin(playerid,DynamicFactions[faction][fSkin3]);
	    		        }
					}
					else
					{
						SetPlayerSkin(playerid,DynamicFactions[faction][fSkin3]);
					}
				}
				else if(rank == 4 && rankamount >= 4)
				{
					if(DynamicFactions[faction][fType] == 1)
	    		    {
	    		        if(CopOnDuty[playerid])
	    		        {
	    		            SetPlayerSkin(playerid,DynamicFactions[faction][fSkin4]);
	    		        }
					}
					else
					{
						SetPlayerSkin(playerid,DynamicFactions[faction][fSkin4]);
					}
				}
				else if(rank == 5 && rankamount >= 5)
				{
					if(DynamicFactions[faction][fType] == 1)
	    		    {
	    		        if(CopOnDuty[playerid])
	    		        {
	    		            SetPlayerSkin(playerid,DynamicFactions[faction][fSkin5]);
	    		        }
					}
					else
					{
						SetPlayerSkin(playerid,DynamicFactions[faction][fSkin5]);
					}
				}
				else if(rank == 6 && rankamount >= 6)
				{
					if(DynamicFactions[faction][fType] == 1)
	    		    {
	    		        if(CopOnDuty[playerid])
	    		        {
	    		            SetPlayerSkin(playerid,DynamicFactions[faction][fSkin6]);
	    		        }
					}
					else
					{
						SetPlayerSkin(playerid,DynamicFactions[faction][fSkin6]);
					}
				}
				else if(rank == 7 && rankamount >= 7)
				{
					if(DynamicFactions[faction][fType] == 1)
	    		    {
	    		        if(CopOnDuty[playerid])
	    		        {
	    		            SetPlayerSkin(playerid,DynamicFactions[faction][fSkin7]);
	    		        }
					}
					else
					{
						SetPlayerSkin(playerid,DynamicFactions[faction][fSkin7]);
					}
				}
				else if(rank == 8 && rankamount >= 8)
				{
					if(DynamicFactions[faction][fType] == 1)
	    		    {
	    		        if(CopOnDuty[playerid])
	    		        {
	    		            SetPlayerSkin(playerid,DynamicFactions[faction][fSkin8]);
	    		        }
					}
					else
					{
						SetPlayerSkin(playerid,DynamicFactions[faction][fSkin8]);
					}
				}
				else if(rank == 9 && rankamount >= 9)
				{
					if(DynamicFactions[faction][fType] == 1)
	    		    {
	    		        if(CopOnDuty[playerid])
	    		        {
	    		            SetPlayerSkin(playerid,DynamicFactions[faction][fSkin9]);
	    		        }
					}
					else
					{
						SetPlayerSkin(playerid,DynamicFactions[faction][fSkin9]);
					}
				}
				else if(rank == 10 && rankamount >= 10)
				{
					if(DynamicFactions[faction][fType] == 1)
	    		    {
	    		        if(CopOnDuty[playerid])
	    		        {
	    		            SetPlayerSkin(playerid,DynamicFactions[faction][fSkin10]);
	    		        }
					}
					else
					{
						SetPlayerSkin(playerid,DynamicFactions[faction][fSkin10]);
					}
				}
   }
		}
		return 1;
}
public SetPlayerToFactionColor(playerid)
{
	if(PlayerInfo[playerid][pFaction] != 255)
	{
		if(DynamicFactions[PlayerInfo[playerid][pFaction]][fUseColor])
		{
		    if(DynamicFactions[PlayerInfo[playerid][pFaction]][fType] == 1)
		    {
      			if(CopOnDuty[playerid] == 1)
	        	{
	        	    SetPlayerColor(playerid,HexToInt(DynamicFactions[PlayerInfo[playerid][pFaction]][fColor]));
   		        }
   		        else
   		        {
	            	SetPlayerColor(playerid,COLOR_CIVILIAN);
   		        }
			}
			else
			{
				SetPlayerColor(playerid,HexToInt(DynamicFactions[PlayerInfo[playerid][pFaction]][fColor]));
			}
		}
	}
	return 0;
}
public OnPlayerExitedMenu(playerid)
{
	return 1;
}
public ProxDetectorS(Float:radi, playerid, targetid)
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
strtok(string[],&idx,seperator = ' ')
{
	new ret[128], i = 0, len = strlen(string);
	while(string[idx] == seperator && idx < len) idx++;
	while(string[idx] != seperator && idx < len)
	{
	    ret[i] = string[idx];
	    i++;
		idx++;
	}
	while(string[idx] == seperator && idx < len) idx++;
	return ret;
}
//=====================================================[SERVERSIDE CASH FUNCTIONS=============================================
stock GivePlayerCash(playerid, money)
{
	PlayerInfo[playerid][pCash] += money;
	ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
	UpdateMoneyBar(playerid,PlayerInfo[playerid][pCash]);//Sets the money in the moneybar to the serverside cash, Do not remove!
	return PlayerInfo[playerid][pCash];
}
stock SetPlayerCash(playerid, money)
{
	PlayerInfo[playerid][pCash] = money;
	ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
	UpdateMoneyBar(playerid,PlayerInfo[playerid][pCash]);//Sets the money in the moneybar to the serverside cash, Do not remove!
	return PlayerInfo[playerid][pCash];
}
stock ResetPlayerCash(playerid)
{
	PlayerInfo[playerid][pCash] = 0;
	ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
	UpdateMoneyBar(playerid,PlayerInfo[playerid][pCash]);//Sets the money in the moneybar to the serverside cash, Do not remove!
	return PlayerInfo[playerid][pCash];
}
stock GetPlayerCash(playerid)
{
	return PlayerInfo[playerid][pCash];
}
//=====================================================================================================================================
public LoadProductsSellerJob()
{
	new arrCoords[14][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Jobs/productsellersjob.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		ProductsSellerJob[TakeJobX] = floatstr(arrCoords[0]);
		ProductsSellerJob[TakeJobY] = floatstr(arrCoords[1]);
		ProductsSellerJob[TakeJobZ] = floatstr(arrCoords[2]);
		ProductsSellerJob[TakeJobWorld] = strval(arrCoords[3]);
		ProductsSellerJob[TakeJobInterior] = strval(arrCoords[4]);
		ProductsSellerJob[TakeJobAngle] = floatstr(arrCoords[5]);
		ProductsSellerJob[TakeJobPickupID] = strval(arrCoords[6]);
        ProductsSellerJob[TakeJobPickupID] = CreateStreamPickup(1239,1,ProductsSellerJob[TakeJobX],ProductsSellerJob[TakeJobY],ProductsSellerJob[TakeJobZ],PICKUP_RANGE);
		ProductsSellerJob[BuyProductsX] = floatstr(arrCoords[7]);
		ProductsSellerJob[BuyProductsY] = floatstr(arrCoords[8]);
		ProductsSellerJob[BuyProductsZ] = floatstr(arrCoords[9]);
		ProductsSellerJob[BuyProductsWorld] = strval(arrCoords[10]);
		ProductsSellerJob[BuyProductsInterior] = strval(arrCoords[11]);
		ProductsSellerJob[BuyProductsAngle] = floatstr(arrCoords[12]);
		ProductsSellerJob[BuyProductsPickupID] = strval(arrCoords[13]);
        ProductsSellerJob[BuyProductsPickupID] = CreateStreamPickup(1239,1,ProductsSellerJob[BuyProductsX],ProductsSellerJob[BuyProductsY],ProductsSellerJob[BuyProductsZ],PICKUP_RANGE);
        print("[INFO:] Products seller job loaded.");
	}
	fclose(file);
	return 1;
}
public SaveProductsSellerJob()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f|%d|%f|%f|%f|%d|%d|%f|%d\n",
	ProductsSellerJob[TakeJobX],
	ProductsSellerJob[TakeJobY],
	ProductsSellerJob[TakeJobZ],
	ProductsSellerJob[TakeJobWorld],
	ProductsSellerJob[TakeJobInterior],
	ProductsSellerJob[TakeJobAngle],
	ProductsSellerJob[TakeJobPickupID],
	ProductsSellerJob[BuyProductsX],
	ProductsSellerJob[BuyProductsY],
	ProductsSellerJob[BuyProductsZ],
	ProductsSellerJob[BuyProductsWorld],
	ProductsSellerJob[BuyProductsInterior],
	ProductsSellerJob[BuyProductsAngle],
	ProductsSellerJob[BuyProductsPickupID]);

	file2 = fopen("CRP_Scriptfiles/Jobs/productsellersjob.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public LoadGunJob()
{
	new arrCoords[21][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Jobs/gunjob.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		GunJob[TakeJobX] = floatstr(arrCoords[0]);
		GunJob[TakeJobY] = floatstr(arrCoords[1]);
		GunJob[TakeJobZ] = floatstr(arrCoords[2]);
		GunJob[TakeJobWorld] = strval(arrCoords[3]);
		GunJob[TakeJobInterior] = strval(arrCoords[4]);
		GunJob[TakeJobAngle] = floatstr(arrCoords[5]);
		GunJob[TakeJobPickupID] = strval(arrCoords[6]);
        GunJob[TakeJobPickupID] = CreateStreamPickup(1239,1,GunJob[TakeJobX],GunJob[TakeJobY],GunJob[TakeJobZ],PICKUP_RANGE);
		GunJob[BuyPackagesX] = floatstr(arrCoords[7]);
		GunJob[BuyPackagesY] = floatstr(arrCoords[8]);
		GunJob[BuyPackagesZ] = floatstr(arrCoords[9]);
		GunJob[BuyPackagesWorld] = strval(arrCoords[10]);
		GunJob[BuyPackagesInterior] = strval(arrCoords[11]);
		GunJob[BuyPackagesAngle] = floatstr(arrCoords[12]);
		GunJob[BuyPackagesPickupID] = strval(arrCoords[13]);
        GunJob[BuyPackagesPickupID] = CreateStreamPickup(1239,1,GunJob[BuyPackagesX],GunJob[BuyPackagesY],GunJob[BuyPackagesZ],PICKUP_RANGE);
        GunJob[DeliverX] = floatstr(arrCoords[14]);
		GunJob[DeliverY] = floatstr(arrCoords[15]);
		GunJob[DeliverZ] = floatstr(arrCoords[16]);
		GunJob[DeliverWorld] = strval(arrCoords[17]);
		GunJob[DeliverInterior] = strval(arrCoords[18]);
		GunJob[DeliverAngle] = floatstr(arrCoords[19]);
		GunJob[DeliverPickupID] = strval(arrCoords[20]);
        GunJob[DeliverPickupID] = CreateStreamPickup(1239,1,GunJob[DeliverX],GunJob[DeliverY],GunJob[DeliverZ],PICKUP_RANGE);
        print("[INFO:] Gun job loaded.");
	}
	fclose(file);
	return 1;
}
public SaveGunJob()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f|%d|%f|%f|%f|%d|%d|%f|%d|%f|%f|%f|%d|%d|%f|%d\n",
	GunJob[TakeJobX],
	GunJob[TakeJobY],
	GunJob[TakeJobZ],
	GunJob[TakeJobWorld],
	GunJob[TakeJobInterior],
	GunJob[TakeJobAngle],
	GunJob[TakeJobPickupID],
	GunJob[BuyPackagesX],
	GunJob[BuyPackagesY],
	GunJob[BuyPackagesZ],
	GunJob[BuyPackagesWorld],
	GunJob[BuyPackagesInterior],
	GunJob[BuyPackagesAngle],
	GunJob[BuyPackagesPickupID],
	GunJob[DeliverX],
	GunJob[DeliverY],
	GunJob[DeliverZ],
	GunJob[DeliverWorld],
	GunJob[DeliverInterior],
	GunJob[DeliverAngle],
	GunJob[DeliverPickupID]);
	
	file2 = fopen("CRP_Scriptfiles/Jobs/gunjob.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public LoadDrugJob()
{
	new arrCoords[21][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Jobs/drugjob.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		DrugJob[TakeJobX] = floatstr(arrCoords[0]);
		DrugJob[TakeJobY] = floatstr(arrCoords[1]);
		DrugJob[TakeJobZ] = floatstr(arrCoords[2]);
		DrugJob[TakeJobWorld] = strval(arrCoords[3]);
		DrugJob[TakeJobInterior] = strval(arrCoords[4]);
		DrugJob[TakeJobAngle] = floatstr(arrCoords[5]);
		DrugJob[TakeJobPickupID] = strval(arrCoords[6]);
        DrugJob[TakeJobPickupID] = CreateStreamPickup(1239,1,DrugJob[TakeJobX],DrugJob[TakeJobY],DrugJob[TakeJobZ],PICKUP_RANGE);
		DrugJob[BuyDrugsX] = floatstr(arrCoords[7]);
		DrugJob[BuyDrugsY] = floatstr(arrCoords[8]);
		DrugJob[BuyDrugsZ] = floatstr(arrCoords[9]);
		DrugJob[BuyDrugsWorld] = strval(arrCoords[10]);
		DrugJob[BuyDrugsInterior] = strval(arrCoords[11]);
		DrugJob[BuyDrugsAngle] = floatstr(arrCoords[12]);
		DrugJob[BuyDrugsPickupID] = strval(arrCoords[13]);
        DrugJob[BuyDrugsPickupID] = CreateStreamPickup(1239,1,DrugJob[BuyDrugsX],DrugJob[BuyDrugsY],DrugJob[BuyDrugsZ],PICKUP_RANGE);
        DrugJob[DeliverX] = floatstr(arrCoords[14]);
		DrugJob[DeliverY] = floatstr(arrCoords[15]);
		DrugJob[DeliverZ] = floatstr(arrCoords[16]);
		DrugJob[DeliverWorld] = strval(arrCoords[17]);
		DrugJob[DeliverInterior] = strval(arrCoords[18]);
		DrugJob[DeliverAngle] = floatstr(arrCoords[19]);
		DrugJob[DeliverPickupID] = strval(arrCoords[20]);
        DrugJob[DeliverPickupID] = CreateStreamPickup(1239,1,DrugJob[DeliverX],DrugJob[DeliverY],DrugJob[DeliverZ],PICKUP_RANGE);
        print("[INFO:] Drug job loaded.");
	}
	fclose(file);
	return 1;
}
public SaveDrugJob()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f|%d|%f|%f|%f|%d|%d|%f|%d|%f|%f|%f|%d|%d|%f|%d\n",
	DrugJob[TakeJobX],
	DrugJob[TakeJobY],
	DrugJob[TakeJobZ],
	DrugJob[TakeJobWorld],
	DrugJob[TakeJobInterior],
	DrugJob[TakeJobAngle],
	DrugJob[TakeJobPickupID],
	DrugJob[BuyDrugsX],
	DrugJob[BuyDrugsY],
	DrugJob[BuyDrugsZ],
	DrugJob[BuyDrugsWorld],
	DrugJob[BuyDrugsInterior],
	DrugJob[BuyDrugsAngle],
	DrugJob[BuyDrugsPickupID],
	DrugJob[DeliverX],
	DrugJob[DeliverY],
	DrugJob[DeliverZ],
	DrugJob[DeliverWorld],
	DrugJob[DeliverInterior],
	DrugJob[DeliverAngle],
	DrugJob[DeliverPickupID]);

	file2 = fopen("CRP_Scriptfiles/Jobs/drugjob.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
//=================================================[LOADING POSITIONS]=====================================================
public LoadBankPosition()
{
	new arrCoords[7][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Locations/banklocation.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		BankPosition[X] = floatstr(arrCoords[0]);
		BankPosition[Y] = floatstr(arrCoords[1]);
		BankPosition[Z] = floatstr(arrCoords[2]);
		BankPosition[World] = strval(arrCoords[3]);
		BankPosition[Interior] = strval(arrCoords[4]);
		BankPosition[Angle] = floatstr(arrCoords[5]);
		BankPosition[PickupID] = strval(arrCoords[6]);
		//Creating Pickup
        BankPosition[PickupID] = CreateStreamPickup(1239,1,BankPosition[X],BankPosition[Y],BankPosition[Z],PICKUP_RANGE);
        print("[INFO:] Bank location loaded.");
	}
	fclose(file);
	return 1;
}
public SaveBankPosition()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f|%d\n",
	BankPosition[X],
	BankPosition[Y],
	BankPosition[Z],
	BankPosition[World],
	BankPosition[Interior],
	BankPosition[Angle],
	BankPosition[PickupID]);
	file2 = fopen("CRP_Scriptfiles/Locations/banklocation.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public LoadDrivingTestPosition()
{
	new arrCoords[7][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Locations/drivingtestlocation.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		DrivingTestPosition[X] = floatstr(arrCoords[0]);
		DrivingTestPosition[Y] = floatstr(arrCoords[1]);
		DrivingTestPosition[Z] = floatstr(arrCoords[2]);
		DrivingTestPosition[World] = strval(arrCoords[3]);
		DrivingTestPosition[Interior] = strval(arrCoords[4]);
		DrivingTestPosition[Angle] = floatstr(arrCoords[5]);
		DrivingTestPosition[PickupID] = strval(arrCoords[6]);
		//Creating Pickup
        DrivingTestPosition[PickupID] = CreateStreamPickup(1239,1,DrivingTestPosition[X],DrivingTestPosition[Y],DrivingTestPosition[Z],PICKUP_RANGE);
        print("[INFO:] Driving test location loaded.");
	}
	fclose(file);
	return 1;
}
public SaveDrivingTestPosition()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f|%d\n",
	DrivingTestPosition[X],
	DrivingTestPosition[Y],
	DrivingTestPosition[Z],
	DrivingTestPosition[World],
	DrivingTestPosition[Interior],
	DrivingTestPosition[Angle],
	DrivingTestPosition[PickupID]);
	file2 = fopen("CRP_Scriptfiles/Locations/drivingtestlocation.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public LoadFlyingTestPosition()
{
	new arrCoords[7][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Locations/flyingtestlocation.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		FlyingTestPosition[X] = floatstr(arrCoords[0]);
		FlyingTestPosition[Y] = floatstr(arrCoords[1]);
		FlyingTestPosition[Z] = floatstr(arrCoords[2]);
		FlyingTestPosition[World] = strval(arrCoords[3]);
		FlyingTestPosition[Interior] = strval(arrCoords[4]);
		FlyingTestPosition[Angle] = floatstr(arrCoords[5]);
		FlyingTestPosition[PickupID] = strval(arrCoords[6]);
		//Creating Pickup
        FlyingTestPosition[PickupID] = CreateStreamPickup(1239,1,FlyingTestPosition[X],FlyingTestPosition[Y],FlyingTestPosition[Z],PICKUP_RANGE);
        print("[INFO:] Flying test location loaded.");
	}
	fclose(file);
	return 1;
}
public SaveFlyingTestPosition()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f|%d\n",
	FlyingTestPosition[X],
	FlyingTestPosition[Y],
	FlyingTestPosition[Z],
	FlyingTestPosition[World],
	FlyingTestPosition[Interior],
	FlyingTestPosition[Angle],
	FlyingTestPosition[PickupID]);
	file2 = fopen("CRP_Scriptfiles/Locations/flyingtestlocation.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public LoadWeaponLicensePosition()
{
	new arrCoords[7][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Locations/weaponlicenselocation.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		WeaponLicensePosition[X] = floatstr(arrCoords[0]);
		WeaponLicensePosition[Y] = floatstr(arrCoords[1]);
		WeaponLicensePosition[Z] = floatstr(arrCoords[2]);
		WeaponLicensePosition[World] = strval(arrCoords[3]);
		WeaponLicensePosition[Interior] = strval(arrCoords[4]);
		WeaponLicensePosition[Angle] = floatstr(arrCoords[5]);
		WeaponLicensePosition[PickupID] = strval(arrCoords[6]);
		//Creating Pickup
        WeaponLicensePosition[PickupID] = CreateStreamPickup(1239,1,WeaponLicensePosition[X],WeaponLicensePosition[Y],WeaponLicensePosition[Z],PICKUP_RANGE);
        print("[INFO:] Weapon License location loaded.");
	}
	fclose(file);
	return 1;
}
public SaveWeaponLicensePosition()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f|%d\n",
	WeaponLicensePosition[X],
	WeaponLicensePosition[Y],
	WeaponLicensePosition[Z],
	WeaponLicensePosition[World],
	WeaponLicensePosition[Interior],
	WeaponLicensePosition[Angle],
	WeaponLicensePosition[PickupID]);
	file2 = fopen("CRP_Scriptfiles/Locations/weaponlicenselocation.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public LoadPoliceArrestPosition()
{
	new arrCoords[6][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Locations/policearrestposition.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		PoliceArrestPosition[X] = floatstr(arrCoords[0]);
		PoliceArrestPosition[Y] = floatstr(arrCoords[1]);
		PoliceArrestPosition[Z] = floatstr(arrCoords[2]);
		PoliceArrestPosition[World] = strval(arrCoords[3]);
		PoliceArrestPosition[Interior] = strval(arrCoords[4]);
		PoliceArrestPosition[Angle] = floatstr(arrCoords[5]);
        print("[INFO:] Police Arrest location loaded.");
	}
	fclose(file);
	return 1;
}
public SavePoliceArrestPosition()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f\n",
	PoliceArrestPosition[X],
	PoliceArrestPosition[Y],
	PoliceArrestPosition[Z],
	PoliceArrestPosition[World],
	PoliceArrestPosition[Interior],
	PoliceArrestPosition[Angle]);
	file2 = fopen("CRP_Scriptfiles/Locations/policearrestposition.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public LoadPoliceDutyPosition()
{
	new arrCoords[6][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Locations/policedutyposition.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		PoliceDutyPosition[X] = floatstr(arrCoords[0]);
		PoliceDutyPosition[Y] = floatstr(arrCoords[1]);
		PoliceDutyPosition[Z] = floatstr(arrCoords[2]);
		PoliceDutyPosition[World] = strval(arrCoords[3]);
		PoliceDutyPosition[Interior] = strval(arrCoords[4]);
		PoliceDutyPosition[Angle] = floatstr(arrCoords[5]);
        print("[INFO:] Police Duty location loaded.");
	}
	fclose(file);
	return 1;
}
public SavePoliceDutyPosition()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f\n",
	PoliceDutyPosition[X],
	PoliceDutyPosition[Y],
	PoliceDutyPosition[Z],
	PoliceDutyPosition[World],
	PoliceDutyPosition[Interior],
	PoliceDutyPosition[Angle]);
	file2 = fopen("CRP_Scriptfiles/Locations/policedutyposition.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public LoadDetectiveJob()
{
	new arrCoords[7][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Jobs/detectivejob.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		DetectiveJobPosition[X] = floatstr(arrCoords[0]);
		DetectiveJobPosition[Y] = floatstr(arrCoords[1]);
		DetectiveJobPosition[Z] = floatstr(arrCoords[2]);
		DetectiveJobPosition[World] = strval(arrCoords[3]);
		DetectiveJobPosition[Interior] = strval(arrCoords[4]);
		DetectiveJobPosition[Angle] = floatstr(arrCoords[5]);
		DetectiveJobPosition[PickupID] = strval(arrCoords[6]);
		DetectiveJobPosition[PickupID] = CreateStreamPickup(1239,1,DetectiveJobPosition[X],DetectiveJobPosition[Y],DetectiveJobPosition[Z],PICKUP_RANGE);
        print("[INFO:] Detective job loaded.");
	}
	fclose(file);
	return 1;
}
public SaveDetectiveJob()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f|%d\n",
	DetectiveJobPosition[X],
	DetectiveJobPosition[Y],
	DetectiveJobPosition[Z],
	DetectiveJobPosition[World],
	DetectiveJobPosition[Interior],
	DetectiveJobPosition[Angle],
	DetectiveJobPosition[PickupID]);
	file2 = fopen("CRP_Scriptfiles/Jobs/detectivejob.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public LoadLawyerJob()
{
	new arrCoords[7][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Jobs/lawyerjob.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		LawyerJobPosition[X] = floatstr(arrCoords[0]);
		LawyerJobPosition[Y] = floatstr(arrCoords[1]);
		LawyerJobPosition[Z] = floatstr(arrCoords[2]);
		LawyerJobPosition[World] = strval(arrCoords[3]);
		LawyerJobPosition[Interior] = strval(arrCoords[4]);
		LawyerJobPosition[Angle] = floatstr(arrCoords[5]);
		LawyerJobPosition[PickupID] = strval(arrCoords[6]);
		LawyerJobPosition[PickupID] = CreateStreamPickup(1239,1,LawyerJobPosition[X],LawyerJobPosition[Y],LawyerJobPosition[Z],PICKUP_RANGE);
        print("[INFO:] Lawyer job loaded.");
	}
	fclose(file);
	return 1;
}
public SaveLawyerJob()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f|%d\n",
	LawyerJobPosition[X],
	LawyerJobPosition[Y],
	LawyerJobPosition[Z],
	LawyerJobPosition[World],
	LawyerJobPosition[Interior],
	LawyerJobPosition[Angle],
	LawyerJobPosition[PickupID]);
	file2 = fopen("CRP_Scriptfiles/Jobs/lawyerjob.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
//================================================[FACTION MATERIALS & DRUG STORAGE]===================================================
public LoadFactionMaterialsStorage()
{
	new arrCoords[7][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Locations/factionmatsstorage.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		FactionMaterialsStorage[X] = floatstr(arrCoords[0]);
		FactionMaterialsStorage[Y] = floatstr(arrCoords[1]);
		FactionMaterialsStorage[Z] = floatstr(arrCoords[2]);
		FactionMaterialsStorage[World] = strval(arrCoords[3]);
		FactionMaterialsStorage[Interior] = strval(arrCoords[4]);
		FactionMaterialsStorage[Angle] = floatstr(arrCoords[5]);
		FactionMaterialsStorage[PickupID] = strval(arrCoords[6]);
		//Creating Pickup
        FactionMaterialsStorage[PickupID] = CreateStreamPickup(1254,1,FactionMaterialsStorage[X],FactionMaterialsStorage[Y],FactionMaterialsStorage[Z],PICKUP_RANGE); // Faction Materials Storage Facility
        print("[INFO:] Faction materials storage location loaded.");
	}
	fclose(file);
	return 1;
}
public SaveFactionMaterialsStorage()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f|%d\n",
	FactionMaterialsStorage[X],
	FactionMaterialsStorage[Y],
	FactionMaterialsStorage[Z],
	FactionMaterialsStorage[World],
	FactionMaterialsStorage[Interior],
	FactionMaterialsStorage[Angle],
	FactionMaterialsStorage[PickupID]);
	file2 = fopen("CRP_Scriptfiles/Locations/factionmatsstorage.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
public LoadFactionDrugsStorage()
{
	new arrCoords[7][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Locations/factiondrugsstorage.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		FactionDrugsStorage[X] = floatstr(arrCoords[0]);
		FactionDrugsStorage[Y] = floatstr(arrCoords[1]);
		FactionDrugsStorage[Z] = floatstr(arrCoords[2]);
		FactionDrugsStorage[World] = strval(arrCoords[3]);
		FactionDrugsStorage[Interior] = strval(arrCoords[4]);
		FactionDrugsStorage[Angle] = floatstr(arrCoords[5]);
		FactionDrugsStorage[PickupID] = strval(arrCoords[6]);
		//Creating Pickup
        FactionDrugsStorage[PickupID] = CreateStreamPickup(1279,1,FactionDrugsStorage[X],FactionDrugsStorage[Y],FactionDrugsStorage[Z],PICKUP_RANGE); // Faction Materials Storage Facility
        print("[INFO:] Faction drugs storage location loaded.");
	}
	fclose(file);
	return 1;
}
public SaveFactionDrugsStorage()
{
	new File: file2;
	new coordsstring[512];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f|%d\n",
	FactionDrugsStorage[X],
	FactionDrugsStorage[Y],
	FactionDrugsStorage[Z],
	FactionDrugsStorage[World],
	FactionDrugsStorage[Interior],
	FactionDrugsStorage[Angle],
	FactionDrugsStorage[PickupID]);
	file2 = fopen("CRP_Scriptfiles/Locations/factiondrugsstorage.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
//===========================================================[DYNAMIC CIVILIAN SPAWN SYSTEM]===========================================
public LoadCivilianSpawn()
{
	new arrCoords[6][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Locations/civilianspawn.cfg", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, '|');
		CivilianSpawn[X] = floatstr(arrCoords[0]);
		CivilianSpawn[Y] = floatstr(arrCoords[1]);
		CivilianSpawn[Z] = floatstr(arrCoords[2]);
		CivilianSpawn[World] = strval(arrCoords[3]);
		CivilianSpawn[Interior] = strval(arrCoords[4]);
		CivilianSpawn[Angle] = floatstr(arrCoords[5]);
	}
	fclose(file);
	return 1;
}
public SaveCivilianSpawn()
{
	new File: file2;
	new coordsstring[64];
	format(coordsstring, sizeof(coordsstring), "%f|%f|%f|%d|%d|%f\n",
	CivilianSpawn[X],
	CivilianSpawn[Y],
	CivilianSpawn[Z],
	CivilianSpawn[World],
	CivilianSpawn[Interior],
	CivilianSpawn[Angle]);
	file2 = fopen("CRP_Scriptfiles/Locations/civilianspawn.cfg", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
//=============================================================[DYNAMIC BUSINESS SYSTEM]========================================
public SaveBusinesses()
{
	new idx;
	new File: file2;
	while (idx < sizeof(Businesses))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%s|%s|%f|%f|%f|%d|%d|%f|%f|%f|%f|%d|%f|%d|%d|%d|%d|%d|%d|%d|%d|%d\n",
		Businesses[idx][BusinessName],
		Businesses[idx][Owner],
		Businesses[idx][EnterX],
		Businesses[idx][EnterY],
		Businesses[idx][EnterZ],
		Businesses[idx][EnterWorld],
		Businesses[idx][EnterInterior],
		Businesses[idx][EnterAngle],
		Businesses[idx][ExitX],
		Businesses[idx][ExitY],
		Businesses[idx][ExitZ],
		Businesses[idx][ExitInterior],
		Businesses[idx][ExitAngle],
		Businesses[idx][Owned],
		Businesses[idx][Enterable],
		Businesses[idx][BizPrice],
		Businesses[idx][EntranceCost],
		Businesses[idx][Till],
		Businesses[idx][Locked],
		Businesses[idx][BizType],
		Businesses[idx][Products],
		Businesses[idx][PickupID]);

		if(idx == 0)
		{
			file2 = fopen("CRP_Scriptfiles/Businesses/businesses.cfg", io_write);
		}
		else
		{
			file2 = fopen("CRP_Scriptfiles/Businesses/businesses.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}
public LoadBusinesses()
{
	new arrCoords[22][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Businesses/businesses.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(Businesses))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			strmid(Businesses[idx][BusinessName], arrCoords[0], 0, strlen(arrCoords[0]), 255);
			strmid(Businesses[idx][Owner], arrCoords[1], 0, strlen(arrCoords[1]), 255);
			Businesses[idx][EnterX] = floatstr(arrCoords[2]);
			Businesses[idx][EnterY] = floatstr(arrCoords[3]);
			Businesses[idx][EnterZ] = floatstr(arrCoords[4]);
			Businesses[idx][EnterWorld] = strval(arrCoords[5]);
			Businesses[idx][EnterInterior] = strval(arrCoords[6]);
			Businesses[idx][EnterAngle] = floatstr(arrCoords[7]);
			Businesses[idx][ExitX] = floatstr(arrCoords[8]);
			Businesses[idx][ExitY] = floatstr(arrCoords[9]);
			Businesses[idx][ExitZ] = floatstr(arrCoords[10]);
			Businesses[idx][ExitInterior] = strval(arrCoords[11]);
			Businesses[idx][ExitAngle] = floatstr(arrCoords[12]);
			Businesses[idx][Owned] = strval(arrCoords[13]);
			Businesses[idx][Enterable] = strval(arrCoords[14]);
			Businesses[idx][BizPrice] = strval(arrCoords[15]);
			Businesses[idx][EntranceCost] = strval(arrCoords[16]);
			Businesses[idx][Till] = strval(arrCoords[17]);
			Businesses[idx][Locked] = strval(arrCoords[18]);
			Businesses[idx][BizType] = strval(arrCoords[19]);
			Businesses[idx][Products] = strval(arrCoords[20]);
			Businesses[idx][PickupID] = strval(arrCoords[21]);

			if(Businesses[idx][BizPrice] != 0) // Don't create the business icon if the price is 0.
			{
				if(Businesses[idx][Owned] == 0)
				{
					Businesses[idx][PickupID]=CreateStreamPickup(1272, 1, Businesses[idx][EnterX], Businesses[idx][EnterY], Businesses[idx][EnterZ],PICKUP_RANGE);
				}
				else if(Businesses[idx][Owned] == 1)
				{
				    Businesses[idx][PickupID]=CreateStreamPickup(1239, 1, Businesses[idx][EnterX], Businesses[idx][EnterY], Businesses[idx][EnterZ],PICKUP_RANGE);
				}
			}
			idx++;
		}
		fclose(file);
	}
	return 1;
}
//==============================================================================================================================

//=============================================================[DYNAMIC HOUSES SYSTEM]==========================================
public SaveHouses()
{
	new idx;
	new File: file2;
	while (idx < sizeof(Houses))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%s|%s|%f|%f|%f|%d|%d|%f|%f|%f|%f|%d|%f|%d|%d|%d|%d|%d|%d|%d|%d|%d\n",
		Houses[idx][Description],
		Houses[idx][Owner],
		Houses[idx][EnterX],
		Houses[idx][EnterY],
		Houses[idx][EnterZ],
		Houses[idx][EnterWorld],
		Houses[idx][EnterInterior],
		Houses[idx][EnterAngle],
		Houses[idx][ExitX],
		Houses[idx][ExitY],
		Houses[idx][ExitZ],
		Houses[idx][ExitInterior],
		Houses[idx][ExitAngle],
		Houses[idx][Owned],
		Houses[idx][Rentable],
		Houses[idx][RentCost],
		Houses[idx][HousePrice],
		Houses[idx][Materials],
		Houses[idx][Drugs],
		Houses[idx][Money],
		Houses[idx][Locked],
		Houses[idx][PickupID]);
		
		if(idx == 0)
		{
			file2 = fopen("CRP_Scriptfiles/Houses/houses.cfg", io_write);
		}
		else
		{
			file2 = fopen("CRP_Scriptfiles/Houses/houses.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}
public LoadHouses()
{
	new arrCoords[22][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Houses/houses.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(Houses))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			strmid(Houses[idx][Description], arrCoords[0], 0, strlen(arrCoords[0]), 255);
			strmid(Houses[idx][Owner], arrCoords[1], 0, strlen(arrCoords[1]), 255);
			Houses[idx][EnterX] = floatstr(arrCoords[2]);
			Houses[idx][EnterY] = floatstr(arrCoords[3]);
			Houses[idx][EnterZ] = floatstr(arrCoords[4]);
			Houses[idx][EnterWorld] = strval(arrCoords[5]);
			Houses[idx][EnterInterior] = strval(arrCoords[6]);
			Houses[idx][EnterAngle] = floatstr(arrCoords[7]);
			Houses[idx][ExitX] = floatstr(arrCoords[8]);
			Houses[idx][ExitY] = floatstr(arrCoords[9]);
			Houses[idx][ExitZ] = floatstr(arrCoords[10]);
			Houses[idx][ExitInterior] = strval(arrCoords[11]);
			Houses[idx][ExitAngle] = floatstr(arrCoords[12]);
			Houses[idx][Owned] = strval(arrCoords[13]);
			Houses[idx][Rentable] = strval(arrCoords[14]);
			Houses[idx][RentCost] = strval(arrCoords[15]);
			Houses[idx][HousePrice] = strval(arrCoords[16]);
			Houses[idx][Materials] = strval(arrCoords[17]);
			Houses[idx][Drugs] = strval(arrCoords[18]);
			Houses[idx][Money] = strval(arrCoords[19]);
			Houses[idx][Locked] = strval(arrCoords[20]);
			Houses[idx][PickupID] = strval(arrCoords[21]);

			if(Houses[idx][HousePrice] != 0) // Don't create the house icon if the price is 0.
			{
				if(Houses[idx][Owned] == 0)
				{
					Houses[idx][PickupID] = CreateStreamPickup(1273, 1, Houses[idx][EnterX], Houses[idx][EnterY], Houses[idx][EnterZ],PICKUP_RANGE);
				}
				else if(Houses[idx][Owned] == 1)
				{
					Houses[idx][PickupID] = CreateStreamPickup(1239, 1, Houses[idx][EnterX], Houses[idx][EnterY], Houses[idx][EnterZ],PICKUP_RANGE);
				}
			}
			idx++;
		}
		fclose(file);
	}
	return 1;
}
//============================================================[DYNAMIC BUILDING SYSTEM]=========================================
public LoadBuildings()
{
	new arrCoords[15][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Buildings/buildings.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(Building))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			strmid(Building[idx][BuildingName], arrCoords[0], 0, strlen(arrCoords[0]), 255);
			Building[idx][EnterX] = floatstr(arrCoords[1]);
			Building[idx][EnterY] = floatstr(arrCoords[2]);
			Building[idx][EnterZ] = floatstr(arrCoords[3]);
			Building[idx][EntranceFee] = strval(arrCoords[4]);
			Building[idx][EnterWorld] = strval(arrCoords[5]);
			Building[idx][EnterInterior] = strval(arrCoords[6]);
			Building[idx][EnterAngle] = floatstr(arrCoords[7]);
			Building[idx][ExitX] = floatstr(arrCoords[8]);
			Building[idx][ExitY] = floatstr(arrCoords[9]);
			Building[idx][ExitZ] = floatstr(arrCoords[10]);
			Building[idx][ExitInterior] = strval(arrCoords[11]);
			Building[idx][ExitAngle] = floatstr(arrCoords[12]);
			Building[idx][Locked] = strval(arrCoords[13]);
			Building[idx][PickupID] = strval(arrCoords[14]);
			
			Building[idx][PickupID] = CreateStreamPickup(1239, 1, Building[idx][EnterX], Building[idx][EnterY], Building[idx][EnterZ],PICKUP_RANGE); //Storing the PickupID in the PickupID variable.

			printf("[Building System:] Building Name: %s - Loaded. (%d)",Building[idx][BuildingName],idx);
			idx++;
		}
		fclose(file);
	}
	return 1;
}
public SaveBuildings()
{
	new idx;
	new File: file2;
	while (idx < sizeof(Building))
	{

		new coordsstring[512];
		format(coordsstring, sizeof(coordsstring), "%s|%f|%f|%f|%d|%d|%d|%f|%f|%f|%f|%d|%f|%d|%d\n",
		Building[idx][BuildingName],
		Building[idx][EnterX],
		Building[idx][EnterY],
		Building[idx][EnterZ],
		Building[idx][EntranceFee],
		Building[idx][EnterWorld],
		Building[idx][EnterInterior],
		Building[idx][EnterAngle],
		Building[idx][ExitX],
		Building[idx][ExitY],
		Building[idx][ExitZ],
		Building[idx][ExitInterior],
		Building[idx][ExitAngle],
		Building[idx][Locked],
		Building[idx][PickupID]);

		if(idx == 0)
		{
			file2 = fopen("CRP_Scriptfiles/Buildings/buildings.cfg", io_write);
		}
		else
		{
			file2 = fopen("CRP_Scriptfiles/Buildings/buildings.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}
//==============================================================================================================================

//===========================================================[DYNAMIC FACTION SYSTEM]===========================================
public LoadDynamicFactions()
{
	new arrCoords[33][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Factions/factions.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(DynamicFactions))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			strmid(DynamicFactions[idx][fName], arrCoords[0], 0, strlen(arrCoords[0]), 255);
			DynamicFactions[idx][fX] = floatstr(arrCoords[1]);
			DynamicFactions[idx][fY] = floatstr(arrCoords[2]);
			DynamicFactions[idx][fZ] = floatstr(arrCoords[3]);
			DynamicFactions[idx][fMaterials] = strval(arrCoords[4]);
			DynamicFactions[idx][fDrugs] = strval(arrCoords[5]);
			DynamicFactions[idx][fBank] = strval(arrCoords[6]);
			strmid(DynamicFactions[idx][fRank1], arrCoords[7], 0, strlen(arrCoords[7]), 255);
			strmid(DynamicFactions[idx][fRank2], arrCoords[8], 0, strlen(arrCoords[8]), 255);
            strmid(DynamicFactions[idx][fRank3], arrCoords[9], 0, strlen(arrCoords[9]), 255);
            strmid(DynamicFactions[idx][fRank4], arrCoords[10], 0, strlen(arrCoords[10]), 255);
            strmid(DynamicFactions[idx][fRank5], arrCoords[11], 0, strlen(arrCoords[11]), 255);
            strmid(DynamicFactions[idx][fRank6], arrCoords[12], 0, strlen(arrCoords[12]), 255);
            strmid(DynamicFactions[idx][fRank7], arrCoords[13], 0, strlen(arrCoords[13]), 255);
            strmid(DynamicFactions[idx][fRank8], arrCoords[14], 0, strlen(arrCoords[14]), 255);
            strmid(DynamicFactions[idx][fRank9], arrCoords[15], 0, strlen(arrCoords[15]), 255);
            strmid(DynamicFactions[idx][fRank10], arrCoords[16], 0, strlen(arrCoords[16]), 255);
			DynamicFactions[idx][fSkin1] = strval(arrCoords[17]);
			DynamicFactions[idx][fSkin2] = strval(arrCoords[18]);
			DynamicFactions[idx][fSkin3] = strval(arrCoords[19]);
			DynamicFactions[idx][fSkin4] = strval(arrCoords[20]);
			DynamicFactions[idx][fSkin5] = strval(arrCoords[21]);
			DynamicFactions[idx][fSkin6] = strval(arrCoords[22]);
			DynamicFactions[idx][fSkin7] = strval(arrCoords[23]);
			DynamicFactions[idx][fSkin8] = strval(arrCoords[24]);
			DynamicFactions[idx][fSkin9] = strval(arrCoords[25]);
			DynamicFactions[idx][fSkin10] = strval(arrCoords[26]);
			DynamicFactions[idx][fJoinRank] = strval(arrCoords[27]);
			DynamicFactions[idx][fUseSkins] = strval(arrCoords[28]);
			DynamicFactions[idx][fType] = strval(arrCoords[29]);
			DynamicFactions[idx][fRankAmount] = strval(arrCoords[30]);
			strmid(DynamicFactions[idx][fColor], arrCoords[31], 0, strlen(arrCoords[31]), 255);
			DynamicFactions[idx][fUseColor] = strval(arrCoords[32]);
			printf("[DYNAMIC FACTIONS:] Faction Name: %s, Type: %d, ID: %d",DynamicFactions[idx][fName],DynamicFactions[idx][fType],idx);
			idx++;
		}
		fclose(file);
	}
	return 1;
}
public SaveDynamicFactions()
{
	new idx;
	new File: file2;
	while (idx < sizeof(DynamicFactions))
	{

		new coordsstring[512];
		format(coordsstring, sizeof(coordsstring), "%s|%f|%f|%f|%d|%d|%d|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%s|%d\n",
		DynamicFactions[idx][fName],
		DynamicFactions[idx][fX],
		DynamicFactions[idx][fY],
		DynamicFactions[idx][fZ],
		DynamicFactions[idx][fMaterials],
		DynamicFactions[idx][fDrugs],
		DynamicFactions[idx][fBank],
		DynamicFactions[idx][fRank1],
		DynamicFactions[idx][fRank2],
		DynamicFactions[idx][fRank3],
		DynamicFactions[idx][fRank4],
		DynamicFactions[idx][fRank5],
		DynamicFactions[idx][fRank6],
		DynamicFactions[idx][fRank7],
		DynamicFactions[idx][fRank8],
		DynamicFactions[idx][fRank9],
		DynamicFactions[idx][fRank10],
		DynamicFactions[idx][fSkin1],
		DynamicFactions[idx][fSkin2],
		DynamicFactions[idx][fSkin3],
		DynamicFactions[idx][fSkin4],
		DynamicFactions[idx][fSkin5],
		DynamicFactions[idx][fSkin6],
		DynamicFactions[idx][fSkin7],
		DynamicFactions[idx][fSkin8],
		DynamicFactions[idx][fSkin9],
		DynamicFactions[idx][fSkin10],
		DynamicFactions[idx][fJoinRank],
		DynamicFactions[idx][fUseSkins],
		DynamicFactions[idx][fType],
		DynamicFactions[idx][fRankAmount],
		DynamicFactions[idx][fColor],
		DynamicFactions[idx][fUseColor]);

		if(idx == 0)
		{
			file2 = fopen("CRP_Scriptfiles/Factions/factions.cfg", io_write);
		}
		else
		{
			file2 = fopen("CRP_Scriptfiles/Factions/factions.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}
//=====================================================[DYNAMIC CAR SYSTEM]=====================================================
forward CreateVehicleFromDB(uid);
public CreateVehicleFromDB(uid)
{
	new pointer = CreateVehicle(DynamicCars[uid][CarModel], DynamicCars[uid][CarX], DynamicCars[uid][CarY], DynamicCars[uid][CarZ], DynamicCars[uid][CarAngle], DynamicCars[uid][CarColor1], DynamicCars[uid][CarColor2], -1);
	DynamicCars[uid][CarID] = uid;
	return pointer;
}

public LoadDynamicCars()
{
	new vid = 1;
	print("[carSystem:] Zaczynam wczytywac pojazdy...");
	mysql_query("SELECT * FROM `vehicles`");
	mysql_store_result();
	vid++;
	while(mysql_fetch_row_format(fetch, "|"))
	{
	    new uid;
	    sscanf(fetch, "p<|>d", uid);
	    sscanf(fetch, "p<|>ddffffdddddd",
	    uid,
	    DynamicCars[uid][CarModel],
	    DynamicCars[uid][CarX],
	    DynamicCars[uid][CarY],
	    DynamicCars[uid][CarZ],
	    DynamicCars[uid][CarAngle],
	    DynamicCars[uid][CarColor1],
	    DynamicCars[uid][CarColor2],
	    DynamicCars[uid][FactionCar],
	    DynamicCars[uid][CarType],
	    DynamicCars[uid][Cena],
	    DynamicCars[uid][OwnID]
		);
		DynamicCars[uid][CarID] = uid;
		if(DynamicCars[uid][CarModel] != 0)
		{
		    CreateVehicleFromDB(uid);
		}
		ile++;
	}
	mysql_free_result();
	printf("[carSystem:] %d pojazd(ow) wczytanych", ile);
	return 1;
}
public SaveDynamicCars(uid)
{
	format(fetch, sizeof(fetch), "update `vehicles` set `carmodel`='%d', `carx`='%f', `cary`='%f', `carz`='%f', `carangle`='%f', `carcolor1`='%d', `carcolor2`='%d', `factioncar`='%d', `cartype`='%d', `cena`='%d', `ownid`='%d' where `id`='%d'",
	DynamicCars[uid][CarModel],
	DynamicCars[uid][CarX],
 	DynamicCars[uid][CarY],
 	DynamicCars[uid][CarZ],
  	DynamicCars[uid][CarAngle],
  	DynamicCars[uid][CarColor1],
  	DynamicCars[uid][CarColor2],
  	DynamicCars[uid][FactionCar],
  	DynamicCars[uid][CarType],
   	DynamicCars[uid][Cena],
   	DynamicCars[uid][OwnID],
   	uid);
   	mysql_query(fetch);
   	mysql_free_result();
	return 1;
}
//===============================================================================================================================
stock StopMusic(playerid)
{
	PlayerPlaySound(playerid, 1069, 0.0, 0.0, 0.0);
}
public SyncTime()
{
	new tmphour;
	new tmpminute;
	new tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	FixHour(tmphour);
	tmphour = shifthour;
	if ((tmphour > ghour) || (tmphour == 0 && ghour == 23))
	{
		ghour = tmphour;
		PayDay();
		if (realtime)
		{
			SetWorldTime(tmphour);
		}
	}
}
public ShowStats(playerid,targetid)
{
    if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		if(gPlayerLogged[targetid])
		{
			SendClientMessage(playerid,COLOR_YELLOW,"____________________________________________________");
			
			new wstring[128];
			new level = PlayerInfo[targetid][pLevel];
			new exp = PlayerInfo[targetid][pExp];
			new nxtlevel = PlayerInfo[targetid][pLevel]+1;
			new expamount = nxtlevel*levelexp;
			new drugs = PlayerInfo[targetid][pDrugs];
			new mats = PlayerInfo[targetid][pMaterials];
			new housekey = PlayerInfo[targetid][pHouseKey];
			new bizkey = PlayerInfo[targetid][pBizKey];
		    new playinghours = PlayerInfo[targetid][pPlayingHours];
		    new bank = PlayerInfo[targetid][pBank];
		    new warnings = PlayerInfo[targetid][pWarnings];
		    new Float:hp;
			GetPlayerHealth(targetid,hp);
 			new age = PlayerInfo[targetid][pAge];
 			new products = PlayerInfo[targetid][pProducts];
 			new donatortext[128];
 			new phonenumbertext[128];
			new location[MAX_ZONE_NAME];
			GetPlayer2DZone(playerid, location, MAX_ZONE_NAME);
			new phonenetwork[128];
			new jobtext[128];
			new weplicense[128];
			new flylicense[128];
			new carlicense[128];
			new ranktext[256];
			
			switch(PlayerInfo[targetid][pJob])
			{
			    case 0: jobtext = "None";
			    case 1: jobtext = "Arms Dealer";
			    case 2: jobtext = "Drug Dealer";
			    case 3: jobtext = "Detective";
			    case 4: jobtext = "Lawyer";
			    case 5: jobtext = "Products Seller";
			}
			switch(PlayerInfo[targetid][pDonator])
			{
			    case 0: donatortext = "No";
			    case 1: donatortext = "Yes";
			}
			switch(PlayerInfo[targetid][pCarLic])
			{
			    case 0: carlicense = "No";
			    case 1: carlicense = "Yes";
			}
			switch(PlayerInfo[targetid][pFlyLic])
			{
			    case 0: flylicense = "No";
			    case 1: flylicense = "Yes";
			}
			switch(PlayerInfo[targetid][pWepLic])
			{
			    case 0: weplicense = "No";
			    case 1: weplicense = "Yes";
			}
			
			if(PlayerInfo[targetid][pPhoneC] == 255) { phonenetwork = "None"; } else { format(phonenetwork, sizeof(phonenetwork), "%s",Businesses[PlayerInfo[targetid][pPhoneC]][BusinessName]); }
			if(PlayerInfo[targetid][pPhoneNumber] == 0) { phonenumbertext = "None"; } else { format(phonenumbertext, sizeof(phonenumbertext), "%d",PlayerInfo[targetid][pPhoneNumber]); }
			
   			format(wstring, sizeof(wstring), "[GENERAL:] Name: %s - Health: %.1f - Cash: $%d - Level: %d - Experience: %d/%d - Materials: %d - Drugs: %d",GetPlayerNameEx(targetid),hp,GetPlayerCash(targetid),level,exp,expamount,mats,drugs);
		    SendClientMessage(playerid,COLOR_WHITE, wstring);
   			format(wstring, sizeof(wstring), "[GENERAL:] House Key: %d - Business Key: %d - Location: %s - Bank: $%d - Warnings: %d - Age: %d - Playing Hours: %d", housekey,bizkey,location,bank,warnings,age,playinghours);
		    SendClientMessage(playerid,COLOR_WHITE, wstring);
   			format(wstring, sizeof(wstring), "[GENERAL:] Phone Number: %s - Phone Network: %s - Donator: %s - Job: %s - Products: %d", phonenumbertext,phonenetwork,donatortext,jobtext,products);
		    SendClientMessage(playerid,COLOR_WHITE, wstring);
   			format(wstring, sizeof(wstring), "[LICENSES:] Driving License: %s - Flying License: %s - Weapon License: %s", carlicense, flylicense, weplicense);
		    SendClientMessage(playerid,COLOR_WHITE, wstring);
		    
		    if(PlayerInfo[targetid][pFaction] != 255)
			{
	      		switch(PlayerInfo[targetid][pRank])
			    {
			        case 1: format(ranktext, sizeof(ranktext), "%s", DynamicFactions[PlayerInfo[targetid][pFaction]][fRank1]);
			        case 2: format(ranktext, sizeof(ranktext), "%s", DynamicFactions[PlayerInfo[targetid][pFaction]][fRank2]);
			        case 3: format(ranktext, sizeof(ranktext), "%s", DynamicFactions[PlayerInfo[targetid][pFaction]][fRank3]);
			        case 4: format(ranktext, sizeof(ranktext), "%s", DynamicFactions[PlayerInfo[targetid][pFaction]][fRank4]);
			        case 5: format(ranktext, sizeof(ranktext), "%s", DynamicFactions[PlayerInfo[targetid][pFaction]][fRank5]);
			        case 6: format(ranktext, sizeof(ranktext), "%s", DynamicFactions[PlayerInfo[targetid][pFaction]][fRank6]);
			        case 7: format(ranktext, sizeof(ranktext), "%s", DynamicFactions[PlayerInfo[targetid][pFaction]][fRank7]);
			        case 8: format(ranktext, sizeof(ranktext), "%s", DynamicFactions[PlayerInfo[targetid][pFaction]][fRank8]);
			        case 9: format(ranktext, sizeof(ranktext), "%s", DynamicFactions[PlayerInfo[targetid][pFaction]][fRank9]);
			        case 10: format(ranktext, sizeof(ranktext), "%s", DynamicFactions[PlayerInfo[targetid][pFaction]][fRank10]);
			    }
		 		format(wstring, sizeof(wstring), "[FACTION:] Faction: %s - Rank: %s",DynamicFactions[PlayerInfo[targetid][pFaction]][fName],ranktext);
  				SendClientMessage(playerid,COLOR_WHITE, wstring);
			}
			else
			{
				SendClientMessage(playerid,COLOR_WHITE, "[FACTION:] Faction: None - Rank: None");
			}
		    
			SendClientMessage(playerid,COLOR_YELLOW,"____________________________________________________");
		}
	}
}
public FixHour(hour)
{
	hour = timeshift+hour;
	if (hour < 0)
	{
		hour = hour+24;
	}
	else if (hour > 23)
	{
		hour = hour-24;
	}
	shifthour = hour;
	return 1;
}
public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}
stock IsSkinValid(SkinID) return ((SkinID >= 0 && SkinID <= 1)||(SkinID == 2)||(SkinID == 7)||(SkinID >= 9 && SkinID <= 41)||(SkinID >= 43 && SkinID <= 85)||(SkinID >=87 && SkinID <= 118)||(SkinID >= 120 && SkinID <= 148)||(SkinID >= 150 && SkinID <= 207)||(SkinID >= 209 && SkinID <= 272)||(SkinID >= 274 && SkinID <= 288)||(SkinID >= 290 && SkinID <= 299)) ? true:false;

stock ClearScreen(playerid)
{
	for(new i = 0; i < 50; i++)
	{
	    SendClientMessage(playerid, COLOR_WHITE, " ");
	}
	return 0;
}
stock GetPlayerFirstName(playerid)
{
	new namestring[2][MAX_PLAYER_NAME];
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,MAX_PLAYER_NAME);
	split(name, namestring, '_');
	return namestring[0];
}
stock GetPlayerLastName(playerid)
{
	new namestring[2][MAX_PLAYER_NAME];
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,MAX_PLAYER_NAME);
	split(name, namestring, '_');
	return namestring[1];
}
stock GetVehicleCount()
{
	new count;
	for(new v = 1; v < MAX_VEHICLES; v++)
	{
		if (IsVehicleSpawned(v)) count++;
	}
	return count;
}

stock IsVehicleSpawned(vehicleid)
{
	new Float:VX,Float:VY,Float:VZ;
	GetVehiclePos(vehicleid,VX,VY,VZ);
	if (VX == 0.0 && VY == 0.0 && VZ == 0.0) return 0;
	return 1;
}
stock GetPlayerIpAddress(playerid)
{
	new IP[16];
	GetPlayerIp(playerid, IP, sizeof(IP));
	return IP;
}

stock GetPlayerNameEx(playerid)
{
    new string[24];
    GetPlayerName(playerid,string,24);
    new str[24];
    strmid(str,string,0,strlen(string),24);
    for(new i = 0; i < MAX_PLAYER_NAME; i++)
    {
        if (str[i] == '_') str[i] = ' ';
    }
    return str;
}
stock GetObjectCount()
{
	new count;
	for(new o; o < MAX_OBJECTS; o++)
	{
		if (IsValidObject(o)) count++;
	}
	return count;
}

ReturnUser(text[], playerid = INVALID_PLAYER_ID)
{
	new pos = 0;
	while (text[pos] < 0x21) // Strip out leading spaces
	{
		if (text[pos] == 0) return INVALID_PLAYER_ID; // No passed text
		pos++;
	}
	new userid = INVALID_PLAYER_ID;
	if (IsNumeric(text[pos])) // Check whole passed string
	{
		// If they have a numeric name you have a problem (although names are checked on id failure)
		userid = strval(text[pos]);
		if (userid >=0 && userid < MAX_PLAYERS)
		{
			if(!IsPlayerConnected(userid))
			{
				/*if (playerid != INVALID_PLAYER_ID)
				{
					SendClientMessage(playerid, 0xFF0000AA, "User not connected");
				}*/
				userid = INVALID_PLAYER_ID;
			}
			else
			{
				return userid; // A player was found
			}
		}
		/*else
		{
			if (playerid != INVALID_PLAYER_ID)
			{
				SendClientMessage(playerid, 0xFF0000AA, "Invalid user ID");
			}
			userid = INVALID_PLAYER_ID;
		}
		return userid;*/
		// Removed for fallthrough code
	}
	// They entered [part of] a name or the id search failed (check names just incase)
	new len = strlen(text[pos]);
	new count = 0;
	new name[MAX_PLAYER_NAME];
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i, name, sizeof (name));
			if (strcmp(name, text[pos], true, len) == 0) // Check segment of name
			{
				if (len == strlen(name)) // Exact match
				{
					return i; // Return the exact player on an exact match
					// Otherwise if there are two players:
					// Me and MeYou any time you entered Me it would find both
					// And never be able to return just Me's id
				}
				else // Partial match
				{
					count++;
					userid = i;
				}
			}
		}
	}
	if (count != 1)
	{
		if (playerid != INVALID_PLAYER_ID)
		{
			if (count)
			{
				SendClientMessage(playerid, 0xFF0000AA, "Multiple users found, please narrow earch");
			}
			else
			{
				SendClientMessage(playerid, 0xFF0000AA, "No matching user found");
			}
		}
		userid = INVALID_PLAYER_ID;
	}
	return userid; // INVALID_USER_ID for bad return
}
IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}
public KickPlayer(playerid,kickedby[MAX_PLAYER_NAME],reason[])
{
	new string[128];
	format(string,sizeof(string),"[C-RPG:]%s zosta³ wyrucony przez %s, Powoód: %s ",GetPlayerNameEx(playerid),kickedby,reason);
	SendClientMessageToAll(COLOR_ADMINCMD,string);
	KickLog(string);
	return Kick(playerid);
}
public BanPlayerAccount(playerid,bannedby[MAX_PLAYER_NAME],reason[])
{
	new string[128];
	format(string,sizeof(string),"[C-RPG:]%s zosta³ zablokowany przez %s, Powód: %s ",GetPlayerNameEx(playerid),bannedby,reason);
	SendClientMessageToAll(COLOR_ADMINCMD,string);
	AccountBanLog(string);
	PlayerInfo[playerid][pBanned] = 1;
	OnPlayerDataSave(playerid);
	return Kick(playerid);
}
public BanPlayer(playerid,bannedby[MAX_PLAYER_NAME],reason[])
{
	new string[128];
	format(string,sizeof(string),"[C-RPG:]%s zosta³ zbanowany przez %s, Powód: %s ",GetPlayerNameEx(playerid),bannedby,reason);
	SendClientMessageToAll(COLOR_ADMINCMD,string);
	BanLog(string);
	return Ban(playerid);
}
public ShowScriptStats(playerid)
{
	new form[128];
	format(form, sizeof form, "%s [%s] | Stworzy³ %s | Napisanych linii: %d | Ostatnia aktualizacja: %s", GAMEMODE,VERSION,DEVELOPER,SCRIPT_LINES,LAST_UPDATE);
	SendClientMessage(playerid, COLOR_WHITE,form);

 	if(PlayerInfo[playerid][pAdmin] >= 1)
	{
		format(form, sizeof form, "Strona www: %s | Mapa: %s | Has³o serwera: %s | Wejœæ: %d", WEBSITE,MAP_NAME,ShowServerPassword(),JoinCounter);
		SendClientMessage(playerid, COLOR_WHITE,form);
	}
	else
	{
		format(form, sizeof form, "Strona www: %s | Mapa: %s | Wejœæ: %d",WEBSITE,MAP_NAME,JoinCounter);
		SendClientMessage(playerid, COLOR_WHITE,form);
	}
}
public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}
stock ShowServerPassword()
{
	new pass[128];
	if (strlen(PASSWORD) != 0)
	{
		format(pass, sizeof pass, "%s", PASSWORD);
	}
	else
	{
	    pass = "None";
	}
	return pass;
}
//===============================================[ZONE FUNCTIONS]================================================================
stock GetCoords2DZone(Float:x, Float:y, zone[], len)
{
 	for(new i = 0; i != sizeof(gSAZones); i++ )
 	{
		if(x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4])
		{
		    return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}
stock GetPlayer2DZone(playerid, zone[], len)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
 	for(new i = 0; i != sizeof(gSAZones); i++ )
 	{
		if(x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4])
		{
		    return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}
stock GetPlayer3DZone(playerid, zone[], len)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
 	for(new i = 0; i != sizeof(gSAZones); i++ )
 	{
		if(x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4] && z >= gSAZones[i][SAZONE_AREA][2] && z <= gSAZones[i][SAZONE_AREA][5])
		{
		    return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}
stock IsPlayerInZone(playerid, zone[])
{
	new TmpZone[MAX_ZONE_NAME];
	GetPlayer3DZone(playerid, TmpZone, sizeof(TmpZone));
	for(new i = 0; i != sizeof(gSAZones); i++)
	{
		if(strfind(TmpZone, zone, true) != -1)
			return 1;
	}
	return 0;
}
//====================================================[Chat Functions]=============================================================
public SendFactionMessage(faction, color, string[])
{
for(new i = 0; i < MAX_PLAYERS; i++)
{
	if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pFaction] != 255)
		    {
			 	if(PlayerInfo[i][pFaction] == faction)
			  	{
 	 				SendClientMessage(i, color, string);
				}
			}
		}
	}
}
public SendFactionTypeMessage(factiontype, color, string[])
{
for(new i = 0; i < MAX_PLAYERS; i++)
{
	if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pFaction] != 255)
		    {
			 	if(DynamicFactions[PlayerInfo[i][pFaction]][fType] == factiontype)
			  	{
				 	if(DynamicFactions[PlayerInfo[i][pFaction]][fType] == 1)
			  	    {
			  	        if(CopOnDuty[i])
			  	        {
			  	            SendClientMessage(i, color, string);
			  	        }
			  	    }
			  	    else
			  	    {
						SendClientMessage(i, color, string);
					}
				}
			}
		}
	}
}
//==================================================================================================================================
public PickupGametexts()
{
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new string[128];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			GetPlayerPos(i, oldposx, oldposy, oldposz);
			if(oldposx!=0.0 && oldposy!=0.0 && oldposz!=0.0)
			{
			    //=============================================[BUILDING GAMETEXTS]==========================================
				for(new h = 0; h < sizeof(Building); h++)
				{
					if (PlayerToPoint(1.0, i,Building[h][EnterX], Building[h][EnterY], Building[h][EnterZ]))
					{
					if(GetPlayerCash(i) >= Building[h][EntranceFee])
					{
					    if(Building[h][EntranceFee] > 1)
					    {
					    	format(string, sizeof(string), "%s~n~~w~Oplata za wejscie: ~g~$%d",Building[h][BuildingName],Building[h][EntranceFee]);
					    	GameTextForPlayer(i, string, 3500, 3);
						}
						else
						{
							format(string, sizeof(string), "%s",Building[h][BuildingName]);
							GameTextForPlayer(i, string, 3500, 3);
						}
					}
					else
					{
         				if(Building[h][EntranceFee] > 1)
         				{
         					format(string, sizeof(string), "%s~n~~w~Oplata za wejscie: ~r~$%d",Building[h][BuildingName],Building[h][EntranceFee]);
         					GameTextForPlayer(i, string, 3500, 3);
         				}
         				else
         				{
         					format(string, sizeof(string), "%s",Building[h][BuildingName]);
         					GameTextForPlayer(i, string, 3500, 3);
         				}
					}
					}
				}
				//=========================================================================================================
				//======================================[HOUSE GAMETEXTS]===================================================
				for(new n = 0; n < sizeof(Houses); n++)
				{
					if (PlayerToPoint(1.0, i,Houses[n][EnterX], Houses[n][EnterY], Houses[n][EnterZ]))
					{
					    if(Houses[n][HousePrice] != 0) //Only show the house if price is set
					    {
						    if(Houses[n][Owned] == 0)
						    {
			    				new houselocation[MAX_ZONE_NAME];
								GetCoords2DZone(Houses[n][EnterX],Houses[n][EnterY], houselocation, MAX_ZONE_NAME);
								format(string, sizeof(string), "~g~Ten dom jest na sprzedaz!~n~~w~Adres: ~y~ %d %s~n~~w~Cena: ~y~$%d~n~%s",n,houselocation,Houses[n][HousePrice]);
						    	GameTextForPlayer(i, string, 3500, 3);
							}
							else
							{
							    if(Houses[n][Rentable] == 1)
							    {
		   							new houselocation[MAX_ZONE_NAME];
									GetCoords2DZone(Houses[n][EnterX],Houses[n][EnterY], houselocation, MAX_ZONE_NAME);
			    					format(string, sizeof(string), "~w~Adres: ~y~%d %s~n~~w~Wlasciciel: ~y~%s ~n~~w~Cena wynajmu: ~y~$%d",n,houselocation,Houses[n][Owner],Houses[n][RentCost]);
							    	GameTextForPlayer(i, string, 3500, 3);
							    }
							    else
							    {
		  							new houselocation[MAX_ZONE_NAME];
									GetCoords2DZone(Houses[n][EnterX],Houses[n][EnterY], houselocation, MAX_ZONE_NAME);
			    					format(string, sizeof(string), "~w~Address: ~y~%d %s~n~~w~Wlasciciel: ~y~%s",n,houselocation,Houses[n][Owner]);
							    	GameTextForPlayer(i, string, 3500, 3);
						    	}
							}
						}
					}
				}
				//=======================================[BUSINESS GAMETEXTS]=========================================================
				for(new n = 0; n < sizeof(Businesses); n++)
				{
					if (PlayerToPoint(1.0, i,Businesses[n][EnterX], Businesses[n][EnterY], Businesses[n][EnterZ]))
					{
					    new businesstype[128];
					    if(Businesses[n][BizType] != 0)
					    {
	    					if(Businesses[n][BizType] == 1) { businesstype = "Restauracja"; }
						    else if(Businesses[n][BizType] == 2) { businesstype = "Telekomunikacja"; }
						    else if(Businesses[n][BizType] == 3) { businesstype = "Market"; }
						    else if(Businesses[n][BizType] == 4) { businesstype = "Sklep z bronia"; }
						    else if(Businesses[n][BizType] == 5) { businesstype = "Ogloszenia"; }
						    else if(Businesses[n][BizType] == 6) { businesstype = "Sklep z ubraniami"; }
						    else if(Businesses[n][BizType] == 7) { businesstype = "Bar"; }
						    else if(Businesses[n][BizType] == 8) { businesstype = "Sex shop"; }
						    else if(Businesses[n][BizType] == 9) { businesstype = "Coffee Shop"; }
						    else if(Businesses[n][BizType] == 10) { businesstype = "Hurtownia"; }
						    
					    }
					    else { businesstype = "Nie przyznano"; }
					    
					    if(Businesses[n][BizPrice] != 0) //Only show the business if price is set
					    {
						    if(Businesses[n][Owned] == 0)
						    {
								format(string, sizeof(string), "~g~Ten biznes jest na sprzedaz!~n~~w~Nazwa: ~y~%s ~n~~w~Typ: ~y~%s ~n~~w~Cena: ~y~$%d",Businesses[n][BusinessName],businesstype,Businesses[n][BizPrice]);
						    	GameTextForPlayer(i, string, 3500, 3);
							}
							else
							{
							    format(string, sizeof(string), "~w~Nazwa: ~y~%s ~n~~w~Typ: ~y~%s ~n~~w~Wlasciciel: ~y~%s~n~~w~Wejsciowka: ~y~$%d",Businesses[n][BusinessName],businesstype,Businesses[n][Owner],Businesses[n][EntranceCost]);
					    		GameTextForPlayer(i, string, 3500, 3);
							}
						}
					}
				}
				//=========================================[FUEL GAMETEXT]=============================================================
    			if(ShowFuel[i] && GetPlayerState(i) == PLAYER_STATE_DRIVER)
    			{
    			    new form[128];
    				new vehicle = GetPlayerVehicleID(i);
    				if(!OutOfFuel[i])
    				{
	    				if(Fuel[vehicle] <= 25)
	    				{
	    				    if(EngineStatus[vehicle])
	    				    {
	   	    					format(form, sizeof(form), "~w~~n~~n~~n~~n~~n~~n~~y~Silnik odpalony.~n~~w~Paliwo:~g~ %d%~n~~r~Malo paliwa.",Fuel[vehicle]);
		    					GameTextForPlayer(i,form,1000,5);
	    				    }
	    				    else
	    				    {
	   	    					format(form, sizeof(form), "~w~~n~~n~~n~~n~~n~~n~~y~Silnik nie odpalony.~n~~w~Paliwo:~g~ %d%~n~~r~Malo paliwa.",Fuel[vehicle]);
		    					GameTextForPlayer(i,form,1000,5);
	    				    }
	    				}
	  					else
	  					{
	  					    if(EngineStatus[vehicle])
	  					    {
		  						format(form, sizeof(form), "~w~~n~~n~~n~~n~~n~~n~~y~Silnik odpalony.~n~~w~Paliwo:~g~ %d%",Fuel[vehicle]);
		  						GameTextForPlayer(i,form,1000,5);
	  						}
	  						else
	  						{
	  							format(form, sizeof(form), "~w~~n~~n~~n~~n~~n~~n~~y~Silnik nie odpalony.~n~~w~Paliwo:~g~ %d%",Fuel[vehicle]);
		  						GameTextForPlayer(i,form,1000,5);
	  						}
	  					}
  					}
  				}
  				//========================================================================================================================
				//======================================================================================================
				if (PlayerToPoint(1.0, i,DrivingTestPosition[X],DrivingTestPosition[Y],DrivingTestPosition[Z]))
				{
				    if(GetPlayerVirtualWorld(i) == DrivingTestPosition[World])
				    {
						GameTextForPlayer(i, "~w~Prawojazdy~n~Cena: ~g~$1500~n~~w~/prawko", 3500, 3);
					}
				}
				else if(PlayerToPoint(1.0, i,FlyingTestPosition[X],FlyingTestPosition[Y],FlyingTestPosition[Z]))
				{
    				if(GetPlayerVirtualWorld(i) == FlyingTestPosition[World])
	     			{
						GameTextForPlayer(i, "~w~Licencja pilota~n~Cena: ~g~$20000~n~~w~/lickapilota", 3500, 3);
					}
				}
				else if(PlayerToPoint(1.0, i,WeaponLicensePosition[X],WeaponLicensePosition[Y],WeaponLicensePosition[Z]))
				{
    				if(GetPlayerVirtualWorld(i) == WeaponLicensePosition[World])
	     			{
						GameTextForPlayer(i, "~w~Licencja na bron~n~Cena: ~g~$50000~n~~w~/lickabron", 3500, 3);
					}
				}
				else if(PlayerToPoint(1.0, i,BankPosition[X],BankPosition[Y],BankPosition[Z]))
				{
    				if(GetPlayerVirtualWorld(i) == BankPosition[World])
	     			{
						GameTextForPlayer(i, "~w~Bank~n~~r~/bankcmd", 3500, 3);
					}
				}
				else if(PlayerToPoint(1.0, i,FactionMaterialsStorage[X],FactionMaterialsStorage[Y],FactionMaterialsStorage[Z]))
				{
				    if(PlayerInfo[i][pFaction] != 255 && DynamicFactions[PlayerInfo[i][pFaction]][fType] != 1)
				    {
				    	GameTextForPlayer(i, "~w~Frakcyjna skladnica materialow", 3500, 3);
				    }
				    else
				    {
				    	GameTextForPlayer(i, "~r~Unknown", 3500, 3);
				    }
				}
				else if(PlayerToPoint(1.0, i,FactionDrugsStorage[X],FactionDrugsStorage[Y],FactionDrugsStorage[Z]))
				{
				    if(PlayerInfo[i][pFaction] != 255 && DynamicFactions[PlayerInfo[i][pFaction]][fType] != 1)
				    {
   						GameTextForPlayer(i, "~w~Frakcyjna skladnica dragow", 3500, 3);
				    }
				    else
				    {
				    	GameTextForPlayer(i, "~r~Unknown", 3500, 3);
				    }
				}
    			else if(PlayerToPoint(1.0, i,GunJob[TakeJobX],GunJob[TakeJobY],GunJob[TakeJobZ]))
				{
				    if(GetPlayerVirtualWorld(i) == GunJob[TakeJobWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Praca dilera broni~n~~w~/wezprace", 3500, 3);
   					}
				}
				else if(PlayerToPoint(1.0, i,GunJob[BuyPackagesX],GunJob[BuyPackagesY],GunJob[BuyPackagesZ]))
				{
				    if(GetPlayerVirtualWorld(i) == GunJob[BuyPackagesWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Sklad broni~n~~w~/mkup", 3500, 3);
   					}
				}
    			else if(PlayerToPoint(1.0, i,GunJob[DeliverX],GunJob[DeliverY],GunJob[DeliverZ]))
				{
				    if(GetPlayerVirtualWorld(i) == GunJob[DeliverWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Sklad broni~n~~w~/mdostarcz", 3500, 3);
   					}
				}
 				else if(PlayerToPoint(1.0, i,DrugJob[TakeJobX],DrugJob[TakeJobY],DrugJob[TakeJobZ]))
				{
				    if(GetPlayerVirtualWorld(i) == DrugJob[TakeJobWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Diler narkotykow~n~~w~/wezprace", 3500, 3);
   					}
				}
				else if(PlayerToPoint(1.0, i,DrugJob[BuyDrugsX],DrugJob[BuyDrugsY],DrugJob[BuyDrugsZ]))
				{
				    if(GetPlayerVirtualWorld(i) == DrugJob[BuyDrugsWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Sklad narkotykow~n~~w~/nkup", 3500, 3);
   					}
				}
    			else if(PlayerToPoint(1.0, i,DrugJob[DeliverX],DrugJob[DeliverY],DrugJob[DeliverZ]))
				{
				    if(GetPlayerVirtualWorld(i) == DrugJob[DeliverWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Sklad narkotykow~n~~w~/ndostarcz", 3500, 3);
   					}
				}
				else if(PlayerToPoint(1.0, i,DetectiveJobPosition[X],DetectiveJobPosition[Y],DetectiveJobPosition[Z]))
				{
				    if(GetPlayerVirtualWorld(i) == DetectiveJobPosition[World])
				    {
   						GameTextForPlayer(i, "~n~~r~Praca detektywa~n~~w~/wezprace", 3500, 3);
   					}
				}
    			else if(PlayerToPoint(1.0, i,LawyerJobPosition[X],LawyerJobPosition[Y],LawyerJobPosition[Z]))
				{
				    if(GetPlayerVirtualWorld(i) == LawyerJobPosition[World])
				    {
   						GameTextForPlayer(i, "~n~~r~Praca adwokata~n~~w~/wezprace", 3500, 3);
   					}
				}
				//=============================================================================================================
			}
		}
	}
	return 1;
}
public FuelTimer()
{
	//=============================================[TAKING FUEL FROM CARS WITH PLAYERS IN THEM]=================================
	for(new i=0;i<MAX_PLAYERS;i++)
	{
    	if(IsPlayerConnected(i))
       	{
       	    if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
       	    {
	       		new vehicle = GetPlayerVehicleID(i);
	        	if(Fuel[vehicle] >= 1) //Fuel wont be taken unless the engine is on.
		   		{
		   		    if(EngineStatus[vehicle])
		   		    {
	              		Fuel[vehicle]--;
	              		if(IsAPlane(vehicle)) { Fuel[vehicle]++; }
	              	}
		   		}
	   			else
	           	{
					OutOfFuel[i] = 1;
		        	GameTextForPlayer(i,"~r~Nie masz paliwa!",1500,3);
		        	TogglePlayerControllable(i,0);
				}
			}
		}
     }
     //======================================================================================================================
	//===========================================[TAKING FUEL FROM UNOCCUPIED CARS WITH ENGINE ON]======================================
 	for(new c=0;c<MAX_VEHICLES;c++)
	{
	    if(EngineStatus[c])
	    {
	        if(IsVehicleOccupied(c) == 0) //Will only take fuel if the car is unoccupied.
	        {
		        if(Fuel[c] >= 1)
		        {
		        	Fuel[c]--;
		        }
	        }
	    }
	}
	//=======================================================================================================================
	return 1;
}
public IsAtGasStation(playerid)
{
    if(IsPlayerConnected(playerid))
	{
		if(PlayerToPoint(6.0,playerid,1004.0070,-939.3102,42.1797) || PlayerToPoint(6.0,playerid,1944.3260,-1772.9254,13.3906))
		{//LS
		    return 1;
		}
		else if(PlayerToPoint(6.0,playerid,-90.5515,-1169.4578,2.4079) || PlayerToPoint(6.0,playerid,-1609.7958,-2718.2048,48.5391))
		{//LS
		    return 1;
		}
		else if(PlayerToPoint(6.0,playerid,-2029.4968,156.4366,28.9498) || PlayerToPoint(8.0,playerid,-2408.7590,976.0934,45.4175))
		{//SF
		    return 1;
		}
		else if(PlayerToPoint(5.0,playerid,-2243.9629,-2560.6477,31.8841) || PlayerToPoint(8.0,playerid,-1676.6323,414.0262,6.9484))
		{//Between LS and SF
		    return 1;
		}
		else if(PlayerToPoint(6.0,playerid,2202.2349,2474.3494,10.5258) || PlayerToPoint(10.0,playerid,614.9333,1689.7418,6.6968))
		{//LV
		    return 1;
		}
		else if(PlayerToPoint(8.0,playerid,-1328.8250,2677.2173,49.7665) || PlayerToPoint(6.0,playerid,70.3882,1218.6783,18.5165))
		{//LV
		    return 1;
		}
		else if(PlayerToPoint(8.0,playerid,2113.7390,920.1079,10.5255) || PlayerToPoint(6.0,playerid,-1327.7218,2678.8723,50.0625))
		{//LV
		    return 1;
		}
	}
	return 0;
}
public RemoveDriverFromVehicle(playerid) //This function will be used to avoid issue when removing players from vehicle and them being froze.
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		RemovePlayerFromVehicle(playerid);
		TogglePlayerControllable(playerid,1);
		return 1;
	}
	return 0;
}
//====================================================[ACTION MESSAGES]================================================
public PlayerLocalMessage(playerid,Float:radius,message[])
{
	//This is for messages like "Blah has crashed"
	new string[128];
	format(string, sizeof(string), "[LOCAL:] %s %s", GetPlayerNameEx(playerid), message);
	ProxDetector(20.0, playerid, string, COLOR_LOCALMSG,COLOR_LOCALMSG,COLOR_LOCALMSG,COLOR_LOCALMSG,COLOR_LOCALMSG);
	PlayerLocalLog(string);
	return 1;
}
public PlayerActionMessage(playerid,Float:radius,message[])
{
	//This is for messages like "Blah has opened the door".
	new string[128];
	format(string, sizeof(string), "[ACTION:] %s %s", GetPlayerNameEx(playerid), message);
	ProxDetector(20.0, playerid, string, COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE);
	PlayerActionLog(string);
	return 1;
}
public PlayerPlayerActionMessage(playerid,targetid,Float:radius,message[])
{
	//This is for messages like "Blah has opened the door for Steve".
	new string[128];
	format(string, sizeof(string), "[ACTION:] %s %s %s.", GetPlayerNameEx(playerid), message,GetPlayerNameEx(targetid));
	ProxDetector(20.0, playerid, string, COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE,COLOR_LIGHTBLUE);
	PlayerActionLog(string);
	return 1;
}
//======================================================================================================================

//================================================[VEHICLE CHECK FUNCTIONS]==============================================
public IsVehicleOccupied(vehicleid)
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		if(IsPlayerInVehicle(i,vehicleid)) return 1;
	}
	return 0;
}
public IsAPlane(vehicleid)
{   new model = GetVehicleModel(vehicleid);
	if(model == 592 || model == 577 || model == 511 || model == 512 || model == 593 || model == 520 || model == 553 || model == 476 || model == 519 || model == 460 || model == 513)
	{
		return 1;
	}
	return 0;
}
public IsAHelicopter(vehicleid)
{   new model = GetVehicleModel(vehicleid);
	if(model == 548 || model == 525 || model == 417 || model == 487 || model == 488 || model == 497 || model == 563 || model == 447 || model == 469)
	{
		return 1;
	}
	return 0;
}
public IsABike(vehicleid)
{   new model = GetVehicleModel(vehicleid);
	if(model == 581 || model == 509 || model == 481 || model == 462 || model == 521 || model == 463 || model == 510 || model == 522 || model == 461 || model == 448 || model == 471 || model == 468 || model == 586)
	{
		return 1;
	}
	return 0;
}
//=======================================================================================================================

//==============================================[INT/OTHER FUNCTIONS]====================================================
stock HexToInt(string[]) {
  if (string[0]==0) return 0;
  new i;
  new cur=1;
  new res=0;
  for (i=strlen(string);i>0;i--) {
    if (string[i-1]<58) res=res+cur*(string[i-1]-48); else res=res+cur*(string[i-1]-65+10);
    cur=cur*16;
  }
  return res;
}
//========================================================================================================================
public AddsOn()
{
	adds=1;
	return 1;
}
//======================================================[LOGS]=============================================================
public PayLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/pay.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public HackLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/hack.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public KickLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/kick.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public AccountBanLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/accountban.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public BanLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/ban.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public PlayerActionLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/playeraction.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public PlayerLocalLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/playerlocal.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public TalkLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/talk.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}

public FactionChatLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/factionchat.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public SMSLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/sms.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public PMLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/pm.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public DonatorLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/donator.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public ReportLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/report.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
public OOCLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\r\n",string);
	new File:hFile;
	hFile = fopen("CRP_Scriptfiles/Logs/ooc.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
//============================================================================================================================
public AdministratorMessage(color,const string[],level)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if (PlayerInfo[i][pAdmin] >= level)
			{
			    if(AdminDuty[i] == 1)
			    {
					SendClientMessage(i, color, string);
				}
			}
		}
	}
	return 1;
}
public HangupTimer(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE)
		{
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
			return 1;
		}
	}
	return 0;
}
stock PlayerName(playerid) {
  new name[24];
  GetPlayerName(playerid, name, 24);
  return name;
}
public IsACopSkin(skinid)
{
	if(skinid == 280 || skinid == 281 || skinid == 282 || skinid == 283 || skinid == 288 || skinid == 284 || skinid == 285 || skinid == 286 || skinid == 287)
	{
		return 1;
	}
	return 0;
}
public JailTimer()
{
	new string[128];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(PlayerInfo[i][pJailed] == 1)
	    {
	    	if(PlayerInfo[i][pJailTime] != 0)
	    	{
				PlayerInfo[i][pJailTime]--;
				format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~w~Pozostalo: ~g~%d sekund.",PlayerInfo[i][pJailTime]);
   				GameTextForPlayer(i, string, 999, 3);
			}
			if(PlayerInfo[i][pJailTime] == 0)
			{
			    PlayerInfo[i][pJailed] = 0;
				SendClientMessage(i, COLOR_LIGHTBLUE2,"[INFO:] Wolnoœæ!");
				SetPlayerVirtualWorld(i,2);
			    SetPlayerInterior(i, 6);
				SetPlayerPos(i,268.0903,77.6489,1001.0391);
			}
		}
	}
	return 1;
}
public PhoneAnimation(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
		SetTimerEx("HangupTimer", 1000, false, "i", playerid);
		return 1;
	}
	return 0;
}
public DrugEffect(playerid)
{
	SendClientMessage(playerid,COLOR_LIGHTBLUE2,"[INFO:] Jesteœ pod wp³ywem...!");
 	SetPlayerWeather(playerid, 500);
    ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1,1,1,1,1,1);
    SetTimerEx("UndrugEffect", 8000, false, "i", playerid);
	return 1;
}
public UndrugEffect(playerid)
{
	SendClientMessage(playerid,COLOR_LIGHTBLUE2,"[INFO:] Nie jesteœ juz pod wp³ywem narkotyków :(");
 	SetPlayerWeather(playerid, 0);
	DrugsIntake[playerid] = 0;
	return 1;
}
stock IsValidSkin(skinid)
{
    #define	MAX_BAD_SKINS 22
    new badSkins[MAX_BAD_SKINS] =
    {
        3, 4, 5, 6, 8, 42, 65, 74, 86,
        119, 149, 208, 265, 266, 267,
        268, 269, 270, 271, 272, 273, 289
    };
    if (skinid < 0 || skinid > 299) return false;
    for (new i = 0; i < MAX_BAD_SKINS; i++)
    {
        if (skinid == badSkins[i]) return false;
    }
    #undef MAX_BAD_SKINS
    return 1;
}
public GetClosestPlayer(p1)
{
	new x,Float:dis,Float:dis2,player;
	player = -1;
	dis = 99999.99;
	for (x=0;x<MAX_PLAYERS;x++)
	{
		if(IsPlayerConnected(x))
		{
			if(x != p1)
			{
				dis2 = GetDistanceBetweenPlayers(x,p1);
				if(dis2 < dis && dis2 != -1.00)
				{
					dis = dis2;
					player = x;
				}
			}
		}
	}
	return player;
}
public Float:GetDistanceBetweenPlayers(p1,p2)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
	{
		return -1.00;
	}
	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}
public ResetPlayerWantedLevelEx(playerid)
{
  	SetPlayerWantedLevel(playerid, 0);
	WantedLevel[playerid] = 0;
	return 1;
}
public SetPlayerWantedLevelEx(playerid,level)
{
  	SetPlayerWantedLevel(playerid, level);
	WantedLevel[playerid] = level;
	return 1;
}
public GetPlayerWantedLevelEx(playerid)
{
	return WantedLevel[playerid];
}
public UntazePlayer(playerid)
{
	if(PlayerTazed[playerid] == 1)
	{
	    SendClientMessage(playerid,COLOR_LIGHTBLUE2,"[INFO:] You are now untazed.");
	    TogglePlayerControllable(playerid,1);
	    PlayerTazed[playerid] = 0;
	    PlayerActionMessage(playerid,15.0,"is now untazed.");
	}
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if (newkeys & KEY_SECONDARY_ATTACK)
		{
	        if(EngineStatus[GetPlayerVehicleID(playerid)] == 0)
			{
				RemoveDriverFromVehicle(playerid);
			}
			if(OutOfFuel[playerid])
			{
				RemoveDriverFromVehicle(playerid);
				OutOfFuel[playerid] = 0;
			}
		}
	}
	if(newkeys == KEY_SPRINT)
	{
	    cmd_wejdz(playerid, "");
	    cmd_wyjdz(playerid, "");
	}
	return 1;
}
public IsAtBar(playerid)
{
    if(IsPlayerConnected(playerid))
	{
		if(PlayerToPoint(4.0,playerid,495.7801,-76.0305,998.7578) || PlayerToPoint(4.0,playerid,499.9654,-20.2515,1000.6797))
		{//In grove street bar (with girlfriend), and in Havanna
		    return 1;
		}
		else if(PlayerToPoint(4.0,playerid,1215.9480,-13.3519,1000.9219) || PlayerToPoint(10.0,playerid,-2658.9749,1407.4136,906.2734))
		{//PIG Pen
		    return 1;
		}
	}
	return 0;
}
public ClearCheckpointsForPlayer(playerid)
{
	DisablePlayerCheckpoint(playerid);
	if(PlayerInfo[playerid][pJob] == 3)
	{
		if(TrackingPlayer[playerid])
		{
		    SendClientMessage(playerid,COLOR_LIGHTBLUE2,"[INFO:] You are no longer tracking a player.");
			TrackingPlayer[playerid] = 0;
		}
	}
	return 1;
}
//===========================================[PICKUP STREAMER]==========================================================

public CreateStreamPickup(model,type,Float:x,Float:y,Float:z,range)
{
	new FoundID = 0;
	new ID;

	for ( new i = 0; FoundID <= 0 ; i++)
	{
	    if( Pickup[i][pickupCreated] == 0 )
	    {
	        if( FoundID == 0 )
	        {
	     	   ID = i;
	     	   FoundID = 1;
	        }
	    }
	    if( i > MAX_PICKUPZ )
	    {
		    FoundID = 2;
		}
	}
	if( FoundID == 2 )
	{
	    print("Pickup limit reached! Pickup not created!");
	    return -1;
	}
	Pickup[ID][pickupCreated] = 1;
	Pickup[ID][pickupVisible] = 0;
	Pickup[ID][pickupModel] = model;
	Pickup[ID][pickupType] = type;
	Pickup[ID][pickupX] = x;
	Pickup[ID][pickupY] = y;
	Pickup[ID][pickupZ] = z;
	Pickup[ID][pickupRange] = range;
	return ID;

}
public DestroyStreamPickup(ID)
{
	if(Pickup[ID][pickupCreated])
	{
		DestroyPickup(Pickup[ID][pickupID]);
		Pickup[ID][pickupCreated] = 0;
		return 1;
	}
	return 0;
}
public CountStreamPickups()
{
	new count = 0;
	for(new i = 0; i < MAX_PICKUPZ; i++)
	{
	    if(Pickup[i][pickupCreated] == 1)
	    {
			count++;
	    }
	}
	return count;
}
public StreamPickups()
{
	for(new i = 0; i < MAX_PICKUPZ; i++)
	{
	    if(Pickup[i][pickupCreated] == 1)
	    {
			if(Pickup_AnyPlayerToPoint(Pickup[i][pickupRange],Pickup[i][pickupX],Pickup[i][pickupY],Pickup[i][pickupZ]))
			{
			    if(Pickup[i][pickupVisible] == 0)
			    {
			        Pickup[i][pickupID] = CreatePickup(Pickup[i][pickupModel],Pickup[i][pickupType],Pickup[i][pickupX],Pickup[i][pickupY],Pickup[i][pickupZ]);
			        Pickup[i][pickupVisible] = 1;
				}
			}
			else
			{
			    if(Pickup[i][pickupVisible] == 1)
			    {
			        DestroyPickup(Pickup[i][pickupID]);
					Pickup[i][pickupVisible] = 0;
			    }
			}
	    }
	}
}
public MoveStreamPickup(ID,Float:x,Float:y,Float:z)
{
	if(Pickup[ID][pickupCreated])
	{
	    DestroyPickup(Pickup[ID][pickupID]);
	    Pickup[ID][pickupVisible] = 0;
		Pickup[ID][pickupX] = x;
		Pickup[ID][pickupY] = y;
		Pickup[ID][pickupZ] = z;
		return 1;
	}
	return 0;
}
public ChangeStreamPickupModel(ID,newmodel)
{
    if(Pickup[ID][pickupCreated])
	{
	    DestroyPickup(Pickup[ID][pickupID]);
	    Pickup[ID][pickupVisible] = 0;
		Pickup[ID][pickupModel] = newmodel;
		return 1;
	}
	return 0;
}
public ChangeStreamPickupType(ID,newtype)
{
    if(Pickup[ID][pickupCreated])
	{
	    DestroyPickup(Pickup[ID][pickupID]);
	    Pickup[ID][pickupVisible] = 0;
		Pickup[ID][pickupType] = newtype;
		return 1;
	}
	return 0;
}
public Pickup_AnyPlayerToPoint(Float:radi, Float:x, Float:y, Float:z)
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
		{
			new Float:oldposx, Float:oldposy, Float:oldposz;
			new Float:tempposx, Float:tempposy, Float:tempposz;
			GetPlayerPos(i, oldposx, oldposy, oldposz);
			tempposx = (oldposx -x);
			tempposy = (oldposy -y);
			tempposz = (oldposz -z);
			if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
			{
				return 1;
			}
		}
	}
    return 0;
}
//===================================================================================================================================================
public GameModeRestart()
{
	new string[128];
	format(string, sizeof(string), "Game Mode Restarting.");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			DisablePlayerCheckpoint(i);
			GameTextForPlayer(i, string, 4000, 5);
			SetPlayerCameraPos(i,1460.0, -1324.0, 287.2);
			SetPlayerCameraLookAt(i,1374.5, -1291.1, 239.0);
			OnPlayerDataSave(i);
			gPlayerLogged[i] = 0;
		}
	}
	SetTimer("GameModeRestartFunction", 4000, 0);
 	SaveDynamicFactions();
	SaveCivilianSpawn();
	SaveFactionMaterialsStorage();
	SaveFactionDrugsStorage();
	SaveDrivingTestPosition();
	SaveFlyingTestPosition();
	SaveBankPosition();
	SaveWeaponLicensePosition();
	SavePoliceArrestPosition();
	SavePoliceDutyPosition();
	SaveGunJob();
	SaveDrugJob();
	SaveDetectiveJob();
	SaveLawyerJob();
	SaveProductsSellerJob();
	return 1;
}
public GameModeRestartFunction()
{
	GameModeExit();
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case rejestracja:
		{
		    switch(response)
		    {
		        case 0:
		        {
		            KickPlayer(playerid, "System", "nie podanie has³a przy rejestracji");
				}
				case 1:
				{
				    OnPlayerRegister(playerid, inputtext);
				}
			}
		}
		case logowanie:
		{
		    switch(response)
		    {
		        case 0:
		        {
		            KickPlayer(playerid, "System", "nie podanie has³a przy rejestracji");
				}
				case 1:
				{
				    OnPlayerLogin(playerid, inputtext);
				}
			}
		}
		case wiek:
		{
		    switch(response)
		    {
		        case 0:
		        {
		            KickPlayer(playerid, "System", "nie podanie wieku postaci (IC)");
				}
				case 1:
				{
				    if(!IsNumeric(inputtext))
				        return ShowPlayerDialog(playerid, wiek, DIALOG_STYLE_INPUT, "Wyst¹pi³ b³¹d!", "Wiek to liczba a nie zwyk³e litery!!!\nPodaj jeszcze raz wiek postaci", "Dalej", "Anuluj");
				        
					if(strlen(inputtext) < 0 || strlen(inputtext) > 2)
					    return ShowPlayerDialog(playerid, wiek, DIALOG_STYLE_INPUT, "Wyst¹pi³ b³¹d!", "Wiek mo¿esz podaæ w przedziale 1-99\nPodaj jeszcze raz wiek postaci", "Dalej", "Anuluj");

                    PlayerInfo[playerid][pAge] = strval(inputtext);
					PlayerInfo[playerid][pRegistered] = 2;
					ShowPlayerDialog(playerid, plec, DIALOG_STYLE_LIST, "Jakiej p³ci jest Twoja postaæ? (IC)", "Mê¿czyzna\nKobieta", "Wybierz", "Anuluj");
				}
			}
		}
		case plec:
		{
		    switch(response)
		    {
		        case 0:
		        {
		            KickPlayer(playerid, "System", "nie podanie wieku postaci (IC)");
				}
				case 1:
				{
					switch(listitem)
					{
					    case 0:
					    {
                            PlayerInfo[playerid][pSex] = 1;
						}
						case 1:
					    {
                            PlayerInfo[playerid][pSex] = 2;
						}
					}
				}
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
					ShowPlayerDialog(playerid, ppanel2, DIALOG_STYLE_LIST, "Co chcesz zrobiæ?", "Zmiania koloru pierwszego($500)\nZmiana koloru drugiego($500)\nZaparkowanie pojazdu($100)\nRespawn pojazdu($100)\nTeleport do pojazdu($50)\nPrzywo³anie pojazdu($300)\nSprzeda¿ pojazdu", "Wybierz", "Anuluj");
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
		                    ShowPlayerDialog(playerid, kolorpierwszy, DIALOG_STYLE_INPUT, "Kolor pierwszy", "Podaj id koloru pierwszego", "Zmieñ", "anuluj");
						}
						case 1:
						{
						    ShowPlayerDialog(playerid, kolorpierwszy, DIALOG_STYLE_INPUT, "Kolor drugi", "Podaj id koloru drugiego", "Zmieñ", "anuluj");
						}
						case 2:
						{
						    if(PlayerInfo[playerid][pCash] < 100)
					    		return SendClientMessage(playerid, COLOR_WHITE, "[Error:] Nie masz 100$!");
					    
						    GetVehiclePos(vehicleuid[playerid], DynamicCars[vehicleuid[playerid]][CarX], DynamicCars[vehicleuid[playerid]][CarY], DynamicCars[vehicleuid[playerid]][CarZ]);
						    GetVehicleZAngle(vehicleuid[playerid], DynamicCars[vehicleuid[playerid]][CarAngle]);
						    SaveDynamicCars(vehicleuid[playerid]);
						    GivePlayerCash(playerid, -100);
						    SendClientMessage(playerid, COLOR_WHITE, "[Info:] Zaparkowa³eœ pojazd!");
						}
						case 3:
						{
						    if(PlayerInfo[playerid][pCash] < 100)
					    		return SendClientMessage(playerid, COLOR_WHITE, "[Error:] Nie masz 100$!");

						    SetVehiclePos(vehicleuid[playerid], DynamicCars[vehicleuid[playerid]][CarX], DynamicCars[vehicleuid[playerid]][CarY], DynamicCars[vehicleuid[playerid]][CarZ]);
						    SetVehicleZAngle(vehicleuid[playerid], DynamicCars[vehicleuid[playerid]][CarAngle]);
						    SendClientMessage(playerid, COLOR_WHITE, "[Info:] Pojazd zrespawnowany!");
						    GivePlayerCash(playerid, -100);
						}
						case 4:
						{
						    if(PlayerInfo[playerid][pCash] < 50)
					    		return SendClientMessage(playerid, COLOR_WHITE, "[Error:] Nie masz 50$!");

							new Float:vx, Float:vy, Float:vz;
							GetVehiclePos(vehicleuid[playerid], vx, vy, vz);
							SetPlayerPos(playerid, vx+1, vy+1, vz+2);
							GivePlayerCash(playerid, -50);
							SendClientMessage(playerid, COLOR_WHITE, "[Info:] Teleportowa³eœ siê do swojego pojazdu!");
						}
						case 5:
						{
						    if(PlayerInfo[playerid][pCash] < 300)
					    		return SendClientMessage(playerid, COLOR_WHITE, "[Error:] Nie masz 300$!");

                            new Float:vx, Float:vy, Float:vz, Float:va;
                            GetPlayerPos(playerid, vx, vy, vz);
                            GetPlayerFacingAngle(playerid, va);
                            SetVehiclePos(vehicleuid[playerid], vx+2, vy, vz);
                            SetVehicleZAngle(vehicleuid[playerid], va);
                            GivePlayerCash(playerid, -300);
                            SendClientMessage(playerid, COLOR_WHITE, "[Info:] Przeteleportowa³eœ swój pojazd do siebie!");
						}
						case 6:
						{
						    ShowPlayerDialog(playerid, pytaniepojazd, DIALOG_STYLE_MSGBOX, "Pytanie", "Czy na pewno chcesz sprzedaæ swój samochód?\nZostan¹ Ci zwrócone koszty kupna.", "Tak", "Nie");
						}
					}
				}
			}
		}
		case pytaniepojazd:
		{
		    switch(response)
		    {
		        case 1:
		        {
		            DynamicCars[vehicleuid[playerid]][CarType] = 3;
		            DynamicCars[vehicleuid[playerid]][OwnID] = 0;
					GivePlayerCash(playerid, DynamicCars[vehicleuid[playerid]][Cena]);
					SaveDynamicCars(vehicleuid[playerid]);
					SendClientMessage(playerid, COLOR_WHITE, "[Info:] Pojazd zosta³ wystawiony na sprzeda¿!");
				}
			}
		}
		case kolorpierwszy: 
		{
		    switch(response)
		    {
		        case 1:
		        {
		            if(strval(inputtext) < 0 || strval(inputtext) > 255)
		                return ShowPlayerDialog(playerid, kolorpierwszy, DIALOG_STYLE_INPUT, "Kolor pojazdu", "Podaj id koloru", "Zmieñ", "Anuluj");

					if(PlayerInfo[playerid][pCash] < 500)
					    return SendClientMessage(playerid, COLOR_WHITE, "[Error:] Nie masz 500$!");

                    PlayerInfo[playerid][pCash] -= 500;
                    DynamicCars[vehicleuid[playerid]][CarColor1] = strval(inputtext);
                    ChangeVehicleColor(vehicleuid[playerid], strval(inputtext), DynamicCars[vehicleuid[playerid]][CarColor2]);
					SaveDynamicCars(vehicleuid[playerid]);
					GivePlayerCash(playerid, -500);
					SendClientMessage(playerid, COLOR_WHITE, "[Info:] Zmieni³eœ kolor pojazdu!");
				}
			}
		}
		case kolordrugi:
		{
		    switch(response)
		    {
		        case 1:
		        {
		            if(strval(inputtext) < 0 || strval(inputtext) > 255)
		                return ShowPlayerDialog(playerid, kolorpierwszy, DIALOG_STYLE_INPUT, "Kolor pojazdu", "Podaj id koloru", "Zmieñ", "Anuluj");

					if(PlayerInfo[playerid][pCash] < 500)
					    return SendClientMessage(playerid, COLOR_WHITE, "[Error:] Nie masz 500$!");

                    PlayerInfo[playerid][pCash] -= 500;
                    DynamicCars[vehicleuid[playerid]][CarColor2] = strval(inputtext);
                    ChangeVehicleColor(vehicleuid[playerid], DynamicCars[vehicleuid[playerid]][CarColor1], strval(inputtext));
					SaveDynamicCars(vehicleuid[playerid]);
					GivePlayerCash(playerid, -500);
					SendClientMessage(playerid, COLOR_WHITE, "[Info:] Zmieni³eœ kolor pojazdu!");
				}
			}
		}
	}
	return 1;
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

CMD:acaradd(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return NU
		
	new Float:px, Float:py, Float:pz, Float:pa;
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, pa);
	format(tekst, sizeof(tekst), "insert into `vehicles` (`carx`, `cary`, `carz`, `carangle`) values ('%f', '%f', '%f', '%f')",
	px,
	py,
	pz,
	pa);
	mysql_query(tekst);
	new uid = mysql_insert_id();
	DynamicCars[uid][CarModel] = 410;
 	DynamicCars[uid][CarX] = px;
  	DynamicCars[uid][CarY] = py;
   	DynamicCars[uid][CarZ] = pz;
    DynamicCars[uid][CarAngle] = pa;
    DynamicCars[uid][CarColor1] = 0;
    DynamicCars[uid][CarColor2] = 1;
    DynamicCars[uid][FactionCar] = 0;
    DynamicCars[uid][CarType] = 0;
    DynamicCars[uid][Cena] = 0;
    DynamicCars[uid][OwnID] = 0;
    CreateVehicleFromDB(uid);
    mysql_free_result();
	SendClientMessage(playerid, COLOR_WHITE, "[INFO:] Doda³eœ nowy pojazd do bazy danych. Wpisz /avehcmd aby poznaæ komendy dostêpne w systemie pojazdów");
	return 1;
}

CMD:acarcolor(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
		return NU
		
	new kolor, kolor2;
	if(sscanf(params, "dd", kolor, kolor2))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[U¿ycie:] /acarcolor [id koloru] [id koloru2]");
	    
	if(kolor < 0 || kolor > 255 || kolor2 < 0 || kolor2 > 255)
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Kolor to liczba od 0-255");
	    
	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Musisz siedzieæ w pojeŸdzie!");
	    
	new uid = GetPlayerVehicleID(playerid);
	DynamicCars[uid][CarColor1] = kolor;
	DynamicCars[uid][CarColor2] = kolor2;
	ChangeVehicleColor(uid, kolor, kolor2);
	SaveDynamicCars(uid);
	return 1;
}

CMD:acarmodel(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
		return NU
		
    if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Musisz siedzieæ w pojeŸdzie!");

	new uid = GetPlayerVehicleID(playerid);
	
    new modelid;
	if(sscanf(params, "d", modelid))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[U¿ycie:] /acarmodel [id modelu]");

	if(modelid < 0 || modelid > 601)
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Z³e ID modelu!");
	    
    DynamicCars[uid][CarModel] = modelid;
    SaveDynamicCars(uid);
    DestroyVehicle(uid);
    CreateVehicleFromDB(uid);
    return 1;
}

CMD:acarpark(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
		return NU

    if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Musisz siedzieæ w pojeŸdzie!");

	new uid = GetPlayerVehicleID(playerid);
	new Float:px, Float:py, Float:pz, Float:pa;
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, pa);
	DynamicCars[uid][CarX] = px;
	DynamicCars[uid][CarY] = py;
	DynamicCars[uid][CarZ] = pz;
	DynamicCars[uid][CarAngle] = pa;
	SaveDynamicCars(uid);
	SendClientMessage(playerid, COLOR_LIGHTYELLOW, "Zaparkowany!");
    return 1;
}

CMD:acarfaction(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
		return NU

    if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Musisz siedzieæ w pojeŸdzie!");

	new uid = GetPlayerVehicleID(playerid);
	
	new idfrakcji;
	if(sscanf(params, "d", idfrakcji))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[U¿ycie:] /acarfaction [id frakcji]");
		
	format(tekst, sizeof(tekst), "select `id` from `factions` where `id`='%d'", idfrakcji);
	mysql_query(tekst);
	mysql_store_result();
	if(!mysql_num_rows())
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Nie ma takiej frakcji!");
	    
	mysql_free_result();
	DynamicCars[uid][FactionCar] = idfrakcji;
	DynamicCars[uid][CarType] = 2;
	SaveDynamicCars(uid);
	SendClientMessage(playerid, COLOR_LIGHTYELLOW, "Zapisano!");
    return 1;
}

CMD:acartype(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
		return NU

    if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Musisz siedzieæ w pojeŸdzie!");

	new uid = GetPlayerVehicleID(playerid);
	
	new typid;
	if(sscanf(params, "d", typid))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[U¿ycie:] /acartype [typ]");

	if(typid < 0 || typid > 4)
        return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Typ to liczba od 0-4");
        
    DynamicCars[uid][CarType] = typid;
    SaveDynamicCars(uid);
	SendClientMessage(playerid, COLOR_LIGHTYELLOW, "Zapisano!");
    return 1;
}

CMD:acargethere(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
		return NU
		
	new Float:gx, Float:gy, Float:gz;
	GetPlayerPos(playerid, gx, gy, gz);
	
	new vid;
	if(sscanf(params, "d", vid))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[U¿ycie:] /acargethere [id pojazdu]");
		
	SetVehiclePos(vid, gx, gy, gz);
	return 1;
}

CMD:acargoto(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
		return NU

	new Float:gx, Float:gy, Float:gz;
	
	if(!strval(params))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[U¿ycie:] /acargoto [id pojazdu]");
		
	GetVehiclePos(strval(params), gx, gy, gz);
	SetPlayerPos(playerid, gx, gy, gz+2);
	return 1;
}

CMD:acarprice(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
		return NU

    if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Musisz siedzieæ w pojeŸdzie!");

	new uid = GetPlayerVehicleID(playerid);

	if(DynamicCars[uid][CarType] != 3)
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Najpierw wystaw ten pojazd na sprzeda¿ - zmieñ jego typ na 3");

    new typid;
	if(sscanf(params, "d", typid))
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[U¿ycie:] /acarprice [iloœc gotówki]");

    if(typid < 0 || typid > 900000000)
        return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Bez przesady...");

    DynamicCars[uid][Cena] = typid;
    SaveDynamicCars(uid);
	SendClientMessage(playerid, COLOR_LIGHTYELLOW, "Zapisano!");
    return 1;
}

CMD:silnik(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Tylko kierowca moze odpaliæ silnik...");
        
    if(EngineStatus[GetPlayerVehicleID(playerid)] == 0)
	{
		TogglePlayerControllable(playerid,1);
		EngineStatus[GetPlayerVehicleID(playerid)] = 1;
		if(PlayerInfo[playerid][pSex] == 1)
		{
			PlayerActionMessage(playerid,15.0,"odpali³ silnik.");
		}
		else
		{
			PlayerActionMessage(playerid,15.0,"odpali³a silnik.");
		}
	}
	else
	{
		TogglePlayerControllable(playerid,0);
		EngineStatus[GetPlayerVehicleID(playerid)] = 0;
		if(PlayerInfo[playerid][pSex] == 1)
		{
			PlayerActionMessage(playerid,15.0,"zgasi³ silnik.");
		}
		else
		{
			PlayerActionMessage(playerid,15.0,"zgasi³a silnik.");
		}
	}
	return 1;
}

// -=-=-=-==-=-=-=-=-=-=-=-==-=-=-=-Komendy gracza - pojazdy =-==-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=

CMD:kuppojazd(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Musisz siedzieæ w pojeŸdzie!");

	new uid = GetPlayerVehicleID(playerid);
	
    if(DynamicCars[uid][CarType] != 3)
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Ten pojazd nie jest na sprzeda¿!");

	if(PlayerInfo[playerid][pCash] < DynamicCars[uid][Cena])
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Nie masz tyle pieniêdzy!");
	    
    DynamicCars[uid][OwnID] = PlayerInfo[playerid][pID];
    DynamicCars[uid][CarType] = 4; // prywatny
	GivePlayerCash(playerid, -DynamicCars[uid][Cena]);
    SaveDynamicCars(uid);
    SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Info:] Kupi³eœ pojazd, mo¿esz teraz wpisaæ /ppanel !");
    return 1;
}

CMD:ppanel(playerid, params[])
{
    listaP(playerid);
	return 1;
}

// -=-=-=-==-=-=-=-=-=-=-=-==-=-=-=-Spawn mapy =-==-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=
CMD:aspawnmapy(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU

	GetPlayerPos(playerid, CivilianSpawn[X], CivilianSpawn[Y], CivilianSpawn[Z]);
	GetPlayerFacingAngle(playerid, CivilianSpawn[Angle]);
	CivilianSpawn[World] = GetPlayerVirtualWorld(playerid);
	CivilianSpawn[Interior] = GetPlayerInterior(playerid);
	SaveCivilianSpawn();
	SendClientMessage(playerid, COLOR_ADMINCMD, "[Admin:] Ustawiono domyœlny spawn gracza w tym miejscu.");
	return 1;
}

// -=-=-=-==-=-=-=-=-=-=-=-==-=-=-=-Komendy admina - biznes =-==-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=
CMD:abgethere(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU
		
	if(!strval(params))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] /abtp /[id biznesu]");
	    
	new id = strval(params);
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
	format(tekst, sizeof(tekst), "[INFO:] Biznes o ID: %d przeniesiony.", id);
	SendClientMessage(playerid, COLOR_ADMINCMD, tekst);
	return 1;
}

CMD:abgoto(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU

	if(!strval(params))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] /abtp /[id biznesu]");

	new id = strval(params);
	SetPlayerPos(playerid,Businesses[id][EnterX],Businesses[id][EnterY],Businesses[id][EnterZ]);
	SetPlayerInterior(playerid,Businesses[id][EnterInterior]);
	SetPlayerVirtualWorld(playerid,Businesses[id][EnterWorld]);
	format(tekst, sizeof(tekst), "[INFO:] Teleportowa³eœ siê do biznesu o ID: %d.", id);
	SendClientMessage(playerid, COLOR_ADMINCMD, tekst);
	return 1;
}

CMD:abprodukty(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU
		
	new id, amount;
	if(sscanf(params, "dd", id, amount))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] /abprodukty [id] [iloœæ]");
	    
    Businesses[id][Products] = amount;
    format(tekst, sizeof tekst, "Biznes id %d otrzyma³ %d produktów.", id,amount);
	SendClientMessage(playerid, COLOR_ADMINCMD,tekst);
	SaveBusinesses();
	return 1;
}

CMD:abcena(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU

	new id, amount;
	if(sscanf(params, "dd", id, amount))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] /abceba [id] [cena]");

	if(amount < 0 || amount > 9000000)
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] Cena musi siê zmieœciæ w przedziale 0-9 mln");

 	Businesses[id][BizPrice] = amount;
	format(tekst, sizeof tekst, "Biznes id %d teraz kosztujê $%d.", id,amount);
	SendClientMessage(playerid, COLOR_ADMINCMD,tekst);
	SaveBusinesses();
	return 1;
}

CMD:abtypy(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU
		
	SendClientMessage(playerid, COLOR_LIGHTBLUE2,"[Typy biznesów:]");
    SendClientMessage(playerid, COLOR_ADMINCMD,BUSINESS_TYPES);
	SendClientMessage(playerid, COLOR_ADMINCMD,BUSINESS_TYPES2);
	return 1;
}

CMD:abtyp(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU

	new id, id2;
	if(sscanf(params, "dd", id, id2))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] /abtyp [id] [typ]");

    Businesses[id][BizType] = id2;
	format(tekst, sizeof tekst, "Biznes o id %d ma teraz typ nr %d.", id,id2);
	SendClientMessage(playerid, COLOR_ADMINCMD,tekst);
	SaveBusinesses();
	return 1;
}

CMD:abexit(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU

	if(!strval(params))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] /abexit /[id biznesu]");

	new id = strval(params);
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
	format(tekst, sizeof(tekst), "[INFO:] Ustawi³eœ biznesowi id %d now¹ lokacje wyjœcia.", id);
	SendClientMessage(playerid, COLOR_ADMINCMD, tekst);
	return 1;
}

CMD:abinty(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU
		
    SendClientMessage(playerid, COLOR_WHITE, "[USAGE:] /abusinessint [bizid] [id (1-33)]");
	SendClientMessage(playerid, COLOR_LIGHTBLUE2, "[INTS:] 1: Marcos Bistro (Eat) - 2: Big Spread Ranch (Bar) - 3: Burger Shot (Eat) - 4: Cluckin Bell (EAT)");
	SendClientMessage(playerid, COLOR_LIGHTBLUE2, "[INTS:] 5: Well Stacked Pizza (Eat) - 6: Rusty Browns Dohnuts (Eat) - 7: Jays Diner (Eat) - 8: Pump Truck Stop Diner (Eat)");
	SendClientMessage(playerid, COLOR_LIGHTBLUE2, "[INTS:] 9: Alhambra (Drink) - 10: Mistys (Drink) - 11: Lil' Probe Inn (Drink) - 12: Exclusive (Clothes) - 13: Binco (Clothes)");
	SendClientMessage(playerid, COLOR_LIGHTBLUE2, "[INTS:] 14: ProLaps (Clothes) - 15: SubUrban (Clothes) - 16: Victim (Clothes) - 17: Zip (Clothes) - 18: Redsands Casino");
	SendClientMessage(playerid, COLOR_LIGHTBLUE2, "[INTS:] 19: Off Track Betting - 20: Sex Shop - 21: Zeros RC Shop - 22-25: Ammunations (Gun) - 26: Ammu Shooting Range (DONT USE)");
	SendClientMessage(playerid, COLOR_LIGHTBLUE2, "[INTS:] 27: Jizzys (Drink) - 27-33: 24-7's (Buy)");
	return 1;
}

CMD:abint(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU

    new id, id2;
	if(sscanf(params, "dd", id, id2))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] /abint [id] [id int]");

    if(id2 == 1)
	{
		Businesses[id][ExitX] = 794.8064;
		Businesses[id][ExitY] = 491.6866;
		Businesses[id][ExitZ] = 1376.195;
		Businesses[id][ExitInterior] = 1;
	}
	else if(id2 == 2)
	{
		Businesses[id][ExitX] = 1212.019897;
		Businesses[id][ExitY] = -28.663099;
		Businesses[id][ExitZ] = 1001.089966;
		Businesses[id][ExitInterior] = 3;
	}
	else if(id2 == 3)
	{
		Businesses[id][ExitX] = 366.923980;
		Businesses[id][ExitY] = -72.929359;
		Businesses[id][ExitZ] = 1001.507812;
		Businesses[id][ExitInterior] = 10;
	}
	else if(id2 == 4)
	{
		Businesses[id][ExitX] = 365.672974;
		Businesses[id][ExitY] = -10.713200;
		Businesses[id][ExitZ] = 1001.869995;
		Businesses[id][ExitInterior] = 9;
	}
	else if(id2 == 5)
	{
		Businesses[id][ExitX] = 372.351990;
		Businesses[id][ExitY] = -131.650986;
		Businesses[id][ExitZ] = 1001.449951;
		Businesses[id][ExitInterior] = 5;
	}
	else if(id2 == 6)
	{
		Businesses[id][ExitX] = 377.098999;
		Businesses[id][ExitY] = -192.439987;
		Businesses[id][ExitZ] = 1000.643982;
		Businesses[id][ExitInterior] = 17;
	}
	else if(id2 == 7)
	{
		Businesses[id][ExitX] = 460.099976;
		Businesses[id][ExitY] = -88.428497;
		Businesses[id][ExitZ] = 999.621948;
		Businesses[id][ExitInterior] = 4;
	}
	else if(id2 == 8)
	{
		Businesses[id][ExitX] = 681.474976;
		Businesses[id][ExitY] = -451.150970;
		Businesses[id][ExitZ] = -25.616798;
		Businesses[id][ExitInterior] = 1;
	}
	else if(id2 == 9)
	{
		Businesses[id][ExitX] = 476.068328;
		Businesses[id][ExitY] = -14.893922;
		Businesses[id][ExitZ] = 1003.695312;
		Businesses[id][ExitInterior] = 17;
	}
	else if(id2 == 10)
	{
		Businesses[id][ExitX] = 501.980988;
		Businesses[id][ExitY] = -69.150200;
		Businesses[id][ExitZ] = 998.834961;
		Businesses[id][ExitInterior] = 11;
	}
	else if(id2 == 11)
	{
		Businesses[id][ExitX] = -227.028000;
		Businesses[id][ExitY] = 1401.229980;
		Businesses[id][ExitZ] = 27.769798;
		Businesses[id][ExitInterior] = 18;
	}
	else if(id2 == 12)
	{
		Businesses[id][ExitX] = 204.332993;
		Businesses[id][ExitY] = -166.694992;
		Businesses[id][ExitZ] = 1000.578979;
		Businesses[id][ExitInterior] = 14;
	}
	else if(id2 == 13)
	{
		Businesses[id][ExitX] = 207.737991;
		Businesses[id][ExitY] = -109.019997;
		Businesses[id][ExitZ] = 1005.269958;
		Businesses[id][ExitInterior] = 15;
	}
	else if(id2 == 14)
	{
		Businesses[id][ExitX] = 207.054993;
		Businesses[id][ExitY] = -138.804993;
		Businesses[id][ExitZ] = 1003.519958;
		Businesses[id][ExitInterior] = 3;
	}
	else if(id2 == 15)
	{
		Businesses[id][ExitX] = 203.778000;
		Businesses[id][ExitY] = -48.492397;
		Businesses[id][ExitZ] = 1001.799988;
		Businesses[id][ExitInterior] = 1;
	}
	else if(id2 == 16)
	{
		Businesses[id][ExitX] = 226.293991;
		Businesses[id][ExitY] = -7.431530;
		Businesses[id][ExitZ] = 1002.259949;
		Businesses[id][ExitInterior] = 5;
	}
	else if(id2 == 17)
	{
		Businesses[id][ExitX] = 161.391006;
		Businesses[id][ExitY] = -93.159156;
		Businesses[id][ExitZ] = 1001.804687;
		Businesses[id][ExitInterior] = 18;
	}
	else if(id2 == 18)
	{
		Businesses[id][ExitX] = 1133.069946;
		Businesses[id][ExitY] = -9.573059;
		Businesses[id][ExitZ] = 1000.750000;
		Businesses[id][ExitInterior] = 12;
	}
	else if(id2 == 19)
	{
		Businesses[id][ExitX] = 833.818970;
		Businesses[id][ExitY] = 7.418000;
		Businesses[id][ExitZ] = 1004.179993;
		Businesses[id][ExitInterior] = 3;
	}
	else if(id2 == 20)
	{
		Businesses[id][ExitX] = -100.325996;
		Businesses[id][ExitY] = -22.816500;
		Businesses[id][ExitZ] = 1000.741943;
		Businesses[id][ExitInterior] = 3;
	}
	else if(id2 == 21)
	{
		Businesses[id][ExitX] = -2239.569824;
		Businesses[id][ExitY] = 130.020996;
		Businesses[id][ExitZ] = 1035.419922;
		Businesses[id][ExitInterior] = 6;
	}
	else if(id2 == 22)
	{
		Businesses[id][ExitX] = 286.148987;
		Businesses[id][ExitY] = -40.644398;
		Businesses[id][ExitZ] = 1001.569946;
		Businesses[id][ExitInterior] = 1;
	}
	else if(id2 == 23)
	{
		Businesses[id][ExitX] = 286.800995;
		Businesses[id][ExitY] = -82.547600;
		Businesses[id][ExitZ] = 1001.539978;
		Businesses[id][ExitInterior] = 4;
	}
	else if(id2 == 24)
	{
		Businesses[id][ExitX] = 296.919983;
		Businesses[id][ExitY] = -108.071999;
		Businesses[id][ExitZ] = 1001.569946;
		Businesses[id][ExitInterior] = 6;
	}
	else if(id2 == 25)
	{
		Businesses[id][ExitX] = 316.524994;
		Businesses[id][ExitY] = -167.706985;
		Businesses[id][ExitZ] = 999.661987;
		Businesses[id][ExitInterior] = 6;
	}
	else if(id2 == 26)
	{
		Businesses[id][ExitX] = 302.292877;
		Businesses[id][ExitY] = -143.139099;
		Businesses[id][ExitZ] = 1004.062500;
		Businesses[id][ExitInterior] = 7;
	}
	else if(id2 == 27)
	{
		Businesses[id][ExitX] = -2637.449951;
		Businesses[id][ExitY] = 1404.629883;
		Businesses[id][ExitZ] = 906.457947;
		Businesses[id][ExitInterior] = 3;
	}
	else if(id2 == 28)
	{
		Businesses[id][ExitX] = -25.884499;
		Businesses[id][ExitY] = -185.868988;
		Businesses[id][ExitZ] = 1003.549988;
		Businesses[id][ExitInterior] = 17;
	}
	else if(id2 == 29)
	{
		Businesses[id][ExitX] = 6.091180;
		Businesses[id][ExitY] = -29.271898;
		Businesses[id][ExitZ] = 1003.549988;
		Businesses[id][ExitInterior] = 10;
	}
	else if(id2 == 30)
	{
		Businesses[id][ExitX] = -30.946699;
		Businesses[id][ExitY] = -89.609596;
		Businesses[id][ExitZ] = 1003.549988;
		Businesses[id][ExitInterior] = 18;
	}
	else if(id2 == 31)
	{
		Businesses[id][ExitX] = -25.132599;
		Businesses[id][ExitY] = -139.066986;
		Businesses[id][ExitZ] = 1003.549988;
		Businesses[id][ExitInterior] = 16;
	}
	else if(id2 == 32)
	{
		Businesses[id][ExitX] = -27.312300;
		Businesses[id][ExitY] = -29.277599;
		Businesses[id][ExitZ] = 1003.549988;
		Businesses[id][ExitInterior] = 4;
	}
	else if(id2 == 33)
	{
		Businesses[id][ExitX] = -26.691599;
		Businesses[id][ExitY] = -55.714897;
		Businesses[id][ExitZ] = 1003.549988;
		Businesses[id][ExitInterior] = 6;
	}
	SaveBusinesses();
	return 1;
}

CMD:abnazwa(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU
		
	new id, nazwa[128];
	if(sscanf(params,"ds[128]", id, nazwa))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] /abnazwa [id] [nazwa]");
	    
	strmid(Businesses[id][BusinessName], nazwa, 0, strlen(nazwa), 128);
	format(tekst, sizeof(tekst), "[INFO:] Biznes ID %d ma teraz nazwê %s", id, nazwa);
	SendClientMessage(playerid, COLOR_ADMINCMD, tekst);
	SaveBusinesses();
	return 1;
}

CMD:absprzedaj(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
		return NU

    if(!strval(params))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Error:] /absprzedaj /[id biznesu]");

	new id = strval(params);
	Businesses[id][Locked] = 1;
	Businesses[id][Owned] = 0;
	strmid(Businesses[id][Owner], "None", 0, strlen("None"), 255);
	ChangeStreamPickupModel(Businesses[id][PickupID],1272);
	MoveStreamPickup(Businesses[id][PickupID],Businesses[id][EnterX], Businesses[id][EnterY], Businesses[id][EnterZ]);
	SaveBusinesses();
	format(tekst, sizeof(tekst), "[INFO:] Sprzeda³eœ biznes o ID: %d.", id);
	SendClientMessage(playerid, COLOR_ADMINCMD, tekst);
	return 1;
}
// -=-=-=-==-=-=-=-=-=-=-=-==-=-=-=-Spisy komend=-==-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=
CMD:acarcmd(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
		return NU
		
	new long_string[267];
	strcat(long_string, "/acaradd - Dodaje nowy pojazd do bazy danych\n/acarcolor - zmienia kolor pojazdu\n/acarmodel - zmienia model pojazdu\n/acarpark - zapisuje pozycje pojazdu\n/acarfaction - przypisuje pojazd do frakcji\n/acartype - zmienia typ pojazdu\n/acarprice - ustala cenê pojazdu");
	ShowPlayerDialog(playerid, 9001, DIALOG_STYLE_MSGBOX, "System pojazdów", long_string, "Zamknij", "");
	return 1;
}

// Zwyk³e CMD gracza

CMD:wejdz(playerid, params[])
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
					GameTextForPlayer(playerid, "~r~Zamkniety", 5000, 1);
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
						GameTextForPlayer(playerid, "~r~Nie masz tyle pieniedzy!", 5000, 1);
					}
				}
				else
				{
					GameTextForPlayer(playerid, "~r~Zamkniete", 5000, 1);
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
							GameTextForPlayer(playerid, "~r~Biznes zamkniety.", 5000, 1);
							return 1;
						}
						if(Businesses[i][Products] == 0)
						{
							GameTextForPlayer(playerid, "~r~Brak produktow.", 5000, 1);
							return 1;
						}
						GivePlayerCash(playerid,-Businesses[i][EntranceCost]);
						format(tekst, sizeof(tekst), "[INFO:] Zap³aci³eœ $%d za wejœcie do %s.", Businesses[i][EntranceCost],Businesses[i][BusinessName]);
						SendClientMessage(playerid,COLOR_LIGHTBLUE2,tekst);
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
						SendClientMessage(playerid,COLOR_LIGHTBLUE2,"[INFO:] Darmowe wejscie dla szefa.");
						SetPlayerInterior(playerid,Businesses[i][ExitInterior]);
						SetPlayerPos(playerid,Businesses[i][ExitX],Businesses[i][ExitY],Businesses[i][ExitZ]);
						SetPlayerVirtualWorld(playerid,i);
						SetPlayerFacingAngle(playerid,Businesses[i][ExitAngle]);
					}
				}
				else
				{
					SendClientMessage(playerid,COLOR_RED,"[ERROR:] Nie masz tyle pieniêdzy!");
				}
			}
		}
	}
	return 1;
}

CMD:wyjdz(playerid, params[])
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
					GameTextForPlayer(playerid, "~r~Drzwi zamkniete.", 5000, 1);
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
					GameTextForPlayer(playerid, "~r~Drzwi zamkniete.", 5000, 1);
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
					GameTextForPlayer(playerid, "~r~Drzwi zamkniete.", 5000, 1);
				}
			}
		}
	}
	return 1;
}

CMD:ogl(playerid, params[])
{
	return cmd_ogloszenie(playerid, params);
}

CMD:ogloszenie(playerid, params[])
{
	new ogl[128];
	if(sscanf(params, "s[128]", ogl))
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[U¿ycie:] /ogl(oszenie) [treœæ]");
	    
    for(new i = 0; i < sizeof(Businesses); i++)
	{
	    if(PlayerToPoint(25.0, playerid,Businesses[i][ExitX], Businesses[i][ExitY], Businesses[i][ExitZ]))
	    {
			if(GetPlayerVirtualWorld(playerid) == i)
			{
				if(Businesses[i][BizType] == 5)
				{
					if(Businesses[i][Products] != 0)
					{
						if ((adds))
						{
							new payout = strlen(ogl) * 25;
							if(GetPlayerCash(playerid) < payout)
							{
            					SendClientMessage(playerid, COLOR_RED, "[Error:] Nie masz tyle gotówki!");
							}
      						GivePlayerCash(playerid, - payout);
							Businesses[i][Till] += payout;
							Businesses[i][Products] --;
							format(tekst, sizeof(tekst), "--------------------------------------|%s|--------------------------------------",  Businesses[i][BusinessName]);
							SendClientMessageToAll(COLOR_GREEN,tekst);
							format(tekst, sizeof(tekst), "%s", ogl);
							SendClientMessageToAll(COLOR_WHITE,tekst);
							format(tekst, sizeof(tekst), "---- Nadawca: %s ---- Kontakt telefoniczny: %d ----", PlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
							SendClientMessageToAll(COLOR_WHITE,tekst);
							if(PlayerInfo[playerid][pAdmin] < 1){SetTimer("AddsOn", addtimer, 0);adds = 0;}
							format(tekst, sizeof(tekst), "-> Znaków: %d -> Ca³kowity koszt %d -> nadane dziêki %s - dziêkujemy i zapraszamy ponownie! :)", strlen(ogl), payout, Businesses[i][BusinessName]);
							SendClientMessageToAll(COLOR_WHITE,tekst);
							PlayerActionMessage(playerid,15.0,"podchodzi do tablicy po czym pisze og³oszenie");
							SaveBusinesses();
						}
						else
						{
						        SendClientMessage(playerid, COLOR_RED, "[Error:] Odczekaj chwilê czym nadasz kolejne ogloszenie.");
						}
					}
					else
					{
					    SendClientMessage(playerid, COLOR_RED, "[Error:] Ten biznes nie ma produktów!");
					}
				}
				else
				{
    				SendClientMessage(playerid, COLOR_RED, "[Error:] Nie jesteœ w biznesie typu og³oszenia.");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "[Error:] Twój VW musi byæ równy 1");
			}
		}
		else
		{
		    return SendClientMessage(playerid, COLOR_RED, "[Error:] Nie jesteœ w ¿adnym biznesie.");
		}
	}
	return 1;
}
// -=-=-=-==-=-=-=-=-=-=-=-==-=-=-=-Moje funkcje=-==-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=

forward listaP(playerid);
public listaP(playerid)
{
	new dgui[512];
	new query[32];
	new ile2 = 0;
	for(new i = 1; i <= ile; i++)
	{
		if(DynamicCars[i][OwnID] == PlayerInfo[playerid][pID] && DynamicCars[i][CarType] == 4)
		{
			format(query, sizeof(query), "%d - %s\n", DynamicCars[i][CarID], carname[DynamicCars[i][CarModel]-400]);
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

forward BankTD(playerid);
public BankTD(playerid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    format(tekst, sizeof(tekst), "$%d", PlayerInfo[playerid][pBank]);
	    TextDrawSetString(bank2[i], tekst);
	    TextDrawShowForPlayer(playerid, bank2[i]);
	}
	return 1;
}


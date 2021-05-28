/*
								Gamemode Eagle Serwer
								Autor: Thorus
								Data rozpoczêcia: 7.05.2013
*/
#include <a_samp> // podstawowy
#include <a_mysql> // baza danych
#include <sscanf2> // do rozdzielania tekstu
#include <zcmd> // system komend
#include <md5> // szyfrowanie has³a algorytmem md5
#include <time> // do czasu
#include <a_http>
#include <streamer>

// ------------ | Definicje gamemoda | ------------
#define HOST    "localhost" //nasz host
#define BAZA    "samp" //nasza baza danych
#define USER    "admin" //nazwa u¿ytkownika bazy danych
#define PASS    "admin" //has³o u¿ytkownika bazy danych
#define MAP     "Eagle Server [FC][PL]" // nazwa mapy
#define GAM     "ES-FC[PL]" // nazwa gamemoda
#define SER     "Eagle Server [PL][FC] BETA! Zapraszamy !" // nazwa serwera
#define WEB     "es.pl" // strona serwera

// ------------ | Definicje limitów itp | ------------
#undef MAX_PLAYERS
#define MAX_PLAYERS 2
#undef MAX_VEHICLES
#define MAX_VEHICLES    250

// ------------ | Definicje ID Dialogów | ------------
#define		REJ         1 // rejestracja
#define		LOG         2 // logowanie
#define     ZHAS        3 // zmiana has³a
#define     ZNI         4 // zmiana nicku
#define     CMDLISTA    5 // wyœwietla liste CMD
#define     STATY       6 
#define     VIP2        7 // informacja w /premium
#define     MCMD        8 // lista komend moderatora
#define     MCMD2       9 // -||-
#define     AINFO       10
#define     ACMD        11
#define     AVCMD       12
#define     VPANEL      13
#define     VNASK       14
#define     VNLCO       15
#define     VMASK       16
#define     VDOOR       17
#define     VENGINE     18
#define     VLIGHT      19
#define     VBONET      20
#define     VALARM      21
#define     LSKILL      22
#define     LINFO       23

// ------------ | Definicje kolorów | ------------
#define 	E   				0xf2ee80AA // error
#define     DO                  0xd9cc88EE // /do
#define 	ME 					0xC2A2DAAA // /me
#define 	COLOR_FADE1 		0xE6E6E6E6 // lokalny czat
#define 	COLOR_FADE2 		0xC8C8C8C8 // lokalny czat
#define 	COLOR_FADE3 		0xAAAAAAAA // lokalny czat
#define 	COLOR_FADE4 		0x8C8C8C8C // lokalny czat
#define 	COLOR_FADE5 		0x6E6E6E6E // lokalny czat
#define     B           		0xed2323AA // do warnów, kicków, banów etc
#define     CF                  0xe6c44eAA // do GUI
#define     WHITE               0xFFFFFFDD // po prostu bia³y -,-
#define     GC                  0x104ca6EE // Globalny czat
#define     PW               	0xacc7f0EE // Kolor prywatnych wiadomoœæi
#define     VIP                 0xa2fadaAA // kolor konta premium(VIP-a)
#define     I                   0xcaff87AA // kolor "informacja"
#define     ADMIN               0xffa26dAA // kolor admina

// ------------ | Reszta definicji | ------------
#define		ER					"[Error:] Nie jesteœ upowa¿niony do u¿ycia tej cmd!"

// ------------ | Zabezbieczenie dla GUI | ------------
#define A_CHAR(%0) for(new i = strlen(%0) - 1; i >= 0; i--)\
    if((%0)[i] == '%')\
        (%0)[i] = ('#')
        
// ------------ | Zmienne globalne | ------------
new query[256]; 
new fetch[1024]; 
new lczat = 1; 
new gczat = 1; 
new tekst[128]; 
new vNeon[MAX_VEHICLES][2];
// ------------ | TD | ------------
new Text:bank[MAX_PLAYERS];
new Text:news;
// ------------ | Enumy | ------------

enum gInfo
{
	gID,
	gLogin[24],
	gHaslo[256], // 256 poniewa¿ u¿ywam md5
	gAdmin,
	gPremium,
	gWarn,
	gBan,
	gMute,
	gKasa,
	gPoziom,
	gExp,
	gWexp,
	gZabojstw,
	gSmierci,
	gBank,
	gZalogowany,
	gPW,
	gPktdr,
	gPktr,
//  --- | Normalne skille | ---
	gSkill,
	gSkill1,
	gSkill2,
	gSkill3,
	gSkill4,
	gSkill5,
	gSkill6,
	gSkill7,
	gSkill8,
	gSkill9,
	gSkill10,
	gSkill11,
	gSkill12,
	gSkill13,
	gSkill14,
//  --- | Skille Premium | ---
	gPskill, // god mode
	gPskill1, // obrzyn
	gPskill2, // medyk
	gPskill3, // pistolet z t³umikiem
	gPskill4, // SPASI 12
	gPskill5, // Armor co 30 s + 10
	gPskill6, // Ammo co 30 s + 50
	gPskill7, // Szansa 1/14 max 1/4 ¿e ktoœ wybuchnie po strzale
	gPskill8, // Wy¿sze skoki z+1 co poziom
	gPskill9, // Cichy zabójca - 10 lvl daje natychmiastowe zabicie no¿em
};

new GraczInfo[MAX_PLAYERS][gInfo];

enum pInfo
{
	pID,
	pmodel,
	Float:x,
	Float:y,
	Float:z,
	Float:a,
	pkolor,
	pkolor1,
	ptyp,
	pfid,
	pidowner,
	pcena,
	pidp,
};

new PojazdInfo[MAX_VEHICLES][pInfo];

#if defined FILTERSCRIPT
#endif

public OnGameModeInit()
{
	EnableStuntBonusForAll(0);
	mysql_connect(HOST, USER, BAZA, PASS);
	if(mysql_ping() == 1)
	{
	    print("Jest polaczenie z baza danych!\n");
	}
	else
	{
	    print("Brak polaczenia z baza danych!\n");
	}
	new rcon[64];
	format(rcon, 64, "hostname %s", SER);
	SendRconCommand(rcon);
	format(rcon, 64, "mapname %s", MAP);
	SendRconCommand(rcon);
	format(rcon, 64, "gamemodetext %s", GAM);
	SendRconCommand(rcon);
	format(rcon, 64, "weburl %s", WEB);
	SendRconCommand(rcon);
	printf("Uruchomiono %s", SER);
	AddPlayerClass(0, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(1, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(2, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(3, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(4, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(5, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(6, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(7, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(8, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(9, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(10, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(11, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(12, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(13, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(14, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(15, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(16, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(17, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(18, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(19, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(20, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(21, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(22, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(23, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(24, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(25, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(26, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(27, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(28, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(29, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(30, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(31, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(32, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(33, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(34, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(35, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(36, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(37, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(38, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(39, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(40, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(41, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(42, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(43, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(44, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(45, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(46, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(47, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(48, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(49, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(50, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(51, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(52, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(53, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(54, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(55, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(56, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(57, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(58, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(59, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(60, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(61, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(62, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(63, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(64, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(65, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(66, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(67, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(68, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(69, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(70, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(71, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(72, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(73, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(74, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(75, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(76, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(77, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(78, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(79, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(80, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(81, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(82, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(83, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(84, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(85, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(86, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(87, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(88, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(89, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(90, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(91, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(92, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(93, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(94, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(95, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(96, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(97, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(98, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(99, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(100, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(101, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(102, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(103, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(104, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(105, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(106, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(107, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(108, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(109, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(110, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(111, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(112, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(113, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(114, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(115, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(116, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(117, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(118, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(119, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(120, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(121, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(122, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(123, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(124, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(125, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(126, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(127, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(128, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(129, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(130, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(131, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(132, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(133, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(134, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(135, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(136, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(137, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(138, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(139, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(140, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(141, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(142, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(143, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(144, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(145, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(146, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(147, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(148, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(149, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(150, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(151, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(152, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(153, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(154, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(155, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(156, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(157, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(158, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(159, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(160, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(161, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(162, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(163, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(164, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(165, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(166, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(167, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(168, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(169, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(170, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(171, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(172, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(173, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(174, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(175, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(176, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(177, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(178, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(179, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(180, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(181, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(182, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(183, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(184, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(185, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(186, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(187, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(188, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(189, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(190, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(191, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(192, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(193, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(194, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(195, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(196, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(197, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(198, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(199, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(200, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(201, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(202, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(203, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(204, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(205, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(206, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(207, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(208, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(209, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(210, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(211, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(212, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(213, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(214, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(215, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(216, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(217, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(218, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(219, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(220, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(221, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(222, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(223, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(224, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(225, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(226, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(227, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(228, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(229, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(230, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(231, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(232, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(233, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(234, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(235, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(236, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(237, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(238, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(239, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(240, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(241, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(242, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(243, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(244, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(245, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(246, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(247, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(248, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(249, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(250, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(251, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(252, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(253, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(254, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(255, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(256, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(257, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(258, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(259, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(260, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(261, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(262, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(263, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(264, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(265, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(266, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(267, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(268, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(269, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(270, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(271, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(272, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(273, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(274, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(275, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(276, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(277, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(278, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(279, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(280, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(281, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(282, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(283, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(284, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(285, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(286, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(287, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(288, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(289, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(290, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(291, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(292, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(293, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(294, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(295, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(296, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(297, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(298, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(299, -316.269409,1054.797973,19.742187, 0.0, 0, 0, 0, 0, 0, 0);
    AllowInteriorWeapons(1);
    DisableInteriorEnterExits();
    UsePlayerPedAnims();
    ShowPlayerMarkers(0);
    SetNameTagDrawDistance(3);
    WczytajPojazdy();
    // --- | TextDraw | ---
    news = TextDrawCreate(3, 445, " ");
    TextDrawUseBox(news, 1);
    TextDrawBackgroundColor(news, 0x000000DD);
    TextDrawBoxColor(news, 0x000000DD);
    TextDrawFont(news, 1);
    for(new i = 0; i <= MAX_PLAYERS; i++)
    {
        // informacja o kasie w banku
    	bank[i] = TextDrawCreate(495.5, 99, " ");
    	TextDrawFont(bank[i], 1);
    	TextDrawColor(bank[i], 0x85F0FFFF);
    	TextDrawLetterSize(bank[i], 0.6, 2.0);
		TextDrawSetProportional(bank[i], true);
    }
    for(new i; i < MAX_VEHICLES; i++)
		vNeon[i] = {-1, -1};
		
	return 1;
}

public OnGameModeExit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    TextDrawDestroy(bank[i]);
	}
	TextDrawDestroy(news);
    mysql_close();
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	return 1;
}

SetupPlayerForClassSelection(playerid)
{
    SetPlayerPos(playerid, -207.379425,1158.568359,19.742187);
	SetPlayerCameraPos(playerid, -204.9814, 1161.3182, 22.2313);
	SetPlayerCameraLookAt(playerid, -205.6461, 1160.5654, 21.7413);
	SetPlayerFacingAngle(playerid, -30.0);
	SetPlayerInterior(playerid, 0);
	return 1;
}

forward MyHttpResponse(index, response_code, data[]);
public MyHttpResponse(index, response_code, data[])
{
    // In this callback "index" would normally be called "playerid" ( if you didn't get it already :) )
    new
        buffer[ 128 ];
    if(response_code == 200) //Did the request succeed?
    {
        //Yes!
        format(buffer, sizeof(buffer), "The URL replied: %s", data);
        SendClientMessage(index, 0xFFFFFFFF, buffer);
    }
    else
    {
        //No!
        format(buffer, sizeof(buffer), "The request failed! The response code was: %d", response_code);
        SendClientMessage(index, 0xFFFFFFFF, buffer);
    }
}

public OnPlayerConnect(playerid)
{
    format(query, sizeof(query), "SELECT `id` FROM `gracze` Where `login`='%s'", PlayerName(playerid));
	mysql_query(query);
	mysql_store_result();
	if(mysql_num_rows())
	{
		ShowPlayerDialog(playerid, LOG, DIALOG_STYLE_PASSWORD, "Eagle Server - Panel logowania:", "Podaj swoje has³o:", "Zaloguj", "Anuluj");
	}
	else
	{
		ShowPlayerDialog(playerid, REJ, DIALOG_STYLE_PASSWORD, "Eagle Server - Panel rejestracji:", "Podaj swoje has³o:", "Zarejestruj", "Anuluj");
	}
	mysql_free_result(playerid);
	RemoveBuildingForPlayer(playerid, 1413, 75.0547, 1077.6875, 14.1250, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 75.7500, 1067.0469, 11.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 75.8516, 1041.6797, 13.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 75.9922, 1036.3828, 13.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 74.6484, 1082.9453, 14.1250, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 82.2344, 1028.6719, 13.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 78.3125, 1032.2031, 13.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 85.9844, 1024.9297, 13.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 16000, 110.8125, 1023.9922, 12.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 130.3828, 1029.3516, 13.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 134.8984, 1032.1250, 13.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 137.1328, 1036.2422, 13.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 94.9688, 1067.2031, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 108.9688, 1067.2031, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 96.8750, 1057.2188, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 98.6484, 1047.6563, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 91.3750, 1085.6719, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 105.3750, 1085.6719, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 100.1406, 1076.7891, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 107.1406, 1076.7891, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 112.3750, 1085.6719, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 115.9688, 1067.2031, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 110.8750, 1057.2188, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 112.6484, 1047.6563, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 121.1406, 1076.7891, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 128.1406, 1076.7891, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 122.9688, 1067.2031, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 124.8750, 1057.2188, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 119.6484, 1047.6563, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 139.7734, 1052.9609, 13.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 141.6797, 1071.9844, 13.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 141.0391, 1066.7500, 13.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 773, 159.5547, 1070.9688, 14.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 780, 160.7656, 1054.5078, 16.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 92.4141, 1099.5313, 12.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 79.3359, 1099.9453, 11.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 97.1172, 1107.4141, 13.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 97.2578, 1102.1172, 13.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 16001, 110.6172, 1109.5156, 12.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 141.7656, 1109.8828, 11.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 131.4766, 1109.2734, 12.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 16002, 172.8047, 1088.6250, 18.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 160.6875, 1106.7344, 13.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 147.9219, 1090.0625, 12.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 16003, 150.2344, 1105.5313, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 98.8359, 1115.2734, 13.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 96.7031, 1112.6719, 13.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 104.1250, 1115.0000, 13.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 109.3984, 1115.0000, 13.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 3362, 610.1641, 1550.0156, 3.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3363, 542.4609, 1558.6719, -0.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 3364, 708.9141, 1593.5156, 2.8984, 0.25);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	ZapiszGracza(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(GraczInfo[playerid][gZalogowany] == 1)
	{
	    GivePlayerMoney(playerid, GraczInfo[playerid][gKasa]);
	    SetPlayerScore(playerid, GetPlayerScore(playerid)+GraczInfo[playerid][gPoziom]);
	    if(GraczInfo[playerid][gPktdr] >= 1)
	    {
	        ListaSkilli(playerid);
		}
		switch(GraczInfo[playerid][gSkill])
		{
		    case 0:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 1);
			}
			case 2:
			{
			    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 9);
			}
			case 3:
			{
			    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 39);
			}
			case 4:
			{
			    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 59);
			}
			case 5:
			{
			    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 109);
			}
			case 6:
			{
			    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 199);
			}
			case 7:
			{
			    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 399);
			}
			case 8:
			{
			    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 499);
			}
			case 9:
			{
			    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 699);
			}
			case 10:
			{
			    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 999);
			}
			default: SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 1);
		}
		switch(GraczInfo[playerid][gSkill1])
		{
		    case 0:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 1);
			}
			case 1:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 9);
			}
			case 2:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 39);
			}
			case 3:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 59);
			}
			case 4:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 109);
			}
			case 5:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 199);
			}
			case 6:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 399);
			}
			case 7:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 499);
			}
			case 8:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 669);
			}
			case 9:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 799);
			}
			case 10:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
			}
			default: SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 1);
		}
		switch(GraczInfo[playerid][gSkill2])
		{
		    case 0:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 1);
			}
			case 1:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 19);
			}
			case 2:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 39);
			}
			case 3:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 49);
			}
			case 4:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 109);
			}
			case 5:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 199);
			}
			case 6:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 399);
			}
			case 7:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 499);
			}
			case 8:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 699);
			}
			case 9:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 799);
			}
			case 10:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
			}
			default: SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 1);
		}
		switch(GraczInfo[playerid][gSkill3])
		{
		    case 0:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);
			}
			case 1:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 19);
			}
			case 2:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 39);
			}
			case 3:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 59);
			}
			case 4:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 109);
			}
			case 5:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 199);
			}
			case 6:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 399);
			}
			case 7:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 499);
			}
			case 8:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 699);
			}
			case 9:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 799);
			}
			case 10:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 999);
			}
			default: SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);
		}
		switch(GraczInfo[playerid][gSkill4])
		{
		    case 0:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 1);
			}
			case 1:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 19);
			}
			case 2:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 39);
			}
			case 3:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 59);
			}
			case 4:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 109);
			}
			case 5:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 199);
			}
			case 6:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 399);
			}
			case 7:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 499);
			}
			case 8:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 699);
			}
			case 9:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 799);
			}
			case 10:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
			}
			default: SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 1);
		}
		switch(GraczInfo[playerid][gSkill5])
		{
		    case 0:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 1);
			}
			case 1:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 19);
			}
			case 2:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 39);
			}
			case 3:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 59);
			}
			case 4:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 109);
			}
			case 5:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 199);
			}
			case 6:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 399);
			}
			case 7:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 499);
			}
			case 8:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 699);
			}
			case 9:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 799);
			}
			case 10:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
			}
			default: SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 1);
		}
		switch(GraczInfo[playerid][gSkill6])
		{
		    case 0:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 1);
			}
			case 1:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 19);
			}
			case 2:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 39);
			}
			case 3:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 59);
			}
			case 4:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 109);
			}
			case 5:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 199);
			}
			case 6:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 399);
			}
			case 7:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 499);
			}
			case 8:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 699);
			}
			case 9:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 799);
			}
			case 10:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
			}
			default: SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 1);
		}
		switch(GraczInfo[playerid][gSkill7])
		{
		    case 0:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 1);
			}
			case 1:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 19);
			}
			case 2:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 39);
			}
			case 3:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 59);
			}
			case 4:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 109);
			}
			case 5:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 199);
			}
			case 6:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 399);
			}
			case 7:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 499);
			}
			case 8:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 699);
			}
			case 9:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 799);
			}
			case 10:
		    {
		        SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 999);
			}
			default: SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 1);
		}
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1);
		if(GraczInfo[playerid][gPremium] >= 1)
		{
  			switch(GraczInfo[playerid][gPskill1])
			{
		    	case 0:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
				}
				case 1:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
				}
				case 2:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
				}
				case 3:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
				}
				case 4:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
				}
				case 5:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
				}
				case 6:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 999);
				}
				case 7:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 999);
				}
				case 8:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 999);
				}
				case 9:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 999);
				}
				case 10:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 999);
				}
				default: SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
			}
			switch(GraczInfo[playerid][gPskill3])
			{
		    	case 0:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1);
				}
				case 1:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1);
				}
				case 2:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1);
				}
				case 3:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1);
				}
				case 4:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1);
				}
				case 5:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1);
				}
				case 6:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 999);
				}
				case 7:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 999);
				}
				case 8:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 999);
				}
				case 9:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 999);
				}
				case 10:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 999);
				}
				default: SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1);
			}
			switch(GraczInfo[playerid][gPskill4])
			{
		    	case 0:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
				}
				case 1:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
				}
				case 2:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
				}
				case 3:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
				}
				case 4:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
				}
				case 5:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
				}
				case 6:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
				}
				case 7:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
				}
				case 8:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
				}
				case 9:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
				}
				case 10:
		    	{
		        	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
				}
				default: SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
			}
		}
	}
	SetPlayerHealth(playerid, 100.0);
	TextDrawShowForPlayer(playerid, bank[playerid]);
	TextDrawShowForPlayer(playerid, news);
	SetTimerEx("BankTD", 1000, true, "d", playerid);
	SetPlayerColor(playerid, WHITE);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	GraczInfo[playerid][gSmierci] += 1;
	GraczInfo[killerid][gZabojstw] += 1;
	switch(reason)
	{
	    case 0:
	    {
    		GraczInfo[killerid][gExp] += 20;
    		GraczInfo[killerid][gBank] += 100;
    		if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 1:
		{
		    GraczInfo[killerid][gExp] += 15;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 2:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 3:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 4:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 5:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 6:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 7:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 8:
		{
		    GraczInfo[killerid][gExp] += 150;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 9:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 10:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 11:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 12:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 13:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 14:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 15:
		{
		    GraczInfo[killerid][gExp] += 12;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 16:
		{
		    GraczInfo[killerid][gExp] += 35;
		    GraczInfo[killerid][gBank] += 150;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 18:
		{
		    GraczInfo[killerid][gExp] += 35;
		    GraczInfo[killerid][gBank] += 150;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 22:
		{
		    GraczInfo[killerid][gExp] += 50;
		    GraczInfo[killerid][gBank] += 250;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 23:
		{
		    GraczInfo[killerid][gExp] += 23;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 24:
		{
		    GraczInfo[killerid][gExp] += 30;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 25:
		{
		    GraczInfo[killerid][gExp] += 25;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 26:
		{
		    GraczInfo[killerid][gExp] += 20;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 27:
		{
		    GraczInfo[killerid][gExp] += 28;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 28:
		{
		    GraczInfo[killerid][gExp] += 30;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 29:
		{
		    GraczInfo[killerid][gExp] += 42;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 30:
		{
		    GraczInfo[killerid][gExp] += 30;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 31:
		{
		    GraczInfo[killerid][gExp] += 32;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 32:
		{
		    GraczInfo[killerid][gExp] += 32;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 33:
		{
		    GraczInfo[killerid][gExp] += 42;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		case 34:
		{
		    GraczInfo[killerid][gExp] += 122;
		    GraczInfo[killerid][gBank] += 50;
		    if(GraczInfo[killerid][gPremium] >= 1)
    		{
                GraczInfo[killerid][gExp] += 100;
    			GraczInfo[killerid][gBank] += 500;
			}
		}
		
	}
	ZapiszGracza(playerid);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
    DestroyNeon(vehicleid);
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    DestroyNeon(vehicleid);
	return 1;
}

public OnPlayerText(playerid, text[])
{
    if (lczat)
	{
	    if(GraczInfo[playerid][gZalogowany] == 0)
	    {
	        SendClientMessage(playerid, E, "[Error:] Najpierw siê zaloguj!");
	        return 0;
      	}
      	if(GraczInfo[playerid][gMute] == 1)
	    {
	        SendClientMessage(playerid, E, "[Error:] Jesteœ uciszony!");
	        return 0;
      	}
    	new text1[256];
     	format(text1, sizeof(text1), "%s mówi: %s", PlayerName(playerid), text);
		PD(20.0, playerid, text1,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
		return 0;
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new uid = PojazdInfo[vehicleid][pID];
	switch(PojazdInfo[uid][ptyp])
	{
	    case 0:
	    {
	        SendClientMessage(playerid, I, "Publiczny");
		}
		case 1:
		{
		    SendClientMessage(playerid, I, "Frakcyjny");
		    RemovePlayerFromVehicle(playerid);
		}
		case 2:
		{
			SendClientMessage(playerid, I, "Na sprzeda¿");
		}
		case 3:
		{
			if(GraczInfo[playerid][gID] != PojazdInfo[uid][pidowner])
			{
			    SendClientMessage(playerid, I, "To nie twój pojazd");
			    RemovePlayerFromVehicle(playerid);
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

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
    new Float:ihp;
    GetPlayerHealth(playerid, ihp);
    if(issuerid != INVALID_PLAYER_ID)
    {
		switch(weaponid)
		{
		    case 0:
		    {
        		switch(GraczInfo[issuerid][gSkill13])
        		{
            		case 1:
            		{
                		SetPlayerHealth(playerid, ihp-1);
					}
					case 2:
            		{
                		SetPlayerHealth(playerid, ihp-2);
					}
					case 3:
            		{
                		SetPlayerHealth(playerid, ihp-3);
					}
					case 4:
            		{
               		 	SetPlayerHealth(playerid, ihp-4);
					}
					case 5:
            		{
                		SetPlayerHealth(playerid, ihp-5);
					}
					case 6:
            		{
                		SetPlayerHealth(playerid, ihp-6);
					}
					case 7:
            		{
                		SetPlayerHealth(playerid, ihp-7);
					}
					case 8:
            		{
                		SetPlayerHealth(playerid, ihp-8);
					}
					case 9:
            		{
                		SetPlayerHealth(playerid, ihp-9);
					}
					case 10:
            		{
                		SetPlayerHealth(playerid, ihp-10);
					}
				}
			}
		    case 5:
		    {
        		switch(GraczInfo[issuerid][gSkill10])
        		{
            		case 1:
            		{
                		SetPlayerHealth(playerid, ihp-1);
					}
					case 2:
            		{
                		SetPlayerHealth(playerid, ihp-2);
					}
					case 3:
            		{
                		SetPlayerHealth(playerid, ihp-3);
					}
					case 4:
            		{
               		 	SetPlayerHealth(playerid, ihp-4);
					}
					case 5:
            		{
                		SetPlayerHealth(playerid, ihp-5);
					}
					case 6:
            		{
                		SetPlayerHealth(playerid, ihp-6);
					}
					case 7:
            		{
                		SetPlayerHealth(playerid, ihp-7);
					}
					case 8:
            		{
                		SetPlayerHealth(playerid, ihp-8);
					}
					case 9:
            		{
                		SetPlayerHealth(playerid, ihp-9);
					}
					case 10:
            		{
                		SetPlayerHealth(playerid, ihp-10);
					}
				}
			}
		    case 8:
		    {
        		switch(GraczInfo[issuerid][gSkill9])
        		{
            		case 1:
            		{
                		SetPlayerHealth(playerid, ihp-1);
					}
					case 2:
            		{
                		SetPlayerHealth(playerid, ihp-2);
					}
					case 3:
            		{
                		SetPlayerHealth(playerid, ihp-3);
					}
					case 4:
            		{
               		 	SetPlayerHealth(playerid, ihp-4);
					}
					case 5:
            		{
                		SetPlayerHealth(playerid, ihp-5);
					}
					case 6:
            		{
                		SetPlayerHealth(playerid, ihp-6);
					}
					case 7:
            		{
                		SetPlayerHealth(playerid, ihp-7);
					}
					case 8:
            		{
                		SetPlayerHealth(playerid, ihp-8);
					}
					case 9:
            		{
                		SetPlayerHealth(playerid, ihp-9);
					}
					case 10:
            		{
                		SetPlayerHealth(playerid, ihp-10);
					}
				}
			}
		    case 22:
		    {
        		switch(GraczInfo[issuerid][gSkill])
        		{
            		case 1:
            		{
                		SetPlayerHealth(playerid, ihp-1);
					}
					case 2:
            		{
                		SetPlayerHealth(playerid, ihp-2);
					}
					case 3:
            		{
                		SetPlayerHealth(playerid, ihp-3);
					}
					case 4:
            		{
               		 	SetPlayerHealth(playerid, ihp-4);
					}
					case 5:
            		{
                		SetPlayerHealth(playerid, ihp-5);
					}
					case 6:
            		{
                		SetPlayerHealth(playerid, ihp-6);
					}
					case 7:
            		{
                		SetPlayerHealth(playerid, ihp-7);
					}
					case 8:
            		{
                		SetPlayerHealth(playerid, ihp-8);
					}
					case 9:
            		{
                		SetPlayerHealth(playerid, ihp-9);
					}
					case 10:
            		{
                		SetPlayerHealth(playerid, ihp-10);
					}
				}
			}
			case 24:
		    {
        		switch(GraczInfo[issuerid][gSkill2])
        		{
            		case 1:
            		{
                		SetPlayerHealth(playerid, ihp-1);
					}
					case 2:
            		{
                		SetPlayerHealth(playerid, ihp-2);
					}
					case 3:
            		{
                		SetPlayerHealth(playerid, ihp-3);
					}
					case 4:
            		{
               		 	SetPlayerHealth(playerid, ihp-4);
					}
					case 5:
            		{
                		SetPlayerHealth(playerid, ihp-5);
					}
					case 6:
            		{
                		SetPlayerHealth(playerid, ihp-6);
					}
					case 7:
            		{
                		SetPlayerHealth(playerid, ihp-7);
					}
					case 8:
            		{
                		SetPlayerHealth(playerid, ihp-8);
					}
					case 9:
            		{
                		SetPlayerHealth(playerid, ihp-9);
					}
					case 10:
            		{
                		SetPlayerHealth(playerid, ihp-10);
					}
				}
			}
			case 25:
		    {
        		switch(GraczInfo[issuerid][gSkill1])
        		{
            		case 1:
            		{
                		SetPlayerHealth(playerid, ihp-1);
					}
					case 2:
            		{
                		SetPlayerHealth(playerid, ihp-2);
					}
					case 3:
            		{
                		SetPlayerHealth(playerid, ihp-3);
					}
					case 4:
            		{
               		 	SetPlayerHealth(playerid, ihp-4);
					}
					case 5:
            		{
                		SetPlayerHealth(playerid, ihp-5);
					}
					case 6:
            		{
                		SetPlayerHealth(playerid, ihp-6);
					}
					case 7:
            		{
                		SetPlayerHealth(playerid, ihp-7);
					}
					case 8:
            		{
                		SetPlayerHealth(playerid, ihp-8);
					}
					case 9:
            		{
                		SetPlayerHealth(playerid, ihp-9);
					}
					case 10:
            		{
                		SetPlayerHealth(playerid, ihp-10);
					}
				}
			}
			case 28:
		    {
        		switch(GraczInfo[issuerid][gSkill3])
        		{
            		case 1:
            		{
                		SetPlayerHealth(playerid, ihp-1);
					}
					case 2:
            		{
                		SetPlayerHealth(playerid, ihp-2);
					}
					case 3:
            		{
                		SetPlayerHealth(playerid, ihp-3);
					}
					case 4:
            		{
               		 	SetPlayerHealth(playerid, ihp-4);
					}
					case 5:
            		{
                		SetPlayerHealth(playerid, ihp-5);
					}
					case 6:
            		{
                		SetPlayerHealth(playerid, ihp-6);
					}
					case 7:
            		{
                		SetPlayerHealth(playerid, ihp-7);
					}
					case 8:
            		{
                		SetPlayerHealth(playerid, ihp-8);
					}
					case 9:
            		{
                		SetPlayerHealth(playerid, ihp-9);
					}
					case 10:
            		{
                		SetPlayerHealth(playerid, ihp-10);
					}
				}
			}
			case 29:
		    {
        		switch(GraczInfo[issuerid][gSkill4])
        		{
            		case 1:
            		{
                		SetPlayerHealth(playerid, ihp-1);
					}
					case 2:
            		{
                		SetPlayerHealth(playerid, ihp-2);
					}
					case 3:
            		{
                		SetPlayerHealth(playerid, ihp-3);
					}
					case 4:
            		{
               		 	SetPlayerHealth(playerid, ihp-4);
					}
					case 5:
            		{
                		SetPlayerHealth(playerid, ihp-5);
					}
					case 6:
            		{
                		SetPlayerHealth(playerid, ihp-6);
					}
					case 7:
            		{
                		SetPlayerHealth(playerid, ihp-7);
					}
					case 8:
            		{
                		SetPlayerHealth(playerid, ihp-8);
					}
					case 9:
            		{
                		SetPlayerHealth(playerid, ihp-9);
					}
					case 10:
            		{
                		SetPlayerHealth(playerid, ihp-10);
					}
				}
			}
			case 30:
		    {
        		switch(GraczInfo[issuerid][gSkill5])
        		{
            		case 1:
            		{
                		SetPlayerHealth(playerid, ihp-1);
					}
					case 2:
            		{
                		SetPlayerHealth(playerid, ihp-2);
					}
					case 3:
            		{
                		SetPlayerHealth(playerid, ihp-3);
					}
					case 4:
            		{
               		 	SetPlayerHealth(playerid, ihp-4);
					}
					case 5:
            		{
                		SetPlayerHealth(playerid, ihp-5);
					}
					case 6:
            		{
                		SetPlayerHealth(playerid, ihp-6);
					}
					case 7:
            		{
                		SetPlayerHealth(playerid, ihp-7);
					}
					case 8:
            		{
                		SetPlayerHealth(playerid, ihp-8);
					}
					case 9:
            		{
                		SetPlayerHealth(playerid, ihp-9);
					}
					case 10:
            		{
                		SetPlayerHealth(playerid, ihp-10);
					}
				}
			}
			case 31:
		    {
        		switch(GraczInfo[issuerid][gSkill6])
        		{
            		case 1:
            		{
                		SetPlayerHealth(playerid, ihp-1);
					}
					case 2:
            		{
                		SetPlayerHealth(playerid, ihp-2);
					}
					case 3:
            		{
                		SetPlayerHealth(playerid, ihp-3);
					}
					case 4:
            		{
               		 	SetPlayerHealth(playerid, ihp-4);
					}
					case 5:
            		{
                		SetPlayerHealth(playerid, ihp-5);
					}
					case 6:
            		{
                		SetPlayerHealth(playerid, ihp-6);
					}
					case 7:
            		{
                		SetPlayerHealth(playerid, ihp-7);
					}
					case 8:
            		{
                		SetPlayerHealth(playerid, ihp-8);
					}
					case 9:
            		{
                		SetPlayerHealth(playerid, ihp-9);
					}
					case 10:
            		{
                		SetPlayerHealth(playerid, ihp-10);
					}
				}
			}
			case 34:
		    {
        		switch(GraczInfo[issuerid][gSkill7])
        		{
            		case 1:
            		{
                		SetPlayerHealth(playerid, ihp-1);
					}
					case 2:
            		{
                		SetPlayerHealth(playerid, ihp-2);
					}
					case 3:
            		{
                		SetPlayerHealth(playerid, ihp-3);
					}
					case 4:
            		{
               		 	SetPlayerHealth(playerid, ihp-4);
					}
					case 5:
            		{
                		SetPlayerHealth(playerid, ihp-5);
					}
					case 6:
            		{
                		SetPlayerHealth(playerid, ihp-6);
					}
					case 7:
            		{
                		SetPlayerHealth(playerid, ihp-7);
					}
					case 8:
            		{
                		SetPlayerHealth(playerid, ihp-8);
					}
					case 9:
            		{
                		SetPlayerHealth(playerid, ihp-9);
					}
					case 10:
            		{
                		SetPlayerHealth(playerid, ihp-10);
					}
				}
			}
		}
		switch(GraczInfo[issuerid][gSkill14])
		{
			case 1:
 			{
  				SetPlayerHealth(playerid, ihp-1);
			}
			case 2:
 			{
 				SetPlayerHealth(playerid, ihp-2);
			}
			case 3:
 			{
 				SetPlayerHealth(playerid, ihp-3);
			}
			case 4:
 			{
		 		SetPlayerHealth(playerid, ihp-4);
			}
			case 5:
 			{
 				SetPlayerHealth(playerid, ihp-5);
			}
			case 6:
 			{
 				SetPlayerHealth(playerid, ihp-6);
			}
			case 7:
 			{
 				SetPlayerHealth(playerid, ihp-7);
			}
			case 8:
 			{
 				SetPlayerHealth(playerid, ihp-8);
			}
			case 9:
 			{
 				SetPlayerHealth(playerid, ihp-9);
			}
			case 10:
 			{
 				SetPlayerHealth(playerid, ihp-10);
			}
		}
		if(ihp < 90)
		{
			switch(GraczInfo[issuerid][gSkill8])
			{
				case 1:
 				{
  					SetPlayerHealth(playerid, ihp+1);
				}
				case 2:
 				{
 					SetPlayerHealth(playerid, ihp+2);
				}
				case 3:
 				{
 					SetPlayerHealth(playerid, ihp+3);
				}
				case 4:
 				{
		 			SetPlayerHealth(playerid, ihp+4);
				}
				case 5:
 				{
 					SetPlayerHealth(playerid, ihp-5);
				}
				case 6:
 				{
 					SetPlayerHealth(playerid, ihp-6);
				}
				case 7:
 				{
 					SetPlayerHealth(playerid, ihp-7);
				}
				case 8:
 				{
 					SetPlayerHealth(playerid, ihp-8);
				}
				case 9:
 				{
 					SetPlayerHealth(playerid, ihp-9);
				}
				case 10:
 				{
 					SetPlayerHealth(playerid, ihp-10);
				}
			}
		}
    }
    return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    A_CHAR(inputtext);
    switch(dialogid)
    {
        case REJ:
        {
            switch(response)
            {
                case 0:
                {
                    KickES(playerid, "eSystem", "próba zarejestrowania siê bez podania has³a");
				}
				case 1:
				{
				    if(strlen(inputtext) >= 4 && strlen(inputtext) <= 24)
				    {
				        format(query, sizeof(query), "INSERT INTO `gracze` (`login`, `haslo`) VALUES ('%s', '%s')", PlayerName(playerid), MD5_Hash(inputtext));
				        mysql_query(query);
				        mysql_free_result();
				        ShowPlayerDialog(playerid, LOG, DIALOG_STYLE_PASSWORD, "Eagle Server - Panel logowania:", "Podaj swoje has³o:", "Zaloguj", "Anuluj");
					}
				    else
				    {
				        ShowPlayerDialog(playerid, REJ, DIALOG_STYLE_PASSWORD, "Eagle Server - Panel rejestracji:", "Has³o musi mieæ od 4-24 znaków!", "Zarejestruj", "Anuluj");
					}
				}
			}
		}
		case LOG:
		{
		    switch(response)
            {
                case 0:
                {
                    KickES(playerid, "eSystem", "próba zalogowania siê bez podania has³a");
				}
				case 1:
				{
				    format(query, sizeof(query), "SELECT `haslo`, `ban` FROM `gracze` WHERE `login`='%s'", PlayerName(playerid));
					mysql_query(query);
					mysql_store_result();
					mysql_fetch_row_format(query, "|");
					sscanf(query, "p<|>s[256]d", GraczInfo[playerid][gHaslo], GraczInfo[playerid][gBan]);
					if(GraczInfo[playerid][gBan] == 1)
					{
					    KickES(playerid, "eSystem", "próba zalogowania siê na zbanowane konto");
					}
					if(!strcmp(GraczInfo[playerid][gHaslo], MD5_Hash(inputtext), true))
					{
					    format(fetch, sizeof(fetch), "SELECT * FROM `gracze` WHERE `login`='%s'", PlayerName(playerid));
						mysql_query(fetch);
						mysql_store_result();
						mysql_fetch_row_format(fetch, "|");
						sscanf(fetch, "p<|>ds[24]s[256]ddddddddddddddddddddddddddddddd",
						GraczInfo[playerid][gID],
						GraczInfo[playerid][gLogin],
						GraczInfo[playerid][gHaslo],
						GraczInfo[playerid][gAdmin],
						GraczInfo[playerid][gPremium],
						GraczInfo[playerid][gWarn],
						GraczInfo[playerid][gBan],
						GraczInfo[playerid][gKasa],
						GraczInfo[playerid][gBank],
						GraczInfo[playerid][gPoziom],
						GraczInfo[playerid][gExp],
						GraczInfo[playerid][gWexp],
						GraczInfo[playerid][gZabojstw],
						GraczInfo[playerid][gSmierci],
						GraczInfo[playerid][gPktdr],
						GraczInfo[playerid][gPktr],
						GraczInfo[playerid][gSkill],
						GraczInfo[playerid][gSkill1],
						GraczInfo[playerid][gSkill2],
						GraczInfo[playerid][gSkill3],
						GraczInfo[playerid][gSkill4],
						GraczInfo[playerid][gSkill5],
						GraczInfo[playerid][gSkill6],
						GraczInfo[playerid][gSkill7],
						GraczInfo[playerid][gSkill8],
						GraczInfo[playerid][gSkill9],
						GraczInfo[playerid][gSkill10],
						GraczInfo[playerid][gSkill11],
						GraczInfo[playerid][gSkill12],
						GraczInfo[playerid][gSkill13],
						GraczInfo[playerid][gSkill14],
						GraczInfo[playerid][gPskill],
						GraczInfo[playerid][gPskill1],
						GraczInfo[playerid][gPskill2]
						);
						mysql_free_result();
						GraczInfo[playerid][gZalogowany] = 1;
						GraczInfo[playerid][gPW] = 1;
						if(GraczInfo[playerid][gAdmin] == 1)
						{
						    SendClientMessage(playerid, ADMIN, "[Admin:] Wpisz /modcmd, ¿eby poznaæ cmd moderatora");
						}
						else if(GraczInfo[playerid][gAdmin] == 2)
						{
						    SendClientMessage(playerid, ADMIN, "[Admin:] Wpisz /admcmd, ¿eby poznaæ cmd admina");
						}
						else if(GraczInfo[playerid][gAdmin] == 3)
						{
						    SendClientMessage(playerid, ADMIN, "[Admin:] Wpisz /sadmcmd, ¿eby poznaæ cmd senior admina");
						}
						else if(GraczInfo[playerid][gAdmin] == 9)
						{
						    SendClientMessage(playerid, ADMIN, "[Admin:] Wpisz /hadmcmd, ¿eby poznaæ cmd h@ admina");
						}
						if(GraczInfo[playerid][gPremium] >= 1)
						{
						    SendClientMessage(playerid, VIP, "[Premium:] Dziêki za wsparcie serwera! Wpisz /premiumcmd ");
						}
					}
					else
					{
						ShowPlayerDialog(playerid, LOG, DIALOG_STYLE_PASSWORD, "Eagle Server - Panel logowania:", "Poda³eœ z³e has³o!\nSpróbuj jeszcze raz", "Zaloguj", "Anuluj");
					}
				}
			}
		}
		case ZHAS:
		{
			switch(response)
			{
			    case 1:
			    {
			        if(strlen(inputtext) >= 4 && strlen(inputtext) <= 24)
				    {
				        format(query, sizeof(query), "UPDATE `gracze` SET `haslo`='%s' WHERE `login`='%s'", MD5_Hash(inputtext), PlayerName(playerid));
				        mysql_query(query);
				        mysql_free_result();
				        SendClientMessage(playerid, E, "[Info:] Has³o zmienione!");
				        return 1;
					}
					else
					{
					    ShowPlayerDialog(playerid, ZHAS, DIALOG_STYLE_PASSWORD, "Eagle serwer - zmiana has³a", "Podaj swoje nowe has³o:", "Zmieñ", "Anuluj");
					}
				}
			}
		}
		case MCMD:
		{
		    switch(response)
		    {
		        case 1:
		        {
					format(fetch, sizeof(fetch), "%s/zabij %s- zabijasz gracza\n%s/interior %s- ustawiasz interior graczowi\n%s/virtualworld %s- ustawiasz VW graczowi\n%s/resetbroni %s- resetujesz bronie graczowi\n%s/gcstatus %s- w³¹czasz/wy³¹czasz globalny czat\n%s/gotocar %s- teleportuje do pojazdu\n%s/respawn %s- respawnuje pojazdy",
					cformat(CF),
					cformat(WHITE),
					cformat(CF),
					cformat(WHITE),
					cformat(CF),
					cformat(WHITE),
					cformat(CF),
					cformat(WHITE),
					cformat(CF),
					cformat(WHITE),
					cformat(CF),
					cformat(WHITE),
					cformat(CF),
					cformat(WHITE)
					);
		            ShowPlayerDialog(playerid, MCMD2, DIALOG_STYLE_MSGBOX, "Lista komend moderatora:", fetch, "Ok", "");
				}
			}
		}
		case VPANEL:
		{
		    switch(listitem)
		    {
		        case 0:
		        {
		            ShowPlayerDialog(playerid, VNASK, DIALOG_STYLE_MSGBOX, "Neony:", "Chcesz dodaæ neony czy je usun¹æ?", "Dodaæ", "Usun¹æ");
				}
				case 1:
				{
				    ShowPlayerDialog(playerid, VMASK, DIALOG_STYLE_MSGBOX, "Maska:", "Chcesz otworzyæ czy zamkn¹æ?", "Otworzyæ", "Zamkn¹æ");
				}
				case 2:
				{
				    ShowPlayerDialog(playerid, VDOOR, DIALOG_STYLE_MSGBOX, "Drzwi:", "Chcesz otworzyæ czy zamkn¹æ?", "Otworzyæ", "Zamkn¹æ");
				}
				case 3:
				{
				    ShowPlayerDialog(playerid, VENGINE, DIALOG_STYLE_MSGBOX, "Silnik:", "Chcesz odpaliæ czy zgasiæ?", "Odpal", "Zgaœ");
				}
				case 4:
				{
				    ShowPlayerDialog(playerid, VLIGHT, DIALOG_STYLE_MSGBOX, "Œwiat³a:", "Chcesz zapaliæ czy zgasiæ?", "Zapal", "Zgaœ");
				}
				case 5:
				{
				    ShowPlayerDialog(playerid, VBONET, DIALOG_STYLE_MSGBOX, "Baga¿nik:", "Chcesz otworzyæ czy zamkn¹æ?", "Otwórz", "Zamknij");
				}
				case 6:
				{
				    ShowPlayerDialog(playerid, VALARM, DIALOG_STYLE_MSGBOX, "Alarm:", "Chcesz w³¹czyæ czy wy³¹czyæ?", "W³¹cz", "Wy³¹cz");
				}
			}
		}
		case VNASK:
		{
		    switch(response)
		    {
		        case 0:
		        {
		            new id = GetPlayerVehicleID(playerid);
				    DestroyNeon(id);
				}
				case 1:
				{
				    ShowPlayerDialog(playerid, VNLCO, DIALOG_STYLE_LIST, "Lista kolorów neonów:", "Ciemno niebieski\nCzerwony\nZielony\nBia³y\nFioletowy\n¯ó³ty\nB³êkitny\nJasnoniebieski\nRó¿owy\nPomarañczowy\nJasnozielony\nJasno¿ó³ty", "Stwórz", "Anuluj");
				}
			}
		}
		case VNLCO:
		{
		    new id = GetPlayerVehicleID(playerid);
			DestroyNeon(id);
		   	switch(listitem)
			{
			   	case 0:
				{
					vNeon[id][0] = CreateObject(18648,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = -1;
			  	}
	   			case 1:
				{
					vNeon[id][0] = CreateObject(18647,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = -1;
				}
	   			case 2:
				{
					vNeon[id][0] = CreateObject(18649,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = -1;
				}
	   			case 3:
				{
					vNeon[id][0] = CreateObject(18652,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = -1;
				}
	   			case 4:
				{
			   		vNeon[id][0] = CreateObject(18651,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = -1;
				}
	   			case 5:
				{
			   		vNeon[id][0] = CreateObject(18650,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = -1;
				}
	   			case 6:
				{
	  				vNeon[id][0] = CreateObject(18648,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = CreateObject(18649,0,0,0,0,0,0, 100.0);
				}
	   			case 7:
				{
	  				vNeon[id][0] = CreateObject(18648,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = CreateObject(18652,0,0,0,0,0,0, 100.0);
				}
	   			case 8:
				{
					vNeon[id][0] = CreateObject(18647,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = CreateObject(18652,0,0,0,0,0,0, 100.0);
				}
	   			case 9:
				{
					vNeon[id][0] = CreateObject(18647,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = CreateObject(18650,0,0,0,0,0,0, 100.0);

				}
	   			case 10:
				{
					vNeon[id][0] = CreateObject(18649,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = CreateObject(18652,0,0,0,0,0,0, 100.0);

				}
	   			case 11:
				{
					vNeon[id][0] = CreateObject(18652,0,0,0,0,0,0, 100.0);
					vNeon[id][1] = CreateObject(18650,0,0,0,0,0,0, 100.0);
				}
			}
			if(vNeon[id][1] != -1)
				AttachObjectToVehicle(vNeon[id][1], id, 0.0, 0.0, -0.70, 0.0, 0.0, 0.0);

			AttachObjectToVehicle(vNeon[id][0], id, 0.0, 0.0, -0.70, 0.0, 0.0, 0.0);
			SendClientMessage(playerid, I, "[Info:]Doda³eœ neon!Wygl¹da super! :)");
			return 1;
		}
		case VMASK:
		{
		    new engine, lights, bonnet, alarm, doors, boot, objective;
		    new id = GetPlayerVehicleID(playerid);
		    GetVehicleParamsEx(id, engine, lights, alarm, doors, bonnet, boot, objective);
		    switch(response)
		    {
		    	case 0:
		    	{
		    		SetVehicleParamsEx(id, 1,lights, alarm, doors, 0, boot, objective);
				}
				case 1:
				{
			    	SetVehicleParamsEx(id, 1, lights, alarm, doors, 1, boot, objective);
				}
			}
		}
		case VDOOR:
		{
		    new engine, lights, bonnet, alarm, doors, boot, objective;
		    new id = GetPlayerVehicleID(playerid);
		    GetVehicleParamsEx(id, engine, lights, alarm, doors, bonnet, boot, objective);
		    switch(response)
		    {
		    	case 0:
		    	{
		    		SetVehicleParamsEx(id, 1,lights, alarm, 0, bonnet, boot, objective);
				}
				case 1:
				{
			    	SetVehicleParamsEx(id, 1, lights, alarm, 1, bonnet, boot, objective);
				}
			}
		}
		case VENGINE:
		{
		    new engine, lights, bonnet, alarm, doors, boot, objective;
		    new id = GetPlayerVehicleID(playerid);
		    GetVehicleParamsEx(id, engine, lights, alarm, doors, bonnet, boot, objective);
		    switch(response)
		    {
		    	case 0:
		    	{
		    		SetVehicleParamsEx(id, 0,lights, alarm, doors, bonnet, boot, objective);
				}
				case 1:
				{
			    	SetVehicleParamsEx(id, 1, lights, alarm, doors, bonnet, boot, objective);
				}
			}
		}
		case VLIGHT:
		{
		    new engine, lights, bonnet, alarm, doors, boot, objective;
		    new id = GetPlayerVehicleID(playerid);
		    GetVehicleParamsEx(id, engine, lights, alarm, doors, bonnet, boot, objective);
		    switch(response)
		    {
		    	case 0:
		    	{
		    		SetVehicleParamsEx(id, 1, 0, alarm, doors, bonnet, boot, objective);
				}
				case 1:
				{
			    	SetVehicleParamsEx(id, 1, 1, alarm, doors, bonnet, boot, objective);
				}
			}
		}
		case VALARM:
		{
		    new engine, lights, bonnet, alarm, doors, boot, objective;
		    new id = GetPlayerVehicleID(playerid);
		    GetVehicleParamsEx(id, engine, lights, alarm, doors, bonnet, boot, objective);
		    switch(response)
		    {
		    	case 0:
		    	{
		    		SetVehicleParamsEx(id, 1, lights,0, doors, bonnet, boot, objective);
				}
				case 1:
				{
			    	SetVehicleParamsEx(id, 1, lights, 1, doors, bonnet, boot, objective);
				}
			}
		}
		case LSKILL:
		{
		    switch(response)
		    {
		        case 0:
		        {
		            return 1;
				}
				case 1:
				{
					switch(listitem)
					{
					    case 0:
					    {
					        return 1;
						}
					}
					if(GraczInfo[playerid][gPktdr] <= 1)
				    {
				        ShowPlayerDialog(playerid, LINFO, DIALOG_STYLE_MSGBOX, "Informacja", "Nie masz punktów do rozdania!", "Ok", "Anuluj");
					}
				}
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

//Odpowiada on za to, co stanie siê przed komend¹ któr¹ wpisa³ gracz. U¿ycie póŸniej.
public OnPlayerCommandReceived(playerid, cmdtext[])
{
 	if(GraczInfo[playerid][gZalogowany] == 0)
 	{
 	    SendClientMessage(playerid, E, "[Error:] Najpierw siê zaloguj!");
 	    return 1;
	}
    return 1;
}
// Ten zaœ, odpowiada za to co stanie siê po, komendzie któr¹ wpisa³ gracz.
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(!success)
	{
	    SendClientMessage(playerid, E, "[Error:] Nie ma takiej komendy!Wpisz /cmd");
	    return 1;
	}
	if(GraczInfo[playerid][gZalogowany] == 0)
	{
	    success = 0;
	}
    return 1;
}

CMD:cmd(playerid, params[])
{
	format(fetch, sizeof(fetch), "%s/statystyki%s - statystyki twojej postaci\n%s/zmienhaslo%s - pozwala zmieniæ twoje obecne has³o\n%s/gc %s- globalny chat\n%s/report %s- zg³aszasz przewinienie gracza\n%s/premium %s- zalety konta premium\n%s/sklepik %s- us³ugi do kupienia na naszym serwerze\n%s/vipy %s- lista vipów na serwerze\n%s/admini %s- lista adminów na serwerze\n%s/pw %s- prywatna wiadomoœæ\n%s/vpanel %s- panel pojazdu",
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE)
	);
	ShowPlayerDialog(playerid, CMDLISTA, DIALOG_STYLE_MSGBOX, "Lista komend serwera:", fetch, "Dalej", "Anuluj");
	return 1;
}

CMD:lista(playerid, aprams[])
{
	ListaSkilli(playerid);
}

CMD:bron(playerid, params[])
{
	GivePlayerWeapon(playerid, 22, 50);
	GivePlayerWeapon(playerid, 25, 90);
	return 1;
}

CMD:modcmd(playerid, params[])
{
	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);
		
	format(fetch, sizeof(fetch), "%s/kick %s- wyrzucasz gracza z serwera\n%s/warn %s- dajesz ostrze¿enie graczowi\n%s/unwarn %s - usuwasz warna graczowi\n%s/ucisz %s- uciszasz gracza\n%s/odcisz %s- odciszasz gracza\n%s/goto %s- teleportujesz siê do gracza\n%s/gethere %s- teleportujesz do siebie gracza\n%s/napraw %s- naprawiasz pojazd graczowi\n%s/ulecz %s- leczysz gracza\n%s/armor %s- dajesz armor graczowi\n%s/zamroz %s- zamra¿asz gracza\n%s/odmroz %s- odmra¿asz gracza",
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE),
	cformat(CF),
	cformat(WHITE));
	ShowPlayerDialog(playerid, MCMD, DIALOG_STYLE_MSGBOX, "Lista komend moderatora:", fetch, "Dalej", "WyjdŸ");
	return 1;
}

CMD:acmd(playerid, params[])
{
    if(GraczInfo[playerid][gAdmin] < 2)
		return SendClientMessage(playerid, E, ER);
		
	format(fetch, sizeof(fetch), "%s/autacmd %s- lista cmd pojazdów",
	cformat(CF),
	cformat(WHITE));
    ShowPlayerDialog(playerid, ACMD, DIALOG_STYLE_MSGBOX, "Lista komend administratora:", fetch, "Dalej", "WyjdŸ");
    return 1;
}

CMD:aautacmd(playerid, params[])
{
	if(GraczInfo[playerid][gAdmin] <= 1)
	    return SendClientMessage(playerid, E, ER);
	    
	SendClientMessage(playerid, ADMIN, "[Ainfo:] Lista cmd pojazdu dla admina:");
	SendClientMessage(playerid, ADMIN, "[Acmd:] /apojazdstworz - /apojazdzaparkuj - /apojazdkolor");
	SendClientMessage(playerid, ADMIN, "[Ainfo:] Spróbuj czegoœ nie spieprzyæ, ¿yczê powodzenia :P");
	return 1;
}

CMD:vpanel(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, E, "[Error:] Mo¿e wejdziesz do pojazdu?");
	    
	format(fetch, sizeof(fetch), "%sNeony\n%sMaska\n%sDrzwi\n%sSilnik\n%sŒwiat³a\n%sBaga¿nik\n%sAlarm\n%sNapraw\n%sPrzemaluj\n%sPanel w³aœciciela",
	cformat(CF),
    cformat(CF),
    cformat(CF),
    cformat(CF),
    cformat(CF),
    cformat(CF),
    cformat(CF),
    cformat(CF),
    cformat(CF),
    cformat(ADMIN)
	);
	ShowPlayerDialog(playerid, VPANEL, DIALOG_STYLE_LIST, "Jak¹ opcje wybierasz?", fetch, "Wybierz", "Anuluj");
	return 1;
}

CMD:apojazdtyp(playerid, params[])
{
    if(GraczInfo[playerid][gAdmin] < 2)
		return SendClientMessage(playerid, E, ER);

  	new ptyp2;
  	if(sscanf(params, "d", ptyp2))
  		return SendClientMessage(playerid, E, "[U¿ycie:] /apojazdtyp [idtypu]");
  		
	if(ptyp2 == 3)
	    return SendClientMessage(playerid, E, "[Error:] Nie dozwolony tryb!");
	    
    if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, E, "[Error:] WejdŸ do pojazdu");
	    
    new id = GetPlayerVehicleID(playerid);
    PojazdInfo[id][ptyp] = ptyp2;
    ZapiszAuto(id);
    SendClientMessage(playerid, ADMIN, "Zmieni³eœ id typu pojazdu!");
    return 1;
}


CMD:apojazdtworz(playerid, params[])
{
    if(GraczInfo[playerid][gAdmin] < 2)
		return SendClientMessage(playerid, E, ER);
		
  	new pmodelid, pkolorid, pkolorid1;
  	if(sscanf(params, "ddd", pmodelid, pkolorid, pkolorid1))
  		return SendClientMessage(playerid, E, "[U¿ycie:] /apojazdtworz [id model] [id koloru #1] [id koloru #2]");
	        
  	new Float:gx, Float:gy, Float:gz, Float:ga;
  	GetPlayerPos(playerid, gx, gy, gz);
  	GetPlayerFacingAngle(playerid, ga);
  	if(pmodelid < 400 || pmodelid > 611)
   		return SendClientMessage(playerid, E, "[Error:] Model pojazdu musi siê mieœciæ w zakresie 400-611");
	        
	if(pkolorid < 0 || pkolorid > 120)
 		return SendClientMessage(playerid, E, "[Error:] ID Koloru musi byæ w zakresie 0-120");
		    
	if(pkolorid1 < 0 || pkolorid1 > 120)
 		return SendClientMessage(playerid, E, "[Error:] ID Koloru musi byæ w zakresie 0-120");
		    
	new hook = DodajAuto(pmodelid, gx, gy, gz, ga, pkolorid, pkolorid1, 0, 0, 0, 500);
	OnVehicleSpawn(hook);
	SendClientMessage(playerid, ADMIN, "[Admin:]Doda³eœ nowy pojazd do bazy danych");
	CreateVehicleFromDB(hook);
	return 1;
}

CMD:apojazdzaparkuj(playerid, params[])
{
    if(GraczInfo[playerid][gAdmin] < 2)
		return SendClientMessage(playerid, E, ER);
		
	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, E, "[Error:] WejdŸ do pojazdu");
	    
	new id = GetPlayerVehicleID(playerid);
	ZapiszPozycjeAuta(id);
	SendClientMessage(playerid, ADMIN, "[Admin:] Zapisa³eœ pozycje auta");
	return 1;
}

CMD:apojazdkolor(playerid, params[])
{
    if(GraczInfo[playerid][gAdmin] < 2)
		return SendClientMessage(playerid, E, ER);

	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, E, "[Error:] WejdŸ do pojazdu");
	    
	new kolorid, kolorid1;
	if(sscanf(params, "dd", kolorid, kolorid1))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /apojazdkolor [id koloru #1] [id koloru #2]");
	    
    new id = GetPlayerVehicleID(playerid);
	PojazdInfo[id][pkolor] = kolorid;
	PojazdInfo[id][pkolor1] = kolorid1;
	ChangeVehicleColor(id, kolorid, kolorid1);
	ZapiszAuto(id);
	SendClientMessage(playerid, ADMIN, "[Admin:] Zmieni³eœ kolory pojazdu!");
	return 1;
}
	    
CMD:gcstatus(playerid, params[])
{
	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);
		
	if(gczat == 0)
	    return gczat=1;
	    
	if(gczat == 1)
		return gczat=0;

	return 1;
}

CMD:zabij(playerid, params[])
{
    new id;
	id = strval(params);

	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

    if(!!IsPlayerConnected(id))
	    return SendClientMessage(playerid, E, "[Error:] Nie ma takiego gracza!");
	    
	SetPlayerHealth(id, 0.0);
	return 1;
}

CMD:interior(playerid, params[])
{
    new id;
	id = strval(params);

	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

    if(!IsPlayerConnected(id))
	    return SendClientMessage(playerid, E, "[Error:] Nie ma takiego gracza!");
	    
	SetPlayerInterior(id, 0);
	return 1;
}

CMD:virtualworld(playerid, params[])
{
    new id;
	id = strval(params);

	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

    if(!IsPlayerConnected(id))
	    return SendClientMessage(playerid, E, "[Error:] Nie ma takiego gracza!");
	    
	SetPlayerVirtualWorld(id, 0);
	return 1;
}

CMD:resetbroni(playerid, params[])
{
    new id;
	id = strval(params);

	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

    if(!IsPlayerConnected(id))
	    return SendClientMessage(playerid, E, "[Error:] Nie ma takiego gracza!");
	    
	ResetPlayerWeapons(id);
	return 1;
}

CMD:napraw(playerid, params[])
{
	new id;
	id = strval(params);
	
	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);
		
    if(!IsPlayerConnected(id))
	    return SendClientMessage(playerid, E, "[Error:] Nie ma takiego gracza!");
	    
	if(!IsPlayerInAnyVehicle(id))
	    return SendClientMessage(playerid, E, "[Error:] Gracz o podanym id nie jest w pojeŸdzie");
	    
	new idpojazdu = GetPlayerVehicleID(id);
	SetVehicleHealth(idpojazdu, 1000.0);
	return 1;
}

CMD:zamroz(playerid, params[])
{
    new id;
	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

	if(sscanf(params, "ds[128]", id, tekst))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /zamroz [id] [powód]");
	    
	ZamrozES(id, PlayerName(playerid), tekst);
	return 1;
}

CMD:odmroz(playerid, params[])
{
    new id;
	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

	if(sscanf(params, "ds[128]", id, tekst))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /odmroz [id] [powód]");

	OdmrozES(id, PlayerName(playerid), tekst);
	return 1;
}

CMD:ulecz(playerid, params[])
{
    new id;
	id = strval(params);

	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

    if(!IsPlayerConnected(id))
	    return SendClientMessage(playerid, E, "[Error:] Nie ma takiego gracza!");
	    
	SetPlayerHealth(id, 100.0);
	return 1;
}

CMD:armor(playerid, params[])
{
    new id;
	id = strval(params);

	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

    if(!IsPlayerConnected(id))
	    return SendClientMessage(playerid, E, "[Error:] Nie ma takiego gracza!");

	SetPlayerArmour(id, 100.0);
	return 1;
}

CMD:gotocar(playerid, params[])
{
    if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

	new id;
	if(sscanf(params, "d", id))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /gotocar [id]");
	    
	new Float:vx,Float:vy,Float:vz;
	GetVehiclePos(id, vx,vy,vz);
	SetPlayerPos(playerid, vx,vy,vz+5);
	return 1;
}

CMD:przywolajauto(playerid, params[])
{
    if(GraczInfo[playerid][gAdmin] < 2)
		return SendClientMessage(playerid, E, ER);

	new id;
	if(sscanf(params, "d", id))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /przywolajauto [id]");

	new Float:vx,Float:vy,Float:vz;
	GetPlayerPos(playerid, vx,vy,vz);
	SetVehiclePos(id, vx,vy,vz);
	return 1;
}

CMD:goto(playerid, params[])
{
	new id;
	id = strval(params);
	
	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);
		
	if(!IsPlayerConnected(id))
	    return SendClientMessage(playerid, E, "[Error:] Nie ma takiego gracza!");
	    
	new Float:gx,Float:gy,Float:gz;
	GetPlayerPos(id, gx,gy,gz);
	SetPlayerPos(playerid, gx,gy,gz);
	return 1;
}

CMD:dajadmina(playerid, params[])
{
	new id, adminlvl;
	if(GraczInfo[playerid][gAdmin] < 3)
		return SendClientMessage(playerid, E, ER);
		
    if(!IsPlayerConnected(id))
	    return SendClientMessage(playerid, E, "[Error:] Nie ma takiego gracza!");
	    
	if(sscanf(params, "dd", id, adminlvl))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /dajadmina [id gracza] [adminlvl]");
	    
	if(adminlvl < 1 || adminlvl > 9)
	    return SendClientMessage(playerid, E, "[Error:] AdminLvL mieœci sie w przedziale 1-9");
	    
	GraczInfo[id][gAdmin] = adminlvl;
	SendClientMessage(id, ADMIN, "[Admin:] Teraz jesteœ juzadministratorem :) Wpisz /modcmd");
	SendClientMessage(playerid, ADMIN, "[Admin:] Da³eœ graczowi admina!");
	return 1;
}

CMD:gethere(playerid, params[])
{
	new id;
	id = strval(params);

	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

	if(!IsPlayerConnected(id))
	    return SendClientMessage(playerid, E, "[Error:] Nie ma takiego gracza!");

	new Float:gx,Float:gy,Float:gz;
	GetPlayerPos(playerid, gx,gy,gz);
	SetPlayerPos(id, gx,gy,gz);
	return 1;
}

CMD:kick(playerid, params[])
{
	new id;
	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);
		
	if(sscanf(params, "ds[128]", id, tekst))
	    return SendClientMessage(playerid, E, "[U¿ycie:] / kick [id] [powód]");
	    
	KickES(id, PlayerName(playerid), tekst);
	return 1;
}

CMD:warn(playerid, params[])
{
	new id;
	
	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);
		
	if(sscanf(params, "ds[128]", id, tekst))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /warn [id gracza] [powód]");
	    
	WarnES(id, PlayerName(playerid), tekst);
	return 1;
}

CMD:unwarn(playerid, params[])
{
	new id;

	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

	if(sscanf(params, "ds[128]", id, tekst))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /unwarn [id gracza] [powód]");

	UnWarnES(id, PlayerName(playerid), tekst);
	return 1;
}

CMD:odcisz(playerid, params[])
{
	new id;

	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

	if(sscanf(params, "ds[128]", id, tekst))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /odcisz [id gracza] [powód]");

	UnMuteES(id, PlayerName(playerid), tekst);
	return 1;
}

CMD:ucisz(playerid, params[])
{
	new id;

	if(GraczInfo[playerid][gAdmin] < 1)
		return SendClientMessage(playerid, E, ER);

	if(sscanf(params, "ds[128]", id, tekst))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /ucisz[id gracza] [powód]");

	MuteES(id, PlayerName(playerid), tekst);
	return 1;
}

CMD:pw(playerid, params[])
{
	new id;
	if(sscanf(params, "ds[128]", id, tekst))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /pw [id gracza] [treœæ]");

	if(GraczInfo[id][gPW] == 0)
	    SendClientMessage(playerid, E, "[Error:] Ten gracz ma wy³¹czone prywatne wiadomoœci!");
	    
 	PwES(playerid, id, tekst);
	return 1;
}

CMD:vipy(playerid, params[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(GraczInfo[i][gPremium] >= 1)
	    {
	    	format(query, sizeof(query), "{a2fada}%s(id:%d)\n", PlayerName(i), i);
	    	ShowPlayerDialog(playerid, VIP2, DIALOG_STYLE_MSGBOX, "Lista graczy premium:", query, "Ok", "");
		}
	}
	return 1;
}

CMD:admini(playerid, params[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(GraczInfo[i][gAdmin] >= 1)
	    {
	    	format(query, sizeof(query), "{a2fada}%s(id:%d)\n", PlayerName(i), i);
	    	ShowPlayerDialog(playerid, VIP2, DIALOG_STYLE_MSGBOX, "Lista adminów:", query, "Ok", "");
		}
	}
	return 1;
}

CMD:premium(playerid, params[])
{
	fetch = "{a2fada}Korzystaj¹c z konta premium masz:\n- mo¿liwoœæ zmiany nicku\n- wiêkszy exp za zabójstwa\n- bronie dostêpne tylko dla konta premium\n- dostêp do czatu premium\n- kolor nicku\n- unikaln¹ rangê \"VIP\"na forum\n- nowe komendy tylko dla konta premium\nOraz wiele inny - zajrzyj na forum!\nKonto premium kosztuje tylko 10 z³!\nW ten sposób wspierasz nasz serwer!";
	ShowPlayerDialog(playerid, VIP2, DIALOG_STYLE_MSGBOX, "Jakie s¹ korzyœci?", fetch, "Ok", "");
	return 1;
}

CMD:sklepik(playerid, params[])
{
	fetch = "{a2fada}Wysy³aj¹c SMS'a mo¿esz kupiæ:\n- poziom\n- konto premium\n- frakcje\n - prywatny samochód\n- biznes\n- dom\n- cmd do frakcji\n - obiekty do frakcji\n - w³asny dzia³ na forum\n - i inne\nWiêcej informacji na naszym forum\nChcesz coœ kupiæ czego nie ma w sklepiku?\nMo¿esz napisaæ do head admina";
	ShowPlayerDialog(playerid, VIP2, DIALOG_STYLE_MSGBOX, "Jakie us³ugi mo¿na u nas kupiæ?", fetch, "Ok", "");
	return 1;
}

CMD:report(playerid, params[])
{
	new id;
	if(sscanf(params, "ds[128]", id, tekst))
	    return  SendClientMessage(playerid, E, "[U¿ycie:] /report [id gracza] [treœæ]");
	    
	if(GraczInfo[id][gZalogowany] == 0)
	    return SendClientMessage(playerid, E, "[Error:] Ten gracz nie jest zalogowany!");

	SendClientMessage(playerid, I, "[Info:] Z³o¿y³eœ report!");
	format(query, sizeof(query), "[Report:]Gracz %s zg³asza przewinienie gracza %s, powód: %s", PlayerName(playerid), PlayerName(id), tekst);
	AdminES(query);
	return 1;
}

CMD:gc(playerid, params[])
{
	if(sscanf(params, "s[128]", tekst))
	    return SendClientMessage(playerid, E, "[U¿ycie:] /gc [tekst]");

	if(gczat == 0)
	    return SendClientMessage(playerid, E, "[Error:] Czat globalny jest obecnie wy³¹czony!");
	    
	if(GraczInfo[playerid][gMute] == 1)
	    return SendClientMessage(playerid, E, "[Error:] Jesteœ uciszony!");
	    
	format(query, sizeof(query), "%s[Globalny:] %s%s%s: %s",cformat(GC), cformat(B), PlayerName(playerid), cformat(GC), tekst);
	SendClientMessageToAll(GC, query);
	return 1;
}


CMD:statystyki(playerid, params[])
{
	format(query, sizeof(query), "%s%s", cformat(CF), PlayerName(playerid));
	new ranga[24];
	ranga = "Gracz";
	if(GraczInfo[playerid][gAdmin] >= 1)
	{
	    ranga = "Admin";
	}
	if(GraczInfo[playerid][gPremium] >= 1)
	{
	    ranga = "Premium";
	}
	if(GraczInfo[playerid][gAdmin] >= 1 && GraczInfo[playerid][gPremium] >= 1)
	{
	    ranga = "Admin i Premium";
	}
	format(fetch, sizeof(fetch), "%sRanga:%s %s\n%sWarnów: %s%d\n%sKasa:%s %d\n%sBank: %s%d\n%sPoziom:%s %d\n%sExp: %s(%d\\%d)\n%sZabójstw: %s%d\n%sŒmierci: %s%d\n",
	cformat(CF),
	cformat(WHITE),
	ranga,
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gWarn],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gKasa],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gBank],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gPoziom],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gExp],
	GraczInfo[playerid][gWexp],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gZabojstw],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSmierci]);
	ShowPlayerDialog(playerid, STATY, DIALOG_STYLE_MSGBOX, query, fetch, "Ok", "");
	return 1;
}

CMD:zmienhaslo(playerid, params[])
{
	ShowPlayerDialog(playerid, ZHAS, DIALOG_STYLE_PASSWORD, "Eagle serwer - zmiana has³a", "Podaj swoje nowe has³o:", "Zmieñ", "Anuluj");
	return 1;
}

stock PlayerName(playerid)
{
	new imiegracza[MAX_PLAYER_NAME];
 	GetPlayerName(playerid, imiegracza, sizeof(imiegracza));
	return imiegracza;
}

ZamrozES(id, kto[], powod[])
{
    new chat[128];
	format(chat, sizeof(chat), "[Eagle Server:] Gracz %s zosta³ zamro¿ony przez: %s, powód: %s", PlayerName(id), kto, powod);
	SendClientMessageToAll(B, chat);
	TogglePlayerControllable(id, 0);
	return 1;
}

OdmrozES(id, kto[], powod[])
{
    new chat[128];
	format(chat, sizeof(chat), "[Eagle Server:] Gracz %s zosta³ odmro¿ony przez: %s, powód: %s", PlayerName(id), kto, powod);
	SendClientMessageToAll(B, chat);
	TogglePlayerControllable(id, 1);
	return 1;
}

BanES(id, kto[], powod[])
{
	new chat[128];
	format(chat, sizeof(chat), "[Eagle Server:] Gracz %s zosta³ zbanowany przez: %s, powód: %s", PlayerName(id), kto, powod);
	SendClientMessageToAll(B, chat);
	GraczInfo[id][gBan] = 1;
	ZapiszGracza(id);
	Ban(id);
	return 1;
}

KickES(id, kto[], powod[])
{
	new chat[128];
	format(chat, sizeof(chat), "[Eagle Server:] Gracz %s zosta³ wyrzucony z serwera przez: %s, powód: %s", PlayerName(id), kto, powod);
	SendClientMessageToAll(B, chat);
	Kick(id);
	return 1;
}

WarnES(id, kto[], powod[])
{
	new chat[128];
	format(chat, sizeof(chat), "[Eagle Server:] Gracz %s zosta³ ostrze¿ony przez: %s, powód: %s", PlayerName(id), kto, powod);
	SendClientMessageToAll(B, chat);
	GraczInfo[id][gWarn] += 1;
	if(GraczInfo[id][gWarn] >= 5)
	{
	    BanES(id, "eSystem", "otrzymanie pi¹tego ostrze¿enia");
	}
	ZapiszGracza(id);
	return 1;
}

UnWarnES(id, kto[], powod[])
{
	new chat[128];
	format(chat, sizeof(chat), "[Eagle Server:] %s usun¹³ ostrze¿enie graczowi %s, powód: %s", kto, PlayerName(id), powod);
	SendClientMessageToAll(B, chat);
	GraczInfo[id][gWarn] -= 1;
	return 1;
}

MuteES(id, kto[], powod[])
{
	new chat[128];
	format(chat, sizeof(chat), "[Eagle Server:] Gracz %s zosta³ uciszony przez: %s, powód: %s", PlayerName(id), kto, powod);
	SendClientMessageToAll(B, chat);
	GraczInfo[id][gMute] = 1;
	return 1;
}

UnMuteES(id, kto[], powod[])
{
	new chat[128];
	format(chat, sizeof(chat), "[Eagle Server:] Gracz %s zosta³ odciszony przez: %s, powód: %s", PlayerName(id), kto, powod);
	SendClientMessageToAll(B, chat);
	GraczInfo[id][gMute] = 0;
	return 1;
}

AdminES(atekst[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		format(query, sizeof(query), "%s", atekst);
		if(GraczInfo[i][gAdmin] >= 1)
		{
			SendClientMessage(i, ADMIN, atekst);
		}
	}
	return 1;
}

PwES(playerid, id, tresc[])
{
	new g,m,s;
	gettime(g,m,s);
	format(query, sizeof(query), "[%d:%d:%d PW do %s:] %s", g,m,s,PlayerName(id), tresc);
	SendClientMessage(playerid, PW, query);
	format(query, sizeof(query), "[%d:%d:%d PW od %s:] %s", g,m,s,PlayerName(playerid), tresc);
	SendClientMessage(id, PW, query);
	return 1;
}

forward PD(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
public PD(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
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
				GetPlayerPos(i, posx, posy, posz);
				tempposx = (oldposx -posx);
				tempposy = (oldposy -posy);
				tempposz = (oldposz -posz);
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
		}
	}
	return 1;
}

stock cformat(COLOR)
{
	new str[9];
	COLOR = COLOR >>> 8;

	if (COLOR > 0x0FFFFF){
	    format(str, 9, "{%x}",COLOR);
	}else if (COLOR < 0x100000 && COLOR > 0x0FFFFF){
	    format(str, 9, "{0%x}", COLOR);
	}else if (COLOR < 0x010000 && COLOR > 0x000FFF){
	    format(str, 9, "{00%x}", COLOR);
	}else if (COLOR < 0x001000 && COLOR > 0x0000FF){
	    format(str, 9, "{000%x}", COLOR);
	}else if (COLOR < 0x000100 && COLOR > 0x00000F){
	    format(str, 9, "{0000%x}", COLOR);
	}else if (COLOR < 0x000010 && COLOR > 0x000000){
	    format(str, 9, "{00000%x}", COLOR);
	}
	return str;
}

ZapiszGracza(playerid)
{
	new zapis_danych[2048];
	format(zapis_danych, sizeof(zapis_danych), "UPDATE `gracze` SET `admin`='%d', `premium`='%d',`warn`='%d', `ban`='%d', `kasa='%d'`, `bank`='%d', `poziom`='%d', `exp`='%d', `wexp`='%d', `zabojstw`='%d', `smierci`='%d', `pktdr`='%d', `pktr`='%d', `skill`='%d', `skill1`='%d', `skill2`='%d', `skill3`='%d', `skill4`='%d', `skill5`='%d', `skill6`='%d', `skill7`='%d', `skill8`='%d', `skill9`='%d', `skill10`='%d', `skill11`='%d', `skill12`='%d', `skill13`='%d', `skill14`='%d' WHERE `login`='%s'",
	GraczInfo[playerid][gAdmin],
	GraczInfo[playerid][gPremium],
	GraczInfo[playerid][gWarn],
	GraczInfo[playerid][gBan],
	GraczInfo[playerid][gKasa],
	GraczInfo[playerid][gBank],
	GraczInfo[playerid][gPoziom],
	GraczInfo[playerid][gExp],
	GraczInfo[playerid][gWexp],
	GraczInfo[playerid][gZabojstw],
	GraczInfo[playerid][gSmierci],
	GraczInfo[playerid][gPktdr],
	GraczInfo[playerid][gPktr],
    GraczInfo[playerid][gSkill],
    GraczInfo[playerid][gSkill1],
    GraczInfo[playerid][gSkill2],
    GraczInfo[playerid][gSkill3],
    GraczInfo[playerid][gSkill4],
    GraczInfo[playerid][gSkill5],
    GraczInfo[playerid][gSkill6],
    GraczInfo[playerid][gSkill7],
    GraczInfo[playerid][gSkill8],
    GraczInfo[playerid][gSkill9],
    GraczInfo[playerid][gSkill10],
    GraczInfo[playerid][gSkill11],
    GraczInfo[playerid][gSkill12],
    GraczInfo[playerid][gSkill13],
    GraczInfo[playerid][gSkill14],
	PlayerName(playerid)
	);
	mysql_query(zapis_danych);
	mysql_free_result();
	format(zapis_danych, sizeof(zapis_danych), "UPDATE `gracze` SET `pskill`='%d', `pskill1`='%d', `pskill2`='%d', `pskill3`='%d', `pskill4`='%d', `pskill5`='%d', `pskill6`='%d', `pskill7`='%d', `pskill8`='%d', `pskill9`='%d' WHERE `login`='%s'",
	GraczInfo[playerid][gPskill],
	GraczInfo[playerid][gPskill1],
	GraczInfo[playerid][gPskill2],
	GraczInfo[playerid][gPskill3],
	GraczInfo[playerid][gPskill4],
	GraczInfo[playerid][gPskill5],
	GraczInfo[playerid][gPskill6],
	GraczInfo[playerid][gPskill7],
	GraczInfo[playerid][gPskill8],
	GraczInfo[playerid][gPskill9],
	PlayerName(playerid));
	mysql_query(zapis_danych);
	mysql_free_result();
	return 1;
}

forward WczytajPojazdy();
public WczytajPojazdy()
{
	new ile = 0;
	new vid = 1;
	print("[tPSystem:] Zaczynam wczytywac pojazdy...");
	mysql_query("SELECT * FROM `pojazdy`");
	mysql_store_result();
	vid++;
	while(mysql_fetch_row_format(fetch, "|"))
	{
	    new uid;
	    sscanf(fetch, "p<|>d", uid);
	    sscanf(fetch, "p<|>ddffffdddddd",
	    uid,
		PojazdInfo[uid][pmodel],
		PojazdInfo[uid][x],
		PojazdInfo[uid][y],
		PojazdInfo[uid][z],
		PojazdInfo[uid][a],
		PojazdInfo[uid][pkolor],
		PojazdInfo[uid][pkolor1],
		PojazdInfo[uid][ptyp],
		PojazdInfo[uid][pfid],
		PojazdInfo[uid][pidowner],
		PojazdInfo[uid][pcena]);
		PojazdInfo[uid][pID] = uid;
		if(PojazdInfo[uid][pmodel] != 0)
		{
		    new pointer = CreateVehicleFromDB(uid);
		    printf("[tPSystem:]sampid: %d | tPSuid: %d | model: %d | kolorid: %d | kolorid: %d", pointer, PojazdInfo[uid][pID], PojazdInfo[uid][pmodel], PojazdInfo[uid][pkolor], PojazdInfo[uid][pkolor1]);
		}
		ile++;
	}
	mysql_free_result();
	printf("[tPSystem:] %d pojazd(ow) wczytanych", ile);
	return 1;
}

forward CreateVehicleFromDB(uid);
public CreateVehicleFromDB(uid)
{
	new pointer = CreateVehicle(PojazdInfo[uid][pmodel], PojazdInfo[uid][x], PojazdInfo[uid][y], PojazdInfo[uid][z], PojazdInfo[uid][a], PojazdInfo[uid][pkolor], PojazdInfo[uid][pkolor1], -1);
	PojazdInfo[pointer][pID] = uid;
	return pointer;
}

forward BankTD(playerid);
public BankTD(playerid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    format(query, sizeof(query), "$%d", GraczInfo[playerid][gBank]);
	    TextDrawSetString(bank[i], query);
	    TextDrawShowForPlayer(playerid, bank[i]);
	}
	return 1;
}

DestroyNeon(vehicleid)
{
	if(vNeon[vehicleid][0] != -1)
	{
		DestroyObject(vNeon[vehicleid][0]);
		vNeon[vehicleid][0] = -1;
	}
	if(vNeon[vehicleid][1] != -1)
	{
		DestroyObject(vNeon[vehicleid][1]);
		vNeon[vehicleid][1] = -1;
	}
	return 1;
}

ListaSkilli(playerid)
{
	format(tekst, sizeof(tekst), "[%d/%d]Lista umiejêtnoœci:", GraczInfo[playerid][gPktdr], GraczInfo[playerid][gPktr]);
	format(fetch, sizeof(fetch), "%s1.%sGangster(%d)\n%s2.%sObroñca(%d)\n%s3.%sPolicjant(%d)\n%s4.%sHandlarz(%d)\n%s5.%sAntyterrorysta(%d)\n%s6.%sTerrorysta(%d)\n%s7.%s¯o³nierz(%d)\n%s8.%sSnajper(%d)\n%s9.%sStalowe ¿ebra(%d)\n%s10.%sSamurai(%d)\n%s11.%sKibol(%d)\n%s12.%sPrzedsiêbiorca(%d)\n%s13.%sWeteran(%d)\n%s14.%sKulturysta(%d)\n%s15.%sSokole oko(%d)\n%s16%sPremium",
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill1],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill2],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill3],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill4],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill5],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill6],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill7],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill8],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill9],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill10],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill11],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill12],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill13],
	cformat(CF),
	cformat(WHITE),
	GraczInfo[playerid][gSkill14],
	cformat(CF),
	cformat(WHITE));
	ShowPlayerDialog(playerid, LSKILL, DIALOG_STYLE_LIST, tekst, fetch, "Awansuj", "Anuluj");
	return 1;
}

forward DodajAuto(model, Float:vx, Float:vy, Float:vz, Float:va, kolor, kolor1, typ, fid, idowner, cena);
public DodajAuto(model, Float:vx, Float:vy, Float:vz, Float:va, kolor, kolor1, typ, fid, idowner, cena)
{
	format(fetch, sizeof(fetch), "INSERT INTO `pojazdy` (`model`, `x`, `y`, `z`, `a`, `kolor`, `kolor1`, `typ`, `fid`, `idowner`, `cena`) VALUES ('%d', '%f', '%f', '%f', '%f', '%d', '%d', '%d', '%d', '%d', '%d')",
	model,
	vx,
	vy,
	vz,
	va,
	kolor,
	kolor1,
	typ,
	fid,
	idowner,
	cena);
	mysql_query(fetch);
	new vehicleid = mysql_insert_id();
	PojazdInfo[vehicleid][pID] = vehicleid;
	PojazdInfo[vehicleid][pmodel] = model;
	PojazdInfo[vehicleid][x] = vx;
	PojazdInfo[vehicleid][y] = vy;
	PojazdInfo[vehicleid][z] = vz;
	PojazdInfo[vehicleid][a] = va;
	PojazdInfo[vehicleid][pkolor] = kolor;
	PojazdInfo[vehicleid][pkolor1] = kolor1;
	PojazdInfo[vehicleid][ptyp] = typ;
	PojazdInfo[vehicleid][pfid] = fid;
	PojazdInfo[vehicleid][pidowner] = idowner;
	PojazdInfo[vehicleid][pcena] = cena;
	mysql_free_result();
	return vehicleid;
}

forward ZapiszAuto(vehicleid);
public ZapiszAuto(vehicleid)
{
	format(fetch, sizeof(fetch), "UPDATE `pojazdy` SET `model`='%d', `kolor`='%d', `kolor1`='%d', `typ`='%d', `fid`='%d', `idowner`='%d', `cena`='%d' WHERE `id`='%d'",
	PojazdInfo[vehicleid][pmodel],
	PojazdInfo[vehicleid][pkolor],
	PojazdInfo[vehicleid][pkolor1],
	PojazdInfo[vehicleid][ptyp],
	PojazdInfo[vehicleid][pfid],
	PojazdInfo[vehicleid][pidowner],
	PojazdInfo[vehicleid][pcena],
	vehicleid);
	mysql_query(fetch);
	mysql_free_result();
	return 1;
}

forward ZapiszPozycjeAuta(vehicleid);
public ZapiszPozycjeAuta(vehicleid)
{
	new Float:vx, Float:vy, Float:vz, Float:va;
	GetVehiclePos(vehicleid, vx, vy, vz);
	format(tekst, sizeof(tekst), "UPDATE `pojazdy` SET `x`='%f', `y`='%f', `z`='%f', `a`='%f' WHERE `id`='%d'",
	vx,
	vy,
	vz,
	va,
	vehicleid);
	mysql_query(tekst);
	mysql_free_result();
	return 1;
}

/*
do zrobienia

wexp,exp,lvl

reg,log,save

payday


PayDay obliczanie wyp³aty

ka¿dy: 450$
za ka¿dy level gracz dostaje dodatkowe 25$
konto premium dostaje dodatkowe 300$ do wyp³aty

Pomys³y na dodatkowe prace:
1. Mechanik
2. Lekarz

Pomys³y na dodatkowe biznesy:

1.Lichwiarz

*/

//============[SYSTEM RELATED MESSAGE DEFINES]========
#define BUSINESS_TYPES "1: Restaurant - 2: Phone - 3: 24-7 - 4: Ammunation - 5: Advertising - 6: Clothes Store - 7. Bar/Club"
#define BUSINESS_TYPES2 " "
//====================================================

#include <a_samp>
#include <core>
#include <float>
#include <time>
#include <file>
#include <Dini>
#include <a_mysql>
#include <md5>
#include <sscanf2>

#define logowanie   7552
#define rejestracja 7661
#define wiek        8313
#define plec        1664

new db[128];
new db2[256];

#include "moduly/header.inc"

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

public OnGameModeInit()
{
	for(new c=0;c<MAX_VEHICLES;c++)
	{
		Fuel[c] = GasMax;
		EngineStatus[c] = 0;
		VehicleLocked[c] = 0;
		CarWindowStatus[c] = 1; //1 = up, 0 = down.
	}
	ShowPlayerMarkers(0);
	EnableStuntBonusForAll(0); //Disable stunt bonus.
    DisableInteriorEnterExits();//Disable Yellow Markers.
    AllowInteriorWeapons(1);//Allowing weapons inside.
	EnableTirePopping(1);
	EnableZoneNames(1);
	AllowAdminTeleport(1);
	UsePlayerPedAnims();
	LoadScript();
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
	SetTimer("UpdateData", 5000, 1);//Updates scores, and syncs time of day
	SetTimer("Update", 300000, 1);//Update every 5 minutes
	SetTimer("UpdateMoney", 1000, 1);//AntiMoney hack timer
	SetTimer("PickupGametexts", 1000, 1); //Timer that shows gametexts if the player is on a pickup/location.
	SetTimer("FuelTimer", 15000, 1); //Car Fuel System
	SetTimer("OtherTimer", 15000, 1);
	SetTimer("JailTimer", 1000, 1);
	SetTimer("StreamPickups",1000,1);//Streaming pickups
	mysql_connect("localhost", "admin", "classic", "admin");
	if(mysql_ping() == 1)
	{
	    print("[MySQL]Polaczono");
	}
	else
	{
	     print("[MySQL]Brak polaczenia");
	}
	SendRconCommand("mapname FortCarson[PL][RPG]");
	SendRconCommand("gamemodetext PS-RPG v1");
	return 1;
}

public OnGameModeExit()
{
	mysql_close();
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(getPlayerOnDB(playerid))
	{
	    ShowPlayerDialog(playerid, logowanie, DIALOG_STYLE_PASSWORD, "Logowanie", "Witaj!\nKonto o takim nicku istnieje juz w naszej bazie danych.\nPodaj do niego has³o.", "Zaloguj", "Anuluj");
	}
	else
	{
	    ShowPlayerDialog(playerid, rejestracja, DIALOG_STYLE_PASSWORD, "Rejestracja", "Witaj!\nRejestracja na serwerze wymaga podania has³a, podaj je i przejdŸ dalej.", "Dalej", "Anuluj");
	}
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
	        Kick(playerid);
			return 1;
	    }
		SendClientMessage(playerid,COLOR_RED,"[INFO:] Musisz siê zalogowaæ przed spawnem!");
		SpawnAttempts[playerid] ++;
		return 0;
	}
}

public OnPlayerConnect(playerid)
{
	ResetStats(playerid);//Setting variables to 0.
	ClearScreen(playerid);//Clearing the users screen from SA-MP messages.
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
					Kick(playerid);
					format(string, sizeof(string), "[INFO:] System has kicked %s, Reason: Killing an administrator on duty with abuse. ", PlayerName(killerid));
					KickLog(string);
				}
		    }
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
	new string[128];
	new tmp[128];
	
	if(Muted[playerid])
	{
		SendClientMessage(playerid, COLOR_RED, "[ERROR:] Nie mo¿esz pisaæ, jesteœ uciszony.");
		return 0;
	}
	//=================================[PASSWORD]======================================
 	new idx;
	tmp = strtok(text, idx);
 	if((strcmp("(", tmp, true, strlen(tmp)) == 0) && (strlen(tmp) == strlen("(")))
	{
	    if(text[1] != 0)
	    {
		    format(string, sizeof(string), "(( [OOC:] %s mówi: %s ))", PlayerName(playerid),text[1]);
			ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
			OOCLog(string);
	   		return 0;
   		}
	}
	if(Mobile[playerid] != 255)
	{
		format(string, sizeof(string), "[Telefon] %s mówi: %s", GetPlayerNameEx(playerid), text);
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
					SendClientMessage(Mobile[playerid], COLOR_LIGHTGREEN,string);
					SendClientMessage(playerid, COLOR_LIGHTGREEN,string);
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
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2,"[ERROR:] Nie ma nikogo na linii.");
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

// modu³ rejestracji,logowania,zapisu danych gracza

public OnPlayerRegister(playerid, password[])
{
	if(strlen(password) < 4 || strlen(password) > 24)
	    return ShowPlayerDialog(playerid, rejestracja, DIALOG_STYLE_PASSWORD, "Rejestracja", "Has³o musi byæ ci¹giem znaków w przedziale 4-24!\nPodaj ponownie has³o!", "Dalej", "Anuluj");
	    
	format(db, sizeof(db), "INSERT INTO `accounts` (`login`, `haslo`) values ('%s', '%s')", PlayerName(playerid), password);
	mysql_query(db);
	mysql_free_result();
	return 1;
}
public OnPlayerLogin(playerid,password[])
{
	return 1;
}
public OnPlayerDataSave(playerid)
{
	return 1;
}

// koniec modu³u
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
				
				}
				else
				{
					SendClientMessage(i,COLOR_LIGHTYELLOW2,"[INFO:] Nie dostaniesz wyp³aty, za ma³o gra³eœ(aœ).");
				}
			}
			else
			{
				SendClientMessage(i,COLOR_LIGHTYELLOW2,"[INFO:] Nie jesteœ zalogowany, wyp³ata przepada.");
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
	new string[128];
	if(VehicleLocked[vehicleid])
	{
		new Float:playerposx, Float:playerposy, Float:playerposz;
		GetPlayerPos(playerid, playerposx, playerposy, playerposz);
		if(PlayerInfo[playerid][pAdmin] == 0)
		{
			SetPlayerPos(playerid,playerposx, playerposy, playerposz);
		}
		SendClientMessage(playerid,COLOR_WHITE,"[VEHICLE:] Pojazd zamkniêty.");
	}
	if(DynamicCars[vehicleid-1][CarType] == 1)
	{
		if(TakingDrivingTest[playerid] != 1)
		{
			new Float:playerposx, Float:playerposy, Float:playerposz;
			GetPlayerPos(playerid, playerposx, playerposy, playerposz);
			if(PlayerInfo[playerid][pAdmin] == 0)
			{
   				SetPlayerPos(playerid,playerposx, playerposy, playerposz);
			}
			SendClientMessage(playerid,COLOR_WHITE,"[ERROR:] Nie zdajesz egzaminu na prawo jazdy!");
		}
	}
    if(DynamicCars[vehicleid-1][FactionCar] != 255)
	{
	    if(DynamicFactions[DynamicCars[vehicleid-1][FactionCar]][fType] == 1)
	    {
	        if(PlayerInfo[playerid][pFaction] != DynamicCars[vehicleid-1][FactionCar])
	        {
	            new Float:playerposx, Float:playerposy, Float:playerposz;
				GetPlayerPos(playerid, playerposx, playerposy, playerposz);
	  			if(PlayerInfo[playerid][pAdmin] == 0)
				{
					SetPlayerPos(playerid,playerposx, playerposy, playerposz);
				}
	        }
	    }
		format(string, sizeof(string), "[FACTION:] Ten pojazd nale¿y do %s.",DynamicFactions[DynamicCars[vehicleid-1][FactionCar]][fName]);
		SendClientMessage(playerid,COLOR_WHITE, string);
	}
	if(IsAPlane(vehicleid) || IsAHelicopter(vehicleid))
 	{
		new Float:playerposx, Float:playerposy, Float:playerposz;
		GetPlayerPos(playerid, playerposx, playerposy, playerposz);
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
				SendClientMessage(playerid,COLOR_GREEN,"[STATUS:] Silnik zgaszony.");
				TogglePlayerControllable(playerid,0);
			}
			else
			{
			    SendClientMessage(playerid,COLOR_GREEN,"[STATUS:] Nie pozostawiaj pojazdu z odpalonym silnikiem, ca³y czas maleje jego stan paliwa.");
			}
		}
	    if(DynamicCars[GetPlayerVehicleID(playerid)-1][FactionCar] != 255)
		{
		    if(DynamicFactions[DynamicCars[GetPlayerVehicleID(playerid)-1][FactionCar]][fType] == 1)
		    {
		        if(PlayerInfo[playerid][pFaction] != DynamicCars[GetPlayerVehicleID(playerid)-1][FactionCar])
		        {
					RemoveDriverFromVehicle(playerid);
		        }
		    }
		}
	    if(PlayerInfo[playerid][pCarLic] == 0 && IsAPlane(GetPlayerVehicleID(playerid))==0 && IsAHelicopter(GetPlayerVehicleID(playerid))==0)
	    {
	    	SendClientMessage(playerid,COLOR_WHITE,"[INFO:] Jedziesz bez pozwolenia, uwa¿aj na policje.");
	    }
		new updatedvehicleid = GetPlayerVehicleID(playerid) - 1;
		if(DynamicCars[updatedvehicleid][CarType] == 1)
		{
			if(TakingDrivingTest[playerid] == 1)
			{
				SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] JedŸ do pierwszego punktu.");

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

				    if(health >= 800.0)
				    {
				    	SendClientMessage(playerid,COLOR_GREEN,"[INFO:] Gratulacje, zda³eœ.");
				    	PlayerInfo[playerid][pCarLic] = 1;
				    	OnPlayerDataSave(playerid);
				    	SetVehicleToRespawn(veh);
				    	TakingDrivingTest[playerid] = 0;
			    	 	DisablePlayerCheckpoint(playerid);
				    }
				    else
				    {
						SendClientMessage(playerid,COLOR_RED,"[INFO:] Obla³eœ, spróbuj ponownie.");
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
			GameTextForPlayer(playerid, "~r~Crash...~n~~g~powrot do poprzedniej pozycji.", 7000, 6);
			return 1;
		}
	    if(AdminDuty[playerid])
	    {
	    	SetPlayerColor(playerid,COLOR_ADMINDUTY);
			SetPlayerHealth(playerid,99999);
			SetPlayerArmour(playerid,99999);
	    }
	    if(PlayerInfo[playerid][pFaction] != 255)
	    {
			SetPlayerToFactionColor(playerid);
			SetPlayerToFactionSkin(playerid);
     	}
   		if(PlayerInfo[playerid][pJailed] == 1)
		{
		    SetPlayerVirtualWorld(playerid,2); //BUILDING ID 2, MAKE SURE PD IS ID 2
		    SetPlayerInterior(playerid, 6);
			SetPlayerPos(playerid,264.5743,77.5118,1001.0391);
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[ERROR:] Nie odsiedzia³eœ wszystkiego!");
			return 1;
		}
	    new house = PlayerInfo[playerid][pHouseKey];
   		if(house != 255)
		{
		    if(PlayerInfo[playerid][pSpawnPoint])
		    {
				SetPlayerInterior(playerid,Houses[house][ExitInterior]);
				SetPlayerPos(playerid, Houses[house][ExitX], Houses[house][ExitY],Houses[house][ExitZ]);
				SetPlayerVirtualWorld(playerid,house);
    			return 1;
			}
		}
  		if(PlayerInfo[playerid][pFaction] != 255)
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
	new coordsstring[512];
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
public LoadDynamicCars()
{
	new arrCoords[9][64];
	new strFromFile2[256];
	new File: file = fopen("CRP_Scriptfiles/Cars/carspawns.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(DynamicCars))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			DynamicCars[idx][CarModel] = strval(arrCoords[0]);
			DynamicCars[idx][CarX] = floatstr(arrCoords[1]);
			DynamicCars[idx][CarY] = floatstr(arrCoords[2]);
			DynamicCars[idx][CarZ] = floatstr(arrCoords[3]);
			DynamicCars[idx][CarAngle] = floatstr(arrCoords[4]);
			DynamicCars[idx][CarColor1] = strval(arrCoords[5]);
			DynamicCars[idx][CarColor2] = strval(arrCoords[6]);
			DynamicCars[idx][FactionCar] = strval(arrCoords[7]);
			DynamicCars[idx][CarType] = strval(arrCoords[8]);
			
			new vehicleid = CreateVehicle(DynamicCars[idx][CarModel],DynamicCars[idx][CarX],DynamicCars[idx][CarY],DynamicCars[idx][CarZ],DynamicCars[idx][CarAngle],DynamicCars[idx][CarColor1],DynamicCars[idx][CarColor2], -1);

			if(DynamicCars[idx][FactionCar] != 255)
			{
				SetVehicleNumberPlate(vehicleid, DynamicFactions[DynamicCars[idx][FactionCar]][fName]);
				SetVehicleToRespawn(vehicleid);
			}
			idx++;
		}
		fclose(file);
	}
	return 1;
}
public SaveDynamicCars()
{
	new idx;
	new File: file2;
	while (idx < sizeof(DynamicCars))
	{

		new coordsstring[512];
		format(coordsstring, sizeof(coordsstring), "%d|%f|%f|%f|%f|%d|%d|%d|%d\n",
		DynamicCars[idx][CarModel],
		DynamicCars[idx][CarX],
		DynamicCars[idx][CarY],
		DynamicCars[idx][CarZ],
		DynamicCars[idx][CarAngle],
		DynamicCars[idx][CarColor1],
		DynamicCars[idx][CarColor2],
		DynamicCars[idx][FactionCar],
		DynamicCars[idx][CarType]);

		if(idx == 0)
		{
			file2 = fopen("CRP_Scriptfiles/Cars/carspawns.cfg", io_write);
		}
		else
		{
			file2 = fopen("CRP_Scriptfiles/Cars/carspawns.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
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
public ShowStats(playerid,targetid) // statystyki
{
	return 1;
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
	format(string,sizeof(string),"%s has been kicked by %s, Reason: %s ",GetPlayerNameEx(playerid),kickedby,reason);
	SendClientMessageToAll(COLOR_ADMINCMD,string);
	KickLog(string);
	return Kick(playerid);
}
public BanPlayerAccount(playerid,bannedby[MAX_PLAYER_NAME],reason[])
{
	new string[128];
	format(string,sizeof(string),"%s has been Account-Banned by %s, Reason: %s ",GetPlayerNameEx(playerid),bannedby,reason);
	SendClientMessageToAll(COLOR_ADMINCMD,string);
	AccountBanLog(string);
	PlayerInfo[playerid][pBanned] = 1;
	OnPlayerDataSave(playerid);
	return Kick(playerid);
}
public BanPlayer(playerid,bannedby[MAX_PLAYER_NAME],reason[])
{
	new string[128];
	format(string,sizeof(string),"%s has been banned by %s, Reason: %s ",GetPlayerNameEx(playerid),bannedby,reason);
	SendClientMessageToAll(COLOR_ADMINCMD,string);
	BanLog(string);
	return Ban(playerid);
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
					    	format(string, sizeof(string), "%s~n~~w~Koszt wejscia: ~g~$%d",Building[h][BuildingName],Building[h][EntranceFee]);
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
         					format(string, sizeof(string), "%s~n~~w~Koszt wejscia: ~r~$%d",Building[h][BuildingName],Building[h][EntranceFee]);
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
								format(string, sizeof(string), "~g~This house is for sale!~n~~w~Adres: ~y~ %d %s~n~~w~Opis: ~y~%s ~n~~w~Cena: ~y~$%d~n~%s",n,houselocation,Houses[n][Description],Houses[n][HousePrice]);
						    	GameTextForPlayer(i, string, 3500, 3);
							}
							else
							{
							    if(Houses[n][Rentable] == 1)
							    {
		   							new houselocation[MAX_ZONE_NAME];
									GetCoords2DZone(Houses[n][EnterX],Houses[n][EnterY], houselocation, MAX_ZONE_NAME);
			    					format(string, sizeof(string), "~w~Adres: ~y~%d %s~n~~w~wlasciciel: ~y~%s ~n~~w~Opis: ~y~%s~n~~w~Cena wynajmu: ~y~$%d",n,houselocation,Houses[n][Owner],Houses[n][Description],Houses[n][RentCost]);
							    	GameTextForPlayer(i, string, 3500, 3);
							    }
							    else
							    {
		  							new houselocation[MAX_ZONE_NAME];
									GetCoords2DZone(Houses[n][EnterX],Houses[n][EnterY], houselocation, MAX_ZONE_NAME);
			    					format(string, sizeof(string), "~w~Adres: ~y~%d %s~n~~w~Wlasciciel: ~y~%s ~n~~w~Opis: ~y~%s",n,houselocation,Houses[n][Owner],Houses[n][Description]);
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
						    else if(Businesses[n][BizType] == 3) { businesstype = "24-7"; }
						    else if(Businesses[n][BizType] == 4) { businesstype = "Ammunation"; }
						    else if(Businesses[n][BizType] == 5) { businesstype = "Ogloszenia"; }
						    else if(Businesses[n][BizType] == 6) { businesstype = "Ubrania"; }
						    else if(Businesses[n][BizType] == 7) { businesstype = "Bar/Club"; }
					    }
					    else { businesstype = "None Set"; }
					    
					    if(Businesses[n][BizPrice] != 0) //Only show the business if price is set
					    {
						    if(Businesses[n][Owned] == 0)
						    {
								format(string, sizeof(string), "~g~Ten biznes jest na sprzedaz!~n~~w~Nazwa: ~y~%s ~n~~w~Typ: ~y~%s ~n~~w~Cena: ~y~$%d",Businesses[n][BusinessName],businesstype,Businesses[n][BizPrice]);
						    	GameTextForPlayer(i, string, 3500, 3);
							}
							else
							{
	  							format(string, sizeof(string), "~w~Nazwa: ~y~%s ~n~~w~Typ: ~y~%s ~n~~w~Wlasciciel: ~y~%s~n~~w~Cena wejscia: ~y~$%d",Businesses[n][BusinessName],businesstype,Businesses[n][Owner],Businesses[n][EntranceCost]);
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
	   	    					format(form, sizeof(form), "~w~~n~~n~~n~~n~~n~~n~~y~Silnik odpalony.~n~~w~Paliwo:~g~ %d%~n~~r~malo paliwa.",Fuel[vehicle]);
		    					GameTextForPlayer(i,form,1000,5);
	    				    }
	    				    else
	    				    {
	   	    					format(form, sizeof(form), "~w~~n~~n~~n~~n~~n~~n~~y~Silnik zgaszony.~n~~w~Paliwo:~g~ %d%~n~~r~malo paliwa.",Fuel[vehicle]);
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
	  							format(form, sizeof(form), "~w~~n~~n~~n~~n~~n~~n~~y~Silnik zgaszony.~n~~w~Paliwo:~g~ %d%",Fuel[vehicle]);
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
						GameTextForPlayer(i, "~w~Prawo jazdy~n~Cena: ~g~$500~n~~w~Wpisz /pj", 3500, 3);
					}
				}
				else if(PlayerToPoint(1.0, i,FlyingTestPosition[X],FlyingTestPosition[Y],FlyingTestPosition[Z]))
				{
    				if(GetPlayerVirtualWorld(i) == FlyingTestPosition[World])
	     			{
						GameTextForPlayer(i, "~w~Licencja pilota~n~Cena: ~g~$20000~n~~w~Wpisz /lp", 3500, 3);
					}
				}
				else if(PlayerToPoint(1.0, i,WeaponLicensePosition[X],WeaponLicensePosition[Y],WeaponLicensePosition[Z]))
				{
    				if(GetPlayerVirtualWorld(i) == WeaponLicensePosition[World])
	     			{
						GameTextForPlayer(i, "~w~Pozwolenie na bron~n~Cena: ~g~$50000~n~~w~Wpisz /pnb", 3500, 3);
					}
				}
				else if(PlayerToPoint(1.0, i,BankPosition[X],BankPosition[Y],BankPosition[Z]))
				{
    				if(GetPlayerVirtualWorld(i) == BankPosition[World])
	     			{
						GameTextForPlayer(i, "~w~Bank", 3500, 3);
					}
				}
    			else if(PlayerToPoint(1.0, i,GunJob[TakeJobX],GunJob[TakeJobY],GunJob[TakeJobZ]))
				{
				    if(GetPlayerVirtualWorld(i) == GunJob[TakeJobWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Diler broni~n~~w~/wezprace", 3500, 3);
   					}
				}
				else if(PlayerToPoint(1.0, i,GunJob[BuyPackagesX],GunJob[BuyPackagesY],GunJob[BuyPackagesZ]))
				{
				    if(GetPlayerVirtualWorld(i) == GunJob[BuyPackagesWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Materialy na bron~n~~w~/materialy kup", 3500, 3);
   					}
				}
    			else if(PlayerToPoint(1.0, i,GunJob[DeliverX],GunJob[DeliverY],GunJob[DeliverZ]))
				{
				    if(GetPlayerVirtualWorld(i) == GunJob[DeliverWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Diler broni~n~~w~/materialy dostarcz", 3500, 3);
   					}
				}
 				else if(PlayerToPoint(1.0, i,DrugJob[TakeJobX],DrugJob[TakeJobY],DrugJob[TakeJobZ]))
				{
				    if(GetPlayerVirtualWorld(i) == DrugJob[TakeJobWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Diler dragow~n~~w~/wezprace", 3500, 3);
   					}
				}
				else if(PlayerToPoint(1.0, i,DrugJob[BuyDrugsX],DrugJob[BuyDrugsY],DrugJob[BuyDrugsZ]))
				{
				    if(GetPlayerVirtualWorld(i) == DrugJob[BuyDrugsWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Diler dragow~n~~w~/dragi kup", 3500, 3);
   					}
				}
    			else if(PlayerToPoint(1.0, i,DrugJob[DeliverX],DrugJob[DeliverY],DrugJob[DeliverZ]))
				{
				    if(GetPlayerVirtualWorld(i) == DrugJob[DeliverWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Diler dragow~n~~w~/dragi dostarcz", 3500, 3);
   					}
				}
				else if(PlayerToPoint(1.0, i,DetectiveJobPosition[X],DetectiveJobPosition[Y],DetectiveJobPosition[Z]))
				{
				    if(GetPlayerVirtualWorld(i) == DetectiveJobPosition[World])
				    {
   						GameTextForPlayer(i, "~n~~r~Detektyw~n~~w~/wezprace", 3500, 3);
   					}
				}
    			else if(PlayerToPoint(1.0, i,LawyerJobPosition[X],LawyerJobPosition[Y],LawyerJobPosition[Z]))
				{
				    if(GetPlayerVirtualWorld(i) == LawyerJobPosition[World])
				    {
   						GameTextForPlayer(i, "~n~~r~Adwokat~n~~w~/wezprace", 3500, 3);
   					}
				}
				else if(PlayerToPoint(1.0, i,ProductsSellerJob[TakeJobX],ProductsSellerJob[TakeJobY],ProductsSellerJob[TakeJobZ]))
				{
				    if(GetPlayerVirtualWorld(i) == ProductsSellerJob[TakeJobWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Dostawca~n~~w~/wezprace", 3500, 3);
   					}
				}
				else if(PlayerToPoint(1.0, i,ProductsSellerJob[BuyProductsX],ProductsSellerJob[BuyProductsY],ProductsSellerJob[BuyProductsZ]))
				{
				    if(GetPlayerVirtualWorld(i) == ProductsSellerJob[BuyProductsWorld])
				    {
   						GameTextForPlayer(i, "~n~~r~Dostawca~n~~w~/kupprodukty", 3500, 3);
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
		        	GameTextForPlayer(i,"~r~Brak paliwa!",1500,3);
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
				SendClientMessage(i, COLOR_LIGHTYELLOW2,"[INFO:] Jesteœ wolny.");
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
	SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] Naæpa³eœ siê!");
 	SetPlayerWeather(playerid, 500);
    ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1,1,1,1,1,1);
    SetTimerEx("UndrugEffect", 8000, false, "i", playerid);
	return 1;
}
public UndrugEffect(playerid)
{
	SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] Ju¿ nie jesteœ naæpany!");
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
	    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] Jesteœ zakuty.");
	    TogglePlayerControllable(playerid,1);
	    PlayerTazed[playerid] = 0;
	    PlayerActionMessage(playerid,15.0,"jest zakuty w kajdanki.");
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
		    SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[INFO:] Ju¿ nie namierzasz gracza.");
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
	SaveDynamicCars();
	SaveCivilianSpawn();
	SaveBuildings();
	SaveHouses();
	SaveBusinesses();
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

stock getPlayerOnDB(playerid)
{
	format(db, sizeof(db), "SELECT `id` FROM `accounts` WHERE `login`='%s'", PlayerName(playerid));
	mysql_query(db);
	mysql_store_result();
	if(!mysql_num_rows())
 	return 0;

 	mysql_free_result();
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case logowanie:
	    {
	        switch(response)
	        {
	            case 0:
	                return Kick(playerid);
	                
				case 1:
    			{
    				mysql_reconnect();
    			    format(db, sizeof(db), "SELECT `haslo` FROM `accounts` WHERE `login`='%s'", PlayerName(playerid));
    			    mysql_query(db);
    			    mysql_store_result();
    			    mysql_fetch_row_format("|", db2);
    			    sscanf(db2, "p<|>s[24]", PlayerInfo[playerid][pKey]);
    			    printf("Haslo %s - %s", PlayerInfo[playerid][pKey], inputtext);
    			    mysql_free_result();
    				if(!strcmp(inputtext, PlayerInfo[playerid][pKey],true))
					{
						mysql_free_result();
						format(db2, sizeof(db2), "SELECT `id`, `level`, `admin`, `donaterank`, `exp`, `wexp`, `cash`, `bank`, `skin`, `drugs`, `materials` FROM `accounts` WHERE `login`='%s' LIMIT='1'", PlayerName(playerid));
						mysql_query(db2);
						mysql_store_result();
						mysql_fetch_row_format("|", db2);
						sscanf(db2, "p<|>ddddddddddd",
						PlayerInfo[playerid][pId],
						PlayerInfo[playerid][pLevel],
						PlayerInfo[playerid][pAdmin],
						PlayerInfo[playerid][pDonateRank],
						PlayerInfo[playerid][pExp],
						PlayerInfo[playerid][pWexp],
						PlayerInfo[playerid][pCash],
						PlayerInfo[playerid][pBank],
						PlayerInfo[playerid][pSkin],
						PlayerInfo[playerid][pDrugs],
						PlayerInfo[playerid][pMaterials]);
						mysql_free_result();
						format(db2, sizeof(db2), "SELECT `job`, `playinghours`, `allowedpayday`, `paycheck`, `faction`, `rank`, `housekey`, `bizkey`, `spawnpoint`, `banned`, `warnings`, `carlic`, `flylic`, `weplic` WHERE `login`='%s' LIMIT='1'", PlayerName(playerid));
						mysql_query(db2);
						mysql_store_result();
						mysql_fetch_row_format("|", db2);
						sscanf(db2, "p<|>dddddddddddddd",
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
						PlayerInfo[playerid][pWepLic]);
						mysql_free_result();
						format(db2, sizeof(db2), "SELECT `donator`, `jailed`, `jailtime`, `products`, `crashx`, `crashy`, `crashz`, `crashint`, `crashw`, `crashed` FROM `accounts` WHERE `login`='%s' LIMIT='1'", PlayerName(playerid));
						mysql_query(db2);
						mysql_store_result();
						mysql_fetch_row_format("|", db2);
						sscanf(db2, "p<|>ddddfffddd",
						PlayerInfo[playerid][pDonator],
						PlayerInfo[playerid][pJailed],
						PlayerInfo[playerid][pJailTime],
						PlayerInfo[playerid][pProducts],
						PlayerInfo[playerid][pCrashX],
						PlayerInfo[playerid][pCrashY],
						PlayerInfo[playerid][pCrashZ],
						PlayerInfo[playerid][pCrashW],
						PlayerInfo[playerid][pCrashInt],
						PlayerInfo[playerid][pCrashed]);
						mysql_free_result();
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
 								Kick(playerid);
						}
						SetPlayerCash(playerid,PlayerInfo[playerid][pCash]);
						SendClientMessage(playerid, COLOR_YELLOW2, "[INFO:] Zalogowano pomyœlnie.");
						gPlayerLogged[playerid] = 1;
						SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin],CivilianSpawn[X],CivilianSpawn[Y],CivilianSpawn[Z],0,0,0,0,0,0,0);
						SpawnPlayer(playerid);
						return 1;
					}
					else
					{
						mysql_free_result();
	    				ShowPlayerDialog(playerid, logowanie, DIALOG_STYLE_PASSWORD, "Logowanie", "Poda³eœ b³edne has³o, spróbuj jeszcze raz!", "Zaloguj", "Anuluj");
					}
				}
			}
		}
		case rejestracja:
		{
		    switch(response)
		    {
		    	case 0:
      				return Kick(playerid);

				case 1:
   					return OnPlayerRegister(playerid, inputtext);
			}
		}
	}
	return 1;
}


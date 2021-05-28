--
-- Plik wygenerowany przez SQLiteStudio v3.0.3 dnia Pt lut 27 08:44:50 2015
--
-- U¿yte kodowanie tekstu: windows-1250
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Tabela: players
CREATE TABLE players (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, login VARCHAR (24) NOT NULL, haslo VARCHAR (24) NOT NULL, kasa INT (9) NOT NULL DEFAULT (1500), exp INT (9) NOT NULL DEFAULT (0), wexp INT (9) NOT NULL DEFAULT (4), level INT (9) NOT NULL DEFAULT (1), ranga INT (1) NOT NULL DEFAULT (0), rangaf INT (4) DEFAULT (0) NOT NULL, skin INT (3) NOT NULL DEFAULT (72), gx DOUBLE NOT NULL DEFAULT (0), gy DOUBLE NOT NULL DEFAULT (0), gz DOUBLE NOT NULL DEFAULT (0), ga DOUBLE NOT NULL DEFAULT (0), ghp DOUBLE NOT NULL DEFAULT (100), garmor DOUBLE NOT NULL DEFAULT (0), praca INT (1) NOT NULL DEFAULT (0), materialy INT (9) NOT NULL DEFAULT (0), dragi INT (9) NOT NULL DEFAULT (0), prawko INT (1) NOT NULL DEFAULT (0), pilotaz INT (1) NOT NULL DEFAULT (0), motor INT (1) NOT NULL DEFAULT (0), lickabron INT (1) NOT NULL DEFAULT (0), fid INT (5) NOT NULL DEFAULT (0))
INSERT INTO players (id, login, haslo, kasa, exp, wexp, level, ranga, rangaf, skin, gx, gy, gz, ga, ghp, garmor, praca, materialy, dragi, prawko, pilotaz, motor, lickabron, fid) VALUES (1, 'AdminTest', 'qwerty', 1500, 0, 4, 1, 0, 0, 72, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0);

COMMIT TRANSACTION;

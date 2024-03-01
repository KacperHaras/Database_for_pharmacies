DROP TABLE IF EXISTS pracownik_apteka CASCADE;--
DROP TABLE IF EXISTS magazyny_leki CASCADE;--
DROP TABLE IF EXISTS recepty_leki CASCADE;--
DROP TABLE IF EXISTS leki CASCADE;--
DROP TABLE IF EXISTS recepty CASCADE;--
DROP TABLE IF EXISTS rezerwacje CASCADE;--
DROP TABLE IF EXISTS magazyny CASCADE;--
DROP TABLE IF EXISTS apteki CASCADE;--
DROP TABLE IF EXISTS pacjenci CASCADE;--
DROP TABLE IF EXISTS pojazdy CASCADE;--
DROP TABLE IF EXISTS pracownicy CASCADE;--

CREATE table apteki(
    apteka_id serial PRIMARY KEY,
    adres varchar(100) NOT NULL,
    liczba_pracownikow int NOT NULL
);--

CREATE table magazyny(
    apteka_id int PRIMARY KEY,
    osoba_nadzorujaca_id int,
    wielkosc float
);--

CREATE table leki(
    lek_id serial PRIMARY KEY,
    nazwa varchar(100) NOT NULL,
    cena float NOT NULL
);--

CREATE table magazyny_leki(
    magazyny_leki_id serial PRIMARY KEY,
    apteka_id int,
    lek_id int,
    ilosc int,
    data_waznosci date NOT NULL,
    FOREIGN KEY (apteka_id) REFERENCES apteki(apteka_id),
    FOREIGN KEY (lek_id) REFERENCES leki(lek_id)
);--

CREATE table pacjenci(
    pacjent_id serial PRIMARY KEY,
    imie varchar(100) NOT NULL,
    nazwisko varchar(100) NOT NULL,
    pesel varchar(100) NOT NULL,
    wiek int NOT NULL
);--

CREATE table recepty(
    recepta_id serial PRIMARY KEY,
    kod_recepty varchar(100) NOT NULL,
    apteka_realizujaca int NOT NULL,
    pacjent_realizujacy int NOT NULL,
    FOREIGN KEY (pacjent_realizujacy) REFERENCES pacjenci(pacjent_id),
    FOREIGN KEY (apteka_realizujaca) REFERENCES apteki(apteka_id)
);--

CREATE table pojazdy(
    pojazd_id serial PRIMARY KEY,
    rejestracja varchar(20) NOT NULL,
    marka varchar(20) NOT NULL
);--
            
CREATE table pracownicy(
    pracownik_id serial PRIMARY KEY,
    imie varchar(100) NOT NULL,
    nazwisko varchar(100) NOT NULL,
    data_zatrudnienia date NOT NULL,
    plec char(1) NOT NULL,
    stanowisko varchar(100) NOT NULL,
    pojazd_id int,
    FOREIGN KEY (pojazd_id) REFERENCES pojazdy(pojazd_id)
);--

CREATE TABLE rezerwacje (
    rezerwacja_id serial PRIMARY KEY,
    pracownik_id int NOT NULL,
    pojazd_id int NOT NULL,
    data_rozpoczecia date NOT NULL,
    data_zakonczenia date NOT NULL,
    FOREIGN KEY (pracownik_id) REFERENCES pracownicy(pracownik_id),
    FOREIGN KEY (pojazd_id) REFERENCES pojazdy(pojazd_id)
);--

CREATE table pracownik_apteka(
    pracownik_id int NOT NULL,
    apteka_id int NOT NULL,
    FOREIGN KEY (pracownik_id) REFERENCES pracownicy(pracownik_id),
    FOREIGN KEY (apteka_id) REFERENCES apteki(apteka_id)
);--

CREATE table recepty_leki(
    recepta_id int NOT NULL,
    lek_id int NOT NULL,
    FOREIGN KEY (recepta_id) REFERENCES recepty(recepta_id),
    FOREIGN KEY (lek_id) REFERENCES leki(lek_id)
);--
          


INSERT INTO apteki (adres, liczba_pracownikow) VALUES ('ul. Kolorowa 1, 32-300 Olkusz', 6);--
INSERT INTO apteki (adres, liczba_pracownikow) VALUES ('ul. Wesola 2, 32-300 Olkusz', 5);--
INSERT INTO apteki (adres, liczba_pracownikow) VALUES ('ul. Czerwona 3, 32-300 Olkusz', 5);--
INSERT INTO apteki (adres, liczba_pracownikow) VALUES ('ul. Niebieska 4, 32-300 Olkusz', 4);--


INSERT INTO pojazdy (rejestracja, marka) VALUES ('KOL6RL90', 'Iveco');--
INSERT INTO pojazdy (rejestracja, marka) VALUES ('KOL09236', 'Opel');--
INSERT INTO pojazdy (rejestracja, marka) VALUES ('KR543GT', 'Ford');--
INSERT INTO pojazdy (rejestracja, marka) VALUES ('KR1GU45', 'Fiat');--
INSERT INTO pojazdy (rejestracja, marka) VALUES ('KR1GK45', 'Fiat');--
INSERT INTO pojazdy (rejestracja, marka) VALUES ('KR1GT65', 'Fiat');--
INSERT INTO pojazdy (rejestracja, marka) VALUES ('KRU12P5', 'Wolksvagen');--

INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Jan', 'Kowalski', '2019-01-01', 'M', 'Magister farmacji', 3);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Anna', 'Nowak', '2016-01-01', 'K', 'Magister farmacji', 3);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Krystyna', 'Kowalczyk', '2022-08-11', 'K', 'Magister farmacji', null );--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Maria', 'Dabrowski', '2020-06-06', 'K', 'Magister farmacji', 4);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Maria', 'Wojcik', '2014-12-25', 'K', 'Magister farmacji', 5);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Malgorzata', 'Kowalczyk', '2021-01-01', 'K', 'Magister farmacji', null);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Ewa', 'Kaminski', '2014-09-01', 'K', 'Magister farmacji', 6);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Ewa', 'Zielinski', '2014-01-01', 'K', 'Technik farmacji', 3);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Elzbieta', 'Nowak', '2014-05-01', 'K', 'Technik farmacji', null);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Anna', 'Kowalski', '2018-08-01', 'K', 'Technik farmacji', 3);--

INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Malgorzata', 'Baran', '2021-03-01', 'K', 'Technik farmacji', null);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Barbara', 'Dabrowski', '2014-08-01', 'K', 'Technik farmacji', 4);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Maria', 'Lewandowski', '2020-10-05', 'K', 'Technik farmacji', 4);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Anna', 'Kowalski', '2014-03-01', 'K', 'Technik farmacji', null);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Ewa', 'Kowalczyk', '2015-11-01', 'K', 'Technik farmacji', 5);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Zofia', 'Szymanski', '2021-12-14', 'K', 'Technik farmacji', null);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Agata', 'Kowal', '2015-01-01', 'K', 'Technik farmacji', 5);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Monika', 'Puszek', '2018-06-01', 'K', 'Technik farmacji', null);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Katarzyna', 'Mocna', '2012-06-01', 'K', 'Technik farmacji', 6);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Wiktoria', 'Nowak', '2014-05-01', 'K', 'Technik farmacji', 6);--

INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Adam', 'Bedkowski', '2014-01-01', 'M', 'Kierowca', 1);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Stanislaw', 'Kucharski', '2017-01-01', 'M', 'Kierowca', 2);--
INSERT INTO pracownicy (imie, nazwisko, data_zatrudnienia, plec, stanowisko, pojazd_id) VALUES ('Jan', 'Maczka', '2014-01-01', 'M', 'Koordynator', 7);--

INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (1, 1);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (2, 1);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (8, 1);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (9, 1);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (10, 1);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (11, 1);--

INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (3, 2);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (4, 2);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (12, 2);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (13, 2);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (14, 2);--

INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (5, 3);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (6, 3);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (15, 3);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (16, 3);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (17, 3);--

INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (7, 4);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (18, 4);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (19, 4);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (20, 4);--

INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (21, 1);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (21, 2);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (22, 3);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (22, 4);--

INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (23, 1);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (23, 2);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (23, 3);--
INSERT INTO pracownik_apteka (pracownik_id, apteka_id) VALUES (23, 4);--



INSERT INTO magazyny (apteka_id, osoba_nadzorujaca_id, wielkosc) VALUES (1, 2, 37.7);--
INSERT INTO magazyny (apteka_id, osoba_nadzorujaca_id, wielkosc) VALUES (2, 4, 24.4);--
INSERT INTO magazyny (apteka_id, osoba_nadzorujaca_id, wielkosc) VALUES (3, 5, 15.5);--
INSERT INTO magazyny (apteka_id, osoba_nadzorujaca_id, wielkosc) VALUES (4, 7, 12.2);--




INSERT INTO pacjenci (imie, nazwisko, pesel, wiek) VALUES ('Jan', 'Apostol', '17895023461', 50);--
INSERT INTO pacjenci (imie, nazwisko, pesel, wiek) VALUES ('Hanna', 'Karton', '15786234902', 34);--
INSERT INTO pacjenci (imie, nazwisko, pesel, wiek) VALUES ('Justyna', 'Kowalczyk', '12052612903', 23);--
INSERT INTO pacjenci (imie, nazwisko, pesel, wiek) VALUES ('Michal', 'Michalski', '13456827904', 19);--
INSERT INTO pacjenci (imie, nazwisko, pesel, wiek) VALUES ('Andrzej', 'Doda', '35349612101', 44);--


INSERT INTO recepty (kod_recepty, apteka_realizujaca, pacjent_realizujacy) VALUES ('1346', 1, 1);--
INSERT INTO recepty (kod_recepty, apteka_realizujaca, pacjent_realizujacy) VALUES ('3357', 1, 2);--
INSERT INTO recepty (kod_recepty, apteka_realizujaca, pacjent_realizujacy) VALUES ('1256', 1, 2);--
INSERT INTO recepty (kod_recepty, apteka_realizujaca, pacjent_realizujacy) VALUES ('1236', 2, 3);--
INSERT INTO recepty (kod_recepty, apteka_realizujaca, pacjent_realizujacy) VALUES ('6734', 3, 4);--
INSERT INTO recepty (kod_recepty, apteka_realizujaca, pacjent_realizujacy) VALUES ('8763', 3, 4);--
INSERT INTO recepty (kod_recepty, apteka_realizujaca, pacjent_realizujacy) VALUES ('5334', 4, 5);--



INSERT INTO leki (nazwa, cena) VALUES ('Apap', 8.99);--
INSERT INTO leki (nazwa, cena) VALUES ('Ibuprom', 14.49);--
INSERT INTO leki (nazwa, cena) VALUES ('Paracetamol', 7.99);--
INSERT INTO leki (nazwa, cena) VALUES ('Amol', 12.00);--
INSERT INTO leki (nazwa, cena) VALUES ('Aspiryna', 14.00);--
INSERT INTO leki (nazwa, cena) VALUES ('Nurofen', 16.55);--
INSERT INTO leki (nazwa, cena) VALUES ('Gripex', 13.99);--
INSERT INTO leki (nazwa, cena) VALUES ('ACC', 10.40);--
INSERT INTO leki (nazwa, cena) VALUES ('Neo-Angin', 11.25);--
INSERT INTO leki (nazwa, cena) VALUES ('Cholinex', 10.50);--
INSERT INTO leki (nazwa, cena) VALUES ('Acatar', 10.99);--
INSERT INTO leki (nazwa, cena) VALUES ('Rutinoscorbin', 9.99);--




INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (1, 1);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (1, 2);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (1, 5);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (1, 9);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (2, 5);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (2, 7);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (2, 8);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (3, 9);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (3, 2);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (3, 11);--

INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (4, 3);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (4, 2);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (4, 5);--

INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (5, 1);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (5, 5);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (5, 7);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (6, 12);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (6, 11);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (6, 4);--

INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (7, 1);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (7, 9);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (7, 8);--
INSERT INTO recepty_leki (recepta_id, lek_id) VALUES (7, 5);--

INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 1, 100, '2026-11-01');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 2, 120, '2023-01-15');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 3, 50, '2024-08-11');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 4, 120, '2028-06-21');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 5, 100, '2025-03-01');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 6, 160, '2026-11-01');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 7, 130, '2023-01-15');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 8, 100, '2024-08-11');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 9, 30, '2028-06-21');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 10, 90, '2025-03-01');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 11, 100, '2026-11-01');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (1, 12, 120, '2023-01-15');--

INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 1, 170, '2026-04-17');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 2, 160, '2023-03-13');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 3, 100, '2026-10-29');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 4, 60, '2026-05-28');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 5, 150, '2026-05-29');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 6, 100, '2023-08-15');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 7, 140, '2024-06-23');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 8, 60, '2026-10-05');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 9, 170, '2024-05-11');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 10, 170, '2026-07-15');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 11, 170, '2023-03-12');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (2, 12, 180, '2023-03-27');--

INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 1, 90, '2023-04-20');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 2, 120, '2024-07-18');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 3, 50, '2023-06-11');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 4, 140, '2023-10-19');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 5, 150, '2024-12-28');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 6, 100, '2026-02-12');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 7, 60, '2026-03-16');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 8, 130, '2026-01-19');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 9, 100, '2024-05-06');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 10, 170, '2026-12-01');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 11, 70, '2024-06-02');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (3, 12, 190, '2026-03-09');--

INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 1, 160, '2026-01-21');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 2, 100, '2026-04-06');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 3, 150, '2026-05-02');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 4, 70, '2024-07-22');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 5, 120, '2026-12-10');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 6, 120, '2023-10-06');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 7, 120, '2024-08-08');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 8, 190, '2025-05-30');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 9, 120, '2023-01-16');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 10, 200, '2025-04-30');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 11, 70, '2024-06-02');--
INSERT INTO magazyny_leki (apteka_id, lek_id, ilosc, data_waznosci) VALUES (4, 12, 190, '2026-03-09');--


INSERT INTO rezerwacje (pracownik_id, pojazd_id, data_rozpoczecia, data_zakonczenia) VALUES (23, 7, '2018-06-01', '2028-03-01');--
INSERT INTO rezerwacje (pracownik_id, pojazd_id, data_rozpoczecia, data_zakonczenia) VALUES (21, 1, '2020-06-03', '2025-03-01');--
INSERT INTO rezerwacje (pracownik_id, pojazd_id, data_rozpoczecia, data_zakonczenia) VALUES (22, 2, '2022-08-05', '2025-03-01');--

INSERT INTO rezerwacje (pracownik_id, pojazd_id, data_rozpoczecia, data_zakonczenia) VALUES (1, 4, '2024-01-07', '2024-01-08');--
INSERT INTO rezerwacje (pracownik_id, pojazd_id, data_rozpoczecia, data_zakonczenia) VALUES (1, 4, '2024-01-09', '2024-01-10');--
INSERT INTO rezerwacje (pracownik_id, pojazd_id, data_rozpoczecia, data_zakonczenia) VALUES (10, 4, '2024-01-11', '2024-01-12');--
INSERT INTO rezerwacje (pracownik_id, pojazd_id, data_rozpoczecia, data_zakonczenia) VALUES (14, 5, '2024-01-11', '2024-01-12');--
INSERT INTO rezerwacje (pracownik_id, pojazd_id, data_rozpoczecia, data_zakonczenia) VALUES (17, 6, '2024-01-11', '2024-01-13');--
INSERT INTO rezerwacje (pracownik_id, pojazd_id, data_rozpoczecia, data_zakonczenia) VALUES (15, 6, '2024-01-15', '2024-01-16');--


CREATE OR REPLACE VIEW podsumowanie_recepty AS
SELECT 
    pacjenci.imie, 
    pacjenci.nazwisko, 
    pacjenci.pesel, 
    recepty.kod_recepty, 
    recepty.apteka_realizujaca,
    sum(leki.cena) as rachunek,
    STRING_AGG(leki.nazwa, ', ') as lista_lekow
FROM 
    recepty 
JOIN 
    recepty_leki ON recepty.recepta_id = recepty_leki.recepta_id
JOIN 
    leki ON recepty_leki.lek_id = leki.lek_id
JOIN 
    pacjenci ON pacjenci.pacjent_id = recepty.pacjent_realizujacy
GROUP BY 
    recepty.recepta_id, 
    pacjenci.imie, 
    pacjenci.nazwisko, 
    pacjenci.pesel,
    recepty.apteka_realizujaca;--

CREATE OR REPLACE VIEW podsumowanie_rezerwacji AS
SELECT 
    pracownicy.imie, 
    pracownicy.nazwisko,
    pracownicy.stanowisko,
    pojazdy.marka, 
    pojazdy.rejestracja, 
    rezerwacje.data_rozpoczecia, 
    rezerwacje.data_zakonczenia,
	apteki.apteka_id
FROM 
    rezerwacje
JOIN 
    pracownicy ON rezerwacje.pracownik_id = pracownicy.pracownik_id
JOIN 
    pojazdy ON rezerwacje.pojazd_id = pojazdy.pojazd_id
JOIN
    pracownik_apteka ON pracownicy.pracownik_id = pracownik_apteka.pracownik_id
JOIN
    apteki ON pracownik_apteka.apteka_id = apteki.apteka_id;--

CREATE OR REPLACE VIEW podsumowanie_pracownikow AS
SELECT imie, nazwisko, plec, data_zatrudnienia,apteki.apteka_id, stanowisko, 
                        CASE 
                            WHEN pojazd_id IS NOT NULL THEN 'Tak'
                            ELSE 'Nie'
                        END as dostęp_do_auta_służbowego FROM pracownicy 
                    JOIN pracownik_apteka
                    ON pracownicy.pracownik_id = pracownik_apteka.pracownik_id
                    JOIN apteki
                    ON pracownik_apteka.apteka_id = apteki.apteka_id;--


CREATE OR REPLACE VIEW podsumowanie_magazynu AS
SELECT magazyny.apteka_id as numer_apteki, CONCAT(pracownicy.imie,' ',pracownicy.nazwisko) as osoba_nadzorujaca, leki.nazwa, magazyny_leki.ilosc, leki.cena FROM magazyny
JOIN magazyny_leki
ON magazyny.apteka_id=magazyny_leki.apteka_id
JOIN leki
ON leki.lek_id=magazyny_leki.lek_id
JOIN pracownicy
ON pracownicy.pracownik_id=magazyny.osoba_nadzorujaca_id;--




    
CREATE OR REPLACE FUNCTION check_recepty_kod() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM recepty WHERE kod_recepty = NEW.kod_recepty) THEN
        RAISE EXCEPTION 'Kod recepty % juz istnieje w tabeli recepty', NEW.kod_recepty;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;--

CREATE TRIGGER recepty_kod_trigger
BEFORE INSERT ON recepty
FOR EACH ROW
EXECUTE PROCEDURE check_recepty_kod();--



CREATE OR REPLACE FUNCTION check_rezerwacje_data() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM rezerwacje 
        WHERE pojazd_id = NEW.pojazd_id
        AND (
            (NEW.data_rozpoczecia BETWEEN data_rozpoczecia AND data_zakonczenia) 
            OR 
            (NEW.data_zakonczenia BETWEEN data_rozpoczecia AND data_zakonczenia)
            OR 
            (data_rozpoczecia BETWEEN NEW.data_rozpoczecia AND NEW.data_zakonczenia)
        )
    ) THEN
        RAISE EXCEPTION 'Samochod % jest juz zarezerwowany w wybranym okresie', NEW.pojazd_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;--

CREATE TRIGGER rezerwacje_data_trigger
BEFORE INSERT OR UPDATE ON rezerwacje
FOR EACH ROW
EXECUTE PROCEDURE check_rezerwacje_data();--



CREATE OR REPLACE FUNCTION check_dostepnosc_auta() RETURNS TRIGGER AS $$
DECLARE
  pracownik_pojazd_id INT;
BEGIN
  SELECT pojazd_id INTO pracownik_pojazd_id FROM pracownicy WHERE pracownik_id = NEW.pracownik_id;

  IF pracownik_pojazd_id IS NULL THEN
    RAISE EXCEPTION 'Pracownik nie ma przypisanego pojazdu słuzbowego.';
  END IF;

  IF NEW.pojazd_id != pracownik_pojazd_id THEN
    RAISE EXCEPTION 'ID pojazdu nie zgadza sie z pojazdem przypisanym do pracownika.';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;--

CREATE TRIGGER check_dostepnosc_auta_trigger
BEFORE INSERT ON rezerwacje
FOR EACH ROW EXECUTE PROCEDURE check_dostepnosc_auta();--


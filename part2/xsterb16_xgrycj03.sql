-- Autor: Marek Sterba xsterb16@stud.fit.vutbr.cz
-- Autor: Jakub Gryc xgrycj03@stud.fit.vutbr.cz

-- Smazani tabulek

drop table zamestnanec_pracuje_v_kavarne;
drop table uzivatel_oblibena_kavarna;
drop table kavarna_nabizi_kavu;
drop table uzivatel_ohodnotil_reakci;
drop table uzivatel_ohodnotil_recenzi;
drop table reakce;
drop table zamestnanec;
drop table recenze;
drop table uzivatel;
drop table osoba;
drop table kava;
drop table kavarna;

-- Vytvoreni tabulek

create table osoba(
    id_osoby int primary key,
    jmeno nvarchar2(255) not null,
    prijmeni nvarchar2(255) not null,
    datum_narozeni date not null,
    telefon nvarchar2(14) not null check ( regexp_like(telefon, '^(\+[0-9]{12})|([0-9]{9})$')),
    email nvarchar2(255) not null check ( regexp_like(email, '^[a-z0-9.-_]+@[a-z0-9.-_]+]\.[a-z]+]$'))
);

create table zamestnanec(
    id_osoby int primary key references osoba(id_osoby) on delete cascade,
    pozice nvarchar2(255) not null check ( pozice in ('majitel', 'barista', 'cisnik', 'kuchar'))
);

create table uzivatel(
    id_osoby int primary key references osoba(id_osoby) on delete cascade,
    oblibeny_druh_kavy nvarchar2(255) not null,
    oblibeny_druh_pripravy nvarchar2(255) not null,
    kav_denne int not null check (kav_denne >= 0)
);

create table kavarna(
    id_kavarny int primary key not null,
    nazev nvarchar2(255) not null,
    mesto nvarchar2(255) not null,
    psc nvarchar2(255) not null,
    ulice nvarchar2(255) not null,
    cislo_popisne  nvarchar2(255) not null,
    kapacita int not null check (kapacita > 0),
    popis nvarchar2(1023) not null,
    cas_otevreni nvarchar2(5) not null,
    cas_zavreni nvarchar2(5) not null
);

create table recenze(
    id_recenze int primary key not null,
    datum_vytvoreni date not null,
    pocet_hvezdicek int check ((pocet_hvezdicek <= 5) and (pocet_hvezdicek >= 1)),
    text_recenze nvarchar2(1023) not null,
    palce_nahoru int not null check (palce_nahoru >= 0),
    palce_dolu int not null check (palce_dolu >= 0),
    id_uzivatele int not null references uzivatel(id_osoby), -- vztah uzivatel napsal recenzi
    id_kavarny int not null references kavarna(id_kavarny) -- kavarna, na kterou je recenze napsana
);

create table reakce(
    id_reakce int primary key,
    text_reakce nvarchar2(1023) not null,
    palce_nahoru int not null check (palce_nahoru >= 0),
    palce_dolu int not null check (palce_dolu >= 0),
    id_zamestnance int not null references zamestnanec(id_osoby), -- vztah zamestnanec napsal reakci
    id_recenze int not null references recenze(id_recenze) -- recenze, na kterou reakce odpovida
);

create table kava(
    nazev nvarchar2(255) primary key not null,
    oblast_puvodu nvarchar2(255) not null,
    popis_chuti nvarchar2(255) not null,
    zpusob_pripravy nvarchar2(255) not null
);

-- Vytvoreni vztahu n:m

create table uzivatel_ohodnotil_recenzi(
    id_uzivatele int not null references uzivatel(id_osoby),
    id_recenze int not null references recenze(id_recenze),
    primary key(id_uzivatele, id_recenze)
);

create table uzivatel_ohodnotil_reakci(
    id_uzivatele int not null references uzivatel(id_osoby),
    id_reakce int not null references reakce(id_reakce),
    primary key(id_uzivatele, id_reakce)
);

create table uzivatel_oblibena_kavarna(
    id_kavarny int not null references kavarna(id_kavarny),
    id_uzivatele int not null references uzivatel(id_osoby),
    primary key(id_kavarny, id_uzivatele)
);

create table kavarna_nabizi_kavu(
    id_kavarny int not null references kavarna(id_kavarny),
    nazev_kavy nvarchar2(255) not null references kava(nazev),
    primary key (id_kavarny, nazev_kavy)
);

create table zamestnanec_pracuje_v_kavarne(
    id_kavarny int not null references kavarna(id_kavarny),
    id_zamestnance int not null references zamestnanec(id_osoby),
    primary key (id_kavarny, id_zamestnance)
);
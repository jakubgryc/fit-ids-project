-- Autor: Marek Sterba xsterb16@stud.fit.vutbr.cz
-- Autor: Jakub Gryc xgrycj03@stud.fit.vutbr.cz

-- Smazani tabulek

drop table zamestnanec;
drop table uzivatel;
drop table osoba;
drop table reakce;
drop table recenze;
drop table kava;
drop table kavarna;

-- Vytvoreni tabulek

create table osoba(
    id_uzivatele int primary key,
    jmeno nvarchar2(255) not null,
    prijmeni nvarchar2(255) not null,
    datum_narozeni date not null,
    telefon nvarchar2(14) not null check ( regexp_like(telefon, '^(\+[0-9]{12})|([0-9]{9})$')),
    email nvarchar2(255) not null check ( regexp_like(email, '^[a-z0-9.-_]+@[a-z0-9.-_]+]\.[a-z]+]$'))
);

create table zamestnanec(
    id_uzivatele int primary key references osoba(id_uzivatele) on delete cascade,
    pozice nvarchar2(255) not null check ( pozice in ('majitel', 'barista', 'cisnik', 'kuchar'))
);

create table uzivatel(
    id_uzivatele int primary key references osoba(id_uzivatele) on delete cascade,
    oblibeny_druh_kavy nvarchar2(255) not null,
    oblibeny_druh_pripravy nvarchar2(255) not null,
    kav_denne int not null check (kav_denne >= 0)
);

create table recenze(
    id_recenze int primary key not null,
    datum_vytvoreni date not null,
    pocet_hvezdicek int check ((pocet_hvezdicek <= 5) and (pocet_hvezdicek >= 1)),
    text_recenze nvarchar2(1023) not null,
    palce_nahoru int not null check (palce_nahoru >= 0),
    palce_dolu int not null check (palce_dolu >= 0)
);

create table reakce(
    id_reakce int primary key,
    id_recenze int,
    foreign key (id_recenze) references recenze(id_recenze),
    text_reakce nvarchar2(1023) not null,
    palce_nahoru int not null check (palce_nahoru >= 0),
    palce_dolu int not null check (palce_dolu >= 0)
);

create table kava(
    nazev nvarchar2(255) primary key not null,
    oblast_puvodu nvarchar2(255) not null,
    popis_chuti nvarchar2(255) not null,
    zpusob_pripravy nvarchar2(255) not null
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

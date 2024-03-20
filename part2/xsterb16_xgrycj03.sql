-- Autor: Marek Sterba xsterb16@stud.fit.vutbr.cz
-- Autor: Jakub Gryc xgrycj03@stud.fit.vutbr.cz

-- Smazani tabulek

-- drop table Zamestnanec;
-- drop table Uzivatel;
-- drop table Reakce;
-- drop table Recenze;
-- drop table Kava;
-- drop table Kavarna;
-- drop table Osoba;

-- Vytvoreni tabulek

create table Osoba(
    ID_uzivatele int primary key,
    Jmeno nvarchar2(255) not null,
    Prijmeni nvarchar2(255) not null,
    Datum_narozeni date not null,
    Telefon nvarchar2(14) not null check ( regexp_like(Telefon, '^(\+[0-9]{12})|([0-9]{9})$')),
    Email nvarchar2(255) not null check ( regexp_like(Email, '^[a-z0-9.-_]+@[a-z0-9.-_]+]\.[a-z]+]$'))
);

create table Zamestnanec(
    ID_uzivatele int primary key references Osoba(ID_uzivatele) on delete cascade,
    Pozice nvarchar2(255) not null check ( Pozice in ('Majitel', 'Barista', 'Číšník', 'Kuchař'))
);

create table Uzivatel(
    ID_uzivatele int primary key references Osoba(ID_uzivatele) on delete cascade,
    Oblibeny_druh_kavy nvarchar2(255) not null,
    Oblibeny_druh_pripravy nvarchar2(255) not null,
    Kav_denne int not null check (Kav_denne >= 0)
);

create table Kavarna(
                        ID_kavarny int primary key not null,
                        Nazev nvarchar2(255) not null,
                        Mesto nvarchar2(255) not null,
                        PSC nvarchar2(255) not null,
                        Ulice nvarchar2(255) not null,
                        Cislo_popisne  nvarchar2(255) not null,
                        Kapacita int not null check (Kapacita > 0),
                        Popis nvarchar2(1023) not null,
                        Cas_otevreni nvarchar2(5) not null,
                        Cas_zavreni nvarchar2(5) not null
);

create table Kava(
                     Nazev nvarchar2(255) primary key not null,
                     Oblast_puvodu nvarchar2(255) not null,
                     Popis_chuti nvarchar2(255) not null,
                     Zpusob_pripravy nvarchar2(255) not null
);

create table Recenze(
    ID_recenze int primary key not null,
    ID_kavarny int,
    ID_uzivatele int,
    foreign key (ID_uzivatele) references Uzivatel(ID_uzivatele),
    foreign key (ID_kavarny) references Kavarna(ID_kavarny),
    Datum_vytvoreni date not null,
    Pocet_hvezdicek int check ((Pocet_hvezdicek <= 5) and (Pocet_hvezdicek >= 1)),
    Text_recenze nvarchar2(1023) not null,
    Palce_nahoru int not null check (Palce_nahoru >= 0),
    Palce_dolu int not null check (Palce_dolu >= 0)
);

create table Reakce(
    ID_reakce int primary key,
    ID_recenze int,
    ID_uzivatele int,
    foreign key (ID_uzivatele) references Zamestnanec(ID_uzivatele),
    foreign key (ID_recenze) references Recenze(ID_recenze),
    Text_reakce nvarchar2(1023) not null,
    Palce_nahoru int not null check (Palce_nahoru >= 0),
    Palce_dolu int not null check (Palce_dolu >= 0)
);



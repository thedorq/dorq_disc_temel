create table disc_inventory
(
    id int auto_increment
        primary key,
    owner text not null,
    type text null,
    data longtext not null
);

create table disc_inventory_itemdata
(
    id bigint unsigned auto_increment,
    name text not null,
    description text null,
    weight int default 0 not null,
    closeonuse tinyint(1) default 0 not null,
    max int default 100 not null,
    constraint id
        unique (id)
);


create table disc_ammo
(
    id bigint unsigned auto_increment PRIMARY KEY,
    owner text not null,
    hash text not null,
    count int default 0 not null,
    constraint id
        unique (id)
);

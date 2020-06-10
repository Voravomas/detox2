DROP TABLE IF EXISTS alcoholic;
CREATE TABLE alcoholic(
alcoholic_id serial not null,
first_name varchar,
last_name varchar,
PRIMARY KEY (alcoholic_id)
);


DROP TABLE IF EXISTS bed;
CREATE TABLE bed(
bed_id serial not null,
PRIMARY KEY (bed_id)
);

DROP TABLE IF EXISTS inspector;
CREATE TABLE inspector(
inspector_id serial not null,
first_name varchar,
last_name varchar,
PRIMARY KEY (inspector_id)
);


/*
 IF INSPECTOR FREED IS NULL AND date_left not null -> ESCAPED
 if from_bed_id null -> just entered
 INSPECTOR PUTS ON BED AS SOON AS CATCHES
 */
DROP TABLE IF EXISTS registry;
CREATE TABLE registry(
alcoholic_id int not null,
inspector_id_brought int,
inspector_id_freed int,
date_entered date,
date_left date,
from_bed_id int,
to_bed_id int,
FOREIGN KEY (alcoholic_id) REFERENCES alcoholic (alcoholic_id),
FOREIGN KEY (inspector_id_brought) REFERENCES inspector (inspector_id),
FOREIGN KEY (inspector_id_freed) REFERENCES inspector (inspector_id),
FOREIGN KEY (from_bed_id) REFERENCES bed (bed_id),
FOREIGN KEY (to_bed_id) REFERENCES bed (bed_id)
);


DROP TABLE IF EXISTS drink;
CREATE TABLE drink(
drink_id serial not null,
drink_name varchar not null,
PRIMARY KEY (drink_id)
);

DROP TABLE IF EXISTS song;
CREATE TABLE song(
song_id serial not null,
song_name varchar,
PRIMARY KEY (song_id)
);

DROP TABLE IF EXISTS party;
CREATE TABLE party(
party_id serial not null,
date_happened date not null,
drink_id int,
song_id int,
PRIMARY KEY (party_id),
FOREIGN KEY (drink_id) REFERENCES drink (drink_id),
FOREIGN KEY (song_id) REFERENCES song (song_id)
);

DROP TABLE IF EXISTS party_id_alcoholic_id;
CREATE TABLE party_id_alcoholic_id(
party_id int not null,
alcoholic_id int not null,
FOREIGN KEY (party_id) REFERENCES party (party_id),
FOREIGN KEY (alcoholic_id) REFERENCES alcoholic (alcoholic_id)
);

DROP TABLE IF EXISTS faints;
CREATE TABLE faints(
alcoholic_id int not null,
date_happened date not null,
bed_id int not null,
FOREIGN KEY (bed_id) REFERENCES bed (bed_id),
FOREIGN KEY (alcoholic_id) REFERENCES alcoholic (alcoholic_id)
);

DROP TABLE IF EXISTS viewers;
CREATE TABLE viewers(
v_id serial,
v_name varchar not null,
v_login varchar not null,
v_password varchar not null,
v_permission varchar not null,
PRIMARY KEY (v_id)
);


--inserts

INSERT INTO viewers (v_name, v_login, v_password, v_permission) VALUES
('Ivan', 'john', 'jjj', 'viewer'),
('Petro', 'pet', '007', 'lord' );

INSERT INTO alcoholic (first_name, last_name) VALUES
('Ivasyk', 'Tekesyk'),
('Pasha', 'Derevo'),
('Olesia', 'Dobie'),
('Richard','Dickson'),
('Lil', 'Peep'),
('Austin', 'Post'),
('John', 'Snow'),
('Travis','Barker'),
('Colson','Baker'),
('Koza', 'Dereza');



INSERT INTO bed values(default); 
INSERT INTO bed values(default); 
INSERT INTO bed values(default); 
INSERT INTO bed values(default); 

INSERT INTO inspector (first_name, last_name) VALUES
('Orest', 'Penkin'),
('Will', 'Smith'),
('Bad', 'Cop'),
('Bruce', 'Willis'),
('Snoop', 'Dogg'),
('Kevin', 'Spacey'),
('Good', 'Cop');


/*

to_bed_id == null and inspector_id_freed == null -> escaped
from_bed_id == null and inspector id != null -> just brought
IF THERE IS row with alcoholic_id == I and to_bed_id == B and there is no record alcoholic_id == i and FROM_BED_ID == B -> still on that bed

date_left == null -> still there
*/

INSERT INTO registry (alcoholic_id, inspector_id_brought, inspector_id_freed, date_entered, date_left, from_bed_id, to_bed_id) VALUES
(1, 2, null, '2020-03-13', null, null, 2),/*just brought */
(1, 3, null, '2020-03-20', null, 2, 3), /*inspector 3 took him from bed 2 to bed 3 + */
(1, null, 2, null, '2020-03-22', 3, null),/*inspector 2 freed him*/
(2, 4, null, '2020-04-21', null, null, 1),/*inpector 4 took him here and then*/
(2, 4, null, '2020-04-24', null, 1, 2),/*inspector 4 took him to another bed and thats all HE IS STILL ON THAT BED cause no slot with date_left*/
(2, 4, null, '2020-04-21', null, 4, null ),/*NOW STIll on bed 4! NOT ESCAPE! cause no date_left*/
(3, 3, null, '2020-05-21', null, null, 1 ),/*just brought*/
(3, null, null, null, '2020-05-22', 1, null ),/*ESCAPE: no ispector_id_freed = null, to_bed_id = null, inspector_id_brought = null, date_left != null*/
(3, 2, null, '2020-06-01', null, null, 2 ),/*comeback*/
(3, 2, null, '2020-06-03', null, 2, 3 ),/*take him from bed 2 to 3*/
(3, null, 1, null, '2020-06-05', 3, null ); /*inpector 1 freed him*/

INSERT INTO drink (drink_name) VALUES
('Hardcore juice'),
('Sotka el'),
('Cardboard wine'),
('Hand cleaner');

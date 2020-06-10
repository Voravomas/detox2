/*
iнспектор забирає алгоколiка у витверезник i обирає для нього лiжко;
*/
/*Якщо намагається змінити дату, яка до останнього запису в реєстрі, то кидати error "You cannot change the past"*/
/*Якщо на поточну дату алкоголік MY_alc_ID вже є у витверезнику, то кидати ERROR Алкоголік вже у витверезнику*/
/*TASK for Білик: перевірка чи на поточну дату алкаш у витверезнику*/

INSERT INTO registry (alcoholic_id, inspector_id_brought, inspector_id_freed, date_entered, date_left, from_bed_id, to_bed_id) VALUES
(MY_alc_ID, MY_insp_ID, null, MY_date_entered, null, null, MY_bed_id);/*just brought */


/*iнспектор випускає алкоголiка з витверезника;*/
/*Якщо намагається змінити дату, яка до останнього запису в реєстрі, то кидати error "You cannot change the past"*/
/*Якщо на поточну дату алкоголік MY_alc_ID не є у витверезнику, то кидати ERROR Алкоголіка нема у витверезнику*/
/*TASK for Білик: перевірка чи на поточну дату алкаш у витверезнику*/


INSERT INTO registry (alcoholic_id, inspector_id_brought, inspector_id_freed, date_entered, date_left, from_bed_id, to_bed_id) VALUES
(MY_alc_ID, null, MY_insp_ID, null, MY_date_freed, MY_bed_id, null);/*inspector freed him*/

/*алкоголiк тiкає з витверезника (лiжка);*/
/*Якщо намагається змінити дату, яка до останнього запису в реєстрі, то кидати error "You cannot change the past"*/
/*Якщо на поточну дату алкоголік MY_alc_ID не є у витверезнику, то кидати ERROR Алкоголіка нема у витверезнику*/


INSERT INTO registry (alcoholic_id, inspector_id_brought, inspector_id_freed, date_entered, date_left, from_bed_id, to_bed_id) VALUES
(MY_alc_ID, null, null, null, MY_date_esceped, MY_bed_id, null );/*ESCAPE: no inspector_id_freed = null, to_bed_id = null, inspector_id_brought = null, date_left != null*/


/*iнспектор переводить алкоголiка на iнше лiжко;*/
/*Якщо намагається змінити дату, яка до останнього запису в реєстрі, то кидати error "You cannot change the past"*/
/*Якщо на поточну дату алкоголік MY_alc_ID не є у витверезнику, то кидати ERROR Алкоголіка нема у витверезнику*/
/*TASK for Білик: отримати ліжко, на якому лежить алкоголік на задану дату (щоб потім інсертити from_bed_id)*/


INSERT INTO registry (alcoholic_id, inspector_id_brought, inspector_id_freed, date_entered, date_left, from_bed_id, to_bed_id) VALUES
(MY_alc_ID, MY_insp_ID, null, MY_date_entered, null, MY_FROM_bed_id, MY_TO_bed_id);

/*• група алкоголiкiв розпиває алкогольний напiй; +співає пісню*/
/*Створити свято на певну дату*/
INSERT INTO party (date_happened, drink_id, song_id) VALUES
(My_date, MY_drink_id, MY_song_id);
/*Додати туди алкоголіка*/
/*Якщо на поточну дату алкоголік MY_alc_ID лежить у витверезнику, то кидати ERROR Алкоголік зараз у витверезнику і не може прийти на вечірку*/


INSERT INTO party_id_alcoholic_id (party_id, alcoholic_id) VALUES
(MY_party_id, MY_alcoholic_id);

/*алкоголiк втрачає свiдомiсть;*/
/*Якщо на поточну дату алкоголік MY_alc_ID не є у витверезнику, то кидати ERROR Алкоголіка нема у витверезнику*/
/*+ отримати ліжко, на якому лежить алкоголік на задану дату (щоб потім інсертити bed_id)*/

INSERT INTO faints (alcoholic_id, date_happened, bed_id) VALUES
(MY_alc_id, MY_date, MY_bed_id);

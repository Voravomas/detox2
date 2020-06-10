allRequests = {
    "r_get_alcoholic" : 'SELECT * FROM alcoholic',
    "r_get_bed" : 'SELECT * FROM bed',
    "r_get_drink" : 'SELECT * FROM drink',
    "r_get_faints" : 'SELECT * FROM faints',
    "r_get_inspector" : 'SELECT * FROM inspector',
    "r_get_party" : 'SELECT * FROM party',
    "r_get_party_id_alcoholic_id" : 'SELECT * FROM party_id_alcoholic_id',
    "r_get_registry" : 'SELECT * FROM registry',
    "r_get_song" : 'SELECT * FROM song',
    "r_get_viewers" : 'SELECT * FROM viewers',
    "r_alco_took" : "SELECT r.inspector_id_brought, count(*) FROM registry as r WHERE r.from_bed_id IS NULL AND r.alcoholic_id = $1 AND r.date_entered BETWEEN $2 AND $3 GROUP BY r.inspector_id_brought having count(*) >= $4;",
    "r_alco_slept" : "",
    "r_insp_took" : "",
    "r_alco_run" : "",
    "r_alco_less" : "",
    "r_all_insp_took" : "",
    "r_all_alco_took" : "",
    "r_alco_inspt_event" : "",
    "r_alco_bar" : "",
    "r_run_registry" : "",
    "r_bed_registry" : "",
    "r_drink_with" : "",
    "tr_is_in_detox" : "SELECT CASE WHEN ($1 > a.date_entered AND a.date_left IS NULL) OR ($1 BETWEEN a.date_entered AND a.date_left) THEN 'TRUE' ELSE 'FALSE' END FROM (SELECT (SELECT MAX(date_entered) FROM registry WHERE alcoholic_id = $2 AND from_bed_id IS NULL) as date_entered, (SELECT MAX(date_left) FROM registry WHERE alcoholic_id = $2) as date_left) a;",
    "tr_what_bed" : 'SELECT a.to_bed_id FROM (SELECT * FROM registry WHERE alcoholic_id = $1 AND date_left IS NULL ORDER BY date_entered DESC) as a',
    "tr_last_date" : 'SELECT MAX(date_happened) as last_date FROM ( SELECT date_happened FROM faints UNION SELECT date_happened FROM party UNION SELECT date_entered FROM registry UNION SELECT date_left FROM registry) a;'
    }

// r - request
// tr - team request (requests that are added by our team)
allEvents = {
    "e_make_viewer" : 'INSERT INTO viewers (v_name, v_login, v_password, v_permission) VALUES ($1, $2, $3, $4)',
    "e_delete_viewer" : 'DELETE FROM viewers WHERE v_id = $1',
    "e_take" : 'INSERT INTO registry (alcoholic_id, inspector_id_brought, inspector_id_freed, date_entered, date_left, from_bed_id, to_bed_id) VALUES ($1, $2, null, $3, null, null, $4);',
    "e_release" : "INSERT INTO registry (alcoholic_id, inspector_id_brought, inspector_id_freed, date_entered, date_left, from_bed_id, to_bed_id) VALUES ($1, null, $2, null, $3, $4, null);",
    "e_run" : "",
    "e_change" : "",
    "e_party" : "",
    "e_faint" : "INSERT INTO faints (alcoholic_id, date_happened, bed_id) VALUES ($1, $2, $3);",    
}

// e - event
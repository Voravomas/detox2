const eventer = require("./events.js")
const requester = require("./requests.js")

const Pool = require('pg').Pool
const pool = new Pool({
    user: 'my_user',
    host: 'localhost',
    database: 'detox',
    password: 'root',
    port: 5432,
});

//-----viewers interaction
const getViewers = () => {
    return new Promise(function(resolve, reject){
        pool.query(allRequests["r_get_viewers"], (error, results) => {
            if (error) {
                reject(error)
            }
            resolve(results.rows);
        })
    })
}

const createViewer = (body) => {
    console.log("here")
    return new Promise(function(resolve, reject) {
        const {v_name, v_login, v_password, v_permission} = body
        pool.query(allEvents["e_make_viewer"], [v_name, v_login, v_password, v_permission], (error, results) => {
            if (error) {
                reject(error);
            } else {
                resolve(`A new viewer has been added`)
            }
        })
    })
}

const deleteViewer = (id) => {
    return new Promise(function(resolve, reject) {
        pool.query(allEvents["e_delete_viewer"], [parseInt(id)], (error, results) => {
            if (error) {
                reject(error)
            } else {
                resolve(`Viewer deleted with ID: ${id}`)
            }
        })
    })
}

//-----teams-requests
const tr_is_in_detox = (date, id) => { 
    return new Promise(function(resolve, reject) {
        pool.query(allRequests["tr_is_in_detox"], [date, parseInt(id)], (error, results) => {
            if (error) {
                reject(error)
            } else {
                resolve(results)
            }
        })
    }).then(response => {
        // console.log("response from tr_is_in_detox");
        // console.log(response.rows[0].case)
        if (response !== undefined){
            return response.rows[0].case;
        }
        else {
            return undefined;
        }
    })
    .catch(error => {
        console.log("Error from tr_is_in_detox: ")
        console.log(error);
        return undefined;
    })
}

const tr_what_bed = (id) => {
    return new Promise(function(resolve, reject) {
        pool.query(allRequests["tr_what_bed"], [parseInt(id)], (error, results) => {
            if (error) {
                reject(error)
            } else {
                resolve(results)
            }
        })
    })
}

const tr_last_date = () => {
    return new Promise(function(resolve, reject) {
        pool.query(allRequests["tr_last_date"], (error, response) => {
            if (error) {
                console.log("Error: ")
                console.log(error);
                reject(undefined)
            } else {
                let res = String(response.rows[0].last_date);
                if (res !== undefined){
                    res = res.split(" ");
                    res = res[1] + " " + res[2] + " " + res[3];
                    // console.log("HERE SHOULD BE RESULT:")
                    // console.log(res);
                    resolve(res);
                }
                else {
                    resolve(undefined);
                }
            }
        })
    })
}

async function make1Async(body) {
    const pr1 = await tr_last_date();
    if (pr1 == undefined){
        console.log("Error in input values")
        throw Error("Error in input values");
    }
    const pr2 = await tr_is_in_detox(body.date_entered, body.alc_id);
    if (pr2 == undefined) {
        console.log("Error in input values")
        throw Error("Error in input values");
    }
    if (Date(body.date_entered) < Date(pr1)){
        console.log("You cannot change the past");
        throw Error("You cannot change the past"); 
    }
    if (pr2 === "TRUE"){
        console.log("Alcoholic is already in prison");
        throw Error("Alcoholic is already in prison");
    }
}

async function make2Async(body) {
    const pr1 = await tr_last_date();
    if (pr1 == undefined) {
        console.log("Error in input values")
        throw Error("Error in input values");
    }
    const pr2 = await tr_is_in_detox(body.date_freed, body.alc_id);
    if (pr2 == undefined) {
        console.log("Error in input values")
        throw Error("Error in input values");
    }
    const pr3 = await tr_what_bed(body.alc_id);
    if (pr3 == undefined) {
        console.log("Error in input values")
        throw Error("Error in input values");
    }
    if (Date(body.date_freed) < Date(pr1)){
        console.log("You cannot change the past");
        throw Error("You cannot change the past");
    }
    if (pr2 === "FALSE"){
        console.log("Alcoholic is not in prison");
        throw Error("Alcoholic is not in prison");
    }
    return pr3;
}

async function make3Async(body) {
    let copy_date_from = new Date(body.date_from);
    let copy_date_to = new Date(body.date_to);
    if (copy_date_from >= copy_date_to){
        console.log("Dates are incorrect");
        throw Error("Dates are incorrect");
    }
    const pr1 = await tr_is_in_detox(body.date_from, body.alc_id);
    if (pr1 == undefined) {
        console.log("Error in input values")
        throw Error("Error in input values");
    }
    if (pr1 === "FALSE"){
        console.log("Alcoholic is not in prison");
        throw Error("Alcoholic is not in prison");
    }
    const pr2 = await tr_is_in_detox(body.date_to, body.alc_id);
    if (pr2 == undefined) {
        console.log("Error in input values")
        throw Error("Error in input values");
    }
    if (pr2 === "FALSE"){
        console.log("Alcoholic is not in prison");
        throw Error("Alcoholic is not in prison");
    }
}

//-------events
const e_take = (body) => {
    let query;
    let arrOfVars = [];
    return new Promise(function(resolve, reject) {
        make1Async(body).then(() => {
            query = allEvents["e_take"];
            arrOfVars = Object.values(body);
            pool.query(query, arrOfVars, (error, results) => {
                if (error) {
                    console.log(error);
                    reject(error)
                }
                else{
                    resolve(results);
                }
            })
            }
        ).catch(error => {
            console.log(error)
            reject(new Error("error"))})
        })
    }

const e_release = (body) => {
    let query;
    let arrOfVars = [];
    return new Promise(function(resolve, reject) {
        make2Async(body).then((bed_id) => {
            query = allEvents["e_release"];
            arrOfVars = Object.values(body);
            arrOfVars.push(bed_id.rows[0].to_bed_id);
            pool.query(query, arrOfVars, (error, results) => {
                if (error) {
                    console.log(error);
                    reject(error)
                }
                else{
                    resolve(results);
                }
            })
        })
        .catch(error => {
            console.log(error)
            reject(new Error("error"))})
    })
}

const e_faint = (body) => {
    let query;
    let arrOfVars = [];
    return new Promise(function(resolve, reject) {
        make2Async(body).then((bed_id) => {
            query = allEvents["e_faint"];
            arrOfVars = Object.values(body);
            arrOfVars.push(bed_id.rows[0].to_bed_id);
            pool.query(query, arrOfVars, (error, results) => {
                if (error) {
                    console.log(error);
                    reject(error)
                }
                else{
                    resolve(results);
                }
            })
        })
        .catch(error => {
            console.log(error)
            reject(new Error("error"))})
    })
}

//-------requests

const get_table = (id) => {
    return new Promise(function(resolve, reject){
        let myId = parseInt(id);
        if (myId > 9){
            reject(new Error("Id is too big"));
        }
        let psqlSelect = allRequests[Object.keys(allRequests)[parseInt(id)]];
        pool.query(psqlSelect, (error, results) => {
            if (error) {
                reject(error)
            }
            resolve(results.rows);
        })
    })
}

const r_alco_took = (body) => {
    let query;
    let arrOfVars = [];
    return new Promise(function(resolve, reject) {
        make3Async(body).then(() => {
            query = allRequests["r_alco_took"];
            arrOfVars = Object.values(body);
            // console.log(arrOfVars)
            // resolve("OK")

            pool.query(query, arrOfVars, (error, results) => {
                if (error) {
                    console.log(error);
                    reject(error)
                }
                else{
                    resolve(results.rows);
                }
            })
        })
        .catch(error => {
            console.log(error)
            reject(new Error("error"))})
    })
}


module.exports = {
    getViewers,
    createViewer,
    deleteViewer,
    e_take,
    e_release,
    get_table,
    e_faint,
    r_alco_took
}
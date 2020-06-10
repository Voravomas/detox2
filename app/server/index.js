const express = require('express');
const app = express()
const port = 3001

const detox_model = require('./detox_model')

app.use(express.json())
app.use(function (req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', 'http://localhost:3000');
    res.setHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Access-Control-Allow-Headers');
    next();
  });

//-----viewers interaction
app.get('/getViewers', (req, res) => {
    detox_model.getViewers()
    .then(response => {
        res.status(200).send(response);
    })
    .catch(error => {
        console.log(error)
        res.status(500).send(error);
    })
})

app.post('/createViewers', (req, res) => {
    detox_model.createViewer(req.body)
    .then(response => {
        res.status(200).send(response);
    })
    .catch(error => {
        console.log(error)
        res.status(500).send(error);
    })
})

app.delete('/viewers/:id', (req, res) => {
    detox_model.deleteViewer(req.params.id)
    .then(response => {
        res.status(200).send(response);
    })
    .catch(error => {
        console.log(error);
        res.status(500).send(error);
    })
})

//-------events 
app.post('/event/e_take', (req, res) => {
    detox_model.e_take(req.body)
    .then(response => {
        res.status(200).send(response);
    })
    .catch(error => {
        console.log(error)
        res.status(500).send(error);
    })
})

app.post('/event/e_release', (req, res) => {
    detox_model.e_release(req.body)
    .then(response => {
        res.status(200).send(response);
    })
    .catch(error => {
        console.log(error)
        res.status(500).send(error);
    })
})

app.post('/event/e_faint', (req, res) => {
    detox_model.e_faint(req.body)
    .then(response => {
        res.status(200).send(response);
    })
    .catch(error => {
        console.log(error)
        res.status(500).send(error);
    })
})
//-------requests

app.get('/table/:id', (req, res) => {
    detox_model.get_table(req.params.id)
    .then(response => {
        res.status(200).send(response);
    })
    .catch(error => {
        res.status(500).send(error);
    })
})

app.post('/request/r_alco_took', (req, res) => {
    detox_model.r_alco_took(req.body)
    .then(response => {
        res.status(200).send(response);
    })
    .catch(error => {
        console.log(error)
        res.status(500).send(error);
    })
})

app.listen(port, () => {
    console.log(`App is running on port ${port}.`)
})
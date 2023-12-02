const express = require('express');
const app = express();
var router = express.Router();

const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '1234',
    database: 'my_db',
    port: '3305'
});

router.post('/login', (req, res) => {
    const { userid, password } = req.body;

    connection.query('SELECT * FROM userdb WHERE userid=? AND password=?', [userid, password], (error, results, field) => {
        if (error) throw error;

        if (results.length > 0) {
            console.log('User info is: ', results);
            res.json(true);
        }
        else {
            res.json(false);  //일치하지 않는 경우
        }
    });
});

router.post('/signup', (req, res) => {
    var name = req.body['username'];
    var id = req.body['userid'];
    var pw = req.body['password'];

    connection.query(
        'INSERT INTO userdb (username, userid, password) VALUES (?, ?, ?)',
        [name, id, pw],
        (error, results, field) => {
            if (error) throw error
            else res.json(true)
        });
});

router.get('/loadspots', (req, res) => {
    connection.query(
        'SELECT * FROM spots', (error, results, field) => {
        if(error) throw error;

        res.json(results);
        }
    )
}
)

router.post('/loadallmenu', (req, res) => {
    connection.query(
        'SELECT * FROM menudb',
        (error, results, field) => {
            if (error) throw error;
            res.json(results);
        });
});

module.exports = router;
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

router.post('/loadchat', (req, res) => {
    const chatID = req.body["chatID"];

    connection.query('SELECT * FROM chat WHERE chatID = ?', [chatID], (error, results, field) => {
        if (error) throw error;
        res.json(results);
        }
    );
    }
);

router.post('/sendchat', (req, res) => {
    const userid = req.body["userid"];
    const message = req.body["message"];
    const chatID = req.body["chatID"];

    var today = new Date();

    var year = today.getFullYear();
    var month = ('0' + (today.getMonth() + 1)).slice(-2);
    var day = ('0' + today.getDate()).slice(-2);

    var dateString = year + '-' + month + '-' + day;

    var hours = ('0' + today.getHours()).slice(-2);
    var minutes = ('0' + today.getMinutes()).slice(-2);
    var seconds = ('0' + today.getSeconds()).slice(-2);

    var timeString = hours + ':' + minutes + ':' + seconds;

    var create_time = dateString + ' ' + timeString;

    connection.query('INSERT INTO chat (create_time, userid, message, chatID) VALUES (?, ?, ?, ?)', [create_time, userid, message, chatID],
        (error, results, field) => {
            if (error) throw error
            res.json(true);
        }
    );
})

module.exports = router;
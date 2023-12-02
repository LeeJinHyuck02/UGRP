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

router.post('/loadrooms', (req, res) => {

    connection.query('SELECT * FROM chatrooms', (error, results, field) => {
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
});

router.post('/board', (req, res) => {
    console.log('윽')
    connection.query('SELECT * FROM board',
        (error, results, field) => {
            if (error) { throw error; }
            console.log(results);
            res.send(results);
        }
    )
}
)

router.post('/comment', (req, res) => {
    console.log('윽');

    var textid = req.body["textid"];

    console.log(req.body);

    connection.query('SELECT * FROM comment WHERE textid =?', [textid], 
        (error, results, field) => {
            if (error) { throw error; }
            res.send(results);
        }
    )
}
)

router.post('/add', (req, res) => {
    var textid = req.body["textid"];
    var userid = req.body["userid"];
    var usertext = req.body["usertext"];

    console.log('ㅎ')
    connection.query('INSERT INTO comment (userid, usertext, textid) VALUES (?, ?, ?)',
    [userid, usertext, textid],
        (error, results, field) => {
            if (error) { throw error; }
            res.send(results);
        }
    )
}
)

router.post('/addtext', (req, res) => {
    var userid = req.body["userid"];
    var title = req.body["title"];
    var text = req.body["usertext"];
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

    console.log('gn')
    connection.query('INSERT INTO board (userid, title, text, create_time) VALUES (?, ?, ?, ?)',
    [userid, title, text, create_time],
        (error, results, field) => {
            if (error) { throw error; }
            console.log(results);
            res.send(results);
        }
    )
}
)

module.exports = router;
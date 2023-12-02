var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var http = require('http');

app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var beforeroute = require('./api/before.js');
var sessionsroute = require('./api/sessions.js');
var communityroute = require('./api/community.js');

app.use('/before', beforeroute);
app.use('/sessions', sessionsroute);
app.use('/community', communityroute);

const server = http.createServer(app);

server.listen(3000, () => { console.log('서버 돌아간다!') });

const io = require('socket.io')(server);

const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '1234',
    database: 'my_db',
    port: '3305'
});

io.on('connection', (socket) => {
    console.log('연결됐다!');

    socket.on('send', (msg) => {
        console.log(msg);
        io.to(msg["chatID"]).emit('get', msg);
    });

    socket.on('join', (msg) => {
        console.log(msg);
        socket.join(msg["chatID"]);
    });

    socket.on('disconnect', () => {
        console.log('user disconnected');
    });
});



/*
const wsModule = require('ws');
const WebSocketServer = new wsModule.Server(
    {
        server: server,
    }
);

var id = 0;
var lookup = [];

WebSocketServer.on('connection', (ws, req) => {

    if (ws.readyState === ws.OPEN) {
        console.log('열렸다!');
    }

    console.log(req.headers.userid);

    lookup.push({"ws": ws, "userid": req.headers.userid})

    id++;

    ws.on('message', (msg) => {
        console.log(msg.toString());
        const instance = JSON.parse(msg.toString());


        const userid = instance.userid;
        const message = instance.message;
        const chatID = instance.chatID;

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
            }
        );

        connection.query('SELECT userid FROM chatuser WHERE chatID = ?', [chatID],
            (error, results, field) => {
                console.log(results);
                for (i = 0; i < lookup.length; i++) {
                    for (j = 0; j < results.length; j++) {
                        if (lookup[i]["userid"] == results[j]["userid"]) {
                            lookup[i]["ws"].send(JSON.stringify(instance));
                        }
                    }
                }
            }
        )
    })

    ws.on('error', (error) => {
        console.log('에러다!');
    })
})*/
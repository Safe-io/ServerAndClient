import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });

console.log("SERVER started")

let CurrentClientID = 0

wss.on('connection', function connection(ws) {
  CurrentClientID++
  ws.send(JSON.stringify({"id": CurrentClientID.toString()}))

  ws.on('message', function message(data) {

    console.log(JSON.parse(data))
    ws.send(data);
  });

});


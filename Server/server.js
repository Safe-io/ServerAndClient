import WebSocket, { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });

console.log("SERVER started")
let CurrentClientID = 0
let payloadToAllClients = {}


wss.on('connection', function connection(ws) {
  CurrentClientID ++
  ws.send(JSON.stringify({"id": CurrentClientID.toString()}));

  ws.on('message', function message(data) {
    console.log(JSON.parse(data))
  });

});

function SendPayloadToAllClients(payloadToAllClients){
      //Send a message to all clients
  wss.clients.forEach(function each(client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(payloadToAllClients));
    }
  });
}


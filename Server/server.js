import WebSocket, { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });

console.log("SERVER started")
let CurrentClientID = 0

let payloadToAllClients = {}


wss.on('connection', function connection(ws) {
  console.log("Client Connected!")
  CurrentClientID ++
  ws.send(JSON.stringify({"assignid": CurrentClientID.toString()}));

  ws.on('message', function message(data) {
    SendPayloadToAllClients(data)
    console.log(JSON.parse(data))
  });
});

function SendPayloadToAllClients(payloadToAllClients){
      //Send a message to all clients
  wss.clients.forEach(function each(client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(payloadToAllClients);
    }
  });
}


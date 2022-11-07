import WebSocket, { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });

console.log("SERVER started")
let CurrentClientID = 0

let payloadToAllClients = {}



let clientHasConected = (ws) => {
  console.log("Client Connected!")
  CurrentClientID ++
  console.log(CurrentClientID)
  let bytesLength = 0;
  ws.send(JSON.stringify({"assignid": CurrentClientID}));

  setInterval(() => {
    console.log("bytes: " + bytesLength);
    bytesLength = 0
  }, 1000);

  ws.on('message', function message(data) {
    bytesLength += data.length
    sendPayloadToAllClients(data)
    console.log(JSON.parse(data))
  });
}

wss.on('connection', clientHasConected);

function sendPayloadToAllClients(payloadToAllClients){
  //Send a message to all clients
  wss.clients.forEach(function each(client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(payloadToAllClients);
    }
  });
}

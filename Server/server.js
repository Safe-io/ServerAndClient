import WebSocket, { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });

console.log("SERVER started")

function heartbeat(){
  this.isAlive = true
  console.log("heartbeated")
}

let CurrentClientID = 0

let payloadToAllClients = {}

const SECONDS_BETWEEN_PINGS = 1000 * 6



let clientHasConected = (ws) => {
  AssignClientID(ws)
  

  ws.on('message', function message(data) {

    if(typeof(data) === "object"){
      sendPayloadToAllClients(data)
      console.log(JSON.parse(data))
    }
  });
}

wss.on('connection', clientHasConected);

function sendPayloadToAllClients(payloadToAllClients){
  wss.clients.forEach(function each(client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(payloadToAllClients);
    }
  });
}

function AssignClientID(ws){
  CurrentClientID ++
  console.log("Client id:" + CurrentClientID + " has connected!")
  ws.send(JSON.stringify({"assignid": CurrentClientID}));
}
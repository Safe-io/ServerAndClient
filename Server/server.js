import WebSocket, { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });

console.log("SERVER started")

function heartbeat(){
  this.isAlive = true
  console.log("heartbeated")
}

let CurrentClientID = 0

let payloadToAllClients = {}

let PlayersState = {}

let idList = [0]

const SECONDS_BETWEEN_PINGS = 1000 * 6

let clientHasConected = (ws) => {
  AssignClientID(ws)


  ws.on('message', function message(data) {


    if(typeof(data) === "object"){
      PlayersState[data.id] = data
      console.log(PlayersState)

      sendPayloadToAllClients(data)
      console.log(JSON.parse(data))
    }
  });

  ws.on('close', function clientHasDisconnected(){
    console.log("Client with ID" + " ? " + "has disconnected!")
  })
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
  ws.id = CurrentClientID
  console.log("Client id:" + CurrentClientID + " has connected!")
  ws.send(JSON.stringify({"assignid": CurrentClientID}));
}

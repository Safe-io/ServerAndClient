import WebSocket, { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });

console.log("SERVER started")

let CurrentClientID = 0

let payloadToAllClients = {}

let PlayersState = {}

const SECONDS_BETWEEN_PINGS = 1000 * 6

console.log({1: "oi"})

let clientHasConected = (ws) => {
  AssignClientID(ws)

	//AO RECEBER OU ENVIAR PACOTES, UTILIZE O FORMATO "STRING"
  ws.on('message', function message(data) {

    let dataObject = JSON.parse(data)
    if(typeof(data) === "object"){
      PlayersState[ws.id] = dataObject

      sendPayloadToAllClients(JSON.stringify(PlayersState))
      console.log(PlayersState)
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
  CurrentClientID++
  ws.id = CurrentClientID
  console.log("Client id:" + CurrentClientID + " has connected!")
  ws.send(JSON.stringify({"assignid": CurrentClientID}));
}

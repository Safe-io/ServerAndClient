import WebSocket, { WebSocketServer } from 'ws';
import { createEnemy } from './enemy/enemy.js';
import { handlePlayerHits } from './player/player.js';

const wss = new WebSocketServer({ port: 3000 });

console.log("SERVER started")

let CurrentClientID = 0


let GameState = {
  enemies : {1 : createEnemy(2000)},
  players : {}
}

let availableIds = []

const CLIENT_DISCONNECTED = 404

let clientHasConected = (ws) => {
  AssignClientID(ws)

  ws.on('message', function message(data) {

    let dataObject = JSON.parse(data)

    if(typeof(data) === "object"){
      if(GameState.players[ws.id] === {"err": CLIENT_DISCONNECTED}) return
    
      handlePlayerHits(GameState, dataObject)      
      GameState.players[ws.id] = dataObject
      sendPayloadToAllClients(JSON.stringify(GameState))
      console.log(GameState)

      // delete GameState.players[ws.id].posx
      // delete GameState.players[ws.id].posy
    }
  });

  ws.on('close', function clientHasDisconnected() {
    GameState.players[ws.id] = {"err": CLIENT_DISCONNECTED}
    sendPayloadToAllClients(JSON.stringify(GameState))
    delete GameState.players[ws.id]
    availableIds.push(ws.id)
    console.log(`Client with ID ${ws.id} has disconnected!`)
  })
}

wss.on('connection', clientHasConected);

function sendPayloadToAllClients(payloadToAllClients){
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(payloadToAllClients);
    }
  });
}

function AssignClientID(ws){
  if(availableIds.length > 0){
    ws.id = availableIds.pop()
  }
  else{
    CurrentClientID++
    ws.id = CurrentClientID
  }
  console.log(`Client id: ${CurrentClientID} has connected!`)
  ws.send(JSON.stringify({"assignid": CurrentClientID}));
}

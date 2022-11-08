import WebSocket, { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });

console.log("SERVER started")

function heartbeat(){
  this.isAlive = true
  console.log("heartbeated")
}

let CurrentClientID = 0

let payloadToAllClients = {}

const SECONDS_BETWEEN_PINGS = 1000 * 60

const interval = setInterval(function ping() {
  wss.clients.forEach(function each(ws) {
    if (ws.isAlive === false) return ws.terminate();

    ws.isAlive = false;
  });
}, SECONDS_BETWEEN_PINGS);

wss.on('close', function close() {
  clearInterval(interval);
});


let clientHasConected = (ws) => {
  ws.isAlive = true;

  //ws.on("pong", heartbeat);
  CurrentClientID ++

  console.log("Client id:" + CurrentClientID + " has connected!")
  let bytesLength = 0;
  ws.send(JSON.stringify({"assignid": CurrentClientID}));

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

function print_bytes_received(seconds){
  setInterval(() => {
    console.log("bytes: " + bytesLength);
    bytesLength = 0
  }, 1000 * seconds);

}

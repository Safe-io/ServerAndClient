import WebSocket, { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });

console.log("SERVER started")



wss.on('connection', function connection(ws) {

  ws.on('message', function message(data) {
    let CurrentClientID = 0
    //Sending a message to all clients
    wss.clients.forEach(function each(client) {
      if (client.readyState === WebSocket.OPEN) {
        CurrentClientID ++
        console.log(CurrentClientID)
        client.send(JSON.stringify({"id": CurrentClientID.toString()}));
      }
    });

    console.log(JSON.parse(data))
  });

});


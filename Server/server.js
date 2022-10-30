import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3000 });

console.log("SERVER started")

let CurrentClientID = 0

wss.on('connection', function connection(ws) {
  
  ws.on('message', function message(data) {
    console.log('received: %s',JSON.parse(data).msg);
    ws.send(data);
  });

  //ws.send({"msg":"Resposta do Servidor"});
});


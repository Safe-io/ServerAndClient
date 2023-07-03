import { createServer } from 'https';
import { readFileSync } from 'fs';
import WebSocket, { WebSocketServer } from 'ws';
import { createEnemy } from './enemy/enemy.js';
import { handlePlayerHits } from './player/player.js';

// Constants
const HOST = 'localhost';
const PORT = 3000;
const CLIENT_DISCONNECTED = 404;
const PING_INTERVAL = 30000;
const UPDATE_RATE = 1000 / 60;

// Server setup
const wss = new WebSocketServer({ host: HOST, port: PORT });
console.log("SERVER started");

// Game state
let GameState = {
  enemies: {1 : createEnemy(2000)},
  players: {}
};

// Track client IDs
let currentClientID = 0;
let availableIds = [];

// Create a new player
function createPlayer(id) {
  return {
    id,
    pos: getRandomPosition(0, 1000),
    motion: [0, 0],
    r: 0
  };
}

// Handle a client connection
function handleConnection(ws) {
  ws.on('error', console.error);
  ws.on('pong', heartbeat);
  ws.on('close', handleDisconnection.bind(null, ws));
  ws.on('message', handleMessage.bind(null, ws));
  
  ws.isAlive = true;
  ws.id = assignClientID();
  ws.send(JSON.stringify({"assignid": ws.id}));

  GameState.players[ws.id] = createPlayer(ws.id);
  ws.send(JSON.stringify({"assignposition": GameState.players[ws.id].pos}));
}

// Keep the connection alive
function heartbeat() {
  this.isAlive = true;
}

// Handle a client disconnection
function handleDisconnection(ws) {
  GameState.players[ws.id] = {"err": CLIENT_DISCONNECTED};
  delete GameState.players[ws.id];
  availableIds.push(ws.id);
  console.log(`Client with ID ${ws.id} has disconnected!`);
}

// Handle incoming messages
function handleMessage(ws, data) {
  setTimeout(() => {
    const dataObject = JSON.parse(data);
    console.log("Received: " , dataObject);

    if (dataObject.type == "movement" && GameState.players[ws.id]) {
      GameState.players[ws.id].pos = applyMovement(GameState.players[ws.id].pos, dataObject.motion);
    }
  }, 200);
}

// Send state to all clients at a regular interval
setInterval(sendPayloadToAllClients, UPDATE_RATE);

// Send current game state to all clients
function sendPayloadToAllClients() {
  if (wss.clients.size > 0) {
    const payload = JSON.stringify(GameState);
    wss.clients.forEach(client => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(payload);
      }
    });
    console.log("Sent: " , GameState);
  }
}

// Assign a unique ID to each client
function assignClientID() {
  return availableIds.length > 0 ? availableIds.pop() : ++currentClientID;
}

// Ping clients regularly to keep connection alive
const interval = setInterval(pingClients, PING_INTERVAL);

// Ping all clients
function pingClients() {
  wss.clients.forEach(ws => {
    if (ws.isAlive === false) return ws.terminate();

    ws.isAlive = false;
    ws.ping();
    console.log("ping sent");
  });
}

// Apply motion to a position
function applyMovement(position, motion) {
  const playerSpeed = 2;
  const playerVelocity = motion.map(m => m * playerSpeed);
  return position.map((pos, index) => pos + playerVelocity[index]);
}

// Get a random position
function getRandomPosition(min, max) {
  const randomCoordinate = () => Math.random() * (max - min) + min;
  return [randomCoordinate(), randomCoordinate()];
}

// Start the server
wss.on('connection', handleConnection);
wss.on('close', () => clearInterval(interval));

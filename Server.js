// server.js
const express = require('express');
const app = express();
const port = 3000;

// Command data in JSON format
const commands = {
    "hello": "return function() { print('Hello, world!'); }",
    "spawnNPC": "return function() { print('NPC spawned!'); }",
    "greet": "return function() { print('Greetings from the web server!'); }"
};

// Serve the commands in JSON format
app.get('/commands.json', (req, res) => {
    res.json(commands);
});

// Start the web server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});

const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const cors = require('cors');
const http = require('http');

const documentRouter = require('./routes/document');

const PORT = process.env.PORT || 3001;

const app = express();
var server = http.createServer(app);
var io = require('socket.io')(server);

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

mongoose.connect(process.env.MONGODB_URI || 'mongodb+srv://augustine:NYu9phUz43ejWR7D@cluster0.basoscy.mongodb.net/?retryWrites=true&w=majority').then(()=> {
    console.log('MongoDB connected');
}).catch(err => console.log(err));

io.on('connection', (socket) => {
  
   socket.on('join', (documnetId) => {
    socket.join(documnetId);
    console.log('joined', documnetId);
   });

   //delta is the data that is sent from the client
    socket.on('typing', (delta) => {
        socket.broadcast.to(delta.room).emit('changes', delta);
    }   
    );
});

server.listen(PORT, "0.0.0.0", ()=> {
    console.log(`Server listening on ${PORT}`);
});


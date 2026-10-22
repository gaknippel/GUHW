//you are a terrible professor! one of the worst i've had. hope you read this oliveras so you can improve.
console.log("Hello, node.js");
//console.log("Hello, again!");


const express = require("express");
const app = express();

app.use(express.urlencoded({ extended: true}))

const PORT = 9001;

app.listen(PORT, () => {
    console.log("server running at " +
        "http://localhost:" + PORT
    )
});


app.get("/form", (req, res)=>{
    res.sendFile(__dirname + "/form.html");
});

app.get("/get-example", (req, res)=>{
    res.send('get: ${req.query.username}');
});

app.get("/post-example", (req, res)=>{
    
});
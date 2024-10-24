const express = require('express');
const { doSomeHeavyTask } = require('./utils');

const app = express();
const PORT = process.env.PORT || 3000;

app.get("/", (req, res)=>{
    return res.json({ message : 'Hello from Express Server'});
});

app.get("/slow", async (req,res)=>{
    try {
        const timeTaken = await doSomeHeavyTask();
        return res.json({
            status : "Success",
            message : `Heavy task completed in ${timeTaken}ms`
        })
    } catch (error) {
        console.log(error)
        return res.status(500).json({status:'Error', message:'Internal server error'})
    }
});

app.listen(PORT, ()=>{
    console.log(`Express Server Started at 3000`)
});
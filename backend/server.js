require('dotenv').config()
const express = require('express')
const cors = require('cors')
const mongoose = require('mongoose')
const Vehicle = require('./models/vehicle')

const app = express()
const PORT = process.env.PORT || 5000

app.use(cors())
app.use(express.json())

mongoose.connect(process.env.MONGO_URI)
   .then(()=> console.log('MongoDB connecté ✅'))
   .catch((err)=> console.error('Erreur MongoDB :', err.message))


app.get('/', (req, res)=> {
    res.json({message : 'API Mobility en ligne 🚀'})
})

app.get('/api/health', (req, res)=> {
    res.json({ status: 'ok' })
})

app.get('/api/vehicles', async (req, res)=>{
    try {
        const vehicles = await Vehicle.find()
        res.json(vehicles)
    } catch (err) {
        res.status(500).json({error: err.message})
    }
})

app.post('/api/vehicles', async (req, res)=> {
    try {
        const vehicle = await Vehicle.create(req.body)
        res.status(201).json(vehicle)
    } catch (err) {
        res.status(400).json({error: err.message})
    }
})

app.listen(PORT, ()=> {
    console.log(`Serveur démarré sur http://localhost:${PORT}`)
})
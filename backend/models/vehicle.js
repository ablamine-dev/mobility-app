const mongoose = require('mongoose')

const vehicleSchema = new mongoose.Schema({
    type: {type: String, required: true},
    model: {type: String, required: true},
    available: {type: Boolean, required: true}
}, {timestamps: true})

module.exports = mongoose.model('Vehicle', vehicleSchema)
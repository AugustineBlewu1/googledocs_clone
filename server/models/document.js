const mongoose = require('mongoose');

const documentSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
        trim: true

    },
    content: {
        type: Array,
        default: []

    },
    uid: {
        type: String,
        required: true,
    },
    createdAt: {
        required: true,
        type: Number,
    }
    
});

const Document = mongoose.model('Document', documentSchema);

module.exports = Document;
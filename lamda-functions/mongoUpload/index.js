const { MongoClient } = require('mongodb');

exports.handler = async (event) => {
    let response = { statusCode: 200, body: 'Data uploaded successfully' };
        
    try {
        const uri = `mongodb+srv://${process.env.USERNAME}:${process.env.PASSWORD}@motiv-cluster.apflp3y.mongodb.net/?retryWrites=true&w=majority`;
        const client = new MongoClient(uri);
        const database = event.database;
        const users = database.collection(process.env.COLLECTION_NAME);

        // Parse the user data from the event body
        const data = event.body;

        // Insert the user data into the MongoDB collection
        await users.insertOne(data);
    } catch (error) {
        console.error("Error uploading data to MongoDB:", error);
        response = { statusCode: 500, body: 'Error uploading data to MongoDB' };
    }

    return response;
};

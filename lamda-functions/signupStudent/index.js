const { MongoClient } = require('mongodb');
const bcrypt = require('bcryptjs');

exports.handler = async (event) => {
    let response = { statusCode: 200, body: 'User saved successfully' };
    
    console.log("Received event data:", event);
    
    try {
        const uri = `mongodb+srv://${process.env.USERNAME}:${process.env.PASSWORD}@motiv-cluster.apflp3y.mongodb.net/?retryWrites=true&w=majority`;
        const client = new MongoClient(uri);
        const database = client.db(process.env.DATABASE_NAME);
        const users = database.collection(process.env.COLLECTION_NAME);

        // Parse the user data from the event body
        const userData = event.body;


        // Encrypt the password before saving
        const saltRounds = 5;
        const hashedPassword = await bcrypt.hash(userData.password, saltRounds);
        userData.password = hashedPassword; // Replace the plain password with the hashed one

        // Insert the user data into the MongoDB collection
        await users.insertOne(userData);
    } catch (error) {
        console.error("Error saving user:", error);
        response = { statusCode: 500, body: 'Error saving user' };
    }

    return response;
};

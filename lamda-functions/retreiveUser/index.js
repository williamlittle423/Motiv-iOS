const { MongoClient } = require('mongodb');

exports.handler = async (event, context) => {

    try {

        // Connect to the MongoDB cluster
        const uri = `mongodb+srv://${process.env.USERNAME}:${process.env.PASSWORD}@motiv-cluster.apflp3y.mongodb.net/?retryWrites=true&w=majority`;
        const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
        await client.connect();
        const database = client.db(process.env.DATABASE_NAME);
        const auth_collection = database.collection('auth-tokens')


        // Get the 'auth-token' value from the event
        const auth_token = event.auth_token;

        // Create a query based on the 'auth-token' value
        const query = { 'authToken': auth_token };

        // Execute the query to find the document
        const result = await auth_collection.findOne(query);

        if (!result) {
            return {
                statusCode: 404,
                body: JSON.stringify({ error: 'Document not found' }),
            };
        }

        // Extract the 'userID' value from the document
        const userID = result.userID;

        // Create a query for fetching additional data using the 'userID'
        const userCollection = database.collection('users'); 
        const userQuery = { _id: userID };

        // Execute the query to fetch user data
        const userData = await userCollection.findOne(userQuery);

        return {
            statusCode: 200,
            body: JSON.stringify(userData),
        };
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Internal Server Error' }),
        };
    } finally {
        // Close the MongoDB client connection
        await client.close();
    }
};

const { MongoClient } = require('mongodb');

exports.handler = async (event) => {
    try {
        // Database Configuration
        const uri = `mongodb+srv://${process.env.USERNAME}:${process.env.PASSWORD}@motiv-cluster.apflp3y.mongodb.net/?retryWrites=true&w=majority`;
        
        const databaseName = process.env.DATABASE_NAME;
        const collectionName = event.collection;

        // MongoDB Client Initialization
        const client = new MongoClient(uri);
        await client.connect();
        const database = client.db(databaseName);
        const collection = database.collection(collectionName);

        // Constructing the Query
        // Assuming the event contains the query object directly
        const query = event.query || {};

        // Perform the Query
        const result = await collection.find(query).toArray();

        // Close the connection
        await client.close();

        // Return the query result
        return {
            statusCode: 200,
            body: JSON.stringify(result),
        };
    } catch (error) {
        console.error('Error:', error);

        // In case of an error
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Internal Server Error' }),
        };
    }
};

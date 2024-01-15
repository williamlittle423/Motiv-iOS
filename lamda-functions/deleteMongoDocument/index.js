const { MongoClient } = require('mongodb');

// MARK: Deletes a document in MongoDB associated with a key value pair in a specified collection
// Parameter 1: key - the key to query the document
// Parameter 2: value - the value associated with the key
// Parameter 2: collection - the collection to query that the document for deletion is contained
exports.handler = async (event) => {
    try {
        const uri = `mongodb+srv://${process.env.USERNAME}:${process.env.PASSWORD}@motiv-cluster.apflp3y.mongodb.net/?retryWrites=true&w=majority`;
        const client = new MongoClient(uri);
        const database = client.db(process.env.DATABASE_NAME);

        // Retreive collection
        const collection = database.collection(event.collection);

        // Parse the event to get the key and value for deletion
        const key = event.key;
        const value = event.value;

        // Define the query to find the document to delete
        const query = { [key]: value }; // Use square brackets for dynamic key

        // Delete the document
        const result = await collection.deleteOne(query);

        if (result.deletedCount === 1) {
            return {
                statusCode: 200,
                body: JSON.stringify({ message: 'Document deleted successfully' }),
            };
        } else {
            return {
                statusCode: 404,
                body: JSON.stringify({ error: 'Document not found' }),
            };
        }
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Internal Server Error' }),
        };
    }
};

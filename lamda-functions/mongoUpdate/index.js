const MongoClient = require('mongodb').MongoClient;

exports.handler = async (event) => {
  const { collectionName, filter, update } = JSON.parse(event.body);

  let client;

  try {
    const uri = `mongodb+srv://${process.env.USERNAME}:${process.env.PASSWORD}@motiv-cluster.apflp3y.mongodb.net/?retryWrites=true&w=majority`;
    const client = new MongoClient(uri);
    const database = client.db(process.env.DATABASE_NAME);
    const collection = database.collection(collectionName);

    // Update the document in the specified collection
    const result = await collection.updateOne(filter, update);

    if (result.matchedCount === 0) {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: 'Document not found' }),
      };
    }

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Document updated successfully' }),
    };
  } catch (err) {
    console.error('Error:', err);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Internal Server Error' }),
    };
  }
};

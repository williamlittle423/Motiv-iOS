const { MongoClient } = require('mongodb');
const bcrypt = require('bcryptjs');

// Parameter 1: Email: The users email
// Parameter 2: Password: Password for query
exports.handler = async (event) => {
    try {
        const uri = `mongodb+srv://${process.env.USERNAME}:${process.env.PASSWORD}@motiv-cluster.apflp3y.mongodb.net/?retryWrites=true&w=majority`;
        const client = new MongoClient(uri);
        const database = client.db(process.env.DATABASE_NAME);
        const usersCollection = database.collection('users');

        // 1. Query database for document containing email
        const email = event.email;
        const user = await usersCollection.findOne({ email: email });

        if (!user) {
            return {
                statusCode: 404,
                body: JSON.stringify({ error: 'User not found' }),
            };
        }

        // 2. Fetch the password in the document
        const storedPassword = user.password;

        // 3. Encrypt the inputted password
        const inputPassword = event.password;
        const passwordMatch = await bcrypt.compare(inputPassword, storedPassword);

        // 4. Check if the encrypted inputted password matches the fetched document password
        if (!passwordMatch) {
            return {
                statusCode: 401,
                body: JSON.stringify({ error: 'Invalid password' }),
            };
        }

        // 6. Return a response of the user
        return {
            statusCode: 200,
            body: JSON.stringify(user),
        };
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Internal Server Error' }),
        };
    }
};
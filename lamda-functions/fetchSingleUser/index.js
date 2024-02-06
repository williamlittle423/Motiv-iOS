const { MongoClient } = require('mongodb');
const AWS = require('aws-sdk');
const s3 = new AWS.S3();

exports.handler = async (event) => {
    
            
    const uri = `mongodb+srv://${process.env.USERNAME}:${process.env.PASSWORD}@motiv-cluster.apflp3y.mongodb.net/?retryWrites=true&w=majority`;
    const client = new MongoClient(uri);

    try {

        const database = client.db(process.env.DATABASE_NAME);

        // Extract the 'userID' value from the document
        const userID = event.userID;

        // Create a query for fetching additional data using the 'userID'
        const userCollection = database.collection('users'); 
        const userQuery = { _id: userID };

        // Execute the query to fetch user data
        const userData = await userCollection.findOne(userQuery);

        if (userData) {
            console.log('Found user');
        }

        // Query profile photo from S3
        console.log('Attempting S3 query for profile photo');
        const { base64Image } = await queryS3ProfileImage(userData._id);
        
        // Add profileImageBase64 to userData
        userData.profileImageBase64 = base64Image;
        
        delete userData.profileImageURL;
        delete userData.password;

        console.log(`Returning user: ${userData}`);
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
    }
};

// Function to query the S3 bucket for the profile image
async function queryS3ProfileImage(userID) {
    try {
        // Construct the S3 object key using the userID
        const objectKey = `students/profilephotos/${userID}_profilephoto.jpg`;

        // Extract the bucket name from environment variables
        const bucketName = process.env.BUCKET_NAME;

        // Download the S3 object
        const s3Response = await s3.getObject({ Bucket: bucketName, Key: objectKey }).promise();

        // Convert the object's binary data to base64
        const base64Image = s3Response.Body.toString('base64');

        return { base64Image };
    } catch (error) {
        console.error('Error querying S3:', error);
        throw error;
    }
}


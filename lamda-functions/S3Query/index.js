const AWS = require('aws-sdk');
const s3 = new AWS.S3();

exports.handler = async (event) => {
    try {
        // Retrieve the object key from the event
        const objectKey = event.objectKey;

        console.log('Attempting S3 query for profile photo with key:', objectKey);
        
        // Query S3
        const s3Data = await queryS3(objectKey);

        return {
            statusCode: 200,
            body: JSON.stringify(s3Data),
        };
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Internal Server Error' }),
        };
    }
};

// Function to query the S3 bucket
async function queryS3(objectKey) {
    try {
        // Extract the bucket name from environment variables
        const bucketName = process.env.BUCKET_NAME;

        // Download the S3 object
        const s3Response = await s3.getObject({ Bucket: bucketName, Key: objectKey }).promise();

        // Convert the object's binary data to base64
        const base64 = s3Response.Body.toString('base64');

        return { key: objectKey, base64: base64 };
    } catch (error) {
        console.error(`Error querying S3 for key ${objectKey}:`, error);
        return { key: objectKey, error: 'Failed to retrieve' };
    }
}
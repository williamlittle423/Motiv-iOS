const AWS = require('aws-sdk');
const S3 = new AWS.S3();

exports.handler = async (event) => {
    try {
        if (!event.body) {
            throw new Error("No data in the event body");
        }

        const body = JSON.parse(event.body);
        const base64String = body.image;
        if (!base64String) {
            throw new Error("No image data in the request body");
        }

        const buffer = Buffer.from(base64String, 'base64');
        const bucketName = 'motivapp-bucket';
        const key = `students/profilephotos/${body.userID}_profilephoto.jpg`;

        const params = {
            Bucket: bucketName,
            Key: key,
            Body: buffer,
            ContentType: 'image/jpg',
            ACL: 'public-read'
        };

        await S3.putObject(params).promise();
        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'Image uploaded successfully', url: `https://${bucketName}.s3.amazonaws.com/${key}` }),
        };
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Error processing request', details: error.message })
        };
    }
};

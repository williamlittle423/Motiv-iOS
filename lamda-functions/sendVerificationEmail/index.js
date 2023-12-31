const sendgridMail = require('@sendgrid/mail');

// Assuming the SendGrid API key is stored as an environment variable for security
sendgridMail.setApiKey(process.env.SENDGRID_API_KEY);

exports.handler = async (event) => {
    // Extract the email and verification code from the event
    const { email, verificationCode } = event;

    const appName = 'Motiv'; // Replace with your actual app name

    // Construct the message object
    const msg = {
        to: email,
        from: 'themotivapp@gmail.com',
        subject: `Your Verification Code for ${appName}`,
        text: `Hello,\n\nThank you for signing up for ${appName}! We're excited to have you on board. To complete your registration, please enter the following verification code in the app:\n\nVerification Code: ${verificationCode}\n\nThis code is valid for the next 10 minutes and can only be used once. If you did not initiate this request, please ignore this email or contact support if you have concerns.\n\nThanks,\nThe ${appName} Team`,
        html: `<p>Hello,</p><p>Thank you for signing up for <strong>${appName}</strong>! We're excited to have you on board. To complete your registration, please enter the following verification code in the app:</p><p><strong>Verification Code: ${verificationCode}</strong></p><p>This code is valid for the next 10 minutes and can only be used once. If you did not initiate this request, please ignore this email or contact support if you have concerns.</p><p>Thanks,<br>The <strong>${appName}</strong> Team</p>`,
    };

    try {
        // Send the email
        await sendgridMail.send(msg);
        console.log('Email sent');
        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'Verification email sent successfully.' })
        };
    } catch (error) {
        console.error('Error sending verification email:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Error sending verification email.' })
        };
    }
};
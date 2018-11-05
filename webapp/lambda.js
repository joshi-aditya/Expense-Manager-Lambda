exports.handler = function (event, context, callback) {

    // Load the SDK for JavaScript
    var AWS = require('aws-sdk');
    // Set the region 
    AWS.config.update({ region: 'us-east-1' });

    var message = event.Records[0].Sns.Message;
    console.log('Message received from SNS:', message);

    //Added to make an entry to Dynamo DB
    // Create the DynamoDB service object
    var ddb = new AWS.DynamoDB({ apiVersion: '2012-10-08' });
    const uuidv1 = require('uuid/v1');
    var token = uuidv1();

    var params = {
        TableName: 'Credentials',
        Item: {
            'token': { S: token },
            'username': { S: message },
        }
    };

    // Call DynamoDB to add the item to the table
    ddb.putItem(params, function (err, data) {
        if (err) {
            console.log("Error", err);
        } else {
            console.log("Success", data);
        }
    });

    callback(null, "Success");
};

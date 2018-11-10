exports.handler = function(event, context, callback) {
    
        // Load the SDK for JavaScript
        var AWS = require('aws-sdk');
        // Set the region 
        AWS.config.update({region: 'us-east-1'});
        
        var message = event.Records[0].Sns.Message;
        console.log('Message received from SNS:', message); 
        
        //Added to make an entry to Dynamo DB
        // Create the DynamoDB service object
        var ddb = new AWS.DynamoDB({apiVersion: '2012-10-08'});
        const uuidv1 = require('uuid/v1');
        var token  = uuidv1();
        
        var expiryTime = 1 * 60; //20 minutes
        var ttl = (new Date).getTime() + expiryTime;
        
        const docClient = new AWS.DynamoDB.DocumentClient();
        
        //First check if the email is present in the table
        var params = {
                ExpressionAttributeNames: {"#username": "username"},
                ExpressionAttributeValues: {":username": message},
                FilterExpression: "#username = :username and attribute_not_exists(Removed)",
                Limit: 20,
                TableName: "Credentials"
            };
            
        docClient.scan(params, function(err, data) {
                if (err) {
                    console.log("Error occured while fetching the record");
                } else if (data.Items.length == 0) {
                    
                   addCredentials();
                    
                } else {
                    
                    console.log("Current Time : " + (new Date).getTime());
                    console.log("TTL is : "+ data.Items[0].ttl);
                    if((data.Items[0].ttl - (new Date).getTime()) > expiryTime)
                    {
                        console.log("Password reset link expired");
                        addCredentials();
                    }
                    else
                    { 
                        console.log("Email already sent!");
                    }
                }
            });
            
        function addCredentials()
        {
           var params2 = {
                          TableName: 'Credentials',
                          Item: {
                            'token' : {S: token},
                            'username' : {S: message},
                            'ttl' : {S: "" + ttl}
                          }
                        };
                        
            // Call DynamoDB to add the item to the table
            ddb.putItem(params2, function(err, data) {
              if (err) {
                console.log("Error", err);
              } else {
                console.log("Success", data);
              }
            });
        }
        
        callback(null, "Success");
    };
    
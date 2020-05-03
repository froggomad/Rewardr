const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

  exports.createUser = functions.https.onCall(async (data, context) => {
    //grab the email and password parameters
    return admin.auth().createUser({
        email: data.email,
        password: data.password
      })
      //create the user
      .then(function(userRecord) {        
        const child = userRecord.uid;
        console.log('Successfully created new user:', child);
        //return JSON
        return {
            status: 201,
            data: {
                "message": child
            }
        };
      })
      //handle errors
      .catch(function(error) {
        console.log();
        //return JSON
        return {
            status: 500,
            data: {
                "error": 'error creating user: ', error
            }
        };
      });
  });
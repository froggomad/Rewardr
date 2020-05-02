const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

//add addMessage()
// Take the text parameter passed to this HTTP endpoint and insert it into the
// Realtime Database under the path /messages/:pushId/original
exports.addMessage = functions.https.onRequest(async (req, res) => {
    // Grab the text parameter.
    const original = req.query.text;
    // Push the new message into the Realtime Database using the Firebase Admin SDK.
    const snapshot = await admin.database().ref('/deleteMe').push({original: original});
    // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
    res.redirect(303, snapshot.ref.toString());
  });

  exports.createUser = functions.https.onRequest(async (req, res) => {
    //grab the email and password parameters
    const userEmail = req.query.email;
    const userPassword = req.query.password;
    const parentID = req.query.parentID;

    await admin.auth().createUser({        
        email: userEmail,
        password: userPassword
      })
      .then(function(userRecord) {
        //TODO: Output uid to app???
        const ref = `/parent/${parentID}/children`;
        const child = userRecord.uid;        
        admin.database().ref(ref).update({child});
        console.log('Successfully created new user:', userRecord.uid);
        res.json({
            status: 201,
            data: {
                "message": userRecord.uid
            }
        });
      })
      .catch(function(error) {
        console.log();
        res.json({
            status: 400,
            data: {
                "message": 'error creating user: ', error
            }
        });
      })
      
  });

const admin = require("firebase-admin");
const functions = require("firebase-functions");

const serviceAccount = require("./service-account.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "firebase-adminsdk-4ei83@diatribapp.iam.gserviceaccount.com"
});

  exports.getToken = functions
      .https.onCall(async (data, _) => {
      const resp =  await admin.auth()
        .createCustomToken(data.uid)
        .then((customToken) => {
          return customToken;
        })
        .catch((error) => {
            return error.code;
        });
        return resp;

  });
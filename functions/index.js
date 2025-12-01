const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.notifyManagers = functions.firestore
    .document("reports/{id}")
    .onCreate(async (snap, context) => {
    
  const report = snap.data();

  const payload = {
    notification: {
      title: "Nuova Segnalazione",
      body: `Treno ${report.serial}, carrozza ${report.carriage}`,
    }
  };

  // invia la notifica a tutti i gestori iscritti
  return admin.messaging().sendToTopic("gestori", payload);
});

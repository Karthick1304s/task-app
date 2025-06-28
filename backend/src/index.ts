// backend/firebase.ts
import admin from "firebase-admin";
import serviceAccount from "firebase-admin";

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
});

export default admin;

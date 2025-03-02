const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Initialize Firebase Admin SDK if not already initialized
if (!admin.apps.length) {
    const serviceAccount = require('./kitakyushu-shukatu-firebase-adminsdk-fbsvc-650fb726e2.json');
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
    });
} else {
    console.log('Firebase admin already initialized');
}

const db = admin.firestore();

// Function to add test data
const addTestData = async () => {
    try {
        // Read the company.json file from parent directory using an absolute path
        const companyFilePath = path.join(__dirname, '..', 'company.json');
        const fileData = fs.readFileSync(companyFilePath, 'utf8');
        const data = JSON.parse(fileData);

        // Add data to Firestore
        const batch = db.batch();

        if (Array.isArray(data)) {
            // If it's an array of companies
            data.forEach((company, index) => {
                const docId = company.id || `company-${index}`;
                const docRef = db.collection('companies').doc(docId);
                batch.set(docRef, company);
            });
            console.log(`Adding ${data.length} companies to Firestore`);
        } else {
            // If it's a single company object
            const docId = data.id || 'company-1';
            const docRef = db.collection('companies').doc(docId);
            batch.set(docRef, data);
            console.log('Adding a single company to Firestore');
        }
        
        // Commit the batch
        await batch.commit();
        console.log('Successfully added company data to Firestore');
        
        return { success: true };
    } catch (error) {
        console.error('Error adding test data:', error);
        return { success: false, error: error.message };
    }
};

// Execute if this file is run directly
if (require.main === module) {
    addTestData()
        .then(result => console.log(result))
        .catch(error => console.error(error));
}

module.exports = addTestData;
const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Inicializar Firebase Admin com as credenciais
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function importData() {
  try {
    console.log('🔄 Iniciando importação...\n');

    // Importar Users
    console.log('📥 Importando users...');
    const usersData = JSON.parse(
      fs.readFileSync(path.join(__dirname, '../mongodb/users.json'), 'utf8')
    );

    const usersCollection = db.collection('users');
    let userCount = 0;
    for (const user of usersData) {
      await usersCollection.add({
        name: user.name,
        email: user.email,
        rating: user.rating,
        reviewCount: user.reviewCount,
        verified: user.verified,
        createdAt: admin.firestore.Timestamp.fromDate(new Date(user.createdAt.$date))
      });
      userCount++;
      console.log(`  ✓ User ${userCount}: ${user.name}`);
    }
    console.log(`✅ ${userCount} users importados!\n`);

    // Importar Offers
    console.log('📥 Importando offers...');
    const offersData = JSON.parse(
      fs.readFileSync(path.join(__dirname, '../mongodb/offers.json'), 'utf8')
    );

    const offersCollection = db.collection('offers');
    let offerCount = 0;
    for (const offer of offersData) {
      await offersCollection.add({
        userName: offer.userName,
        offering: offer.offering,
        offeringDescription: offer.offeringDescription,
        offeringCategory: offer.offeringCategory,
        lookingFor: offer.lookingFor,
        lookingForCategory: offer.lookingForCategory,
        location: offer.location,
        distance: offer.distance,
        rating: offer.rating,
        reviews: offer.reviews,
        verified: offer.verified,
        createdAt: admin.firestore.Timestamp.fromDate(new Date(offer.createdAt.$date))
      });
      offerCount++;
      console.log(`  ✓ Offer ${offerCount}: ${offer.offering}`);
    }
    console.log(`✅ ${offerCount} offers importados!\n`);

    console.log('🎉 Importação completa!');
    console.log(`📊 Total: ${userCount} users + ${offerCount} offers`);
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Erro na importação:', error);
    process.exit(1);
  }
}

importData();

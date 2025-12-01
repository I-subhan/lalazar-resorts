import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'fake-api-key',           // can be anything for emulator
      appId: '1:000000000000:android:000000000000', // fake for emulator
      messagingSenderId: '000000000000', // fake
      projectId: 'demo-project',        // any string
      storageBucket: 'demo-bucket',     // any string
      authDomain: 'demo-project.firebaseapp.com', // optional
      measurementId: 'G-XXXXXXX',       // optional
    );
  }
}

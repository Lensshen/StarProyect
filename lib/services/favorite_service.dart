import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/character_model.dart';

class FavoriteService {
final _auth = FirebaseAuth.instance;
final _db = FirebaseFirestore.instance;

// Si el usuario no está autenticado, usamos un ID por defecto (por ejemplo, "anonUser")
String get _uid => _auth.currentUser?.uid ?? 'anonUser';

Future<void> toggleFavorito(CharacterModel personaje) async {
final ref = _db
.collection('usuarios')
.doc(_uid)
.collection('favoritos')
.doc(personaje.name);

    final snapshot = await ref.get();

if (snapshot.exists) {
  await ref.delete();
} else {
  await ref.set({
    'name': personaje.name,
    'gender': personaje.gender,
    'height': personaje.height,
    'mass': personaje.mass,
    'birth_year': personaje.birthYear,
  });
}
}

  

  Future<bool> esFavorito(String nombre) async {
    if (_uid == null) return false;

    final ref = _db
        .collection('usuarios')
        .doc(_uid)
        .collection('favoritos')
        .doc(nombre);

   final doc = await ref.get();
return doc.exists;

  }

  Future<List<CharacterModel>> obtenerFavoritos() async {
    if (_uid == null) return [];

    final snapshot =
        await _db
            .collection('usuarios')
            .doc(_uid)
            .collection('favoritos')
            .get();

    return snapshot.docs.map((doc) {
  final data = doc.data();
  return CharacterModel.fromJson(data);
}).toList();

  }
}

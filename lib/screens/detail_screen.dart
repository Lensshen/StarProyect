import 'package:flutter/material.dart';
import '../models/character_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/favorite_service.dart';

class CharacterDetailScreen extends StatefulWidget {
  final CharacterModel character;

  const CharacterDetailScreen({Key? key, required this.character})
    : super(key: key);

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  bool _esFavorito = false;

  @override
  void initState() {
    super.initState();
    _verificarFavorito();
  }

  Future<void> _verificarFavorito() async {
    final esFav = await FavoriteService().esFavorito(widget.character.name);
    setState(() => _esFavorito = esFav);
  }

  Future<void> _alternarFavorito() async {
    await FavoriteService().toggleFavorito(widget.character);
    setState(() => _esFavorito = !_esFavorito);

    final mensaje =
        _esFavorito ? 'Agregado a favoritos' : 'Eliminado de favoritos';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.character.name),
        actions: [
          IconButton(
            icon: Icon(_esFavorito ? Icons.favorite : Icons.favorite_border),
            onPressed: _alternarFavorito,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🧍 Nombre: ${widget.character.name}', style: _titleStyle),
            const SizedBox(height: 10),
            Text('👤 Género: ${widget.character.gender}'),
            Text('📏 Altura: ${widget.character.height} cm'),
            Text('⚖️ Masa: ${widget.character.mass} kg'),
            Text('📅 Año de nacimiento: ${widget.character.birthYear}'),
          ],
        ),
      ),
    );
  }

  TextStyle get _titleStyle =>
      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
}

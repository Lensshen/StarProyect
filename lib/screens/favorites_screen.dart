import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/detail_screen.dart';
import '../models/character_model.dart';
import '../services/favorite_service.dart';
import 'detail_screen.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  List<CharacterModel> _favoritos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    final lista = await FavoriteService().obtenerFavoritos();
    setState(() {
      _favoritos = lista;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personajes Favoritos')),
      body:
          _cargando
              ? const Center(child: CircularProgressIndicator())
              : _favoritos.isEmpty
              ? const Center(child: Text('No hay personajes favoritos.'))
              : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _favoritos.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final personaje = _favoritos[index];
                  return ListTile(
                    title: Text(personaje.name),
                    subtitle: Text('Género: ${personaje.gender}'),
                    trailing: const Icon(Icons.favorite, color: Colors.red),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  CharacterDetailScreen(character: personaje),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/character_card.dart';
import '../services/swapi_service.dart';
import '../models/character_model.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SwapiService _swapiService = SwapiService();
  List<CharacterModel> _personajes = [];
  bool _cargando = false;
  final TextEditingController _buscador = TextEditingController();

  @override
  void initState() {
    super.initState();
    _buscarPersonajes(""); // carga inicial
  }

  Future<void> _buscarPersonajes(String nombre) async {
    setState(() => _cargando = true);
    try {
      final resultados = await _swapiService.buscarPersonajes(nombre);
      setState(() => _personajes = resultados);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  void dispose() {
    _buscador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personajes de Star Wars')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _buscador,
              decoration: InputDecoration(
                labelText: 'Buscar personaje...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _buscarPersonajes,
            ),
          ),
          if (_cargando)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _personajes.length,
                itemBuilder: (context, index) {
                  final personaje = _personajes[index];
                  return ListTile(
                    title: Text(personaje.name),
                    subtitle: Text('Género: ${personaje.gender}'),
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
            ),
        ],
      ),
    );
  }
}
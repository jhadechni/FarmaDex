import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../../../core/cache/adapters/registered_pokemon.dart';
import '../../../core/widgets/pokeball_logo.dart';

class PokemonRegisterPage extends StatefulWidget {
  const PokemonRegisterPage({super.key});

  @override
  State<PokemonRegisterPage> createState() => _PokemonRegisterPageState();
}

class _PokemonRegisterPageState extends State<PokemonRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _speciesCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();
  String? _gender;
  File? _image;

  static const platform = MethodChannel('com.pokedex.image');

  Future<void> _pickImage(String source) async {
    try {
      String? path;
      switch (source) {
        case 'camera':
          path = await platform.invokeMethod<String>('openCamera');
          break;
        case 'gallery':
          path = await platform.invokeMethod<String>('openGallery');
          break;
        default:
          throw Exception('Invalid source');
      }

      if (path != null && mounted) {
        setState(() {
          _image = File(path!);
        });
      }
    } on PlatformException catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _image != null &&
        _gender != null) {
      final newPokemon = RegisteredPokemon(
        name: _nameCtrl.text.trim(),
        species: _speciesCtrl.text.trim(),
        height: _heightCtrl.text.trim(),
        weight: _weightCtrl.text.trim(),
        gender: _gender!,
        imagePath: _image!.path,
      );

      final box = Hive.box<RegisteredPokemon>('registered_pokemons');
      box.add(newPokemon);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pokémon registered successfully!')),
      );

      context.pop(); // Return to Home
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please complete all fields including image and gender.')),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _speciesCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage('gallery');
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage('camera');
              },
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarRadius = screenWidth < 400 ? 60.0 : 80.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Create a Pokémon')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: _image != null
                            ? CircleAvatar(
                                radius: avatarRadius,
                                backgroundImage: FileImage(_image!),
                              )
                            : CircleAvatar(
                                radius: avatarRadius,
                                backgroundColor: Colors.grey[200],
                                child: const Icon(Icons.add_a_photo,
                                    size: 40, color: Colors.grey),
                              ),
                      ),
                      Positioned(
                        bottom: -20,
                        child: SizedBox(
                          width: avatarRadius * 2,
                          height: 40,
                          child: const PokeballLogo(
                            size: 40,
                            color: Colors.black12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: _inputDecoration('Name'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _speciesCtrl,
                    decoration: _inputDecoration('Species'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _heightCtrl,
                    decoration: _inputDecoration('Height (m)'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _weightCtrl,
                    decoration: _inputDecoration('Weight (kg)'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                    ],
                    onChanged: (value) => setState(() => _gender = value),
                    decoration: _inputDecoration('Gender'),
                    validator: (v) => v == null ? 'Select a gender' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _submitForm,
                    // ignore: deprecated_member_use
                    icon: const Icon(FontAwesomeIcons.save),
                    label: const Text('Save Pokémon'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

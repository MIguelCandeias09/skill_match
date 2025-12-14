import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/firebase_offer_service.dart';
import '../models/offer_model.dart';
import '../widgets/common_widgets.dart';

class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({Key? key}) : super(key: key);

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  // 1. A variável que estava a dar aviso (agora vai ser usada)
  final _formKey = GlobalKey<FormState>();

  final _offeringController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lookingForController = TextEditingController();

  String _offeringCategory = 'Música';
  String _lookingForCategory = 'Outro';
  bool _isLoading = false;

  final List<String> _categories = [
    'Música',
    'Desporto',
    'Idiomas',
    'Arte',
    'Tecnologia',
    'Culinária',
    'Outro'
  ];

  @override
  void dispose() {
    _offeringController.dispose();
    _descriptionController.dispose();
    _lookingForController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Detetar Web
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: isWeb ? const Color(0xFFF5F5F5) : Colors.white,
      appBar: AppBar(
        title: const Text('Nova Oferta', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Container(
          // Limita a largura na Web para ficar bonito
          width: isWeb ? 600 : double.infinity,
          padding: const EdgeInsets.all(24.0),
          margin: isWeb ? const EdgeInsets.symmetric(vertical: 24) : null,
          decoration: isWeb
              ? BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          )
              : null,
          child: Form(
            // 2. AQUI ESTÁ A CORREÇÃO: Associar a key ao Form
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'O que queres ensinar?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Campo Título
                  AuthTextField(
                    controller: _offeringController,
                    label: 'Título (ex: Aulas de Guitarra)',
                    icon: Icons.title,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insere um título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Categoria
                  DropdownButtonFormField<String>(
                    initialValue: _offeringCategory,
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      prefixIcon: const Icon(Icons.category_outlined, color: Color(0xFF8A4FFF)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF8A4FFF), width: 2),
                      ),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem(value: category, child: Text(category));
                    }).toList(),
                    onChanged: (val) => setState(() => _offeringCategory = val!),
                  ),
                  const SizedBox(height: 16),

                  // Campo Descrição
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Descrição detalhada',
                      alignLabelWithHint: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(Icons.description_outlined, color: Color(0xFF8A4FFF)),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF8A4FFF), width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 10) {
                        return 'A descrição deve ser mais detalhada';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  const Text(
                    'O que procuras em troca?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Campo Procura
                  AuthTextField(
                    controller: _lookingForController,
                    label: 'Interesse (ex: Inglês, Design...)',
                    icon: Icons.swap_horiz_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Diz-nos o que queres aprender';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Categoria Procura
                  DropdownButtonFormField<String>(
                    initialValue: _lookingForCategory,
                    decoration: InputDecoration(
                      labelText: 'Categoria de Interesse',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF8A4FFF)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF8A4FFF), width: 2),
                      ),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem(value: category, child: Text(category));
                    }).toList(),
                    onChanged: (val) => setState(() => _lookingForCategory = val!),
                  ),

                  const SizedBox(height: 40),

                  // Botão Criar
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitOffer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A4FFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Publicar Oferta',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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

  Future<void> _submitOffer() async {
    // 3. AQUI ESTÁ A CORREÇÃO: Usar a key para validar
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final newOffer = Offer(
        id: '', // O Firebase gera isto
        userId: '', // O serviço preenche isto
        userName: '', // O serviço preenche isto
        offering: _offeringController.text.trim(),
        offeringDescription: _descriptionController.text.trim(),
        offeringCategory: _offeringCategory,
        lookingFor: _lookingForController.text.trim(),
        lookingForCategory: _lookingForCategory,
        location: 'Braga, Portugal', // Podes melhorar isto depois com geolocalização
        distance: 0,
        rating: 0,
        reviews: 0,
        verified: false,
        createdAt: DateTime.now(),
      );

      final success = await FirebaseOfferService.createOffer(newOffer);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Oferta criada com sucesso! 🚀'),
            backgroundColor: Color(0xFF8A4FFF),
          ),
        );
        context.pop(); // Fecha o ecrã e volta atrás
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao criar oferta. Tenta novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/firebase_offer_service.dart';
import '../models/offer_model.dart';

class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({Key? key}) : super(key: key);

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  final _formKey = GlobalKey<FormState>();

  final _offeringController = TextEditingController();
  final _descriptionController = TextEditingController();
  // 1. ADICIONADO: Controlador para a localização
  final _locationController = TextEditingController(text: 'Braga, Portugal');
  final _lookingForController = TextEditingController();

  String _offeringCategory = 'Música';
  String _lookingForCategory = 'Outro';
  bool _isLoading = false;

  // Cor principal da app
  final Color _primaryColor = const Color(0xFF8A4FFF);

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
    _locationController.dispose(); // Não esquecer de descartar
    _lookingForController.dispose();
    super.dispose();
  }

  // 2. FUNÇÃO AUXILIAR PARA ESTILIZAR OS CAMPOS
  // Isto garante que todos os campos têm o mesmo estilo bonito e roxo
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      alignLabelWithHint: true,
      prefixIcon: Icon(icon, color: _primaryColor),
      filled: true,
      // Um fundo roxo muito suave para destacar os campos
      fillColor: const Color(0xFFF5F0FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _primaryColor.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      // Fundo ligeiramente diferente na web para destacar o cartão
      backgroundColor: isWeb ? const Color(0xFFF0EDF5) : Colors.white,
      appBar: AppBar(
        title: const Text('Nova Oferta', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Container(
          width: isWeb ? 600 : double.infinity,
          padding: const EdgeInsets.all(24.0),
          margin: isWeb ? const EdgeInsets.symmetric(vertical: 24) : null,
          decoration: isWeb
              ? BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          )
              : null,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // === SECÇÃO 1: O QUE OFERECES ===
                  const Text(
                    'O que queres ensinar? 🎓',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),

                  // Campo Título
                  TextFormField(
                    controller: _offeringController,
                    decoration: _buildInputDecoration('Título (ex: Aulas de Guitarra)', Icons.title),
                    validator: (value) => value == null || value.isEmpty ? 'Insere um título' : null,
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Categoria
                  DropdownButtonFormField<String>(
                    initialValue: _offeringCategory,
                    decoration: _buildInputDecoration('Categoria', Icons.category_outlined),
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
                    decoration: _buildInputDecoration('Descrição detalhada', Icons.description_outlined),
                    validator: (value) => value == null || value.length < 10 ? 'A descrição deve ser mais detalhada' : null,
                  ),

                  const SizedBox(height: 32),

                  // === SECÇÃO 2: LOCALIZAÇÃO (ADICIONADA DE VOLTA) ===
                  const Text(
                    'Onde? 📍',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: _buildInputDecoration('Localização (Cidade, País)', Icons.location_on_outlined),
                    validator: (value) => value == null || value.isEmpty ? 'Indica a localização' : null,
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // === SECÇÃO 3: O QUE PROCURAS ===
                  const Text(
                    'O que procuras em troca? 🤝',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Campo Procura
                  TextFormField(
                    controller: _lookingForController,
                    decoration: _buildInputDecoration('Interesse (ex: Inglês, Design...)', Icons.swap_horiz_outlined),
                    validator: (value) => value == null || value.isEmpty ? 'Diz-nos o que queres aprender' : null,
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Categoria Procura
                  DropdownButtonFormField<String>(
                    initialValue: _lookingForCategory,
                    decoration: _buildInputDecoration('Categoria de Interesse', Icons.search),
                    items: _categories.map((String category) {
                      return DropdownMenuItem(value: category, child: Text(category));
                    }).toList(),
                    onChanged: (val) => setState(() => _lookingForCategory = val!),
                  ),

                  const SizedBox(height: 40),

                  // Botão Criar
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitOffer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        shadowColor: _primaryColor.withValues(alpha: 0.4),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Publicar Oferta',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final newOffer = Offer(
        id: '',
        userId: '',
        userName: '',
        offering: _offeringController.text.trim(),
        offeringDescription: _descriptionController.text.trim(),
        offeringCategory: _offeringCategory,
        lookingFor: _lookingForController.text.trim(),
        lookingForCategory: _lookingForCategory,
        // 3. USAR O VALOR DO CONTROLADOR DE LOCALIZAÇÃO
        location: _locationController.text.trim(),
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
          SnackBar(
            content: const Text('Oferta criada com sucesso! 🚀', style: TextStyle(color: Colors.white)),
            backgroundColor: _primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao criar oferta. Tenta novamente.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }
}
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
  int _currentStep = 0;
  String? _selectedOfferingCategory;
  String? _selectedLookingForCategory;
  final _formKey = GlobalKey<FormState>();

  final _offeringController = TextEditingController();
  final _offeringDescriptionController = TextEditingController();
  final _lookingForController = TextEditingController();
  final _locationController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Música', 'icon': Icons.music_note},
    {'name': 'Desporto', 'icon': Icons.sports_soccer},
    {'name': 'Idiomas', 'icon': Icons.language},
    {'name': 'Arte', 'icon': Icons.palette},
    {'name': 'Tecnologia', 'icon': Icons.computer},
    {'name': 'Culinária', 'icon': Icons.restaurant},
    {'name': 'Artesanato', 'icon': Icons.handyman},
    {'name': 'Fotografia', 'icon': Icons.camera_alt},
  ];

  @override
  void dispose() {
    _offeringController.dispose();
    _offeringDescriptionController.dispose();
    _lookingForController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Oferta'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF8A4FFF).withOpacity(0.03),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  _buildStepIndicator(0, 'Oferta'),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: _currentStep > 0
                          ? const Color(0xFF8A4FFF)
                          : Colors.grey[300],
                    ),
                  ),
                  _buildStepIndicator(1, 'Procura'),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: _currentStep > 1
                          ? const Color(0xFF8A4FFF)
                          : Colors.grey[300],
                    ),
                  ),
                  _buildStepIndicator(2, 'Localização'),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: _buildStepContent(),
              ),
            ),

            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Voltar'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _handlePrimaryAction,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _currentStep < 2 ? 'Continuar' : 'Criar Oferta',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    final isCurrentStep = _currentStep == step;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF8A4FFF) : Colors.grey[300],
            shape: BoxShape.circle,
            border: Border.all(
              color:
              isCurrentStep ? const Color(0xFF8A4FFF) : Colors.transparent,
              width: 3,
            ),
            boxShadow: isCurrentStep
                ? [
              BoxShadow(
                color: const Color(0xFF8A4FFF).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isCurrentStep ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFF8A4FFF) : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildOfferingStep();
      case 1:
        return _buildLookingForStep();
      case 2:
        return _buildLocationStep();
      default:
        return Container();
    }
  }

  Widget _buildOfferingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStepHeader(
          Icons.school_rounded,
          'O que podes ensinar?',
          [Color(0xFF8A4FFF), Color(0xFF6B3FCC)],
        ),
        const SizedBox(height: 32),
        const Text('Categoria',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categories
              .map((c) => _buildCategoryChip(
            c['name'],
            c['icon'],
            _selectedOfferingCategory == c['name'],
                () => setState(() => _selectedOfferingCategory = c['name']),
          ))
              .toList(),
        ),
        if (_selectedOfferingCategory == null)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Seleciona uma categoria',
                style: TextStyle(color: Colors.red, fontSize: 12)),
          ),
        const SizedBox(height: 32),
        AuthTextField(
          controller: _offeringController,
          label: 'Habilidade a oferecer',
          icon: Icons.school_outlined,
          validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _offeringDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Descrição',
            prefixIcon:
            Icon(Icons.description_outlined, color: Color(0xFF8A4FFF)),
          ),
          maxLines: 4,
          validator: (v) =>
          v == null || v.length < 10 ? 'Mínimo 10 caracteres' : null,
        ),
      ],
    );
  }

  Widget _buildLookingForStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStepHeader(
          Icons.psychology_rounded,
          'O que queres aprender?',
          [Color(0xFFFF6B9D), Color(0xFFFF4081)],
        ),
        const SizedBox(height: 32),
        const Text('Categoria',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categories
              .map((c) => _buildCategoryChip(
            c['name'],
            c['icon'],
            _selectedLookingForCategory == c['name'],
                () =>
                setState(() => _selectedLookingForCategory = c['name']),
          ))
              .toList(),
        ),
        if (_selectedLookingForCategory == null)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Seleciona uma categoria',
                style: TextStyle(color: Colors.red, fontSize: 12)),
          ),
        const SizedBox(height: 32),
        AuthTextField(
          controller: _lookingForController,
          label: 'Habilidade desejada',
          icon: Icons.psychology_outlined,
          validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
        ),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStepHeader(
          Icons.location_on_rounded,
          'Onde queres ensinar?',
          [Color(0xFF4CAF50), Color(0xFF2E7D32)],
        ),
        const SizedBox(height: 32),
        AuthTextField(
          controller: _locationController,
          label: 'Localização preferida',
          icon: Icons.location_on_outlined,
          validator: (v) =>
          v == null || v.length < 3 ? 'Mínimo 3 caracteres' : null,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F7FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF8A4FFF).withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF8A4FFF), size: 20),
                  SizedBox(width: 8),
                  Text('Resumo da tua oferta',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF8A4FFF))),
                ],
              ),
              const SizedBox(height: 16),
              _buildSummaryItem(
                  Icons.school_rounded,
                  'Ofereces',
                  _offeringController.text.isEmpty
                      ? 'Não especificado'
                      : _offeringController.text),
              const SizedBox(height: 12),
              _buildSummaryItem(
                  Icons.psychology_rounded,
                  'Procuras',
                  _lookingForController.text.isEmpty
                      ? 'Não especificado'
                      : _lookingForController.text),
              const SizedBox(height: 12),
              _buildSummaryItem(
                  Icons.location_on_rounded,
                  'Localização',
                  _locationController.text.isEmpty
                      ? 'Não especificado'
                      : _locationController.text),
            ],
          ),
        ),
      ],
    );
  }

  void _handlePrimaryAction() {
    if (_validateCurrentStep()) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });
      } else {
        _createOffer();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revê os campos deste passo.')),
      );
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0 && _selectedOfferingCategory == null) return false;
    if (_currentStep == 1 && _selectedLookingForCategory == null) return false;
    if (_currentStep == 0 && _offeringController.text.isEmpty) return false;
    if (_currentStep == 1 && _lookingForController.text.isEmpty) return false;
    if (_currentStep == 2 && _locationController.text.length < 3) return false;
    return true;
  }

  Widget _buildStepHeader(IconData icon, String title, List<Color> colors) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: colors[0], size: 48),
          ),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8A4FFF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF8A4FFF) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF8A4FFF).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF8A4FFF),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF8A4FFF), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9E9E9E),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _createOffer() async {
    FocusScope.of(context).unfocus();
    if (!mounted) return;

    LoadingDialog.show(context);
    try {
      final offer = Offer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        userName: 'User',
        offering: _offeringController.text.trim(),
        offeringDescription: _offeringDescriptionController.text.trim(),
        offeringCategory: _selectedOfferingCategory ?? '',
        lookingFor: _lookingForController.text.trim(),
        lookingForCategory: _selectedLookingForCategory ?? '',
        location: _locationController.text.trim(),
        createdAt: DateTime.now(),
      );

      await FirebaseOfferService.createOffer(offer);
      if (!mounted) return;
      LoadingDialog.hide(context);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8A4FFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle,
                    color: Color(0xFF8A4FFF), size: 64),
              ),
              const SizedBox(height: 24),
              const Text('Oferta Criada!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.pop(); // Fecha o dialog
                  context.pop(true); // MODIFICAÇÃO: Envia 'true' para a Homepage
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      LoadingDialog.hide(context);
      showErrorSnackbar(context, 'Erro ao criar oferta: $e');
    }
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/firebase_auth_service.dart';
import '../widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.arrow_back_rounded,
                  color: Color(0xFF8A4FFF)),
              alignment: Alignment.centerLeft,
            ),
            const SizedBox(height: 20),
            Hero(
              tag: 'logo',
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF8A4FFF),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8A4FFF).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.swap_horiz_rounded,
                    size: 45, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Cria a tua conta',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 40),
            AuthTextField(
              controller: _nameController,
              label: 'Nome completo',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Nome obrigatório';
                if (value.length < 3) return 'Nome demasiado curto';
                return null;
              },
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email obrigatório';
                if (!RegExp(r'^.+@.+\..+$').hasMatch(value))
                  return 'Email inválido';
                return null;
              },
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _passwordController,
              label: 'Palavra-passe',
              icon: Icons.lock_outline,
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Palavra-passe obrigatória';
                if (value.length < 6) return 'Mínimo de 6 caracteres';
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _confirmPasswordController,
              label: 'Confirmar palavra-passe',
              icon: Icons.lock_outline,
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Confirma a palavra-passe';
                if (value != _passwordController.text)
                  return 'Palavras-passe não coincidem';
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) =>
                      setState(() => _acceptTerms = value ?? false),
                  activeColor: const Color(0xFF8A4FFF),
                ),
                Expanded(
                  child: Text('Aceito os Termos e Condições',
                      style: TextStyle(color: Colors.grey[700])),
                ),
              ],
            ),
            const SizedBox(height: 32),
            PrimaryButton(
                text: 'Criar Conta',
                onPressed: _acceptTerms ? _handleRegister : null),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Já tens conta? ',
                    style: TextStyle(color: Colors.grey[600])),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Entrar',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      if (!mounted) return;

      LoadingDialog.show(context);
      try {
        final success = await FirebaseAuthService.register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (!mounted) return;
        LoadingDialog.hide(context);

        if (success) {
          context.go('/homepage');
        } else {
          showErrorSnackbar(context, 'Erro ao criar conta.');
        }
      } catch (e) {
        if (!mounted) return;
        LoadingDialog.hide(context);
        showErrorSnackbar(context, 'Erro ao registar: $e');
      }
    }
  }
}

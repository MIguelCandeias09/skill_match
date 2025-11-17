import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/firebase_auth_service.dart';
import '../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF8A4FFF),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8A4FFF).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.swap_horiz_rounded,
                    size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Bem-vindo de volta!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 48),
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
            const SizedBox(height: 32),
            PrimaryButton(text: 'Entrar', onPressed: _handleLogin),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Não tens conta? ',
                    style: TextStyle(color: Colors.grey[600])),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('Criar conta',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      FocusScope.of(context).unfocus();

      // Show loading indicator
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        final success = await FirebaseAuthService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (!mounted) return;
        Navigator.pop(context); // Close loading dialog

        if (success) {
          context.go('/homepage');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email ou palavra-passe incorretos.')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao entrar: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revê os campos obrigatórios.')),
      );
    }
  }
}

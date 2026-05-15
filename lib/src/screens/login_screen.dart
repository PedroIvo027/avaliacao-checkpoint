import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_usedev/src/services/login_service.dart';
import 'package:projeto_usedev/src/screens/initial_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isAlreadyAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsAuthenticated();
  }

  Future<void> _checkIfUserIsAuthenticated() async {
    final token = await LoginService.getToken();
    if (mounted && token != null && token.isNotEmpty) {
      setState(() {
        _isAlreadyAuthenticated = true;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _performLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha usuário e senha.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await LoginService.login(username, password);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha no login. Verifique suas credenciais.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Image(
                image: AssetImage('assets/logo_usedev.png'),
                height: 100,
              ),
              const SizedBox(height: 60),
              Text(
                'Login',
                style: TextStyle(
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              if (_isAlreadyAuthenticated)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    border: Border.all(color: Colors.green[700]!, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[700], size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Usuário já autenticado.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_isAlreadyAuthenticated) const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                enabled: !_isAlreadyAuthenticated,
                decoration: InputDecoration(
                  hintText: 'Usuário',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                enabled: !_isAlreadyAuthenticated,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Senha',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _isAlreadyAuthenticated ? null : () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isAlreadyAuthenticated ? null : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Redefinição de senha enviada para seu email.')),
                    );
                  },
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: (_isLoading || _isAlreadyAuthenticated) ? null : _performLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (_isAlreadyAuthenticated)
                ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const InitialScreen()),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.purple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Ir para Início',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                ],
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

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

  
  final Color primaryColor = const Color(0xFF7C13F3);
  final Color inputBgColor = const Color(0xFF202024);
  final Color hintTextColor = const Color(0xFF7C7C8A);

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40.0),
                  
                  const Image(
                    image: AssetImage('assets/logo_usedev.png'),
                    height: 100.0,
                  ),
                  const SizedBox(height: 24.0),

                  Text(
                    'LOGIN',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.orbitron(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 32.0),

                  if (_isAlreadyAuthenticated) ...[
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B3B2B),
                        border: Border.all(color: const Color(0xFF4ADE80), width: 1.5),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF4ADE80), size: 26.0),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              'Usuário já autenticado.',
                              style: GoogleFonts.quicksand(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFBBF7D0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                  ],

                  
                  TextField(
                    controller: _usernameController,
                    style: GoogleFonts.quicksand(color: Colors.black87),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Usuário',
                      hintStyle: GoogleFonts.quicksand(color: hintTextColor),
                      prefixIcon: Icon(Icons.person_outline_rounded, color: hintTextColor),
                      filled: false,
                      fillColor: inputBgColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0), 
                        borderSide: BorderSide(color: primaryColor, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: GoogleFonts.quicksand(color: Colors.black87),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      hintStyle: GoogleFonts.quicksand(color: hintTextColor),
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: hintTextColor),
                      filled: false,
                      fillColor: inputBgColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: primaryColor, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: hintTextColor,
                        ),
                        onPressed: _isAlreadyAuthenticated ? null : () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  
                  ElevatedButton(
                    onPressed: (_isLoading || _isAlreadyAuthenticated) ? null : _performLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: primaryColor.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      shape: const StadiumBorder(),
                      elevation: 0.0, 
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'ENTRAR',
                            style: GoogleFonts.orbitron(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),

                  const SizedBox(height: 12.0),

                  Center(
                    child: TextButton(
                      onPressed: _isAlreadyAuthenticated ? null : () {},
                      child: Text(
                        'Esqueceu a senha?',
                        style: GoogleFonts.quicksand(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  
                  if (_isAlreadyAuthenticated) ...[
                    const SizedBox(height: 14.0),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const InitialScreen()),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor, width: 2.0), // Borda roxa exata
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        shape: const StadiumBorder(),
                        elevation: 0.0,
                      ),
                      child: Text(
                        'Ir para Início',
                        style: GoogleFonts.quicksand(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
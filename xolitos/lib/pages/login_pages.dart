import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Este es el Client ID que obtuviste de la Google Cloud Console
// para la plataforma web.
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId:
      '86009060056-b3qfkttk4kmcnodr0nfkid37pcc8stnl.apps.googleusercontent.com',
);

class AgriculturalLoginScreen extends StatefulWidget {
  const AgriculturalLoginScreen({super.key});

  @override
  _AgriculturalLoginScreenState createState() =>
      _AgriculturalLoginScreenState();
}

class _AgriculturalLoginScreenState extends State<AgriculturalLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Navega a otra pantalla o actualiza el estado de la UI
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sesión iniciada como: ${googleUser.displayName}'),
          ),
        );
      }
    } catch (error) {
      print('Error de autenticación: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/agriculture_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay con gradiente
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                  Color.fromARGB(255, 3, 129, 10).withOpacity(0.5),
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),

          // Logo en la esquina superior izquierda
          Positioned(
            top: 50,
            left: 30,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/Isologo.png',
                  height: 40,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AGROORBIT',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Monitoreo Satelital Inteligente.',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Formulario de login centrado y responsivo
          // Se elimina el widget Positioned para que el formulario se centre.
          // Se usa ConstrainedBox para limitar el ancho en pantallas grandes.
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Container(
                // Se elimina el width fijo para que se adapte al ancho disponible
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título del formulario
                    Text(
                      'Bienvenido!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 73, 80, 73),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Por favor, ingresa tus datos para continuar',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 40),

                    // Campo de usuario
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre de usuario',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu nombre de usuario',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF08A20D),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Campo de contraseña
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contraseña',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: '••••••••••',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF08A20D),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Enlace "Forgot password?"
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          print('Olvidaste tu contraseña?');
                        },
                        child: Text(
                          'Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: const Color(0xFF08A20D),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Botón de Sign In
                    Container(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          //Aquí va a modificarse para mandar a mapa
                          if (_usernameController.text == 'Juan Pérez' &&
                              _passwordController.text == '12345678') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Iniciando sesión...'),
                                backgroundColor: Color(0xFF08A20D),
                              ),
                            );
                            Navigator.pushReplacementNamed(context, '/parcel');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Credenciales inválidas'),
                                backgroundColor: Color.fromARGB(255, 189, 6, 6),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 77, 4),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- SECCIÓN AÑADIDA PARA GOOGLE AUTH ---
                    const Center(
                      child: Text(
                        'o',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botón de Iniciar Sesión con Google
                    Container(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => _signInWithGoogle(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.grey[800],
                          elevation: 0,
                          side: BorderSide(color: Colors.grey[300]!, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Aquí puedes añadir un icono de Google si tienes el asset
                            // Por ejemplo: Image.asset('assets/google_logo.png', height: 24),
                            // O un icono simple:
                            Icon(
                              Icons.g_mobiledata,
                              color: Colors.blue[600],
                              size: 30,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Iniciar sesión con Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- FIN DE LA SECCIÓN AÑADIDA ---
                    const SizedBox(height: 32),

                    // Texto de registro
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Eres nuevo? ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              print('Create an Account');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Crea tu cuenta',
                              style: TextStyle(
                                color: Color(0xFF08A20D),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

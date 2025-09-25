import 'package:flutter/material.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AgroOrbitLandingPage(); // <-- solo tu contenido
  }
}

class AgroOrbitLandingPage extends StatelessWidget {
  const AgroOrbitLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/agriculture_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.2),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header/Navigation
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 12),
                        // Logo (no clickeable)
                        Image.asset(
                          'assets/images/Isologo.png',
                          height: 40,                  // ajusta tamaño a tu gusto
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                        const SizedBox(width: 5),
                        Image.asset(
                          'assets/images/nombreLogo1.png',
                          height: 30,                  // ajusta tamaño a tu gusto
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                        const SizedBox(width: 60),
                        // Navigation Items (clickeables)
                        NavItem(
                          text: 'Inicio',
                          color: const Color.fromARGB(255, 0, 145, 17),
                          fontSize: 20,
                          isActive: true,
                          onTap: () {
                            // Si ya estás en /init, no navegues
                            if (ModalRoute.of(context)?.settings.name != '/init') {
                              Navigator.of(context).pushNamedAndRemoveUntil('/init', (r) => false);
                            }
                          },
                        ),
                        const SizedBox(width: 30),
                        NavItem(
                          text: 'Sobre Nosotros',
                          color: Colors.black,
                          fontSize: 20,
                          onTap: () {
                            Navigator.pushNamed(context, '/business'); //ruta
                          },
                        ),
                        const SizedBox(width: 30),
                        const Spacer(),

                        // Registrarse (funciona como botón; navegación comentada)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              // Navigator.pushNamed(context, '/register');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Registrarse...'),
                                  backgroundColor: Color(0xFF08A20D)
                                )
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9ACD32),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Registrarse',
                                style: TextStyle(
                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Entrar (funciona como botón; navegación comentada)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9ACD32),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Entrar',
                                style: TextStyle(
                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Títulos…
                const Text(
                  'Monitoreo Satelital',
                  style: TextStyle(
                    color: Colors.white, fontSize: 74, fontWeight: FontWeight.bold, height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Inteligente',
                  style: TextStyle(
                    color: Colors.white, fontSize: 74, fontWeight: FontWeight.bold, height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Innovar para cosechar.',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),

                // CTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9ACD32),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Empezar Ahora',
                                style: TextStyle(
                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.black, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback? onTap;
  final Color color;
  final Color? activeColor;
   final double fontSize;

  const NavItem({
    super.key,
    required this.text,
    this.isActive = false,
    this.onTap,
    this.color = Colors.black,
    this.fontSize = 16, 
    this.activeColor
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isActive ? (activeColor ?? color) : color;

    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            child: Text(
              text,
              style: TextStyle(
                color: effectiveColor,
                fontSize: 16,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

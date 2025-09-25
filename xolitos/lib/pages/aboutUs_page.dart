// lib/pages/business_landing_page.dart
import 'package:flutter/material.dart';

class BusinessLandingPage extends StatelessWidget {
  const BusinessLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),   
            _buildHeroSection(),
            _buildStatsSection(),
            _buildTeamSection(),
            _buildServicesSection(),
            _buildCTASection(),
          ],
        ),
      ),
    );
  }

  // ───────── HEADER ─────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.business, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                'AGROORBIT',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildNavItem(
                context,
                text: 'Inicio',
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name != '/init') {
                    Navigator.of(context).pushNamedAndRemoveUntil('/init', (r) => false);
                  }
                },
              ),
              _buildNavItem(
                context,
                text: 'Sobre Nosotros',
                isActive: true,
                onTap: () {
                  Navigator.pushNamed(context, '/business'); // about us
                },
              ),
              const SizedBox(width: 20),
              //get stared
              InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Item de navegación clickeable con tamaño configurable
  Widget _buildNavItem(
    BuildContext context, {
    required String text,
    bool isActive = false,
    VoidCallback? onTap,
    double fontSize = 16,
  }) {
    final color = isActive ? Colors.green[600] : Colors.grey[600];

    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: MouseRegion(
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
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ───────── HERO ─────────
  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(80),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nosotros',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Somos un sitio WEB el cual está diseñado para pequeños y medianos agricultores en el cual se digitaliza y optimiza la gestión integral de la información sobre el estado de sus tierras ofreciendo herramientas clave para la toma de decisiones basada en datos, permitiendo así, que cada usuario tenga mayor sostenibilidad y satisfacción al usar la plataforma.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 60),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/Logotipo.png',
                  height: 500,                
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────── STATS ─────────
  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(80),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filosofía Empresarial',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nuestra misión y visión son los pilares que guían cada una de nuestras acciones y decisiones.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              _buildStatCard('Misión', '''Ser un puente tecnológico que conecta a los pequeños y medianos agricultores  a través de una plataforma simple y accesible.Facilitando el acceso a información vital y a herramientas digitales, para que puedan tomar decisiones informadas, optimizar sus operaciones y asegurar la sostenibilidad de sus tierras, para así contribuir a un futuro de seguridad alimentaria.
              Nuestro propósito es, democratizar el acceso a la gestión de datos y herramientas inteligentes, ayudándolos a mejorar su productividad, reducir costos y construir negocios agrícolas más resilientes y prósperos.''', Colors.grey[800]!),
              const SizedBox(width: 20),
              _buildStatCard('Visión', '''Ser la herramienta indispensable para la transformación digital del sector agrícola.Para construir el futuro de ésta, y así unificar y fortalecer a los pequeños y medianos agricultores, asegurando la prosperidad del campo proveyéndoles de herramientas y datos necesarios para competir en el mercado.
              Además de, potenciar el rendimiento de cada cultivo y el éxito de cada agricultor. Nuestro propósito también es, innovar constantemente para ofrecer herramientas digitales que no solo resuelvan los desafíos actuales, sino que también preparen a los agricultores para las oportunidades del futuro.''', Colors.green[600]!)
          ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String description, Color bgColor) {
    return Expanded(
      child: Container(
        height: 280,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── TEAM ─────────
  Widget _buildTeamSection() {
    return Container(
      padding: const EdgeInsets.all(80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Equipo de Trabajo',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'El equipo que transforma AGROORBIT en una realidad.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
              Text(
                'Nuestra pasión y dedicación son el motor que impulsa a AGROORBIT \na ser una plataforma innovadora y confiable para los agricultores.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              List<String> names = [
                'Octavio Quintero Cibrian ',
                'Juan Martin Gonzalez Razo',
                'Eduardo Jara Jimenez',
                'Karla Gpe Carrillo Hernández',
                'Diana Sahagun Hernández',
                'Esteban Nicolás López Mares'
              ];
              List<String> positions = [
                'Asesor Academico',
                'Lider/Backend Developer',
                'CI/CD Developer',
                'Frontend Developer',
                'Área de Finanzas',
                'Área de Contabilidad'
              ];
              return _buildTeamCard(names[index], positions[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(String name, String position) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Center(
                child: Text(
                  '📷 FOTO DEL\nTEAM MEMBER',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  position,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────── SERVICES ─────────
  Widget _buildServicesSection() {
    return Container(
      padding: const EdgeInsets.all(80),
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seamless, Flexible, and\nEfficient Workflow',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Our workflow is designed to support diverse workstyles\nand foster inclusive cultures that enable all employees\nto do their best work.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 60),
          Column(
            children: [
              _buildServiceItem(
                'Designing',
                'Our design process is collaborative, iterative, and focused on creating solutions that not only look great but also solve real problems.',
                '📷 IMAGEN\nDISEÑO',
              ),
              const SizedBox(height: 40),
              _buildServiceItem(
                'Development',
                'We use cutting-edge technologies and best practices to build robust, scalable, and user-friendly applications.',
                '📷 IMAGEN\nDESARROLLO',
              ),
              const SizedBox(height: 40),
              _buildServiceItem(
                'Research',
                'We conduct thorough market research to understand your target audience and competitive landscape.',
                '📷 IMAGEN\nINVESTIGACIÓN',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String title, String description, String imagePlaceholder) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 60),
        Container(
          width: 200,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              imagePlaceholder,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ),
        ),
      ],
    );
  }

  // ───────── CTA ─────────
  Widget _buildCTASection() {
    return Container(
      padding: const EdgeInsets.all(80),
      color: Colors.grey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transform Your Business\nToday - Get in Touch for a\nFree Consultation',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  // Navigator.pushNamed(context, '/business');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Get in Touch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFooterSection('About', ['Story', 'Clients', 'Testimonials']),
              const SizedBox(height: 40),
              _buildFooterSection('Services', ['Designing', 'Development', 'Consulting']),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFooterSection('Locations', ['New York', 'London', 'Sydney']),
              const SizedBox(height: 40),
              _buildFooterSection('Contact', ['info@agency.com', '+1 (555) 000-0000']),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFooterSection('Follow Us', ['LinkedIn', 'Twitter', 'Instagram']),
              const SizedBox(height: 40),
              _buildFooterSection('Newsletter', ['Subscribe to our newsletter']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   title,
        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        // ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(item, style: TextStyle(fontSize: 14, color: Colors.grey[400])),
        )),
      ],
    );
  }
}

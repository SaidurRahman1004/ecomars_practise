import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'John Doe - Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.inter().fontFamily,
        useMaterial3: true,
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      _isScrolled = _scrollController.offset > 50;
    });
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _downloadResume() {
    // In real implementation, this would download a PDF
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Resume'),
        content: const Text('Resume would be downloaded as PDF'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar (Navigation)
          SliverAppBar(
            backgroundColor: _isScrolled
                ? Colors.white.withOpacity(0.95)
                : Colors.transparent,
            elevation: _isScrolled ? 4 : 0,
            floating: true,
            pinned: true,
            snap: false,
            title: Text(
              'JohnDoe',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2563EB),
              ),
            ),
            centerTitle: false,
            actions: [
              _buildNavButton('Home', _homeKey),
              _buildNavButton('About', _aboutKey),
              _buildNavButton('Skills', _skillsKey),
              _buildNavButton('Projects', _projectsKey),
              _buildNavButton('Contact', _contactKey),
              const SizedBox(width: 20),
            ],
          ),

          // Hero Section
          SliverToBoxAdapter(
            key: _homeKey,
            child: _buildHeroSection(),
          ),

          // About Section
          SliverToBoxAdapter(
            key: _aboutKey,
            child: _buildAboutSection(),
          ),

          // Skills Section
          SliverToBoxAdapter(
            key: _skillsKey,
            child: _buildSkillsSection(),
          ),

          // Projects Section
          SliverToBoxAdapter(
            key: _projectsKey,
            child: _buildProjectsSection(),
          ),

          // Contact Section
          SliverToBoxAdapter(
            key: _contactKey,
            child: _buildContactSection(),
          ),

          // Footer
          const SliverToBoxAdapter(
            child: _FooterSection(),
          ),
        ],
      ),
      floatingActionButton: _isScrolled
          ? FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      )
          : null,
    );
  }

  Widget _buildNavButton(String title, GlobalKey key) {
    return TextButton(
      onPressed: () => _scrollToSection(key),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF8FAFC),
            const Color(0xFFF1F5F9),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, I\'m John Doe',
                      style: GoogleFonts.inter(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Flutter App Developer',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'I create beautiful, high-performance mobile applications using Flutter and Firebase. '
                          'Passionate about clean code, user experience, and solving real-world problems with technology.',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        ElevatedButton(
                          onPressed: () => _scrollToSection(_projectsKey),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'View Projects',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: _downloadResume,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: Color(0xFF2563EB)),
                          ),
                          child: Text(
                            'Download Resume',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => _scrollToSection(_contactKey),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: Color(0xFF2563EB)),
                          ),
                          child: Text(
                            'Contact Me',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                child: _buildCodeWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFF87171),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBBF24),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'import \'package:flutter/material.dart\';',
            style: GoogleFonts.robotoMono(
              color: const Color(0xFF2563EB),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '',
            style: GoogleFonts.robotoMono(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Text(
            'void main() {',
            style: GoogleFonts.robotoMono(
              color: const Color(0xFF2563EB),
              fontSize: 14,
            ),
          ),
          Text(
            '  runApp(const MyPortfolio());',
            style: GoogleFonts.robotoMono(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Text(
            '}',
            style: GoogleFonts.robotoMono(
              color: const Color(0xFF2563EB),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '',
            style: GoogleFonts.robotoMono(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Text(
            '// Building mobile experiences',
            style: GoogleFonts.robotoMono(
              color: const Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
          Text(
            '// with passion & precision',
            style: GoogleFonts.robotoMono(
              color: const Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'About Me',
                style: GoogleFonts.inter(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 4,
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(height: 60),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Building Digital Experiences',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'I\'m a passionate Flutter developer with 3+ years of experience creating mobile applications '
                              'for both Android and iOS. My journey in software development started with a curiosity about '
                              'how apps work, which quickly turned into a professional career.',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'I specialize in developing cross-platform applications using Flutter, with a strong focus on '
                              'performance, clean architecture, and excellent user experience. I believe in writing '
                              'maintainable code and following best practices.',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'When I\'m not coding, you can find me contributing to open-source projects, learning new '
                              'technologies, or exploring the latest trends in mobile development.',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Currently focused on:',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildTag('Flutter'),
                            _buildTag('Firebase'),
                            _buildTag('Learning Django'),
                            _buildTag('Clean Architecture'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.2,
                      children: [
                        _buildStatCard('3+', 'Years Experience'),
                        _buildStatCard('24+', 'Projects Completed'),
                        _buildStatCard('15+', 'Happy Clients'),
                        _buildStatCard('100%', 'Satisfaction Rate'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: const Color(0xFF2563EB),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: GoogleFonts.inter(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: const Color(0xFFF8FAFC),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Skills & Technologies',
                style: GoogleFonts.inter(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 4,
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.all(32),
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildSkillCategory(
                          'Mobile Development',
                          FontAwesomeIcons.mobileAlt,
                          ['Flutter', 'Dart', 'State Management', 'REST APIs'],
                        )),
                        const SizedBox(width: 32),
                        Expanded(child: _buildSkillCategory(
                          'Backend & Database',
                          FontAwesomeIcons.server,
                          ['Firebase', 'Cloud Functions', 'Firestore', 'Node.js'],
                        )),
                        const SizedBox(width: 32),
                        Expanded(child: _buildSkillCategory(
                          'Tools & Others',
                          FontAwesomeIcons.tools,
                          ['Git', 'GitHub', 'Figma', 'Analytics'],
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillCategory(String title, IconData icon, List<String> skills) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2563EB), size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: skills.map((skill) => _buildSkillItem(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillItem(String skill) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getSkillIcon(skill),
            size: 32,
            color: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              skill,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSkillIcon(String skill) {
    switch (skill) {
      case 'Flutter':
        return FontAwesomeIcons.flutter;
      case 'Dart':
        return FontAwesomeIcons.code;
      case 'Firebase':
        return FontAwesomeIcons.fire;
      case 'Git':
        return FontAwesomeIcons.gitAlt;
      case 'GitHub':
        return FontAwesomeIcons.github;
      case 'Figma':
        return FontAwesomeIcons.figma;
      default:
        return FontAwesomeIcons.code;
    }
  }

  Widget _buildProjectsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Featured Projects',
                style: GoogleFonts.inter(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 4,
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(child: _buildProjectCard(
                    'E-Commerce App',
                    'A full-featured mobile shopping application with user authentication, product catalog, cart, and payment integration.',
                    ['Flutter', 'Firebase', 'Stripe', 'Provider'],
                  )),
                  const SizedBox(width: 32),
                  Expanded(child: _buildProjectCard(
                    'Task Management Tool',
                    'A collaborative task management application with real-time updates, team features, and progress tracking.',
                    ['Flutter', 'Firestore', 'Bloc', 'WebSockets'],
                  )),
                  const SizedBox(width: 32),
                  Expanded(child: _buildProjectCard(
                    'Weather App',
                    'A beautiful weather application with location detection, 7-day forecasts, and detailed weather information.',
                    ['Flutter', 'OpenWeather API', 'GetX', 'Animations'],
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(String title, String description, List<String> tech) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.shoppingCart,
                size: 60,
                color: const Color(0xFF2563EB),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tech
                      .map((t) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _launchURL(
                            'https://github.com/johndoe/ecommerce-app'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Color(0xFF2563EB)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(FontAwesomeIcons.github,
                                size: 20, color: Color(0xFF2563EB)),
                            const SizedBox(width: 8),
                            Text(
                              'GitHub',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Live Demo',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Get In Touch',
                style: GoogleFonts.inter(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 4,
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(height: 60),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Let\'s Work Together',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'I\'m currently open to new opportunities, whether it\'s a freelance project, '
                              'full-time position, or just a friendly chat about technology.',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildContactItem(
                          FontAwesomeIcons.envelope,
                          'Email',
                          'john.doe@example.com',
                        ),
                        const SizedBox(height: 24),
                        _buildContactItem(
                          FontAwesomeIcons.github,
                          'GitHub',
                          'github.com/johndoe',
                        ),
                        const SizedBox(height: 24),
                        _buildContactItem(
                          FontAwesomeIcons.linkedin,
                          'LinkedIn',
                          'linkedin.com/in/johndoe',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32),
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
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: 'Message',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Message Sent'),
                                  content: const Text(
                                      'Thank you for your message! I\'ll get back to you soon.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Send Message',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: const Color(0xFF2563EB), size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E293B),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'JohnDoe',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Home',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'About',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Skills',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Projects',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Contact',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildSocialButton(FontAwesomeIcons.github),
                      const SizedBox(width: 16),
                      _buildSocialButton(FontAwesomeIcons.linkedin),
                      const SizedBox(width: 16),
                      _buildSocialButton(FontAwesomeIcons.envelope),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
              const SizedBox(height: 40),
              Text(
                '© 2023 John Doe. All rights reserved.',
                style: GoogleFonts.inter(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: Colors.white),
    );
  }
}
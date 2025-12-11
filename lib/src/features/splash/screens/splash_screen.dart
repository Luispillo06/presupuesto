import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import '../../../shared/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;
  late AnimationController _bgController;
  Timer? _navigationTimer;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  late Animation<double> _loadingFade;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateToLogin();
  }

  void _initAnimations() {
    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoRotate = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _loadingFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeOut),
    );

    // Background animation
    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _bgController.repeat();

    // Start animations
    _logoController.forward().then((val) {
      _textController.forward().then((val) {
        _loadingController.forward();
      });
    });
  }

  void _navigateToLogin() {
    _navigationTimer = Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          _buildBackground(),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 24),
                _buildText(),
                const SizedBox(height: 48),
                _buildLoading(),
              ],
            ),
          ),

          // Version info
          Positioned(bottom: 32, left: 0, right: 0, child: _buildVersionInfo()),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor.withValues(alpha: 0.1),
                Colors.white,
                AppTheme.primaryColor.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: CustomPaint(
            painter: _SplashBgPainter(
              _bgController.value,
              AppTheme.primaryColor,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Transform.rotate(
            angle: _logoRotate.value,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withValues(alpha: 0.7),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: const Icon(
                Icons.store_rounded,
                size: 70,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _textSlide.value),
          child: Opacity(
            opacity: _textFade.value,
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withValues(alpha: 0.7),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'MarketMove',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gestion inteligente para tu comercio',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        return Opacity(
          opacity: _loadingFade.value,
          child: Column(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Cargando...',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVersionInfo() {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        return Opacity(
          opacity: _loadingFade.value,
          child: Column(
            children: [
              Text(
                'MarketMove S.L.',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SplashBgPainter extends CustomPainter {
  final double animation;
  final Color color;

  _SplashBgPainter(this.animation, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: 0.05);

    // Animated circles
    final double t = animation * 2 * math.pi;

    canvas.drawCircle(
      Offset(
        size.width * 0.85 + math.sin(t) * 30,
        size.height * 0.15 + math.cos(t) * 30,
      ),
      120,
      paint,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.15 + math.cos(t) * 20,
        size.height * 0.85 + math.sin(t) * 20,
      ),
      100,
      paint,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.5 + math.sin(t + 1) * 15,
        size.height * 0.5 + math.cos(t + 1) * 15,
      ),
      80,
      paint,
    );

    // Additional smaller circles
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: 0.03);

    canvas.drawCircle(
      Offset(
        size.width * 0.7 + math.cos(t * 0.5) * 25,
        size.height * 0.3 + math.sin(t * 0.5) * 25,
      ),
      60,
      paint2,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.3 + math.sin(t * 0.7) * 20,
        size.height * 0.7 + math.cos(t * 0.7) * 20,
      ),
      50,
      paint2,
    );
  }

  @override
  bool shouldRepaint(_SplashBgPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

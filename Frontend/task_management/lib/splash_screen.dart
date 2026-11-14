import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:task_management/screens/auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Rotation animation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Scale animation
    _scaleAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    // Fade animation
    _fadeAnimation = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    );

    // Slide animation
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _logoController.forward();

    // Navigate to Home Screen after 3 seconds
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _logoController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7C5CFC);
    const secondaryColor = Color(0xFF4D8DFF);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF11152E), Color(0xFF1C1B45), Color(0xFF10172F)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background decorative circles
            Positioned(
              top: -100,
              right: -100,
              child: _backgroundCircle(300, primaryColor),
            ),

            Positioned(
              bottom: -120,
              left: -100,
              child: _backgroundCircle(350, secondaryColor),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _logoController,
                      _rotationController,
                      _pulseController,
                    ]),
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: SizedBox(
                            width: 190,
                            height: 190,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer rotating circle
                                Transform.rotate(
                                  angle:
                                      _rotationController.value * 2 * math.pi,
                                  child: Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primaryColor.withOpacity(0.4),
                                        width: 2,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          color: secondaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Pulsing circle
                                Container(
                                  width: 145 + (_pulseController.value * 12),
                                  height: 145 + (_pulseController.value * 12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor.withOpacity(0.08),
                                    border: Border.all(
                                      color: primaryColor.withOpacity(0.2),
                                    ),
                                  ),
                                ),

                                // Logo container
                                Container(
                                  width: 115,
                                  height: 115,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF9478FF),
                                        Color(0xFF5A72F5),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.4),
                                        blurRadius: 35,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.task_alt_rounded,
                                    color: Colors.white,
                                    size: 65,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 45),

                  // Animated app name
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          const Text(
                            'Task Management App',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Organize your life. Achieve more.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 65),

                  // Loading indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              secondaryColor,
                            ),
                            backgroundColor: Colors.white.withOpacity(0.1),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          'GETTING THINGS READY...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom version
            Positioned(
              bottom: 35,
              child: Text(
                'MADE FOR PRODUCTIVITY',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroundCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.07),
      ),
    );
  }
}

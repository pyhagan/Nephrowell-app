import 'package:ckd_mobile/Login%20SignUp/Screen/home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ckd_mobile/Login%20SignUp/signup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Duration for the animations
    );

    // Create a Tween for scaling (pulse effect)
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Create a Tween for fading
    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Create a Tween for spinning (rotation)
    _spinAnimation = Tween<double>(begin: 0.0, end: 4.0 * 3.1415927).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

  
    _animationController.forward().whenComplete(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => SignUpScreen(),
       //builder: (_) => HomeScreen(),
     
      ));
    });
  }

  @override
  void dispose() {
    // Dispose of the animation controller
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Color.fromARGB(255, 6, 60, 104)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _spinAnimation,
                builder: (context, child) {
                  // Applying a 3D transformation using Matrix4
                  final Matrix4 transform = Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Perspective transformation
                    ..rotateY(_spinAnimation.value); // 3D rotation around the Y axis

                  return Transform(
                    transform: transform,
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: _pulseAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: const Text(
                  'NephroWell',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              const Text(
                'Your partner in kidney health',
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

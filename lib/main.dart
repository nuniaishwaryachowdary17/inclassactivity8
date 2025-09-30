import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget with theme switching
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),
      home: FadingTextAnimation(
        onToggleTheme: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

/// Main animation screen
class FadingTextAnimation extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const FadingTextAnimation({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<FadingTextAnimation> createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  bool _showFrame = false;
  Color _textColor = Colors.deepPurple;
  int _currentPage = 0;

  late final AnimationController _rotationController;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _textColor;
        return AlertDialog(
          title: const Text("Pick Text Color"),
          content: BlockPicker(
            pickerColor: _textColor,
            onColorChanged: (color) => tempColor = color,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => _textColor = tempColor);
                Navigator.pop(context);
              },
              child: const Text("Select"),
            ),
          ],
        );
      },
    );
  }

  /// Fading image with optional frame
  Widget _buildFadingImage() {
    return GestureDetector(
      onTap: _toggleVisibility,
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        child: Container(
          decoration: _showFrame
              ? BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 3),
                  borderRadius: BorderRadius.circular(20),
                )
              : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
              width: 220,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  /// Screen 1: fading text + image + frame toggle + rotation
  Widget _buildFirstScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          child: Text(
            "✨ Hello, Flutter!",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: _textColor,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: _textColor.withOpacity(0.6),
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildFadingImage(),
        SwitchListTile(
          title: const Text("Show Frame"),
          value: _showFrame,
          onChanged: (value) => setState(() => _showFrame = value),
        ),
        const SizedBox(height: 20),
        RotationTransition(
          turns: _rotationController,
          child: const Icon(
            Icons.star,
            size: 70,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  /// Screen 2: slower fading + scaling text
  Widget _buildSecondScreen() {
    return Center(
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(seconds: 4),
        curve: Curves.easeInOut,
        child: AnimatedScale(
          scale: _isVisible ? 1.0 : 0.6,
          duration: const Duration(seconds: 4),
          curve: Curves.elasticOut,
          child: Text(
            "🚀 Second Screen Animation!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: _textColor,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(3, 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Page indicator
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        2,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: _currentPage == index ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.purple : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isDark
              ? [Colors.black, Colors.blueGrey.shade900]
              : [Colors.blue.shade100, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("🎨 Fading Text Animation"),
          centerTitle: true,
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          actions: [
            IconButton(
              onPressed: _pickColor,
              icon: const Icon(Icons.color_lens),
            ),
            IconButton(
              onPressed: widget.onToggleTheme,
              icon: Icon(widget.isDark ? Icons.nights_stay : Icons.wb_sunny),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildFirstScreen(),
                  _buildSecondScreen(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildPageIndicator(),
            const SizedBox(height: 20),
          ],
        ),
        floatingActionButton: AnimatedScale(
          scale: _isVisible ? 1.0 : 1.2,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: FloatingActionButton(
            onPressed: _toggleVisibility,
            child: Icon(_isVisible ? Icons.pause : Icons.play_arrow),
          ),
        ),
      ),
    );
  }
}

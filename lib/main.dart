import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in an IDE, or press "r" if you used the command line).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use "hot
        // restart" instead.
        //
        // This works for code too: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        
      ),
      home: const MyHomePage(title: 'Dow Draper\'s flutter project'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that there is a State object (defined below) that contains fields that
  // affect how it looks.

  // This class is the configuration for the state. It holds the values (in
  // this case the the title) provided by the parent (in this case the App
  // widget) and used by the build method of the State class. Fields that are
  // marked "final" in a Widget subclass are always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State class, which in turn causes the framework to
      // rerun the build method below so that the display can reflect the
      // updated values.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B0A5C), Color(0xFF6A0DAD)],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
            letterSpacing: 2.5,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF14032B), Color(0xFF4B0A8A), Color(0xFF14032B)],
          ),
        ),
        child: CustomPaint(
          painter: const OrnateBorderPainter(),
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. Here we use mainAxisAlignment to
                // center the children vertically.
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Dow Draper has pushed the button this many times:',
                    style: TextStyle(
                      color: Color(0xFFFFE9A0),
                      fontStyle: FontStyle.italic,
                      fontSize: 48
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomPaint(
                    painter: const OrnateBorderPainter(
                      gold: Color(0xFFFF2FB0),
                      accent: Color(0xFFFFD700),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        '$_counter',
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// An extremely gaudy ornamental "calligraphy" frame: a swept-gold band, a
/// magenta rule, a fine gold rule, triple-arc corner flourishes with swash
/// bows, S-scrolls, and jeweled diamond studs on every edge. Everything is
/// drawn relative to the painted size, so the same painter frames the whole
/// page and the counter medallion alike.
class OrnateBorderPainter extends CustomPainter {
  const OrnateBorderPainter({
    this.gold = const Color(0xFFFFD700),
    this.accent = const Color(0xFFFF2FB0),
  });

  final Color gold;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.min(size.width, size.height);
    final rect = Offset.zero & size;

    // Outer gold band with a rotating sheen.
    final band = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.02
      ..shader = const SweepGradient(
        colors: [
          Color(0xFFFFD700),
          Color(0xFFFFF7BF),
          Color(0xFFB8860B),
          Color(0xFFFFD700),
        ],
      ).createShader(rect);
    canvas.drawRect(rect.deflate(s * 0.01), band);

    // Magenta rule, then a fine gold rule inside it.
    canvas.drawRect(
      rect.deflate(s * 0.045),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.008
        ..color = accent,
    );
    canvas.drawRect(
      rect.deflate(s * 0.06),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.003
        ..color = gold,
    );

    // Corner flourishes, each rotated into place.
    final corners = <(Offset, double)>[
      (Offset.zero, 0.0),
      (Offset(size.width, 0), math.pi / 2),
      (Offset(size.width, size.height), math.pi),
      (Offset(0, size.height), -math.pi / 2),
    ];
    for (final (corner, rotation) in corners) {
      canvas.save();
      canvas.translate(corner.dx, corner.dy);
      canvas.rotate(rotation);
      _paintCornerFlourish(canvas, s);
      canvas.restore();
    }

    // Jeweled diamond studs sitting on the magenta rule, mid-edge.
    final inset = s * 0.045;
    final studs = [
      Offset(size.width / 2, inset),
      Offset(size.width - inset, size.height / 2),
      Offset(size.width / 2, size.height - inset),
      Offset(inset, size.height / 2),
    ];
    for (final center in studs) {
      _paintDiamond(canvas, center, s * 0.035, gold, accent);
    }
  }

  /// One corner's ornament, drawn with the corner at the origin and the frame
  /// interior toward (+x, +y).
  void _paintCornerFlourish(Canvas canvas, double s) {
    final r = s * 0.15;

    // Triple concentric quarter arcs.
    final arcs = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.012
      ..strokeCap = StrokeCap.round
      ..color = gold;
    for (final k in [1.0, 0.8, 0.6]) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: r * k),
        0,
        math.pi / 2,
        false,
        arcs,
      );
    }

    // Magenta calligraphic swash bowing inside the arcs, then an S-scroll
    // sweeping across the diagonal.
    final swash = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.009
      ..strokeCap = StrokeCap.round
      ..color = accent;
    canvas.drawPath(
      Path()
        ..moveTo(r * 1.15, 0)
        ..cubicTo(r * 0.5, 0, 0, r * 0.5, 0, r * 1.15),
      swash,
    );
    canvas.drawPath(
      Path()
        ..moveTo(r * 0.95, r * 0.15)
        ..cubicTo(r * 1.3, r * 0.35, r * 0.35, r * 1.3, r * 0.15, r * 0.95),
      swash,
    );

    // A jewel capping the diagonal.
    _paintDiamond(canvas, Offset(r * 1.25, r * 1.25), s * 0.022, accent, gold);
  }

  void _paintDiamond(Canvas canvas, Offset center, double radius, Color fill, Color edge) {
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - radius, center.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.25
        ..color = edge,
    );
  }

  @override
  bool shouldRepaint(OrnateBorderPainter oldDelegate) =>
      oldDelegate.gold != gold || oldDelegate.accent != accent;
}

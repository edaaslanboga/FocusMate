import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';


void main() {
  runApp(const FocusMateApp());
}

class FocusMateApp extends StatelessWidget {
  const FocusMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusMate',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const FocusScreen(),
    );
  }
}

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  int altin = 0;
  final CountDownController _controller = CountDownController();

  @override
  void initState() {
    super.initState();
    _loadAltin();
  }

  Future<void> _loadAltin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      altin = prefs.getInt('altin') ?? 0;
    });
  }

  Future<void> _gorevTamamla() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      altin += 1;
      prefs.setInt('altin', altin);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('+1 Altın kazandın! 🥳')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FocusMate')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Toplam Altın: $altin 🪙',
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 30),
            CircularCountDownTimer(
              duration: 1500, // 25 dakika
              initialDuration: 0,
              controller: _controller,
              width: 200,
              height: 200,
              ringColor: Colors.grey[300]!,
              fillColor: Colors.orange,
              backgroundColor: Colors.white,
              strokeWidth: 10.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(fontSize: 33.0, color: Colors.black),
              textFormat: CountdownTextFormat.MM_SS,
              isReverse: true,
              isReverseAnimation: true,
              autoStart: false,
              onComplete: _gorevTamamla,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _controller.start();
              },
              child: const Text('⏳ 25 Dakika Odaklan!'),
            ),
          ],
        ),
      ),
    );
  }
}

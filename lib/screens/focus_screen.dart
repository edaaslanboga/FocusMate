import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

// Widget klasöründen getirilen bileşenler
import '../widgets/gorev_giris.dart';
import '../widgets/altin_gosterge.dart';

final TextEditingController _gorevController = TextEditingController();
String _gorevMetni = '';

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

  // 📦 SharedPreferences ile kayıtlı altını yükle
  Future<void> _loadAltin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      altin = prefs.getInt('altin') ?? 0;
    });
  }

  // 🪙 Sayaç tamamlanınca altın ekle
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🧠 Görev giriş alanı
              GorevGiris(
                controller: _gorevController,
                onChanged: (deger) {
                  setState(() {
                    _gorevMetni = deger;
                  });
                },
              ),

              const SizedBox(height: 20),

              // 🪙 Altın göstergesi
              AltinGosterge(altin: altin),

              const SizedBox(height: 30),

              // ⏱️ Odak sayacı
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

              // 🚀 Görev başlatma butonu
              ElevatedButton(
                onPressed: () {
                  if (_gorevMetni.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lütfen bir görev gir 📝')),
                    );
                    return;
                  }

                  print("Görev başlatıldı: $_gorevMetni");
                  _controller.start();
                },
                child: const Text('⏳ 25 Dakika Odaklan!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

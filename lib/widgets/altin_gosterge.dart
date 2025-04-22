import 'package:flutter/material.dart';

class AltinGosterge extends StatelessWidget {
  final int altin;

  const AltinGosterge({super.key, required this.altin});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Toplam Altın: $altin 🪙',
      style: const TextStyle(fontSize: 24),
    );
  }
}

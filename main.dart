import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const IAAppApostas());
}

class IAAppApostas extends StatelessWidget {
  const IAAppApostas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IA Apostas Premium',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String modo = 'Aviator';
  String casaSelecionada = 'Premier Bet';
  int diasRestantes = 7;
  List<String> fichaMilionaria = [];

  @override
  void initState() {
    super.initState();
    gerarFichaMilionaria();
  }

  void gerarFichaMilionaria() {
    final random = Random();
    final esportes = ['Futebol', 'Basquete', 'Tênis'];
    fichaMilionaria = List.generate(50, (index) {
      double odd1 = (1 + random.nextDouble() * 3);
      double odd2 = (1 + random.nextDouble() * 3);
      String esporte = esportes[random.nextInt(esportes.length)];
      String previsao = random.nextBool() ? 'Vitória Time A' : 'Vitória Time B';
      return '$esporte | $previsao | Odds: ${odd1.toStringAsFixed(2)} vs ${odd2.toStringAsFixed(2)}';
    });
  }

  Color corProbabilidade(String linha) {
    final regex = RegExp(r'Odds: (\d+\.\d+) vs (\d+\.\d+)');
    final match = regex.firstMatch(linha);

    if (match != null) {
      final odd1 = double.tryParse(match.group(1)!) ?? 0;
      final odd2 = double.tryParse(match.group(2)!) ?? 0;
      final media = (odd1 + odd2) / 2;

      if (media < 2.0) return Colors.green;
      if (media > 3.0) return Colors.red;
      return Colors.yellow;
    }
    return Colors.grey;
  }

  Widget buildPainelApostas() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text('?? Casa selecionada: $casaSelecionada',
            style: const TextStyle(fontSize: 18)),
        Text('?? Licença Premium: $diasRestantes dias restantes',
            style: const TextStyle(fontSize: 16, color: Colors.orange)),
        const SizedBox(height: 20),
        const Text('?? Ficha Milionária (IA Premium)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...fichaMilionaria.map(
          (linha) => Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: corProbabilidade(linha).withOpacity(0.15),
              border: Border.all(color: corProbabilidade(linha)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(linha, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  void alternarModo() {
    setState(() {
      modo = (modo == 'Aviator') ? 'Esportes' : 'Aviator';
      gerarFichaMilionaria();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IA de Apostas - Modo $modo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Alternar Modo',
            onPressed: alternarModo,
          ),
        ],
      ),
      body: buildPainelApostas(),
    );
  }
}
import 'package:flutter/material.dart';
import 'dea_code_source.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEA Codi L-4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFDB913), // Groc L4
        ),
      ),
      home: const DeaCodiL4Page(),
    );
  }
}

class DeaCodiL4Page extends StatefulWidget {
  const DeaCodiL4Page({super.key, this.codeSource = const DemoDeaCodeSource()});

  final DeaCodeSource codeSource;

  @override
  State<DeaCodiL4Page> createState() => _DeaCodiL4PageState();
}

class _DeaCodiL4PageState extends State<DeaCodiL4Page> {
  final List<String> estacionsL4 = [
    "La Pau",
    "Besòs",
    "Besòs Mar",
    "El Maresme | Fòrum",
    "Selva de Mar",
    "Poblenou",
    "Llacuna",
    "Bogatell",
    "Ciutadella | Vila Olímpica",
    "Barceloneta",
    "Jaume I",
    "Urquinaona",
    "Passeig de Gràcia",
    "Girona",
    "Verdaguer",
    "Joanic",
    "Alfons X",
    "Guinardó | Hospital de Sant Pau",
    "Maragall",
    "Llucmajor",
    "Via Júlia",
    "Trinitat Nova",
  ];

  String? estacioSeleccionada;
  String codiMostrat = "";
  String? avis;
  bool demostracio = true;
  int requestId = 0;

  Future<void> seleccionarEstacio(String? estacio) async {
    final id = ++requestId;
    setState(() {
      estacioSeleccionada = estacio;
      codiMostrat = "";
      avis = estacio == null ? null : "Carregant…";
    });
    if (estacio == null) return;
    try {
      final result = await widget.codeSource.getCode(estacio);
      if (!mounted || id != requestId) return;
      setState(() {
        codiMostrat = result.displayCode;
        demostracio = result.isDemo;
        avis = null;
      });
    } catch (_) {
      if (!mounted || id != requestId) return;
      setState(() {
        avis = "Codi no disponible. Cal accés autoritzat al servei DEA.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const l4Color = Color(0xFFFDB913);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'DEA Codi L-4',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'by Roberspierre',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: l4Color,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Títol informatiu
            const Text(
              "SISTEMA DE DESBLOQUEIG RECEPTACLE DEA",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // 2. Text de capçalera de l'esquema
            const Text(
              "ESQUEMA D'OBERTURA",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // 3. Foto del teclat real
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedCornerShape(12),
              elevation: 2,
              child: Image.asset(
                'assets/images/teclado.jpg',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            // 4. Selector d'estacions
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: estacioSeleccionada,
                  hint: const Text(
                    "Selecciona una estació",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  isExpanded: true,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: l4Color,
                    size: 30,
                  ),
                  items: estacionsL4.map((String estacio) {
                    return DropdownMenuItem<String>(
                      value: estacio,
                      child: Text(
                        estacio,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: seleccionarEstacio,
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (avis != null)
              Text(avis!, textAlign: TextAlign.center),

            // 5. Resultat del codi i instruccions
            if (codiMostrat.isNotEmpty) ...[
              Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedCornerShape(16),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        demostracio
                            ? "DEMOSTRACIÓ · SENSE CODI REAL"
                            : "CODI D'OBERTURA",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        codiMostrat,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                      const Divider(
                        height: 30,
                        thickness: 1,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "1. Prem 'C' per reiniciar.\n"
                          "2. Introdueix els 4 dígits del codi.\n"
                          "3. Prem 'X'.\n"
                          "4. Gira la maneta i obre la caixa.",
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

ShapeBorder RoundedCornerShape(double radius) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
  );
}
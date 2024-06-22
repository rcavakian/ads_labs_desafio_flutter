import 'package:ads_labs_tarefa_flutter/responsavel_api.dart';
import 'package:ads_labs_tarefa_flutter/tarefa_api.dart';
import 'package:ads_labs_tarefa_flutter/tela_lista_responsavel.dart';
import 'package:ads_labs_tarefa_flutter/tela_lista_tarefa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<TarefaProvider>(
            create: (_) => TarefaProvider(),
          ),
          ChangeNotifierProvider<ResponsavelProvider>(
            create: (_) => ResponsavelProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'ADS Labs Flutter',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'ADS Labs Fase 2'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => navigateToResponsavelListPage(),
              child: const Text('Lista Responsáveis'),
            ),
            ElevatedButton(
              onPressed: () => navigateToTarefaListPage(),
              child: const Text('Lista Tarefas'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToResponsavelListPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ListaResponsavelPage()));
  }

  void navigateToTarefaListPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ListaTarefaPage()));
  }
}

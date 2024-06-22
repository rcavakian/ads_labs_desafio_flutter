import 'package:ads_labs_tarefa_flutter/tarefa_add_ui.dart';
import 'package:ads_labs_tarefa_flutter/tarefa_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TarefaProvider>(
        create: (_) => TarefaProvider(),
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
    Provider.of<TarefaProvider>(context, listen: false).fetchTarefas();
  }

  @override
  Widget build(BuildContext context) {
    final tarefaProvider = Provider.of<TarefaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: tarefaProvider.tarefas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tarefaProvider.tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefaProvider.tarefas[index];
                return ListTile(
                  title: Text(
                    tarefa.titulo,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.person_2),
                        const SizedBox(width: 5),
                        Text('Responsável: ${tarefa.responsavel}'),
                      ]),
                      Row(children: [
                        const Icon(Icons.calendar_today_outlined),
                        const SizedBox(width: 5),
                        Text('Prazo Conclusão: ${DateFormat('yyyy-MM-dd').format(tarefa.dataLimite)}'),
                      ]),
                      Row(children: [
                          const Icon(Icons.work),
                          const SizedBox(width: 5),
                          Text('${tarefa.status}'),
                        ],
                      )
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => navigateToEditTarefa(tarefa.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => tarefaProvider.deleteTarefa(tarefa.id),
                      )
                    ],
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => navigateToAddTarefa(),
      ),
    );
  }

  void navigateToAddTarefa() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddTarefaPage()));
  }
}

void navigateToEditTarefa(int tarefaId) {}

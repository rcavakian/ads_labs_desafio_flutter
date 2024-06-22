import 'package:ads_labs_tarefa_flutter/main.dart';
import 'package:ads_labs_tarefa_flutter/tarefa_edit_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ads_labs_tarefa_flutter/tarefa_add_ui.dart';
import 'package:ads_labs_tarefa_flutter/tarefa_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaTarefaPage extends StatefulWidget {
  const ListaTarefaPage({super.key});

  @override
  State<ListaTarefaPage> createState() => _ListaTarefaPage();
}

class _ListaTarefaPage extends State<ListaTarefaPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<TarefaProvider>(context, listen: false).fetchTarefas();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final tarefaProvider = Provider.of<TarefaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Tarefas'),
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
                        Text(
                            'Prazo Conclusão: ${DateFormat('yyyy-MM-dd').format(tarefa.dataLimite)}'),
                      ]),
                      Row(children: [
                        const Icon(Icons.work),
                        const SizedBox(width: 5),
                        Text('${tarefa.status}'),
                      ]),
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
                  ]),
                );
              }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => navigateToEditTarefa(),
      ),
    );
  }
  void navigateToAddTarefa() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddTarefaPage()));
  }

  void navigateToEditTarefa(int tarefaId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditTarefaPage(tarefaId: tarefaId)
        )
    );
  }

}

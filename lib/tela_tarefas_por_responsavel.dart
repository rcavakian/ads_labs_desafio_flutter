import 'package:ads_labs_tarefa_flutter/tarefa_api.dart';
import 'package:ads_labs_tarefa_flutter/tarefa_edit_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TarefasPorResponsavelPage extends StatefulWidget {
  final int responsavelId;
  const TarefasPorResponsavelPage({super.key, required this.responsavelId});

  @override
  State<TarefasPorResponsavelPage> createState() => _TarefasPorResponsavelPageState();
}

class _TarefasPorResponsavelPageState extends State<TarefasPorResponsavelPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<TarefaProvider>(context, listen: false).fetchTarefasPorId(widget.responsavelId);
  }

  @override
  Widget build(BuildContext context) {
    final tarefaProvider = Provider.of<TarefaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas do Responsável'),
      ),
      body: tarefaProvider.tarefas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
          itemCount: tarefaProvider.tarefas.length,
          itemBuilder: (context, index) {
            final tarefa = tarefaProvider.tarefas[index];
            final isPending = tarefa.isPending;
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              tileColor: isPending ? Colors.red[50] : null,
              title: Text(
                tarefa.titulo,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isPending ? Colors.red : Colors.black),
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
                    Text(tarefa.status ? 'Concluída' : 'Não Concluída'),
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
                  ),
                ],
              ),
            );
          }),
    );
  }

  void navigateToEditTarefa(int tarefaId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditTarefaPage(tarefaId: tarefaId)));
  }
}

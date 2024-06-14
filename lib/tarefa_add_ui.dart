import 'package:ads_labs_tarefa_flutter/tarefa_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

class AddTarefaPage extends StatefulWidget {
  const AddTarefaPage({super.key});

  @override
  State<AddTarefaPage> createState() => _AddTarefaPageState();

}

class _AddTarefaPageState extends State<AddTarefaPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  DateTime dataLimite = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tarefaProvider = Provider.of<TarefaProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tarefa'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: _responsavelController,
                decoration: const InputDecoration(labelText: 'Responsável'),
              ),
              TextField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              Row(
                children: [
                  const Text('Prazo de conclusão: '),
                  TextButton(onPressed: () {
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      onConfirm: (date) {
                        setState(() {
                          dataLimite = date;
                        });
                      },
                    );
                  },
                    child: Text(dataLimite?.toString() ?? "Selecione a data limite de conclusão"),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  final tarefa = Tarefa (
                    id: 0,
                    titulo: _titleController.text,
                    descricao: _descricaoController.text,
                    responsavel: _responsavelController.text,
                    status: _statusController.text,
                    dataLimite: dataLimite,
                  );
                  tarefaProvider.addTarefa(tarefa).then((_) {
                    Navigator.pop(context);
                    tarefaProvider.fetchTarefas();
                  }).catchError((error) {
                  });
                },
                child: const Text('Add Tarefa'),
              )
            ],
          ),
        ),
      ),
    );
  }

}
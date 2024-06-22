import 'package:ads_labs_tarefa_flutter/tarefa_api.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dp;
import 'package:provider/provider.dart';

class EditTarefaPage extends StatefulWidget {
  final int tarefaId;
  const EditTarefaPage({super.key, required this.tarefaId});

  @override
  State<EditTarefaPage> createState() => _EditTarefaPage();
}

class _EditTarefaPage extends State<EditTarefaPage>{
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();
  bool _statusController = false;
  DateTime dataLimite = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tarefaProvider = Provider.of<TarefaProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tarefa'),
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
                keyboardType: TextInputType.number,
              ),
              DropdownButton<bool>(
                value: _statusController,
                onChanged: (bool? newValue) {
                  setState(() {
                    _statusController = newValue!;
                  });
                },
                items: <bool>[true, false].map<DropdownMenuItem<bool>>((bool value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value ? 'Concluída' : 'Não Concluída'),
                  );
              }).toList(),
              ),
              Row(
                children: [
                  const Text('Prazo de conclusão'),
                  TextButton(
                      onPressed: () {
                        dp.DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          onConfirm: (date) {
                            setState(() {
                              dataLimite = date;
                            });
                          }
                        );
                      }, child: Text(dataLimite.toString()),
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    final tarefa = Tarefa(
                      // precisa resolver problema do id da tarefa, precisa recuperar o id do contexto anterior
                      id: widget.tarefaId,
                      titulo: _titleController.text,
                      descricao: _descricaoController.text,
                      responsavel: int.parse(_responsavelController.text),
                      status: _statusController ? true : false,
                      dataLimite: dataLimite,
                    );
                    try {
                      await tarefaProvider.editTarefa(widget.tarefaId, tarefa);
                      await tarefaProvider.fetchTarefas();
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao editar tarefa: $error'),
                          ),
                      );
                    }
                  }, child: const Text('Edit Tarefa'),
              )
            ],
          ),
        )
      ),
    );
  }
}
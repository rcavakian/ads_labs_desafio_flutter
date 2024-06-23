import 'package:ads_labs_tarefa_flutter/tarefa_api.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dp;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditTarefaPage extends StatefulWidget {
  final int tarefaId;
  const EditTarefaPage({super.key, required this.tarefaId});

  @override
  State<EditTarefaPage> createState() => _EditTarefaPage();
}

class _EditTarefaPage extends State<EditTarefaPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();
  bool _statusController = false;
  DateTime? dataLimite;
  // DateTime dataLimite = DateTime.now();

  @override
  void initState() {
    super.initState();
    final tarefaProvider = Provider.of<TarefaProvider>(context, listen: false);
    final tarefaId = widget.tarefaId;

    tarefaProvider.fetchTarefaById(tarefaId).then((tarefa) {
      if (tarefa != null) {
        setState(() {
          _titleController.text = tarefa.titulo;
          _descricaoController.text = tarefa.descricao;
          _responsavelController.text = tarefa.responsavel.toString();
          _statusController = tarefa.status;
          dataLimite = tarefa.dataLimite;
        });
      }
    });
  }

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
              items:
                  <bool>[true, false].map<DropdownMenuItem<bool>>((bool value) {
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
                    dp.DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(), onConfirm: (date) {
                      setState(() {
                        dataLimite = date;
                      });
                    });
                  },
                  child: Text(DateFormat('yyyy/MM/dd').format(DateTime.now())),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final existingTarefa = tarefaProvider.tarefas
                    .firstWhere((t) => t.id == widget.tarefaId);
                final updatedTarefa = Tarefa(
                  id: existingTarefa.id,
                  titulo: _titleController.text.isEmpty ? existingTarefa.titulo : _titleController.text,
                  descricao: _descricaoController.text.isEmpty ? existingTarefa.descricao : _descricaoController.text,
                  responsavel: _responsavelController.text.isEmpty ? existingTarefa.responsavel : int.parse(_responsavelController.text),
                  status: _statusController,
                  dataLimite: dataLimite ?? existingTarefa.dataLimite,
                );
                try {
                  await tarefaProvider.editTarefa(
                      widget.tarefaId, updatedTarefa, existingTarefa);
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
              },
              child: const Text('Edit Tarefa'),
            )
          ],
        ),
      )),
    );
  }
}

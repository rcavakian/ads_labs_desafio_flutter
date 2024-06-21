// import 'package:ads_labs_tarefa_flutter/tarefa_api.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as dp;
// import 'package:provider/provider.dart';
//
// class AddTarefaPage extends StatefulWidget {
//   const AddTarefaPage({super.key});
//
//   @override
//   State<AddTarefaPage> createState() => _AddTarefaPageState();
//
// }
//
// class _AddTarefaPageState extends State<AddTarefaPage> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descricaoController = TextEditingController();
//   final TextEditingController _responsavelController = TextEditingController();
//   final TextEditingController _statusController = TextEditingController();
//   DateTime dataLimite = DateTime.now();
//
//   @override
//   Widget build(BuildContext context) {
//     final tarefaProvider = Provider.of<TarefaProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Tarefa'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(labelText: 'Título'),
//               ),
//               TextField(
//                 controller: _descricaoController,
//                 decoration: const InputDecoration(labelText: 'Descrição'),
//               ),
//               TextField(
//                 controller: _responsavelController,
//                 decoration: const InputDecoration(labelText: 'Responsável'),
//               ),
//               TextField(
//                 controller: _statusController,
//                 decoration: const InputDecoration(labelText: 'Status'),
//               ),
//               Row(
//                 children: [
//                   const Text('Prazo de conclusão: '),
//                   TextButton(onPressed: () {
//                     dp.DatePicker.showDatePicker(
//                       context,
//                       showTitleActions: true,
//                       minTime: DateTime.now(),
//                       onConfirm: (date) {
//                         setState(() {
//                           dataLimite = date;
//                         });
//                       },
//                     );
//                   },
//                     child: Text(dataLimite?.toString() ?? "Selecione a data limite de conclusão"),
//                   ),
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   final tarefa = Tarefa (
//                     id: 0,
//                     titulo: _titleController.text,
//                     descricao: _descricaoController.text,
//                     responsavel: _responsavelController.text,
//                     status: _statusController.text,
//                     dataLimite: dataLimite,
//                   );
//                   tarefaProvider.addTarefa(tarefa).then((_) {
//                     Navigator.pop(context);
//                     tarefaProvider.fetchTarefas();
//                   }).catchError((error) {
//                   });
//                 },
//                 child: const Text('Add Tarefa'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }

import 'package:ads_labs_tarefa_flutter/tarefa_api.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dp;
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
  bool _statusController = false;
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
                    child: Text(value ? 'Concluída' : 'Não concluída'),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  const Text('Prazo de conclusão: '),
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
                        },
                      );
                    },
                    child: Text(dataLimite.toString()),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  final tarefa = Tarefa(
                    id: 0,
                    titulo: _titleController.text,
                    descricao: _descricaoController.text,
                    responsavel: int.parse(_responsavelController.text),
                    status: _statusController ? true : false,
                    dataLimite: dataLimite,
                  );
                  try {
                    await tarefaProvider.addTarefa(tarefa);
                    await tarefaProvider.fetchTarefas();
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao adicionar tarefa: $error'),
                        ),
                    );
                  }
                  // tarefaProvider.addTarefa(tarefa).then((_) {
                  //   Navigator.pop(context);
                  //   tarefaProvider.fetchTarefas();
                  // }).catchError((error) {
                  //   // Handle the error here
                  // });
                },
                child: const Text('Add Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:ads_labs_tarefa_flutter/responsavel_api.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dp;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditResponsavelPage extends StatefulWidget {
  final int responsavelId;
  const EditResponsavelPage({super.key, required this.responsavelId});

  @override
  State<EditResponsavelPage> createState() => _EditResponsavelPage();
}

class _EditResponsavelPage extends State<EditResponsavelPage>{
  final TextEditingController _nomeController = TextEditingController();
  DateTime dataNascimento = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final responsavelProvider = Provider.of<ResponsavelProvider>(context);
    return Scaffold (
      appBar: AppBar(
        title: const Text('Edit Responsável'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              Row(
                children: [
                  const Text('Data de nascimento: '),
                  TextButton(
                    onPressed: () {
                      dp.DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          maxTime: DateTime(2014, 12, 31),
                          onConfirm: (date) {
                            setState(() {
                              dataNascimento = date;
                            });
                          });
                    },
                    child: Text(DateFormat('yyyy/MM/dd').format(dataNascimento)),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  final responsavel = Responsavel(
                      id: widget.responsavelId,
                      nome: _nomeController.text,
                      dataNascimento: dataNascimento
                  );
                  try {
                    await responsavelProvider.editResponsavel(widget.responsavelId, responsavel);
                    await responsavelProvider.fetchResponsaveis();
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar (
                          content: Text('Erro ao editar responsável: $error'),
                        )
                    );
                  }
                }, child: const Text('Editar Responsável'),
              )
            ],
          ),
        )
      ),
    );
  }
}


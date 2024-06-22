import 'package:ads_labs_tarefa_flutter/responsavel_api.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dp;
import 'package:provider/provider.dart';

class AddResponsavelPage extends StatefulWidget {
  const AddResponsavelPage({super.key});

  @override
  State<AddResponsavelPage> createState() => _AddResponsavelPage();
}

class _AddResponsavelPage extends State<AddResponsavelPage> {
  final TextEditingController _nomeController = TextEditingController();
  DateTime dataNascimento = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final responsavelProvider = Provider.of<ResponsavelProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Responsável'),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextButton(
                  onPressed: () {
                    dp.DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        // tentar colocar regra de negocio que aceite nascidos ate 2014
                        maxTime: DateTime(2014, 12, 31),
                        onConfirm: (date) {
                      setState(() {
                        dataNascimento = date;
                      });
                    });
                  },
                  child: Text(dataNascimento.toString()),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final responsavel = Responsavel(
                        id: 0, 
                        dataNascimento: dataNascimento, 
                        nome: _nomeController.text
                    );
                    try {
                      await responsavelProvider.addResponsavel(responsavel);
                      await responsavelProvider.fetchResponsaveis();
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Erro ao adicionar respomsável: $error'),
                        )
                      )
                    }
                  }, child: const Text('Add Responsável'),
                )
              ],
            )),
      ),
    );
  }
}
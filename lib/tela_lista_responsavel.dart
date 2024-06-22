import 'package:ads_labs_tarefa_flutter/main.dart';
import 'package:ads_labs_tarefa_flutter/responsavel_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListaResponsavelPage extends StatefulWidget {
  const ListaResponsavelPage({super.key});

  @override
  State<ListaResponsavelPage> createState() => _ListaResponsavelPage();
}

class _ListaResponsavelPage extends State<ListaResponsavelPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ResponsavelProvider>(context, listen: false)
        .fetchResponsaveis();
  }

  @override
  Widget build(BuildContext context) {
    final responsavelProvider = Provider.of<ResponsavelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Responsaveis'),
      ),
      body: responsavelProvider.responsaveis.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: responsavelProvider.responsaveis.length,
              itemBuilder: (context, index) {
                final responsavel = responsavelProvider.responsaveis[index];
                return ListTile(
                  title: Text(
                    responsavel.nome,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.calendar_today_outlined),
                        const SizedBox(width: 5),
                        Text('Data de nascimento: ${DateFormat('yyyy-MM-dd').format(responsavel.dataNascimento)}'),
                      ])
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => navigateToEditResponsavel(responsavel.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => responsavelProvider.deleteResponsavel(responsavel.id),
                      )
                    ],
                  ),
                );
              }),
    );
  }

void navigateToAddResponsavel() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddResponsavelPage()));
}

  navigateToEditResponsavel(int responsavelId) {}
}

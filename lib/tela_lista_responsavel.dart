import 'package:ads_labs_tarefa_flutter/responsavel_add_ui.dart';
import 'package:ads_labs_tarefa_flutter/responsavel_api.dart';
import 'package:ads_labs_tarefa_flutter/responsavel_edit_ui.dart';
import 'package:ads_labs_tarefa_flutter/tela_tarefas_por_responsavel.dart';
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
        title: const Text('Lista Responsáveis'),
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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.calendar_today_outlined),
                    const SizedBox(width: 5),
                    Text('Data de nascimento: ${DateFormat('yyyy-MM-dd').format(responsavel.dataNascimento)}'),
                  ]),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => navigateToEditResponsavel(responsavel.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => responsavelProvider.deleteResponsavel(responsavel.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.view_list),
                        onPressed: () => navigateToListTarefasById(responsavel.id),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => navigateToAddResponsavel(),
      ),
    );
  }

  void navigateToAddResponsavel() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AddResponsavelPage()));
  }

  navigateToEditResponsavel(int responsavelId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditResponsavelPage(responsavelId: responsavelId)));
  }

  navigateToListTarefasById(int responsavelId) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TarefasPorResponsavelPage(responsavelId: responsavelId),
        )
    );
  }
}

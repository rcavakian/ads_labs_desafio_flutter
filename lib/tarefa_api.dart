import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'consts.dart';

class Tarefa {
  int id;
  final String titulo;
  final String descricao;
  final int responsavel;
  final bool status;
  final DateTime dataLimite;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.responsavel,
    required this.status,
    required this.dataLimite
  });

  bool get isPending {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDate = DateTime(dataLimite.year, dataLimite.month, dataLimite.day); 
    return !status && deadlineDate.isAtSameMomentAs(today) || deadlineDate.isAfter(today);
  }

  factory Tarefa.fromJson (Map<String, dynamic> json) => Tarefa (
    id: json['id'],
    titulo: json['titulo'],
    descricao: json['descricao'],
    responsavel: json['responsavelid'],
    status: json['concluida'],
    dataLimite: DateTime.parse(json['data_limite_conclusao'])
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descricao': descricao,
    'responsavelid': responsavel,
    'concluida': status,
    'data_limite_conclusao': dataLimite.toIso8601String(),
  };

  Map<String, dynamic> toJsonForAdd() => {
    'titulo': titulo,
    'descricao': descricao,
    'responsavelid': responsavel,
    'concluida': status,
    'data_limite_conclusao': dataLimite.toIso8601String(),
  };

  Map<String, dynamic> toJsonForUpdate(Tarefa updatedTarefa) {
    return {
      'titulo': updatedTarefa.titulo ?? titulo,
      'descricao': updatedTarefa.descricao ?? descricao,
      'data_limite_conclusao': updatedTarefa.dataLimite?.toIso8601String() ?? dataLimite.toIso8601String(),
      'concluida': updatedTarefa.status ?? status,
      'responsavelid': updatedTarefa.responsavel ?? responsavel,
    };
  }
}

class TarefaProvider extends ChangeNotifier {
  List<Tarefa> tarefas = [];

  Future<void> fetchTarefas() async {
    const url = 'http://$localhost:3000/tarefa';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> tarefaData = data['dados'];
      tarefas = tarefaData.map((item) => Tarefa.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load tarefas');
    }
  }

  Future<void> fetchTarefasPorId(int idResponsavel) async {
    try {
      final url = Uri.parse('http://$localhost:3000/tarefa?responsavelid=$idResponsavel');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> tarefaData = data['dados'];
        tarefas = tarefaData.map((item) => Tarefa.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load Tarefas do Responsável: $idResponsavel');
      }
    } catch (error) {
      throw Exception('Failed to load Tarefas do Responsável: $idResponsavel');
    }
  }

  Future<void> addTarefa(Tarefa tarefa) async {
    const url = 'http://$localhost:3000/tarefa';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(tarefa.toJsonForAdd()),
    );
    if (response.statusCode != 201) {
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add tarefa');
    } else {
      await fetchTarefas();
      notifyListeners();
    }
  }

  Future<void> deleteTarefa(int tarefaId) async {
    final url = 'http://$localhost:3000/tarefa/$tarefaId';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete tarefa');
    } else {
      tarefas.removeWhere((tarefa) => tarefa.id == tarefaId);
      notifyListeners();
    }
  }

  Future<void> editTarefa(int tarefaId, Tarefa updatedTarefa, Tarefa existingTarefa) async {
    final url = 'http://$localhost:3000/tarefa/$tarefaId';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(existingTarefa.toJsonForUpdate(updatedTarefa)),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao editar tarefa');
    } else {
      final index = tarefas.indexWhere((tarefa) => tarefa.id == tarefaId);
      tarefas[index] = updatedTarefa;
      notifyListeners();
    }
  }

  Future<Tarefa?> fetchTarefaById(int tarefaId) async {
    final url = 'http://$localhost:3000/tarefa/$tarefaId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Tarefa.fromJson(data['dados']);
    } else {
      return null;
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'consts.dart';

class Responsavel {
  int id;
  final String nome;
  final DateTime dataNascimento;

  Responsavel({
    required this.id,
    required this.nome,
    required this.dataNascimento
  });

  factory Responsavel.fromJson (Map<String, dynamic> json) => Responsavel (
    id: json['id'],
    nome: json['nome'],
    dataNascimento: DateTime.parse(json['data_nascimento'])
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'data_nascimento': dataNascimento.toIso8601String(),
  };

  Map<String, dynamic> toJsonForAdd() => {
    'nome': nome,
    'data_nascimento': dataNascimento.toIso8601String(),
  };
}

class ResponsavelProvider extends ChangeNotifier {
  List<Responsavel> responsaveis = [];

  Future<void> fetchResponsaveis() async {
    const url = 'http://$localhost:3000/responsavel';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> responsavelData = data['dados'];
      responsaveis = responsavelData.map((item) => Responsavel.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load responsáveis');
    }
  }

  Future<void> addResponsavel(Responsavel responsavel) async {
    const url = 'http://$localhost:3000/responsavel/';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(responsavel.toJsonForAdd()),
    );
    if (response.statusCode != 201) {
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add tarefa');
    } else {
      fetchResponsaveis();
      notifyListeners();
    }
  }

  Future<void> deleteResponsavel(int responsavelId) async {
    final url = 'http://$localhost:3000/responsavel/$responsavelId';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete responsavel');
    } else {
      responsaveis.removeWhere((tarefa) => tarefa.id == responsavelId);
      notifyListeners();
    }
  }

  Future<void> editResponsavel(int responsavelId, Responsavel updatedResponsavel) async {
    final url = 'http://$localhost:3000/responsavel/$responsavelId';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': "application/json"},
      body: json.encode(updatedResponsavel.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to edit responsavel');
    } else {
      final index = responsaveis.indexWhere((responsavel) => responsavel.id == responsavelId);
      responsaveis[index] = updatedResponsavel;
      notifyListeners();
    }
  }
}
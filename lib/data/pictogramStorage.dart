import 'package:hive/hive.dart';
import '../models/pictogram.dart';
import 'dart:io';
import 'package:flutter/painting.dart';

class Pictogramstorage {
  static const String _boxName = 'pictograms';
  Box<Pictogram>? _box; // Variável que armazenará a instância do Box

  // Método para garantir que o Box seja aberto apenas uma vez
  Future<void> _initializeBox() async {
    if (_box == null) {
      // Se o Box ainda não foi inicializado
      _box = await Hive.openBox<Pictogram>(_boxName);
    }
  }

  // Método para salvar o pictograma
  Future<void> savePictogram(Pictogram pictogram) async {
    await _initializeBox(); // Garante que o Box esteja aberto
    _box!.add(pictogram); // Usa o Box aberto para adicionar o pictograma
  }

  // Método para buscar todos os pictogramas
  Future<List<Pictogram>> getPictograms() async {
    await _initializeBox();
    await _box!
        .compact(); // Compacta para garantir que dados removidos sejam excluídos da memória
    return _box!.values.toList();
  }

  // Método para limpar todos os dados no Box
  Future<void> clearPictograms() async {
    await _initializeBox(); // Garante que o Box esteja aberto
    await _box!.clear(); // Limpa todos os dados armazenados no Box
  }

  Future<void> deletePictograms(List<String> imagePaths) async {
    await _initializeBox(); // Certifica-se de que o box está aberto

    // Lista para armazenar as chaves que precisam ser deletadas
    List<dynamic> keysToDelete = [];

    // Percorre os itens no Hive para encontrar as chaves dos pictogramas a serem removidos
    for (var key in _box!.keys) {
      var pictogram = _box!.get(key);
      if (pictogram != null && imagePaths.contains(pictogram.imagePath)) {
        keysToDelete.add(key); // Armazena a chave real para deleção
      }
    }

    // Remove os itens do Hive usando as chaves corretas
    if (keysToDelete.isNotEmpty) {
      await _box!.deleteAll(keysToDelete);
     
    }

    await _box!.compact();
    
  }
}

import 'package:hive/hive.dart';
import '../models/pictogram.dart';

class Pictogramstorage {
  static const String _boxName = 'pictograms';
  Box<Pictogram>? _box;  // Variável que armazenará a instância do Box

  // Método para garantir que o Box seja aberto apenas uma vez
  Future<void> _initializeBox() async {
    if (_box == null) {  // Se o Box ainda não foi inicializado
      _box = await Hive.openBox<Pictogram>(_boxName);
    }
  }

  // Método para salvar o pictograma
  Future<void> savePictogram(Pictogram pictogram) async {
    await _initializeBox();  // Garante que o Box esteja aberto
    _box!.add(pictogram);  // Usa o Box aberto para adicionar o pictograma
  }

  // Método para buscar todos os pictogramas
  Future<List<Pictogram>> getPictograms() async {
    await _initializeBox();  // Garante que o Box esteja aberto
    return _box!.values.toList();  // Retorna todos os pictogramas
  }

  // Método para limpar todos os dados no Box
  Future<void> clearPictograms() async {
    await _initializeBox();  // Garante que o Box esteja aberto
    await _box!.clear();  // Limpa todos os dados armazenados no Box
  }

  Future<void> deletePictograms(List<String> imagePath) async {
    print('Remove Local images ${imagePath}');
  }
}

import 'package:hive/hive.dart';

part 'pictogram.g.dart';

@HiveType(typeId: 0)
class Pictogram {
  
  @HiveField(0)
  final String imagePath;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String label;

  @HiveField(3)
  final bool isLocal;  // Adicionado campo isLocal

  // Modifique o construtor para inicializar isLocal
  Pictogram({
    required this.imagePath,
    required this.label,
    required this.category,
    this.isLocal = false,  // Adicionando valor padrão para isLocal
  });

  factory Pictogram.fromJson(Map<String, dynamic> json) {
    return Pictogram(
      imagePath: json['imagePath'].toString(),  // Convertendo para String caso necessário
      label: json['label'].toString(),  // Convertendo para String caso necessário
      category: json['category'].toString(),
    );
  }
}

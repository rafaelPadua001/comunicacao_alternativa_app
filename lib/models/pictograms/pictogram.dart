class Pictogram {
  final String id;
  final String label;
  final String category;
  final String imageUrl;
  final DateTime createdAt;

  Pictogram({
    required this.id,
    required this.label,
    required this.category,
    required this.imageUrl,
    required this.createdAt,
  });
 
  // Converte um objeto para um mapa JSON (para salvar no Supabase)
  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'category': category,
      'imageUrl': imageUrl,
      'created_at': createdAt.toIso8601String(), // ISO 8601 (compatível com Supabase)
    };
  }

 

  // Método para converter JSON do Supabase para um objeto Pictogram
  factory Pictogram.fromJson(Map<String, dynamic> json) {
    return Pictogram(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.parse(json['created_at']), // Supabase retorna string ISO
    );
  }
}

class Pictogram {
  final String id;
  final String label;
  final String category;
  final String imageUrl;
  final String userId;
  final DateTime createdAt;

  Pictogram({
    required this.id,
    required this.label,
    required this.category,
    required this.imageUrl,
    required this.userId,
    required this.createdAt,
  });
 
  // Converte um objeto para um mapa JSON (para salvar no Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'category': category,
      'imageUrl': imageUrl,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(), // ISO 8601 (compatível com Supabase)
    };
  }

 

  // Método para converter JSON do Supabase para um objeto Pictogram
  factory Pictogram.fromJson(Map<String, dynamic> json) {
    return Pictogram(
      id: json['id']?.toString() ?? '',
      label: json['label'] ?? 'sem nome',
      category: json['category'] ?? 'sem categoria',
      imageUrl: json['imageUrl'] ?? '',
      userId: json['userId'] ?? '', 
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
      : DateTime.now(),
       // Supabase retorna string ISO
    );
  }
}

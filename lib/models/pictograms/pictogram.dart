import 'package:cloud_firestore/cloud_firestore.dart';

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

  //Conver object to map
  Map<String, dynamic> toMap(){
    return{
      'label': label,
      'category': category,
      'imageUrl': imageUrl,
      'created_at': createdAt,
    };
  }

  //Convert Map to Object pictogram
  factory Pictogram.fromMap(String id, Map<String, dynamic> map) {
    return Pictogram(
      id: id,
      label: map['label'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }
}
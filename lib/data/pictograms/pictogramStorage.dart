import 'package:flutter/material.dart';
import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import '../../models/pictograms/pictogram.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_config.dart';

class PictogramStorage {
  static const String bucketName = 'pictograms';

  //upload image method
  static Future<String?> uploadImage(File image) async {
    try {
      //FileName
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      //upload to supabase storage
      await SupabaseConfig.supabase.storage
          .from(bucketName)
          .upload(fileName, image);

      //url public file
      return '${SupabaseConfig.supabaseUrl}/storage/v1/object/public/pictograms/$fileName';
    } catch (e) {
      print('Erro ao fazer uploadd da imagem: $e');
      return null;
    }
  }

  //save pictograms method
  static Future<bool> savePictogram(
    String label,
    String category,
    String imageUrl,
  ) async {
    try {
      await SupabaseConfig.supabase.from('pictograms_table').insert({
        'label': label,
        'category': category,
        'imageUrl': imageUrl,
      });

      return true;
    } catch (error) {
      print("Erro ao salvar pictograma no banco: $error");
      return false;
    }
  }

static Future<List<Pictogram>> getPictograms() async {
  try {
    final response = await SupabaseConfig.supabase
        .from('pictograms_table')
        .select();

    // Verifique se a resposta contém a chave 'data'
    if (response != null && response is List) {
      List<Pictogram> pictograms = response
          .map<Pictogram>((data) => Pictogram.fromJson(data))
          .toList();
      return pictograms;
    } else {
      print("Formato de resposta inválido ou vazio");
      return [];
    }
  } catch (error) {
    print("Erro ao buscar pictogramas: $error");
    return [];
  }
}
}

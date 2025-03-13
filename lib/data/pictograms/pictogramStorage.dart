import 'package:flutter/material.dart';
import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
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

      final publicUrl = SupabaseConfig.supabase.storage
          .from(bucketName)
          .getPublicUrl(fileName);

      //url public file
      // return '${SupabaseConfig.supabaseUrl}/storage/v1/object/public/pictograms/$fileName';
      return publicUrl;
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
    String userId 
  ) async {
    try {
      await SupabaseConfig.supabase.from('pictograms_table').insert({
        'label': label,
        'category': category,
        'imageUrl': imageUrl,
        'user_id': userId,
      });

      return true;
    } catch (error) {
      print("Erro ao salvar pictograma no banco: $error");
      return false;
    }
  }

  static Future<List<Pictogram>> getPictograms() async {
    try {
      final response =
          await SupabaseConfig.supabase.from('pictograms_table').select();
      print(response);
      // Verifique se a resposta contém a chave 'data'
      if (response != null && response is List) {
        List<Pictogram> pictograms =
            response
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

  static Future<void> deletePictograms(
    BuildContext context,
    List<String> imageUrls,
  ) async {
    for (var imageUrl in imageUrls) {
      try {
        final imageName = Uri.parse(imageUrl).pathSegments.last;
        final correctedPath = '$imageName';

        final storageResponse = await SupabaseConfig.supabase.storage
            .from('pictograms')
            .remove([correctedPath]);

        final response =
            await SupabaseConfig.supabase
                .from('pictograms_table')
                .delete()
                .eq('imageUrl', imageUrl)
                .select();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao tentar deletar a imagem: $e')),
        );
      }
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Processo de exclusão finalizado.')));
  }
}

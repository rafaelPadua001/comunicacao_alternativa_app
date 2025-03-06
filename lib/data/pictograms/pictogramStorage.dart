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

 static Future<void> deletePictograms(List<String> imageNames) async {
  for (var image in imageNames) {
    try {
      final uri = Uri.parse(image);
      final imagePath = uri.pathSegments.last;
      final fullPath = 'pictograms/$imagePath';

      final response = await SupabaseConfig.supabase
          .from('pictograms_table')  // Certifique-se de que o nome da tabela está correto
          .delete()
          .eq('imageUrl', image)
          .select();  // A consulta precisa retornar algo, pode ser uma confirmação

      if (response == null) {
        print('Erro ao tentar deletar a imagem $image: resposta nula');
        continue;
      }

      // Verifique se houve algum erro
      if (response.isEmpty) {
        // Se a resposta estiver vazia, significa que nenhum registro foi deletado
        print('Nenhum registro encontrado para a imagem $image');
      } else {
        // Se a resposta não estiver vazia, a deleção foi bem-sucedida
        print('Imagem $image deletada com sucesso!');
      }

      final storageResponse = await SupabaseConfig.supabase.storage
      .from('pictograms')
      .remove([fullPath]);


      if(storageResponse.isEmpty){
        print('Erro ao tentar deletar a imagem $image do storage ${storageResponse}');
      }
      else{
        print('$image removida do storage com sucesso');
      }
    } catch (e) {
      print('Erro ao tentar deletar a imagem $image: $e');
    }
  }
  print('Delete disparado');
}

}

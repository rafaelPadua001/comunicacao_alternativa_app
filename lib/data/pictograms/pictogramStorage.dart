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

static Future<void> deletePictograms(List<String> imageUrls) async {
  for (var imageUrl in imageUrls) {
    try {
      // 1. Extrai o nome da imagem a partir da URL completa
      final uri = Uri.parse(imageUrl);
      final imageName = uri.pathSegments.last; // Obtém o nome do arquivo (ex: 1741274611930.jpg)

      // 2. Constrói o caminho relativo no formato esperado pelo Supabase Storage
      final correctedPath = 'pictograms/$imageName'.replaceAll('//', '/'); // Substitui qualquer barra extra por uma barra simples

      print('Caminho corrigido para o arquivo: $correctedPath');

      // 3. Remove o registro da tabela no banco de dados
      final response = await SupabaseConfig.supabase
          .from('pictograms_table')  // Certifique-se de que o nome da tabela está correto
          .delete()
          .eq('imageUrl', imageUrl)  // Certifique-se de que o campo imageUrl está correto
          .select();  // A consulta precisa retornar algo, pode ser uma confirmação

      if (response.isEmpty) {
        // Se a resposta estiver vazia, significa que nenhum registro foi deletado
        print('Nenhum registro encontrado para a imagem $imageUrl');
      } else {
        // Se a resposta não estiver vazia, a deleção foi bem-sucedida
        print('Imagem $imageUrl deletada do banco de dados com sucesso!');
      }

      // 4. Tenta remover o arquivo do storage diretamente
      final storageResponse = await SupabaseConfig.supabase.storage
          .from('pictograms')  // Nome do bucket
          .remove([correctedPath]); // Caminho corrigido do arquivo

      // Diagnóstico: Imprimir resposta completa
      print('Resposta do Supabase: $storageResponse');

      if (storageResponse.isEmpty) {
        // Se a lista de arquivos removidos estiver vazia, significa que nenhum arquivo foi removido
        print('Erro ao deletar imagem do storage: A imagem não foi removida');
      } else {
        // Se a lista não estiver vazia, a remoção foi bem-sucedida
        print('Imagem $correctedPath removida do storage com sucesso!');
      }

    } catch (e) {
      print('Erro ao tentar deletar a imagem $imageUrl: $e');
    }
  }
  print('Delete finalizado.');
}

}

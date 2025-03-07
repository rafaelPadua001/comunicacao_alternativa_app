import 'package:comunicacao_alternativa_app/screens/admin/pictograms/addPictogram.dart';
import 'package:flutter/material.dart';
import '../data/pictograms/pictogramStorage.dart' as adminPictograms;
import '../data/pictogramStorage.dart' as localPictograms;


class DeletePictograms {
  final List<String> cloudImages;
  final List<String> localImages;

  DeletePictograms({
    required this.cloudImages,
    required this.localImages,
  });

  void deleteLocalImages(dynamic imageNames){
    print('Image $imageNames removida do armazenamento local');
  }

  void deleteCloudImages(BuildContext context, dynamic imageNames){
    List<String> imagesToDelete = (imageNames is String) ? [imageNames] : List<String>.from(imageNames);

    adminPictograms.PictogramStorage.deletePictograms(context, imagesToDelete);
    for(var imageName in imagesToDelete){
      print('Image $imageName removida da nuvem');
    }
      
  }

  void deleteAll(){
     print("Todas as imagens foram removidas.");
  }

  void showImages(){
    print('Images locais: $localImages');
    print('Images cloud: $cloudImages');
  }
}


// void main(){
//    var addPictograms = AddPictogram();

//   var pictograms = DeletePictograms(
//     localImages: addPictograms.getLocalImages(),
//     cloudImages: addPictograms.getCloudImages(),
//   );

//   pictograms.showImages();
// }
import 'package:flutter/material.dart'; // Ou 'package:flutter/foundation.dart';
class AvatarProvider with ChangeNotifier {
  String? _avatarImage;

  String? get avatarImage => _avatarImage;

  void updateAvatarImage(String newImageUrl) {
    _avatarImage = newImageUrl;
    notifyListeners();
  }
}
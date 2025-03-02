import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Função para fazer login
  Future<UserCredential?> loginWithEmailPassword(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Aqui você pode capturar o erro e exibir mensagens personalizadas
      throw e.message ?? "Erro ao fazer login";
    }
  }

  // Função para sair
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Função para verificar se o usuário está logado
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}

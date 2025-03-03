// import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_config.dart';

class AdminModel {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final SupabaseClient _supabase = SupabaseConfig.supabase;

  // Função para fazer login
  Future<AuthResponse?> loginWithEmailPassword(String email, String password) async {
  try {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    print("Login bem-sucedido: ${response.user?.id}");
    return response;
  } catch (e, stacktrace) {
    print("Erro ao fazer login: $e");
    print("Stacktrace: $stacktrace");
    return null;
  }
}

  // Função para sair
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  // Função para verificar se o usuário está logado
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}

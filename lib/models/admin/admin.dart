// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

    final userId = response.user?.id;
    final userEmail = response.user?.email;
    final userType = 'admin';

    final createProfile = createUserProfile(userId!, userEmail!, userType);

    return response;
  } catch (e, stacktrace) {
    print("Erro ao fazer login: $e");
    print("Stacktrace: $stacktrace");
    return null;
  }
}

  Future<void> createUserProfile(String userId, String userEmail, String userType) async {
  final response = await SupabaseConfig.supabase.from('user_profiles').insert([
    {
      'id': userId, // ID do usuário, que é o user_id do Supabase
      'displayName': 'Admin',
      'email': userEmail,
      'photoUrl': '',
      'userType': userType,  // Nível de acesso (admin, student, professor)
    }
  ]);

  if (response.error != null) {
    print('Erro ao criar perfil: ${response.error?.message}');
  } else {
    print('Perfil criado com sucesso');
  }
}

Future<void> updateUserProfile(String userId, String newRole) async {
  final response = await SupabaseConfig.supabase.from('user_profiles').update({
    'role': newRole,
  }).eq('id', userId);

  if (response.error != null) {
    print('Erro ao atualizar perfil: ${response.error?.message}');
  } else {
    print('Perfil atualizado com sucesso');
  }
}

  // Função para sair
  Future<void> logout() async {
    await _supabase.auth.signOut();
    ;
  }

  // Função para verificar se o usuário está logado
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}

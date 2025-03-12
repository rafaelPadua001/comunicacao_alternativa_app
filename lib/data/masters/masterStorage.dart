import 'package:comunicacao_alternativa_app/services/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/master/master.dart';

class MasterStorage {
  final SupabaseClient _supabase = SupabaseConfig.supabase;

  static Future<String?> registerUser(Master master, {String? phone}) async {
    try {
      final response = await SupabaseConfig.supabase.auth.signUp(
        email: master.email,
        password: 'example-password', //student.password,
        phone: phone, // opcional, apenas se desejar usar o número de telefone
      );

      final Session? session = response.session;
      final User? user = response.user;

      if (user != null) {
        final saveResult = await saveUser(master, user.id);

        if (saveResult != null) {
          return saveResult;
        }

        return saveResult;
      }
    } on AuthException catch (e) {
      print('Erro de autenticação: ${e.message}');
      return e.message; // Retorna a mensagem de erro do Supabase
    } catch (e) {
      print('Erro inesperado ao registrar o aluno: $e');
      return 'Ocorreu um erro inesperado. Tente novamente.';
    }
  }

  static Future<String?> saveUser(Master master, String userId) async {
    try {
      // Insere os dados na tabela `user_profiles`
      final response = await SupabaseConfig.supabase
          .from('user_profiles')
          .insert({
            'id': userId, // ID do usuário (herdado de auth.users.id)
            'displayname': master.fullName,
            'email': master.email, // E-mail do estudante
            'usertype': 'master', // Tipo de usuário (fixo como "student")
          });

      // Sucesso
      return response;
    } on PostgrestException catch (e) {
      // Captura erros específicos do Supabase
      print('Erro ao salvar usuário na tabela: $e');
      return 'Erro ao salvar usuário na tabela: ${e.message}';
    } catch (e) {
      // Captura outros erros
      print('Erro ao salvar usuário na tabela: $e');
      return 'Erro ao salvar usuário na tabela. Tente novamente.';
    }
  }

  Future<AuthResponse?> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e, stacktrace) {
      print("Erro ao fazer login: $e");
      print("Stacktrace: $stacktrace");
      return null;
    }
  }
}

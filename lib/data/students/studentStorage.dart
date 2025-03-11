import 'package:comunicacao_alternativa_app/services/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/student/student.dart';

class StudentStorage {
  final SupabaseClient _supabase = SupabaseConfig.supabase;

  static Future<String?> registerUser(Student student, {String? phone}) async {
    try {
      final response = await SupabaseConfig.supabase.auth.signUp(
        email: student.email,
        password: 'example-password', //student.password,
        phone: phone, // opcional, apenas se desejar usar o número de telefone
      );

      final Session? session = response.session;
      final User? user = response.user;

      if (user != null) {
        final saveResult = await saveUser(student, user.id);

        if (saveResult != null) {
          return saveResult;
        }

        return null;
      }
    } on AuthException catch (e) {
      print('Erro de autenticação: ${e.message}');
      return e.message; // Retorna a mensagem de erro do Supabase
    } catch (e) {
      print('Erro inesperado ao registrar o aluno: $e');
      return 'Ocorreu um erro inesperado. Tente novamente.';
    }
  }

  static Future<String?> saveUser(Student student, String userId) async {
    try {
      // Insere os dados na tabela `user_profiles`
      final response = await SupabaseConfig.supabase
          .from('user_profiles')
          .insert({
            'id': userId, // ID do usuário (herdado de auth.users.id)
            'displayname': student.fullName,
            'email': student.email, // E-mail do estudante
            'usertype': 'student', // Tipo de usuário (fixo como "student")
          });

      // Sucesso
      return null;
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

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = "https://sauizwxtoqjeioawowvs.supabase.co";

  static const String supabaseAnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhdWl6d3h0b3FqZWlvYXdvd3ZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5NjQxOTAsImV4cCI6MjA1NjU0MDE5MH0.CF7avcxCULdJq5NYc-Usv-WdWHodtdIAAcp_miCm0dk";

  static final supabase = SupabaseClient(supabaseUrl, supabaseAnonKey);
}

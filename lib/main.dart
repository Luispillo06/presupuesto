import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/core/supabase/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await SupabaseConfig.initialize();

  runApp(const MarketMoveApp());
}

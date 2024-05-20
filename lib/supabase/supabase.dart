import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider extends ChangeNotifier {
  final url = 'https://gznwbuvjfglgrcckmzeg.supabase.co';
  final anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd6bndidXZqZmdsZ3JjY2ttemVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM5NTM5MzYsImV4cCI6MjAyOTUyOTkzNn0.uHx0t0ZRYQm-mLj3laHNCJgy2YOCTshv1TL0bcEod4E";
  var db;
  var dbS;
  initialize() async {
    db = await Supabase.initialize(url: url, anonKey: anonKey);
    print("supabase inicializována");
  }

  createMuscle() async {
    await Supabase.instance.client.from('muscles').insert({'muscle_name': 'triceps'});
  }
}

class Person {
  final String name;
  final int id;

  Person({required this.id, required this.name}) {}
}

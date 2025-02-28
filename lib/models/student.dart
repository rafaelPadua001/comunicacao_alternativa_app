import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 1)
class Student {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  @HiveField(3)
  final String registration;

  Student({required this.name, required this.age, required this.registration});
}
import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String content;

  @HiveField(2)
  late String createdAt;

  @HiveField(3)
  late String updatedAt;

  Note({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}

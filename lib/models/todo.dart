import 'package:objectbox/objectbox.dart';

@Entity()
class Todo {
  @Id()
  int id = 0;

  String? title;
  String? description;

  @Property(type: PropertyType.date) // Store as int in milliseconds
  DateTime? dueDate;
}

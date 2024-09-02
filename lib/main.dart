import 'package:blue_todo/business_logic/todo_cubit.bloc.dart';
import 'package:blue_todo/components/blueshoe_datefield.dart';
import 'package:blue_todo/components/blueshoe_textfield.dart';
import 'package:blue_todo/models/todo.dart';
import 'package:blue_todo/objectbox.dart';
import 'package:blue_todo/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

late final ObjectBox boxInstance;
late final Store store;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  boxInstance = await ObjectBox.create();
  store = boxInstance.store;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blueshoe Demo",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TodoPage(title: "Blueshoe ToDo Demo Page"),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key, required this.title});

  final String title;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Todo? _newTodo;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoCubit>(
      create: (context) => TodoCubit(todoBox: store.box<Todo>()),
      child: Builder(
        builder: (context) => Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Blue ToDo",
                  style: TextStyle(color: Colors.blue, fontSize: 36.0),
                ),
                const Gap(10.0),
                BlocBuilder<TodoCubit, TodoState>(builder: (context, state) {
                  if (state is TodoInitial || state is TodoLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (state is TodoFailed) {
                    return const Center(
                      child: Text("Failed to load ToDo's :("),
                    );
                  }

                  final doneState = state as TodoDone;

                  if (state.todos.isEmpty) {
                    return const Text(
                      "No ToDo's added yet. Add some via the bottom right FloatingActionButton!",
                    );
                  }

                  return Expanded(
                    child: ListView.separated(
                      itemCount: doneState.todos.length,
                      itemBuilder: (context, index) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Text(doneState.todos[index].title!),
                            subtitle: Text(doneState.todos[index].description!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "due at: ${DateFormat('dd.MM.yyyy').format(doneState.todos[index].dueDate!)}",
                                ),
                                const Gap(8.0),
                                IconButton(
                                    onPressed: () => _deleteTodo(
                                          context,
                                          doneState.todos[index],
                                        ),
                                    icon: Icon(MdiIcons.trashCanOutline))
                              ],
                            ),
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  );
                }),
              ],
            ),
          ),
          floatingActionButton: BlocBuilder<TodoCubit, TodoState>(
            builder: (context, state) => FloatingActionButton(
              onPressed: () => _addTodo(context),
              child: Icon(MdiIcons.plus),
            ),
          ),
        ),
      ),
    );
  }

  _addTodo(BuildContext context) async {
    _newTodo = Todo()..dueDate = DateTime.now();

    final todo = await showAdaptiveDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog.adaptive(
          title: const Text("Add ToDo"),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlueshoeTextfield(
                  "Title",
                  _titleController,
                  isRequired: true,
                ),
                const Gap(8.0),
                BlueshoeTextfield(
                  "Description",
                  _descriptionController,
                ),
                const Gap(8.0),
                BlueshoeDatefield(
                  "Due date",
                  DateFormat("dd.MM.yyyy").format(_newTodo!.dueDate!),
                  () => _showDatePicker(setState),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(
                context,
                _newTodo!
                  ..title = _titleController.text
                  ..description = _descriptionController.text,
              ),
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      }),
    );

    // reset inputs
    _titleController.text = "";
    _descriptionController.text = "";

    if (todo != null) {
      context.read<TodoCubit>().addTodo(todo);
    }
  }

  _showDatePicker(customSetState) async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      customSetState(() {
        _newTodo!.dueDate = pickedDate;
      });
    }
  }

  _deleteTodo(BuildContext context, Todo toDelete) {
    context.read<TodoCubit>().deleteTodo(toDelete);
  }
}

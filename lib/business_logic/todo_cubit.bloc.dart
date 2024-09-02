import 'package:blue_todo/models/todo.dart';
import 'package:blue_todo/objectbox.g.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final Box todoBox;

  TodoCubit({required this.todoBox}) : super(TodoInitial()) {
    loadTodos();
  }

  loadTodos() async {
    emit(TodoLoading());

    try {
      final todos = List<Todo>.from(await todoBox.getAllAsync());
      emit(TodoDone(todos));
    } catch (ex) {
      emit(TodoFailed());
    }
  }

  addTodo(Todo todo) async {
    final state = this.state;

    if (state is TodoDone) {
      final id = await todoBox.putAsync(todo);
      todo.id = id;
      emit(
        TodoDone(
          [
            todo,
            ...state.todos,
          ],
        ),
      );
    }
  }

  deleteTodo(Todo toDelete) async {
    final state = this.state;

    if (state is TodoDone) {
      await todoBox.removeAsync(toDelete.id);
      emit(
        TodoDone(
          state.todos.where((t) => t.id != toDelete.id).toList(),
        ),
      );
    }
  }
}

part of 'todo_cubit.bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

final class TodoInitial extends TodoState {}

final class TodoLoading extends TodoState {}

final class TodoDone extends TodoState {
  final List<Todo> todos;

  const TodoDone(this.todos);

  @override
  List<Object> get props => [
        todos,
      ];
}

// in case anything goes wrong
final class TodoFailed extends TodoState {}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as https;

part 'to_do_list_event.dart';
part 'to_do_list_state.dart';

class ToDoListBloc extends Bloc<ToDoListGetData, ToDoListState> {
  ToDoListBloc() : super(ToDoListInitial()) {
    on<ToDoListGetData>((event, emit) {
      https.get(Uri.parse('https://dummyjson.com/todos'));
    });
  }
}

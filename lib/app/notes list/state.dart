import 'package:get/get.dart';

class NotesState {

  final _isLoading = false.obs;
  set isLoading(bool value) => _isLoading.value = value;
  bool get isLoading => _isLoading.value;

  NotesState();
}

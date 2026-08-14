import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/core/services/task_api_service.dart';
import 'package:demo_sccess_refresh_token_app/models/task/task.dart';

class TaskController extends GetxController {
  TaskController({required this.taskApiService});
  final TaskApiService taskApiService;

  var tasks = <Task>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    isLoading.value = true;
    try {
      final result = await taskApiService.getTasks();
      tasks.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to load tasks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addTask(Task task) async {
    try {
      final created = await taskApiService.createTask(task);
      tasks.add(created);
      return true;
    } catch (e) {
      Get.snackbar("Error", "Failed to create task: $e");
      return false;
    }
  }

  Future<bool> editTask(Task task) async {
    try {
      final updated = await taskApiService.updateTask(task);
      final index = tasks.indexWhere((t) => t.id == updated.id);
      if (index != -1) tasks[index] = updated;
      return true;
    } catch (e) {
      Get.snackbar("Error", "Failed to update task: $e");
      return false;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await taskApiService.deleteTask(id);
      tasks.removeWhere((t) => t.id == id);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete task: $e");
    }
  }

  Future<void> toggleComplete(Task task) async {
    // optimistic update — flip the UI immediately, revert if the API call fails
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) return;
    final newValue = !task.isCompleted;
    tasks[index] = task.copyWith(isCompleted: newValue);

    try {
      final updated = await taskApiService.toggleComplete(task.id!, newValue);
      tasks[index] = updated;
    } catch (e) {
      tasks[index] = task; // revert
      Get.snackbar("Error", "Failed to update task: $e");
    }
  }
}
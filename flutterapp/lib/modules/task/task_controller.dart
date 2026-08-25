import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/core/services/task_api_service.dart';
import 'package:demo_sccess_refresh_token_app/models/task/task.dart';

class TaskController extends GetxController {
  TaskController({required this.taskApiService});
  final TaskApiService taskApiService;

  var tasks = <Task>[].obs;
  var isLoading = false.obs;

  var selectedFilter = Rxn<String>();
  var searchQuery = ''.obs;

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

  void clearTasks() {
    tasks.clear();
    selectedFilter.value = null;
  }

  void selectFilter(String? filter) {
    selectedFilter.value = filter;
  }

  List<String> get categories {
    final set = <String>{};
    for (final t in tasks) {
      if (t.category != null && t.category!.trim().isNotEmpty) {
        set.add(t.category!.trim());
      }
    }
    final list = set.toList()..sort();
    return list;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  List<Task> get filteredTasks {
    final filter = selectedFilter.value;
    List<Task> base;
    if (filter == null) {
      base = tasks.where((t) => !t.isCompleted).toList();
    } else if (filter == '__finished__') {
      base = tasks.where((t) => t.isCompleted).toList();
    } else {
      base = tasks
          .where((t) => t.category == filter && !t.isCompleted)
          .toList();
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return base;
    return base.where((t) => t.title.toLowerCase().contains(query)).toList();
  }

  int get allCount => tasks.where((t) => !t.isCompleted).length;
  int get finishedCount => tasks.where((t) => t.isCompleted).length;

  int countForCategory(String category) =>
      tasks.where((t) => t.category == category && !t.isCompleted).length;

  Future<bool> addTask(Task task) async {
    try {
      final created = await taskApiService.createTask(task);

      tasks.add(created);
      tasks.refresh();

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

      if (index != -1) {
        tasks[index] = updated;
        tasks.refresh();
      }

      return true;
    } catch (e) {
      Get.snackbar("Error", "Failed to update task: $e");
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      await taskApiService.deleteTask(id);

      tasks.removeWhere((t) => t.id == id);

      tasks.refresh();

      return true;
    } catch (e) {
      Get.snackbar("Error", "Failed to delete task: $e");
      return false;
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

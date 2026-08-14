import 'package:demo_sccess_refresh_token_app/data/local/token_store_local.dart';
import 'package:demo_sccess_refresh_token_app/models/task/task.dart';
import 'package:demo_sccess_refresh_token_app/modules/task/task_controller.dart';
import 'package:demo_sccess_refresh_token_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("My Tasks"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.cyan),
              child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 22)),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("All Tasks"),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                TokenStoreLocal.removeToken();
                Get.offAllNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.cyan));
        }
        if (controller.tasks.isEmpty) {
          return const Center(child: Text("No tasks yet. Tap + to add one."));
        }
        return RefreshIndicator(
          onRefresh: controller.fetchTasks,
          child: ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];
              return _TaskTile(task: task, controller: controller);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () => Get.toNamed(AppRoutes.taskForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task, required this.controller});
  final Task task;
  final TaskController controller;

  Color _priorityColor() {
    switch (task.priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => controller.deleteTask(task.id!),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => controller.toggleComplete(task),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.deadline != null
            ? Text("Due: ${task.deadline!.toLocal()}".split('.').first)
            : null,
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: _priorityColor(), shape: BoxShape.circle),
        ),
        onTap: () => Get.toNamed(AppRoutes.taskForm, arguments: task),
      ),
    );
  }
}
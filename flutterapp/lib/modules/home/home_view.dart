import 'package:demo_sccess_refresh_token_app/data/local/token_store_local.dart';
import 'package:demo_sccess_refresh_token_app/models/task/task.dart';
import 'package:demo_sccess_refresh_token_app/modules/task/task_controller.dart';
import 'package:demo_sccess_refresh_token_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/constants/colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSearching = false;
  final searchCtrl = TextEditingController();

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        foregroundColor: Colors.white,

        title: isSearching
            ? TextField(
                controller: searchCtrl,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search tasks...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: controller.updateSearch,
              )
            : Obx(() {
                final filter = controller.selectedFilter.value;

                final title = filter == null
                    ? "All Tasks"
                    : filter == '__finished__'
                    ? "Finished"
                    : filter;

                return Text(title);
              }),

        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;

                if (!isSearching) {
                  searchCtrl.clear();
                  controller.updateSearch('');
                }
              });
            },
          ),
        ],
      ),
      drawer: _TaskDrawer(controller: controller),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        final list = controller.filteredTasks;
        if (list.isEmpty) {
          return const Center(child: Text("No tasks here. Tap + to add one."));
        }
        return RefreshIndicator(
          onRefresh: controller.fetchTasks,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _TaskTile(task: list[index], controller: controller);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.darkNavy,
        onPressed: () => Get.toNamed(AppRoutes.taskForm),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _TaskDrawer extends StatelessWidget {
  const _TaskDrawer({required this.controller});
  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkNavy,
      child: SafeArea(
        child: Obx(() {
          final selected = controller.selectedFilter.value;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.navy, AppColors.darkNavy],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "To Do List",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Signed in",
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "TASK LISTS",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              _DrawerItem(
                icon: Icons.home_outlined,
                label: "All Tasks",
                count: controller.allCount,
                selected: selected == null,
                onTap: () {
                  controller.selectFilter(null);
                  Get.back();
                },
              ),
              ...controller.categories.map((cat) {
                return _DrawerItem(
                  icon: Icons.list_alt_outlined,
                  label: cat,
                  count: controller.countForCategory(cat),
                  selected: selected == cat,
                  onTap: () {
                    controller.selectFilter(cat);
                    Get.back();
                  },
                );
              }),
              _DrawerItem(
                icon: Icons.check_circle_outline,
                label: "Finished",
                count: controller.finishedCount,
                selected: selected == '__finished__',
                onTap: () {
                  controller.selectFilter('__finished__');
                  Get.back();
                },
              ),
              const Divider(color: Colors.white24, height: 32),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white70),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  TokenStoreLocal.removeToken();
                  controller.clearTasks();
                  Get.offAllNamed(AppRoutes.login);
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  static const _accent = Color(0xFF3D7BFF);
  static const _selectedBg = Color(0xFF223A5E);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: selected ? _selectedBg : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: Colors.white70, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (count > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$count",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
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
          decoration: BoxDecoration(
            color: _priorityColor(),
            shape: BoxShape.circle,
          ),
        ),
        onTap: () => Get.toNamed(AppRoutes.taskForm, arguments: task),
      ),
    );
  }
}

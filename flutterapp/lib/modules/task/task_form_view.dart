import 'package:demo_sccess_refresh_token_app/models/task/task.dart';
import 'package:demo_sccess_refresh_token_app/modules/task/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskFormView extends StatefulWidget {
  const TaskFormView({super.key});

  @override
  State<TaskFormView> createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> {
  final controller = Get.find<TaskController>();
  late final Task? editingTask;

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  Priority priority = Priority.medium;
  DateTime? deadline;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    editingTask = Get.arguments as Task?;
    if (editingTask != null) {
      titleCtrl.text = editingTask!.title;
      descCtrl.text = editingTask!.description ?? '';
      categoryCtrl.text = editingTask!.category ?? '';
      priority = editingTask!.priority;
      deadline = editingTask!.deadline;
    }
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: deadline ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) setState(() => deadline = picked);
  }

  Future<void> _save() async {
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar("Error", "Title is required");
      return;
    }

    setState(() => isSaving = true);

    final task = Task(
      id: editingTask?.id,
      title: titleCtrl.text.trim(),
      description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
      priority: priority,
      category: categoryCtrl.text.trim().isEmpty ? null : categoryCtrl.text.trim(),
      createdAt: editingTask?.createdAt ?? DateTime.now(),
      deadline: deadline,
      isCompleted: editingTask?.isCompleted ?? false,
    );

    final success = editingTask == null
        ? await controller.addTask(task)
        : await controller.editTask(task);

    setState(() => isSaving = false);

    if (success) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = editingTask != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Task" : "New Task")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categoryCtrl,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            const SizedBox(height: 16),
            const Text("Priority", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: Priority.values.map((p) {
                return ChoiceChip(
                  label: Text(p.name),
                  selected: priority == p,
                  onSelected: (_) => setState(() => priority = p),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(deadline == null
                  ? "No deadline"
                  : "Deadline: ${deadline!.toLocal()}".split(' ').first),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDeadline,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : _save,
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEditing ? "Update Task" : "Add Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
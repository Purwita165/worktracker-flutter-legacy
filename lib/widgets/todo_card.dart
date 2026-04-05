import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_logic.dart';

String formatDuration(int hours) {
  if (hours < 24) return "$hours hours";

  int days = hours ~/ 24;
  if (days < 30) return "$days days";

  int months = days ~/ 30;
  return "$months months";
}

class TodoCard extends StatelessWidget {
  final Todo todo;
  final bool isOverdue;

  final void Function(Todo) toggleTodo;
  final void Function(Todo) toggleFocus;
  final void Function(Todo) confirmDelete;
  final void Function(Todo) openTaskDialog;

  final Map<String, String> priorityLabels;
  final Color Function(String) getPriorityColor;
  final String Function(DateTime?) formatDate;

  const TodoCard({
    super.key,
    required this.todo,
    required this.isOverdue,
    required this.toggleTodo,
    required this.toggleFocus,
    required this.confirmDelete,
    required this.openTaskDialog,
    required this.priorityLabels,
    required this.getPriorityColor,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    const metaStyle = TextStyle(
      fontSize: 12,
      color: Colors.black87,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== LEFT (Checkbox + Star) =====
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: todo.isDone,
                  onChanged: (_) => toggleTodo(todo),
                ),
                GestureDetector(
                  onTap: () => toggleFocus(todo),
                  child: const Icon(
                    Icons.star_border,
                    size: 18,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 10),

            /// ===== MIDDLE (Content) =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    todo.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: TodoLogic.getDescriptionColor(todo),
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// METADATA
                  todo.isDone
                      ? Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            children: [
                              TextSpan(text: "WorkID: ${todo.workId ?? ""}   "),
                              TextSpan(text: "Ref: ${todo.ref ?? ""}   "),
                              TextSpan(
                                text:
                                    "Created: ${formatDate(todo.createdAt)}   ",
                              ),
                              TextSpan(
                                text:
                                    "Completed: ${formatDate(todo.completedAt)}   ",
                              ),
                              TextSpan(
                                text:
                                    "Duration: ${formatDuration(todo.duration ?? 0)}",
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// ROW 1
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "WorkID: ${todo.workId ?? "-"}",
                                    style: metaStyle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Ref: ${todo.ref ?? "-"}",
                                    style: metaStyle,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            /// ROW 2
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Priority: ${todo.priority ?? "-"}",
                                    style: metaStyle.copyWith(
                                      color: getPriorityColor(todo.priority),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Progress: ${todo.progress}%",
                                    style: metaStyle,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            /// ROW 3
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Start ${formatDate(todo.startDate)}",
                                    style: metaStyle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Due ${formatDate(todo.dueDate)}",
                                    style: metaStyle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ],
              ),
            ),

            /// ===== RIGHT (Actions) =====
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => openTaskDialog(todo),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => confirmDelete(todo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
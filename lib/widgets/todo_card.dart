import 'package:flutter/material.dart';
import '../models/todo.dart';

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
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: todo.isDone,
                  onChanged: (_) {
                    toggleTodo(todo);
                  },
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

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.description,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isOverdue ? Colors.red : Colors.black,
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  const SizedBox(height: 4),

                  todo.isDone
                      ? Text(
                          "Completed: ${formatDate(todo.completedAt)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        )
                      : Text.rich(
                          TextSpan(
                            style: const TextStyle(fontSize: 13),
                            children: [
                              TextSpan(text: "WorkID: ${todo.workId ?? ""}   "),
                              TextSpan(text: "Ref: ${todo.ref ?? ""}   "),

                              if (!todo.isDone)
                                TextSpan(
                                  text:
                                      "Priority: ${priorityLabels[todo.priority]}   ",
                                  style: TextStyle(
                                    color: getPriorityColor(todo.priority),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              if (!todo.isDone)
                                TextSpan(
                                  text: "Progress: ${todo.progress}%   ",
                                ),

                              if (!todo.isDone)
                                TextSpan(
                                  text: "Due: ${formatDate(todo.dueDate)}",
                                ),

                              if (todo.isDone)
                                TextSpan(
                                  text:
                                      "Created: ${formatDate(todo.createdAt)}   ",
                                  style: const TextStyle(color: Colors.grey),
                                ),

                              if (todo.isDone)
                                TextSpan(
                                  text:
                                      "Completed: ${formatDate(todo.completedAt)}   ",
                                  style: const TextStyle(color: Colors.grey),
                                ),

                              if (todo.isDone)
                                TextSpan(
                                  text: "Duration: ${todo.duration ?? 0} hours",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                ],
              ),
            ),

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

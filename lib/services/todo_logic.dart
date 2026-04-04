// lib/services/todo_logic.dart

import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoLogic {
  /// ===============================
  /// HITUNG SELISIH HARI KE DUE DATE
  /// ===============================
  static int getDueDiffDays(Todo todo) {
    if (todo.dueDate == null) return 999;

    return todo.dueDate!.difference(DateTime.now()).inDays;
  }

  /// ===============================
  /// WARNA DESCRIPTION (URGENCY)
  /// ===============================
  static Color getDescriptionColor(Todo todo) {
    if (todo.isDone) return Colors.grey;

    final now = DateTime.now();
    final start = todo.startDate;

    if (start == null) return Colors.black;

    final diff = start.difference(now).inDays;

    if (diff > 7) {
      return Colors.grey; // masih jauh
    } else if (diff > 2) {
      return Colors.green; // mulai mendekat
    } else if (diff >= 0) {
      return Colors.blue; // sangat dekat
    } else {
      return Colors.orange; // sudah lewat start → harus jalan
    }
  }

  /// ===============================
  /// OVERDUE CHECK
  /// ===============================
  static bool isOverdue(Todo todo) {
    if (todo.dueDate == null) return false;

    return todo.dueDate!.isBefore(DateTime.now()) && !todo.isDone;
  }
}

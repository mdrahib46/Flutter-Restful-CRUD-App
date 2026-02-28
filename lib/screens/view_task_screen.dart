import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postapp/model/todo_list_model.dart';
import 'package:postapp/services/network_caller.dart';
import 'package:postapp/services/network_response.dart';
import 'package:postapp/urls.dart';

class ViewTaskScreen extends StatefulWidget {
  const ViewTaskScreen({super.key, required this.id});
  final String id;

  @override
  State<ViewTaskScreen> createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  TodoListModel? todo;
  bool _inProgress = false;
  late final DateTime _parseDate = DateTime.parse(todo!.createdDate!);
  late final String _date = DateFormat('dd-MM-yyyy').format(_parseDate);


  Future<void> viewTask() async {
    setState(() => _inProgress = true);

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getTodoById(id: widget.id),
    );

    setState(() => _inProgress = false);

    if (response.isSuccess) {
      if (mounted) {
        setState(() {
          todo = TodoListModel.fromJson(
            response.responseData as Map<String, dynamic>,
          );
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.errorMessage)));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    viewTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Task Details"),
      ),
      body: _inProgress
          ? const Center(child: CircularProgressIndicator())
          : todo == null
          ? const Center(child: Text("Task not found"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Title: ${todo!.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Description: ${todo!.description}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Created At: $_date',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

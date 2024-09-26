import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager_app/models/todo_model.dart';

class DatabaseService {
  final CollectionReference todoCollection = 
  FirebaseFirestore.instance.collection("todos");

  User? user = FirebaseAuth.instance.currentUser;

// Add todo task 
  Future<DocumentReference> addTodoItem(String title, String description) async {
    return await todoCollection.add({
      'uid' : user!.uid,
      'title' : title,
      'description' : description,
      'completed' : false,
      'createdAt' : FieldValue.serverTimestamp(),

    });
  } 

  // Update todo task
  Future<void> updateTodo(String id, String title, String description) async {
    final updatetodoCollection = 
    FirebaseFirestore.instance.collection("todos").doc(id);
    return await updatetodoCollection.update({
      'title' : title,
      'description' : description,
    });
  }

  // Update todo status
  Future<void> updateTodoStatus(String id, bool completed) async {
    return await todoCollection.doc(id).update({'completed': completed});
  }

  // Delete todo task
  Future<void> deleteTodoTask(String id) async {
    return await todoCollection.doc(id).delete();
  }

  // Get pending tasks
  Stream<List<Todo>> get todos {
    return todoCollection.where('uid', isEqualTo: user!.uid).where('completed', isEqualTo: 
    false).snapshots().map(_todoListFromSnapshot);
  }
  
  // Get completed tasks
  Stream<List<Todo>> get completedtodos {
    return todoCollection.where('uid', isEqualTo: user!.uid).where('completed', isEqualTo: 
    true).snapshots().map(_todoListFromSnapshot);
  }

  List<Todo> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Todo(id: doc.id,
      title: doc['title'] ?? '', 
      description: doc['description'] ?? '', 
      completed: doc['completed'] ?? false, 
      timeStamp: doc['createdAt'] ?? '');
    }).toList();
  }
}
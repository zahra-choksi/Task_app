import '../datasource/remote/task_api_service.dart';
import '../datasource/local/task_db_helper.dart';
import '../model/task_model.dart';
class TaskRepository {
  final TaskDbHelper _localDataSource ;
  final TaskRemoteDataSource _remoteDataSource ;
 TaskRepository(this._localDataSource,this._remoteDataSource);
  // Fetch tasks from local database or remote API (based on network availability)
  Future<List<Task>> getTasks() async {
    try {
      // First try to get tasks from remote API
      final tasksFromApi = await _remoteDataSource.getTasksFromApi();

      // If API fetch successful, save the data to local database
      for (var task in tasksFromApi) {
        await _localDataSource.insertTask(task);
      }

      return tasksFromApi;
    } catch (e) {

      // Fallback to local database if API call fails
      return await _localDataSource.getTasks();
    }
  }

  // Create task (both locally and remotely)
  Future<Task> createTask(Task task) async {
    try {
      // First create task remotely
      final newTask = await _remoteDataSource.createTaskOnApi(task);

      // Save task locally after successful API creation
      await _localDataSource.insertTask(newTask);

      return newTask;
    } catch (e) {

      // If API fails, create task locally
      await _localDataSource.insertTask(task);
      return task;
    }
  }

  // Update task (both locally and remotely)
  Future<Task> updateTask(Task task) async {
    try {
      // Update task remotely
      final updatedTask = await _remoteDataSource.updateTaskOnApi(task);

      // Update task locally after successful API update
      await _localDataSource.updateTask(updatedTask);
      return updatedTask;
    } catch (e) {
      // If API fails, update task locally
      await _localDataSource.updateTask(task);
      return task;
    }
  }

  // Delete task (both locally and remotely)
  Future<void> deleteTask(String taskId) async {
    try {
      // Delete task remotely
      await _remoteDataSource.deleteTaskFromApi(taskId);

      // Delete task locally after successful API deletion
      await _localDataSource.deleteTask(taskId);
    } catch (e) {
      // If API fails, delete task locally
      await _localDataSource.deleteTask(taskId);
    }
  }
}

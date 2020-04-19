@isTest
public with sharing class ToDoControllerTest {
  @TestSetup
  static void makeData() {
    List<SObject> todos = new List<SObject>();

    SObject todo1 = (Sobject) Type.forName('ToDo__c').newInstance();
    todo1.put('Name', 'Test todo 1');
    todo1.put('Done__c', false);

    SObject todo2 = (Sobject) Type.forName('ToDo__c').newInstance();
    todo2.put('Name', 'Test todo 2');
    todo2.put('Done__c', true);

    SObject todo3 = (Sobject) Type.forName('ToDo__c').newInstance();
    todo3.put('Name', 'Test todo 3');
    todo3.put('Done__c', false);

    todos.add(todo1);
    todos.add(todo2);
    todos.add(todo3);

    insert todos;
  }

  @isTest
  static void addTodoTest() {
    //create ToDo Object
    ToDoController.ToDo todo = new ToDoController.ToDo();
    todo.done = false;
    todo.todoName = 'Test todo 4';
    Test.startTest();
    String todoId = ToDoController.addTodo(JSON.serialize(todo));
    Test.stopTest();

    System.assert(todoId != null, 'Id is null');

    List<SObject> todos = Database.query(
      'SELECT Id, Name, CreatedDate, Done__c FROM ToDo__c'
    );
    System.assertEquals(4, todos.size(), 'Todos size should be 4');
  }

  @isTest
  static void updateTodoTest() {
    Test.startTest();
    List<SObject> todoToUpdate = Database.query(
      'SELECT Id FROM ToDo__c WHERE Name=\'Test todo 2\''
    );

    //create ToDo Object
    ToDoController.ToDo todo = new ToDoController.ToDo();
    todo.done = false;
    todo.todoId = todoToUpdate[0].Id;

    ToDoController.updateTodo(JSON.serialize(todo));
    Test.stopTest();

    List<SObject> todos = Database.query(
      'SELECT Id, Name, CreatedDate, Done__c FROM ToDo__c WHERE Done__c=false'
    );

    System.assertEquals(3, todos.size(), 'Todos size should be 3');
  }

  @isTest
  static void deleteTodoTest() {
    Test.startTest();
    List<SObject> todoToDelete = Database.query(
      'SELECT Id FROM ToDo__c WHERE Name=\'Test todo 2\''
    );

    ToDoController.deleteTodo(String.valueOf(todoToDelete[0].id));
    Test.stopTest();

    List<SObject> todos = Database.query(
      'SELECT Id, Name, CreatedDate, Done__c FROM ToDo__c'
    );

    System.assertEquals(2, todos.size(), 'Todos size should be 2');
  }

  @isTest
  static void getCurrentTodosTest() {
    Test.startTest();
    List<ToDoController.ToDo> todos = ToDoController.getCurrentTodos();
    Test.stopTest();
    System.assertEquals(3, todos.size(), 'Todos size should be 3');
  }

  @isTest
  static void getAllTodosTest() {
    Test.startTest();
    List<ToDoController.ToDo> todos = ToDoController.getAllTodos();
    Test.stopTest();
    System.assertEquals(3, todos.size(), 'Todos size should be 3');
  }
}

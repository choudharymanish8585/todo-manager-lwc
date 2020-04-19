/**
 * ToDoList component
 * Provides ability to view todos for last 7 days
 * @author Manish Choudhari
 */
import { LightningElement, wire, track } from "lwc";
import getAllTodos from "@salesforce/apex/ToDoController.getAllTodos";

export default class ToDoList extends LightningElement {
  //reactive list property to hold todo items
  @track todos = [];

  //wire adapter to retrieve todos
  @wire(getAllTodos)
  parseTodos({ data, error }) {
    if (data) {
      this.groupTodos(data);
    } else if (error) {
      console.error(error);
    }
  }

  /**
   * Group todos based on date
   * @param {*} todos
   */
  groupTodos(todos) {
    if (todos) {
      const todoWrap = new Map();
      todos.forEach(todo => {
        if (!todoWrap.has(todo.todoDate)) {
          todoWrap.set(todo.todoDate, []);
        }
        todoWrap.get(todo.todoDate).push(todo);
      });

      const todoList = [];
      for (let key of todoWrap.keys()) {
        const todoItem = { date: key, items: todoWrap.get(key) };
        todoList.push(todoItem);
      }
      this.todos = todoList;
    }
  }
}

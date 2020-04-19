/**
 * ToDoListItem component
 * Represents an item with some styling based on item status
 * @author Manish Choudhari
 */
import { LightningElement, api } from "lwc";

export default class ToDoListItem extends LightningElement {
  //public properties to get todo information
  @api todoId;
  @api todoName;
  @api done = false;

  //get property to return container class based on todo status
  get containerClass() {
    return this.done ? "todo completed" : "todo upcoming";
  }
}

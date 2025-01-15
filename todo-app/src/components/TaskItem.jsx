import React from 'react';

const TaskItem = ({ task, onEdit, onDelete }) => {
  return (
    <div>
      <h3>{task.title}</h3>
      <p>Priority: {task.priority}</p>
      <p>Due Date: {task.dueDate}</p>
      <button onClick={() => onEdit(task.id)}>Edit</button>
      <button onClick={() => onDelete(task.id)}>Delete</button>
    </div>
  );
};

export default TaskItem;
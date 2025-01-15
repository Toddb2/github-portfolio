import React from 'react';
import { List } from '@mui/material';
import TaskItem from './TaskItem';
import './TaskList.css';

const TaskList = ({ tasks, onEdit, onDelete }) => {
  return (
    <List className="task-list">
      {tasks.map(task => (
        <TaskItem key={task.id} task={task} onEdit={onEdit} onDelete={onDelete} />
      ))}
    </List>
  );
};

export default TaskList;
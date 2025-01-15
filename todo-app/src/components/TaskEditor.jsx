import React, { useState } from 'react';
import {
  TextField,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  MenuItem,
} from '@mui/material';
import { v4 as uuidv4 } from 'uuid';
import { format } from 'date-fns';
import './TaskEditor.css';

const priorities = ['Low', 'Medium', 'High'];

const TaskEditor = ({ onSave, task, onCancel }) => {
  const [open, setOpen] = useState(!task ? false : true);
  const [title, setTitle] = useState(task ? task.title : '');
  const [priority, setPriority] = useState(task ? task.priority : 'Medium');
  const [dueDate, setDueDate] = useState(task ? task.dueDate : format(new Date(), 'yyyy-MM-dd'));
  const [score, setScore] = useState(task ? task.score : 0);

  const handleSubmit = () => {
    const newTask = {
      id: task ? task.id : uuidv4(),
      title,
      priority,
      dueDate,
      score: parseInt(score, 10),
    };
    onSave(newTask);
    if (!task) {
      setTitle('');
      setPriority('Medium');
      setDueDate(format(new Date(), 'yyyy-MM-dd'));
      setScore(0);
    }
    if (!task && onCancel) onCancel();
    setOpen(false);
  };

  const handleOpen = () => setOpen(true);
  const handleClose = () => {
    if (onCancel) onCancel();
    setOpen(false);
  };

  return (
    <>
      {!task && (
        <Button variant="contained" color="primary" onClick={handleOpen}>
          Add Task
        </Button>
      )}
      <Dialog open={open} onClose={handleClose}>
        <DialogTitle>{task ? 'Edit Task' : 'New Task'}</DialogTitle>
        <DialogContent className="task-editor">
          <TextField
            autoFocus
            margin="dense"
            label="Task Title"
            type="text"
            fullWidth
            variant="standard"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
          />
          <TextField
            select
            margin="dense"
            label="Priority"
            fullWidth
            variant="standard"
            value={priority}
            onChange={(e) => setPriority(e.target.value)}
          >
            {priorities.map((option) => (
              <MenuItem key={option} value={option}>
                {option}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            margin="dense"
            label="Due Date"
            type="date"
            fullWidth
            variant="standard"
            InputLabelProps={{
              shrink: true,
            }}
            value={dueDate}
            onChange={(e) => setDueDate(e.target.value)}
          />
          <TextField
            margin="dense"
            label="Score"
            type="number"
            fullWidth
            variant="standard"
            value={score}
            onChange={(e) => setScore(e.target.value)}
            inputProps={{ min: 0 }}
          />
        </DialogContent>
        <DialogActions>
          {onCancel && (
            <Button onClick={handleClose} color="secondary">
              Cancel
            </Button>
          )}
          <Button onClick={handleSubmit} color="primary">
            {task ? 'Save' : 'Add'}
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default TaskEditor;
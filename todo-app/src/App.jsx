import React, { useState, useEffect, useMemo } from 'react';
import { Container, Typography, Grid, IconButton } from '@mui/material';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import Brightness4Icon from '@mui/icons-material/Brightness4';
import Brightness7Icon from '@mui/icons-material/Brightness7';
import TaskList from './components/TaskList';
import TaskEditor from './components/TaskEditor';
import SearchBar from './components/SearchBar';
import AnalyticsWindow from './components/AnalyticsWindow';
import './App.css';

const App = () => {
  const [tasks, setTasks] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [filteredTasks, setFilteredTasks] = useState([]);
  const [darkMode, setDarkMode] = useState(false);

  useEffect(() => {
    setFilteredTasks(
      tasks.filter(task =>
        task.title.toLowerCase().includes(searchQuery.toLowerCase())
      )
    );
  }, [searchQuery, tasks]);

  const handleSave = (task) => {
    setTasks([...tasks, task]);
  };

  const handleEdit = (updatedTask) => {
    setTasks(tasks.map(task => (task.id === updatedTask.id ? updatedTask : task)));
  };

  const handleDelete = (id) => {
    setTasks(tasks.filter(task => task.id !== id));
  };

  const toggleDarkMode = () => {
    setDarkMode(!darkMode);
  };

  const theme = useMemo(
    () =>
      createTheme({
        palette: {
          mode: darkMode ? 'dark' : 'light',
        },
      }),
    [darkMode],
  );

  return (
    <ThemeProvider theme={theme}>
      <Container className="container">
        <Grid container justifyContent="space-between" alignItems="center" className="header">
          <Typography variant="h4" align="center" gutterBottom>
            To-Do List App
          </Typography>
          <IconButton onClick={toggleDarkMode} color="inherit">
            {darkMode ? <Brightness7Icon /> : <Brightness4Icon />}
          </IconButton>
        </Grid>
        <Grid container spacing={2}>
          <Grid item xs={12}>
            <SearchBar query={searchQuery} setQuery={setSearchQuery} />
          </Grid>
          <Grid item xs={12} md={6}>
            <TaskEditor onSave={handleSave} />
          </Grid>
          <Grid item xs={12} md={6}>
            <AnalyticsWindow tasks={tasks} />
          </Grid>
          <Grid item xs={12}>
            <TaskList tasks={filteredTasks} onEdit={handleEdit} onDelete={handleDelete} />
          </Grid>
        </Grid>
      </Container>
    </ThemeProvider>
  );
};

export default App;

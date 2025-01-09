import { useState } from 'react';
import './App.css';

function App() {
  const [todos, setTodos] = useState([]);
  const [input, setInput] = useState('');
  const [editId, setEditId] = useState(null);
  const [editInput, setEditInput] = useState('');
  const [darkMode, setDarkMode] = useState(false);
  const [priority, setPriority] = useState('medium');
  const [dueDate, setDueDate] = useState('');
  const [category, setCategory] = useState('work');
  const [search, setSearch] = useState('');
  const [filter, setFilter] = useState('all');

  const addTodo = (e) => {
    e.preventDefault();
    if (input.trim()) {
      setTodos([...todos, { text: input, completed: false, id: Date.now(), priority, dueDate, category }]);
      setInput('');
      setPriority('medium');
      setDueDate('');
      setCategory('work');
    }
  };

  const toggleTodo = (id) => {
    setTodos(todos.map(todo => 
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    ));
  };

  const deleteTodo = (id) => {
    setTodos(todos.filter(todo => todo.id !== id));
  };

  const startEditTodo = (id, text) => {
    setEditId(id);
    setEditInput(text);
  };

  const saveTodoEdit = (id) => {
    if (editInput.trim()) {
      setTodos(todos.map(todo => 
        todo.id === id ? { ...todo, text: editInput } : todo
      ));
      setEditId(null);
      setEditInput('');
    }
  };

  const cancelEdit = () => {
    setEditId(null);
    setEditInput('');
  };

  const toggleDarkMode = () => {
    setDarkMode(!darkMode);
  };

  const filteredTodos = todos.filter(todo => {
    if (filter === 'completed') return todo.completed;
    if (filter === 'incomplete') return !todo.completed;
    return true;
  }).filter(todo => todo.text.toLowerCase().includes(search.toLowerCase()));

  const completedCount = todos.filter(todo => todo.completed).length;
  const totalCount = todos.length;

  return (
    <div className={`App ${darkMode ? 'dark-mode' : ''}`}>
      <header>
        <h1>Todo List</h1>
        <button onClick={toggleDarkMode}>
          {darkMode ? 'Light Mode' : 'Dark Mode'}
        </button>
      </header>
      <form onSubmit={editId ? (e) => { e.preventDefault(); saveTodoEdit(editId); } : addTodo}>
        <input 
          type="text"
          value={editId ? editInput : input}
          onChange={(e) => editId ? setEditInput(e.target.value) : setInput(e.target.value)}
          placeholder={editId ? "Edit todo" : "Add a new todo"}
        />
        <select value={priority} onChange={(e) => setPriority(e.target.value)}>
          <option value="low">Low</option>
          <option value="medium">Medium</option>
          <option value="high">High</option>
        </select>
        <input 
          type="date"
          value={dueDate}
          onChange={(e) => setDueDate(e.target.value)}
        />
        <select value={category} onChange={(e) => setCategory(e.target.value)}>
          <option value="work">Work</option>
          <option value="personal">Personal</option>
          <option value="shopping">Shopping</option>
        </select>
        <button type="submit">{editId ? "Update" : "Add"}</button>
      </form>
      <div className="search-filter">
        <input 
          type="text"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Search todos"
        />
        <select value={filter} onChange={(e) => setFilter(e.target.value)}>
          <option value="all">All</option>
          <option value="completed">Completed</option>
          <option value="incomplete">Incomplete</option>
        </select>
      </div>
      <ul>
        {filteredTodos.map(todo => (
          <li key={todo.id} className={`priority-${todo.priority} ${new Date(todo.dueDate) < new Date() && !todo.completed ? 'overdue' : ''}`}>
            <input
              type="checkbox"
              checked={todo.completed}
              onChange={() => toggleTodo(todo.id)}
            />
            {editId === todo.id ? (
              <div className="edit-form">
                <input
                  type="text"
                  value={editInput}
                  onChange={(e) => setEditInput(e.target.value)}
                />
                <button onClick={() => saveTodoEdit(todo.id)}>Save</button>
                <button onClick={cancelEdit}>Cancel</button>
              </div>
            ) : (
              <>
                <span style={{ textDecoration: todo.completed ? 'line-through' : 'none' }}>
                  {todo.text}
                </span>
                <span className="due-date">{todo.dueDate}</span>
                <span className="category">{todo.category}</span>
                <button onClick={() => startEditTodo(todo.id, todo.text)}>Edit</button>
                <button onClick={() => deleteTodo(todo.id)}>Delete</button>
              </>
            )}
          </li>
        ))}
      </ul>
      <footer>
        <p>&copy; 2023 Todo List App</p>
        <p>Progress: {completedCount}/{totalCount} tasks completed</p>
      </footer>
    </div>
  );
}

export default App;
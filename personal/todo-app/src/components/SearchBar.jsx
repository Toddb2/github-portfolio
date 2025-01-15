import React from 'react';
import { TextField } from '@mui/material';
import './SearchBar.css';

const SearchBar = ({ query, setQuery }) => {
  return (
    <TextField
      className="search-bar"
      fullWidth
      label="Search Tasks"
      variant="outlined"
      value={query}
      onChange={(e) => setQuery(e.target.value)}
    />
  );
};

export default SearchBar;
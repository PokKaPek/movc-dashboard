import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Dashboard from './pages/Dashboard';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/" element={<div style={{ padding: '2rem' }}><h2>Welcome to MOVC App</h2><p>Go to /dashboard to see live ranking.</p></div>} />
      </Routes>
    </Router>
  );
}

export default App;
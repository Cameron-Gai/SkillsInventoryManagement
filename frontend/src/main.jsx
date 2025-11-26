// main.jsx
// Entry point for the React App. This injects the router into the page.

import React from 'react'
import ReactDOM from 'react-dom/client'
import AppRouter from '@/routes/AppRouter'
import '@/styles/global.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <AppRouter />
  </React.StrictMode>
)

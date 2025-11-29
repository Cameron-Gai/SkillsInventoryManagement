// main.jsx
// Entry point for the React App. This injects the router into the page.

import RootLayout from "@/layouts/RootLayout.jsx";
import '@/styles/global.css'
import React from 'react'
import ReactDOM from 'react-dom/client'
import AppRouter from '@/routes/AppRouter'

// Default theme behavior:
// - If a theme is already stored, honor it.
// - If no preference exists, default to dark mode.
const THEME_KEY = 'sim_theme'
try {
  const stored = localStorage.getItem(THEME_KEY)
  if (!stored) {
    localStorage.setItem(THEME_KEY, 'dark')
    document.documentElement.classList.add('dark')
  } else if (stored === 'dark') {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
} catch (e) {
  // If localStorage is unavailable, silently fail and keep styles as-is.
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <RootLayout>
      <AppRouter />
    </RootLayout>
  </React.StrictMode>
);
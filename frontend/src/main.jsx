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
  // Define light/dark primary colors so the active primary color
  // is set according to the theme. Dark mode uses the older/brighter red.
  const LIGHT_PRIMARY = '#B00020'
  const DARK_PRIMARY = '#E4002B'

  if (!stored) {
    localStorage.setItem(THEME_KEY, 'dark')
    document.documentElement.classList.add('dark')
    document.documentElement.style.setProperty('--color-primary', DARK_PRIMARY)
    document.documentElement.style.setProperty('--color-primary-dark', '#C00021')
  } else if (stored === 'dark') {
    document.documentElement.classList.add('dark')
    document.documentElement.style.setProperty('--color-primary', DARK_PRIMARY)
    document.documentElement.style.setProperty('--color-primary-dark', '#C00021')
  } else {
    document.documentElement.classList.remove('dark')
    document.documentElement.style.setProperty('--color-primary', LIGHT_PRIMARY)
    document.documentElement.style.setProperty('--color-primary-dark', '#8A0018')
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
// main.jsx
// Entry point for the React App. This injects the router into the page.

import RootLayout from "@/layouts/RootLayout.jsx";
import '@/styles/global.css'
import React from 'react'
import ReactDOM from 'react-dom/client'
import AppRouter from '@/routes/AppRouter'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <RootLayout>
      <AppRouter />
    </RootLayout>
  </React.StrictMode>
);
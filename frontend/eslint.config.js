// This is your ESLint Flat Config file.
// ESLint recently switched from .eslintrc.* to this modern format.
//
// It defines how ESLint checks your code, catches bugs, and enforces rules.
// It also integrates Prettier so formatting issues show as ESLint errors.

import js from '@eslint/js'              // Base JavaScript rules
import globals from 'globals'            // Browser globals (window, document, etc.)
import react from 'eslint-plugin-react'  // React linting rules

export default [
  {
    // Tell ESLint to ignore compiled output from Vite
    ignores: ['dist'],
  },

  {
    // Apply these rules to all JS and JSX files
    files: ['**/*.{js,jsx}'],

    languageOptions: {
      ecmaVersion: 2020,                 // Modern JS features
      globals: globals.browser,          // Allow browser globals
      parserOptions: {
        ecmaFeatures: {
          jsx: true,                     // Allow JSX syntax for React
        },
      },
    },

    plugins: {
      react,                             // Enables React rules (hooks, JSX issues, etc.)
      prettier: require('eslint-plugin-prettier'),
      // Allows ESLint to report Prettier formatting issues
    },

    rules: {
      // Base recommended JS rules
      ...js.configs.recommended.rules,

      // React recommended rules (hooks, JSX best practices)
      ...react.configs.recommended.rules,

      // Run Prettier as an ESLint rule
      // Any formatting errors appear as red squiggles in VS Code
      'prettier/prettier': 'error',

      // Disable React import requirement (Vite handles this automatically)
      'react/react-in-jsx-scope': 'off',
    },
  },
]

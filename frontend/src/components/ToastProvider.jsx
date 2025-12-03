import { createContext, useContext, useState, useCallback } from 'react'

const ToastContext = createContext({ showToast: () => {} })

export const useToast = () => useContext(ToastContext)

export default function ToastProvider({ children }) {
  const [toasts, setToasts] = useState([])

  const showToast = useCallback((message, { variant = 'success', duration = 3000 } = {}) => {
    const id = Date.now() + Math.random()
    setToasts((prev) => [...prev, { id, message, variant }])
    setTimeout(() => {
      setToasts((prev) => prev.filter(t => t.id !== id))
    }, duration)
  }, [])

  return (
    <ToastContext.Provider value={{ showToast }}>
      {children}
      <div className="fixed top-4 right-4 z-50 space-y-2">
        {toasts.map(t => (
          <div key={t.id} className={`rounded-md px-4 py-2 shadow ${t.variant === 'success' ? 'bg-green-100 text-green-700' : t.variant === 'error' ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-700'}`}>
            {t.message}
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  )
}

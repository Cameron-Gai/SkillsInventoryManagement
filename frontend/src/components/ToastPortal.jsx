import { useEffect, useState } from 'react'
import { subscribeToast, TOAST_TYPES } from '@/utils/toast'

export default function ToastPortal() {
  const [toasts, setToasts] = useState([])

  useEffect(() => {
    const unsubscribe = subscribeToast(({ id, message, type, duration }) => {
      setToasts((prev) => [...prev, { id, message, type, duration }])
      setTimeout(() => {
        setToasts((prev) => prev.filter(t => t.id !== id))
      }, duration || 3000)
    })
    return unsubscribe
  }, [])

  return (
    <div className="fixed bottom-4 right-4 z-[100] space-y-2">
      {toasts.map(({ id, message, type }) => (
        <div
          key={id}
          className={`min-w-[260px] max-w-sm rounded-md px-4 py-3 text-white shadow-lg ${TOAST_TYPES[type] || TOAST_TYPES.info}`}
        >
          {message}
        </div>
      ))}
    </div>
  )
}

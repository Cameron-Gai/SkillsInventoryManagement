// Minimal toast bus + helper
const TOAST_EVENT = 'sim_toast_event';

export function showToast(message, type = 'info', duration = 3000) {
  const detail = { message, type, duration, id: Date.now() + Math.random() };
  window.dispatchEvent(new CustomEvent(TOAST_EVENT, { detail }));
}

export function subscribeToast(handler) {
  const listener = (e) => handler(e.detail);
  window.addEventListener(TOAST_EVENT, listener);
  return () => window.removeEventListener(TOAST_EVENT, listener);
}

export const TOAST_TYPES = {
  info: 'bg-blue-600',
  success: 'bg-green-600',
  warning: 'bg-amber-600',
  error: 'bg-red-600',
};

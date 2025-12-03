// axiosInstance.js
// Central Axios instance for all API requests.
// Handles base URL, headers, error management, and interceptors.

import axios from "axios";
import { clearStoredUser } from "@/utils/auth";

const axiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_URL || "http://localhost:3000/api/v1",
  withCredentials: true, // allows cookies if needed later
  timeout: 10000, // prevents hanging requests
});

// ============================
// Request Interceptor
// ============================

axiosInstance.interceptors.request.use(
  (config) => {
    // Inject JWT token if present
    const token = localStorage.getItem("sim_token");

    if (token) {
      config.headers["Authorization"] = `Bearer ${token}`;
    }

    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// ============================
// Response Interceptor
// ============================

axiosInstance.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error("API Error:", error.response?.data || error.message);

    // Handle unauthorized access globally
    if (error.response?.status === 401) {
      // Token expired or invalid; clear stored session and force re-auth
      clearStoredUser();
      window.location.replace("/login");
    }

    // Handle too many requests (limits) with a friendly toast/alert
    if (error.response?.status === 429) {
      const msg =
        error.response?.data?.error ||
        error.response?.data?.message ||
        "You have reached the current request limit.";
      if (typeof window !== 'undefined' && typeof window.simShowToast === 'function') {
        window.simShowToast(msg, { variant: 'error' });
      }
    }

    return Promise.reject(error);
  }
);

export default axiosInstance;

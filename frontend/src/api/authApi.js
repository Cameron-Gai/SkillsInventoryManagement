// authApi.js
// API functions related to authentication: login, logout, register, etc.

import axios from "./axiosInstance";

const authApi = {
  login: (email, password) =>
    axios.post("/auth/login", { email, password }),

  logout: () =>
    axios.post("/auth/logout"),

  verify: () =>
    axios.get("/auth/verify"), // returns user info if token is valid
};

export default authApi;

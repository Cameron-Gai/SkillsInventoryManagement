// usersApi.js
// Interacts with users, profiles, roles, etc.

import axios from "./axiosInstance";

const usersApi = {
  getProfile: () => axios.get(`/users/me?_t=${Date.now()}`),
  updateProfile: (data) => axios.put("/users/me", data),

  // Manager/Admin examples
  getAllUsers: () => axios.get("/users"),
  deleteUser: (id) => axios.delete(`/users/${id}`),
};

export default usersApi;

// personSkillsApi.js
// API functions for managing personal skill inventory

import axios from "./axiosInstance";

const personSkillsApi = {
  // Get current user's skills
  getMySkills: () => axios.get("/person-skills/me"),

  // Get a specific user's skills (admin/manager)
  getUserSkills: (userId) => axios.get(`/person-skills/user/${userId}`),

  // Add a skill to current user's profile
  addMySkill: (skillId, payload = {}) =>
    axios.post("/person-skills/me", {
      skill_id: skillId,
      ...payload,
    }),

  // Add a skill to a specific user (admin only)
  addUserSkill: (userId, skillId, payload = {}) =>
    axios.post(`/person-skills/user/${userId}`, {
      skill_id: skillId,
      ...payload,
    }),

  // Update skill status for current user
  updateMySkill: (skillId, payload) =>
    axios.put(`/person-skills/me/${skillId}`, payload),

  // Update skill status for a specific user (admin only)
  updateUserSkill: (userId, skillId, payload) =>
    axios.put(`/person-skills/user/${userId}/${skillId}`, payload),

  // Remove a skill from current user
  removeMySkill: (skillId) => axios.delete(`/person-skills/me/${skillId}`),

  // Remove a skill from a specific user (admin only)
  removeUserSkill: (userId, skillId) =>
    axios.delete(`/person-skills/user/${userId}/${skillId}`),
};

export default personSkillsApi;

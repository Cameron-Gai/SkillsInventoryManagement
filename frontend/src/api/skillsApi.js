// skillsApi.js
// API functions for managing skills inventory

import axios from "./axiosInstance";

const skillsApi = {
  // Get all available skills
  getAllSkills: () => axios.get("/skills"),

  // Get a specific skill
  getSkill: (id) => axios.get(`/skills/${id}`),

  // Create a new skill (admin only)
  createSkill: (skillData) =>
    axios.post("/skills", {
      skill_name: skillData.name,
      skill_type: skillData.type,
    }),

  // Update a skill (admin only)
  updateSkill: (id, skillData) =>
    axios.put(`/skills/${id}`, {
      skill_name: skillData.name,
      skill_type: skillData.type,
      status: skillData.status,
    }),

  // Delete a skill (admin only)
  deleteSkill: (id) => axios.delete(`/skills/${id}`),
};

export default skillsApi;

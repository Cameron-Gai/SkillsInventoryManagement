// teamApi.js
// API functions for manager/admin team management

import axios from "./axiosInstance";

const teamApi = {
  // Get current manager's team members
  getMyTeam: () => axios.get("/team/my-team"),

  // Get details for a specific team member
  getTeamMember: (memberId) => axios.get(`/team/my-team/${memberId}`),

  // Get team insights (stats, pending approvals, etc.)
  getTeamInsights: () => axios.get("/team/insights"),

  // High value skills management
  getHighValueSkills: () => axios.get("/team/high-value-skills"),
  addHighValueSkill: (payload) => axios.post("/team/high-value-skills", payload),
  deleteHighValueSkill: (id) => axios.delete(`/team/high-value-skills/${id}`),

  // Approve a skill for a team member
  approveTeamMemberSkill: (memberId, skillId) =>
    axios.patch(`/team/my-team/${memberId}/skills/${skillId}/approve`),

  // Reject a skill for a team member
  rejectTeamMemberSkill: (memberId, skillId) =>
    axios.patch(`/team/my-team/${memberId}/skills/${skillId}/reject`),
};

export default teamApi;

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

  // Approve a skill for a team member
  approveTeamMemberSkill: (memberId, skillId) =>
    axios.patch(`/team/my-team/${memberId}/skills/${skillId}/approve`),

  // Reject a skill for a team member
  rejectTeamMemberSkill: (memberId, skillId) =>
    axios.patch(`/team/my-team/${memberId}/skills/${skillId}/reject`),

  // Admin: list all skill requests with optional filters
  getAdminRequests: ({ page = 1, pageSize = 20, status = '' } = {}) => {
    const params = new URLSearchParams()
    params.set('page', page)
    params.set('pageSize', pageSize)
    if (status) params.set('status', status)
    return axios.get(`/team/admin/requests?${params.toString()}`)
  },
};

export default teamApi;

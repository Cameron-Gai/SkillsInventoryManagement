import axios from './axiosInstance'

const skillRequestsApi = {
  createRequest: ({ skill_name, skill_type, justification }) =>
    axios.post('/skill-requests', {
      skill_name,
      skill_type,
      justification,
    }),

  listRequests: () => axios.get('/skill-requests'),

  resolveRequest: (requestId, payload) => axios.put(`/skill-requests/${requestId}`, payload),

  updateRequest: (requestId, payload) => axios.patch(`/skill-requests/${requestId}`, payload),
}

export default skillRequestsApi

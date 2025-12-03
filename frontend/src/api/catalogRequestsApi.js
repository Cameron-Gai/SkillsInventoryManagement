import api from './axiosInstance';

// Create a new Catalog Request
export const createCatalogRequest = async ({ skill_name, skill_type, justification }) => {
  const { data } = await api.post('/catalog-requests', { skill_name, skill_type, justification });
  return data;
};

// List all Catalog Requests (admin)
export const getCatalogRequests = async () => {
  const { data } = await api.get('/catalog-requests');
  return data;
};

// Approve or Reject a Catalog Request (admin)
export const processCatalogRequest = async (requestId, { action, resolution_notes }) => {
  const { data } = await api.put(`/catalog-requests/${requestId}`, { action, resolution_notes });
  return data;
};

// Edit a pending Catalog Request (admin)
export const editCatalogRequest = async (requestId, { skill_name, skill_type, justification }) => {
  const { data } = await api.patch(`/catalog-requests/${requestId}`, { skill_name, skill_type, justification });
  return data;
};

// Alias for editing to match Admin.jsx import
export const updateCatalogRequest = async (requestId, payload) => {
  const { data } = await api.patch(`/catalog-requests/${requestId}`, payload);
  return data;
};

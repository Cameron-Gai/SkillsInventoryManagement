import axios from "./axiosInstance";

const dataManagementApi = {
  // Create a new backup
  createBackup: () => axios.post("/data-management/backup"),
  
  // List all backups
  listBackups: () => axios.get("/data-management/backups"),
  
  // Download a backup file
  downloadBackup: (filename) => 
    axios.get(`/data-management/backup/${filename}`, { responseType: 'blob' }),
  
  // Delete a backup
  deleteBackup: (filename) => 
    axios.delete(`/data-management/backup/${filename}`),
  
  // Restore from backup
  restoreBackup: (filename) => 
    axios.post(`/data-management/restore/${filename}`),
  
  // Export all data as JSON
  exportJSON: () => axios.get("/data-management/export/json"),
};

export default dataManagementApi;

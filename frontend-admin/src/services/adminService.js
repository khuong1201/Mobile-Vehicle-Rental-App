import api from './api';

export const getAllUsers = () => api.get('/admin/get-all-user');
export const getUserProfile = () => api.get('/admin/get-user-profile');
export const getUnapprovedLicenses = () => api.get('/admin/get-users-with-unapproved-licenses');
export const approveLicense = (userId) => api.post('/admin/approve-license', { userId });
export const rejectLicense = (userId) => api.post('/admin/reject-license', { userId });
export const deleteUserAccount = () => api.delete('/admin/delete-account');

export const getAllVehicles = () => api.get('/admin/all-vehicles');
export const getPendingVehicles = () => api.get('/admin/pending');
export const changeVehicleStatus = (vehicleId, status) =>
  api.put(`/admin/status/${vehicleId}`, { status });

export const getAllBrands = () => api.get('/brands');
export const createBrand = (data) => api.post('/admin/create-brand', data);
export const updateBrand = (id, data) => api.put(`/admin/update-brand/${id}`, data);
export const deleteBrand = (id) => api.delete(`/admin/delete-brand/${id}`);

export const getAllReviews = () => api.get('/admin/reviews');
export const getReviewById = (id) => api.get(`/admin/review/${id}`);
export const deleteReview = (id) => api.delete(`/admin/delete-review/${id}`);
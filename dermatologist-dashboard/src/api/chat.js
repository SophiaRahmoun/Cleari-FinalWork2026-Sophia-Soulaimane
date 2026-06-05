import { api } from "./client";

export const getConversations = () => api.get("/chat/conversations");
export const getMessages = (conversationId) =>
  api.get(`/chat/conversations/${conversationId}/messages`);
export const sendMessage = (conversationId, content) =>
  api.post(`/chat/conversations/${conversationId}/messages`, { content });
export const getPatientScans = (conversationId) =>
  api.get(`/chat/conversations/${conversationId}/patient-scans`);
export const getPatientForm = (conversationId) =>
  api.get(`/chat/conversations/${conversationId}/patient-form`);
export const getPatientRoutines = (conversationId) =>
  api.get(`/chat/conversations/${conversationId}/patient-routines`);

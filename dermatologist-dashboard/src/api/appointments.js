import { api } from "./client";

export const getAppointmentRequests = () =>
  api.get("/appointments/dermatologist/requests");

export const updateAppointmentStatus = (id, status) =>
  api.patch(`/appointments/${id}/status`, { status });

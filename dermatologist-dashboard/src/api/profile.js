import { api } from "./client";

const BASE_URL = import.meta.env.VITE_API_BASE_URL;

export const getMyProfile = () => api.get("/dermatologists/me");
export const getCurrentUser = () => api.get("/users/me");
export const updateUsername = (username) =>
  api.put("/users/me/username", { username });
export const updatePassword = (currentPassword, newPassword) =>
  api.put("/users/me/password", { currentPassword, newPassword });

export async function updateProfilePicture(file) {
  const token = localStorage.getItem("cleari_token");
  const fd = new FormData();
  fd.append("image", file);
  const res = await fetch(`${BASE_URL}/users/me/profile-picture`, {
    method: "PUT",
    headers: token ? { Authorization: `Bearer ${token}` } : {},
    body: fd,
  });
  if (res.status === 401 || res.status === 403) {
    localStorage.removeItem("cleari_token");
    localStorage.removeItem("cleari_user");
    window.location.href = "/login";
    throw new Error("Unauthorized");
  }
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(data.message || "Upload failed");
  return data;
}

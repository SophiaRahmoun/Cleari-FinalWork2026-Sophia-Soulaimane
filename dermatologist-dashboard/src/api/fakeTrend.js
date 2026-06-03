const BASE_URL = import.meta.env.VITE_API_BASE_URL;

function getToken() {
  return localStorage.getItem("cleari_token");
}

async function multipartRequest(path, formData) {
  const token = getToken();
  const res = await fetch(`${BASE_URL}${path}`, {
    method: "POST",
    headers: token ? { Authorization: `Bearer ${token}` } : {},
    body: formData,
  });
  if (res.status === 401 || res.status === 403) {
    localStorage.removeItem("cleari_token");
    localStorage.removeItem("cleari_user");
    window.location.href = "/login";
    throw new Error("Unauthorized");
  }
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(data.message || "Request failed");
  return data;
}

import { api } from "./client";

export const getMyFakeTrendPosts = (userId) =>
  api.get(`/fake-trends/dermatologists/${userId}/posts`);

export const getAllFakeTrendPosts = () => api.get("/fake-trends/posts");

export const getMyEarnings = () => api.get("/fake-trends/my-earnings");

export const deleteFakeTrendPost = (id) => api.delete(`/fake-trends/posts/${id}`);

export function createFakeTrendPost(fields) {
  const fd = new FormData();
  Object.entries(fields).forEach(([k, v]) => {
    if (v !== undefined && v !== null && v !== "") fd.append(k, v);
  });
  return multipartRequest("/fake-trends/posts", fd);
}

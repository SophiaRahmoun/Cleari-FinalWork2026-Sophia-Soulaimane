import { api } from "./client";

export const getCommunityPosts = () => api.get("/community/posts");
export const getCommunityFeed = () => api.get("/community/feed");
export const likePost = (postId) => api.post(`/community/posts/${postId}/like`);
export const unlikePost = (postId) =>
  api.delete(`/community/posts/${postId}/like`);
export const getComments = (postId) =>
  api.get(`/community/posts/${postId}/comments`);
export const createComment = (postId, content) =>
  api.post(`/community/posts/${postId}/comments`, { content });

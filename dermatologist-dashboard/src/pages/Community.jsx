import { useEffect, useState } from "react";
import {
  getCommunityPosts,
  likePost,
  unlikePost,
  getComments,
  createComment,
} from "../api/community";
import "./Community.css";

function Avatar({ user, size = 38 }) {
  const src = user?.profile_picture_url || user?.profilePictureUrl || null;
  const letter = user?.username?.[0]?.toUpperCase() || "?";
  if (src) {
    return (
      <img
        src={src}
        alt={user?.username || ""}
        className="author-avatar author-avatar--img"
        style={{ width: size, height: size }}
        onError={(e) => {
          e.currentTarget.style.display = "none";
          e.currentTarget.nextSibling.style.display = "flex";
        }}
      />
    );
  }
  return (
    <span className="author-avatar" style={{ width: size, height: size }}>
      {letter}
    </span>
  );
}

function PostImage({ src }) {
  const [broken, setBroken] = useState(false);
  if (!src || broken) return null;
  const isCloudinary = src.includes("cloudinary.com") || src.startsWith("http");
  if (!isCloudinary) return null;
  return (
    <img
      src={src}
      alt="post"
      className="post-image"
      onError={() => setBroken(true)}
    />
  );
}

export default function Community() {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [expandedPost, setExpandedPost] = useState(null);
  const [comments, setComments] = useState({});
  const [commentInput, setCommentInput] = useState({});
  const [error, setError] = useState("");

  useEffect(() => {
    getCommunityPosts()
      .then((data) => setPosts(Array.isArray(data) ? data : data.posts || []))
      .catch((e) => setError(e.message))
      .finally(() => setLoading(false));
  }, []);

  async function toggleExpand(postId) {
    if (expandedPost === postId) {
      setExpandedPost(null);
      return;
    }
    setExpandedPost(postId);
    if (!comments[postId]) {
      try {
        const data = await getComments(postId);
        setComments((prev) => ({
          ...prev,
          [postId]: data.comments || data || [],
        }));
      } catch {
        setComments((prev) => ({ ...prev, [postId]: [] }));
      }
    }
  }

  async function handleComment(postId) {
    const content = commentInput[postId]?.trim();
    if (!content) return;
    try {
      const data = await createComment(postId, content);
      const newComment = data.comment || data;
      setComments((prev) => ({
        ...prev,
        [postId]: [...(prev[postId] || []), newComment],
      }));
      setCommentInput((prev) => ({ ...prev, [postId]: "" }));
    } catch (e) {
      alert(e.message);
    }
  }

  async function handleLike(post) {
    try {
      if (post.liked) {
        await unlikePost(post.id);
        setPosts((prev) =>
          prev.map((p) =>
            p.id === post.id
              ? { ...p, liked: false, likesCount: (p.likesCount || 1) - 1 }
              : p
          )
        );
      } else {
        await likePost(post.id);
        setPosts((prev) =>
          prev.map((p) =>
            p.id === post.id
              ? { ...p, liked: true, likesCount: (p.likesCount || 0) + 1 }
              : p
          )
        );
      }
    } catch (e) {
      alert(e.message);
    }
  }

  return (
    <div className="community-page">
      <div className="page-header">
        <h2 className="page-title">Community</h2>
        <p className="page-desc">Patient skin community posts</p>
      </div>

      {error && <div className="error-msg">{error}</div>}
      {loading && <div className="loading">Loading posts…</div>}

      <div className="posts-grid">
        {posts.map((post) => (
          <div key={post.id} className="post-card">
            <div className="post-author">
              <Avatar user={post.User} />
              <div className="author-info">
                <span className="author-name">
                  {post.User?.username || "Anonymous"}
                </span>
                <span className="post-date">
                  {new Date(post.createdAt).toLocaleDateString("fr-BE")}
                </span>
              </div>
            </div>

            <PostImage src={post.image || post.imageUrl} />

            <p className="post-content">{post.content}</p>

            <div className="post-actions">
              <button
                className={
                  "action-btn" + (post.liked ? " action-btn--liked" : "")
                }
                onClick={() => handleLike(post)}
              >
                <HeartIcon filled={post.liked} />
                <span>{post.likesCount || 0}</span>
              </button>
              <button
                className="action-btn"
                onClick={() => toggleExpand(post.id)}
              >
                <CommentIcon />
                <span>Comments</span>
              </button>
            </div>

            {expandedPost === post.id && (
              <div className="comments-section">
                {(comments[post.id] || []).length === 0 && (
                  <p className="no-comments">No comments yet. Be the first.</p>
                )}
                {(comments[post.id] || []).map((c, i) => (
                  <div key={c.id || i} className="comment">
                    <Avatar user={c.User} size={26} />
                    <div className="comment-body">
                      <span className="comment-author">
                        {c.User?.username || "User"}
                      </span>
                      <span className="comment-text">{c.content}</span>
                    </div>
                  </div>
                ))}
                <div className="comment-input-row">
                  <input
                    className="comment-input"
                    placeholder="Add a professional comment…"
                    value={commentInput[post.id] || ""}
                    onChange={(e) =>
                      setCommentInput((prev) => ({
                        ...prev,
                        [post.id]: e.target.value,
                      }))
                    }
                    onKeyDown={(e) =>
                      e.key === "Enter" && handleComment(post.id)
                    }
                  />
                  <button
                    className="comment-send"
                    onClick={() => handleComment(post.id)}
                  >
                    Post
                  </button>
                </div>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

function HeartIcon({ filled }) {
  return (
    <svg width="15" height="15" viewBox="0 0 24 24" fill={filled ? "currentColor" : "none"} stroke="currentColor" strokeWidth="2">
      <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
    </svg>
  );
}
function CommentIcon() {
  return (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
    </svg>
  );
}

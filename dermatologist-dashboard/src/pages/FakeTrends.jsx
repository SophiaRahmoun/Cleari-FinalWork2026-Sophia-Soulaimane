import { useEffect, useState } from "react";
import {
  getAllFakeTrendPosts,
  createFakeTrendPost,
  deleteFakeTrendPost,
} from "../api/fakeTrend";
import { useAuth } from "../auth/AuthContext";
import "./FakeTrends.css";

const SKIN_CONCERN_TAGS = [
  "acne", "redness", "oiliness", "dryness", "texture", "pigmentation",
  "wrinkles", "sensitivity", "eczema", "psoriasis",
];
const SKIN_TYPE_TAGS = ["oily", "dry", "combination", "normal", "sensitive"];

export default function FakeTrends() {
  const { user } = useAuth();
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [formError, setFormError] = useState("");
  const [expandedId, setExpandedId] = useState(null);

  const [form, setForm] = useState({
    title: "",
    trendName: "",
    tiktokUrl: "",
    description: "",
    debunkExplanation: "",
    skinConcernTag: "",
    skinTypeTag: "",
  });

  useEffect(() => {
    getAllFakeTrendPosts()
      .then((data) => setPosts(Array.isArray(data) ? data : []))
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  function handleChange(e) {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setFormError("");
    if (!form.title || !form.trendName || !form.description || !form.debunkExplanation) {
      setFormError("Title, trend name, description and debunk explanation are required.");
      return;
    }
    setSubmitting(true);
    try {
      const created = await createFakeTrendPost(form);
      setPosts((prev) => [created, ...prev]);
      setShowForm(false);
      setForm({
        title: "",
        trendName: "",
        tiktokUrl: "",
        description: "",
        debunkExplanation: "",
        skinConcernTag: "",
        skinTypeTag: "",
      });
    } catch (err) {
      setFormError(err.message || "Failed to create post.");
    } finally {
      setSubmitting(false);
    }
  }

  async function handleDelete(id) {
    if (!confirm("Delete this debunk post?")) return;
    try {
      await deleteFakeTrendPost(id);
      setPosts((prev) => prev.filter((p) => p.id !== id));
    } catch (err) {
      alert(err.message);
    }
  }

  return (
    <div className="ft-page">
      <div className="page-header">
        <div className="page-header-row">
          <div>
            <h2 className="page-title">Debunk Trends</h2>
            <p className="page-desc">
              Educate patients by debunking viral skin care myths
            </p>
          </div>
          <button className="new-post-btn" onClick={() => setShowForm((v) => !v)}>
            {showForm ? "Cancel" : "+ New debunk"}
          </button>
        </div>
      </div>

      {showForm && (
        <div className="ft-form-card">
          <h3 className="ft-form-title">Create debunk post</h3>
          {formError && <div className="error-msg">{formError}</div>}
          <form onSubmit={handleSubmit} className="ft-form">
            <div className="ft-form-row">
              <div className="ft-field">
                <label>Post title *</label>
                <input
                  name="title"
                  value={form.title}
                  onChange={handleChange}
                  placeholder="e.g. The truth about slugging your face"
                />
              </div>
              <div className="ft-field">
                <label>Trend name *</label>
                <input
                  name="trendName"
                  value={form.trendName}
                  onChange={handleChange}
                  placeholder="e.g. Slugging"
                />
              </div>
            </div>

            <div className="ft-field">
              <label>TikTok link (optional)</label>
              <input
                name="tiktokUrl"
                value={form.tiktokUrl}
                onChange={handleChange}
                placeholder="https://www.tiktok.com/@user/video/..."
              />
            </div>

            <div className="ft-field">
              <label>Description *</label>
              <textarea
                name="description"
                value={form.description}
                onChange={handleChange}
                rows={3}
                placeholder="Describe the trend and why it is circulating…"
              />
            </div>

            <div className="ft-field">
              <label>Debunk explanation *</label>
              <textarea
                name="debunkExplanation"
                value={form.debunkExplanation}
                onChange={handleChange}
                rows={3}
                placeholder="Explain the medical reality and any risks…"
              />
            </div>

            <div className="ft-form-row">
              <div className="ft-field">
                <label>Skin concern tag</label>
                <select
                  name="skinConcernTag"
                  value={form.skinConcernTag}
                  onChange={handleChange}
                >
                  <option value="">— select —</option>
                  {SKIN_CONCERN_TAGS.map((t) => (
                    <option key={t} value={t}>{t}</option>
                  ))}
                </select>
              </div>
              <div className="ft-field">
                <label>Skin type tag</label>
                <select
                  name="skinTypeTag"
                  value={form.skinTypeTag}
                  onChange={handleChange}
                >
                  <option value="">— select —</option>
                  {SKIN_TYPE_TAGS.map((t) => (
                    <option key={t} value={t}>{t}</option>
                  ))}
                </select>
              </div>
            </div>

            <button type="submit" className="ft-submit-btn" disabled={submitting}>
              {submitting ? "Publishing…" : "Publish debunk"}
            </button>
          </form>
        </div>
      )}

      {loading && <div className="loading">Loading your posts…</div>}

      {!loading && posts.length === 0 && !showForm && (
        <div className="ft-empty">
          <p>You haven't published any debunk posts yet.</p>
          <button className="new-post-btn" onClick={() => setShowForm(true)}>
            Create your first post
          </button>
        </div>
      )}

      <div className="ft-posts">
        {posts.map((post) => (
          <div key={post.id} className="ft-card">
            <div className="ft-card-top">
              {post.imageUrl && (
                <img
                  src={post.imageUrl}
                  alt=""
                  className="ft-card-img"
                  onError={(e) => (e.currentTarget.style.display = "none")}
                />
              )}
              <div className="ft-card-body">
                <div className="ft-card-tags">
                  {post.skinConcernTag && (
                    <span className="ft-tag">{post.skinConcernTag}</span>
                  )}
                  {post.skinTypeTag && (
                    <span className="ft-tag ft-tag--type">{post.skinTypeTag}</span>
                  )}
                </div>
                <h4 className="ft-card-title">{post.title}</h4>
                <p className="ft-trend-name">Trend: {post.trendName}</p>
                {post.tiktokUrl && (
                  <a
                    href={post.tiktokUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="ft-tiktok-link"
                  >
                    View TikTok
                  </a>
                )}
              </div>
            </div>

            <button
              className="ft-expand-btn"
              onClick={() =>
                setExpandedId((id) => (id === post.id ? null : post.id))
              }
            >
              {expandedId === post.id ? "Hide details" : "Show details"}
            </button>

            {expandedId === post.id && (
              <div className="ft-expanded">
                <div className="ft-section">
                  <span className="ft-section-label">Description</span>
                  <p>{post.description}</p>
                </div>
                <div className="ft-section ft-section--debunk">
                  <span className="ft-section-label">Debunk</span>
                  <p>{post.debunkExplanation}</p>
                </div>
              </div>
            )}

            <div className="ft-card-footer">
              <span className="ft-date">
                {new Date(post.createdAt).toLocaleDateString("fr-BE")}
              </span>
              <div className="ft-footer-right">
                {post.dermatologist?.username && (
                  <span className="ft-author">by {post.dermatologist.username}</span>
                )}
                {(post.dermatologistId === user?.id) && (
                  <button className="ft-delete-btn" onClick={() => handleDelete(post.id)}>
                    Delete
                  </button>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

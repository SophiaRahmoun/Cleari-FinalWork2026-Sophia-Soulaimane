import { useEffect, useState } from "react";
import { getMyEarnings } from "../api/fakeTrend";
import "./Earnings.css";

export default function Earnings() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    getMyEarnings()
      .then(setData)
      .catch((e) => setError(e.message))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <div className="loading">Loading earnings…</div>;
  if (error) return <div className="error-msg">{error}</div>;
  if (!data) return null;

  return (
    <div className="earnings-page">
      <div className="page-header">
        <h2 className="page-title">Earnings</h2>
        <p className="page-desc">Your estimated rewards from debunk posts</p>
      </div>

      <div className="earnings-summary">
        <StatCard label="Total posts" value={data.totalPosts} />
        <StatCard label="Total likes" value={data.totalLikes} />
        <StatCard label="Total comments" value={data.totalComments} />
        <StatCard
          label="Estimated earnings"
          value={`€ ${data.estimatedEarnings?.toFixed(2)}`}
          highlight
        />
      </div>

      {data.posts?.length > 0 && (
        <div className="earnings-posts">
          <h3 className="ep-title">Post breakdown</h3>
          <div className="ep-list">
            {data.posts.map((post) => (
              <div key={post.id} className="ep-row">
                <div className="ep-info">
                  {post.imageUrl && (
                    <img
                      src={post.imageUrl}
                      alt=""
                      className="ep-img"
                      onError={(e) => (e.currentTarget.style.display = "none")}
                    />
                  )}
                  <div>
                    <span className="ep-name">{post.title}</span>
                    <span className="ep-trend">{post.trendName}</span>
                  </div>
                </div>
                <div className="ep-stats">
                  <span className="ep-stat">
                    <span className="ep-stat-label">Likes</span>
                    <span className="ep-stat-val">{post.likesCount}</span>
                  </span>
                  <span className="ep-stat">
                    <span className="ep-stat-label">Comments</span>
                    <span className="ep-stat-val">{post.commentsCount}</span>
                  </span>
                  <span className="ep-stat ep-stat--reward">
                    <span className="ep-stat-label">Reward</span>
                    <span className="ep-stat-val">€ {post.estimatedReward?.toFixed(2)}</span>
                  </span>
                </div>
              </div>
            ))}
          </div>

          <p className="ep-disclaimer">
            Estimated rewards are calculated at €0.05 per like and €0.15 per comment.
            Final payouts depend on platform policy.
          </p>
        </div>
      )}

      {(!data.posts || data.posts.length === 0) && (
        <div className="empty-state">
          No posts yet. Publish debunk posts to start earning.
        </div>
      )}
    </div>
  );
}

function StatCard({ label, value, highlight }) {
  return (
    <div className={"stat-card" + (highlight ? " stat-card--highlight" : "")}>
      <span className="stat-label">{label}</span>
      <span className="stat-value">{value}</span>
    </div>
  );
}

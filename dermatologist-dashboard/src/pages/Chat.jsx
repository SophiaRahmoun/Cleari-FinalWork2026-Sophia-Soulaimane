import { useEffect, useState, useRef } from "react";
import {
  getConversations, getMessages, sendMessage,
  getPatientScans, getPatientForm, getPatientRoutines,
} from "../api/chat";
import "./Chat.css";

/* ── Reusable avatar ── */
function Avatar({ user, size = 36 }) {
  const src = user?.profilePictureUrl || user?.profile_picture_url || null;
  const letter =
    user?.username?.[0]?.toUpperCase() ||
    user?.firstName?.[0]?.toUpperCase() || "P";

  const [imgFailed, setImgFailed] = useState(false);

  if (src && !imgFailed) {
    return (
      <img
        src={src}
        alt=""
        className="conv-avatar conv-avatar--img"
        style={{ width: size, height: size, borderRadius: "50%" }}
        onError={() => setImgFailed(true)}
      />
    );
  }
  return (
    <span className="conv-avatar" style={{ width: size, height: size }}>
      {letter}
    </span>
  );
}

/* ── Main Chat page ── */
export default function Chat() {
  const [conversations, setConversations] = useState([]);
  const [active, setActive]               = useState(null);
  const [messages, setMessages]           = useState([]);
  const [input, setInput]                 = useState("");
  const [sending, setSending]             = useState(false);
  const [sidePanel, setSidePanel]         = useState(null);
  const [sidePanelData, setSidePanelData] = useState(null);
  const [sidePanelLoading, setSidePanelLoading] = useState(false);
  const [loading, setLoading]             = useState(true);
  const bottomRef = useRef(null);

  useEffect(() => {
    getConversations()
      .then((data) => setConversations(data.conversations || data || []))
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    if (!active) return;
    getMessages(active.id)
      .then((data) => setMessages(data.messages || data || []))
      .catch(console.error);
  }, [active]);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  async function handleSend() {
    const text = input.trim();
    if (!text || sending) return;
    setSending(true);
    setInput("");
    try {
      const data = await sendMessage(active.id, text);
      setMessages((prev) => [...prev, data.newMessage || data.message || data]);
    } catch (e) {
      alert(e.message);
      setInput(text);
    } finally {
      setSending(false);
    }
  }

  async function openSidePanel(type) {
    if (sidePanel === type) { setSidePanel(null); setSidePanelData(null); return; }
    setSidePanel(type);
    setSidePanelData(null);
    setSidePanelLoading(true);
    try {
      let data;
      if (type === "scans")    data = await getPatientScans(active.id);
      else if (type === "form")     data = await getPatientForm(active.id);
      else if (type === "routines") data = await getPatientRoutines(active.id);
      setSidePanelData(data);
    } catch (e) {
      setSidePanelData({ _error: e.message });
    } finally {
      setSidePanelLoading(false);
    }
  }

  function getPatient(conv) {
    return conv.patient || conv.otherUser || conv.User || null;
  }

  return (
    <div className="chat-page">
      <div className="page-header">
        <h2 className="page-title">Chat</h2>
        <p className="page-desc">Patient conversations</p>
      </div>

      <div className="chat-layout">
        {/* Conversation list */}
        <div className="conv-list">
          {loading && <div className="loading">Loading…</div>}
          {!loading && conversations.length === 0 && (
            <div className="empty-state">No conversations yet.</div>
          )}
          {conversations.map((conv) => {
            const patient = getPatient(conv);
            const name = conv.patientName || patient?.username || `Patient #${conv.userId}`;
            return (
              <button
                key={conv.id}
                className={"conv-item" + (active?.id === conv.id ? " conv-item--active" : "")}
                onClick={() => { setActive(conv); setSidePanel(null); setSidePanelData(null); setMessages([]); }}
              >
                <Avatar user={patient} size={36} />
                <div className="conv-info">
                  <span className="conv-name">{name}</span>
                  <span className="conv-preview">Tap to open</span>
                </div>
              </button>
            );
          })}
        </div>

        {/* Chat window */}
        {active ? (
          <div className="chat-main">
            <div className="chat-top-bar">
              <div className="chat-patient-info">
                <Avatar user={getPatient(active)} size={34} />
                <span className="chat-patient-name">
                  {active.patientName || getPatient(active)?.username || "Patient"}
                </span>
              </div>
              <div className="patient-data-btns">
                {[
                  { key: "scans",    label: "Skin Scans" },
                  { key: "form",     label: "Skin Form"  },
                  { key: "routines", label: "Routines"   },
                ].map(({ key, label }) => (
                  <button
                    key={key}
                    className={"pdata-btn" + (sidePanel === key ? " pdata-btn--active" : "")}
                    onClick={() => openSidePanel(key)}
                  >
                    {label}
                  </button>
                ))}
              </div>
            </div>

            <div className="messages-area">
              {messages.map((msg, i) => {
                const isMine = msg.senderRole === "dermatologist";
                const isImg  = msg.messageType === "image";
                return (
                  <div key={msg.id || i}
                    className={"msg-bubble " + (isMine ? "msg-bubble--mine" : "msg-bubble--theirs")}>
                    {isImg
                      ? <img src={msg.content} alt="img" className="msg-image"
                          onError={(e) => (e.currentTarget.style.display = "none")} />
                      : <span>{msg.content}</span>}
                  </div>
                );
              })}
              <div ref={bottomRef} />
            </div>

            <div className="chat-input-row">
              <input className="chat-input" placeholder="Type a message…"
                value={input} onChange={(e) => setInput(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && handleSend()} />
              <button className="chat-send-btn" onClick={handleSend}
                disabled={sending || !input.trim()}>Send</button>
            </div>
          </div>
        ) : (
          <div className="chat-empty">
            <p>Select a conversation to start chatting</p>
          </div>
        )}

        {/* Side panel */}
        {sidePanel && (
          <div className="side-panel">
            <div className="side-panel-header">
              <h4>
                {sidePanel === "scans"    && "Skin Scans"}
                {sidePanel === "form"     && "Skin Form"}
                {sidePanel === "routines" && "Routines"}
              </h4>
              <button className="close-btn" onClick={() => { setSidePanel(null); setSidePanelData(null); }}>✕</button>
            </div>
            <div className="side-panel-body">
              {sidePanelLoading && <div className="loading">Loading…</div>}
              {!sidePanelLoading && sidePanelData?._error && (
                <div className="side-panel-error">
                  <p>Could not load data</p>
                  <p className="error-detail">{sidePanelData._error}</p>
                </div>
              )}
              {!sidePanelLoading && sidePanelData && !sidePanelData._error && (
                <PatientDataView type={sidePanel} data={sidePanelData} />
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

/* ══════════════════════════════════════════
   Patient data views
══════════════════════════════════════════ */

function PatientDataView({ type, data }) {
  if (type === "scans")    return <ScansView    data={data} />;
  if (type === "form")     return <FormView     data={data} />;
  if (type === "routines") return <RoutinesView data={data} />;
  return null;
}

/* ── Scans ── */
function ScansView({ data }) {
  const scans = data.scans || data || [];
  if (!scans.length) return <p className="empty-state">No scans found.</p>;

  return (
    <div className="scans-list">
      {scans.map((s, i) => <ScanCard key={s.id || i} scan={s} />)}
    </div>
  );
}

function ScanCard({ scan: s }) {
  /* Parse result — it may be a JSON string or already an object */
  let parsed = null;
  if (s.result) {
    if (typeof s.result === "string") {
      try { parsed = JSON.parse(s.result); }
      catch { parsed = { shortAdvice: s.result }; }
    } else {
      parsed = s.result;
    }
  }

  /*
   * recommendation may be:
   *   • a string  → render as text
   *   • an object { skinTypeEstimate, recommendationLevel, shortAdvice }
   *   • undefined
   */
  const rec = parsed?.recommendation ?? null;
  const recIsObj  = rec && typeof rec === "object";
  const recIsStr  = rec && typeof rec === "string";

  const insights  = Array.isArray(parsed?.insights) ? parsed.insights : [];

  const isCloudinary = s.image_url &&
    (s.image_url.startsWith("https://res.cloudinary") ||
     s.image_url.startsWith("http://res.cloudinary"));

  const SCORES = [
    { label: "Overall",  value: s.overall_score  },
    { label: "Acne",     value: s.acne_score     },
    { label: "Redness",  value: s.redness_score  },
    { label: "Oiliness", value: s.oiliness_score },
    { label: "Texture",  value: s.texture_score  },
    { label: "Spots",    value: s.spots_score    },
  ].filter((sc) => sc.value != null);

  return (
    <div className="scan-card">
      {/* Image */}
      {isCloudinary
        ? <img src={s.image_url} alt="scan" className="scan-img"
            onError={(e) => { e.currentTarget.style.display = "none"; }} />
        : <div className="scan-img-placeholder">No scan image</div>}

      {/* Date */}
      <p className="scan-date">
        {s.createdAt
          ? new Date(s.createdAt).toLocaleDateString("fr-BE", { day: "numeric", month: "short", year: "numeric" })
          : "Unknown date"}
      </p>

      {/* Scores */}
      {SCORES.length > 0 && (
        <div className="scan-scores">
          {SCORES.map(({ label, value }) => (
            <div key={label} className="score-row">
              <span className="score-label">{label}</span>
              <div className="score-bar">
                <div className="score-fill" style={{ width: `${Math.min(value, 100)}%` }} />
              </div>
              <span className="score-num">{value}</span>
            </div>
          ))}
        </div>
      )}

      {/* Recommendation — object form */}
      {recIsObj && (
        <div className="scan-rec">
          <span className="rec-section-label">Recommendation</span>
          {rec.skinTypeEstimate && (
            <div className="rec-row">
              <span className="rec-key">Skin type</span>
              <span className="rec-val">{rec.skinTypeEstimate}</span>
            </div>
          )}
          {rec.recommendationLevel && (
            <div className="rec-row">
              <span className="rec-key">Level</span>
              <span className="rec-val rec-level">{rec.recommendationLevel}</span>
            </div>
          )}
          {rec.shortAdvice && (
            <div className="rec-advice">
              <span className="rec-key">Advice</span>
              <p className="rec-advice-text">{rec.shortAdvice}</p>
            </div>
          )}
        </div>
      )}

      {/* Recommendation — plain string */}
      {recIsStr && (
        <div className="scan-rec">
          <span className="rec-section-label">Recommendation</span>
          <p className="rec-advice-text">{rec}</p>
        </div>
      )}

      {/* Insights */}
      {insights.length > 0 && (
        <div className="scan-insights">
          <span className="rec-section-label">Insights</span>
          {insights.map((ins, j) => (
            <div key={j} className="insight-card">
              {typeof ins === "string"
                ? <span className="insight-desc">{ins}</span>
                : <>
                    {ins.title       && <span className="insight-title">{ins.title}</span>}
                    {ins.description && <span className="insight-desc">{ins.description}</span>}
                    {ins.shortAdvice && <span className="insight-desc">{ins.shortAdvice}</span>}
                  </>}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

/* ── Form ── */
function FormView({ data }) {
  const form = data.form || data || null;
  if (!form || typeof form !== "object")
    return <p className="empty-state">No skin form found.</p>;

  const SECTIONS = [
    { key: "skin_feeling",       label: "Skin feeling"        },
    { key: "product_reaction",   label: "Product reaction"    },
    { key: "flakiness",          label: "Flakiness"           },
    { key: "diagnosed_condition",label: "Diagnosed condition" },
    { key: "has_allergies",      label: "Has allergies"       },
    { key: "allergies_details",  label: "Allergy details"     },
    { key: "has_skin_issues",    label: "Has skin issues"     },
    { key: "main_concern",       label: "Main concern"        },
  ];

  const filled = SECTIONS.filter((s) => form[s.key] != null && form[s.key] !== "");

  if (!filled.length) return <p className="empty-state">Form is empty.</p>;

  return (
    <div className="form-answers">
      {filled.map(({ key, label }) => (
        <div key={key} className="form-answer-row">
          <span className="fa-question">{label}</span>
          <span className="fa-answer">{String(form[key])}</span>
        </div>
      ))}
      {form.wants_photo_upload != null && (
        <div className="form-answer-row">
          <span className="fa-question">Wants photo upload</span>
          <span className="fa-answer">{form.wants_photo_upload ? "Yes" : "No"}</span>
        </div>
      )}
      {form.consent_shared != null && (
        <div className="form-answer-row">
          <span className="fa-question">Consent shared</span>
          <span className="fa-answer">{form.consent_shared ? "Yes" : "No"}</span>
        </div>
      )}
    </div>
  );
}

/* ── Routines ── */
function RoutinesView({ data }) {
  const routines = data.routines || data || [];
  if (!routines.length) return <p className="empty-state">No routines found.</p>;

  return (
    <div className="routines-list">
      {routines.map((r, i) => {
        const hasImg = r.product_image_url &&
          (r.product_image_url.startsWith("https://res.cloudinary") ||
           r.product_image_url.startsWith("http://res.cloudinary"));
        return (
          <div key={r.id || i} className="routine-item">
            {hasImg
              ? <img src={r.product_image_url} alt={r.product_name} className="routine-img"
                  onError={(e) => (e.currentTarget.style.display = "none")} />
              : <div className="routine-img-placeholder">{r.product_name?.[0] || "P"}</div>}
            <div className="routine-body">
              <span className="routine-name">{r.product_name}</span>
              {r.usage_time && <span className="routine-usage">{r.usage_time}</span>}
              {r.notes      && <span className="routine-notes">{r.notes}</span>}
            </div>
          </div>
        );
      })}
    </div>
  );
}

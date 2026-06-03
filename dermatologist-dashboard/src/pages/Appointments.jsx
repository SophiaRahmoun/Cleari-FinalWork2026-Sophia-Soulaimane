import { useEffect, useState } from "react";
import {
  getAppointmentRequests,
  updateAppointmentStatus,
} from "../api/appointments";
import "./Appointments.css";

const STATUS_COLORS = {
  pending: "#9e9e9e",
  accepted: "#e8913a",
  declined: "#e05555",
};

function formatDate(dateStr) {
  if (!dateStr) return "—";
  return new Date(dateStr).toLocaleDateString("fr-BE", {
    weekday: "short",
    day: "numeric",
    month: "short",
    year: "numeric",
  });
}

function formatTime(timeStr) {
  if (!timeStr) return "—";
  return timeStr.slice(0, 5);
}

export default function Appointments() {
  const [appointments, setAppointments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selected, setSelected] = useState(null);
  const [updating, setUpdating] = useState(null);
  const [error, setError] = useState("");

  useEffect(() => {
    load();
  }, []);

  async function load() {
    try {
      const data = await getAppointmentRequests();
      setAppointments(data.appointments || data || []);
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  }

  async function handleStatus(id, status) {
    setUpdating(id);
    try {
      await updateAppointmentStatus(id, status);
      setAppointments((prev) =>
        prev.map((a) => (a.id === id ? { ...a, status } : a))
      );
      if (selected?.id === id) setSelected((s) => ({ ...s, status }));
    } catch (e) {
      alert(e.message);
    } finally {
      setUpdating(null);
    }
  }

  const grouped = appointments.reduce((acc, a) => {
    const key = a.date || "unknown";
    if (!acc[key]) acc[key] = [];
    acc[key].push(a);
    return acc;
  }, {});

  const sortedDates = Object.keys(grouped).sort();

  return (
    <div className="appt-page">
      <div className="page-header">
        <h2 className="page-title">Appointments</h2>
        <p className="page-desc">Manage patient appointment requests</p>
      </div>

      {error && <div className="error-msg">{error}</div>}

      {loading ? (
        <div className="loading">Loading…</div>
      ) : appointments.length === 0 ? (
        <div className="empty-state">No appointment requests yet.</div>
      ) : (
        <div className="appt-layout">
          <div className="calendar-view">
            {sortedDates.map((date) => (
              <div key={date} className="cal-day">
                <div className="cal-date-label">{formatDate(date)}</div>
                <div className="cal-slots">
                  {grouped[date].map((a) => (
                    <button
                      key={a.id}
                      className="cal-slot"
                      style={{ borderLeftColor: STATUS_COLORS[a.status] || "#9e9e9e" }}
                      onClick={() => setSelected(a)}
                    >
                      <span
                        className="slot-dot"
                        style={{ background: STATUS_COLORS[a.status] || "#9e9e9e" }}
                      />
                      <span className="slot-time">{formatTime(a.time)}</span>
                      <span className="slot-patient">
                        {a.patient?.username || a.User?.username || "Patient"}
                      </span>
                    </button>
                  ))}
                </div>
              </div>
            ))}
          </div>

          {selected && (
            <div className="appt-detail-panel">
              <button className="close-btn" onClick={() => setSelected(null)}>
                ✕
              </button>
              <h3 className="detail-title">Appointment Details</h3>

              <div className="detail-grid">
                <div className="detail-row">
                  <span className="detail-label">Patient</span>
                  <span className="detail-value">
                    {selected.patient?.username ||
                      selected.User?.username ||
                      "Unknown"}
                  </span>
                </div>
                <div className="detail-row">
                  <span className="detail-label">Date</span>
                  <span className="detail-value">{formatDate(selected.date)}</span>
                </div>
                <div className="detail-row">
                  <span className="detail-label">Time</span>
                  <span className="detail-value">{formatTime(selected.time)}</span>
                </div>
                <div className="detail-row">
                  <span className="detail-label">Reason</span>
                  <span className="detail-value">
                    {selected.reason || "Not specified"}
                  </span>
                </div>
                <div className="detail-row">
                  <span className="detail-label">Status</span>
                  <span
                    className="detail-badge"
                    style={{
                      background: STATUS_COLORS[selected.status] + "22",
                      color: STATUS_COLORS[selected.status],
                    }}
                  >
                    {selected.status}
                  </span>
                </div>
              </div>

              {selected.status === "pending" && (
                <div className="detail-actions">
                  <button
                    className="btn-accept"
                    disabled={updating === selected.id}
                    onClick={() => handleStatus(selected.id, "accepted")}
                  >
                    Accept
                  </button>
                  <button
                    className="btn-decline"
                    disabled={updating === selected.id}
                    onClick={() => handleStatus(selected.id, "declined")}
                  >
                    Decline
                  </button>
                </div>
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

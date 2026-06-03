import { useEffect, useState, useMemo } from "react";
import {
  getAppointmentRequests,
  updateAppointmentStatus,
} from "../api/appointments";
import "./Appointments.css";

/* Status → colour mapping (using Cleari palette) */
const STATUS_COLOR = {
  pending:   "#9e9e9e",
  approved:  "#E07B39",
  confirmed: "#E07B39",
  declined:  "#c03838",
  cancelled: "#c03838",
  completed: "#3a9a60",
};

function patientName(a) {
  const u = a.user || a.User || a.patient;
  if (!u) return `Patient #${a.user_id || "?"}`;
  const full = [u.first_name, u.last_name].filter(Boolean).join(" ").trim();
  return full || u.username || `Patient #${a.user_id}`;
}

function formatDate(dateStr) {
  if (!dateStr) return "—";
  // appointment_date is DATEONLY e.g. "2025-01-15"
  const [y, m, d] = dateStr.split("-");
  if (!y || !m || !d) return dateStr;
  return new Date(+y, +m - 1, +d).toLocaleDateString("fr-BE", {
    weekday: "short", day: "numeric", month: "short", year: "numeric",
  });
}

function formatTime(timeStr) {
  if (!timeStr) return "—";
  // appointment_time is TIME e.g. "14:30:00"
  return timeStr.slice(0, 5);
}

/* ── Component ── */
export default function Appointments() {
  const [appointments, setAppointments] = useState([]);
  const [loading,  setLoading]  = useState(true);
  const [selected, setSelected] = useState(null);
  const [updating, setUpdating] = useState(null);
  const [error,    setError]    = useState("");

  useEffect(() => { load(); }, []);

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

  /* Group by date for the calendar column */
  const grouped = useMemo(() => {
    const map = {};
    for (const a of appointments) {
      const key = a.appointment_date || "unknown";
      if (!map[key]) map[key] = [];
      map[key].push(a);
    }
    return map;
  }, [appointments]);

  const sortedDates = Object.keys(grouped).sort();

  const canAct = selected?.status === "pending";

  return (
    <div className="appt-page">
      <div className="page-header">
        <h2 className="page-title">Appointments</h2>
        <p className="page-desc">
          {appointments.length} request{appointments.length !== 1 ? "s" : ""}
        </p>
      </div>

      {error   && <div className="error-msg">{error}</div>}
      {loading && <div className="loading">Loading appointments…</div>}

      {!loading && appointments.length === 0 && !error && (
        <div className="empty-state">No appointment requests yet.</div>
      )}

      {!loading && appointments.length > 0 && (
        <div className="appt-layout">
          {/* ── Calendar column ── */}
          <div className="calendar-view">
            {sortedDates.map((date) => (
              <div key={date} className="cal-day">
                <div className="cal-date-label">{formatDate(date)}</div>
                <div className="cal-slots">
                  {grouped[date].map((a) => {
                    const color = STATUS_COLOR[a.status] ?? "#9e9e9e";
                    const isActive = selected?.id === a.id;
                    return (
                      <button
                        key={a.id}
                        className={"cal-slot" + (isActive ? " cal-slot--active" : "")}
                        style={{ borderLeftColor: color }}
                        onClick={() => setSelected(a)}
                      >
                        <span className="slot-dot" style={{ background: color }} />
                        <span className="slot-time">{formatTime(a.appointment_time)}</span>
                        <span className="slot-patient">{patientName(a)}</span>
                        <span className="slot-status" style={{ color }}>
                          {a.status}
                        </span>
                      </button>
                    );
                  })}
                </div>
              </div>
            ))}
          </div>

          {/* ── Detail panel ── */}
          {selected && (
            <div className="appt-detail-panel">
              <button className="close-btn" onClick={() => setSelected(null)}>✕</button>
              <h3 className="detail-title">Appointment details</h3>

              <div className="detail-grid">
                <DetailRow label="Patient"  value={patientName(selected)} />
                <DetailRow label="Date"     value={formatDate(selected.appointment_date)} />
                <DetailRow label="Time"     value={formatTime(selected.appointment_time)} />
                <DetailRow label="Reason"   value={selected.reason || "Not specified"} />
                <div className="detail-row">
                  <span className="detail-label">Status</span>
                  <span
                    className="detail-badge"
                    style={{
                      background: (STATUS_COLOR[selected.status] ?? "#9e9e9e") + "22",
                      color: STATUS_COLOR[selected.status] ?? "#9e9e9e",
                    }}
                  >
                    {selected.status}
                  </span>
                </div>
              </div>

              {/* Patient avatar if available */}
              {(selected.user?.profile_picture_url || selected.User?.profile_picture_url) && (
                <img
                  src={selected.user?.profile_picture_url || selected.User?.profile_picture_url}
                  alt=""
                  className="detail-patient-avatar"
                  onError={(e) => (e.currentTarget.style.display = "none")}
                />
              )}

              {canAct && (
                <div className="detail-actions">
                  <button
                    className="btn-accept"
                    disabled={updating === selected.id}
                    onClick={() => handleStatus(selected.id, "approved")}
                  >
                    {updating === selected.id ? "…" : "Approve"}
                  </button>
                  <button
                    className="btn-decline"
                    disabled={updating === selected.id}
                    onClick={() => handleStatus(selected.id, "declined")}
                  >
                    {updating === selected.id ? "…" : "Decline"}
                  </button>
                </div>
              )}

              {!canAct && selected.status !== "pending" && (
                <div
                  className="detail-status-note"
                  style={{ color: STATUS_COLOR[selected.status] }}
                >
                  This appointment is <strong>{selected.status}</strong>.
                </div>
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

function DetailRow({ label, value }) {
  return (
    <div className="detail-row">
      <span className="detail-label">{label}</span>
      <span className="detail-value">{value}</span>
    </div>
  );
}

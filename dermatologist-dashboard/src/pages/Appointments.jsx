import { useEffect, useState, useMemo } from "react";
import {
  getAppointmentRequests,
  updateAppointmentStatus,
} from "../api/appointments";
import "./Appointments.css";

const STATUS_COLOR = {
  pending:   "#9e9e9e",
  approved:  "#E07B39",
  confirmed: "#E07B39",
  declined:  "#c03838",
  cancelled: "#c03838",
  completed: "#3a9a60",
};

function getUser(a) {
  return a.user || a.User || a.patient || null;
}

function patientName(a) {
  const u = getUser(a);
  if (!u) return `Patient #${a.user_id || "?"}`;
  const full = [u.first_name, u.last_name].filter(Boolean).join(" ").trim();
  return full || u.username || `Patient #${a.user_id}`;
}

function patientAvatar(a) {
  const u = getUser(a);
  return u?.profile_picture_url || null;
}

function formatDate(dateStr) {
  if (!dateStr) return "—";
  const [y, m, d] = dateStr.split("-");
  if (!y || !m || !d) return dateStr;
  return new Date(+y, +m - 1, +d).toLocaleDateString("fr-BE", {
    weekday: "short", day: "numeric", month: "short", year: "numeric",
  });
}

function formatTime(timeStr) {
  if (!timeStr) return "—";
  return timeStr.slice(0, 5);
}

/* ── Monthly calendar helpers ── */
const DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

function daysInMonth(year, month) {
  return new Date(year, month + 1, 0).getDate();
}

function firstDayOfMonth(year, month) {
  const d = new Date(year, month, 1).getDay();
  return d === 0 ? 6 : d - 1; // Monday=0
}

/* ── Component ── */
export default function Appointments() {
  const [appointments, setAppointments] = useState([]);
  const [loading,  setLoading]  = useState(true);
  const [selected, setSelected] = useState(null);
  const [updating, setUpdating] = useState(null);
  const [error,    setError]    = useState("");

  const today = new Date();
  const [calYear,  setCalYear]  = useState(today.getFullYear());
  const [calMonth, setCalMonth] = useState(today.getMonth());

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

  /* Group by date for both the list and the calendar */
  const byDate = useMemo(() => {
    const map = {};
    for (const a of appointments) {
      const key = a.appointment_date || "unknown";
      if (!map[key]) map[key] = [];
      map[key].push(a);
    }
    return map;
  }, [appointments]);

  const sortedDates = Object.keys(byDate).sort();
  const canAct = selected?.status === "pending";

  /* Calendar grid data */
  const totalDays   = daysInMonth(calYear, calMonth);
  const startOffset = firstDayOfMonth(calYear, calMonth);
  const monthLabel  = new Date(calYear, calMonth, 1).toLocaleDateString("fr-BE", {
    month: "long", year: "numeric",
  });

  function prevMonth() {
    if (calMonth === 0) { setCalYear(y => y - 1); setCalMonth(11); }
    else setCalMonth(m => m - 1);
  }
  function nextMonth() {
    if (calMonth === 11) { setCalYear(y => y + 1); setCalMonth(0); }
    else setCalMonth(m => m + 1);
  }

  function apptForDay(day) {
    const pad = (n) => String(n).padStart(2, "0");
    const key = `${calYear}-${pad(calMonth + 1)}-${pad(day)}`;
    return byDate[key] || [];
  }

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
          {/* ── Request list ── */}
          <div className="calendar-view">
            {sortedDates.map((date) => (
              <div key={date} className="cal-day">
                <div className="cal-date-label">{formatDate(date)}</div>
                <div className="cal-slots">
                  {byDate[date].map((a) => {
                    const color   = STATUS_COLOR[a.status] ?? "#9e9e9e";
                    const isActive = selected?.id === a.id;
                    const avatar  = patientAvatar(a);
                    return (
                      <button
                        key={a.id}
                        className={"cal-slot" + (isActive ? " cal-slot--active" : "")}
                        style={{ borderLeftColor: color }}
                        onClick={() => setSelected(a)}
                      >
                        {avatar ? (
                          <img
                            src={avatar}
                            alt=""
                            className="slot-avatar"
                            onError={(e) => { e.currentTarget.style.display = "none"; }}
                          />
                        ) : (
                          <span className="slot-avatar slot-avatar--placeholder">
                            {patientName(a).charAt(0).toUpperCase()}
                          </span>
                        )}
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

              {/* Patient header */}
              <div className="detail-patient-header">
                {patientAvatar(selected) ? (
                  <img
                    src={patientAvatar(selected)}
                    alt=""
                    className="detail-avatar"
                    onError={(e) => (e.currentTarget.style.display = "none")}
                  />
                ) : (
                  <span className="detail-avatar detail-avatar--placeholder">
                    {patientName(selected).charAt(0).toUpperCase()}
                  </span>
                )}
                <div>
                  <div className="detail-patient-name">{patientName(selected)}</div>
                  {getUser(selected)?.email && (
                    <div className="detail-patient-email">{getUser(selected).email}</div>
                  )}
                </div>
              </div>

              <h3 className="detail-title">Appointment details</h3>

              <div className="detail-grid">
                <DetailRow label="Date"   value={formatDate(selected.appointment_date)} />
                <DetailRow label="Time"   value={formatTime(selected.appointment_time)} />
                <DetailRow label="Reason" value={selected.reason || "Not specified"} />
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

      {/* ── Monthly calendar ── */}
      {!loading && (
        <div className="month-cal">
          <div className="month-cal-header">
            <button className="month-nav" onClick={prevMonth}>‹</button>
            <span className="month-label">{monthLabel}</span>
            <button className="month-nav" onClick={nextMonth}>›</button>
          </div>

          <div className="month-grid">
            {DAYS.map((d) => (
              <div key={d} className="month-day-name">{d}</div>
            ))}

            {Array.from({ length: startOffset }).map((_, i) => (
              <div key={`empty-${i}`} className="month-cell month-cell--empty" />
            ))}

            {Array.from({ length: totalDays }, (_, i) => i + 1).map((day) => {
              const appts = apptForDay(day);
              const isToday =
                day === today.getDate() &&
                calMonth === today.getMonth() &&
                calYear === today.getFullYear();
              return (
                <div
                  key={day}
                  className={"month-cell" + (isToday ? " month-cell--today" : "")}
                >
                  <span className="month-day-num">{day}</span>
                  {appts.length > 0 && (
                    <div className="month-dots">
                      {appts.map((a) => (
                        <span
                          key={a.id}
                          className="month-dot"
                          title={`${formatTime(a.appointment_time)} — ${patientName(a)} (${a.status})`}
                          style={{ background: STATUS_COLOR[a.status] ?? "#9e9e9e" }}
                          onClick={() => setSelected(a)}
                        />
                      ))}
                    </div>
                  )}
                </div>
              );
            })}
          </div>

          {/* Legend */}
          <div className="month-legend">
            {[
              { label: "Pending",   color: STATUS_COLOR.pending },
              { label: "Approved",  color: STATUS_COLOR.approved },
              { label: "Declined",  color: STATUS_COLOR.declined },
              { label: "Completed", color: STATUS_COLOR.completed },
            ].map(({ label, color }) => (
              <span key={label} className="legend-item">
                <span className="legend-dot" style={{ background: color }} />
                {label}
              </span>
            ))}
          </div>
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

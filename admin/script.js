const BASE = window.location.port === "4000"
  ? "/api"
  : "http://localhost:4000/api";

let token = sessionStorage.getItem("cleari_admin_token") || null;
let dermatologists = [];
let selectedId = null;

const loginScreen  = document.getElementById("login-screen");
const dashboard    = document.getElementById("dashboard");
const loginEmailEl = document.getElementById("login-email");
const loginPassEl  = document.getElementById("login-password");
const loginBtn     = document.getElementById("login-btn");
const loginError   = document.getElementById("login-error");
const logoutBtn    = document.getElementById("logout-btn");
const sidebarList  = document.getElementById("sidebar-list");
const pendingCount = document.getElementById("pending-count");
const detailEmpty  = document.getElementById("detail-empty");
const detailContent = document.getElementById("detail-content");
const toastEl      = document.getElementById("toast");

if (token) {
  showDashboard();
}

loginBtn.addEventListener("click", doLogin);
loginPassEl.addEventListener("keydown", e => { if (e.key === "Enter") doLogin(); });

async function doLogin() {
  const email    = loginEmailEl.value.trim();
  const password = loginPassEl.value;

  if (!email || !password) {
    showLoginError("Please enter your email and password.");
    return;
  }

  loginBtn.disabled = true;
  loginBtn.textContent = "Signing in…";
  loginError.classList.remove("visible");

  try {
    const res  = await fetch(`${BASE}/auth/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password }),
    });
    const data = await res.json();

    if (!res.ok) {
      showLoginError(data.message || "Login failed.");
      return;
    }

    if (data.user?.role !== "admin") {
      showLoginError("Access denied. This dashboard is for admins only.");
      return;
    }

    token = data.token;
    sessionStorage.setItem("cleari_admin_token", token);
    showDashboard();

  } catch (err) {
    showLoginError("Could not reach the server. Make sure the backend is running.");
  } finally {
    loginBtn.disabled = false;
    loginBtn.textContent = "Sign in";
  }
}

function showLoginError(msg) {
  loginError.textContent = msg;
  loginError.classList.add("visible");
}

logoutBtn.addEventListener("click", () => {
  token = null;
  sessionStorage.removeItem("cleari_admin_token");
  dashboard.classList.remove("visible");
  loginScreen.style.display = "flex";
  loginEmailEl.value = "";
  loginPassEl.value  = "";
  loginError.classList.remove("visible");
});

function showDashboard() {
  loginScreen.style.display = "none";
  dashboard.classList.add("visible");
  loadPending();
}

async function loadPending() {
  sidebarList.innerHTML = `<div class="state-msg"><div class="spinner"></div>Loading…</div>`;

  try {
    const res = await fetch(`${BASE}/dermatologists/pending`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    if (res.status === 401 || res.status === 403) {
      toast("Session expired — please sign in again.", "error");
      logoutBtn.click();
      return;
    }

    const data = await res.json();
    dermatologists = data.dermatologists || [];

  } catch (err) {
    sidebarList.innerHTML = `<div class="state-msg">⚠ Could not load data.<br><small>Check that the backend is running.</small></div>`;
    return;
  }

  renderSidebar();
}

function renderSidebar() {
  pendingCount.textContent = dermatologists.length;

  if (dermatologists.length === 0) {
    sidebarList.innerHTML = `<div class="state-msg">🎉 No pending dermatologists.</div>`;
    return;
  }

  sidebarList.innerHTML = dermatologists.map(d => {
    const initials = initFor(d);
    const name     = fullName(d);
    const sub      = d.specialization || d.inami_number || d.user?.email || "—";
    return `
      <div class="derm-row ${selectedId === d.id ? "selected" : ""}" data-id="${d.id}">
        <div class="derm-avatar">${initials}</div>
        <div class="derm-row-info">
          <div class="derm-row-name">${esc(name)}</div>
          <div class="derm-row-sub">${esc(sub)}</div>
        </div>
        <span class="derm-row-arrow">›</span>
      </div>`;
  }).join("");

  sidebarList.querySelectorAll(".derm-row").forEach(el => {
    el.addEventListener("click", () => selectDerm(parseInt(el.dataset.id)));
  });
}

function selectDerm(id) {
  selectedId = id;
  renderSidebar();

  const d = dermatologists.find(x => x.id === id);
  if (!d) return;

  detailEmpty.style.display   = "none";
  detailContent.style.display = "block";

  const name = fullName(d);

  document.getElementById("d-avatar").textContent = initFor(d);
  document.getElementById("d-name").textContent   = name;
  document.getElementById("d-email").textContent  = d.user?.email || "—";

  const pill = document.getElementById("d-status-pill");
  pill.textContent = d.verification_status || "pending";
  pill.className   = `status-pill ${d.verification_status || "pending"}`;

  set("d-username",       d.user?.username);
  set("d-specialization", d.specialization);
  set("d-inami",          d.inami_number);
  set("d-license",        d.license_number);
  set("d-city",           d.city);
  set("d-postal",         d.postal_code);
  set("d-bio",            d.bio);

  const certRow = document.getElementById("d-cert-row");
  const certEl  = document.getElementById("d-cert");
  if (d.certificate_url) {
    certEl.innerHTML = `<a class="cert-link" href="${esc(d.certificate_url)}" target="_blank" rel="noopener">View certificate ↗</a>`;
    certRow.style.display = "";
  } else {
    certRow.style.display = "none";
  }

  document.getElementById("riziv-hint-name").textContent  = name;
  document.getElementById("riziv-hint-inami").textContent = d.inami_number || "—";

  document.getElementById("notes-textarea").value = d.verification_notes || "";

  const approveBtn = document.getElementById("btn-approve");
  const rejectBtn  = document.getElementById("btn-reject");

  approveBtn.onclick = () => doVerify(d.id, "approved");
  rejectBtn.onclick  = () => doVerify(d.id, "rejected");

  const isDone = d.verification_status !== "pending";
  approveBtn.disabled = isDone;
  rejectBtn.disabled  = isDone;
}

async function doVerify(id, status) {
  const notes      = document.getElementById("notes-textarea").value.trim();
  const approveBtn = document.getElementById("btn-approve");
  const rejectBtn  = document.getElementById("btn-reject");

  approveBtn.disabled = true;
  rejectBtn.disabled  = true;

  if (status === "approved") approveBtn.textContent = "Approving…";
  else                       rejectBtn.textContent  = "Rejecting…";

  try {
    const res = await fetch(`${BASE}/dermatologists/${id}/verification`, {
      method: "PATCH",
      headers: {
        "Content-Type":  "application/json",
        "Authorization": `Bearer ${token}`,
      },
      body: JSON.stringify({
        verification_status: status,
        verification_notes:  notes || undefined,
      }),
    });

    const data = await res.json();

    if (!res.ok) {
      toast(data.message || "An error occurred.", "error");
      approveBtn.disabled = false;
      rejectBtn.disabled  = false;
      return;
    }

    toast(
      status === "approved"
        ? "✓ Dermatologist approved successfully."
        : "Dermatologist rejected.",
      status === "approved" ? "success" : "error"
    );

    dermatologists = dermatologists.filter(x => x.id !== id);
    selectedId = null;
    detailEmpty.style.display   = "flex";
    detailContent.style.display = "none";
    renderSidebar();

  } catch (err) {
    toast("Network error. Please try again.", "error");
    approveBtn.disabled = false;
    rejectBtn.disabled  = false;
  } finally {
    approveBtn.textContent = "✓ Approve";
    rejectBtn.textContent  = "✕ Reject";
  }
}

function fullName(d) {
  const parts = [d.first_name, d.last_name].filter(Boolean);
  return parts.length ? parts.join(" ") : (d.user?.username || `Dermatologist #${d.id}`);
}

function initFor(d) {
  const name = fullName(d);
  return name.split(" ").map(w => w[0]).join("").slice(0, 2).toUpperCase();
}

function set(elId, value) {
  const el = document.getElementById(elId);
  if (!el) return;
  if (value) {
    el.textContent = value;
    el.classList.remove("empty");
  } else {
    el.textContent = "—";
    el.classList.add("empty");
  }
}

function esc(str) {
  if (!str) return "";
  return str
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

let toastTimer;
function toast(msg, type = "success") {
  toastEl.textContent = msg;
  toastEl.className   = `toast ${type}`;
  clearTimeout(toastTimer);
  requestAnimationFrame(() => toastEl.classList.add("show"));
  toastTimer = setTimeout(() => toastEl.classList.remove("show"), 3500);
}

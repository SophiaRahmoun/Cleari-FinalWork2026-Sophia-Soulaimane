import { useEffect, useRef, useState } from "react";
import {
  getMyProfile,
  getCurrentUser,
  updateUsername,
  updatePassword,
  updateProfilePicture,
} from "../api/profile";
import { useAuth } from "../auth/AuthContext";
import "./EditProfile.css";

export default function EditProfile() {
  const { user, saveLogin } = useAuth();
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const [avatarPreview, setAvatarPreview] = useState(null);
  const [avatarFile, setAvatarFile] = useState(null);
  const [avatarMsg, setAvatarMsg] = useState("");
  const [savingAvatar, setSavingAvatar] = useState(false);
  const fileInputRef = useRef(null);

  const [username, setUsername] = useState("");
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");

  const [usernameMsg, setUsernameMsg] = useState("");
  const [passwordMsg, setPasswordMsg] = useState("");
  const [savingUsername, setSavingUsername] = useState(false);
  const [savingPassword, setSavingPassword] = useState(false);

  useEffect(() => {
    Promise.all([getMyProfile(), getCurrentUser()])
      .then(([dermProfile, userData]) => {
        const merged = { ...dermProfile, ...userData };
        setProfile(merged);
        setUsername(userData.username || "");
        setAvatarPreview(
          userData.profile_picture_url ||
          userData.profilePictureUrl ||
          null
        );
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  function handleAvatarChange(e) {
    const file = e.target.files?.[0];
    if (!file) return;
    setAvatarFile(file);
    setAvatarPreview(URL.createObjectURL(file));
  }

  async function handleAvatarSave() {
    if (!avatarFile) return;
    setSavingAvatar(true);
    setAvatarMsg("");
    try {
      const data = await updateProfilePicture(avatarFile);
      const newUrl =
        data.user?.profile_picture_url ||
        data.profile_picture_url ||
        data.profilePictureUrl ||
        avatarPreview;
      const token = localStorage.getItem("cleari_token");
      saveLogin(token, { ...user, profile_picture_url: newUrl });
      setAvatarMsg("Profile picture updated.");
      setAvatarFile(null);
    } catch (err) {
      setAvatarMsg(err.message || "Upload failed.");
    } finally {
      setSavingAvatar(false);
    }
  }

  async function handleUpdateUsername(e) {
    e.preventDefault();
    if (!username.trim()) return;
    setSavingUsername(true);
    setUsernameMsg("");
    try {
      await updateUsername(username.trim());
      const token = localStorage.getItem("cleari_token");
      saveLogin(token, { ...user, username: username.trim() });
      setUsernameMsg("Username updated successfully.");
    } catch (err) {
      setUsernameMsg(err.message || "Failed to update username.");
    } finally {
      setSavingUsername(false);
    }
  }

  async function handleUpdatePassword(e) {
    e.preventDefault();
    setPasswordMsg("");
    if (newPassword !== confirmPassword) {
      setPasswordMsg("New passwords do not match.");
      return;
    }
    if (newPassword.length < 6) {
      setPasswordMsg("Password must be at least 6 characters.");
      return;
    }
    setSavingPassword(true);
    try {
      await updatePassword(currentPassword, newPassword);
      setPasswordMsg("Password updated successfully.");
      setCurrentPassword("");
      setNewPassword("");
      setConfirmPassword("");
    } catch (err) {
      setPasswordMsg(err.message || "Failed to update password.");
    } finally {
      setSavingPassword(false);
    }
  }

  if (loading) return <div className="loading">Loading profile…</div>;

  return (
    <div className="profile-page">
      <div className="page-header">
        <h2 className="page-title">Edit Profile</h2>
        <p className="page-desc">Manage your dermatologist account</p>
      </div>

      <div className="profile-grid">
        <div className="profile-card info-card">
          <div
            className="profile-avatar-big-wrap"
            onClick={() => fileInputRef.current?.click()}
            title="Click to change photo"
          >
            {avatarPreview ? (
              <img
                src={avatarPreview}
                alt=""
                className="profile-avatar-big profile-avatar-big--img"
              />
            ) : (
              <div className="profile-avatar-big">
                {user?.username?.[0]?.toUpperCase() || "D"}
              </div>
            )}
            <span className="avatar-change-overlay">Change</span>
          </div>
          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            style={{ display: "none" }}
            onChange={handleAvatarChange}
          />
          {avatarFile && (
            <div className="avatar-save-row">
              <button
                className="form-save-btn form-save-btn--sm"
                onClick={handleAvatarSave}
                disabled={savingAvatar}
              >
                {savingAvatar ? "Uploading…" : "Save photo"}
              </button>
            </div>
          )}
          {avatarMsg && (
            <p className={"form-msg " + (avatarMsg.includes("updated") ? "form-msg--ok" : "form-msg--err")}>
              {avatarMsg}
            </p>
          )}
          <h3 className="info-name">{user?.username}</h3>
          <span className="info-role">Dermatologist</span>
          <div className="info-rows">
            <div className="info-row">
              <span className="info-label">Email</span>
              <span className="info-value">{profile?.email || user?.email || "—"}</span>
            </div>
            {profile?.specialization && (
              <div className="info-row">
                <span className="info-label">Specialization</span>
                <span className="info-value">{profile.specialization}</span>
              </div>
            )}
            {profile?.inami && (
              <div className="info-row">
                <span className="info-label">INAMI</span>
                <span className="info-value">{profile.inami}</span>
              </div>
            )}
            {profile?.verificationStatus && (
              <div className="info-row">
                <span className="info-label">Status</span>
                <span
                  className="info-badge"
                  data-status={profile.verificationStatus}
                >
                  {profile.verificationStatus}
                </span>
              </div>
            )}
          </div>
        </div>

        <div className="profile-forms">
          <div className="form-card">
            <h4 className="form-card-title">Change Username</h4>
            <form onSubmit={handleUpdateUsername}>
              <div className="form-group">
                <label>New username</label>
                <input
                  type="text"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  required
                />
              </div>
              {usernameMsg && (
                <div
                  className={
                    "form-msg " +
                    (usernameMsg.includes("success") ? "form-msg--ok" : "form-msg--err")
                  }
                >
                  {usernameMsg}
                </div>
              )}
              <button type="submit" className="form-save-btn" disabled={savingUsername}>
                {savingUsername ? "Saving…" : "Save username"}
              </button>
            </form>
          </div>

          <div className="form-card">
            <h4 className="form-card-title">Change Password</h4>
            <form onSubmit={handleUpdatePassword}>
              <div className="form-group">
                <label>Current password</label>
                <input
                  type="password"
                  value={currentPassword}
                  onChange={(e) => setCurrentPassword(e.target.value)}
                  required
                />
              </div>
              <div className="form-group">
                <label>New password</label>
                <input
                  type="password"
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  required
                />
              </div>
              <div className="form-group">
                <label>Confirm new password</label>
                <input
                  type="password"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  required
                />
              </div>
              {passwordMsg && (
                <div
                  className={
                    "form-msg " +
                    (passwordMsg.includes("success") ? "form-msg--ok" : "form-msg--err")
                  }
                >
                  {passwordMsg}
                </div>
              )}
              <button type="submit" className="form-save-btn" disabled={savingPassword}>
                {savingPassword ? "Saving…" : "Save password"}
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
}

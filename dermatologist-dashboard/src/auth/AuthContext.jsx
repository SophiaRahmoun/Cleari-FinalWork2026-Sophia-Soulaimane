import { createContext, useContext, useState, useEffect } from "react";
import { getMe } from "../api/auth";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(() => {
    try {
      const stored = localStorage.getItem("cleari_user");
      return stored ? JSON.parse(stored) : null;
    } catch {
      return null;
    }
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const token = localStorage.getItem("cleari_token");
    if (!token) {
      setLoading(false);
      return;
    }
    getMe()
      .then((data) => {
        const u = data.user || data;
        if (u.role !== "dermatologist") {
          logout();
        } else {
          setUser(u);
          localStorage.setItem("cleari_user", JSON.stringify(u));
        }
      })
      .catch(() => logout())
      .finally(() => setLoading(false));
  }, []);

  function saveLogin(token, userData) {
    localStorage.setItem("cleari_token", token);
    localStorage.setItem("cleari_user", JSON.stringify(userData));
    setUser(userData);
  }

  function logout() {
    localStorage.removeItem("cleari_token");
    localStorage.removeItem("cleari_user");
    setUser(null);
  }

  return (
    <AuthContext.Provider value={{ user, loading, saveLogin, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}

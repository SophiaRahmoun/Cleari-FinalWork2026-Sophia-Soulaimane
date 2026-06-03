import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider } from "./auth/AuthContext";
import ProtectedRoute from "./auth/ProtectedRoute";
import DashboardLayout from "./layouts/DashboardLayout";
import Login from "./pages/Login";
import Community from "./pages/Community";
import Appointments from "./pages/Appointments";
import Chat from "./pages/Chat";
import EditProfile from "./pages/EditProfile";
import FakeTrends from "./pages/FakeTrends";
import Earnings from "./pages/Earnings";

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route
            path="/*"
            element={
              <ProtectedRoute>
                <DashboardLayout>
                  <Routes>
                    <Route path="/" element={<Navigate to="/appointments" replace />} />
                    <Route path="/community" element={<Community />} />
                    <Route path="/appointments" element={<Appointments />} />
                    <Route path="/chat" element={<Chat />} />
                    <Route path="/fake-trends" element={<FakeTrends />} />
                    <Route path="/earnings" element={<Earnings />} />
                    <Route path="/profile" element={<EditProfile />} />
                  </Routes>
                </DashboardLayout>
              </ProtectedRoute>
            }
          />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

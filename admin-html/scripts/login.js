const baseUrl = "https://mobile-vehicle-rental-app.onrender.com";
// const baseUrl = "http://localhost:5000";

document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("loginForm");
    const errorEl = document.getElementById("error");
  
    form.addEventListener("submit", async (event) => {
      event.preventDefault();
  
      const email = document.getElementById("email").value;
      const password = document.getElementById("password").value;
  
      try {
        const response = await fetch(`${baseUrl}/api/auth/web-login`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json"
          },
          credentials: "include", // gửi và nhận cookie
          body: JSON.stringify({ email, password })
        });
  
        const data = await response.json();
  
        if (!response.ok) {
          errorEl.textContent = data.message || "Đăng nhập thất bại.";
          return;
        }
  
        // Đăng nhập thành công
        window.location.href = "dashboard.html";
      } catch (error) {
        console.error("Lỗi kết nối:", error);
        errorEl.textContent = "Không thể kết nối đến máy chủ.";
      }
    });
  });
  
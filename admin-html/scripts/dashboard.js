const API_BASE = "http://localhost:5000/api";

const errorEl = document.getElementById("error");

async function callApi(endpoint, method = "GET", body = null) {
  try {
    const options = {
      method,
      credentials: "include",
      headers: body ? { "Content-Type": "application/json" } : {},
      body: body ? JSON.stringify(body) : null,
    };
    let res = await fetch(`${API_BASE}${endpoint}`, options);

    if (res.status === 401) {
      const refresh = await fetch(`${API_BASE}/auth/refresh-web-token`, {
        method: "POST",
        credentials: "include",
      });

      if (!refresh.ok) {
        window.location.href = "/login.html";
        throw new Error("Token hết hạn. Vui lòng đăng nhập lại.");
      }

      res = await fetch(`${API_BASE}${endpoint}`, options);
    }

    if (!res.ok) {
      const err = await res.json();
      throw new Error(err.message || "Lỗi không xác định.");
    }

    return await res.json();
  } catch (err) {
    if (errorEl) {
      errorEl.textContent = err.message;
      errorEl.classList.remove("hidden");
    }
    return null;
  }
}

async function fetchStats() {
  const totalUsersData = await callApi("/admin/get-total-users");
  const totalBookingsData = await callApi("/admin/get-monthly-bookings");
  const totalUsersEl = document.getElementById("totalUsers");
  const totalBookingsEl = document.getElementById("totalBookings");

  if (totalUsersData && totalUsersEl) {
    totalUsersEl.textContent = totalUsersData.totalUsers || 0;
  }
  if (totalBookingsData && totalBookingsEl) {
    totalBookingsEl.textContent = totalBookingsData.totalBookings || 0;
  }
}

async function getAllUsers() {
  const data = await callApi("/admin/get-all-user");
  const list = document.getElementById("userList");
  if (!list) return;

  list.innerHTML = "";
  if (data && data.users) {
    data.users.forEach(u => {
      const tr = document.createElement("tr");
      tr.className = "border-b border-gray-200 hover:bg-gray-100";
      tr.innerHTML = `
        <td class="py-3 px-6">${u.email}</td>
        <td class="py-3 px-6">${u.fullName}</td>
        <td class="py-3 px-6">${u.role}</td>
        <td class="py-3 px-6">${u.verified ? "Đã xác minh" : "Chưa xác minh"}</td>
        <td class="py-3 px-6">
          <button onclick="deleteUser('${u.userId}')" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Xóa</button>
        </td>
      `;
      list.appendChild(tr);
    });
  }
}

async function deleteUser(userId) {
  if (confirm("Bạn có chắc muốn xóa người dùng này?")) {
    const data = await callApi("/admin/delete-account", "DELETE", { userId });
    if (data) {
      alert("Xóa người dùng thành công!");
      getAllUsers();
    }
  }
}

async function getPendingUsers() {
  const data = await callApi("/admin/get-users-with-unapproved-licenses");
  const list = document.getElementById("pendingList");
  if (!list) return;

  list.innerHTML = "";
  if (data && data.users) {
    data.users.forEach(u => {
      const tr = document.createElement("tr");
      tr.className = "border-b border-gray-200 hover:bg-gray-100";
      tr.innerHTML = `
        <td class="py-3 px-6">${u.email}</td>
        <td class="py-3 px-6">${u.fullName}</td>
        <td class="py-3 px-6">
          <img src="${u.avatar}" alt="Avatar" class="w-12 h-12 rounded-full object-cover" />
        </td>
        <td class="py-3 px-6">${u.license[0]?.status === "pending" ? "Chưa duyệt" : u.license[0]?.status}</td>
        <td class="py-3 px-6 flex space-x-2">
          <button onclick="approveLicense('${u.license[0]?._id}')" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600">Duyệt</button>
          <button onclick="rejectLicense('${u.license[0]?._id}')" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Từ chối</button>
        </td>
      `;
      list.appendChild(tr);
    });
  }
}

async function approveLicense(licenseId) {
  const data = await callApi("/admin/approve-license", "POST", { licenseId });
  if (data) {
    alert("Duyệt giấy phép thành công!");
    getPendingUsers();
  }
}

async function rejectLicense(licenseId) {
  if (confirm("Bạn có chắc muốn từ chối giấy phép này?")) {
    const data = await callApi("/admin/reject-license", "POST", { licenseId });
    if (data) {
      alert("Từ chối giấy phép thành công!");
      getPendingUsers();
    }
  }
}

async function getPendingVehicles() {
  const data = await callApi("/admin/pending");
  const list = document.getElementById("vehicleList");
  if (!list) return;

  list.innerHTML = "";
  if (data && data.vehicles) {
    data.vehicles.forEach(v => {
      const tr = document.createElement("tr");
      tr.className = "border-b border-gray-200 hover:bg-gray-100";
      tr.innerHTML = `
        <td class="py-3 px-6">${v.vehicleName}</td>
        <td class="py-3 px-6">${v.licensePlate}</td>
        <td class="py-3 px-6">${v.brand}</td>
        <td class="py-3 px-6">${v.price.toLocaleString()} VND</td>
        <td class="py-3 px-6">
          ${v.images && v.images.length ? `<img src="${v.images[0]}" alt="Vehicle" class="w-12 h-12 object-cover rounded" />` : "Không có ảnh"}
        </td>
        <td class="py-3 px-6">${v.status}</td>
        <td class="py-3 px-6 flex space-x-2">
          <button onclick="approveVehicle('${v.vehicleId}')" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600">Duyệt</button>
          <button onclick="rejectVehicle('${v.vehicleId}')" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Từ chối</button>
        </td>
      `;
      list.appendChild(tr);
    });
  }
}

async function approveVehicle(vehicleId) {
  const data = await callApi(`/admin/status/${vehicleId}`, "PUT", { status: "approved" });
  if (data) {
    alert("Duyệt xe thành công!");
    getPendingVehicles();
  }
}

async function rejectVehicle(vehicleId) {
  if (confirm("Bạn có chắc muốn từ chối xe này?")) {
    const data = await callApi(`/admin/status/${vehicleId}`, "PUT", { status: "rejected" });
    if (data) {
      alert("Từ chối xe thành công!");
      getPendingVehicles();
    }
  }
}

async function getAllBrands() {
  const data = await callApi("/admin/get-all-banner");
  const list = document.getElementById("brandList");
  if (!list) return;

  list.innerHTML = "";
  if (data && data.brands) {
    data.brands.forEach(b => {
      const tr = document.createElement("tr");
      tr.className = "border-b border-gray-200 hover:bg-gray-100";
      tr.innerHTML = `
        <td class="py-3 px-6">${b.name}</td>
        <td class="py-3 px-6 flex space-x-2">
          <button onclick="editBrand('${b.id}', '${b.name}')" class="bg-yellow-500 text-white px-2 py-1 rounded hover:bg-yellow-600">Sửa</button>
          <button onclick="deleteBrand('${b.id}')" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Xóa</button>
        </td>
      `;
      list.appendChild(tr);
    });
  }
}

async function createOrUpdateBrand() {
  const brandName = document.getElementById("brandName").value;
  const brandId = document.getElementById("brandId").value;

  if (!brandName) {
    alert("Vui lòng nhập tên thương hiệu!");
    return;
  }

  let data;
  if (brandId) {
    data = await callApi(`/admin/update-brand/${brandId}`, "PUT", { name: brandName });
  } else {
    data = await callApi("/admin/create-brand", "POST", { name: brandName });
  }

  if (data) {
    alert(brandId ? "Cập nhật thương hiệu thành công!" : "Tạo thương hiệu thành công!");
    document.getElementById("brandName").value = "";
    document.getElementById("brandId").value = "";
    getAllBrands();
  }
}

async function editBrand(id, name) {
  document.getElementById("brandName").value = name;
  document.getElementById("brandId").value = id;
}

async function deleteBrand(id) {
  if (confirm("Bạn có chắc muốn xóa thương hiệu này?")) {
    const data = await callApi(`/admin/delete-brand/${id}`, "DELETE");
    if (data) {
      alert("Xóa thương hiệu thành công!");
      getAllBrands();
    }
  }
}

async function getAllReviews() {
  const data = await callApi("/admin/all-reviews");
  const list = document.getElementById("reviewList");
  if (!list) return;

  list.innerHTML = "";
  if (data && data.reviews) {
    data.reviews.forEach(r => {
      const tr = document.createElement("tr");
      tr.className = "border-b border-gray-200 hover:bg-gray-100";
      tr.innerHTML = `
        <td class="py-3 px-6">${r.content}</td>
        <td class="py-3 px-6">${r.rating}</td>
        <td class="py-3 px-6">
          <button onclick="deleteReview('${r.id}')" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Xóa</button>
        </td>
      `;
      list.appendChild(tr);
    });
  }
}

async function deleteReview(id) {
  if (confirm("Bạn có chắc muốn xóa đánh giá này?")) {
    const data = await callApi(`/admin/delete-review/${id}`, "DELETE");
    if (data) {
      alert("Xóa đánh giá thành công!");
      getAllReviews();
    }
  }
}

// Auto-fetch data based on current page
document.addEventListener("DOMContentLoaded", () => {
  if (document.getElementById("totalUsers") || document.getElementById("totalBookings")) {
    fetchStats();
  } else if (document.getElementById("userList") || document.getElementById("pendingList")) {
    getAllUsers();
    getPendingUsers();
  } else if (document.getElementById("vehicleList")) {
    getPendingVehicles();
  } else if (document.getElementById("brandList")) {
    getAllBrands();
  } else if (document.getElementById("reviewList")) {
    getAllReviews();
  }
});
const API_BASE = "http://localhost:5000/api";

const DOM = {
  error: document.getElementById("error"),
  totalUsers: document.getElementById("totalUsers"),
  totalBookings: document.getElementById("totalBookings"),
  userList: document.getElementById("userList"),
  pendingList: document.getElementById("pendingList"),
  vehicleList: document.getElementById("vehicleList"),
  brandList: document.getElementById("brandList"),
  reportList: document.getElementById("reportList"),
  brandForm: document.getElementById("brandForm"),
  brandId: document.getElementById("brandId"),
  brandName: document.getElementById("brandName"),
  brandLogo: document.getElementById("brandLogo"),
  previewLogo: document.getElementById("previewLogo"),
  imageModal: document.getElementById("imageModal"),
  imageModalContent: document.getElementById("imageModalContent"),
  licenseImageModal: document.getElementById("licenseImageModal"),
  licenseImageModalContent: document.getElementById("licenseImageModalContent"),
};

// Utility function for API calls with token refresh
async function callApi(endpoint, method = "GET", body = null) {
  try {
    const options = {
      method,
      credentials: "include",
      headers: body && !(body instanceof FormData) ? { "Content-Type": "application/json" } : {},
      body: body instanceof FormData ? body : body ? JSON.stringify(body) : null,
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
    if (DOM.error) {
      DOM.error.textContent = err.message;
      DOM.error.classList.remove("hidden");
    }
    return null;
  }
}

// Display images in modal
function openImageModal(images, modalId = "imageModal", contentId = "imageModalContent") {
  const container = DOM[contentId];
  container.innerHTML = images
    .map(img => `<img src="${img}" alt="Ảnh" class="w-full h-auto object-contain rounded border" />`)
    .join("");
  DOM[modalId].classList.remove("hidden");
}

function closeImageModal(modalId = "imageModal") {
  DOM[modalId].classList.add("hidden");
}

// Stats fetching
async function fetchStats() {
  const [totalUsersData, totalBookingsData] = await Promise.all([
    callApi("/admin/get-total-users"),
    callApi("/admin/get-monthly-bookings"),
  ]);

  if (totalUsersData && DOM.totalUsers) {
    DOM.totalUsers.textContent = totalUsersData.totalUsers || 0;
  }
  if (totalBookingsData && DOM.totalBookings) {
    DOM.totalBookings.textContent = totalBookingsData.totalBookings || 0;
  }
}

// User management
async function getAllUsers() {
  if (!DOM.userList) return;
  DOM.userList.innerHTML = "";

  const data = await callApi("/admin/get-all-user");
  if (data?.users) {
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
      DOM.userList.appendChild(tr);
    });
  }
}

async function deleteUser(userId) {
  if (!confirm("Bạn có chắc muốn xóa người dùng này?")) return;
  const data = await callApi("/admin/delete-account", "DELETE", { userId });
  if (data) {
    alert("Xóa người dùng thành công!");
    await getAllUsers();
  }
}

// License management
async function getPendingUsers() {
  if (!DOM.pendingList) return;
  DOM.pendingList.innerHTML = "";

  const data = await callApi("/admin/get-users-with-unapproved-licenses");
  if (data?.users) {
    data.users.forEach(u => {
      u.license.forEach(lic => {
        const frontImage = lic.driverLicenseFront
          ? `<img src="${lic.driverLicenseFront}" class="w-16 h-10 object-cover border rounded cursor-pointer" onclick="openImageModal(['${lic.driverLicenseFront}', '${lic.driverLicenseBack || ''}'], 'licenseImageModal', 'licenseImageModalContent')" />`
          : `<div class="w-16 h-10 flex items-center justify-center border rounded bg-gray-100 text-xs text-gray-500">Không có ảnh</div>`;

        const backImage = lic.driverLicenseBack
          ? `<img src="${lic.driverLicenseBack}" class="w-16 h-10 object-cover border rounded cursor-pointer" onclick="openImageModal(['${lic.driverLicenseFront || ''}', '${lic.driverLicenseBack}'], 'licenseImageModal', 'licenseImageModalContent')" />`
          : `<div class="w-16 h-10 flex items-center justify-center border rounded bg-gray-100 text-xs text-gray-500">Không có ảnh</div>`;

        const tr = document.createElement("tr");
        tr.className = "border-b border-gray-200 hover:bg-gray-100";
        tr.innerHTML = `
          <td class="py-3 px-6">${u.email}</td>
          <td class="py-3 px-6">${u.fullName}</td>
          <td class="py-3 px-6"><div class="flex space-x-2 mt-2">${frontImage}${backImage}</div></td>
          <td class="py-3 px-6">${lic.status === "pending" ? "Chưa duyệt" : lic.status}</td>
          <td class="py-3 px-6 flex space-x-2">
            <button onclick="approveLicense('${u._id}', '${lic._id}')" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600">Duyệt</button>
            <button onclick="rejectLicense('${u._id}', '${lic._id}')" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Từ chối</button>
          </td>
        `;
        DOM.pendingList.appendChild(tr);
      });
    });
  }
}

async function approveLicense(userId, licenseId) {
  const data = await callApi("/admin/approve-license", "POST", { userId, licenseId });
  if (data) {
    alert("Duyệt giấy phép thành công!");
    await getPendingUsers();
  }
}

async function rejectLicense(userId, licenseId) {
  if (!confirm("Bạn có chắc muốn từ chối giấy phép này?")) return;
  const data = await callApi("/admin/reject-license", "POST", { userId, licenseId });
  if (data) {
    alert("Từ chối giấy phép thành công!");
    await getPendingUsers();
  }
}

// Vehicle management
async function getPendingVehicles() {
  if (!DOM.vehicleList) return;
  DOM.vehicleList.innerHTML = "";

  const data = await callApi("/admin/pending");
  if (data?.vehicles) {
    data.vehicles.forEach(v => {
      const tr = document.createElement("tr");
      tr.className = "border-b hover:bg-gray-100";
      tr.innerHTML = `
        <td class="py-3 px-6">${v.vehicleName}</td>
        <td class="py-3 px-6">${v.licensePlate}</td>
        <td class="py-3 px-6">${v.brand}</td>
        <td class="py-3 px-6">${v.price.toLocaleString()} VND</td>
        <td class="py-3 px-6">
          ${v.images?.length
            ? `<button onclick="openImageModal(${JSON.stringify(v.images)})" class="text-blue-600 underline hover:text-blue-800">Xem ${v.images.length} ảnh</button>`
            : "Không có ảnh"}
        </td>
        <td class="py-3 px-6">${v.status}</td>
        <td class="py-3 px-6 flex gap-2">
          <button onclick="approveVehicle('${v.vehicleId}')" class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600">Duyệt</button>
          <button onclick="rejectVehicle('${v.vehicleId}')" class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600">Từ chối</button>
        </td>
      `;
      DOM.vehicleList.appendChild(tr);
    });
  }
}

async function approveVehicle(vehicleId) {
  const data = await callApi(`/admin/status/${vehicleId}`, "PUT", { status: "approved" });
  if (data) {
    alert("Duyệt xe thành công!");
    await getPendingVehicles();
  }
}

async function rejectVehicle(vehicleId) {
  if (!confirm("Bạn có chắc muốn từ chối xe này?")) return;
  const data = await callApi(`/admin/status/${vehicleId}`, "PUT", { status: "rejected" });
  if (data) {
    alert("Từ chối xe thành công!");
    await getPendingVehicles();
  }
}

// Brand management
async function getAllBrands() {
  if (!DOM.brandList) return;
  DOM.brandList.innerHTML = "";

  const res = await callApi("/admin/get-all-brands");
  if (res?.data) {
    res.data.forEach(b => {
      const tr = document.createElement("tr");
      tr.className = "border-b border-gray-200 hover:bg-gray-100";
      tr.innerHTML = `
        <td class="py-3 px-6"><img src="${b.brandLogo?.url || ''}" class="w-12 h-12 object-contain" alt="Brand Logo"/></td>
        <td class="py-3 px-6">${b.brandName}</td>
        <td class="py-3 px-6 flex space-x-2">
          <button onclick="editBrand('${b._id}', '${b.brandName}', '${b.brandLogo?.url || ''}')" class="bg-yellow-500 text-white px-2 py-1 rounded hover:bg-yellow-600">Sửa</button>
          <button onclick="deleteBrand('${b._id}')" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Xóa</button>
        </td>
      `;
      DOM.brandList.appendChild(tr);
    });
  }
}

function editBrand(id, name, logoUrl) {
  DOM.brandId.value = id;
  DOM.brandName.value = name;
  DOM.previewLogo.src = logoUrl;
  DOM.previewLogo.classList.remove("hidden");
}

async function deleteBrand(id) {
  if (!confirm("Bạn có chắc muốn xóa thương hiệu này?")) return;
  const res = await callApi(`/admin/delete-brand/${id}`, "DELETE");
  if (res?.success) {
    alert("Xóa thành công!");
    await getAllBrands();
  }
}

// Review management
async function getReviewReports() {
  if (!DOM.reportList) return;
  DOM.reportList.innerHTML = "";

  const res = await callApi("/admin/get-review-reports");
  if (res?.success && res.reports) {
    res.reports.forEach(r => {
      const tr = document.createElement("tr");
      tr.className = "border-b border-gray-200 hover:bg-gray-100";
      tr.innerHTML = `
        <td class="px-6 py-3">${r.vehicleId?.name || "N/A"}</td>
        <td class="px-6 py-3">${r.reviewId?.comment || "Không có"}</td>
        <td class="px-6 py-3">${r.reviewId?.renterId || "Ẩn"}</td>
        <td class="px-6 py-3">${r.ownerId?.fullName || "Ẩn"}</td>
        <td class="px-6 py-3">${r.reason}</td>
        <td class="px-6 py-3">
          <button onclick="deleteReview('${r.reviewId?._id}')" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Xóa</button>
        </td>
      `;
      DOM.reportList.appendChild(tr);
    });
  }
}

async function deleteReview(id) {
  if (!confirm("Bạn có chắc muốn xóa đánh giá này?")) return;
  const data = await callApi(`/admin/delete-review/${id}`, "DELETE");
  if (data) {
    alert("Xóa đánh giá thành công!");
    await getReviewReports();
  }
}

// Initialize form and event listeners
function initializeForm() {
  if (DOM.brandLogo && DOM.previewLogo) {
    DOM.brandLogo.addEventListener("change", (e) => {
      const file = e.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = () => {
          DOM.previewLogo.src = reader.result;
          DOM.previewLogo.classList.remove("hidden");
        };
        reader.readAsDataURL(file);
      }
    });
  }

  if (DOM.brandForm) {
    DOM.brandForm.addEventListener("submit", async (e) => {
      e.preventDefault();
      const brandId = DOM.brandId?.value;
      const brandName = DOM.brandName?.value;
      const logoFile = DOM.brandLogo?.files?.[0];

      if (!brandName) {
        alert("Vui lòng nhập tên thương hiệu!");
        return;
      }

      const formData = new FormData();
      formData.append("brandName", brandName);
      if (logoFile) formData.append("logo", logoFile);

      const res = await fetch(`${API_BASE}${brandId ? `/admin/update-brand/${brandId}` : "/admin/create-brand"}`, {
        method: brandId ? "PUT" : "POST",
        body: formData,
      }).then(r => r.json());

      if (res.success) {
        alert(brandId ? "Cập nhật thành công!" : "Tạo thương hiệu thành công!");
        DOM.brandForm.reset();
        DOM.previewLogo?.classList.add("hidden");
        await getAllBrands();
      } else {
        alert(res.message || "Có lỗi xảy ra.");
      }
    });
  }
}

// Initialize app
document.addEventListener("DOMContentLoaded", () => {
  initializeForm();
  if (DOM.totalUsers || DOM.totalBookings) fetchStats();
  if (DOM.userList) getAllUsers();
  if (DOM.pendingList) getPendingUsers();
  if (DOM.vehicleList) getPendingVehicles();
  if (DOM.brandList) getAllBrands();
  if (DOM.reportList) getReviewReports();
});

// Expose functions to global scope for inline event handlers
window.deleteUser = deleteUser;
window.approveLicense = approveLicense;
window.rejectLicense = rejectLicense;
window.approveVehicle = approveVehicle;
window.rejectVehicle = rejectVehicle;
window.editBrand = editBrand;
window.deleteBrand = deleteBrand;
window.deleteReview = deleteReview;
window.openImageModal = openImageModal;
window.closeImageModal = closeImageModal;
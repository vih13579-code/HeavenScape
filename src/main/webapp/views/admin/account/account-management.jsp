<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="UTF-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Account Management - HeavenScape</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">

        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "primary": "#004d99",
                            "secondary": "#705d00",
                            "success": "#2E7D32",
                            "error": "#D32F2F",
                            "warning": "#FFA000",
                            "background": "#f3faff",
                            "background-alt": "#F5F7F9",
                            "surface": "#FFFFFF",
                            "on-surface": "#071e27",
                            "on-surface-variant": "#424752",
                            "outline": "#727783",
                            "outline-variant": "#c2c6d4",
                            "surface-container-low": "#e6f6ff",
                            "surface-container": "#dbf1fe",
                            "surface-container-high": "#d5ecf8",
                            "primary-fixed": "#d6e3ff",
                            "secondary-container": "#fdd835",
                            "error-container": "#ffdad6"
                        }
                    }
                }
            }
        </script>

        <style>
            body {
                font-family: 'Inter', sans-serif;
            }
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                vertical-align: middle;
            }
            .custom-scrollbar::-webkit-scrollbar {
                width: 6px;
            }
            .custom-scrollbar::-webkit-scrollbar-track {
                background: transparent;
            }
            .custom-scrollbar::-webkit-scrollbar-thumb {
                background: #cbd5e1;
                border-radius: 10px;
            }
            .status-badge-active  {
                background: #E8F5E9;
                color: #2E7D32;
            }
            .status-badge-inactive {
                background: #FFEBEE;
                color: #D32F2F;
            }
            .role-badge-admin    {
                background: #FCE4EC;
                color: #D32F2F;
            }
            .role-badge-staff    {
                background: #E3F2FD;
                color: #004d99;
            }
            .role-badge-customer {
                background: #FFF3E0;
                color: #E65100;
            }
            .table-hover:hover   {
                background-color: #f5f9ff;
            }
            .modal-hidden  {
                display: none;
            }
            .modal-visible {
                display: flex;
            }
        </style>
    </head>

    <body class="bg-background text-on-surface flex min-h-screen">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen flex flex-col">
            <header class="bg-white border-b h-14 sticky top-0 z-30 flex items-center px-6"
                    style="border-color:#c2c6d4;">
                <h2 class="font-semibold text-base">
                    Account Management
                </h2>
            </header>
            <div class="p-6 md:p-8 ">
                <div class="flex flex-col md:flex-row justify-end items-end gap-4 mb-6">
                    <c:if test="${sessionScope.account.role == 'admin'}">
                        <a href="${pageContext.request.contextPath}/dashboard/add-staff"
                           class="bg-primary text-white px-6 py-3 rounded-xl inline-flex items-center gap-2 hover:opacity-90 transition">
                            <span class="material-symbols-outlined">person_add</span>
                            Add Staff Account
                        </a>
                    </c:if>
                </div>

                <div class="bg-surface rounded-xl shadow-sm border border-outline-variant/30 overflow-hidden">
                    <div class="p-6 border-b border-outline-variant/30">
                        <h3 class="text-xl font-bold mb-4">Account List</h3>
                        <c:set var="loginUser" value="${sessionScope.account}" />

                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <div class="md:col-span-2 relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant">search</span>
                                <input type="text" id="searchInput"
                                       placeholder="Search by name or email..."
                                       value="${keyword}"
                                       class="w-full pl-11 pr-4 py-3 border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary outline-none transition">
                            </div>

                            <c:if test="${loginUser.role == 'admin'}">
                                <select id="roleFilter" class="px-4 py-3 border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary outline-none">
                                    <option value=""         ${role == ''         ? 'selected' : ''}>All Roles</option>
                                    <option value="customer" ${role == 'customer' ? 'selected' : ''}>Customer</option>
                                    <option value="staff" ${role == 'staff' ? 'selected' : ''}>Staff</option>
                                    <option value="admin" ${role == 'admin' ? 'selected' : ''}>Admin</option>
                                </select>
                            </c:if>

                            <select id="statusFilter" class="px-4 py-3 border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary outline-none">
                                <option value=""         ${status == ''         ? 'selected' : ''}>All Statuses</option>
                                <option value="active"   ${status == 'active'   ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Locked</option>
                            </select>
                        </div>
                    </div>

                    <div class="overflow-x-auto custom-scrollbar">
                        <table class="w-full text-left border-collapse text-sm">
                            <thead>
                                <tr class="bg-background-alt border-b border-outline-variant/30">
                                    <th class="px-6 py-4 font-semibold text-on-surface">Account</th>
                                    <th class="px-6 py-4 font-semibold text-on-surface">Role</th>
                                    <th class="px-6 py-4 font-semibold text-on-surface">Status</th>
                                    <th class="px-6 py-4 font-semibold text-on-surface text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="accountTableBody" class="divide-y divide-outline-variant/20">
                                <c:forEach items="${customers}" var="c">
                                    <tr class="table-hover"
                                        data-account-id="${c.customerID}"
                                        data-type="customer"
                                        data-role="customer"
                                        data-status="${c.status}">
                                        <td class="px-6 py-4">
                                            <div class="font-semibold">${c.fullname}</div>
                                            <div class="text-xs text-on-surface-variant">${c.email}</div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <span class="role-badge-customer px-3 py-1 rounded-full text-xs font-bold">Customer</span>
                                        </td>
                                        <td class="px-6 py-4">
                                            <span class="status-badge ${c.status == 'active' ? 'status-badge-active' : 'status-badge-inactive'} px-3 py-1 rounded-full text-xs font-bold">
                                                ${c.status == 'active' ? 'Active' : 'Locked'}
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 text-right">
                                            <div class="flex justify-end gap-2">
                                                <button type="button" class="edit-btn text-primary hover:text-primary/80 p-2 rounded hover:bg-surface-container transition"
                                                        data-id="${c.customerID}" data-type="customer"
                                                        data-fullname="${c.fullname}" data-phone="${c.phone}"
                                                        data-status="${c.status}" data-email="${c.email}"
                                                        title="Update Information">
                                                    <span class="material-symbols-outlined text-sm">edit</span>
                                                </button>
                                                <button class="toggle-status-btn text-warning hover:text-warning/80 p-2 rounded hover:bg-surface-container transition"
                                                        data-account-id="${c.customerID}" data-role="customer" data-current-status="${c.status}"
                                                        title="${c.status == 'active' ? 'Lock Account' : 'Unlock Account'}">
                                                    <span class="material-symbols-outlined text-sm">${c.status == 'active' ? 'lock' : 'lock_open'}</span>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${not empty staffs}">
                                    <c:forEach items="${staffs}" var="s">
                                        <tr class="table-hover"
                                            data-account-id="${s.id}"
                                            data-type="staff"
                                            data-role="${s.role == 'admin' ? 'admin' : 'staff'}"
                                            data-status="${s.status}">
                                            <td class="px-6 py-4">
                                                <div class="font-semibold">${s.fullname}</div>
                                                <div class="text-xs text-on-surface-variant">${s.email}</div>
                                            </td>
                                            <td class="px-6 py-4">
                                                <c:choose>
                                                    <c:when test="${s.role == 'admin'}">
                                                        <span class="role-badge-admin px-3 py-1 rounded-full text-xs font-bold">Admin</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="role-badge-staff px-3 py-1 rounded-full text-xs font-bold">Staff</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4">
                                                <span class="status-badge ${s.status == 'active' ? 'status-badge-active' : 'status-badge-inactive'} px-3 py-1 rounded-full text-xs font-bold">
                                                    ${s.status == 'active' ? 'Active' : 'Locked'}
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 text-right">
                                                <div class="flex justify-end gap-2">
                                                    <button type="button" class="edit-btn text-primary hover:text-primary/80 p-2 rounded hover:bg-surface-container transition"
                                                            data-id="${s.id}" data-type="staff"
                                                            data-fullname="${s.fullname}" data-phone="${s.phone}"
                                                            data-status="${s.status}" data-role-value="${s.role}" data-email="${s.email}"
                                                            title="Update Information">
                                                        <span class="material-symbols-outlined text-sm">edit</span>
                                                    </button>
                                                    <c:if test="${s.role ne 'admin'}">
                                                        <button class="toggle-status-btn text-warning hover:text-warning/80 p-2 rounded hover:bg-surface-container transition"
                                                                data-account-id="${s.id}" data-role="staff" data-current-status="${s.status}"
                                                                title="${s.status == 'active' ? 'Lock Account' : 'Unlock Account'}">
                                                            <span class="material-symbols-outlined text-sm">${s.status == 'active' ? 'lock' : 'lock_open'}</span>
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>

                            </tbody>
                        </table>
                    </div>

                    <c:if test="${empty customers and empty staffs}">
                        <div class="p-8 text-center">
                            <span class="material-symbols-outlined text-5xl text-on-surface-variant mb-2">person_off</span>
                            <p class="text-on-surface-variant mt-2">No accounts found</p>
                        </div>
                    </c:if>

                    <%@ include file="/views/layout/common/pagination.jsp" %>
                </div>
            </div>
            <%@ include file="/views/layout/dashboard/footer.jsp" %>

        </main>

        <div id="confirmModal" class="modal-hidden fixed inset-0 bg-black/50 z-50 items-center justify-center">
            <div class="bg-surface rounded-xl shadow-lg p-6 w-96 max-w-[90vw]">
                <div class="flex items-center gap-3 mb-4">
                    <span class="material-symbols-outlined text-4xl text-warning">warning</span>
                    <h3 class="text-xl font-bold" id="modalTitle">Confirm</h3>
                </div>
                <p class="text-on-surface-variant mb-6" id="modalMessage">Are you sure you want to perform this action?</p>
                <div class="flex gap-3 justify-end">
                    <button id="modalCancel" class="px-6 py-2 border border-outline-variant text-on-surface rounded-lg hover:bg-background-alt transition">Cancel</button>
                    <button id="modalConfirm" class="px-6 py-2 bg-error text-white rounded-lg hover:opacity-90 transition">Confirm</button>
                </div>
            </div>
        </div>

        <div id="updateModal" class="modal-hidden fixed inset-0 bg-black/50 z-50 items-center justify-center p-4">
            <div class="bg-surface rounded-2xl shadow-2xl w-full max-w-lg max-h-[90vh] overflow-y-auto custom-scrollbar">
                <div class="relative bg-gradient-to-br from-primary to-primary/70 rounded-t-2xl px-6 pt-6 pb-6">
                    <button id="updateCancelX" type="button" class="absolute top-4 right-4 text-white/80 hover:text-white transition">
                        <span class="material-symbols-outlined">close</span>
                    </button>
                    <p class="text-white/80 text-sm font-medium mb-2">Update Account Information</p>
                    <div id="updatePreviewName" class="font-bold text-xl text-white truncate">—</div>
                    <div class="flex items-center gap-2 mt-2">
                        <span id="updateRoleBadgePreview" class="role-badge-customer px-3 py-0.5 rounded-full text-xs font-bold">Customer</span>
                        <span id="updateStatusBadgePreview" class="status-badge-active px-3 py-0.5 rounded-full text-xs font-bold">Active</span>
                    </div>
                </div>

                <div class="p-6 pt-5 space-y-5">
                    <input type="hidden" id="updateId">
                    <input type="hidden" id="updateType">

                    <div>
                        <div class="flex items-center gap-2 mb-3">
                            <span class="material-symbols-outlined text-primary text-lg">badge</span>
                            <h4 class="font-bold text-sm text-on-surface">Personal Information</h4>
                        </div>
                        <div class="space-y-3">
                            <div>
                                <label class="block text-xs font-medium text-on-surface-variant mb-1">Full Name</label>
                                <input type="text" id="updateFullname"
                                       class="w-full h-11 px-4 border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/30 focus:border-primary outline-none transition">
                            </div>
                            <div class="grid grid-cols-2 gap-3">
                                <div>
                                    <label class="block text-xs font-medium text-on-surface-variant mb-1">Phone Number</label>
                                    <input type="text" id="updatePhone"
                                           class="w-full h-11 px-4 border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/30 focus:border-primary outline-none transition">
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-on-surface-variant mb-1">Email</label>
                                    <input type="text" id="updateEmail" disabled
                                           class="w-full h-11 px-4 border border-outline-variant rounded-lg bg-background-alt text-on-surface-variant cursor-not-allowed truncate">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="customerStatsSection" class="hidden pt-4 border-t border-outline-variant/60">
                        <div class="flex items-center gap-2 mb-3">
                            <span class="material-symbols-outlined text-primary">shopping_bag</span>
                            <h4 class="font-bold text-sm">Purchase Statistics</h4>
                        </div>
                        <div class="grid grid-cols-2 gap-3">
                            <div class="bg-blue-50 rounded-lg p-4">
                                <p class="text-xs text-gray-500">Total Orders</p>
                                <p id="totalOrders" class="text-2xl font-bold">0</p>
                            </div>
                            <div class="bg-green-50 rounded-lg p-4">
                                <p class="text-xs text-gray-500">Total Spending</p>
                                <p id="totalSpent" class="text-2xl font-bold">0 VND</p>
                            </div>
                        </div>
                    </div>

                    <div class="pt-4 border-t border-outline-variant/60">
                        <div class="flex items-center gap-2 mb-3">
                            <span class="material-symbols-outlined text-primary text-lg">settings_applications</span>
                            <h4 class="font-bold text-sm text-on-surface">Account Settings</h4>
                        </div>
                        <div class="space-y-3">
                            <div id="updateRoleWrapper" class="hidden">
                                <label class="block text-xs font-medium text-on-surface-variant mb-1">System Role</label>
                                <select id="updateRole" class="w-full h-11 px-4 border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/30 focus:border-primary outline-none transition cursor-pointer">
                                    <option value="staff">Staff</option>
                                    <option value="admin">Admin</option>
                                </select>
                            </div>
                            <div class="flex items-center justify-between p-3 bg-surface-container-low rounded-lg">
                                <div>
                                    <p class="text-sm font-medium text-on-surface">Active Status</p>
                                    <p class="text-xs text-on-surface-variant">Allow this account to access the system</p>
                                </div>
                                <label class="relative inline-flex items-center cursor-pointer shrink-0">
                                    <input type="checkbox" id="updateStatusToggle" class="sr-only peer">
                                    <div class="w-11 h-6 bg-outline-variant peer-checked:bg-success rounded-full peer transition-colors after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:after:translate-x-full"></div>
                                </label>
                            </div>
                        </div>
                    </div>

                    <p id="updateError" class="text-error text-sm hidden"></p>
                </div>

                <div class="flex gap-3 justify-end px-6 py-4 border-t border-outline-variant/60 bg-background-alt rounded-b-2xl">
                    <button id="updateCancel" type="button" class="px-6 py-2.5 border border-outline-variant text-on-surface rounded-lg hover:bg-surface transition font-medium">Cancel</button>
                    <button id="updateSubmit" type="button" class="px-6 py-2.5 bg-primary text-white rounded-lg hover:opacity-90 transition font-medium shadow-md shadow-primary/20">Save Changes</button>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/common/toast.jsp" %>

        <script>
            const BASE_URL = '${pageContext.request.contextPath}/dashboard/account-management';

            let searchTimeout = null;

            function applyFilters() {
                const keyword = document.getElementById('searchInput').value.trim();
                const roleFilterEl = document.getElementById('roleFilter');
                const role = roleFilterEl ? roleFilterEl.value : '';
                const status = document.getElementById('statusFilter').value;
                const params = new URLSearchParams({keyword, role, status, page: 1});
                window.location.href = BASE_URL + '?' + params.toString();
            }

            document.getElementById('searchInput').addEventListener('input', function () {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(applyFilters, 400);
            });

            const roleFilterInput = document.getElementById('roleFilter');
            if (roleFilterInput) {
                roleFilterInput.addEventListener('change', applyFilters);
            }
            document.getElementById('statusFilter').addEventListener('change', applyFilters);
            const confirmModal = document.getElementById('confirmModal');
            const modalTitle = document.getElementById('modalTitle');
            const modalMessage = document.getElementById('modalMessage');
            const modalCancel = document.getElementById('modalCancel');
            const modalConfirm = document.getElementById('modalConfirm');
            let pendingAction = null;

            function showConfirmModal(title, message, callback) {
                modalTitle.textContent = title;
                modalMessage.textContent = message;
                pendingAction = callback;
                confirmModal.classList.replace('modal-hidden', 'modal-visible');
            }

            function hideConfirmModal() {
                confirmModal.classList.replace('modal-visible', 'modal-hidden');
                pendingAction = null;
            }

            modalCancel.addEventListener('click', hideConfirmModal);
            confirmModal.addEventListener('click', e => {
                if (e.target === confirmModal)
                    hideConfirmModal();
            });
            modalConfirm.addEventListener('click', async () => {
                if (pendingAction) {
                    const fn = pendingAction;
                    hideConfirmModal();
                    await fn();
                }
            });
            document.querySelectorAll('.toggle-status-btn').forEach(btn => {
                btn.addEventListener('click', function () {
                    const accountId = this.dataset.accountId;
                    const role = this.dataset.role;
                    const currentStatus = this.dataset.currentStatus;
                    const newStatus = currentStatus === 'active' ? 'inactive' : 'active';
                    const row = this.closest('tr');

                    const title = currentStatus === 'active' ? 'Lock Account' : 'Unlock Account';
                    const message = currentStatus === 'active'
                            ? 'Are you sure you want to LOCK this account?'
                            : 'Are you sure you want to UNLOCK this account?';

                    showConfirmModal(title, message, async () => {
                        try {
                            const body = new URLSearchParams({
                                action: role === 'customer' ? 'toggleCustomer' : 'toggleStaff',
                                id: accountId,
                                status: newStatus
                            });

                            const res = await fetch(BASE_URL, {method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body});
                            const result = await res.json();

                            if (result.success) {
                                const statusBadge = row.querySelector('.status-badge');
                                const icon = btn.querySelector('.material-symbols-outlined');

                                if (newStatus === 'active') {
                                    statusBadge.classList.replace('status-badge-inactive', 'status-badge-active');
                                    statusBadge.textContent = 'Active';
                                    icon.textContent = 'lock';
                                    btn.title = 'Lock Account';
                                } else {
                                    statusBadge.classList.replace('status-badge-active', 'status-badge-inactive');
                                    statusBadge.textContent = 'Locked';
                                    icon.textContent = 'lock_open';
                                    btn.title = 'Unlock Account';
                                }

                                row.dataset.status = newStatus;
                                btn.dataset.currentStatus = newStatus;

                                const editBtn = row.querySelector('.edit-btn');
                                if (editBtn)
                                    editBtn.dataset.status = newStatus;

                                showToast('Status updated successfully!');
                            } else {
                                showToast(result.message || 'Update failed!', true);
                            }
                        } catch (err) {
                            console.error(err);
                            showToast('Connection error. Please try again!', true);
                        }
                    });
                });
            });

            const updateModal = document.getElementById('updateModal');
            const updateId = document.getElementById('updateId');
            const updateType = document.getElementById('updateType');
            const updateFullname = document.getElementById('updateFullname');
            const updatePhone = document.getElementById('updatePhone');
            const updateEmail = document.getElementById('updateEmail');
            const updateStatusToggle = document.getElementById('updateStatusToggle');
            const updateRole = document.getElementById('updateRole');
            const updateRoleWrapper = document.getElementById('updateRoleWrapper');
            const updateError = document.getElementById('updateError');
            const updateCancel = document.getElementById('updateCancel');
            const updateCancelX = document.getElementById('updateCancelX');
            const updateSubmit = document.getElementById('updateSubmit');
            const updatePreviewName = document.getElementById('updatePreviewName');
            const updateRoleBadgePreview = document.getElementById('updateRoleBadgePreview');
            const updateStatusBadgePreview = document.getElementById('updateStatusBadgePreview');
            const customerStatsSection = document.getElementById('customerStatsSection');
            const totalOrders = document.getElementById('totalOrders');
            const totalSpent = document.getElementById('totalSpent');

            function refreshUpdatePreview() {
                updatePreviewName.textContent = updateFullname.value.trim() || '—';

                let roleLabel, roleClass;
                if (updateType.value === 'customer') {
                    roleLabel = 'Customer';
                    roleClass = 'role-badge-customer';
                } else if (updateRole.value === 'admin') {
                    roleLabel = 'Admin';
                    roleClass = 'role-badge-admin';
                } else {
                    roleLabel = 'Staff';
                    roleClass = 'role-badge-staff';
                }
                updateRoleBadgePreview.className = roleClass + ' px-3 py-0.5 rounded-full text-xs font-bold';
                updateRoleBadgePreview.textContent = roleLabel;

                const isActive = updateStatusToggle.checked;
                updateStatusBadgePreview.className = (isActive ? 'status-badge-active' : 'status-badge-inactive') + ' px-3 py-0.5 rounded-full text-xs font-bold';
                updateStatusBadgePreview.textContent = isActive ? 'Active' : 'Locked';
            }

            updateFullname.addEventListener('input', refreshUpdatePreview);
            updateRole.addEventListener('change', refreshUpdatePreview);
            updateStatusToggle.addEventListener('change', refreshUpdatePreview);

            function showUpdateModal() {
                updateError.classList.add('hidden');
                updateModal.classList.replace('modal-hidden', 'modal-visible');
            }

            function hideUpdateModal() {
                updateModal.classList.replace('modal-visible', 'modal-hidden');
            }

            updateCancel.addEventListener('click', hideUpdateModal);
            updateCancelX.addEventListener('click', hideUpdateModal);
            updateModal.addEventListener('click', e => {
                if (e.target === updateModal)
                    hideUpdateModal();
            });

            document.querySelectorAll('.edit-btn').forEach(btn => {
                btn.addEventListener('click', function () {
                    const type = this.dataset.type;

                    updateId.value = this.dataset.id;
                    updateType.value = type;
                    updateFullname.value = this.dataset.fullname || '';
                    updatePhone.value = this.dataset.phone || '';
                    updateEmail.value = this.dataset.email || '';
                    updateStatusToggle.checked = (this.dataset.status || 'active') === 'active';

                    if (type === 'staff') {
                        updateRoleWrapper.classList.remove('hidden');
                        customerStatsSection.classList.add('hidden');
                        updateRole.value = this.dataset.roleValue || 'staff';
                    } else {
                        updateRoleWrapper.classList.add('hidden');
                        customerStatsSection.classList.remove('hidden');
                        totalOrders.textContent = '…';
                        totalSpent.textContent = '…';

                        fetch(BASE_URL, {
                            method: 'POST',
                            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                            body: 'action=customerStats&id=' + this.dataset.id
                        })
                                .then(r => r.json())
                                .then(data => {
                                    totalOrders.textContent = data.totalOrders;
                                    totalSpent.textContent = Number(data.totalSpent).toLocaleString('en-US') + ' VND';
                                })
                                .catch(err => console.error(err));
                    }

                    refreshUpdatePreview();
                    showUpdateModal();
                });
            });

            updateSubmit.addEventListener('click', async function () {
                const fullname = updateFullname.value.trim();
                if (!fullname) {
                    updateError.textContent = 'Full name is required';
                    updateError.classList.remove('hidden');
                    return;
                }

                updateError.classList.add('hidden');

                const type = updateType.value;
                const id = updateId.value;
                const newStatus = updateStatusToggle.checked ? 'active' : 'inactive';

                const body = new URLSearchParams({
                    action: type === 'customer' ? 'updateCustomer' : 'updateStaff',
                    id,
                    fullname,
                    phone: updatePhone.value.trim(),
                    status: newStatus
                });

                if (type === 'staff')
                    body.append('role', updateRole.value);

                try {
                    const res = await fetch(BASE_URL, {method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body});
                    const result = await res.json();

                    if (result.success) {
                        hideUpdateModal();

                        const row = document.querySelector('tr[data-account-id="' + id + '"][data-type="' + type + '"]');
                        if (row) {
                            row.querySelector('td:first-child .font-semibold').textContent = fullname;

                            const statusBadge = row.querySelector('.status-badge');
                            if (newStatus === 'active') {
                                statusBadge.classList.replace('status-badge-inactive', 'status-badge-active');
                                statusBadge.textContent = 'Active';
                            } else {
                                statusBadge.classList.replace('status-badge-active', 'status-badge-inactive');
                                statusBadge.textContent = 'Locked';
                            }
                            row.dataset.status = newStatus;

                            const toggleBtn = row.querySelector('.toggle-status-btn');
                            if (toggleBtn) {
                                toggleBtn.dataset.currentStatus = newStatus;
                                toggleBtn.querySelector('.material-symbols-outlined').textContent = newStatus === 'active' ? 'lock' : 'lock_open';
                                toggleBtn.title = newStatus === 'active' ? 'Lock Account' : 'Unlock Account';
                            }

                            const editBtn = row.querySelector('.edit-btn');
                            if (editBtn) {
                                editBtn.dataset.fullname = fullname;
                                editBtn.dataset.phone = updatePhone.value.trim();
                                editBtn.dataset.status = newStatus;

                                if (type === 'staff') {
                                    const newRole = updateRole.value;
                                    editBtn.dataset.roleValue = newRole;
                                    row.dataset.role = newRole;

                                    row.children[1].innerHTML = newRole === 'admin'
                                            ? '<span class="role-badge-admin px-3 py-1 rounded-full text-xs font-bold">Admin</span>'
                                            : '<span class="role-badge-staff px-3 py-1 rounded-full text-xs font-bold">Staff</span>';
                                }
                            }
                        }

                        showToast('Updated successfully!');
                    } else {
                        updateError.textContent = result.message || 'Update failed!';
                        updateError.classList.remove('hidden');
                    }
                } catch (err) {
                    console.error(err);
                    updateError.textContent = 'Connection error. Please try again!';
                    updateError.classList.remove('hidden');
                }
            });
        </script>
    </body>
</html>
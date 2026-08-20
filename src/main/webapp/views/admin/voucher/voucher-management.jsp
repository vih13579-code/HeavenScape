<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <title>Voucher Management - HeavenScape</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            "primary": "#C92127", "on-primary": "#FFFFFF",
                            "surface-tint": "#C92127", "primary-fixed": "#FFDAD9",
                            "background": "#F7F7F8", "background-alt": "#FFFFFF",
                            "surface": "#FFFFFF", "surface-variant": "#EFE0DF",
                            "surface-container": "#F1F1F3", "surface-container-low": "#F7F7F8",
                            "surface-container-high": "#EBEBED",
                            "on-surface": "#1B1B1B", "on-surface-variant": "#5C5C5F",
                            "outline": "#8F8F92", "outline-variant": "#D9D9DC",
                            "inverse-surface": "#303030",
                            "error": "#D32F2F", "error-container": "#FFDAD6",
                            "success": "#2E7D32", "warning": "#F9A825",
                        },
                        fontFamily: {"sans": ["Inter", "sans-serif"]},
                        boxShadow: {
                            "card": "0 4px 20px rgba(21,101,192,0.08)",
                            "card-hover": "0 8px 32px rgba(21,101,192,0.14)",
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
            .icon-fill {
                font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
            .sidebar-link {
                display: flex;
                align-items: center;
                padding: 10px 16px;
                margin: 0 8px;
                border-radius: 10px;
                color: #5C5C5F;
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                transition: all 0.2s ease;
                gap: 10px;
            }
            .sidebar-link:hover {
                background: #FDE8E9;
                color: #C92127;
            }
            .sidebar-link.active {
                background: #FDE8E9;
                color: #C92127;
                font-weight: 700;
            }
            .sidebar-link.active .material-symbols-outlined {
                font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
            .user-popup {
                display: none;
                position: absolute;
                bottom: 70px;
                left: 12px;
                right: 12px;
                background: white;
                border: 1px solid #D9D9DC;
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(21,101,192,0.12);
                z-index: 100;
                overflow: hidden;
            }
            .user-popup.open {
                display: block;
                animation: popupIn 0.15s ease;
            }
            @keyframes popupIn {
                from {
                    opacity: 0;
                    transform: translateY(8px);
                }
                to   {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .user-popup a {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 16px;
                font-size: 14px;
                color: #5C5C5F;
                text-decoration: none;
                transition: background 0.15s;
            }
            .user-popup a:hover {
                background: #FDE8E9;
                color: #C92127;
            }
            .user-popup a.danger:hover {
                background: #ffdad6;
                color: #D32F2F;
            }
            .user-popup .divider {
                height: 1px;
                background: #D9D9DC;
                margin: 4px 0;
            }
            .user-trigger {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 12px;
                margin: 0 8px 8px;
                border-radius: 10px;
                cursor: pointer;
                transition: background 0.2s;
            }
            .user-trigger:hover {
                background: #FDE8E9;
            }
            .modal-backdrop {
                backdrop-filter: blur(4px);
            }
            .code-badge {
                font-family: 'Courier New', monospace;
                letter-spacing: 0.05em;
            }
            tbody tr {
                transition: background 0.15s;
            }
            #toast {
                transition: all 0.3s ease;
            }
        </style>
    </head>
    <body class="bg-background text-on-surface flex min-h-screen">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <%-- ===== MAIN ===== --%>
        <main class="ml-64 flex-1 flex flex-col min-h-screen">

            <%-- Content --%>
            <div class="p-6 flex-1 space-y-6 max-w-screen-xl mx-auto w-full">

                <%-- Page title --%>
                <div class="hs-admin-page-heading">
                    <div>
                        <h1 class="hs-admin-page-title">Promotional Vouchers</h1>
                        <p class="hs-admin-page-subtitle">Manage discount codes and promotions.</p>
                    </div>
                    <button onclick="openModal()"
                            class="flex items-center gap-2 px-5 py-2.5 rounded-lg text-white text-sm font-semibold shadow-card active:scale-95 transition-all"
                            style="background:#C92127;">
                        <span class="material-symbols-outlined" style="font-size:18px;">add</span>
                        Add Voucher
                    </button>
                </div>

                <%-- Stats --%>
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
                    <div class="bg-white rounded-2xl shadow-card p-5 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0" style="background:#FDE8E9;">
                            <span class="material-symbols-outlined" style="color:#C92127;font-size:24px;">local_activity</span>
                        </div>
                        <div>
                            <p class="text-xs" style="color:#5C5C5F;">Total Vouchers</p>
                            <p class="text-xl font-bold" style="color:#1B1B1B;">${not empty totalVouchers ? totalVouchers : 0}</p>
                        </div>
                    </div>
                    <div class="bg-white rounded-2xl shadow-card p-5 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0" style="background:#e8f5e9;">
                            <span class="material-symbols-outlined" style="color:#2E7D32;font-size:24px;">check_circle</span>
                        </div>
                        <div>
                            <p class="text-xs" style="color:#5C5C5F;">Active</p>
                            <p class="text-xl font-bold" style="color:#1B1B1B;">${not empty activeVouchers ? activeVouchers : 0}</p>
                        </div>
                    </div>
                    <div class="bg-white rounded-2xl shadow-card p-5 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0" style="background:#fff8e1;">
                            <span class="material-symbols-outlined" style="color:#FFA000;font-size:24px;">schedule</span>
                        </div>
                        <div>
                            <p class="text-xs" style="color:#5C5C5F;">Expired</p>
                            <p class="text-xl font-bold" style="color:#1B1B1B;">${not empty expiredVouchers ? expiredVouchers : 0}</p>
                        </div>
                    </div>
                    <div class="bg-white rounded-2xl shadow-card p-5 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0" style="background:#FDE8E9;">
                            <span class="material-symbols-outlined" style="color:#C92127;font-size:24px;">people</span>
                        </div>
                        <div>
                            <p class="text-xs" style="color:#5C5C5F;">Total Uses</p>
                            <p class="text-xl font-bold" style="color:#1B1B1B;">${not empty totalUsed ? totalUsed : 0}</p>
                        </div>
                    </div>
                </div>

                <%-- Table panel --%>
                <div class="bg-white rounded-2xl shadow-card overflow-hidden">

                    <%-- Filter --%>
                    <div class="p-4 border-b flex flex-col md:flex-row gap-3 justify-between items-center"
                         style="border-color:#D9D9DC; background:#F5F7F9;">
                        <form method="get" action="${pageContext.request.contextPath}/dashboard/voucher-management"
                              class="flex flex-col md:flex-row gap-3 w-full">
                           
                            <div class="flex items-center gap-2">
                                <span class="text-xs font-medium whitespace-nowrap" style="color:#5C5C5F;">Status:</span>
                                <select name="status" class="border rounded-lg text-sm py-2 pl-3 pr-8 bg-white appearance-none focus:outline-none focus:ring-2"
                                        style="border-color:#D9D9DC;">
                                    <option value=""       ${empty param.status              ? 'selected' : ''}>All</option>
                                    <option value="active"  ${param.status == 'active'        ? 'selected' : ''}>Active</option>
                                    <option value="inactive"${param.status == 'inactive'      ? 'selected' : ''}>Inactive</option>
                                    <option value="expired" ${param.status == 'expired'       ? 'selected' : ''}>Expired</option>
                                </select>
                            </div>
                            <button type="submit" class="px-4 py-2 rounded-lg text-white text-sm font-medium whitespace-nowrap"
                                    style="background:#C92127;">Filter</button>
                        </form>
                    </div>

                    <%-- Table --%>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead>
                                <tr class="border-b" style="background:#F5F7F9; border-color:#D9D9DC;">
                                    <th class="py-3 px-5 text-xs font-semibold" style="color:#5C5C5F;">Code</th>
                                    <th class="py-3 px-5 text-xs font-semibold" style="color:#5C5C5F;">Discount</th>
                                    <th class="py-3 px-5 text-xs font-semibold" style="color:#5C5C5F;">Remaining / Total</th>
                                    <th class="py-3 px-5 text-xs font-semibold" style="color:#5C5C5F;">Used</th>
                                    <th class="py-3 px-5 text-xs font-semibold" style="color:#5C5C5F;">Validity</th>
                                    <th class="py-3 px-5 text-xs font-semibold" style="color:#5C5C5F;">Status</th>
                                    <th class="py-3 px-5 text-xs font-semibold text-right" style="color:#5C5C5F;">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y" style="border-color:#f0f0f0;">
                                <c:choose>
                                    <c:when test="${empty voucherList}">
                                        <tr>
                                            <td colspan="7" class="py-16 text-center text-sm" style="color:#5C5C5F;">
                                                <span class="material-symbols-outlined block mb-2" style="font-size:40px;color:#D9D9DC;">sell</span>
                                                No vouchers found
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${voucherList}" var="v">
                                            <tr class="hover:bg-surface-container-low group">
                                                <%-- Code --%>
                                                <td class="py-3.5 px-5">
                                                    <div class="inline-flex items-center gap-1.5 px-3 py-1 rounded-md border code-badge text-sm font-semibold"
                                                         style="background:#FDE8E9; border-color:#D9D9DC; color:#C92127;">
                                                        ${v.code}
                                                        <button onclick="copyCode('${v.code}')" title="Copy"
                                                                class="hover:opacity-70 transition-opacity">
                                                            <span class="material-symbols-outlined" style="font-size:15px;">content_copy</span>
                                                        </button>
                                                    </div>
                                                </td>

                                                <%-- Discount --%>
                                                <td class="py-3.5 px-5 text-sm font-semibold" style="color:#1B1B1B;">
                                                    <fmt:formatNumber value="${v.discountPercent}" maxFractionDigits="0"/>%
                                                </td>

                                                <%-- Remaining / Total --%>
                                                <td class="py-3.5 px-5 text-sm" style="color:#5C5C5F;">
                                                    <c:choose>
                                                        <c:when test="${v.quantity != null and v.quantity > 0}">
                                                            <span class="font-medium" style="color:#1B1B1B;">${v.quantity - v.usedCount}</span>
                                                            / ${v.quantity}
                                                        </c:when>
                                                        <c:otherwise><span class="font-medium">Unlimited</span></c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <%-- Used --%>
                                                <td class="py-3.5 px-5 text-sm" style="color:#1B1B1B;">
                                                    ${v.usedCount}
                                                    <span class="text-xs" style="color:#5C5C5F;">uses</span>
                                                </td>

                                                <%-- Validity --%>
                                                <td class="py-3.5 px-5 text-sm">
                                                    <c:choose>
                                                        <c:when test="${v.startDate != null}">
                                                            <div style="color:#1B1B1B;">
                                                                <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy"/>
                                                            </div>
                                                            <div class="text-xs" style="color:#727783;">
                                                                to <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy"/>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-xs" style="color:#727783;">Unlimited</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <%-- Status --%>
                                                <td class="py-3.5 px-5">
                                                    <c:choose>
                                                        <c:when test="${v.status == 'active'}">
                                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium"
                                                                  style="background:#e8f5e9; color:#2E7D32;">
                                                                <span class="w-1.5 h-1.5 rounded-full" style="background:#2E7D32;"></span>
                                                                Active
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${v.status == 'inactive'}">
                                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium"
                                                                  style="background:#f0f0f0; color:#5C5C5F;">
                                                                <span class="w-1.5 h-1.5 rounded-full" style="background:#727783;"></span>
                                                                Inactive
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium"
                                                                  style="background:#ffdad6; color:#D32F2F;">
                                                                <span class="w-1.5 h-1.5 rounded-full" style="background:#D32F2F;"></span>
                                                                Expired
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <%-- Actions --%>
                                                <td class="py-3.5 px-5 text-right">
                                                    <div class="flex items-center justify-end gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                                                        <button onclick="openEditModal(${v.voucherID}, '${v.code}', ${v.discountPercent}, ${v.quantity != null ? v.quantity : 0}, '${v.startDate}', '${v.endDate}', '${v.status}', ${v.minOrderValue != null ? v.minOrderValue : 0}, ${v.maxDiscountValue != null ? v.maxDiscountValue : 0})"
                                                                class="p-1.5 rounded hover:bg-surface-container transition-colors"
                                                                style="color:#5C5C5F;" title="Edit">
                                                            <span class="material-symbols-outlined" style="font-size:18px;">edit</span>
                                                        </button>

                                                        <c:choose>
                                                            <c:when test="${v.status == 'active'}">
                                                                <form method="post" action="${pageContext.request.contextPath}/dashboard/voucher-management" style="display:inline;">
                                                                    <input type="hidden" name="action" value="toggle"/>
                                                                    <input type="hidden" name="voucherID" value="${v.voucherID}"/>
                                                                    <input type="hidden" name="newStatus" value="inactive"/>
                                                                    <button type="submit" class="p-1.5 rounded hover:bg-surface-container transition-colors"
                                                                            style="color:#FFA000;" title="Disable">
                                                                        <span class="material-symbols-outlined" style="font-size:18px;">block</span>
                                                                    </button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <form method="post" action="${pageContext.request.contextPath}/dashboard/voucher-management" style="display:inline;">
                                                                    <input type="hidden" name="action" value="toggle"/>
                                                                    <input type="hidden" name="voucherID" value="${v.voucherID}"/>
                                                                    <input type="hidden" name="newStatus" value="active"/>
                                                                    <button type="submit" class="p-1.5 rounded hover:bg-surface-container transition-colors"
                                                                            style="color:#2E7D32;" title="Activate">
                                                                        <span class="material-symbols-outlined" style="font-size:18px;">play_circle</span>
                                                                    </button>
                                                                </form>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <button onclick="confirmDelete(${v.voucherID}, '${v.code}')"
                                                                class="p-1.5 rounded transition-colors"
                                                                style="color:#5C5C5F;" title="Delete"
                                                                onmouseover="this.style.background = '#ffdad6';this.style.color = '#D32F2F';"
                                                                onmouseout="this.style.background = '';this.style.color = '#5C5C5F';">
                                                            <span class="material-symbols-outlined" style="font-size:18px;">delete</span>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <%-- Pagination (dùng chung) --%>
                    <%@ include file="/views/layout/common/pagination.jsp" %>
                </div>
            </div>

            <%@ include file="/views/layout/dashboard/footer.jsp" %>
        </main>

        <%@ include file="/views/admin/voucher/voucher-modal.jsp" %>

        <%-- ===== TOAST (dùng chung) ===== --%>
        <%@ include file="/views/layout/common/toast.jsp" %>

        <script>
            // ---- Sidebar popup ----
            function toggleUserPopup() {
                const popup = document.getElementById('userPopup');
                const chevron = document.getElementById('userChevron');
                popup.classList.toggle('open');
                chevron.textContent = popup.classList.contains('open') ? 'expand_less' : 'expand_more';
            }
            document.addEventListener('click', function (e) {
                const trigger = document.getElementById('userTrigger');
                const popup = document.getElementById('userPopup');
                if (trigger && popup && !trigger.contains(e.target) && !popup.contains(e.target)) {
                    popup.classList.remove('open');
                    const chevron = document.getElementById('userChevron');
                    if (chevron)
                        chevron.textContent = 'expand_more';
                }
            });

            // ---- Helpers ----
            function todayStr() {
                return new Date().toISOString().split('T')[0];
            }

            // ---- Modal: TẠO MỚI ----
            function openModal() {
                document.getElementById('modalTitle').textContent = 'Add New Voucher';
                document.getElementById('formAction').value = 'add';
                document.getElementById('formVoucherID').value = '';
                document.getElementById('voucherForm').reset();

                // Giới hạn startDate không được chọn quá khứ
                document.getElementById('inputStartDate').min = todayStr();
                document.getElementById('inputEndDate').min   = todayStr();

                // Ẩn toggle trạng thái — tạo mới luôn active
                document.getElementById('statusSection').classList.add('hidden');

                updatePreview();
                document.getElementById('voucherModal').classList.remove('hidden');
            }

            // ---- Modal: CHỈNH SỬA ----
            function openEditModal(id, code, discount, quantity, startDate, endDate, status, minOrder, maxDisc) {
                document.getElementById('modalTitle').textContent = 'Edit Voucher';
                document.getElementById('formAction').value = 'edit';
                document.getElementById('formVoucherID').value = id;
                document.getElementById('inputCode').value     = code;
                document.getElementById('inputDiscount').value = discount;
                document.getElementById('inputQuantity').value = quantity > 0 ? quantity : '';
                document.getElementById('inputStartDate').value = startDate ? startDate.substring(0, 10) : '';
                document.getElementById('inputEndDate').value   = endDate   ? endDate.substring(0, 10)   : '';
                document.getElementById('inputMinOrder').value    = minOrder > 0 ? minOrder : '';
                document.getElementById('inputMaxDiscount').value = maxDisc  > 0 ? maxDisc  : '';

                // Bỏ giới hạn min khi edit
                document.getElementById('inputStartDate').min = '';
                document.getElementById('inputEndDate').min   = '';

                // Hiện toggle trạng thái khi edit
                document.getElementById('statusSection').classList.remove('hidden');
                const isActive = status === 'active';
                document.getElementById('inputStatus').checked = isActive;
                document.getElementById('toggleBg').style.background = isActive ? '#2E7D32' : '#D9D9DC';
                document.getElementById('statusLabel').textContent    = isActive ? 'Active' : 'Disable';

                updatePreview();
                document.getElementById('voucherModal').classList.remove('hidden');
            }

            function closeModal() {
                document.getElementById('voucherModal').classList.add('hidden');
            }

            // ---- Delete ----
            function confirmDelete(id, code) {
                document.getElementById('deleteVoucherID').value = id;
                document.getElementById('deleteCodeLabel').textContent = code;
                document.getElementById('deleteDialog').classList.remove('hidden');
            }
            function closeDeleteDialog() {
                document.getElementById('deleteDialog').classList.add('hidden');
            }

            // ---- Preview ----
            function updatePreview() {
                if (!document.getElementById('previewCode')) {
                    return;
                }
                const code     = (document.getElementById('inputCode').value    || 'CODE').toUpperCase();
                const discount = document.getElementById('inputDiscount').value || '?';
                const endDate  = document.getElementById('inputEndDate').value;
                const minOrder = document.getElementById('inputMinOrder').value;
                const maxDisc  = document.getElementById('inputMaxDiscount').value;

                document.getElementById('previewCode').textContent     = code;
                document.getElementById('previewDiscount').textContent = 'Save ' + discount + '%';
                document.getElementById('previewDate').textContent     = endDate
                    ? 'Expires: ' + new Date(endDate).toLocaleDateString('en-US')
                    : 'Expires: No limit';
                document.getElementById('previewMinOrder').textContent = minOrder
                    ? 'Minimum order: ' + Number(minOrder).toLocaleString('en-US') + ' VND'
                    : '';
                document.getElementById('previewMaxDiscount').textContent = maxDisc
                    ? 'Maximum discount: ' + Number(maxDisc).toLocaleString('en-US') + ' VND'
                    : '';
            }

            // ---- Random code ----
            function randomCode() {
                const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
                let r = 'HS';
                for (let i = 0; i < 6; i++)
                    r += chars.charAt(Math.floor(Math.random() * chars.length));
                document.getElementById('inputCode').value = r;
                updatePreview();
            }

            // ---- Copy ----
            function copyCode(code) {
                navigator.clipboard.writeText(code).then(() => showToast('Copied code: ' + code));
            }

            // ---- Toggle style (chỉ dùng khi edit) ----
            document.getElementById('inputStatus').addEventListener('change', function () {
                document.getElementById('toggleBg').style.background = this.checked ? '#2E7D32' : '#D9D9DC';
                document.getElementById('statusLabel').textContent    = this.checked ? 'Active' : 'Disable';
            });

        </script>
    </body>
</html>

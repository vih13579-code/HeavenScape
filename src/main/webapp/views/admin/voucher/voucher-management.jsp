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
            .vm-content { width: 100%; max-width: 1440px; margin: 0 auto; padding: 24px; }
            .vm-heading { display: flex; align-items: flex-start; justify-content: space-between; gap: 20px; margin-bottom: 20px; }
            .vm-title { margin: 0; color: #333; font-size: 30px; line-height: 1.2; font-weight: 700; }
            .vm-subtitle { margin: 6px 0 0; color: #666; font-size: 14px; line-height: 1.5; }
            .vm-create-btn { height: 40px; display: inline-flex; align-items: center; justify-content: center; gap: 7px; padding: 0 16px; border-radius: 6px; background: #c92127; color: #fff; font-size: 13px; font-weight: 700; white-space: nowrap; }
            .vm-create-btn:hover { background: #a7191e; }
            .vm-panel { overflow: hidden; border: 1px solid #e2e2e2; border-radius: 8px; background: #fff; box-shadow: 0 2px 8px rgba(0,0,0,.06); }
            .vm-filters { padding: 15px 16px; border-bottom: 1px solid #e5e5e5; background: #fff; }
            .vm-filter-form { display: grid; grid-template-columns: minmax(260px, 1fr) 180px auto auto; align-items: end; gap: 12px; }
            .vm-filter-form { box-shadow: none !important; }
            .vm-field { min-width: 0; }
            .vm-field label { display: block; margin-bottom: 6px; color: #555; font-size: 11px; font-weight: 700; }
            .vm-search { position: relative; }
            .vm-search input { width: 100%; height: 40px; padding: 0 40px 0 12px; font-size: 12px; }
            .vm-search .material-symbols-outlined { position: absolute; top: 50%; right: 12px; color: #777; font-size: 18px; transform: translateY(-50%); pointer-events: none; }
            .vm-field select { width: 100%; height: 40px; padding: 0 34px 0 12px; font-size: 12px; }
            .vm-filter-btn { height: 40px; display: inline-flex; align-items: center; justify-content: center; gap: 6px; padding: 0 16px; border: 1px solid #c92127; border-radius: 6px; background: #fff; color: #c92127; font-size: 12px; font-weight: 700; }
            .vm-filter-btn:hover { background: #fff2f3; }
            .vm-reset { height: 40px; display: inline-flex; align-items: center; justify-content: center; gap: 5px; padding: 0 8px; color: #666; font-size: 12px; font-weight: 600; white-space: nowrap; }
            .vm-reset:hover { color: #c92127; }
            .vm-table-wrap { overflow-x: auto; }
            .vm-table { width: 100%; min-width: 1100px; border-collapse: collapse; }
            .vm-table thead { background: #f7f7f7; }
            .vm-table th { padding: 12px 14px; border-bottom: 1px solid #e2e2e2; color: #666; font-size: 10px; font-weight: 800; letter-spacing: .03em; text-align: left; text-transform: uppercase; white-space: nowrap; }
            .vm-table td { padding: 13px 14px; border-bottom: 1px solid #ededed; color: #444; font-size: 11px; vertical-align: middle; }
            .vm-table tbody tr:hover { background: #fffafa; }
            .vm-code { display: inline-flex; align-items: center; gap: 5px; max-width: 150px; padding: 6px 9px; border-radius: 5px; background: #c92127; color: #fff; font-family: 'Courier New', monospace; font-size: 11px; font-weight: 800; }
            .vm-code span:first-child { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
            .vm-code button { flex: 0 0 auto; }
            .vm-discount { color: #c92127; font-weight: 800; white-space: nowrap; }
            .vm-muted { color: #777; font-size: 10px; }
            .vm-period { line-height: 1.55; white-space: nowrap; }
            .vm-badge { display: inline-flex; align-items: center; justify-content: center; padding: 4px 8px; border-radius: 999px; font-size: 9px; font-weight: 800; text-transform: uppercase; }
            .vm-badge.active { background: #e6f6eb; color: #16833b; }
            .vm-badge.inactive { background: #fff3dd; color: #b66a00; }
            .vm-badge.expired { background: #eff0f2; color: #6b6d72; }
            .vm-table-footer { display: flex; align-items: center; justify-content: space-between; gap: 16px; min-height: 58px; padding: 10px 16px; color: #666; font-size: 11px; }
            .vm-pagination { display: flex; align-items: center; gap: 5px; }
            .vm-page { width: 31px; height: 31px; display: inline-flex; align-items: center; justify-content: center; border: 1px solid #dedede; border-radius: 5px; background: #fff; color: #555; font-size: 11px; }
            .vm-page:hover:not(.disabled), .vm-page.active { border-color: #c92127; background: #c92127; color: #fff; }
            .vm-page.disabled { color: #bbb; cursor: not-allowed; }
            .vm-stats { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 14px; margin-top: 18px; }
            .vm-stats { box-shadow: none !important; }
            .vm-stat { min-height: 94px; display: flex; align-items: center; gap: 13px; padding: 16px; border: 1px solid #e2e2e2; border-radius: 8px; background: #fff; box-shadow: 0 2px 8px rgba(0,0,0,.05); }
            .vm-stat-icon { width: 42px; height: 42px; display: flex; align-items: center; justify-content: center; flex: 0 0 auto; border-radius: 9px; }
            .vm-stat-icon .material-symbols-outlined { font-size: 22px; }
            .vm-stat-icon.total { background: #fff0f1; color: #c92127; }
            .vm-stat-icon.active { background: #e8f7ed; color: #16833b; }
            .vm-stat-icon.expired { background: #f0f1f3; color: #666; }
            .vm-stat-icon.used { background: #fff3df; color: #d87900; }
            .vm-stat-value { color: #29292c; font-size: 20px; line-height: 1.1; font-weight: 800; }
            .vm-stat-label { margin-top: 4px; color: #666; font-size: 11px; }
            .vm-empty { padding: 54px 20px !important; color: #777 !important; text-align: center; }
            @media (max-width: 900px) {
                .vm-filter-form { grid-template-columns: minmax(220px, 1fr) 160px auto; }
                .vm-reset { grid-column: 1 / -1; justify-self: end; height: auto; }
                .vm-stats { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            }
            @media (max-width: 767px) {
                .vm-content { padding: 18px 14px; }
            }
            @media (max-width: 600px) {
                .vm-heading { align-items: stretch; flex-direction: column; }
                .vm-title { font-size: 26px; }
                .vm-create-btn { width: 100%; }
                .vm-filter-form { grid-template-columns: 1fr; }
                .vm-reset { grid-column: auto; justify-self: center; }
                .vm-filter-btn { width: 100%; }
                .vm-table-footer { align-items: flex-start; flex-direction: column; }
                .vm-stats { grid-template-columns: 1fr; }
            }
        </style>
    </head>
    <body class="hs-admin-page bg-background text-on-surface flex min-h-screen">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <main class="ml-64 flex-1 flex flex-col min-h-screen">
            <div class="vm-content flex-1">
                <div class="vm-heading">
                    <div>
                        <h1 class="vm-title">Voucher Management</h1>
                        <p class="vm-subtitle">Create, update and manage store vouchers.</p>
                    </div>
                    <button type="button" class="vm-create-btn" onclick="openModal()">
                        <span class="material-symbols-outlined" style="font-size:18px;">add</span>
                        Create Voucher
                    </button>
                </div>

                <section class="vm-panel">
                    <div class="vm-filters">
                        <form class="vm-filter-form" method="get" action="${pageContext.request.contextPath}/dashboard/voucher-management">
                            <div class="vm-field">
                                <label for="voucherKeyword">Search</label>
                                <div class="vm-search">
                                    <input id="voucherKeyword" name="keyword" type="search" value="<c:out value='${param.keyword}' />" placeholder="Search by voucher code..." />
                                    <span class="material-symbols-outlined">search</span>
                                </div>
                            </div>
                            <div class="vm-field">
                                <label for="voucherStatus">Status</label>
                                <select id="voucherStatus" name="status">
                                    <option value="" ${empty param.status ? 'selected' : ''}>All Statuses</option>
                                    <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                    <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Disabled</option>
                                    <option value="expired" ${param.status == 'expired' ? 'selected' : ''}>Expired</option>
                                </select>
                            </div>
                            <button class="vm-filter-btn" type="submit">
                                <span class="material-symbols-outlined" style="font-size:17px;">filter_alt</span>
                                Filter
                            </button>
                            <a class="vm-reset" href="${pageContext.request.contextPath}/dashboard/voucher-management">
                                <span class="material-symbols-outlined" style="font-size:16px;">restart_alt</span>
                                Reset
                            </a>
                        </form>
                    </div>

                    <div class="vm-table-wrap">
                        <table class="vm-table">
                            <thead>
                                <tr>
                                    <th>Code</th>
                                    <th>Discount</th>
                                    <th>Min. Order</th>
                                    <th>Max. Discount</th>
                                    <th>Remaining / Total</th>
                                    <th>Used</th>
                                    <th>Valid Period</th>
                                    <th>Status</th>
                                    <th style="text-align:right;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty voucherList}">
                                        <tr>
                                            <td class="vm-empty" colspan="9">
                                                <span class="material-symbols-outlined" style="display:block;margin-bottom:7px;color:#bbb;font-size:34px;">sell</span>
                                                No vouchers found.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${voucherList}" var="v">
                                            <tr>
                                                <td>
                                                    <span class="vm-code">
                                                        <span><c:out value="${v.code}" /></span>
                                                        <button type="button" onclick="copyCode('${v.code}')" title="Copy code" aria-label="Copy ${v.code}">
                                                            <span class="material-symbols-outlined" style="font-size:14px;">content_copy</span>
                                                        </button>
                                                    </span>
                                                </td>
                                                <td><span class="vm-discount"><fmt:formatNumber value="${v.discountPercent}" maxFractionDigits="2" />%</span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${v.minOrderValue != null}"><fmt:formatNumber value="${v.minOrderValue}" type="number" groupingUsed="true" /> VND</c:when>
                                                        <c:otherwise><span class="vm-muted">No minimum</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${v.maxDiscountValue != null}"><fmt:formatNumber value="${v.maxDiscountValue}" type="number" groupingUsed="true" /> VND</c:when>
                                                        <c:otherwise><span class="vm-muted">No limit</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${v.quantity != null}"><strong>${v.quantity - v.usedCount}</strong> / ${v.quantity}</c:when>
                                                        <c:otherwise><span class="vm-muted">Unlimited</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><strong>${v.usedCount}</strong> <span class="vm-muted">uses</span></td>
                                                <td class="vm-period">
                                                    <c:choose>
                                                        <c:when test="${v.startDate == null and v.endDate == null}"><span class="vm-muted">Unlimited</span></c:when>
                                                        <c:otherwise>
                                                            <c:choose>
                                                                <c:when test="${v.startDate != null}"><fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy HH:mm" /></c:when>
                                                                <c:otherwise><span class="vm-muted">No start date</span></c:otherwise>
                                                            </c:choose>
                                                            <br><span class="vm-muted">–
                                                                <c:choose>
                                                                    <c:when test="${v.endDate != null}"><fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy HH:mm" /></c:when>
                                                                    <c:otherwise>No end date</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${v.status == 'active'}"><span class="vm-badge active">Active</span></c:when>
                                                        <c:when test="${v.status == 'inactive'}"><span class="vm-badge inactive">Disabled</span></c:when>
                                                        <c:otherwise><span class="vm-badge expired">Expired</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="action-group">
                                                        <button type="button" class="btn-action btn-action-edit" title="Edit voucher" aria-label="Edit voucher"
                                                                onclick="openEditModal(${v.voucherID}, '${v.code}', ${v.discountPercent}, ${v.quantity != null ? v.quantity : 0}, '${v.startDate}', '${v.endDate}', '${v.status}', ${v.minOrderValue != null ? v.minOrderValue : 0}, ${v.maxDiscountValue != null ? v.maxDiscountValue : 0})">
                                                            <span class="material-symbols-outlined" aria-hidden="true">edit</span>
                                                        </button>
                                                        <c:choose>
                                                            <c:when test="${v.status == 'active'}">
                                                                <form method="post" action="${pageContext.request.contextPath}/dashboard/voucher-management">
                                                                    <input type="hidden" name="action" value="toggle" />
                                                                    <input type="hidden" name="voucherID" value="${v.voucherID}" />
                                                                    <input type="hidden" name="newStatus" value="inactive" />
                                                                    <button type="submit" class="btn-action btn-action-disable" title="Disable voucher" aria-label="Disable voucher"><span class="material-symbols-outlined" aria-hidden="true">pause_circle</span></button>
                                                                </form>
                                                            </c:when>
                                                            <c:when test="${v.status == 'inactive'}">
                                                                <form method="post" action="${pageContext.request.contextPath}/dashboard/voucher-management">
                                                                    <input type="hidden" name="action" value="toggle" />
                                                                    <input type="hidden" name="voucherID" value="${v.voucherID}" />
                                                                    <input type="hidden" name="newStatus" value="active" />
                                                                    <button type="submit" class="btn-action btn-action-enable" title="Activate voucher" aria-label="Activate voucher"><span class="material-symbols-outlined" aria-hidden="true">play_circle</span></button>
                                                                </form>
                                                            </c:when>
                                                        </c:choose>
                                                        <button type="button" class="btn-action btn-action-delete" title="Delete voucher" aria-label="Delete voucher" onclick="confirmDelete(${v.voucherID}, '${v.code}')">
                                                            <span class="material-symbols-outlined" aria-hidden="true">delete</span>
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

                    <c:set var="showingFrom" value="${totalRecords == 0 ? 0 : ((currentPage - 1) * pageSize) + 1}" />
                    <c:set var="calculatedTo" value="${currentPage * pageSize}" />
                    <c:set var="showingTo" value="${calculatedTo > totalRecords ? totalRecords : calculatedTo}" />
                    <div class="vm-table-footer">
                        <span>Showing ${showingFrom} to ${showingTo} of ${totalRecords} vouchers</span>
                        <nav class="vm-pagination" aria-label="Voucher pagination">
                            <c:choose>
                                <c:when test="${currentPage <= 1}"><span class="vm-page disabled">&lsaquo;</span></c:when>
                                <c:otherwise><a class="vm-page" href="${baseUrl}&page=${currentPage - 1}" aria-label="Previous page">&lsaquo;</a></c:otherwise>
                            </c:choose>
                            <c:set var="startPage" value="${currentPage - 2}" />
                            <c:if test="${startPage < 1}"><c:set var="startPage" value="1" /></c:if>
                            <c:set var="endPage" value="${startPage + 4}" />
                            <c:if test="${endPage > totalPages}">
                                <c:set var="endPage" value="${totalPages}" />
                                <c:set var="startPage" value="${endPage - 4}" />
                                <c:if test="${startPage < 1}"><c:set var="startPage" value="1" /></c:if>
                            </c:if>
                            <c:forEach begin="${startPage}" end="${endPage}" var="pageNumber">
                                <c:choose>
                                    <c:when test="${pageNumber == currentPage}"><span class="vm-page active">${pageNumber}</span></c:when>
                                    <c:otherwise><a class="vm-page" href="${baseUrl}&page=${pageNumber}">${pageNumber}</a></c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${currentPage >= totalPages}"><span class="vm-page disabled">&rsaquo;</span></c:when>
                                <c:otherwise><a class="vm-page" href="${baseUrl}&page=${currentPage + 1}" aria-label="Next page">&rsaquo;</a></c:otherwise>
                            </c:choose>
                        </nav>
                    </div>
                </section>

                <section class="vm-stats" aria-label="Voucher statistics">
                    <div class="vm-stat">
                        <span class="vm-stat-icon total"><span class="material-symbols-outlined">confirmation_number</span></span>
                        <div><p class="vm-stat-value">${not empty totalVouchers ? totalVouchers : 0}</p><p class="vm-stat-label">Total Vouchers</p></div>
                    </div>
                    <div class="vm-stat">
                        <span class="vm-stat-icon active"><span class="material-symbols-outlined">check_circle</span></span>
                        <div><p class="vm-stat-value">${not empty activeVouchers ? activeVouchers : 0}</p><p class="vm-stat-label">Active Vouchers</p></div>
                    </div>
                    <div class="vm-stat">
                        <span class="vm-stat-icon expired"><span class="material-symbols-outlined">schedule</span></span>
                        <div><p class="vm-stat-value">${not empty expiredVouchers ? expiredVouchers : 0}</p><p class="vm-stat-label">Expired Vouchers</p></div>
                    </div>
                    <div class="vm-stat">
                        <span class="vm-stat-icon used"><span class="material-symbols-outlined">redeem</span></span>
                        <div><p class="vm-stat-value">${not empty totalUsed ? totalUsed : 0}</p><p class="vm-stat-label">Total Uses</p></div>
                    </div>
                </section>
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
                const now = new Date();
                const year = now.getFullYear();
                const month = String(now.getMonth() + 1).padStart(2, '0');
                const day = String(now.getDate()).padStart(2, '0');
                return year + '-' + month + '-' + day;
            }

            function clearVoucherFieldError(fieldName) {
                const field = document.getElementById('voucherForm').elements.namedItem(fieldName);
                const message = document.querySelector('[data-error-for="' + fieldName + '"]');
                if (field) {
                    field.classList.remove('voucher-field-error');
                    field.removeAttribute('aria-invalid');
                }
                if (message) {
                    message.textContent = '';
                    message.classList.add('hidden');
                }
            }

            function clearVoucherErrors() {
                document.querySelectorAll('#voucherForm [data-error-for]').forEach(function (message) {
                    clearVoucherFieldError(message.dataset.errorFor);
                });
                const formError = document.getElementById('voucherFormError');
                formError.textContent = '';
                formError.classList.add('hidden');
            }

            function setVoucherFieldError(fieldName, message) {
                const field = document.getElementById('voucherForm').elements.namedItem(fieldName);
                const messageElement = document.querySelector('[data-error-for="' + fieldName + '"]');
                if (!field || !messageElement) {
                    showVoucherFormError(message);
                    return;
                }
                field.classList.add('voucher-field-error');
                field.setAttribute('aria-invalid', 'true');
                messageElement.textContent = message;
                messageElement.classList.remove('hidden');
            }

            function showVoucherFormError(message) {
                const formError = document.getElementById('voucherFormError');
                formError.textContent = message;
                formError.classList.remove('hidden');
            }

            function focusFirstVoucherError() {
                const firstInvalidField = document.querySelector('#voucherForm .voucher-field-error');
                if (firstInvalidField) {
                    firstInvalidField.focus();
                    firstInvalidField.scrollIntoView({block: 'center', behavior: 'smooth'});
                }
            }

            function validateVoucherForm() {
                clearVoucherErrors();
                const form = document.getElementById('voucherForm');
                const action = document.getElementById('formAction').value;
                const code = form.elements.namedItem('code').value.trim();
                const discountRaw = form.elements.namedItem('discountPercent').value.trim();
                const quantityRaw = form.elements.namedItem('quantity').value.trim();
                const minOrderRaw = form.elements.namedItem('minOrderValue').value.trim();
                const maxDiscountRaw = form.elements.namedItem('maxDiscountValue').value.trim();
                const startDate = form.elements.namedItem('startDate').value;
                const endDate = form.elements.namedItem('endDate').value;
                let valid = true;

                if (!code) {
                    setVoucherFieldError('code', 'Voucher code is required.');
                    valid = false;
                }

                if (!discountRaw) {
                    setVoucherFieldError('discountPercent', 'Discount is required.');
                    valid = false;
                } else {
                    const discount = Number(discountRaw);
                    if (!Number.isFinite(discount) || discount <= 0 || discount > 100) {
                        setVoucherFieldError('discountPercent', 'Discount must be greater than 0 and no more than 100%.');
                        valid = false;
                    }
                }

                if (quantityRaw) {
                    const quantity = Number(quantityRaw);
                    if (!Number.isInteger(quantity) || quantity <= 0) {
                        setVoucherFieldError('quantity', 'Quantity must be a whole number greater than 0.');
                        valid = false;
                    }
                }

                if (minOrderRaw) {
                    const minOrder = Number(minOrderRaw);
                    if (!Number.isFinite(minOrder) || minOrder < 0) {
                        setVoucherFieldError('minOrderValue', 'Minimum order value cannot be negative.');
                        valid = false;
                    }
                }

                if (maxDiscountRaw) {
                    const maxDiscount = Number(maxDiscountRaw);
                    if (!Number.isFinite(maxDiscount) || maxDiscount <= 0) {
                        setVoucherFieldError('maxDiscountValue', 'Maximum discount must be greater than 0.');
                        valid = false;
                    }
                }

                if (action === 'add' && startDate && startDate < todayStr()) {
                    setVoucherFieldError('startDate', 'Start date cannot be in the past.');
                    valid = false;
                }

                if (startDate && endDate && startDate >= endDate) {
                    setVoucherFieldError('endDate', 'End date must be after the start date.');
                    valid = false;
                }

                if (!valid) {
                    focusFirstVoucherError();
                }
                return valid;
            }

            // ---- Modal: TẠO MỚI ----
            function openModal() {
                document.getElementById('modalTitle').textContent = 'Add New Voucher';
                document.getElementById('formAction').value = 'add';
                document.getElementById('formVoucherID').value = '';
                document.getElementById('voucherForm').reset();
                clearVoucherErrors();
                document.getElementById('voucherSubmitButton').textContent = 'Create';

                // Giới hạn startDate không được chọn quá khứ
                document.getElementById('inputStartDate').min = todayStr();
                document.getElementById('inputEndDate').min   = todayStr();

                // Ẩn toggle trạng thái — tạo mới luôn active
                document.getElementById('statusSection').classList.add('hidden');

                updatePreview();
                document.getElementById('voucherModal').classList.remove('hidden');
                window.setTimeout(function () { document.getElementById('inputCode').focus(); }, 0);
            }

            // ---- Modal: CHỈNH SỬA ----
            function openEditModal(id, code, discount, quantity, startDate, endDate, status, minOrder, maxDisc) {
                document.getElementById('modalTitle').textContent = 'Edit Voucher';
                document.getElementById('formAction').value = 'edit';
                document.getElementById('formVoucherID').value = id;
                clearVoucherErrors();
                document.getElementById('voucherSubmitButton').textContent = 'Save Changes';
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
                document.getElementById('inputStatus').value = isActive ? 'active' : 'inactive';

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
                clearVoucherFieldError('code');
                updatePreview();
            }

            // ---- Copy ----
            function copyCode(code) {
                navigator.clipboard.writeText(code).then(() => showToast('Copied code: ' + code));
            }

            // ---- Toggle style (chỉ dùng khi edit) ----
            document.querySelectorAll('#voucherForm input:not([type="hidden"])').forEach(function (field) {
                const clearCurrentError = function () {
                    clearVoucherFieldError(field.name);
                    document.getElementById('voucherFormError').classList.add('hidden');
                    if (field.name === 'startDate' || field.name === 'endDate') {
                        clearVoucherFieldError('startDate');
                        clearVoucherFieldError('endDate');
                    }
                };
                field.addEventListener('input', clearCurrentError);
                field.addEventListener('change', clearCurrentError);
            });

            document.getElementById('voucherForm').addEventListener('submit', function (event) {
                if (!validateVoucherForm()) {
                    event.preventDefault();
                    return;
                }

                const submitButton = document.getElementById('voucherSubmitButton');
                submitButton.disabled = true;
                submitButton.textContent = document.getElementById('formAction').value === 'add'
                        ? 'Creating...'
                        : 'Saving...';
            });

        </script>
    </body>
</html>

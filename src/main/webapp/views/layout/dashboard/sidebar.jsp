<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String currentPage = (String) request.getAttribute("jakarta.servlet.forward.request_uri");
    if (currentPage == null || currentPage.isEmpty()) {
        currentPage = request.getRequestURI();
    }

    String sidebarContextPath = request.getContextPath();
    String sidebarCurrentPath = currentPage;
    if (sidebarContextPath != null
            && !sidebarContextPath.isEmpty()
            && sidebarCurrentPath.startsWith(sidebarContextPath)) {
        sidebarCurrentPath = sidebarCurrentPath.substring(sidebarContextPath.length());
    }

    int jsessionIndex = sidebarCurrentPath.indexOf(';');
    if (jsessionIndex >= 0) {
        sidebarCurrentPath = sidebarCurrentPath.substring(0, jsessionIndex);
    }

    while (sidebarCurrentPath.length() > 1 && sidebarCurrentPath.endsWith("/")) {
        sidebarCurrentPath = sidebarCurrentPath.substring(0, sidebarCurrentPath.length() - 1);
    }

    boolean isDashboardPage = "/dashboard".equals(sidebarCurrentPath);
    model.Account sidebarUser = (model.Account) session.getAttribute("account");
    String sidebarRole = "";
    String sidebarName = "";
    if (sidebarUser != null) {
        sidebarName = sidebarUser.getFullname();
        if ("admin".equals(sidebarUser.getRole())) {
            sidebarRole = "Administrator";
        } else if ("staff".equals(sidebarUser.getRole())) {
            sidebarRole = "Staff";
        } else {
            sidebarRole = sidebarUser.getRole();
        }
    }
    boolean isStaffUser = sidebarUser != null && "staff".equals(sidebarUser.getRole());
    boolean isAdminUser = sidebarUser != null && "admin".equals(sidebarUser.getRole());
    boolean isStaffOrAdmin = isStaffUser || isAdminUser;
%>

<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400..800&amp;display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/admin.css" rel="stylesheet">
<style>
    /* ===== Fahasa-inspired admin theme overrides ===== */
    body.hs-admin-page { font-family: 'Be Vietnam Pro', sans-serif; background:#F7F7F8; }
    .hs-admin-mobile-bar {
        display: none; align-items: center; justify-content: space-between;
        background: #C92127; color: #fff; padding: 12px 16px;
    }
    .hs-admin-sidebar {
        background: #ffffff; border-right: 1px solid #E3E3E6;
        width: 256px; min-height: 100vh; display: flex; flex-direction: column;
    }
    .hs-admin-brand { padding: 18px 20px; border-bottom: 3px solid #C92127; }
    .hs-admin-brand img { width: 205px; max-width: 100%; height: auto; }
    .hs-admin-quick-action {
        margin: 14px 16px 0; background: #C92127; color: #fff; text-decoration: none;
        display: flex; align-items: center; justify-content: center; gap: 6px;
        padding: 10px; border-radius: 8px; font-weight: 700; font-size: 13.5px;
        transition: background .15s;
    }
    .hs-admin-quick-action:hover { background: #8E171B; }
    .hs-admin-nav { display: flex; flex-direction: column; gap: 2px; padding: 16px 12px; flex: 1; }
    .sidebar-link {
        display: flex; align-items: center; gap: 12px; padding: 10px 14px;
        border-radius: 8px; color: #5C5C5F; text-decoration: none; font-size: 14px; font-weight: 500;
        transition: background .15s, color .15s;
    }
    .sidebar-link:hover { background: #FDE8E9; color: #C92127; }
    .sidebar-link.active { background: #C92127; color: #fff; font-weight: 700; }
    .hs-admin-user-area { border-top: 1px solid #E3E3E6; padding: 12px; position: relative; }
    .user-trigger { display: flex; align-items: center; gap: 10px; padding: 8px; border-radius: 8px; cursor: pointer; }
    .user-trigger:hover { background: #F7F7F8; }
    .hs-admin-user-role { color: #8F8F92; }
    .user-popup {
        display: none; position: absolute; bottom: 64px; left: 12px; right: 12px;
        background: #fff; border: 1px solid #E3E3E6; border-radius: 10px;
        box-shadow: 0 10px 30px rgba(0,0,0,.12); overflow: hidden;
    }
    .user-popup.open { display: block; }
    .user-popup a { display: flex; align-items: center; gap: 10px; padding: 10px 14px; color: #1B1B1B; text-decoration: none; font-size: 13.5px; }
    .user-popup a:hover { background: #F7F7F8; }
    .user-popup a.danger { color: #D32F2F; }
    .user-popup .divider { border-top: 1px solid #E3E3E6; }
    @media (max-width: 767px) {
        .hs-admin-mobile-bar { display: flex; }
        .hs-admin-sidebar {
            position: fixed; top: 0; left: -280px; z-index: 100; transition: left .2s;
            box-shadow: 4px 0 20px rgba(0,0,0,.15);
        }
        .hs-admin-sidebar.open { left: 0; }
        .hs-admin-overlay {
            display: none; position: fixed; inset: 0; background: rgba(0,0,0,.4); z-index: 90;
        }
        .hs-admin-overlay.open { display: block; }
    }
</style>

<div class="hs-admin-mobile-bar" aria-label="Admin navigation">
    <button type="button" id="adminMenuButton" aria-label="Open navigation" aria-controls="adminSidebar" aria-expanded="false">
        <span class="material-symbols-outlined">menu</span>
    </button>
    <strong style="font-family:'Be Vietnam Pro',Georgia,serif;">HeavenScape Admin</strong>
    <span class="material-symbols-outlined" aria-hidden="true">auto_stories</span>
</div>
<div class="hs-admin-overlay" id="adminSidebarOverlay"></div>

<aside class="hs-admin-sidebar" id="adminSidebar">
    <div class="hs-admin-brand">
        <a href="${pageContext.request.contextPath}/dashboard" class="flex items-center gap-3">
            <img src="${pageContext.request.contextPath}/assets/images/logo/logoHS_2.png"
                 alt="HeavenScape Logo"
                 class="object-contain"/>
        </a>
    </div>

    <nav class="hs-admin-nav">

        <a href="${pageContext.request.contextPath}/dashboard"
           class="sidebar-link <%= isDashboardPage ? "active" : ""%>">
            <span class="material-symbols-outlined">monitoring</span>
            Dashboard
        </a>

        <c:choose><c:when test="${sessionScope.account.role == 'staff'}">
        <a href="${pageContext.request.contextPath}/dashboard/customer-order"
           class="sidebar-link <%= currentPage.contains("customer-order") ? "active" : ""%>">
            <span class="material-symbols-outlined">local_mall</span>
            Orders
        </a>
        </c:when></c:choose>

        <% if (isStaffUser) {
                boolean khoHangActive = "product-management".equals(request.getAttribute("activeMenu"))
                        || currentPage.contains("product-management");
        %>
        <a href="${pageContext.request.contextPath}/dashboard/product-management"
           class="sidebar-link <%= khoHangActive ? "active" : ""%>">
            <span class="material-symbols-outlined">warehouse</span>
            Inventory
        </a>
        <% } %>



        <% if (isStaffUser) { %>
        <a href="${pageContext.request.contextPath}/dashboard/genre-management"
           class="sidebar-link <%= sidebarCurrentPath.startsWith("/dashboard/genre-management") ? "active" : ""%>">
            <span class="material-symbols-outlined">account_tree</span>
            Genre
        </a>
        <% } %>

        <% if (isStaffOrAdmin) { %>
        <a href="${pageContext.request.contextPath}/dashboard/account-management"
           class="sidebar-link <%= currentPage.contains("account-management") ? "active" : ""%>">
            <span class="material-symbols-outlined">manage_accounts</span>
            Account
        </a>

        <a href="${pageContext.request.contextPath}/dashboard/review-management"
           class="sidebar-link <%= currentPage.contains("review") ? "active" : ""%>">
            <span class="material-symbols-outlined">reviews</span>
            Review
        </a>
        <% } %>

        <% if (isStaffUser) { %>
        <a href="${pageContext.request.contextPath}/dashboard/voucher-management"
           class="sidebar-link <%= currentPage.contains("voucher") ? "active" : ""%>">
            <span class="material-symbols-outlined">confirmation_number</span>
            Voucher
        </a>
        <% } %>

    </nav>


    <div class="hs-admin-user-area">
        <div class="user-popup" id="userPopup">
            <a href="${pageContext.request.contextPath}/dashboard/profile">
                <span class="material-symbols-outlined" style="font-size:18px;">
                    manage_accounts
                </span>
                Personal Profile
            </a>
            <a href="${pageContext.request.contextPath}/dashboard/profile/change-password">
                <span class="material-symbols-outlined" style="font-size:18px;">
                    lock_reset
                </span>
                Change Password
            </a>
            <div class="divider"></div>
            <a href="${pageContext.request.contextPath}/logout" class="danger">
                <span class="material-symbols-outlined"
                      style="font-size:18px; color:#D32F2F;">
                    logout
                </span>
                Log Out
            </a>
        </div>

        <div class="user-trigger" id="userTrigger" onclick="toggleUserPopup()" role="button" tabindex="0" aria-expanded="false" aria-controls="userPopup">
            <div class="flex-1 min-w-0">
                <p class="hs-admin-user-name text-sm font-semibold truncate">
                    <%= sidebarName.isEmpty() ? "User" : sidebarName%>
                </p>
                <p class="hs-admin-user-role text-xs truncate">
                    <%= sidebarRole%>
                </p>
            </div>

            <span class="material-symbols-outlined text-sm hs-admin-user-role"
                  style="font-size: 18px;"
                  id="userChevron">
                expand_less
            </span>
        </div>
    </div>

</aside>

<script>
    document.body.classList.add('hs-admin-page');

    function toggleUserPopup() {
        const popup = document.getElementById('userPopup');
        const chevron = document.getElementById('userChevron');
        const trigger = document.getElementById('userTrigger');

        popup.classList.toggle('open');
        trigger.setAttribute('aria-expanded', popup.classList.contains('open'));
        chevron.textContent =
                popup.classList.contains('open')
                ? 'expand_less'
                : 'expand_more';
    }

    document.addEventListener('click', function (e) {
        const trigger = document.getElementById('userTrigger');
        const popup = document.getElementById('userPopup');

        if (!trigger.contains(e.target) && !popup.contains(e.target)) {
            popup.classList.remove('open');
            trigger.setAttribute('aria-expanded', 'false');
            document.getElementById('userChevron').textContent = 'expand_more';
        }
    });

    document.getElementById('userTrigger').addEventListener('keydown', function (event) {
        if (event.key === 'Enter' || event.key === ' ') {
            event.preventDefault();
            toggleUserPopup();
        }
    });

    (function () {
        const button = document.getElementById('adminMenuButton');
        const sidebar = document.getElementById('adminSidebar');
        const overlay = document.getElementById('adminSidebarOverlay');

        function setMenu(open) {
            sidebar.classList.toggle('open', open);
            overlay.classList.toggle('open', open);
            button.setAttribute('aria-expanded', String(open));
            document.body.style.overflow = open ? 'hidden' : '';
        }

        button.addEventListener('click', function () {
            setMenu(!sidebar.classList.contains('open'));
        });
        overlay.addEventListener('click', function () { setMenu(false); });
        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') {
                setMenu(false);
                document.getElementById('userPopup').classList.remove('open');
            }
        });
    })();
</script>

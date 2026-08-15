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

<link href="https://fonts.googleapis.com/css2?family=Source+Serif+4:opsz,wght@8..60,400..700&amp;family=Hanken+Grotesk:wght@400..700&amp;display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/admin.css" rel="stylesheet">

<div class="hs-admin-mobile-bar" aria-label="Admin navigation">
    <button type="button" id="adminMenuButton" aria-label="Open navigation" aria-controls="adminSidebar" aria-expanded="false">
        <span class="material-symbols-outlined">menu</span>
    </button>
    <strong style="font-family:'Source Serif 4',Georgia,serif;">HeavenScape Admin</strong>
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

    <% if (isStaffUser) { %>
    <a class="hs-admin-quick-action" href="${pageContext.request.contextPath}/dashboard/product-management?action=create">
        <span class="material-symbols-outlined" style="font-size:19px;">add</span>
        New Listing
    </a>
    <% } %>

    <nav class="hs-admin-nav">

        <a href="${pageContext.request.contextPath}/dashboard"
           class="sidebar-link <%= isDashboardPage ? "active" : ""%>">
            <span class="material-symbols-outlined">dashboard</span>
            Dashboard
        </a>

        <c:choose><c:when test="${sessionScope.account.role == 'staff'}">
        <a href="${pageContext.request.contextPath}/dashboard/customer-order"
           class="sidebar-link <%= currentPage.contains("customer-order") ? "active" : ""%>">
            <span class="material-symbols-outlined">shopping_cart</span>
            Orders
        </a>
        </c:when></c:choose>

        <% if (isStaffUser) {
                boolean khoHangActive = "product-management".equals(request.getAttribute("activeMenu"))
                        || currentPage.contains("product-management");
        %>
        <a href="${pageContext.request.contextPath}/dashboard/product-management"
           class="sidebar-link <%= khoHangActive ? "active" : ""%>">
            <span class="material-symbols-outlined">inventory_2</span>
            Inventory
        </a>
        <% } %>



        <% if (isStaffUser) { %>
        <a href="${pageContext.request.contextPath}/dashboard/category-management"
           class="sidebar-link <%= sidebarCurrentPath.startsWith("/dashboard/category-management") ? "active" : ""%>">
            <span class="material-symbols-outlined">category</span>
            Genre
        </a>
        <% } %>

        <% if (isStaffOrAdmin) { %>
        <a href="${pageContext.request.contextPath}/dashboard/account-management"
           class="sidebar-link <%= currentPage.contains("account-management") ? "active" : ""%>">
            <span class="material-symbols-outlined">group</span>
            Account
        </a>

        <a href="${pageContext.request.contextPath}/dashboard/review-management"
           class="sidebar-link <%= currentPage.contains("review") ? "active" : ""%>">
            <span class="material-symbols-outlined">rate_review</span>
            Review
        </a>
        <% } %>

        <% if (isStaffUser) { %>
        <a href="${pageContext.request.contextPath}/dashboard/voucher-management"
           class="sidebar-link <%= currentPage.contains("voucher") ? "active" : ""%>">
            <span class="material-symbols-outlined">sell</span>
            Voucher
        </a>
        <% } %>

    </nav>


    <div class="hs-admin-user-area">
        <div class="user-popup" id="userPopup">
            <a href="${pageContext.request.contextPath}/profile">
                <span class="material-symbols-outlined" style="font-size:18px;">
                    manage_accounts
                </span>
                Personal Profile
            </a>
            <a href="${pageContext.request.contextPath}/profile/change-password">
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

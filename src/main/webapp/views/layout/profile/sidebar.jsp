<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    body { background:#f2f4f5; }
    .profile-card { background:#fff; border-radius:8px; border:0; box-shadow:0 2px 8px rgba(0,0,0,.07); }
    .menu-item { display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:5px; transition:.18s; text-decoration:none; color:#555; font-size:13px; }
    .menu-item:hover { background:#f7f7f7; color:#c92127; }
    .menu-active { background:#fff0f1; color:#c92127; font-weight:700; }
    .profile-sidebar { min-width:0; }
    .profile-default-avatar {
        width:80px;
        height:80px;
        display:flex;
        align-items:center;
        justify-content:center;
        border-radius:999px;
        background:#fff0f1;
        color:#c92127;
        border:2px solid #ffe1e3;
    }
    .profile-default-avatar .material-symbols-outlined {
        font-size:52px;
        line-height:1;
    }
</style>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
<div class="profile-sidebar">
    <div class="profile-card p-5">
        <div class="flex flex-col items-center">
            <div class="profile-default-avatar" aria-hidden="true">
                <span class="material-symbols-outlined">account_circle</span>
            </div>
            <h2 class="mt-3 text-base font-bold text-center">
                ${sessionScope.account.fullname}
            </h2>
            <div class="mt-2 px-3 py-1 rounded-full bg-[#fff5df] text-[#9a5c00] text-xs">
                ${sessionScope.account.role}
            </div>
        </div>
        <hr class="my-4">
        <nav class="space-y-2">
            <a href="${pageContext.request.contextPath}/profile?id=${sessionScope.account.id}"
               class="menu-item ${activeMenu == 'profile' ? 'menu-active' : ''}">
                <span class="material-symbols-outlined">person</span>
                Personal Information
            </a>
            <a href="${pageContext.request.contextPath}/profile/order-history"
               class="menu-item ${activeMenu == 'orders' ? 'menu-active' : ''}">
                <span class="material-symbols-outlined">receipt_long</span>
                Order History
            </a>
            <a href="${pageContext.request.contextPath}/profile/change-password"
               class="menu-item ${activeMenu == 'password' ? 'menu-active' : ''}">
                <span class="material-symbols-outlined">lock</span>
                Change Password
            </a>
            <a href="${pageContext.request.contextPath}/profile/address"
               class="menu-item ${activeMenu == 'address' ? 'menu-active' : ''}">
                <span class="material-symbols-outlined">location_on</span>
                My Addresses
            </a>
            <a href="${pageContext.request.contextPath}/logout"
               class="menu-item text-red-600">
                <span class="material-symbols-outlined">logout</span>
                Log Out
            </a>
        </nav>
    </div>
</div>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    body {
        background: #f3faff;
    }
    .profile-card {
        background: #fff;
        border-radius: 16px;
        border: 1px solid #dbeafe;
        box-shadow: 0 2px 10px rgba(0, 0, 0, .05);
    }
    .menu-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 16px;
        border-radius: 12px;
        transition: .2s;
        text-decoration: none;
    }
    .menu-item:hover {
        background: #eff6ff;
    }
    .menu-active {
        background: #dbeafe;
        color: #2563eb;
        font-weight: 600;
    }
</style>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
<div class="lg:col-span-1">
    <div class="profile-card p-6">
        <div class="flex flex-col items-center">
            <div class="relative">
                <img
                    src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
                    class="w-24 h-24 rounded-full border-4 border-blue-200 shadow"
                    alt="Avatar">
            </div>
            <h2 class="mt-4 text-xl font-bold text-center">
                ${sessionScope.account.fullname}
            </h2>
            <div class="mt-2 px-3 py-1 rounded-full bg-yellow-100 text-yellow-700 text-sm">
                ${sessionScope.account.role}
            </div>
        </div>
        <hr class="my-6">
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
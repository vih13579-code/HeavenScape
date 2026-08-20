<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#C92127">
    <title>HeavenScape - Online Bookstore</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "surface-container-lowest": "#FFFFFF",
                        "inverse-on-surface": "#F5F5F5",
                        "inverse-surface": "#303030",
                        "error-container": "#FFDAD6",
                        "tertiary-fixed-dim": "#F4C967",
                        "primary-container": "#FFF0F1",
                        "outline-variant": "#E5E5E5",
                        "surface": "#FFFFFF",
                        "on-surface-variant": "#777777",
                        "primary": "#C92127",
                        "primary-dark": "#A7191E",
                        "primary-light": "#E54A4F",
                        "on-primary-container": "#7A0F13",
                        "on-surface": "#333333",
                        "on-error-container": "#93000A",
                        "surface-container-highest": "#E8E8E8",
                        "tertiary-container": "#FFF5DF",
                        "tertiary": "#F39801",
                        "surface-variant": "#F1F1F1",
                        "primary-fixed": "#FFD9DB",
                        "primary-fixed-dim": "#FFB8BC",
                        "outline": "#999999",
                        "surface-dim": "#E9E9E9",
                        "surface-bright": "#FFFFFF",
                        "surface-container-low": "#F7F7F7",
                        "background": "#F2F4F5",
                        "error": "#D32F2F",
                        "secondary-container": "#FFF0D5",
                        "tertiary-fixed": "#FFE9A8",
                        "secondary": "#F39801",
                        "on-secondary": "#FFFFFF",
                        "on-tertiary": "#402D00",
                        "inverse-primary": "#FFB8BC",
                        "surface-container-high": "#ECECEC",
                        "on-primary": "#FFFFFF",
                        "surface-tint": "#C92127",
                        "surface-container": "#F1F1F1"
                    },
                    borderRadius: { DEFAULT: "0.375rem", lg: "0.5rem", xl: "0.75rem", full: "9999px" },
                    fontFamily: {
                        sans: ["Be Vietnam Pro", "sans-serif"],
                        "body-lg": ["Be Vietnam Pro"],
                        "label-sm": ["Be Vietnam Pro"],
                        "headline-sm": ["Be Vietnam Pro"],
                        "label-md": ["Be Vietnam Pro"],
                        "headline-md": ["Be Vietnam Pro"],
                        "body-md": ["Be Vietnam Pro"],
                        "display-lg-mobile": ["Be Vietnam Pro"],
                        "display-lg": ["Be Vietnam Pro"]
                    }
                }
            }
        };
    </script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <script>
        window.addEventListener('pageshow', function (event) {
            if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
                window.location.reload();
            }
        });
    </script>
</head>
<body class="bg-background text-on-background flex flex-col min-h-screen antialiased">

<div class="hs-promo-strip">
    <div class="hs-container hs-promo-inner">
        <div class="hs-promo-copy">
            <span class="material-symbols-outlined hs-ms-icon hs-ms-icon-sm">auto_awesome</span>
            <span>Read more, save more — discover new books every week</span>
        </div>
        <div class="hs-promo-meta">HeavenScape Bookstore • Support 1900 8386</div>
    </div>
</div>

<header class="hs-site-header">
    <div class="hs-container hs-header-inner">
        <a class="hs-brand" href="${pageContext.request.contextPath}/" aria-label="HeavenScape - Home">
            <img class="hs-brand-logo"
                 src="${pageContext.request.contextPath}/assets/images/logo/logoHS_2.png"
                 alt="HeavenScape Online Bookstore">
        </a>

        <div class="hs-search-wrap">
            <form action="${pageContext.request.contextPath}/products" method="get" class="hs-search" role="search">
                <input name="keyword" value="${param.keyword}"
                       placeholder="Search by book title, author..." type="search"
                       id="header-search" autocomplete="off" aria-label="Search books">
                <button type="submit" aria-label="Search">
                    <span class="material-symbols-outlined hs-ms-icon">search</span>
                </button>
            </form>
        </div>

        <div class="hs-header-actions">
            <a href="${pageContext.request.contextPath}/wishlist"
               class="hs-header-action hs-wishlist-action" aria-label="Wishlist">
                <span class="material-symbols-outlined hs-ms-icon">favorite</span>
                <span class="hs-header-action-label">Wishlist</span>
                <span class="wishlist-badge hs-badge <c:if test='${empty sessionScope.wishlistCount or sessionScope.wishlistCount == 0}'>hidden</c:if>">
                    ${empty sessionScope.wishlistCount ? 0 : sessionScope.wishlistCount}
                </span>
            </a>

            <a href="${pageContext.request.contextPath}/cart" class="hs-header-action" aria-label="Cart">
                <span class="material-symbols-outlined hs-ms-icon">shopping_cart</span>
                <span class="hs-header-action-label">Cart</span>
                <span id="cart-count" class="hs-badge">
                    <c:choose>
                        <c:when test="${sessionScope.cartCount > 0}">${sessionScope.cartCount}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </span>
            </a>

            <div class="relative group">
                <c:choose>
                    <c:when test="${not empty sessionScope.account}">
                        <button type="button" class="hs-header-action" aria-label="Open account menu">
                            <span class="material-symbols-outlined hs-ms-icon">person</span>
                            <span class="hs-user-copy">${sessionScope.account.fullname}</span>
                        </button>
                        <div class="hs-user-menu-panel absolute top-full right-0 mt-1 w-56 bg-white
                             opacity-0 invisible group-hover:opacity-100 group-hover:visible group-focus-within:opacity-100 group-focus-within:visible
                             transition-all z-[90] text-on-surface text-sm overflow-hidden">
                            <a href="${pageContext.request.contextPath}/profile?id=${sessionScope.account.id}"
                               class="flex items-center gap-3 px-4 py-3 hover:bg-surface-container-low">
                                <span class="material-symbols-outlined text-primary text-[18px]">person</span> My Account
                            </a>
                            <a href="${pageContext.request.contextPath}/profile/order-history"
                               class="flex items-center gap-3 px-4 py-3 hover:bg-surface-container-low">
                                <span class="material-symbols-outlined text-primary text-[18px]">inventory_2</span> Orders
                            </a>
                            <a href="${pageContext.request.contextPath}/wishlist"
                               class="flex items-center gap-3 px-4 py-3 hover:bg-surface-container-low">
                                <span class="material-symbols-outlined text-primary text-[18px]">favorite</span> Wishlist
                            </a>
                            <a href="${pageContext.request.contextPath}/logout"
                               class="flex items-center gap-3 px-4 py-3 border-t border-outline-variant text-error hover:bg-error-container/30">
                                <span class="material-symbols-outlined text-[18px]">logout</span> Log Out
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="hs-header-action" aria-label="Log In">
                            <span class="material-symbols-outlined hs-ms-icon">person</span>
                            <span class="hs-user-copy">Account</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</header>

<%@ include file="navbar.jsp" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="theme-color" content="#04162e">
        <title>HeavenScape - Your Online Book Paradise</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo/logoHS_3.png">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Hanken+Grotesk:wght@400;500;600;700&family=Source+Serif+4:opsz,wght@8..60,400;600;700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            "surface-container-lowest": "#ffffff",
                            "inverse-on-surface": "#f2f0f0",
                            "inverse-surface": "#303030",
                            "error-container": "#ffdad6",
                            "tertiary-fixed-dim": "#ffb4a8",
                            "primary-container": "#1a2b44",
                            "outline-variant": "#c5c6ce",
                            "surface": "#fbf9f8",
                            "on-surface-variant": "#44474d",
                            "primary": "#04162e",
                            "primary-dark": "#1a2b44",
                            "primary-light": "#374762",
                            "on-primary-container": "#8292b0",
                            "on-surface": "#1b1c1c",
                            "on-error-container": "#93000a",
                            "surface-container-highest": "#e4e2e2",
                            "tertiary-container": "#5b0503",
                            "tertiary": "#360000",
                            "surface-variant": "#e4e2e2",
                            "primary-fixed": "#d5e3ff",
                            "primary-fixed-dim": "#b6c7e7",
                            "outline": "#75777e",
                            "surface-dim": "#dbd9d9",
                            "surface-bright": "#fbf9f8",
                            "surface-container-low": "#f5f3f3",
                            "background": "#fbf9f8",
                            "error": "#ba1a1a",
                            "secondary-container": "#e1dfdb",
                            "tertiary-fixed": "#ffdad4",
                            "secondary": "#5e5e5b",
                            "on-secondary": "#ffffff",
                            "on-tertiary": "#ffffff",
                            "inverse-primary": "#b6c7e7",
                            "surface-container-high": "#eae8e7",
                            "on-primary": "#ffffff",
                            "surface-tint": "#4f5f7b",
                            "surface-container": "#efeded"
                        },
                        borderRadius: {
                            DEFAULT: "0.125rem",
                            lg: "0.25rem",
                            xl: "0.5rem",
                            full: "0.75rem"
                        },
                        spacing: {
                            gutter: "24px",
                            "container-max": "1280px",
                            unit: "8px",
                            "margin-mobile": "20px",
                            "margin-desktop": "64px"
                        },
                        fontFamily: {
                            sans: ["Hanken Grotesk", "sans-serif"],
                            "body-lg": ["Hanken Grotesk"],
                            "label-sm": ["Hanken Grotesk"],
                            "headline-sm": ["Source Serif 4"],
                            "label-md": ["Hanken Grotesk"],
                            "headline-md": ["Source Serif 4"],
                            "body-md": ["Hanken Grotesk"],
                            "display-lg-mobile": ["Source Serif 4"],
                            "display-lg": ["Source Serif 4"]
                        },
                        fontSize: {
                            "body-lg": ["18px", {lineHeight: "28px", fontWeight: "400"}],
                            "label-sm": ["12px", {lineHeight: "16px", fontWeight: "500"}],
                            "headline-sm": ["24px", {lineHeight: "32px", fontWeight: "600"}],
                            "label-md": ["14px", {lineHeight: "20px", letterSpacing: "0.05em", fontWeight: "600"}],
                            "headline-md": ["32px", {lineHeight: "40px", fontWeight: "600"}],
                            "body-md": ["16px", {lineHeight: "24px", fontWeight: "400"}],
                            "display-lg-mobile": ["32px", {lineHeight: "40px", letterSpacing: "-0.01em", fontWeight: "700"}],
                            "display-lg": ["48px", {lineHeight: "56px", letterSpacing: "-0.02em", fontWeight: "700"}]
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

        <header class="hs-site-header">
            <div class="hs-container hs-header-inner">
                <a class="hs-brand" href="${pageContext.request.contextPath}/" aria-label="HeavenScape - Home">
                    <img src="${pageContext.request.contextPath}/assets/images/logo/logoHS_1.png"
                         alt="HeavenScape">
                </a>

                <form action="${pageContext.request.contextPath}/products" method="get" class="hs-search" role="search">
                    <input name="keyword" value="${param.keyword}"
                           placeholder="Search books and authors..." type="search"
                           id="header-search" autocomplete="off" aria-label="Search books">
                    <button type="submit" aria-label="Search">
                        <i data-lucide="search" class="icon-lg"></i>
                    </button>
                </form>

                <div class="hs-header-actions">
                    <c:if test="${not empty sessionScope.account}">
                        <a href="${pageContext.request.contextPath}/wishlist"
                           class="hs-header-action hs-wishlist-action" aria-label="Wishlist">
                            <i data-lucide="heart" class="icon-lg"></i>
                            <span class="hs-header-action-label text-sm">Wishlist</span>
                            <span class="wishlist-badge hs-badge <c:if test='${empty sessionScope.wishlistCount or sessionScope.wishlistCount == 0}'>hidden</c:if>">
                                ${empty sessionScope.wishlistCount ? 0 : sessionScope.wishlistCount}
                            </span>
                        </a>
                    </c:if>

                    <div class="relative group">
                        <c:choose>
                            <c:when test="${not empty sessionScope.account}">
                                <button type="button" class="hs-header-action" aria-label="Open account menu">
                                    <i data-lucide="user" class="icon-lg"></i>
                                    <span class="hs-user-copy hidden xl:block max-w-[120px] truncate text-sm font-semibold">
                                        ${sessionScope.account.fullname}
                                    </span>
                                    <i data-lucide="chevron-down" class="hidden xl:block w-4 h-4"></i>
                                </button>
                                <div class="hs-user-menu-panel absolute top-full right-0 mt-2 w-56 bg-white rounded-lg
                                     opacity-0 invisible group-hover:opacity-100 group-hover:visible group-focus-within:opacity-100 group-focus-within:visible
                                     transition-all z-[90] text-on-surface text-sm overflow-hidden">
                                    <a href="${pageContext.request.contextPath}/profile?id=${sessionScope.account.id}"
                                       class="flex items-center gap-3 px-4 py-3 hover:bg-surface-container-low">
                                        <i data-lucide="user" class="w-4 h-4 text-primary"></i> My Account
                                    </a>
                                    <a href="${pageContext.request.contextPath}/profile/order-history"
                                       class="flex items-center gap-3 px-4 py-3 hover:bg-surface-container-low">
                                        <i data-lucide="package" class="w-4 h-4 text-primary"></i> Orders
                                    </a>
                                    <a href="${pageContext.request.contextPath}/wishlist"
                                       class="flex items-center gap-3 px-4 py-3 hover:bg-surface-container-low">
                                        <i data-lucide="heart" class="w-4 h-4 text-primary"></i> Wishlist
                                    </a>
                                    <a href="${pageContext.request.contextPath}/logout"
                                       class="flex items-center gap-3 px-4 py-3 border-t border-outline-variant text-error hover:bg-error-container/30">
                                        <i data-lucide="log-out" class="w-4 h-4"></i> Log Out
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="hs-header-action" aria-label="Log In">
                                    <i data-lucide="user" class="icon-lg"></i>
                                    <span class="hs-user-copy hidden xl:flex flex-col leading-tight text-left">
                                        <strong class="text-sm">Log In</strong>
                                        <span class="text-[11px] text-primary-fixed">Account</span>
                                    </span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <a href="${pageContext.request.contextPath}/cart"
                       class="hs-header-action" aria-label="Cart">
                        <i data-lucide="shopping-cart" class="icon-lg"></i>
                        <span class="hs-header-action-label hidden xl:inline text-sm">Cart</span>
                        <span id="cart-count" class="hs-badge">
                            <c:choose>
                                <c:when test="${sessionScope.cartCount > 0}">${sessionScope.cartCount}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </span>
                    </a>
                </div>
            </div>
        </header>

        <%@ include file="navbar.jsp" %>

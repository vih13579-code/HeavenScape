<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Dashboard - HeavenScape Admin</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {extend: {
                        colors: {
                            "primary": "#004d99", "primary-container": "#1565c0",
                            "secondary-container": "#fdd835", "secondary": "#705d00",
                            "background": "#f3faff", "surface": "#ffffff",
                            "on-surface": "#071e27", "on-surface-variant": "#424752",
                            "outline-variant": "#c2c6d4", "success": "#2E7D32",
                            "error": "#D32F2F", "warning": "#FFA000",
                            "error-container": "#ffdad6", "primary-fixed": "#d6e3ff",
                            "surface-container-low": "#e6f6ff", "background-alt": "#F5F7F9"
                        },
                        fontFamily: {sans: ["Inter", "sans-serif"]}
                    }}
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

            /* Stat card hover */
            .stat-card {
                background: #fff;
                border: 1px solid #e0ecf8;
                border-radius: 18px;
                padding: 22px 24px;
                display: flex;
                align-items: center;
                gap: 18px;
                transition: box-shadow .2s, transform .2s;
                cursor: default;
            }
            .stat-card:hover {
                box-shadow: 0 8px 28px rgba(0,77,153,.11);
                transform: translateY(-2px);
            }
            .stat-icon {
                width: 52px;
                height: 52px;
                border-radius: 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
            }

            /* Quick action card */
            .action-card {
                background: #fff;
                border: 1px solid #e0ecf8;
                border-radius: 16px;
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 10px;
                text-align: center;
                text-decoration: none;
                color: #071e27;
                transition: box-shadow .2s, transform .2s, background .2s;
            }
            .action-card:hover {
                box-shadow: 0 6px 22px rgba(0,77,153,.13);
                transform: translateY(-3px);
                background: #f0f8ff;
                color: #004d99;
            }
            .action-card .action-icon {
                width: 48px;
                height: 48px;
                border-radius: 13px;
                background: #e6f6ff;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            /* Table row hover */
            .book-row:hover {
                background: #f0f8ff;
            }

            /* Status badge */
            .badge-available    {
                background:#dcfce7;
                color:#166534;
                font-size:11px;
                font-weight:700;
                padding:3px 9px;
                border-radius:20px;
            }
            .badge-out_of_stock {
                background:#fef9c3;
                color:#854d0e;
                font-size:11px;
                font-weight:700;
                padding:3px 9px;
                border-radius:20px;
            }
            .badge-discontinued {
                background:#fee2e2;
                color:#991b1b;
                font-size:11px;
                font-weight:700;
                padding:3px 9px;
                border-radius:20px;
            }

            /* Progress bar */
            .progress-bar {
                height: 6px;
                border-radius: 99px;
                background: #e6f0ff;
                overflow: hidden;
                margin-top: 8px;
            }
            .progress-fill {
                height: 100%;
                border-radius: 99px;
                transition: width .6s ease;
            }
        </style>
    </head>
    <body class="bg-background text-on-surface flex min-h-screen">

        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <%@ include file="/views/layout/common/toast.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen p-6">
            <div class="max-w-[1200px] mx-auto space-y-7">

                <%-- ═══ HEADER ═══ --%>
                <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
                    <div>
                        <h1 class="text-2xl font-bold text-on-surface">🏠 Dashboard</h1>
                        <p class="text-sm text-on-surface-variant mt-1">
                            Welcome Back, <strong>${sessionScope.account.fullname}</strong>!
                            Here is an overview of the HeavenScape system.
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/dashboard/product-management?action=create"
                       class="inline-flex items-center gap-2 bg-primary text-white px-5 py-2.5 rounded-xl font-semibold hover:opacity-90 transition-opacity whitespace-nowrap text-sm">
                        <span class="material-symbols-outlined" style="font-size:19px">add</span>
                        Add New Book
                    </a>
                </div>

                <%-- ═══ STATS CARDS ═══ --%>
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">

                    <%-- Total Books --%>
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#dbeafe;">
                            <span class="material-symbols-outlined" style="color:#1d4ed8; font-size:26px;">library_books</span>
                        </div>
                        <div class="min-w-0">
                            <p class="text-xs font-semibold text-on-surface-variant uppercase tracking-wide">Total Books</p>
                            <p class="text-3xl font-bold text-on-surface mt-0.5">${totalBooks}</p>
                            <p class="text-xs text-on-surface-variant mt-0.5">All Statuses</p>
                        </div>
                    </div>

                    <%-- Available --%>
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#dcfce7;">
                            <span class="material-symbols-outlined" style="color:#16a34a; font-size:26px;">sell</span>
                        </div>
                        <div class="min-w-0">
                            <p class="text-xs font-semibold text-on-surface-variant uppercase tracking-wide">Available</p>
                            <p class="text-3xl font-bold text-success mt-0.5">${availableBooks}</p>
                            <div class="progress-bar">
                                <div class="progress-fill" style="background:#16a34a; width:<c:if test="${totalBooks > 0}">${availableBooks * 100 / totalBooks}</c:if><c:if test="${totalBooks == 0}">0</c:if>%;"></div>
                                </div>
                            </div>
                        </div>

                    <%-- Out of Stock --%>
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#fef9c3;">
                            <span class="material-symbols-outlined" style="color:#ca8a04; font-size:26px;">inventory</span>
                        </div>
                        <div class="min-w-0">
                            <p class="text-xs font-semibold text-on-surface-variant uppercase tracking-wide">Out of Stock</p>
                            <p class="text-3xl font-bold text-warning mt-0.5">${outOfStockBooks}</p>
                            <div class="progress-bar">
                                <div class="progress-fill" style="background:#ca8a04; width:<c:if test="${totalBooks > 0}">${outOfStockBooks * 100 / totalBooks}</c:if><c:if test="${totalBooks == 0}">0</c:if>%;"></div>
                                </div>
                            </div>
                        </div>

                    <%-- Discontinued --%>
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#fee2e2;">
                            <span class="material-symbols-outlined" style="color:#dc2626; font-size:26px;">block</span>
                        </div>
                        <div class="min-w-0">
                            <p class="text-xs font-semibold text-on-surface-variant uppercase tracking-wide">Discontinued</p>
                            <p class="text-3xl font-bold text-error mt-0.5">${discontinuedBooks}</p>
                            <div class="progress-bar">
                                <div class="progress-fill" style="background:#dc2626; width:<c:if test="${totalBooks > 0}">${discontinuedBooks * 100 / totalBooks}</c:if><c:if test="${totalBooks == 0}">0</c:if>%;"></div>
                                </div>
                            </div>
                        </div>

                    </div>

                <%-- ═══ QUICK ACTIONS ═══ --%>
                <div>
                    <h2 class="text-base font-bold text-on-surface mb-3">⚡ Actions nhanh</h2>
                    <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3">

                        <a href="${pageContext.request.contextPath}/dashboard/product-management?action=create" class="action-card">
                            <div class="action-icon" style="background:#e0f2fe;">
                                <span class="material-symbols-outlined" style="color:#0284c7;">add_box</span>
                            </div>
                            <span class="text-sm font-semibold">Add Book</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/dashboard/product-management" class="action-card">
                            <div class="action-icon" style="background:#ede9fe;">
                                <span class="material-symbols-outlined" style="color:#7c3aed;">library_books</span>
                            </div>
                            <span class="text-sm font-semibold">Manage Books</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/dashboard/product-management?status=out_of_stock" class="action-card">
                            <div class="action-icon" style="background:#fef9c3;">
                                <span class="material-symbols-outlined" style="color:#ca8a04;">warning</span>
                            </div>
                            <span class="text-sm font-semibold">Out-of-Stock Books</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/dashboard/account-management" class="action-card">
                            <div class="action-icon" style="background:#dcfce7;">
                                <span class="material-symbols-outlined" style="color:#16a34a;">group</span>
                            </div>
                            <span class="text-sm font-semibold">Account</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/dashboard/voucher-management" class="action-card">
                            <div class="action-icon" style="background:#fce7f3;">
                                <span class="material-symbols-outlined" style="color:#be185d;">local_offer</span>
                            </div>
                            <span class="text-sm font-semibold">Voucher</span>
                        </a>

                    </div>
                </div>

                <%-- ═══ RECENT BOOKS TABLE ═══ --%>
                <div class="bg-surface rounded-2xl border border-outline-variant/30 overflow-hidden">

                    <div class="px-5 py-4 border-b border-outline-variant/30 flex items-center justify-between">
                        <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary">schedule</span>
                            <h2 class="font-bold text-base text-on-surface">Recently Added Books</h2>
                        </div>
                        <a href="${pageContext.request.contextPath}/dashboard/product-management"
                           class="text-sm text-primary font-semibold hover:underline flex items-center gap-1">
                            View All
                            <span class="material-symbols-outlined" style="font-size:17px">arrow_forward</span>
                        </a>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse text-sm">
                            <thead>
                                <tr class="bg-background-alt border-b border-outline-variant/30">
                                    <th class="px-5 py-3 font-semibold text-on-surface-variant">Book</th>
                                    <th class="px-5 py-3 font-semibold text-on-surface-variant">Genre</th>
                                    <th class="px-5 py-3 font-semibold text-on-surface-variant text-right">Price</th>
                                    <th class="px-5 py-3 font-semibold text-on-surface-variant text-center">Stock</th>
                                    <th class="px-5 py-3 font-semibold text-on-surface-variant text-center">Status</th>
                                    <th class="px-5 py-3 font-semibold text-on-surface-variant text-center">Date Added</th>
                                    <th class="px-5 py-3 font-semibold text-on-surface-variant text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-outline-variant/20">

                                <c:forEach var="book" items="${recentBooks}">
                                    <tr class="book-row transition-colors">
                                        <td class="px-5 py-3">
                                            <div class="flex items-center gap-3">
                                                <div class="w-9 h-11 rounded-lg overflow-hidden bg-gray-100 flex-shrink-0 flex items-center justify-center">
                                                    <c:choose>
                                                        <c:when test="${not empty book.thumbnail}">
                                                            <img src="${book.thumbnail}" alt="" class="w-full h-full object-cover">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="material-symbols-outlined text-gray-300" style="font-size:16px">book</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div>
                                                    <div class="font-semibold text-on-surface line-clamp-1 max-w-[200px]">${book.title}</div>
                                                    <div class="text-xs text-on-surface-variant">
                                                        #${book.bookID}
                                                        <c:if test="${not empty book.authors}">
                                                            · <c:forEach var="a" items="${book.authors}" varStatus="s">${a}<c:if test="${!s.last}">, </c:if></c:forEach>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-5 py-3">
                                            <c:if test="${not empty book.genreName}">
                                                <span style="background:#dbeafe; color:#1d4ed8; font-size:11px; font-weight:700; padding:3px 9px; border-radius:20px;">${book.genreName}</span>
                                            </c:if>
                                        </td>
                                        <td class="px-5 py-3 text-right font-semibold text-primary">
                                            <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true"/> VND
                                        </td>
                                        <td class="px-5 py-3 text-center">
                                            <c:choose>
                                                <c:when test="${book.stockQuantity > 10}">
                                                    <span class="font-bold text-success">${book.stockQuantity}</span>
                                                </c:when>
                                                <c:when test="${book.stockQuantity > 0}">
                                                    <span class="font-bold text-warning">${book.stockQuantity}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="font-bold text-error">0</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-5 py-3 text-center">
                                            <c:choose>
                                                <c:when test="${book.status == 'available'}">
                                                    <span class="badge-available">Available</span>
                                                </c:when>
                                                <c:when test="${book.status == 'out_of_stock'}">
                                                    <span class="badge-out_of_stock">Out of Stock</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-discontinued">Discontinued</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-5 py-3 text-center text-xs text-on-surface-variant">
                                            <c:if test="${not empty book.createdAt}">
                                                <fmt:formatDate value="${book.createdAt}" pattern="dd/MM/yyyy"/>
                                            </c:if>
                                        </td>
                                        <td class="px-5 py-3 text-right">
                                            <div class="flex items-center justify-end gap-1.5">
                                                <a href="${pageContext.request.contextPath}/dashboard/product-management?action=edit&id=${book.bookID}"
                                                   class="w-8 h-8 flex items-center justify-center rounded-lg border border-primary/30 text-primary hover:bg-primary/10 transition-colors"
                                                   title="Edit">
                                                    <span class="material-symbols-outlined" style="font-size:16px">edit</span>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/dashboard/product-management"
                                                   class="w-8 h-8 flex items-center justify-center rounded-lg border border-outline-variant text-on-surface-variant hover:bg-gray-100 transition-colors"
                                                   title="View All">
                                                    <span class="material-symbols-outlined" style="font-size:16px">open_in_new</span>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty recentBooks}">
                                    <tr>
                                        <td colspan="7" class="px-5 py-16 text-center text-on-surface-variant">
                                            <span class="material-symbols-outlined text-5xl opacity-30 block mb-2">library_books</span>
                                            There are no books in the system yet
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <%-- Footer --%>
                    <div class="px-5 py-3 border-t border-outline-variant/30 flex items-center justify-between text-xs text-on-surface-variant">
                        <span>Showing ${recentBooks.size()} newest books</span>
                        <a href="${pageContext.request.contextPath}/dashboard/product-management"
                           class="text-primary font-semibold hover:underline">
                            Manage All Books →
                        </a>
                    </div>

                </div>

                <%-- ═══ BOTTOM ACTION STRIP ═══ --%>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">

                    <%-- Add book banner --%>
                    <div class="md:col-span-2 rounded-2xl p-6 flex items-center gap-5"
                         style="background: linear-gradient(135deg, #004d99 0%, #1565c0 100%);">
                        <div class="w-14 h-14 rounded-2xl bg-white/20 flex items-center justify-center flex-shrink-0">
                            <span class="material-symbols-outlined text-white" style="font-size:30px; font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24;">auto_stories</span>
                        </div>
                        <div class="flex-1">
                            <h3 class="text-white font-bold text-lg">Manage Book Inventory</h3>
                            <p class="text-blue-200 text-sm mt-0.5">Add, edit, and monitor stock for every book in the system.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/dashboard/product-management"
                           class="flex-shrink-0 bg-white text-primary font-bold px-5 py-2.5 rounded-xl text-sm hover:bg-blue-50 transition-colors">
                            Manage Books
                        </a>
                    </div>

                    <%-- Staff info --%>
                    <div class="bg-surface rounded-2xl border border-outline-variant/30 p-5 flex flex-col justify-between">
                        <div>
                            <div class="flex items-center gap-2 mb-3">
                                <div class="w-9 h-9 rounded-xl bg-green-100 flex items-center justify-center">
                                    <span class="material-symbols-outlined text-success" style="font-size:20px">badge</span>
                                </div>
                                <span class="font-bold text-sm text-on-surface">System Staff</span>
                            </div>
                            <p class="text-4xl font-bold text-on-surface">${totalStaffs}</p>
                            <p class="text-xs text-on-surface-variant mt-1">Total staff and administrator accounts</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/dashboard/account-management"
                           class="mt-4 w-full text-center border border-primary/30 text-primary font-semibold text-sm py-2 rounded-xl hover:bg-primary/5 transition-colors block">
                            Account Management
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>

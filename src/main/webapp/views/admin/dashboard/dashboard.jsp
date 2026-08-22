<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Dashboard - HeavenScape</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "tertiary": "#F5A623",
                            "primary": "#C92127",
                            "warning": "#F9A825",
                            "surface-container-highest": "#E3E3E6",
                            "surface-container-lowest": "#FFFFFF",
                            "on-primary": "#FFFFFF",
                            "surface": "#FFFFFF",
                            "primary-container": "#FDE8E9",
                            "on-background": "#1B1B1B",
                            "background": "#F7F7F8",
                            "surface-container-low": "#F7F7F8",
                            "background-alt": "#FFFFFF",
                            "success": "#2E7D32",
                            "error": "#D32F2F",
                            "on-surface-variant": "#5C5C5F",
                            "on-surface": "#1B1B1B",
                            "outline": "#8F8F92",
                            "outline-variant": "#D9D9DC"
                        },
                        "spacing": {
                            "container-max": "1280px",
                            "stack-lg": "48px",
                            "gutter": "24px",
                            "stack-md": "24px",
                            "stack-sm": "12px"
                        },
                        "fontFamily": {"body": ["Inter"]}
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Inter', sans-serif; }
            .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; vertical-align: middle; }
            .bar-item { min-width: 18px; border-radius: 10px 10px 0 0; background: linear-gradient(180deg, #F97316 0%, #C92127 100%); }
        </style>
    </head>
    <body class="bg-background text-on-surface flex min-h-screen">
        <%@ include file="/views/layout/common/toast.jsp" %>
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen flex flex-col">
            <div class="p-gutter max-w-container-max w-full mx-auto space-y-stack-lg">
                <div class="hs-admin-page-heading">
                    <div>
                        <h2 class="hs-admin-page-title">Dashboard</h2>
                        <p class="hs-admin-page-subtitle">Monitor HeavenScape revenue, orders, and book sales performance.</p>
                    </div>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/dashboard" class="bg-surface rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] border border-outline-variant/30 p-6">
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
                        <div>
                            <label class="block text-sm font-semibold text-on-surface-variant mb-2">From Date</label>
                            <input type="date" name="fromDate" value="${fromDate}" max="${currentDate}" class="w-full rounded-xl border-outline-variant bg-surface-container-low focus:ring-primary focus:border-primary">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-on-surface-variant mb-2">To Date</label>
                            <input type="date" name="toDate" value="${toDate}" max="${currentDate}" class="w-full rounded-xl border-outline-variant bg-surface-container-low focus:ring-primary focus:border-primary">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-on-surface-variant mb-2">Category</label>
                            <select name="categoryID" class="w-full rounded-xl border-outline-variant bg-surface-container-low focus:ring-primary focus:border-primary">
                                <option value="0">All Categories</option>
                                <c:forEach var="g" items="${categories}">
                                    <option value="${g.categoryID}" <c:if test="${selectedCategoryID == g.categoryID}">selected</c:if>>${g.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="flex gap-3">
                            <button type="submit" name="action" value="filter" class="flex-1 px-5 py-3 rounded-xl bg-primary text-white font-bold hover:bg-primary-container transition-colors flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined text-[18px]">filter_alt</span>
                                Filter
                            </button>
                            <a href="${pageContext.request.contextPath}/dashboard" class="px-5 py-3 rounded-xl bg-background-alt border border-outline-variant/40 text-primary font-bold hover:bg-surface-container-low transition-colors flex items-center justify-center">
                                Reset
                            </a>
                        </div>
                    </div>
                </form>

                <c:if test="${not empty dateError}">
                    <div class="-mt-8 rounded-xl border border-error/30 bg-error/5 px-4 py-3 text-sm font-semibold text-error">
                        ${dateError}
                    </div>
                </c:if>

                <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                    <div class="bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-2">
                        <span class="text-primary font-semibold">Total Revenue</span>
                        <div class="flex items-baseline gap-2">
                            <span class="text-3xl font-bold"><fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> VND</span>
                        </div>
                        <span class="text-on-surface-variant text-xs">Based on Current Filters</span>
                    </div>
                    <div class="bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-2">
                        <span class="text-primary font-semibold">Total Orders</span>
                        <div class="flex items-baseline gap-2">
                            <span class="text-3xl font-bold">${totalOrders}</span>
                            <span class="material-symbols-outlined text-primary text-sm">shopping_cart</span>
                        </div>
                        <span class="text-on-surface-variant text-xs">Orders in the System</span>
                    </div>
                    <div class="bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-2 border-l-4 border-warning">
                        <span class="text-primary font-semibold">Purchasing Customers</span>
                        <div class="flex items-baseline gap-2">
                            <span class="text-3xl font-bold">${totalCustomers}</span>
                            <span class="text-on-surface-variant text-xs">customers</span>
                        </div>
                        <span class="text-on-surface-variant text-xs">Customers with Orders Matching the Filters</span>
                    </div>
                    <div class="bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-2">
                        <span class="text-primary font-semibold">Books Sold</span>
                        <div class="flex items-baseline gap-2">
                            <span class="text-3xl font-bold">${totalSoldBooks}</span>
                            <span class="material-symbols-outlined text-success text-sm">trending_up</span>
                        </div>
                        <span class="text-on-surface-variant text-xs">Total Books: ${totalBooks}</span>
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-gutter">
                    <c:forEach var="statusEntry" items="${statusSummary}">
                        <div class="bg-surface p-stack-md rounded-xl shadow-sm border border-outline-variant/10 flex items-center gap-4">
                            <div class="w-12 h-12 rounded-lg bg-primary/10 flex items-center justify-center text-primary">
                                <span class="material-symbols-outlined">receipt_long</span>
                            </div>
                            <div>
                                <p class="text-sm text-on-surface-variant uppercase">${statusEntry.key}</p>
                                <p class="text-xl font-bold">${statusEntry.value}</p>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty statusSummary}">
                        <div class="sm:col-span-2 lg:col-span-4 bg-surface p-6 rounded-xl shadow-sm border border-outline-variant/10 text-center text-on-surface-variant">
                            No order statuses exist in the database.
                        </div>
                    </c:if>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-gutter">
                    <div class="bg-surface rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] border border-outline-variant/30 p-6">
                        <div class="flex items-center justify-between mb-6">
                            <div>
                                <h3 class="text-xl font-bold">Revenue by Category</h3>
                                <p class="text-sm text-on-surface-variant">
                            </div>
                            <span class="material-symbols-outlined text-primary">bar_chart</span>
                        </div>
                        <c:choose>
                            <c:when test="${empty revenueByCategory}">
                                <div class="text-center py-10 text-on-surface-variant">No revenue data is available.</div>
                            </c:when>
                            <c:otherwise>
                                <div class="space-y-4">
                                    <c:forEach var="row" items="${revenueByCategory}">
                                        <div>
                                            <div class="flex justify-between text-sm mb-1">
                                                <span class="font-semibold">${row.categoryName}</span>
                                                <span class="text-primary font-bold"><fmt:formatNumber value="${row.revenue}" type="number" groupingUsed="true"/> VND</span>
                                            </div>
                                            <div class="h-3 bg-surface-container-low rounded-full overflow-hidden">
                                                <div class="h-full bg-primary rounded-full" style="width: ${row.percentage}%"></div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="bg-surface rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] border border-outline-variant/30 p-6">
                        <div class="flex items-center justify-between mb-6">
                            <div>
                                <h3 class="text-xl font-bold">Best-Selling Books</h3>
                                <p class="text-sm text-on-surface-variant">Top books for the selected date range and category</p>
                            </div>
                            <span class="material-symbols-outlined text-primary">workspace_premium</span>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left">
                                <thead>
                                    <tr class="border-b border-outline-variant/20">
                                        <th class="py-3 text-xs uppercase text-on-surface-variant">Book</th>
                                        <th class="py-3 text-xs uppercase text-on-surface-variant">Category</th>
                                        <th class="py-3 text-xs uppercase text-on-surface-variant text-right">Sold</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-outline-variant/10">
                                    <c:forEach var="book" items="${topSellingBooks}">
                                        <tr>
                                            <td class="py-3 font-semibold text-sm">${book.title}</td>
                                            <td class="py-3 text-sm text-on-surface-variant">${book.categoryName}</td>
                                            <td class="py-3 text-sm font-bold text-primary text-right">${book.soldQuantity}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty topSellingBooks}">
                                        <tr><td colspan="3" class="py-10 text-center text-on-surface-variant">No best-selling book data is available.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
            <%@ include file="/views/layout/dashboard/footer.jsp" %>
        </main>
    </body>
</html>

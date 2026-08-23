<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Dashboard - HeavenScape</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;family=Source+Serif+4:opsz,wght@8..60,500;8..60,600;8..60,700&amp;display=swap" rel="stylesheet">
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
                            "background": "#F7F5F1",
                            "surface-container-low": "#F7F5F1",
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
                        "fontFamily": {
                            "body": ["Inter"],
                            "display": ['"Source Serif 4"', "Georgia", "serif"]
                        }
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Inter', sans-serif; }
            .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; vertical-align: middle; }

            /* Signature: a short two-tone rule under every section title, evoking a book's title-page divider. */
            .section-rule::after {
                content: "";
                display: block;
                height: 3px;
                width: 40px;
                margin-top: 10px;
                border-radius: 999px;
                background: linear-gradient(90deg, #C92127, #F5A623);
            }

            .eyebrow {
                font-size: 0.68rem;
                font-weight: 700;
                letter-spacing: 0.14em;
                text-transform: uppercase;
            }

            .tabular-nums { font-variant-numeric: tabular-nums; }

            /* Left "spine" accent used on KPI cards, like color-coded book spines on a shelf. */
            .spine { border-left-width: 4px; }
        </style>
    </head>
    <body class="bg-background text-on-surface flex min-h-screen">
        <%@ include file="/views/layout/common/toast.jsp" %>
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen flex flex-col">
            <div class="p-gutter max-w-container-max w-full mx-auto space-y-stack-lg">

                <div class="hs-admin-page-heading">
                    <div>
                        <h2 class="hs-admin-page-title font-display text-3xl font-semibold text-on-surface">Dashboard</h2>
                        <p class="hs-admin-page-subtitle text-on-surface-variant mt-1">Monitor HeavenScape revenue, orders, and book sales performance.</p>
                    </div>
                </div>

                <!-- Filters -->
                <form method="get" action="${pageContext.request.contextPath}/dashboard" class="bg-surface rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] border border-outline-variant/30 p-6">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 items-end">
                        <div>
                            <label class="block text-sm font-semibold text-on-surface-variant mb-2">From Date</label>
                            <input type="date" name="fromDate" value="${fromDate}" max="${currentDate}" class="w-full rounded-xl border-outline-variant bg-surface-container-low focus:ring-primary focus:border-primary">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-on-surface-variant mb-2">To Date</label>
                            <input type="date" name="toDate" value="${toDate}" max="${currentDate}" class="w-full rounded-xl border-outline-variant bg-surface-container-low focus:ring-primary focus:border-primary">
                        </div>
                        <div class="flex gap-3">
                            <button type="submit" name="action" value="filter" class="flex-1 px-5 py-3 rounded-xl bg-primary text-white font-bold hover:bg-primary-container transition-colors flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined text-[18px]" aria-hidden="true">filter_alt</span>
                                Filter
                            </button>
                            <a href="${pageContext.request.contextPath}/dashboard" class="px-5 py-3 rounded-xl bg-background-alt border border-outline-variant/40 text-primary font-bold hover:bg-surface-container-low transition-colors flex items-center justify-center">
                                Reset
                            </a>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty fromDate and not empty toDate}">
                            <p class="text-xs text-on-surface-variant mt-4">Showing data from <span class="font-semibold text-on-surface">${fromDate}</span> to <span class="font-semibold text-on-surface">${toDate}</span></p>
                        </c:when>
                        <c:otherwise>
                            <p class="text-xs text-on-surface-variant mt-4">Showing data for all time</p>
                        </c:otherwise>
                    </c:choose>
                </form>

                <c:if test="${not empty dateError}">
                    <div class="rounded-xl border border-error/30 bg-error/5 px-4 py-3 text-sm font-semibold text-error flex items-center gap-2">
                        <span class="material-symbols-outlined text-[18px]" aria-hidden="true">error</span>
                        ${dateError}
                    </div>
                </c:if>

                <!-- KPI summary -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                    <div class="spine border-primary bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-3">
                        <div class="flex items-center justify-between">
                            <span class="eyebrow text-on-surface-variant">Total Revenue</span>
                            <span class="material-symbols-outlined text-primary" aria-hidden="true">payments</span>
                        </div>
                        <span class="font-display text-3xl font-semibold text-on-surface"><fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> <span class="text-base font-body font-medium text-on-surface-variant">VND</span></span>
                        <span class="text-on-surface-variant text-xs">Based on current filters</span>
                    </div>

                    <div class="spine border-tertiary bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-3">
                        <div class="flex items-center justify-between">
                            <span class="eyebrow text-on-surface-variant">Total Orders</span>
                            <span class="material-symbols-outlined text-tertiary" aria-hidden="true">shopping_cart</span>
                        </div>
                        <span class="font-display text-3xl font-semibold text-on-surface">${totalOrders}</span>
                        <span class="text-on-surface-variant text-xs">Orders in the system</span>
                    </div>

                    <div class="spine border-warning bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-3">
                        <div class="flex items-center justify-between">
                            <span class="eyebrow text-on-surface-variant">Purchasing Customers</span>
                            <span class="material-symbols-outlined text-warning" aria-hidden="true">group</span>
                        </div>
                        <span class="font-display text-3xl font-semibold text-on-surface">${totalCustomers}</span>
                        <span class="text-on-surface-variant text-xs">Customers with orders matching the filters</span>
                    </div>

                    <div class="spine border-success bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-3">
                        <div class="flex items-center justify-between">
                            <span class="eyebrow text-on-surface-variant">Books Sold</span>
                            <span class="material-symbols-outlined text-success" aria-hidden="true">trending_up</span>
                        </div>
                        <span class="font-display text-3xl font-semibold text-on-surface">${totalSoldBooks}</span>
                        <span class="text-on-surface-variant text-xs">Out of ${totalBooks} total titles</span>
                    </div>
                </div>

                <!-- Order status: chips + chart live together, one section instead of two -->
                <div class="bg-surface rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] border border-outline-variant/30 p-6">
                    <div class="section-rule mb-5">
                        <h3 class="font-display text-xl font-semibold text-on-surface">Order Status Overview</h3>
                        <p class="text-sm text-on-surface-variant mt-1">Distribution of orders in the selected date range</p>
                    </div>

                    <c:choose>
                        <c:when test="${empty statusSummary}">
                            <div class="rounded-xl border border-dashed border-outline-variant/50 p-8 text-center text-on-surface-variant">
                                No order statuses match this range yet. Try widening the dates above.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="flex flex-wrap gap-2 mb-6">
                                <c:forEach var="statusEntry" items="${statusSummary}">
                                    <c:set var="statusKey" value="${fn:toLowerCase(statusEntry.key)}" />
                                    <c:choose>
                                        <c:when test="${statusKey == 'pending'}"><c:set var="dotColor" value="#F9A825" /></c:when>
                                        <c:when test="${statusKey == 'confirmed'}"><c:set var="dotColor" value="#1565C0" /></c:when>
                                        <c:when test="${statusKey == 'shipping'}"><c:set var="dotColor" value="#7E57C2" /></c:when>
                                        <c:when test="${statusKey == 'completed'}"><c:set var="dotColor" value="#2E7D32" /></c:when>
                                        <c:when test="${statusKey == 'cancelled'}"><c:set var="dotColor" value="#C92127" /></c:when>
                                        <c:otherwise><c:set var="dotColor" value="#8F8F92" /></c:otherwise>
                                    </c:choose>
                                    <span class="inline-flex items-center gap-2 rounded-full border border-outline-variant/30 bg-surface-container-low px-4 py-2 text-sm">
                                        <span class="w-2.5 h-2.5 rounded-full" style="background-color: ${dotColor};" aria-hidden="true"></span>
                                        <span class="font-semibold capitalize">${statusEntry.key}</span>
                                        <span class="text-on-surface-variant tabular-nums">${statusEntry.value}</span>
                                    </span>
                                </c:forEach>
                            </div>

                            <canvas id="statusChart" height="150" class="w-full" role="img" aria-label="Order status distribution chart"></canvas>
                            <div id="statusChartData" class="hidden">
                                <c:forEach var="entry" items="${statusSummary}"><span data-label="${entry.key}" data-value="${entry.value}"></span></c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Trend + ranking -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-gutter">
                    <div class="bg-surface rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] border border-outline-variant/30 p-6">
                        <div class="section-rule mb-5">
                            <h3 class="font-display text-xl font-semibold text-on-surface">Revenue Trend</h3>
                            <p class="text-sm text-on-surface-variant mt-1">Completed orders by day</p>
                        </div>
                        <c:choose>
                            <c:when test="${empty revenueTrend}">
                                <div class="rounded-xl border border-dashed border-outline-variant/50 p-8 text-center text-on-surface-variant">
                                    No completed orders in this range yet — the chart will fill in as sales come through.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <canvas id="revenueChart" height="220" class="w-full" role="img" aria-label="Revenue trend bar chart"></canvas>
                                <div id="revenueChartData" class="hidden">
                                    <c:forEach var="row" items="${revenueTrend}"><span data-label="${row.saleDate}" data-value="${row.revenue}"></span></c:forEach>
                                </div>
                                <ul class="sr-only">
                                    <c:forEach var="row" items="${revenueTrend}">
                                        <li>${row.saleDate}: <fmt:formatNumber value="${row.revenue}" type="number" groupingUsed="true"/> VND</li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="bg-surface rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] border border-outline-variant/30 p-6">
                        <div class="section-rule mb-5">
                            <h3 class="font-display text-xl font-semibold text-on-surface">Best-Selling Books</h3>
                            <p class="text-sm text-on-surface-variant mt-1">Completed-order quantities for the selected date range</p>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left">
                                <thead>
                                    <tr class="border-b border-outline-variant/20">
                                        <th class="py-3 text-xs uppercase text-on-surface-variant">Book</th>
                                        <th class="py-3 text-xs uppercase text-on-surface-variant text-right">Sold</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-outline-variant/10">
                                    <c:forEach var="book" items="${topSellingBooks}" varStatus="rank">
                                        <tr class="hover:bg-surface-container-low/70 transition-colors">
                                            <td class="py-3 pr-4">
                                                <span class="inline-flex items-baseline gap-3">
                                                    <span class="font-display text-base text-outline w-5 text-right shrink-0">${rank.index + 1}</span>
                                                    <span class="font-semibold text-sm">${book.title}</span>
                                                </span>
                                            </td>
                                            <td class="py-3 text-sm font-bold text-primary text-right tabular-nums">${book.soldQuantity}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty topSellingBooks}">
                                        <tr><td colspan="2" class="py-10 text-center text-on-surface-variant">No completed sales yet in this range — top sellers will show up here once orders come in.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
            <%@ include file="/views/layout/dashboard/footer.jsp" %>
        </main>
        <script>
            function drawDashboardBars(canvasId, dataId, color, labelOrder) {
                const canvas = document.getElementById(canvasId);
                const source = document.getElementById(dataId);
                if (!canvas || !source) return;
                const rows = Array.from(source.querySelectorAll('[data-value]')).map(el => ({
                    label: el.dataset.label,
                    value: Number(el.dataset.value) || 0
                }));
                if (!rows.length) return;

                if (Array.isArray(labelOrder)) {
                    const priority = new Map(labelOrder.map((label, index) => [label, index]));
                    rows.sort((left, right) => {
                        const leftPriority = priority.has(left.label) ? priority.get(left.label) : labelOrder.length;
                        const rightPriority = priority.has(right.label) ? priority.get(right.label) : labelOrder.length;
                        return leftPriority - rightPriority;
                    });
                }

                const ratio = window.devicePixelRatio || 1;
                const cssWidth = Math.max(320, canvas.parentElement.clientWidth - 48);
                const cssHeight = Number(canvas.getAttribute('height')) || 180;
                canvas.width = cssWidth * ratio;
                canvas.height = cssHeight * ratio;
                canvas.style.width = cssWidth + 'px';
                canvas.style.height = cssHeight + 'px';
                const ctx = canvas.getContext('2d');
                ctx.scale(ratio, ratio);

                const pad = {left: 46, right: 16, top: 12, bottom: 42};
                const width = cssWidth - pad.left - pad.right;
                const height = cssHeight - pad.top - pad.bottom;
                const max = Math.max.apply(null, rows.map(r => r.value)) || 1;
                const gap = 14;
                const barWidth = Math.max(12, (width - gap * (rows.length - 1)) / rows.length);

                ctx.font = '11px Inter, sans-serif';
                ctx.textAlign = 'center';
                rows.forEach((row, index) => {
                    const x = pad.left + index * (barWidth + gap);
                    const barHeight = Math.max(2, row.value / max * height);
                    const barTop = pad.top + height - barHeight;

                    let fillStyle = typeof color === 'function' ? color(row.label) : color;
                    if (fillStyle === '__brand_gradient__') {
                        const gradient = ctx.createLinearGradient(0, barTop, 0, pad.top + height);
                        gradient.addColorStop(0, '#F5A623');
                        gradient.addColorStop(1, '#C92127');
                        fillStyle = gradient;
                    }

                    ctx.fillStyle = fillStyle;
                    ctx.fillRect(x, barTop, barWidth, barHeight);
                    ctx.fillStyle = '#1B1B1B';
                    ctx.fillText(row.value.toLocaleString('en-US'), x + barWidth / 2, barTop - 5);
                    ctx.fillStyle = '#5C5C5F';
                    const shortLabel = row.label.length > 12 ? row.label.substring(0, 11) + '...' : row.label;
                    ctx.fillText(shortLabel, x + barWidth / 2, cssHeight - 16);
                });
            }

            function drawAllDashboardCharts() {
                const statusColors = {
                    pending: '#F9A825',
                    confirmed: '#1565C0',
                    shipping: '#7E57C2',
                    completed: '#2E7D32',
                    cancelled: '#C92127'
                };
                const statusOrder = ['pending', 'confirmed', 'shipping', 'completed', 'cancelled'];
                drawDashboardBars(
                    'statusChart',
                    'statusChartData',
                    label => statusColors[label.toLowerCase()] || '#8F8F92',
                    statusOrder
                );
                drawDashboardBars('revenueChart', 'revenueChartData', '__brand_gradient__');
            }
            window.addEventListener('load', drawAllDashboardCharts);
            window.addEventListener('resize', drawAllDashboardCharts);
        </script>
    </body>
</html>

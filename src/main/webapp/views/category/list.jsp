<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Genre Management - HeavenScape</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            primary: '#004d99', 'on-primary': '#ffffff', background: '#f3faff', surface: '#ffffff',
                            'surface-container': '#dbf1fe', 'surface-container-low': '#e6f6ff', 'surface-variant': '#cfe6f2',
                            'on-surface': '#071e27', 'on-surface-variant': '#424752', outline: '#727783', 'outline-variant': '#c2c6d4',
                            success: '#2E7D32', warning: '#FFA000', error: '#D32F2F', 'error-container': '#ffdad6'
                        },
                        fontFamily: {sans: ['Inter', 'sans-serif']},
                        boxShadow: {card: '0 4px 20px rgba(21,101,192,0.08)'}
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Inter', sans-serif; }
            .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; vertical-align: middle; }
        </style>
    </head>
    <body class="bg-background text-on-surface flex min-h-screen">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen flex flex-col">
            <header class="bg-white border-b h-14 sticky top-0 z-30 flex items-center px-6"
                    style="border-color:#c2c6d4;">
                <h2 class="font-semibold text-base" style="color:#071e27;">Genre Management</h2>
            </header>

            <div class="px-6 py-8 max-w-6xl mx-auto w-full space-y-8">
                <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
                    <div>
                        <h1 class="text-3xl font-bold text-on-surface">Genre List</h1>
                        <p class="text-sm text-on-surface-variant mt-2">Create, update, review, and filter HeavenScape book genres.</p>
                    </div>
                    <c:if test="${canManageCategory}">
                        <a href="${pageContext.request.contextPath}/dashboard/category-management?action=create"
                           class="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-bold text-white shadow-card hover:bg-[#003f7d] transition">
                            <span class="material-symbols-outlined text-[20px]">add</span>
                            Add Genre
                        </a>
                    </c:if>
                </div>

                <c:if test="${not empty sessionScope.success}">
                    <div class="rounded-xl border border-green-200 bg-green-50 px-4 py-3 text-sm font-semibold text-green-700">
                        ${sessionScope.success}
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                        ${sessionScope.error}
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <section class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="bg-surface rounded-2xl border border-outline-variant p-5 shadow-card">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-semibold text-primary">Total Genres</p>
                                <p class="text-3xl font-extrabold mt-2">${totalCategories}</p>
                            </div>
                            <div class="w-12 h-12 rounded-xl bg-surface-container-low flex items-center justify-center text-primary">
                                <span class="material-symbols-outlined">category</span>
                            </div>
                        </div>
                    </div>
                    <div class="bg-surface rounded-2xl border border-outline-variant p-5 shadow-card md:col-span-2">
                        <form action="${pageContext.request.contextPath}/dashboard/category-management" method="get" class="flex flex-col md:flex-row gap-3">
                            <div class="flex-1 relative">
                                <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant text-[20px]">search</span>
                                <input type="text" name="keyword" value="${keyword}"
                                       placeholder="Search genres..."
                                       class="w-full rounded-xl border-outline-variant bg-surface-container-low pl-12 pr-4 py-3 text-sm focus:border-primary focus:ring-primary">
                            </div>
                            <button type="submit" class="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-6 py-3 text-sm font-bold text-white hover:bg-[#003f7d] transition">
                                <span class="material-symbols-outlined text-[19px]">filter_alt</span>
                                Search
                            </button>
                            <a href="${pageContext.request.contextPath}/dashboard/category-management"
                               class="inline-flex items-center justify-center rounded-xl border border-outline-variant bg-white px-5 py-3 text-sm font-semibold text-primary hover:bg-surface-container-low transition">
                                Cancel
                            </a>
                        </form>
                    </div>
                </section>

                <section class="bg-surface rounded-2xl border border-outline-variant shadow-card overflow-hidden">
                    <div class="px-6 py-5 border-b border-outline-variant flex items-center justify-between">
                        <div>
                            <h2 class="text-xl font-bold">Genre List</h2>
                            <p class="text-sm text-on-surface-variant mt-1">View the genres currently available in the system.</p>
                        </div>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead class="bg-surface-container-low">
                                <tr>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant">Genre ID</th>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant">Genre Name</th>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant">Book Count</th>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-outline-variant">
                                <c:forEach var="genre" items="${genres}">
                                    <tr class="hover:bg-surface-container-low transition">
                                        <td class="px-6 py-4 text-sm font-bold text-primary">#CAT-${genre.genreID}</td>
                                        <td class="px-6 py-4 text-sm font-semibold text-on-surface">${genre.genreName}</td>
                                        <td class="px-6 py-4 text-sm text-on-surface-variant">${genre.bookCount}</td>
                                        <td class="px-6 py-4">
                                            <div class="flex items-center justify-end gap-2">
                                                <a href="${pageContext.request.contextPath}/dashboard/category-management?action=detail&id=${genre.genreID}"
                                                   class="w-9 h-9 rounded-lg border border-outline-variant flex items-center justify-center text-primary hover:bg-surface-container-low" title="View Details">
                                                    <span class="material-symbols-outlined text-[18px]">visibility</span>
                                                </a>
                                                <c:if test="${canManageCategory}">
                                                    <form action="${pageContext.request.contextPath}/dashboard/category-management" method="post" onsubmit="openDeleteCategoryModal(this); return false;">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${genre.genreID}">
                                                        <button type="submit" class="w-9 h-9 rounded-lg border border-red-200 flex items-center justify-center text-error hover:bg-red-50" title="Delete">
                                                            <span class="material-symbols-outlined text-[18px]">delete</span>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty genres}">
                                    <tr>
                                        <td colspan="4" class="px-6 py-12 text-center text-sm text-on-surface-variant">No genres found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>
        </main>

        <div id="deleteCategoryModal" class="fixed inset-0 z-[9999] hidden items-center justify-center bg-slate-900/45 p-5">
            <div class="w-full max-w-sm rounded-xl bg-white p-6 shadow-2xl">
                <div class="flex items-center justify-between gap-4">
                    <h2 class="text-xl font-extrabold">Delete Genre</h2>
                    <button type="button" onclick="closeDeleteCategoryModal()" class="text-2xl leading-none text-gray-500">&times;</button>
                </div>
                <p class="mt-5 text-sm text-on-surface-variant">Are you sure you want to delete this genre?</p>
                <div class="mt-6 grid grid-cols-2 gap-3">
                    <button type="button" onclick="closeDeleteCategoryModal()"
                            class="rounded-lg border border-outline-variant bg-white px-4 py-3 font-bold text-on-surface">Cancel</button>
                    <button type="button" onclick="confirmDeleteCategory()"
                            class="rounded-lg bg-primary px-4 py-3 font-bold text-white">Confirm</button>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/common/toast.jsp" %>
        <script>
            let pendingDeleteCategoryForm = null;

            function openDeleteCategoryModal(form) {
                pendingDeleteCategoryForm = form;
                const modal = document.getElementById('deleteCategoryModal');
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            }

            function closeDeleteCategoryModal() {
                const modal = document.getElementById('deleteCategoryModal');
                modal.classList.add('hidden');
                modal.classList.remove('flex');
                pendingDeleteCategoryForm = null;
            }

            function confirmDeleteCategory() {
                if (pendingDeleteCategoryForm) {
                    pendingDeleteCategoryForm.submit();
                }
            }

            document.getElementById('deleteCategoryModal').addEventListener('click', function (event) {
                if (event.target === this) {
                    closeDeleteCategoryModal();
                }
            });
        </script>
    </body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Book Management - HeavenScape</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {extend: {
                        colors: {
                            "primary": "#C92127", "primary-container": "#FDE8E9",
                            "secondary-container": "#FFE3C2", "secondary": "#F97316",
                            "background": "#F7F7F8", "surface": "#FFFFFF",
                            "on-surface": "#1B1B1B", "on-surface-variant": "#5C5C5F",
                            "outline-variant": "#D9D9DC", "success": "#2E7D32",
                            "error": "#D32F2F", "warning": "#F9A825",
                            "error-container": "#FFDAD6", "primary-fixed": "#FFDAD9",
                            "surface-container-low": "#F7F7F8", "background-alt": "#FFFFFF"
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
        </style>
    </head>
    <body class="bg-background text-on-surface flex min-h-screen">

        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <%@ include file="/views/layout/common/toast.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen p-6">
            <div class="max-w-[1200px] mx-auto space-y-6">


                <div class="hs-admin-page-heading">
                    <div>
                        <h2 class="hs-admin-page-title">Book Inventory Management</h2>
                        <p class="hs-admin-page-subtitle">Add, edit, and discontinue books in the HeavenScape catalog</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/dashboard/product-management?action=create"
                       class="inline-flex items-center gap-2 bg-primary text-white px-5 py-2.5 rounded-xl font-semibold hover:opacity-90 transition-opacity whitespace-nowrap">
                        <span class="material-symbols-outlined">add</span>
                        Add New Book
                    </a>
                </div>


                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <div class="bg-surface p-4 rounded-2xl border border-outline-variant/30 flex flex-col gap-1">
                        <span class="text-xs font-semibold text-on-surface-variant uppercase">Total Books</span>
                        <span class="text-2xl font-bold text-primary">${total}</span>
                    </div>
                    <div class="bg-surface p-4 rounded-2xl border border-outline-variant/30 flex flex-col gap-1">
                        <span class="text-xs font-semibold text-on-surface-variant uppercase">Showing</span>
                        <span class="text-2xl font-bold text-success">${books.size()}</span>
                    </div>
                    <div class="bg-surface p-4 rounded-2xl border border-outline-variant/30 flex flex-col gap-1">
                        <span class="text-xs font-semibold text-on-surface-variant uppercase">Trang</span>
                        <span class="text-2xl font-bold">${page}/${totalPages}</span>
                    </div>
                    <div class="bg-surface p-4 rounded-2xl border border-outline-variant/30 flex flex-col gap-1">
                        <span class="text-xs font-semibold text-on-surface-variant uppercase">Genre</span>
                        <span class="text-2xl font-bold">${genreMap.size()}</span>
                    </div>
                </div>


                <div class="bg-surface rounded-2xl border border-outline-variant/30 p-5">
                    <form method="get" action="${pageContext.request.contextPath}/dashboard/product-management"
                          class="flex flex-wrap gap-3 items-end">

                        <div class="flex-1 min-w-[200px] relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant text-[20px]">search</span>
                            <input type="text" name="keyword" value="${keyword}"
                                   placeholder="Search by title or ID..."
                                   class="w-full pl-10 pr-4 py-2.5 border border-outline-variant rounded-xl focus:ring-2 focus:ring-primary focus:border-primary text-sm outline-none">
                        </div>


                        <div class="relative min-w-[150px]">
                            <select name="genre" onchange="this.form.submit()"
                                    class="appearance-none w-full pl-3 pr-9 py-2.5 border border-outline-variant rounded-xl focus:ring-2 focus:ring-primary text-sm outline-none cursor-pointer bg-white">
                                <option value="">Genre</option>
                                <c:forEach var="entry" items="${genreMap}">
                                    <option value="${entry.key}" <c:if test="${genreID == entry.key}">selected</c:if>>${entry.value}</option>
                                </c:forEach>
                            </select>
                            <span class="material-symbols-outlined absolute right-2.5 top-1/2 -translate-y-1/2 text-on-surface-variant text-[20px] pointer-events-none">expand_more</span>
                        </div>


                        <div class="relative min-w-[150px]">
                            <select name="status" onchange="this.form.submit()"
                                    class="appearance-none w-full pl-3 pr-9 py-2.5 border border-outline-variant rounded-xl focus:ring-2 focus:ring-primary text-sm outline-none cursor-pointer bg-white">
                                <option value="">Status</option>
                                <option value="available"    <c:if test="${status == 'available'}">selected</c:if>>Available</option>
                                <option value="out_of_stock" <c:if test="${status == 'out_of_stock'}">selected</c:if>>Out of Stock</option>
                                <option value="discontinued" <c:if test="${status == 'discontinued'}">selected</c:if>>Discontinued</option>
                                </select>
                                <span class="material-symbols-outlined absolute right-2.5 top-1/2 -translate-y-1/2 text-on-surface-variant text-[20px] pointer-events-none">expand_more</span>
                            </div>


                        <c:if test="${not empty keyword or not empty status or not empty genreID}">
                            <a href="${pageContext.request.contextPath}/dashboard/product-management"
                               class="text-sm text-gray-400 hover:text-error transition-colors px-2 py-2.5 whitespace-nowrap">✕ Clear Filters</a>
                        </c:if>
                    </form>
                </div>


                <div class="bg-surface rounded-2xl border border-outline-variant/30 overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse text-sm">
                            <thead>
                                <tr class="bg-background-alt border-b border-outline-variant/30">
                                    <th class="px-4 py-3 font-semibold text-on-surface-variant">Book</th>
                                    <th class="px-4 py-3 font-semibold text-on-surface-variant">Genres</th>
                                    <th class="px-4 py-3 font-semibold text-on-surface-variant">Publisher</th>
                                    <th class="px-4 py-3 font-semibold text-on-surface-variant text-right">Price</th>
                                    <th class="px-4 py-3 font-semibold text-on-surface-variant text-center">Stock</th>
                                    <th class="px-4 py-3 font-semibold text-on-surface-variant text-center">Status</th>
                                    <th class="px-4 py-3 font-semibold text-on-surface-variant text-center">Created Date</th>
                                    <th class="px-4 py-3 font-semibold text-on-surface-variant text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-outline-variant/20">
                                <c:forEach var="book" items="${books}">
                                    <tr class="hover:bg-surface-container-low transition-colors">
                                        <td class="px-4 py-3">
                                            <div class="flex items-center gap-3">
                                                <div class="w-10 h-12 rounded-lg overflow-hidden bg-gray-100 flex-shrink-0 flex items-center justify-center">
                                                    <c:choose>
                                                        <c:when test="${not empty book.thumbnailFirst}">
                                                            <img src="${book.thumbnailFirst}" alt="" class="w-full h-full object-cover">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="material-symbols-outlined text-gray-300" style="font-size:18px">book</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div>
                                                    <div class="font-semibold text-on-surface line-clamp-1 max-w-[220px]">${book.title}</div>
                                                    <div class="text-xs text-on-surface-variant">ID: ${book.bookID}
                                                        <c:if test="${not empty book.authors}">
                                                            · <c:forEach var="a" items="${book.authors}" varStatus="s">${a}<c:if test="${!s.last}">, </c:if></c:forEach>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-4 py-3">
                                            <div class="flex flex-wrap gap-1">
                                                <c:forEach var="genre" items="${book.genres}">
                                                    <span class="bg-primary-fixed text-primary text-xs font-semibold px-2.5 py-0.5 rounded-full">${genre.genreName}</span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                        <td class="px-4 py-3 text-on-surface-variant whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${not empty book.publisherName}">${book.publisherName}</c:when>
                                                <c:otherwise>&mdash;</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-4 py-3 text-right font-semibold text-primary">
                                            <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true"/> VND
                                        </td>
                                        <td class="px-4 py-3 text-center">
                                            <c:choose>
                                                <c:when test="${book.stockQuantity > 10}">
                                                    <span class="text-success font-semibold">${book.stockQuantity}</span>
                                                </c:when>
                                                <c:when test="${book.stockQuantity > 0}">
                                                    <span class="text-warning font-semibold">${book.stockQuantity}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-error font-semibold">0</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-4 py-3 text-center">
                                            <c:choose>
                                                <c:when test="${book.status == 'available'}">
                                                    <span class="bg-green-100 text-green-700 text-xs font-bold px-2.5 py-1 rounded-full">Available</span>
                                                </c:when>
                                                <c:when test="${book.status == 'out_of_stock'}">
                                                    <span class="bg-yellow-100 text-yellow-700 text-xs font-bold px-2.5 py-1 rounded-full">Out of Stock</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="bg-red-100 text-red-700 text-xs font-bold px-2.5 py-1 rounded-full">Discontinued</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-4 py-3 text-center text-xs text-on-surface-variant">
                                            <c:if test="${not empty book.createdAt}">
                                                <fmt:formatDate value="${book.createdAt}" pattern="dd/MM/yyyy"/>
                                            </c:if>
                                        </td>
                                        <td class="px-4 py-3 text-right">
                                            <div class="action-group">
                                                <a href="${pageContext.request.contextPath}/dashboard/product-management?action=edit&id=${book.bookID}"
                                                   class="btn-action btn-action-edit"
                                                   title="Edit" aria-label="Edit book">
                                                    <span class="material-symbols-outlined" aria-hidden="true">edit</span>
                                                </a>
                                                <c:if test="${book.status != 'discontinued'}">
                                                    <button type="button"
                                                            data-book-id="${book.bookID}"
                                                            data-book-title="${book.title}"
                                                            onclick="confirmDelete(this)"
                                                            class="btn-action btn-action-disable"
                                                            title="Discontinue" aria-label="Discontinue book">
                                                        <span class="material-symbols-outlined" aria-hidden="true">block</span>
                                                    </button>
                                                </c:if>
                                                <c:if test="${book.status == 'discontinued'}">
                                                    <button type="button"
                                                            data-book-id="${book.bookID}"
                                                            data-book-title="${book.title}"
                                                            onclick="confirmRestore(this)"
                                                            class="btn-action btn-action-success"
                                                            title="Relist" aria-label="Relist book">
                                                        <span class="material-symbols-outlined" aria-hidden="true">restore</span>
                                                    </button>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty books}">
                                    <tr>
                                        <td colspan="7" class="px-4 py-16 text-center text-on-surface-variant">
                                            <span class="material-symbols-outlined text-5xl opacity-30 block mb-2">inventory_2</span>
                                            No Books Found
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>


                    <c:if test="${totalPages > 1}">
                        <div class="px-4 py-3 border-t border-outline-variant/30 flex justify-center gap-1.5 flex-wrap">
                            <c:if test="${page > 1}">
                                <a href="?page=${page-1}<c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty status}">&status=${status}</c:if><c:if test="${not empty genreID}">&genre=${genreID}</c:if>"
                                   class="w-9 h-9 flex items-center justify-center rounded-lg border border-outline-variant text-on-surface-variant hover:border-primary hover:text-primary transition-colors text-sm">‹</a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == page}">
                                        <span class="w-9 h-9 flex items-center justify-center rounded-lg bg-primary text-white font-bold text-sm">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="?page=${i}<c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty status}">&status=${status}</c:if><c:if test="${not empty genreID}">&genre=${genreID}</c:if>"
                                           class="w-9 h-9 flex items-center justify-center rounded-lg border border-outline-variant text-on-surface-variant hover:border-primary hover:text-primary transition-colors text-sm">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:if test="${page < totalPages}">
                                <a href="?page=${page+1}<c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty status}">&status=${status}</c:if><c:if test="${not empty genreID}">&genre=${genreID}</c:if>"
                                   class="w-9 h-9 flex items-center justify-center rounded-lg border border-outline-variant text-on-surface-variant hover:border-primary hover:text-primary transition-colors text-sm">›</a>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>


        <div id="deleteModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 hidden">
            <div class="bg-white rounded-2xl shadow-2xl p-6 w-full max-w-sm mx-4 animate-[fadeIn_.2s_ease]">
                <div class="flex items-center gap-3 mb-4">
                    <div class="w-10 h-10 rounded-full bg-red-100 flex items-center justify-center">
                        <span class="material-symbols-outlined text-error">warning</span>
                    </div>
                    <h3 class="font-bold text-lg">Discontinue Book?</h3>
                </div>
                <p class="text-sm text-on-surface-variant mb-5" id="deleteMsg">Discontinue this book?</p>
                <div class="flex gap-3">
                    <button onclick="closeDeleteModal()" class="flex-1 border border-outline-variant px-4 py-2.5 rounded-xl text-sm font-semibold hover:bg-gray-50 transition-colors">Cancel</button>
                    <form method="post" action="${pageContext.request.contextPath}/dashboard/product-management" class="flex-1">
                        <input type="hidden" name="action"  value="delete">
                        <input type="hidden" name="bookID"  id="deleteBookID" value="">
                        <button type="submit" class="w-full bg-error text-white px-4 py-2.5 rounded-xl text-sm font-semibold hover:opacity-90 transition-opacity">Discontinued</button>
                    </form>
                </div>
            </div>
        </div>
        <div id="restoreModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 hidden">
            <div class="bg-white rounded-2xl shadow-2xl p-6 w-full max-w-sm mx-4 animate-[fadeIn_.2s_ease]">
                <div class="flex items-center gap-3 mb-4">
                    <div class="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center">
                        <span class="material-symbols-outlined text-success">restore</span>
                    </div>
                    <h3 class="font-bold text-lg">Relist Book?</h3>
                </div>
                <p class="text-sm text-on-surface-variant mb-5" id="restoreMsg">Relist this book?</p>
                <div class="flex gap-3">
                    <button onclick="closeRestoreModal()" class="flex-1 border border-outline-variant px-4 py-2.5 rounded-xl text-sm font-semibold hover:bg-gray-50 transition-colors">Cancel</button>
                    <form method="post" action="${pageContext.request.contextPath}/dashboard/product-management" class="flex-1">
                        <input type="hidden" name="action" value="restore">
                        <input type="hidden" name="bookID" id="restoreBookID" value="">
                        <button type="submit" class="w-full bg-success text-white px-4 py-2.5 rounded-xl text-sm font-semibold hover:opacity-90 transition-opacity">Relist</button>
                    </form>
                </div>
            </div>
        </div>            

        <script>
            function confirmDelete(button) {
                var id = button.getAttribute('data-book-id');
                var title = button.getAttribute('data-book-title');
                document.getElementById('deleteBookID').value = id;
                document.getElementById('deleteMsg').textContent = 'Confirm discontinuation: "' + title + '"? The book will no longer appear in the storefront.';
                document.getElementById('deleteModal').classList.remove('hidden');
            }
            function closeDeleteModal() {
                document.getElementById('deleteModal').classList.add('hidden');
            }
            document.getElementById('deleteModal').addEventListener('click', function (e) {
                if (e.target === this)
                    closeDeleteModal();
            });
            function confirmRestore(button) {
                var id = button.getAttribute('data-book-id');
                var title = button.getAttribute('data-book-title');
                document.getElementById('restoreBookID').value = id;
                document.getElementById('restoreMsg').textContent = 'Confirm relisting: "' + title + '"? The book will appear in the storefront again.';
                document.getElementById('restoreModal').classList.remove('hidden');
            }
            function closeRestoreModal() {
                document.getElementById('restoreModal').classList.add('hidden');
            }
            document.getElementById('restoreModal').addEventListener('click', function (e) {
                if (e.target === this)
                    closeRestoreModal();
            });
        </script>
    </body>
</html>

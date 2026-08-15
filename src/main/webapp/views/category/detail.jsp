<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Genre Details - HeavenScape</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script>
            tailwind.config = {theme: {extend: {colors: {primary: '#004d99', background: '#f3faff', surface: '#ffffff', 'surface-container-low': '#e6f6ff', 'on-surface': '#071e27', 'on-surface-variant': '#424752', 'outline-variant': '#c2c6d4'}, fontFamily: {sans: ['Inter', 'sans-serif']}, boxShadow: {card: '0 4px 20px rgba(21,101,192,0.08)'}}}}
        </script>
        <style>body{font-family:'Inter',sans-serif}.material-symbols-outlined{vertical-align:middle}</style>
    </head>
    <body class="bg-background text-on-surface flex min-h-screen">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <main class="flex-1 md:ml-64 min-h-screen">
            <div class="px-6 py-8 max-w-3xl mx-auto space-y-6">
                <a href="${pageContext.request.contextPath}/dashboard/category-management" class="inline-flex items-center gap-2 text-sm font-semibold text-primary hover:underline">
                    <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                    Back to List
                </a>



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
                <section class="bg-surface rounded-2xl border border-outline-variant shadow-card overflow-hidden">
                    <div class="px-6 py-5 border-b border-outline-variant flex items-center justify-between">
                        <div>
                            <h1 class="text-2xl font-bold">Genre Details</h1>
                            <p class="text-sm text-on-surface-variant mt-1">Detailed information about this book genre.</p>
                        </div>
                        <c:if test="${canManageCategory}">
                            <button type="button" onclick="openUpdateModal()"
                                    class="inline-flex items-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-bold text-white hover:bg-[#003f7d] transition">
                                <span class="material-symbols-outlined text-[18px]">edit</span>
                                Update
                            </button>
                        </c:if>
                    </div>

                    <div class="p-6 grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="rounded-xl bg-surface-container-low p-5">
                            <p class="text-sm font-semibold text-on-surface-variant">Genre ID</p>
                            <p class="text-2xl font-extrabold text-primary mt-2">#CAT-${genre.genreID}</p>
                        </div>
                        <div class="rounded-xl bg-surface-container-low p-5 md:col-span-2">
                            <p class="text-sm font-semibold text-on-surface-variant">Genre Name</p>
                            <p class="text-2xl font-extrabold mt-2">${genre.genreName}</p>
                        </div>
                        <div class="rounded-xl bg-surface-container-low p-5 md:col-span-3">
                            <p class="text-sm font-semibold text-on-surface-variant">Books in This Genre</p>
                            <p class="text-2xl font-extrabold mt-2">${genre.bookCount}</p>
                        </div>
                    </div>
                </section>


                <div id="updateModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-black/40 px-4">
                    <div class="w-full max-w-lg rounded-2xl bg-white shadow-2xl overflow-hidden">
                        <div class="px-6 py-5 border-b border-outline-variant flex items-center justify-between">
                            <div>
                                <h2 class="text-xl font-bold">Update Genre</h2>
                                <p class="text-sm text-on-surface-variant mt-1">
                            </div>
                            <button type="button" onclick="closeUpdateModal()" class="w-9 h-9 rounded-lg hover:bg-surface-container-low flex items-center justify-center">
                                <span class="material-symbols-outlined">close</span>
                            </button>
                        </div>

                        <form action="${pageContext.request.contextPath}/dashboard/category-management" method="post" class="p-6 space-y-5">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${genre.genreID}">

                            <div>
                                <label class="block text-sm font-bold mb-2">Genre Name</label>
                                <input type="text" name="genre_name" required maxlength="100" value="${genre.genreName}"
                                       class="w-full rounded-xl border-outline-variant bg-surface-container-low px-4 py-3 text-sm focus:border-primary focus:ring-primary">
                                <p class="text-xs text-on-surface-variant mt-2">The genre name is required and must be unique.</p>
                            </div>

                            <div class="flex justify-end gap-3 pt-2">
                                <button type="button" onclick="closeUpdateModal()"
                                        class="inline-flex items-center justify-center rounded-xl border border-outline-variant bg-white px-5 py-3 text-sm font-semibold text-primary hover:bg-surface-container-low transition">
                                    Cancel
                                </button>
                                <button type="submit"
                                        class="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-6 py-3 text-sm font-bold text-white hover:bg-[#003f7d] transition">
                                    <span class="material-symbols-outlined text-[19px]">save</span>
                                    Save
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    function openUpdateModal() {
                        const modal = document.getElementById('updateModal');
                        modal.classList.remove('hidden');
                        modal.classList.add('flex');
                    }

                    function closeUpdateModal() {
                        const modal = document.getElementById('updateModal');
                        modal.classList.add('hidden');
                        modal.classList.remove('flex');
                    }
                </script>
            </div>
        </main>
    </body>
</html>

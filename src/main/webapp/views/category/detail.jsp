<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Category Details - HeavenScape</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script>
            tailwind.config = {theme: {extend: {colors: {primary: '#C92127', background: '#F7F7F8', surface: '#ffffff', 'surface-container-low': '#FDE8E9', 'on-surface': '#1B1B1B', 'on-surface-variant': '#5C5C5F', 'outline-variant': '#D9D9DC'}, fontFamily: {sans: ['Inter', 'sans-serif']}, boxShadow: {card: '0 4px 20px rgba(21,101,192,0.08)'}}}}
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



                <section class="bg-surface rounded-2xl border border-outline-variant shadow-card overflow-hidden">
                    <div class="px-6 py-5 border-b border-outline-variant flex items-center justify-between">
                        <div>
                            <h1 class="text-2xl font-bold">Category Details</h1>
                            <p class="text-sm text-on-surface-variant mt-1">Detailed information about this book category.</p>
                        </div>
                        <c:if test="${canManageCategory}">
                            <button type="button" onclick="openUpdateModal()"
                                    class="inline-flex items-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-bold text-white hover:bg-[#8E171B] transition">
                                <span class="material-symbols-outlined text-[18px]">edit</span>
                                Update
                            </button>
                        </c:if>
                    </div>

                    <div class="p-6 grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="rounded-xl bg-surface-container-low p-5">
                            <p class="text-sm font-semibold text-on-surface-variant">Category ID</p>
                            <p class="text-2xl font-extrabold text-primary mt-2">HSC-${category.categoryID}</p>
                        </div>
                        <div class="rounded-xl bg-surface-container-low p-5 md:col-span-2">
                            <p class="text-sm font-semibold text-on-surface-variant">Category Name</p>
                            <p class="text-2xl font-extrabold mt-2">${category.categoryName}</p>
                        </div>
                        <div class="rounded-xl bg-surface-container-low p-5 md:col-span-3">
                            <p class="text-sm font-semibold text-on-surface-variant">Books in This Category</p>
                            <p class="text-2xl font-extrabold mt-2">${category.bookCount}</p>
                        </div>
                    </div>
                </section>


                <div id="updateModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-black/40 px-4">
                    <div class="w-full max-w-lg rounded-2xl bg-white shadow-2xl overflow-hidden">
                        <div class="px-6 py-5 border-b border-outline-variant flex items-center justify-between">
                            <div>
                                <h2 class="text-xl font-bold">Update Category</h2>
                                <p class="text-sm text-on-surface-variant mt-1">
                            </div>
                            <button type="button" onclick="closeUpdateModal()" class="w-9 h-9 rounded-lg hover:bg-surface-container-low flex items-center justify-center">
                                <span class="material-symbols-outlined">close</span>
                            </button>
                        </div>

                        <form action="${pageContext.request.contextPath}/dashboard/category-management" method="post" class="p-6 space-y-5">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${category.categoryID}">

                            <div>
                                <label class="block text-sm font-bold mb-2">Category Name <span class="text-red-600 text-xs">*</span></label>
                                <input type="text" name="category_name" required maxlength="100" value="${category.categoryName}"
                                       class="w-full rounded-xl border-outline-variant bg-surface-container-low px-4 py-3 text-sm focus:border-primary focus:ring-primary">
                                <p class="text-xs text-on-surface-variant mt-2">The category name is required and must be unique.</p>
                            </div>

                            <div class="flex justify-end gap-3 pt-2">
                                <button type="button" onclick="closeUpdateModal()"
                                        class="inline-flex items-center justify-center rounded-xl border border-outline-variant bg-white px-5 py-3 text-sm font-semibold text-primary hover:bg-surface-container-low transition">
                                    Cancel
                                </button>
                                <button type="submit"
                                        class="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-6 py-3 text-sm font-bold text-white hover:bg-[#8E171B] transition">
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
        <%@ include file="/views/layout/common/toast.jsp" %>
    </body>
</html>

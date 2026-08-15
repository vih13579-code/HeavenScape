<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${pageTitle} - HeavenScape</title>
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

                <c:if test="${not empty sessionScope.error}">
                    <div class="rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                        ${sessionScope.error}
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.success}">
                    <div class="rounded-xl border border-green-200 bg-green-50 px-4 py-3 text-sm font-semibold text-green-700">
                        ${sessionScope.success}
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>

                <section class="bg-surface rounded-2xl border border-outline-variant shadow-card overflow-hidden">
                    <div class="px-6 py-5 border-b border-outline-variant">
                        <h1 class="text-2xl font-bold">${pageTitle}</h1>
                        <p class="text-sm text-on-surface-variant mt-1">Enter a genre name to save it in HeavenScape.</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/dashboard/category-management" method="post" class="p-6 space-y-5">
                        <input type="hidden" name="action" value="${formAction}">
                        <input type="hidden" name="id" value="${genre.genreID}">

                        <div>
                            <label class="block text-sm font-bold mb-2">Genre Name</label>
                            <input type="text" name="genre_name" id="genreName" required maxlength="100"
                                   value="${genre.genreName}"
                                   placeholder="Example: Fiction, Personal Development..."
                                   class="w-full rounded-xl border-outline-variant bg-surface-container-low px-4 py-3 text-sm focus:border-primary focus:ring-primary">
<p class="text-xs text-on-surface-variant mt-2">Use letters and spaces only; do not enter numbers or special characters.</p>
                        </div>

                        <div class="flex justify-end gap-3 pt-2">
                            <a href="${pageContext.request.contextPath}/dashboard/category-management"
                               class="inline-flex items-center justify-center rounded-xl border border-outline-variant bg-white px-5 py-3 text-sm font-semibold text-primary hover:bg-surface-container-low transition">
                                Cancel
                            </a>
                            <button type="submit" class="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-6 py-3 text-sm font-bold text-white hover:bg-[#003f7d] transition">
                                <span class="material-symbols-outlined text-[19px]">save</span>
                                Save Genre
                            </button>
                        </div>
                    </form>
                </section>
            </div>
        </main>
            <script>
            const allowedGenres = null;

            document.querySelector('form').addEventListener('submit', function (event) {
                const input = document.getElementById('genreName');
                const value = input.value.trim().replace(/\s+/g, ' ');
                input.value = value;

                if (!/^[\p{L}\s]+$/u.test(value)) {
                    event.preventDefault();
                    input.setCustomValidity('A genre name may contain only letters and spaces, not numbers or special characters.');
                    input.reportValidity();
                    return;
                }        input.setCustomValidity('');
            });

            document.getElementById('genreName').addEventListener('input', function () {
                this.setCustomValidity('');
            });
        </script>
    </body>
</html>
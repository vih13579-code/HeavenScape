<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Genre Management - HeavenScape</title>
		<link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
		<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
		<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
		<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
		<script>tailwind.config = {theme: {extend: {colors: {primary: '#C92127', background: '#F7F7F8', surface: '#ffffff', 'surface-container-low': '#FDE8E9', 'on-surface': '#1B1B1B', 'on-surface-variant': '#5C5C5F', 'outline-variant': '#D9D9DC', success: '#2E7D32', error: '#D32F2F'}, fontFamily: {sans: ['Inter', 'sans-serif']}, boxShadow: {card: '0 4px 20px rgba(21,101,192,0.08)'}}}}</script>
		<style>body{font-family:'Inter',sans-serif}.material-symbols-outlined{vertical-align:middle}</style>
	</head>
	<body class="bg-background text-on-surface flex min-h-screen">
		<%@ include file="/views/layout/dashboard/sidebar.jsp" %>
		<main class="flex-1 md:ml-64 min-h-screen flex flex-col">
			<div class="px-6 py-8 max-w-6xl mx-auto w-full space-y-8">
				<div class="hs-admin-page-heading"><div><h1 class="hs-admin-page-title">Genre List</h1><p class="hs-admin-page-subtitle">Create, update, review, and filter HeavenScape book genres.</p></div>
					<c:if test="${canManageGenre}"><a href="${pageContext.request.contextPath}/dashboard/genre-management?action=create" class="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-bold text-white shadow-card hover:bg-[#8E171B] transition"><span class="material-symbols-outlined text-[20px]">add</span>Add Genre</a></c:if>
				</div>
				<section class="grid grid-cols-1 md:grid-cols-3 gap-4">
					<div class="bg-surface rounded-2xl border border-outline-variant p-5 shadow-card"><div class="flex items-center justify-between"><div><p class="text-sm font-semibold text-primary">Total Genres</p><p class="text-3xl font-extrabold mt-2">${totalGenres}</p></div><div class="w-12 h-12 rounded-xl bg-surface-container-low flex items-center justify-center text-primary"><span class="material-symbols-outlined">account_tree</span></div></div></div>
					<div class="bg-surface rounded-2xl border border-outline-variant p-5 shadow-card md:col-span-2"><form action="${pageContext.request.contextPath}/dashboard/genre-management" method="get" class="flex flex-col md:flex-row gap-3"><div class="flex-1 relative"><span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant text-[20px]">search</span><input type="text" name="keyword" value="${keyword}" placeholder="Search genres..." class="w-full rounded-xl border-outline-variant bg-surface-container-low pl-12 pr-4 py-3 text-sm focus:border-primary focus:ring-primary"></div><button type="submit" class="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-6 py-3 text-sm font-bold text-white hover:bg-[#8E171B] transition"><span class="material-symbols-outlined text-[19px]">filter_alt</span>Search</button><a href="${pageContext.request.contextPath}/dashboard/genre-management" class="inline-flex items-center justify-center rounded-xl border border-outline-variant bg-white px-5 py-3 text-sm font-semibold text-primary hover:bg-surface-container-low transition">Clear</a></form></div>
				</section>
				<section class="bg-surface rounded-2xl border border-outline-variant shadow-card overflow-hidden"><div class="px-6 py-5 border-b border-outline-variant"><h2 class="text-xl font-bold">Genre List</h2><p class="text-sm text-on-surface-variant mt-1">View the genres currently available in the system.</p></div><div class="overflow-x-auto"><table class="w-full text-left"><thead class="bg-surface-container-low"><tr><th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant">Genre ID</th><th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant">Genre Name</th><th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant">Book Count</th><th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant text-right">Actions</th></tr></thead><tbody class="divide-y divide-outline-variant">
					<c:forEach var="genre" items="${genres}"><tr class="hover:bg-surface-container-low transition"><td class="px-6 py-4 text-sm font-bold text-primary">HSC-${genre.genreID}</td><td class="px-6 py-4 text-sm font-semibold text-on-surface">${genre.genreName}</td><td class="px-6 py-4 text-sm text-on-surface-variant">${genre.bookCount}</td><td class="px-6 py-4"><div class="flex items-center justify-end gap-2"><a href="${pageContext.request.contextPath}/dashboard/genre-management?action=detail&id=${genre.genreID}" class="w-9 h-9 rounded-lg border border-outline-variant flex items-center justify-center text-primary hover:bg-surface-container-low" title="View Details"><span class="material-symbols-outlined text-[18px]">visibility</span></a><c:if test="${canManageGenre}"><form action="${pageContext.request.contextPath}/dashboard/genre-management" method="post"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${genre.genreID}"><button type="submit" class="w-9 h-9 rounded-lg border border-red-200 flex items-center justify-center text-error hover:bg-red-50" title="Delete"><span class="material-symbols-outlined text-[18px]">delete</span></button></form></c:if></div></td></tr></c:forEach>
					<c:if test="${empty genres}"><tr><td colspan="4" class="px-6 py-12 text-center text-sm text-on-surface-variant">No genres found.</td></tr></c:if>
				</tbody></table></div></section>
			</div>
		</main>
		<%@ include file="/views/layout/common/toast.jsp" %>
	</body>
</html>

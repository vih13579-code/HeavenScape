<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<main class="max-w-[1400px] mx-auto px-8 py-12 min-h-[65vh]">
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 px-8 py-14 flex flex-col items-center text-center mb-10">
        <div class="relative mb-6 select-none">
            <div class="text-[96px] leading-none drop-shadow"></div>
            <div class="absolute -top-1 -right-3 text-[44px] animate-bounce"></div>
        </div>
        <div class="flex items-baseline gap-2 mb-2">
            <span class="text-[72px] font-black text-primary leading-none tracking-tighter"
                  style="text-shadow: 3px 3px 0 #e8eef8;">404</span>
        </div>
        <h1 class="text-[22px] font-black text-on-surface mb-2">Not Found!</h1>
<!--        <p class="text-gray-500 text-[14px] mb-8 mt-4 leading-relaxed max-w-[420px]">
            The product you are looking for may have been discontinued or changed,<br>
            or it may never have existed in the HeavenScape catalog.
        </p>-->
        <div class="flex justify-center mb-10">
            <a href="${pageContext.request.contextPath}/home"
               class="inline-flex items-center justify-center gap-2 bg-primary text-white font-bold
               px-7 py-3 rounded-full hover:bg-primary-dark transition-colors shadow-md text-[14px]">
                <i data-lucide="home" class="icon-md"></i>
                Home
            </a>
        </div>
        <div class="border-t border-gray-100 pt-7 w-full max-w-[560px]">
            <p class="text-[11px] text-gray-400 uppercase tracking-widest font-semibold mb-3">Suggested Searches</p>
            <div class="flex flex-wrap gap-2 justify-center">
                <a href="${pageContext.request.contextPath}/products" class="bg-gray-100 hover:bg-primary hover:text-white text-gray-600 text-[13px] px-4 py-1.5 rounded-full transition-colors">All Books</a>
                <a href="${pageContext.request.contextPath}/products?category=1" class="bg-gray-100 hover:bg-primary hover:text-white text-gray-600 text-[13px] px-4 py-1.5 rounded-full transition-colors">Fiction</a>
                <a href="${pageContext.request.contextPath}/products?category=2" class="bg-gray-100 hover:bg-primary hover:text-white text-gray-600 text-[13px] px-4 py-1.5 rounded-full transition-colors">Business</a>
                <a href="${pageContext.request.contextPath}/products?category=3" class="bg-gray-100 hover:bg-primary hover:text-white text-gray-600 text-[13px] px-4 py-1.5 rounded-full transition-colors">Personal Development</a>
            </div>
        </div>
    </div>
</main>
<%@ include file="/views/layout/homepage/footer.jsp" %>

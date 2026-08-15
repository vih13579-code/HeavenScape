<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>


<section class="hs-home-hero">
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 items-center">
        <div class="hs-hero-copy flex flex-col items-start order-2 md:order-1 md:pr-10">
            <span class="hs-eyebrow">Curated Collection</span>
            <h1 class="hs-home-title">Discover Your Next Adventure</h1>
            <p class="text-lg leading-7 text-on-surface-variant max-w-[520px] mb-8">
                Immerse yourself in new worlds with titles carefully selected by HeavenScape
                for every reading journey.
            </p>
            <div class="flex flex-wrap gap-4">
                <a href="${pageContext.request.contextPath}/products"
                   class="hs-primary-button inline-flex items-center justify-center gap-2 px-8 py-3 font-semibold">
                    Explore Books <i data-lucide="arrow-right" class="icon-md"></i>
                </a>
                <a href="${pageContext.request.contextPath}/products?sort=newest"
                   class="hs-secondary-button inline-flex items-center justify-center px-8 py-3 font-semibold">
                    New Arrivals
                </a>
            </div>
        </div>

        <div class="hs-hero-visual order-1 md:order-2" aria-label="Books Curated by HeavenScape">
            <c:choose>
                <c:when test="${not empty featuredBooks and not empty featuredBooks[0].thumbnailFirst}">
                    <img src="${featuredBooks[0].thumbnailFirst}" alt="${featuredBooks[0].title}"
                         class="object-contain p-10 md:p-14"
                         onerror="this.style.display='none'; this.nextElementSibling.classList.remove('hidden');">
                    <div class="hs-hero-placeholder hidden">
                        <i data-lucide="book-open" class="w-24 h-24"></i>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="hs-hero-placeholder">
                        <i data-lucide="book-open" class="w-24 h-24"></i>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>


<section class="hs-benefits grid grid-cols-2 md:grid-cols-4">
    <div class="flex items-center gap-3 px-6 py-4 border-r border-gray-100">
        <i data-lucide="library" class="w-7 h-7 text-primary"></i>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">20+ Books</strong>
            <span class="text-xs text-gray-500">Titles Available</span>
        </div>
    </div>
    <div class="flex items-center gap-3 px-6 py-4 border-r border-gray-100">
        <i data-lucide="truck" class="w-7 h-7 text-primary"></i>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">Free Shipping</strong>
            <span class="text-xs text-gray-500">Special Offer</span>
        </div>
    </div>
    <div class="flex items-center gap-3 px-6 py-4 border-r border-gray-100">
        <i data-lucide="badge-check" class="w-7 h-7 text-primary"></i>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">Authentic Products</strong>
            <span class="text-xs text-gray-500">Guaranteed by HeavenScape</span>
        </div>
    </div>
    <div class="flex items-center gap-3 px-6 py-4">
        <i data-lucide="refresh-cw" class="w-7 h-7 text-primary"></i>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">7-Day Returns</strong>
            <span class="text-xs text-gray-500">Fast Refunds</span>
        </div>
    </div>
</section>

<main class="max-w-[1280px] mx-auto px-5 md:px-16 py-16 md:py-20">


    <section class="mb-12">
        <div class="flex justify-between items-center mb-5">
            <h2 class="section-title-border text-xl font-bold text-primary pl-3">Best Sellers</h2>
            <a href="${pageContext.request.contextPath}/products?sort=popular"
               class="text-[13px] text-primary font-medium border border-primary px-3.5 py-1.5 rounded-full hover:bg-primary hover:text-white transition-colors uppercase tracking-tight">View All</a>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            <c:forEach var="book" items="${featuredBooks}">
                <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col h-full">

                    <div class="relative w-full h-0 pb-[135%] bg-[#f0f4ff] overflow-hidden">
                        <c:choose>
                            <c:when test="${not empty book.thumbnailFirst}">
                                <img alt="${book.title}" class="absolute inset-0 w-full h-full object-cover object-center" src="${book.thumbnailFirst}">
                            </c:when>
                            <c:otherwise>
                                <div class="absolute inset-0 flex items-center justify-center">
                                    <i data-lucide="book-open" class="w-16 h-16 text-gray-300"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="absolute top-2.5 right-2.5 z-10 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">Hot</div>
                        <c:if test="${book.status != 'available' or book.stockQuantity == 0}">
                            <div class="absolute inset-0 bg-black/50 flex items-center justify-center z-[15]">
                                <span class="bg-white text-red-600 font-bold text-[11px] px-3 py-1 rounded-full">Out of Stock</span>
                            </div>
                        </c:if>
                        <jsp:include page="/views/layout/common/wishlist-heart.jsp">
                            <jsp:param name="wishBookId" value="${book.bookID}" />
                        </jsp:include>
                    </div>


                    <div class="p-3 flex flex-col flex-1 justify-between min-h-[160px]">
                        <div>
                            <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 h-[38px] overflow-hidden">
                                <a class="text-primary hover:underline"
                                   href="${pageContext.request.contextPath}/products?id=${book.bookID}">
                                    ${book.title}<c:if test="${not empty book.authors}"> – <c:forEach var="a" items="${book.authors}" varStatus="s">${a}<c:if test="${!s.last}">, </c:if></c:forEach></c:if>
                                            </a>
                                        </div>
                                        <div class="text-[#FDD835] text-[12px] mb-2 flex items-center gap-1">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= book.avgRating}">★</c:when>
                                        <c:otherwise><span class="text-gray-300">★</span></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span class="text-gray-400 text-[11px]">(${book.reviewCount})</span>
                            </div>
                        </div>
                        <div class="mt-auto">
                            <div class="text-primary text-[17px] font-bold mb-2.5">
                                <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" /> VND
                            </div>
                            <c:choose>
                                <c:when test="${book.status == 'available' and book.stockQuantity > 0}">
                                    <a href="${pageContext.request.contextPath}/products?id=${book.bookID}"
                                       class="w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                                        <i data-lucide="eye" class="icon-sm"></i> QUICK VIEW
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" disabled
                                            class="w-full bg-gray-200 text-gray-500 rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 cursor-not-allowed tracking-wide">
                                        Out of Stock
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty featuredBooks}">
                <div class="col-span-full py-12 text-center text-gray-400 text-[14px]">No books are available yet.</div>
            </c:if>
        </div>
    </section>


    <section class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-12">
        <a href="${pageContext.request.contextPath}/products"
           class="rounded-lg min-h-[140px] flex flex-col items-center justify-center font-bold text-lg text-white p-6 text-center hover:scale-[1.02] transition-transform bg-gradient-to-br from-primary to-primary-container">
            Skills Books<br><span class="text-[13px] opacity-80 font-normal">Up to 40% Off</span>
        </a>
        <a href="${pageContext.request.contextPath}/products"
           class="rounded-lg min-h-[140px] flex flex-col items-center justify-center font-bold text-lg text-white p-6 text-center hover:scale-[1.02] transition-transform bg-gradient-to-br from-tertiary-container to-tertiary">
            Meaningful Gifts<br><span class="text-[13px] opacity-80 font-normal">Free Gift Wrapping</span>
        </a>
        <a href="${pageContext.request.contextPath}/products?sort=newest"
           class="rounded-lg min-h-[140px] flex flex-col items-center justify-center font-bold text-lg text-primary p-6 text-center hover:scale-[1.02] transition-transform bg-gradient-to-br from-surface-container-high to-surface-container-highest border border-outline-variant">
            Latest Books<br><span class="text-[13px] opacity-80 font-normal">Updated Weekly</span>
        </a>
    </section>


    <section class="mb-12">
        <div class="flex justify-between items-center mb-5">
            <h2 class="section-title-border text-xl font-bold text-primary pl-3">New Arrivals</h2>
            <a href="${pageContext.request.contextPath}/products?sort=newest"
               class="text-[13px] text-primary font-medium border border-primary px-3.5 py-1.5 rounded-full hover:bg-primary hover:text-white transition-colors uppercase tracking-tight">View All</a>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            <c:forEach var="book" items="${newBooks}">
                <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col h-full">

                    <div class="relative w-full h-0 pb-[135%] bg-[#f0f4ff] overflow-hidden">
                        <c:choose>
                            <c:when test="${not empty book.thumbnailFirst}">
                                <img alt="${book.title}" class="absolute inset-0 w-full h-full object-cover object-center" src="${book.thumbnailFirst}">
                            </c:when>
                            <c:otherwise>
                                <div class="absolute inset-0 flex items-center justify-center">
                                    <i data-lucide="book-open" class="w-16 h-16 text-gray-300"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="absolute top-2.5 right-2.5 z-10 bg-[#E53935] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">New</div>
                        <c:if test="${book.status != 'available' or book.stockQuantity == 0}">
                            <div class="absolute inset-0 bg-black/50 flex items-center justify-center z-[15]">
                                <span class="bg-white text-red-600 font-bold text-[11px] px-3 py-1 rounded-full">Out of Stock</span>
                            </div>
                        </c:if>
                        <jsp:include page="/views/layout/common/wishlist-heart.jsp">
                            <jsp:param name="wishBookId" value="${book.bookID}" />
                        </jsp:include>
                    </div>


                    <div class="p-3 flex flex-col flex-1 justify-between min-h-[160px]">
                        <div>
                            <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 h-[38px] overflow-hidden">
                                <a class="text-primary hover:underline"
                                   href="${pageContext.request.contextPath}/products?id=${book.bookID}">
                                    ${book.title}<c:if test="${not empty book.authors}"> – <c:forEach var="a" items="${book.authors}" varStatus="s">${a}<c:if test="${!s.last}">, </c:if></c:forEach></c:if>
                                            </a>
                                        </div>
                                        <div class="text-[#FDD835] text-[12px] mb-2 flex items-center gap-1">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= book.avgRating}">★</c:when>
                                        <c:otherwise><span class="text-gray-300">★</span></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span class="text-gray-400 text-[11px]">(${book.reviewCount})</span>
                            </div>
                        </div>
                        <div class="mt-auto">
                            <div class="text-primary text-[17px] font-bold mb-2.5">
                                <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" /> VND
                            </div>
                            <c:choose>
                                <c:when test="${book.status == 'available' and book.stockQuantity > 0}">
                                    <a href="${pageContext.request.contextPath}/products?id=${book.bookID}"
                                       class="w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                                        <i data-lucide="eye" class="icon-sm"></i> QUICK VIEW
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" disabled
                                            class="w-full bg-gray-200 text-gray-500 rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 cursor-not-allowed tracking-wide">
                                        Out of Stock
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty newBooks}">
                <div class="col-span-full py-12 text-center text-gray-400 text-[14px]">No books are available yet.</div>
            </c:if>
        </div>
    </section>

</main>
<%@ include file="/views/layout/common/wishlist-heart.js.jsp" %>
<%@ include file="/views/layout/homepage/footer.jsp" %>

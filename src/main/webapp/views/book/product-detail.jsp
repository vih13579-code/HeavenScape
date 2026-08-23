<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>
<%@ include file="/views/layout/common/wishlist-heart.js.jsp" %>
<style>
    .no-spinner::-webkit-outer-spin-button,
    .no-spinner::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }

    .no-spinner {
        -moz-appearance: textfield;
        appearance: textfield;
    }

    .section-title-left {
        border-left: 0;
        padding-left: 0;
    }

    .prod-thumb-active {
        border: 2px solid var(--hs-primary);
    }

    .prod-thumb-idle {
        border: 1px solid var(--hs-outline-variant);
    }

    .prod-card-hover {
        border: 1px solid #E0E0E0;
        box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
        transition: box-shadow .2s, transform .2s;
    }

    .prod-card-hover:hover {
        box-shadow: 0 6px 20px rgba(0, 0, 0, .1);
        transform: translateY(-2px);
    }

    .review-card {
        border: 1px solid var(--hs-outline-variant);
        border-radius: 8px;
        background: #fff;
    }

    .slider-track {
        display: flex;
        gap: 16px;
        overflow-x: auto;
        scroll-snap-type: x mandatory;
        scrollbar-width: none;
    }

    .slider-track::-webkit-scrollbar {
        display: none;
    }

    .slider-item {
        flex: 0 0 calc(25% - 12px);
        scroll-snap-align: start;
    }

    @media (max-width: 1024px) {
        .slider-item {
            flex: 0 0 calc(33% - 12px);
        }
    }

    @media (max-width: 768px) {
        .slider-item {
            flex: 0 0 calc(50% - 8px);
        }
    }

    /* ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ Tabs ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ */
    .tab-nav {
        border-bottom: 1px solid var(--hs-outline-variant);
        display: flex;
        gap: 0;
    }

    .tab-btn {
        padding: 14px 24px;
        font-size: 15px;
        font-weight: 600;
        color: #666;
        cursor: pointer;
        border: none;
        background: none;
        border-bottom: 3px solid transparent;
        margin-bottom: -1px;
        transition: color .2s, border-color .2s;
    }

    .tab-btn:hover {
        color: var(--hs-primary);
    }

    .tab-btn.active {
        color: var(--hs-primary);
        border-bottom-color: var(--hs-primary);
    }

    .tab-panel {
        display: none;
        padding-top: 24px;
    }

    .tab-panel.active {
        display: block;
    }

    /* ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ Review cards ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ */
    .badge-purchased {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        background: #e8f5e9;
        color: #2e7d32;
        font-size: 11px;
        font-weight: 700;
        padding: 2px 8px;
        border-radius: 20px;
    }

    .badge-admin {
        display: inline-block;
        background: var(--hs-primary);
        color: #fff;
        font-size: 10px;
        font-weight: 700;
        padding: 1px 7px;
        border-radius: 4px;
        margin-left: 6px;
        vertical-align: middle;
    }

    .admin-reply {
        background: var(--hs-surface-low);
        border-radius: 4px;
        padding: 14px 16px;
        margin-top: 14px;
    }

    /* ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ Write review form ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ */
    .btn-write-review {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        background: var(--hs-tertiary-container);
        color: #fff;
        font-size: 14px;
        font-weight: 700;
        padding: 12px 24px;
        border-radius: 4px;
        border: none;
        cursor: pointer;
        text-transform: uppercase;
        letter-spacing: .5px;
        transition: background .2s;
    }

    .btn-write-review:hover {
        background: var(--hs-tertiary);
    }

    .write-review-form {
        background: #fff;
        border: 1px solid #E0E0E0;
        border-radius: 12px;
        padding: 28px;
        margin-top: 24px;
        display: none;
    }

    .write-review-form.open {
        display: block;
    }

    .review-summary {
        background: linear-gradient(135deg, #f8fafc, #ffffff);
        border: 1px solid #e5e7eb;
        border-radius: 16px;
    }

    .review-item {
        border: 1px solid #e5e7eb;
        border-radius: 14px;
        background: white;
        transition: all .25s ease;
    }

    .review-item:hover {
        box-shadow: 0 8px 24px rgba(0, 0, 0, .08);
    }

    .star-filled {
        color: #facc15;
    }

    .star-empty {
        color: #d1d5db;
    }

    .review-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: #4f46e5;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
    }

    .btn-disabled {
        opacity: 0.5;
        cursor: not-allowed;
        pointer-events: none;
    }
</style>

<main class="flex-grow max-w-[1280px] w-full mx-auto px-5 md:px-16 py-10 md:py-16 flex flex-col gap-10">

    <nav class="flex flex-wrap items-center gap-2 text-sm text-on-surface-variant" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/home" class="hover:text-primary">Home</a>
        <i data-lucide="chevron-right" class="w-4 h-4"></i>
        <c:if test="${not empty book.genreName}">
            <a href="${pageContext.request.contextPath}/products?genre=${book.genreID}" class="hover:text-primary">${book.genreName}</a>
            <i data-lucide="chevron-right" class="w-4 h-4"></i>
        </c:if>
        <span class="text-on-surface line-clamp-1">${book.title}</span>
    </nav>


    <section class="flex flex-col lg:flex-row gap-8 lg:gap-14">


        <div class="flex-shrink-0 w-full lg:w-[42%] flex flex-col gap-4">

            <% String rawThumb = (request.getAttribute("book") != null) ? ((model.Book) request.getAttribute("book")).getThumbnail() : "";
                if (rawThumb == null) {
                    rawThumb = "";
                }
                String[] imgArr = rawThumb.split("\\|", -1);
                String img1 = imgArr.length > 0
                        ? imgArr[0].trim() : "";
                String img2 = imgArr.length > 1 ? imgArr[1].trim() : "";
                String img3 = imgArr.length > 2 ? imgArr[2].trim() : "";
                String img4 = imgArr.length > 3 ? imgArr[3].trim() : "";
                pageContext.setAttribute("img1", img1);
                pageContext.setAttribute("img2", img2);
                pageContext.setAttribute("img3", img3);
                pageContext.setAttribute("img4", img4);
            %>

            <div
                class="bg-surface-container-lowest border border-outline-variant/60 shadow-[0_4px_24px_rgba(4,22,46,0.08)] rounded-lg overflow-hidden aspect-[2/3] flex items-center justify-center relative p-4">
                <c:choose>
                    <c:when test="${not empty img1}">
                        <img id="mainImage" src="${img1}" alt="${book.title}"
                             class="w-full h-full object-cover rounded-sm">
                    </c:when>
                    <c:otherwise>
                        <i data-lucide="book-open" class="w-24 h-24 text-gray-300"></i>
                    </c:otherwise>
                </c:choose>

                <c:if test="${book.featured}">
                    <div
                        class="absolute top-3 left-3 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full">
                        ÃƒÆ’Ã‚Â°Ãƒâ€¦Ã‚Â¸ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒâ€šÃ‚Â¥ Featured</div>
                    </c:if>

                <c:if test="${book.status != 'available' or book.stockQuantity == 0}">
                    <div
                        class="absolute inset-0 bg-black/50 flex items-center justify-center">
                        <span
                            class="bg-white text-red-600 font-bold text-sm px-4 py-2 rounded-full">Out of Stock</span>
                    </div>
                </c:if>
            </div>


            <c:if test="${not empty img1}">
                <div class="grid grid-cols-4 gap-3">
                    <%-- ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¢nh 1: bÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¬a chÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â­nh --%>
                    <button onclick="switchImg(this, '${img1}')"
                            class="prod-thumb-active rounded-lg overflow-hidden aspect-square bg-gray-50">
                        <img src="${img1}" class="w-full h-full object-cover"
                             alt="">
                    </button>
                    <%-- ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¢nh 2 --%>
                    <c:choose>
                        <c:when test="${not empty img2}">
                            <button onclick="switchImg(this, '${img2}')"
                                    class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50">
                                <img src="${img2}"
                                     class="w-full h-full object-cover" alt="">
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button
                                class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50 flex items-center justify-center opacity-40 cursor-not-allowed">
                                <i data-lucide="image"
                                   class="w-6 h-6 text-gray-300"></i>
                            </button>
                        </c:otherwise>
                    </c:choose>
                    <%-- ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¢nh 3 --%>
                    <c:choose>
                        <c:when test="${not empty img3}">
                            <button onclick="switchImg(this, '${img3}')"
                                    class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50">
                                <img src="${img3}"
                                     class="w-full h-full object-cover"
                                     alt="">
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button
                                class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50 flex items-center justify-center opacity-40 cursor-not-allowed">
                                <i data-lucide="image"
                                   class="w-6 h-6 text-gray-300"></i>
                            </button>
                        </c:otherwise>
                    </c:choose>
                    <%-- ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¢nh 4 --%>
                    <c:choose>
                        <c:when test="${not empty img4}">
                            <button onclick="switchImg(this, '${img4}')"
                                    class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50">
                                <img src="${img4}"
                                     class="w-full h-full object-cover"
                                     alt="">
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button
                                class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50 flex items-center justify-center opacity-40 cursor-not-allowed">
                                <i data-lucide="image"
                                   class="w-6 h-6 text-gray-300"></i>
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>

        <!-- RIGHT: Product Info -->
        <div class="flex-1 min-w-0 flex flex-col gap-6">

            <!-- Tags -->
            <div class="flex flex-wrap gap-2">
                <c:if test="${not empty book.genreName}">
                    <span
                        class="bg-primary/10 text-primary text-[12px] font-bold px-3 py-1 rounded-full uppercase tracking-wide">${book.genreName}</span>
                </c:if>
                <c:if test="${book.featured}">
                    <span
                        class="bg-secondary/20 text-primary text-[12px] font-bold px-3 py-1 rounded-full uppercase tracking-wide">ÃƒÆ’Ã‚Â°Ãƒâ€¦Ã‚Â¸ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒâ€šÃ‚Â¥
                        Best Seller</span>
                    </c:if>
                    <c:if test="${not empty book.originName}">
                    <span
                        class="bg-gray-100 text-gray-600 text-[12px] font-medium px-3 py-1 rounded-full">ÃƒÆ’Ã‚Â°Ãƒâ€¦Ã‚Â¸Ãƒâ€¦Ã¢â‚¬â„¢Ãƒâ€šÃ‚Â
                        ${book.originName}</span>
                    </c:if>
            </div>

            <!-- Title -->
            <h1 class="hs-detail-title">${book.title}
            </h1>

            <!-- Author -->
            <c:if test="${not empty book.authors}">
                <p class="text-[18px] italic text-gray-500">
                    Author:
                    <c:forEach var="author" items="${book.authors}" varStatus="s">
                        <span
                            class="text-primary font-semibold not-italic hover:underline cursor-pointer">${author}</span>
                        <c:if test="${!s.last}">, </c:if>
                    </c:forEach>
                </p>
            </c:if>

            <!-- Rating -->
            <div class="flex items-center gap-4">
                <div class="flex items-center gap-0.5 text-[#FDD835] text-[14px]">
                    <c:set var="rating" value="${book.avgRating}" />
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= rating}">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦</c:when>
                            <c:otherwise><span class="text-gray-300">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦</span></c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <span class="text-[14px] font-medium text-gray-500">
                    <fmt:formatNumber value="${book.avgRating}" maxFractionDigits="1" />
                    (${book.reviewCount} reviews)
                </span>
            </div>

            <!-- Price card -->
            <div
                class="hs-purchase-panel px-6 pt-8 pb-6 flex flex-col gap-6">

                <!-- Price -->
                <div class="flex items-end gap-3">
                    <span class="text-[30px] font-bold text-primary leading-none">
                        <fmt:formatNumber value="${book.price}" type="number"
                                          groupingUsed="true" />
                        VND
                    </span>
                </div>

                <!-- Stock status -->

                <div class="flex items-center gap-2 text-[14px] font-medium">
                    <c:choose>
                        <c:when
                            test="${book.status == 'available' and book.stockQuantity > 0}">
                            <div
                                class="w-5 h-5 bg-green-700 rounded-full flex items-center justify-center">
                                <i data-lucide="check" class="w-3 h-3 text-white"></i>
                            </div>
                            <span class="text-[#222222]">In Stock (${book.stockQuantity}
                                books)</span>
                            </c:when>
                            <c:otherwise>
                            <div
                                class="w-5 h-5 bg-red-500 rounded-full flex items-center justify-center">
                                <i data-lucide="x" class="w-3 h-3 text-white"></i>
                            </div>
                            <span class="text-red-500">Out of Stock</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Add to Cart -->
                <div class="flex items-stretch gap-4 flex-wrap">
                    <form id="add-to-cart-form"
                          action="${pageContext.request.contextPath}/cart" method="POST"
                          class="flex items-center gap-4 flex-nowrap flex-[2_1_0%] min-w-[323px]">
                        <input type="hidden" name="action" value="add" />
                        <input type="hidden" name="bookID" value="${book.bookID}" />

                        <c:if test="${book.status == 'available' and book.stockQuantity > 0}">
                            <div class="flex items-center h-[58px] border border-outline-variant rounded overflow-hidden shrink-0">
                                <button type="button" id="qty-minus"
                                        class="px-4 py-2 text-lg font-bold text-gray-500 hover:bg-gray-100 transition-colors">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã¢â‚¬Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢</button>
                                <input id="form-qty" name="quantity" type="number" value="1"
                                       min="1" max="${book.stockQuantity}"
                                       class="w-14 text-center text-[15px] font-bold border-none outline-none py-2 bg-transparent no-spinner"
                                       readonly>
                                <button type="button" id="qty-plus"
                                        class="px-4 py-2 text-lg font-bold text-gray-500 hover:bg-gray-100 transition-colors">+</button>
                            </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${book.status != 'available' or book.stockQuantity == 0}">
                                <button type="button" disabled
                                        class="flex-1 h-[58px] bg-gray-200 text-gray-400 font-bold text-[16px] rounded flex items-center justify-center gap-2 cursor-not-allowed min-w-[160px]">
                                    <i data-lucide="x-circle" class="w-5 h-5"></i> Out of Stock
                                </button>
                            </c:when>

                            <c:when test="${not empty sessionScope.account and sessionScope.account.role == 'customer'}">
                                <button type="button" id="btn-add-to-cart"
                                        class="hs-primary-button flex-1 h-[58px] font-bold text-[16px] flex items-center justify-center gap-2 min-w-[160px]">
                                    <i data-lucide="shopping-cart" class="w-5 h-5"></i> Add to Cart
                                </button>
                            </c:when>

                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login"
                                   class="hs-primary-button flex-1 h-[58px] font-bold text-[16px] flex items-center justify-center gap-2 min-w-[160px]">
                                    <i data-lucide="shopping-cart" class="w-5 h-5"></i> Add to Cart
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </form>

                    <!-- Wishlist -->
                    <c:if
                        test="${empty sessionScope.account or sessionScope.account.role == 'customer'}">
                        <c:choose>
                            <c:when test="${inWishlist}">
                                <form action="${pageContext.request.contextPath}/wishlist"
                                      method="POST" class="flex-1 min-w-[160px]"
                                      id="wishlist-detail-form" data-book-id="${book.bookID}">
                                    <input type="hidden" name="wishAction" value="remove" />
                                    <input type="hidden" name="wishBookId"
                                           value="${book.bookID}" />
                                    <button type="submit"
                                            class="w-full h-[58px] bg-red-50 border border-red-500 text-red-500 font-bold text-[16px] rounded flex items-center justify-center gap-2 hover:bg-red-500 hover:text-white transition-all">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20"
                                             height="20" viewBox="0 0 24 24" fill="#ef4444"
                                             stroke="#ef4444" stroke-width="2"
                                             class="w-5 h-5">
                                        <path
                                            d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                        </path>
                                        </svg>
                                        <span class="wishlist-text">Wishlisted</span>
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/wishlist"
                                      method="POST" class="flex-1 min-w-[160px]"
                                      id="wishlist-detail-form" data-book-id="${book.bookID}">
                                    <input type="hidden" name="wishAction" value="add" />
                                    <input type="hidden" name="wishBookId"
                                           value="${book.bookID}" />
                                    <button type="submit"
                                            class="hs-secondary-button w-full h-[58px] font-bold text-[16px] flex items-center justify-center gap-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20"
                                             height="20" viewBox="0 0 24 24" fill="none"
                                             stroke="currentColor" stroke-width="2"
                                             class="w-5 h-5">
                                        <path
                                            d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                        </path>
                                        </svg>
                                        <span class="wishlist-text">Wishlist</span>
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </div>
            </div>

            <!-- Specs grid -->
            <div
                class="border-y border-outline-variant grid grid-cols-2 md:grid-cols-4 divide-x divide-outline-variant py-6">
                <div class="flex flex-col gap-1 px-4 first:pl-0">
                    <span
                        class="text-[12px] font-bold text-gray-500 uppercase tracking-wide">Format</span>
                    <span class="text-[16px] font-medium text-[#222222]">
                        <c:choose>
                            <c:when test="${not empty book.contentName}">${book.contentName}
                            </c:when>
                            <c:otherwise>ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="flex flex-col gap-1 px-4">
                    <span
                        class="text-[12px] font-bold text-gray-500 uppercase tracking-wide">Origin</span>
                    <span class="text-[16px] font-medium text-[#222222]">
                        <c:choose>
                            <c:when test="${not empty book.originName}">${book.originName}
                            </c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="flex flex-col gap-1 px-4">
                    <span
                        class="text-[12px] font-bold text-gray-500 uppercase tracking-wide">Series</span>
                    <span class="text-[16px] font-medium text-[#222222]">
                        <c:choose>
                            <c:when test="${not empty book.seriesName}">${book.seriesName}
                            </c:when>
                            <c:otherwise>ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="flex flex-col gap-1 px-4">
                    <span
                        class="text-[12px] font-bold text-gray-500 uppercase tracking-wide">Page Count</span>
                    <span class="text-[16px] font-medium text-[#222222]">
                        <c:choose>
                            <c:when test="${book.totalPages > 0}">${book.totalPages} pages
                            </c:when>
                            <c:otherwise>ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>
    </section>


<<<<<<< Updated upstream
    <!-- ══ TABS: Description / Thông tin / Review  -->
    <section class="pt-2">
=======
    <!-- ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢Ãƒâ€šÃ‚ÂÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢Ãƒâ€šÃ‚Â TABS: Description / ThÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â´ng tin / Review  -->
    <section class="fhs-block p-5 md:p-7">
>>>>>>> Stashed changes
        <!-- Tab Navigation -->
        <div class="tab-nav">
            <button class="tab-btn" onclick="switchTab('tab-desc', this)">Description</button>
            <button class="tab-btn" onclick="switchTab('tab-info', this)">Additional Information</button>
            <button class="tab-btn active" onclick="switchTab('tab-reviews', this)">
                Review (${book.reviewCount})
            </button>
        </div>

        <!-- Tab: Description -->
        <div id="tab-desc" class="tab-panel">
            <c:choose>
                <c:when test="${not empty book.description}">
                    <p class="text-[16px] text-gray-600 leading-relaxed">${book.description}
                    </p>
                </c:when>
                <c:otherwise>
                    <p class="text-gray-400 italic">No description is available.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Tab: ThÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â´ng tin bÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢ sung -->
        <div id="tab-info" class="tab-panel">
            <table class="w-full text-[15px]">
                <tbody>
                    <tr class="border-b border-gray-100">
                        <td class="py-3 font-semibold text-gray-500 w-[200px]">Page Count</td>
                        <td class="py-3 text-gray-800">
                            <c:choose>
                                <c:when test="${book.totalPages > 0}">${book.totalPages}
                                    trang
                                </c:when>
                                <c:otherwise>ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr class="border-b border-gray-100">
                        <td class="py-3 font-semibold text-gray-500">Format</td>
                        <td class="py-3 text-gray-800">
                            <c:choose>
                                <c:when test="${not empty book.contentName}">
                                    ${book.contentName}
                                </c:when>
                                <c:otherwise>ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr class="border-b border-gray-100">
                        <td class="py-3 font-semibold text-gray-500">Origin</td>
                        <td class="py-3 text-gray-800">
                            <c:choose>
                                <c:when test="${not empty book.originName}">
                                    ${book.originName}
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr class="border-b border-gray-100">
                        <td class="py-3 font-semibold text-gray-500">Series</td>
                        <td class="py-3 text-gray-800">
                            <c:choose>
                                <c:when test="${not empty book.seriesName}">
                                    ${book.seriesName}
                                </c:when>
                                <c:otherwise>ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr class="border-b border-gray-100">
                        <td class="py-3 font-semibold text-gray-500">SKU</td>
                        <td class="py-3 text-gray-800">HS-${book.bookID}</td>
                    </tr>
                    <%-- [NEW] BÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢ sung Dimensions / Weight tÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â« code 2 (chÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â° hiÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¡n khi cÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³
                        dÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â¯ liÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¡u) --%>
                    <c:if test="${not empty book.dimensions}">
                        <tr class="border-b border-gray-100">
                            <td class="py-3 font-semibold text-gray-500">Dimensions</td>
                            <td class="py-3 text-gray-800">${book.dimensions}</td>
                        </tr>
                    </c:if>
                    <c:if test="${not empty book.weight}">
                        <tr>
                            <td class="py-3 font-semibold text-gray-500">Weight
                            </td>
                            <td class="py-3 text-gray-800">${book.weight} kg</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Tab: Review -->
        <div id="tab-reviews" class="tab-panel active">

            <!-- Header + nÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Âºt viÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¿t reviews -->
            <div class="flex items-center justify-between mb-6">
                <h2 class="section-title-left text-[22px] font-bold text-primary">
                    Product Reviews (${reviews.size()})
                </h2>
                <button id="openReviewModal" data-can-review="${canReview}" type="button"
                        class="flex items-center gap-2 bg-primary hover:opacity-90 text-white font-bold px-5 py-2.5 rounded-lg transition"
                        title="${canReview ? 'Write a Review' : 'You must purchase and receive the book before reviewing it'}">
                    <span class="material-symbols-outlined">edit</span>
                    Write a Review
                </button>
            </div>

            <!-- Danh sÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ch reviews -->
            <c:choose>
                <c:when test="${not empty reviews}">
                    <div class="flex flex-col gap-6">
                        <c:forEach items="${reviews}" var="review">
                            <div
                                class="bg-white p-6 rounded-xl shadow-sm border border-outline-variant hover:shadow-md transition-shadow">
                                <div class="flex justify-between items-start mb-4">
                                    <div>
                                        <div class="flex items-center gap-2">
                                            <strong>${review.customerName}</strong>
                                            <span
                                                class="text-[10px] bg-green-100 text-green-700 px-2 py-1 rounded font-bold uppercase">
                                                Verified Purchase
                                            </span>
                                        </div>
                                        <div class="flex gap-1 mt-1 text-yellow-400">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= review.rating}">
                                                        <span>ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦</span>
                                                    </c:when>
                                                    <c:otherwise><span
                                                            class="text-gray-300">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="flex flex-col items-end gap-2">
                                        <span class="text-xs text-gray-400 italic">
                                            <fmt:formatDate value="${review.createdAt}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                        </span>
                                        <c:if
                                            test="${sessionScope.account != null && sessionScope.account.id == review.customerID}">
                                            <c:choose>
                                                <c:when test="${empty review.adminReply}">
                                                    <button type="button"
                                                            class="edit-review-btn flex items-center gap-1 text-xs font-semibold text-primary hover:underline"
                                                            data-review-id="${review.reviewID}"
                                                            data-rating="${review.rating}"
                                                            data-comment="${fn:escapeXml(review.comment)}">
                                                        <span
                                                            class="material-symbols-outlined text-base">edit</span>
                                                        Edit
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" disabled
                                                            title="You cannot edit this review after HeavenScape has replied"
                                                            class="flex items-center gap-1 text-xs font-semibold text-gray-400 cursor-not-allowed">
                                                        <span
                                                            class="material-symbols-outlined text-base">edit_off</span>
                                                        Edit
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </div>
                                </div>
                                <p class="text-gray-700 leading-relaxed text-sm">
                                    ${review.comment}
                                </p>
                                <c:if test="${not empty review.adminReply}">
                                    <div
                                        class="mt-5 ml-6 p-4 bg-blue-50 rounded-lg border-l-4 border-primary">
                                        <div class="flex items-center gap-2 mb-2">
                                            <span
                                                class="font-bold text-primary">HeavenScape</span>
                                        </div>
                                        <p class="text-gray-700 text-sm leading-relaxed">
                                            ${review.adminReply}</p>
                                            <c:if test="${review.adminReplyDate != null}">
                                            <div class="text-xs text-gray-400 mt-2">
                                                <fmt:formatDate
                                                    value="${review.adminReplyDate}"
                                                    pattern="dd/MM/yyyy HH:mm" />
                                            </div>
                                        </c:if>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div
                        class="bg-white border border-dashed border-gray-300 rounded-xl p-10 text-center">
<<<<<<< Updated upstream
                        <div class="text-5xl mb-3">⭐</div>
=======
                        <div class="text-5xl mb-3">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â </div>
>>>>>>> Stashed changes
                        <div class="font-semibold text-gray-600">No Reviews Yet</div>
                        <div class="text-gray-400 mt-2">Be the first to read and review this book.</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>


    <div id="reviewModal"
         class="fixed inset-0 bg-black/50 hidden items-center justify-center z-50">
        <div class="bg-white w-[600px] rounded-xl p-6 relative">
            <button id="closeReviewModal" class="absolute top-3 right-4 text-2xl">ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã¢â‚¬Â</button>
            <h3 id="reviewModalTitle" class="text-xl font-bold mb-6">Write a Review</h3>
            <form id="reviewForm" action="${pageContext.request.contextPath}/review"
                  method="post">
                <input type="hidden" id="formAction" name="action" value="add">
                <input type="hidden" id="reviewIDInput" name="reviewID" value="">
                <input type="hidden" name="bookID" value="${book.bookID}">
                <input type="hidden" id="ratingValue" name="rating" value="5">
                <div class="mb-4">
                    <label class="font-semibold block mb-2">Your Rating</label>
                    <div id="ratingStars" class="flex gap-2 text-3xl cursor-pointer">
                        <span class="star text-yellow-400" data-value="1">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦</span>
                        <span class="star text-yellow-400" data-value="2">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦</span>
                        <span class="star text-yellow-400" data-value="3">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦</span>
                        <span class="star text-yellow-400" data-value="4">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦</span>
                        <span class="star text-yellow-400" data-value="5">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦</span>
                    </div>
                    <p class="text-sm text-gray-500 mt-2">Your selection: <span
                            id="ratingText">5</span> sao</p>
                </div>
                <textarea id="commentInput" name="comment" rows="5" required
                          placeholder="Share your thoughts..."
                          class="w-full border rounded-lg p-4"></textarea>
                <button id="reviewSubmitBtn" type="submit"
                        class="mt-4 bg-primary text-white px-6 py-3 rounded-lg">
                    Submit Review
                </button>
            </form>
        </div>
    </div>


    <c:if test="${not empty relatedBooks}">
        <section class="pt-2">
            <div class="flex items-center justify-between mb-5">
                <h2 class="section-title-left text-[20px] font-bold text-primary">📚 You May Also Like</h2>
                <div class="flex gap-2">
                    <button id="sliderPrev"
                            class="w-[34px] h-[34px] border border-gray-200 rounded-full flex items-center justify-center hover:border-primary hover:text-primary transition-colors">
                        <i data-lucide="chevron-left" class="w-4 h-4"></i>
                    </button>
                    <button id="sliderNext"
                            class="w-[34px] h-[34px] border border-gray-200 rounded-full flex items-center justify-center hover:border-primary hover:text-primary transition-colors">
                        <i data-lucide="chevron-right" class="w-4 h-4"></i>
                    </button>
                </div>
            </div>

            <div id="relatedSlider" class="slider-track">
                <c:forEach var="rb" items="${relatedBooks}">
                    <div
                        class="slider-item prod-card-hover bg-white rounded-xl overflow-hidden flex flex-col">
                        <div
                            class="relative block bg-[#f0f4ff] aspect-[3/4] overflow-hidden">
                            <a
                                href="${pageContext.request.contextPath}/products?id=${rb.bookID}">
                                <%-- [FIX] check ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Âºng field ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ang ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â°ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â£c hiÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€ Ã¢â‚¬â„¢n thÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¹
                                    (rb.thumbnailFirst) thay vÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¬ check rb.thumbnail (chuÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã¢â‚¬Âi
                                    thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â´, cÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³ thÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€ Ã¢â‚¬â„¢ khÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡c trÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¡ng thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡i rÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã¢â‚¬Âng) --%>
                                <c:choose>
                                    <c:when test="${not empty rb.thumbnailFirst}">
                                        <img src="${rb.thumbnailFirst}"
                                             alt="${rb.title}"
                                             class="w-full h-full object-cover hover:scale-105 transition-transform duration-300">
                                    </c:when>
                                    <c:otherwise>
                                        <div
                                            class="w-full h-full flex items-center justify-center">
                                            <i data-lucide="book-open"
                                               class="w-12 h-12 text-gray-300"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <c:if test="${rb.featured}">
                                <span
<<<<<<< Updated upstream
                                    class="absolute top-2.5 right-2.5 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full">🔥
=======
                                    class="absolute top-2.5 left-2.5 z-10 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full">ÃƒÆ’Ã‚Â°Ãƒâ€¦Ã‚Â¸ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒâ€šÃ‚Â¥
>>>>>>> Stashed changes
                                    Hot</span>
                                </c:if>
                                <jsp:include page="/views/layout/common/wishlist-heart.jsp">
                                    <jsp:param name="wishBookId" value="${rb.bookID}" />
                                </jsp:include>
                        </div>
                        <div class="p-3 flex flex-col flex-1 gap-1.5">
                            <a href="${pageContext.request.contextPath}/products?id=${rb.bookID}"
                               class="text-[13px] font-bold text-[#222222] line-clamp-2 hover:text-primary transition-colors min-h-[36px]">
                                ${rb.title}
                            </a>
                            <c:if test="${not empty rb.authors}">
                                <p class="text-[12px] text-gray-400 line-clamp-1">
                                    <c:forEach var="a" items="${rb.authors}" varStatus="s">
                                        ${a}<c:if test="${!s.last}">, </c:if>
                                    </c:forEach>
                                </p>
                            </c:if>
                            <div class="flex items-center gap-1 text-[12px] text-[#FDD835]">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= rb.avgRating}">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦</c:when>
                                        <c:otherwise><span class="text-gray-300">ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span
                                    class="text-gray-400 text-[11px]">(${rb.reviewCount})</span>
                            </div>
                            <p class="text-primary text-[17px] font-bold">
                                <fmt:formatNumber value="${rb.price}" type="number"
                                                  groupingUsed="true" /> VND
                            </p>
                            <a href="${pageContext.request.contextPath}/products?id=${rb.bookID}"
                               class="mt-auto w-full bg-primary text-white rounded-lg py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors">
                                <i data-lucide="eye" class="w-4 h-4"></i> QUICK VIEW
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </c:if>
</main>

<!-- Modal giÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Âºi hÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¡n stock -->
<div id="stock-limit-modal"
     class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[9999]">
    <div class="bg-white w-[420px] rounded-xl p-6 relative">
        <button type="button" onclick="document.getElementById('stock-limit-modal').classList.add('hidden');
                document.getElementById('stock-limit-modal').classList.remove('flex');"
                class="absolute top-3 right-4 text-2xl hover:text-gray-500">&times;</button>
        <h3 class="text-lg font-bold text-[#D32F2F] mb-3 flex items-center gap-2"> 
            <i data-lucide="triangle-alert" class="w-5 h-5"></i>  Stock Limit</h3>
        <p id="stock-limit-msg" class="text-gray-700 mb-5"></p>
        <div class="flex justify-end gap-3">
            <a href="${pageContext.request.contextPath}/cart"
               class="hs-primary-button px-4 py-2 hover:opacity-90 text-sm font-semibold">
                View Cart
            </a>
            <button type="button"
                    onclick="document.getElementById('stock-limit-modal').classList.add('hidden');document.getElementById('stock-limit-modal').classList.remove('flex');"
                    class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100 text-sm">
                Close
            </button>
        </div>
    </div>
</div>

<script>

    function switchTab(panelId, btn) {
        document.querySelectorAll('.tab-panel').forEach(function (p) {
            p.classList.remove('active');
        });
        document.querySelectorAll('.tab-btn').forEach(function (b) {
            b.classList.remove('active');
        });
        document.getElementById(panelId).classList.add('active');
        btn.classList.add('active');
    }


    (function () {
        var input = document.getElementById('form-qty');
        if (!input)
            return;

        var max = ${ book.stockQuantity > 0 ? book.stockQuantity : 1
    };
        var minus = document.getElementById('qty-minus');
        var plus = document.getElementById('qty-plus');

        function clamp(v) {
            if (isNaN(v) || v < 1)
                v = 1;
            if (v > max)
                v = max;
            return v;
        }

        function render() {
            var v = clamp(parseInt(input.value, 10));
            input.value = v;
            minus.disabled = (v <= 1);
            plus.disabled = (v >= max);
            minus.classList.toggle('opacity-40', v <= 1);
            plus.classList.toggle('opacity-40', v >= max);
        }

        minus.addEventListener('click', function () {
            input.value = clamp(parseInt(input.value, 10) - 1);
            render();
        });
        plus.addEventListener('click', function () {
            input.value = clamp(parseInt(input.value, 10) + 1);
            render();
        });

        input.addEventListener('input', render);
        input.addEventListener('change', render);

        render();
    })();


    window.switchImg = function (btn, src) {
        var main = document.getElementById('mainImage');
        if (main && src)
            main.src = src;
        document.querySelectorAll('.prod-thumb-active, .prod-thumb-idle').forEach(function (el) {
            el.classList.remove('prod-thumb-active');
            el.classList.add('prod-thumb-idle');
        });
        if (btn) {
            btn.classList.remove('prod-thumb-idle');
            btn.classList.add('prod-thumb-active');
        }
    };

    // Add to Cart 
    const btnAdd = document.getElementById('btn-add-to-cart');
    if (btnAdd) {
        btnAdd.addEventListener('click', function () {
            const bookID = document.querySelector('#add-to-cart-form input[name="bookID"]').value;
            const quantity = document.getElementById('form-qty').value;

            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=add&bookID=' + bookID + '&quantity=' + quantity
            })
                    .then(function (res) {
                        return res.json();
                    })
                    .then(function (data) {
                        if (data.ok) {
                            location.reload();
                        } else if (data.overStock) {
                            document.getElementById('stock-limit-msg').textContent =
                                    'You already have ' + data.currentQty + ' copies in your cart. You can order at most ' + data.stock + ' copies.';
                            const modal = document.getElementById('stock-limit-modal');
                            if (modal) {
                                modal.classList.remove('hidden');
                                modal.classList.add('flex');
                            }
                        } else {
                            showToast(data.message || 'Could not add the item to your cart!', true);
                        }
                    })
                    .catch(function () {
                        showToast('Connection error. Please try again!', true);
                    });
        });
    }


    var slider = document.getElementById('relatedSlider');
    var prev = document.getElementById('sliderPrev');
    var next = document.getElementById('sliderNext');
    if (slider && prev && next) {
        var scrollAmt = 280;
        prev.addEventListener('click', function () {
            slider.scrollBy({left: -scrollAmt, behavior: 'smooth'});
        });
        next.addEventListener('click', function () {
            slider.scrollBy({left: scrollAmt, behavior: 'smooth'});
        });
    }


    var stars = document.querySelectorAll('.star');
    var ratingInput = document.getElementById('ratingValue');
    var ratingText = document.getElementById('ratingText');
    var currentRating = 5;

    function updateStars(rating) {
        stars.forEach(function (star) {
            if (star.dataset.value <= rating) {
                star.textContent = 'ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦';
                star.classList.add('text-yellow-400');
            } else {
                star.textContent = 'ÃƒÆ’Ã‚Â¢Ãƒâ€¹Ã…â€œÃƒÂ¢Ã¢â€šÂ¬Ã‚Â ';
                star.classList.remove('text-yellow-400');
            }
        });
    }
    updateStars(currentRating);

    stars.forEach(function (star) {
        star.addEventListener('mouseover', function () {
            updateStars(star.dataset.value);
        });
        star.addEventListener('click', function () {
            currentRating = star.dataset.value;
            ratingInput.value = currentRating;
            ratingText.textContent = currentRating;
            updateStars(currentRating);
        });
    });
    var ratingStars = document.getElementById('ratingStars');
    if (ratingStars) {
        ratingStars.addEventListener('mouseleave', function () {
            updateStars(currentRating);
        });
    }


    var reviewModal = document.getElementById('reviewModal');
    var openReviewBtn = document.getElementById('openReviewModal');
    var closeReviewBtn = document.getElementById('closeReviewModal');
    var formActionInput = document.getElementById('formAction');
    var reviewIDInput = document.getElementById('reviewIDInput');
    var reviewModalTitle = document.getElementById('reviewModalTitle');
    var reviewSubmitBtn = document.getElementById('reviewSubmitBtn');
    var commentInput = document.getElementById('commentInput');

    function setRating(value) {
        currentRating = value;
        ratingInput.value = value;
        ratingText.textContent = value;
        updateStars(value);
    }

    function openModalForCreate() {
        formActionInput.value = 'add';
        reviewIDInput.value = '';
        commentInput.value = '';
        reviewModalTitle.textContent = 'Write a Review';
        reviewSubmitBtn.textContent = 'Submit Review';
        setRating(5);
        reviewModal.classList.remove('hidden');
        reviewModal.classList.add('flex');
    }

    function openModalForEdit(btn) {
        formActionInput.value = 'edit';
        reviewIDInput.value = btn.dataset.reviewId;
        commentInput.value = btn.dataset.comment;
        reviewModalTitle.textContent = 'Edit Review';
        reviewSubmitBtn.textContent = 'Save Changes';
        setRating(parseInt(btn.dataset.rating, 10) || 5);
        reviewModal.classList.remove('hidden');
        reviewModal.classList.add('flex');
    }

    if (reviewModal && openReviewBtn) {
        openReviewBtn.addEventListener('click', function () {
            var canReview = this.dataset.canReview === 'true';
            if (!canReview) {
                showToast('You must purchase and receive the book before reviewing it.', true);
                return;
            }
            openModalForCreate();
        });
        var canReview = openReviewBtn.dataset.canReview === 'true';
        if (!canReview) {
            openReviewBtn.classList.add('btn-disabled', 'opacity-50', 'cursor-not-allowed');
            openReviewBtn.disabled = true;
        }
    }

    if (closeReviewBtn && reviewModal) {
        closeReviewBtn.addEventListener('click', function () {
            reviewModal.classList.add('hidden');
            reviewModal.classList.remove('flex');
        });
    }

    document.querySelectorAll('.edit-review-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            openModalForEdit(btn);
        });
    });

    // ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ Review form AJAX submit ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬
    var reviewForm = document.getElementById('reviewForm');
    if (reviewForm) {
        reviewForm.addEventListener('submit', function (e) {
            e.preventDefault();
            var formData = new URLSearchParams(new FormData(reviewForm));
            fetch('${pageContext.request.contextPath}/review', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: formData.toString()
            })
                    .then(function (res) {
                        if (!res.ok)
                            throw new Error();
                        return res.json();
                    })
                    .then(function (data) {
                        if (data.success) {
                            showToast(data.message);
                            reviewModal.classList.add('hidden');
                            reviewModal.classList.remove('flex');
                            setTimeout(function () {
                                location.reload();
                            }, 1000);
                        } else {
                            showToast(data.message, true);
                        }
                    })
                    .catch(function () {
                        showToast('An error occurred', true);
                    });
        });
    }

</script>

<%@ include file="/views/layout/homepage/footer.jsp" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<c:if test="${param.removed == '1'}">
    <script>window.addEventListener('load', () => showToast('Removed from your wishlist!'));</script>
</c:if>
<c:if test="${param.movedToCart == '1'}">
    <script>window.addEventListener('load', () => showToast('Moved to your cart!'));</script>
</c:if>
<c:if test="${not empty param.wishError}">
    <script>window.addEventListener('load', () => showToast('<c:out value="${param.wishError}"/>', true));</script>
</c:if>

<style>
    .wishlist-page {
        background: #f3f4f6;
        padding-bottom: 36px;
    }
    .wishlist-shell {
        width: min(1180px, calc(100% - 40px));
        margin: 0 auto;
    }
    .wishlist-hero {
        padding: 28px 0;
        background: linear-gradient(135deg, #c92127 0%, #a7191e 100%);
    }
    .wishlist-eyebrow {
        display: inline-flex;
        align-items: center;
        padding: 5px 12px;
        margin-bottom: 9px;
        border-radius: 999px;
        background: #fff;
        color: #c92127;
        font-size: 11px;
        font-weight: 800;
        letter-spacing: .08em;
        text-transform: uppercase;
    }
    .wishlist-title {
        margin: 0;
        color: #fff;
        font-size: 28px;
        line-height: 1.25;
        font-weight: 900;
    }
    .wishlist-count {
        margin-top: 5px;
        color: rgba(255, 255, 255, .82);
        font-size: 14px;
    }
    .wishlist-main {
        padding-top: 24px;
    }
    .wishlist-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 18px;
    }
    .wish-card {
        background:#fff;
        border:1px solid #e1e3e6;
        border-radius:14px;
        overflow:hidden;
        display:flex;
        align-items:stretch;
        min-width: 0;
        min-height: 210px;
        transition:box-shadow .2s, border-color .2s;
    }
    .wish-card:hover {
        border-color: #efb1b5;
        box-shadow:0 8px 24px rgba(77, 17, 20, .10);
    }
    .wish-thumb {
        width:145px;
        min-height:210px;
        flex-shrink:0;
        padding: 12px;
        background:#f7f7f8;
        display:flex;
        align-items:center;
        justify-content:center;
        overflow:hidden;
    }
    .wish-thumb img {
        width:100%;
        height:100%;
        object-fit:contain;
    }
    .wish-card-body {
        min-width: 0;
        padding: 17px 18px;
        display: flex;
        flex: 1;
        flex-direction: column;
        justify-content: space-between;
    }
    .badge-stock-ok  {
        background:#edf8f1;
        border: 1px solid #bfe7cb;
        color:#17643a;
        font-size:11px;
        font-weight:700;
        padding:3px 8px;
        border-radius:999px;
    }
    .badge-stock-out {
        background:#fff1f2;
        border: 1px solid #f2c1c4;
        color:#a7191e;
        font-size:11px;
        font-weight:700;
        padding:3px 8px;
        border-radius:999px;
    }
    .wish-card-actions {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 8px;
        margin-top: 16px;
    }
    .wish-card-actions form {
        min-width: 0;
    }
    .wish-action {
        width: 100%;
        min-height: 40px;
        padding: 8px 10px;
        border: 1px solid transparent;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        font-size: 12px;
        line-height: 1.2;
        font-weight: 700;
        text-align: center;
        transition: background-color .2s, border-color .2s, color .2s;
    }
    .wish-action-primary {
        background: #c92127;
        color: #fff;
    }
    .wish-action-primary:hover {
        background: #a7191e;
    }
    .wish-action-secondary {
        border-color: #c92127;
        background: #fff;
        color: #c92127;
    }
    .wish-action-secondary:hover {
        background: #fff0f1;
    }
    .wish-action-delete {
        border-color: #efb1b5;
        background: #fff;
        color: #a7191e;
    }
    .wish-action-delete:hover {
        border-color: #c92127;
        background: #fff0f1;
    }
    .wish-action-disabled {
        border-color: #d5d7da;
        background: #eceeef;
        color: #71757a;
        cursor: not-allowed;
    }
    .wishlist-footer-actions {
        margin-top: 20px;
        padding-top: 18px;
        border-top: 1px solid #dedfe2;
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 12px;
    }
    .wishlist-bottom-action {
        min-height: 42px;
        padding: 10px 18px;
        border-radius: 8px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        font-size: 13px;
        font-weight: 700;
    }
    .wishlist-continue {
        border: 1px solid #c92127;
        background: #fff;
        color: #c92127;
    }
    .wishlist-continue:hover {
        background: #fff0f1;
    }
    .wishlist-view-cart {
        border: 1px solid #c92127;
        background: #c92127;
        color: #fff;
    }
    .wishlist-view-cart:hover {
        background: #a7191e;
        border-color: #a7191e;
    }
    @media (max-width: 900px) {
        .wishlist-grid {
            grid-template-columns: 1fr;
        }
    }
    @media (max-width: 560px) {
        .wishlist-shell {
            width: min(1180px, calc(100% - 24px));
        }
        .wishlist-hero {
            padding: 22px 0;
        }
        .wishlist-title {
            font-size: 24px;
        }
        .wish-thumb {
            width: 112px;
            padding: 9px;
        }
        .wish-card-body {
            padding: 14px 12px;
        }
        .wish-card-actions {
            grid-template-columns: 1fr;
        }
        .wishlist-footer-actions {
            align-items: stretch;
            flex-direction: column;
        }
    }
</style>

<div class="wishlist-page">
    <section class="wishlist-hero">
        <div class="wishlist-shell">
            <h1 class="wishlist-title">My Wishlist</h1>
            <p class="wishlist-count">${wishlistCount} books in this list</p>
        </div>
    </section>

<main class="wishlist-shell wishlist-main">

    <c:choose>
        <c:when test="${not empty wishlistItems}">
            <div class="wishlist-grid">
                <c:forEach var="item" items="${wishlistItems}">
                    <div class="wish-card">
                        <div class="wish-thumb">
                            <c:choose>
                                <c:when test="${not empty item.thumbnailFirst}">
                                    <img src="${item.thumbnailFirst}" alt="${item.title}">
                                </c:when>
                                <c:otherwise>
                                    <i data-lucide="book-open" class="w-10 h-10 text-gray-200"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="wish-card-body">
                            <div>
                                <a href="${pageContext.request.contextPath}/products?id=${item.bookID}"
                                   class="text-[15px] font-bold text-gray-800 hover:text-primary transition-colors line-clamp-2">${item.title}</a>
                                <c:if test="${not empty item.authorsDisplay}">
                                    <p class="text-[13px] text-gray-400 mt-0.5">${item.authorsDisplay}</p>
                                </c:if>

                                <div class="flex items-center gap-3 mt-2 flex-wrap">
                                    <span class="text-primary text-[17px] font-bold">
                                        <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> VND
                                    </span>
                                    <c:choose>
                                        <c:when test="${item.stockQuantity > 0 and item.status == 'available'}">
                                            <span class="badge-stock-ok">✓ In Stock (${item.stockQuantity})</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-stock-out">✕ Out of Stock</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="text-[#FDD835] text-[11px] mt-1 flex items-center gap-0.5">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= item.avgRating}">★</c:when>
                                            <c:otherwise><span class="text-gray-200">★</span></c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <span class="text-gray-400 text-[10px] ml-0.5">(${item.reviewCount})</span>
                                </div>
                            </div>

                            <div class="wish-card-actions">
                     
                                <c:choose>
                                    <c:when test="${item.stockQuantity > 0 and item.status == 'available'}">
                                        <form method="post" action="${pageContext.request.contextPath}/wishlist">
                                            <input type="hidden" name="action"  value="moveToCart">
                                            <input type="hidden" name="bookID"  value="${item.bookID}">
                                            <button type="submit" class="wish-action wish-action-primary">
                                                <i data-lucide="shopping-cart" class="w-3.5 h-3.5"></i>
                                                Move to Cart
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="wish-action wish-action-disabled" disabled>
                                            <i data-lucide="shopping-cart" class="w-3.5 h-3.5"></i>
                                            Move to Cart
                                        </button>
                                    </c:otherwise>
                                </c:choose>

                                <a href="${pageContext.request.contextPath}/products?id=${item.bookID}"
                                   class="wish-action wish-action-secondary">
                                    <i data-lucide="eye" class="w-3.5 h-3.5"></i>
                                    View Details
                                </a>

                              
                                <form method="post" action="${pageContext.request.contextPath}/wishlist">
                                    <input type="hidden" name="action"  value="remove">
                                    <input type="hidden" name="bookID"  value="${item.bookID}">
                                    <button type="submit"
                                            class="wish-action wish-action-delete"
                                            title="Remove from Wishlist">
                                        <i data-lucide="trash-2" class="w-3.5 h-3.5"></i>
                                        Delete
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="wishlist-footer-actions">
                <a href="${pageContext.request.contextPath}/products"
                   class="wishlist-bottom-action wishlist-continue">
                    <i data-lucide="arrow-left" class="w-4 h-4"></i> Continue Shopping
                </a>
                <a href="${pageContext.request.contextPath}/cart"
                   class="wishlist-bottom-action wishlist-view-cart">
                    View Cart
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="text-center py-24">
                <div class="w-24 h-24 mx-auto mb-6 rounded-full bg-red-50 flex items-center justify-center">
                    <i data-lucide="heart" class="w-10 h-10 text-red-300"></i>
                </div>
                <h2 class="text-xl font-bold text-gray-700 mb-2">No Favorite Books Yet</h2>
                <p class="text-gray-400 text-sm mb-6">Explore our collection and add the books you love here!</p>
                <a href="${pageContext.request.contextPath}/products"
                   class="inline-flex items-center gap-2 bg-primary text-white font-bold px-8 py-3 rounded-full hover:bg-primary-dark transition-colors">
                    <i data-lucide="search" class="w-4 h-4"></i> Explore Books Now
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</main>
</div>

<%@ include file="/views/layout/homepage/footer.jsp" %>

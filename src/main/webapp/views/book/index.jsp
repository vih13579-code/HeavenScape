<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<main class="fhs-home">
    <div class="fhs-home-layout">
        <!-- Hero is now a marketplace banner composition instead of the original editorial 50/50 block. -->
        <section class="fhs-hero-grid" aria-label="HeavenScape highlights">
            <div class="fhs-hero-main">
                <div class="fhs-hero-copy">
                    <span class="fhs-kicker">HeavenScape Picks</span>
                    <h1 class="fhs-hero-title">A better shelf for your next great read.</h1>
                    <p class="fhs-hero-desc">Browse popular titles, new releases and reader favorites in one bookstore-style marketplace.</p>
                    <a href="${pageContext.request.contextPath}/products" class="fhs-hero-cta">
                        Shop Books <i data-lucide="arrow-right" class="icon-md"></i>
                    </a>
                </div>
                <c:choose>
                    <c:when test="${not empty featuredBooks and not empty featuredBooks[0].thumbnailFirst}">
                        <img class="fhs-hero-book" src="${featuredBooks[0].thumbnailFirst}" alt="${featuredBooks[0].title}">
                    </c:when>
                    <c:otherwise>
                        <div class="fhs-hero-book-placeholder"><i data-lucide="book-open" class="w-16 h-16"></i></div>
                    </c:otherwise>
                </c:choose>
            </div>

        </section>

        <section class="fhs-shortcuts" aria-label="Quick access">
            <a class="fhs-shortcut" href="${pageContext.request.contextPath}/products?sort=newest">
                <span class="fhs-shortcut-icon"><i data-lucide="badge-plus"></i></span>
                <span>New Books</span>
            </a>
            <a class="fhs-shortcut" href="${pageContext.request.contextPath}/products?sort=popular">
                <span class="fhs-shortcut-icon"><i data-lucide="trending-up"></i></span>
                <span>Best Sellers</span>
            </a>
            <a class="fhs-shortcut" href="${pageContext.request.contextPath}/products?sort=price_asc">
                <span class="fhs-shortcut-icon"><i data-lucide="tags"></i></span>
                <span>Offers</span>
            </a>
        </section>

        <section class="fhs-product-section">
            <div class="fhs-product-section-head trend">
                <h2 class="fhs-section-title"><span class="marker"></span>Shopping Trends</h2>
                <a class="fhs-view-all" href="${pageContext.request.contextPath}/products?sort=popular">View all →</a>
            </div>
            <div class="fhs-product-grid">
                <c:forEach var="book" items="${featuredBooks}">
                    <article class="fhs-product-card">
                        <div class="fhs-product-cover">
                            <c:choose>
                                <c:when test="${not empty book.thumbnailFirst}">
                                    <img src="${book.thumbnailFirst}" alt="${book.title}">
                                </c:when>
                                <c:otherwise>
                                    <div class="fhs-product-cover-placeholder"><i data-lucide="book-open" class="w-12 h-12"></i></div>
                                </c:otherwise>
                            </c:choose>
                            <span class="fhs-chip hot">Hot</span>
                            <c:if test="${book.status == 'out_of_stock' or book.stockQuantity == 0}">
                                <div class="hs-stock-overlay">
                                    <span class="hs-stock-badge">Out of Stock</span>
                                </div>
                            </c:if>
                            <jsp:include page="/views/layout/common/wishlist-heart.jsp">
                                <jsp:param name="wishBookId" value="${book.bookID}" />
                            </jsp:include>
                        </div>
                        <div class="fhs-product-meta">
                            <a class="fhs-product-name" href="${pageContext.request.contextPath}/products?id=${book.bookID}">${book.title}</a>
                            <div class="fhs-product-author">
                                <c:if test="${not empty book.authors}"><c:forEach var="a" items="${book.authors}" varStatus="s">${a}<c:if test="${!s.last}">, </c:if></c:forEach></c:if>
                            </div>
                            <div class="fhs-price"><fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" /> VND</div>
                            <div class="fhs-rating">
                                <c:forEach begin="1" end="5" var="i"><c:choose><c:when test="${i <= book.avgRating}">★</c:when><c:otherwise><span class="text-gray-300">★</span></c:otherwise></c:choose></c:forEach>
                                <span class="fhs-rating-count">(${book.reviewCount})</span>
                            </div>
                        </div>
                    </article>
                </c:forEach>
                <c:if test="${empty featuredBooks}">
                    <div class="col-span-full py-12 text-center text-gray-400">No books are available yet.</div>
                </c:if>
            </div>
            <div class="fhs-section-foot"><a class="fhs-outline-btn" href="${pageContext.request.contextPath}/products?sort=popular">See more best sellers</a></div>
        </section>

        <section class="fhs-product-section">
            <div class="fhs-product-section-head">
                <h2 class="fhs-section-title"><span class="marker"></span>New Arrivals</h2>
                <a class="fhs-view-all" href="${pageContext.request.contextPath}/products?sort=newest">View all →</a>
            </div>
            <div class="fhs-product-grid">
                <c:forEach var="book" items="${newBooks}">
                    <article class="fhs-product-card">
                        <div class="fhs-product-cover">
                            <c:choose>
                                <c:when test="${not empty book.thumbnailFirst}">
                                    <img src="${book.thumbnailFirst}" alt="${book.title}">
                                </c:when>
                                <c:otherwise>
                                    <div class="fhs-product-cover-placeholder"><i data-lucide="book-open" class="w-12 h-12"></i></div>
                                </c:otherwise>
                            </c:choose>
                            <span class="fhs-chip">New</span>
                            <c:if test="${book.status == 'out_of_stock' or book.stockQuantity == 0}">
                                <div class="hs-stock-overlay">
                                    <span class="hs-stock-badge">Out of Stock</span>
                                </div>
                            </c:if>
                            <jsp:include page="/views/layout/common/wishlist-heart.jsp">
                                <jsp:param name="wishBookId" value="${book.bookID}" />
                            </jsp:include>
                        </div>
                        <div class="fhs-product-meta">
                            <a class="fhs-product-name" href="${pageContext.request.contextPath}/products?id=${book.bookID}">${book.title}</a>
                            <div class="fhs-product-author">
                                <c:if test="${not empty book.authors}"><c:forEach var="a" items="${book.authors}" varStatus="s">${a}<c:if test="${!s.last}">, </c:if></c:forEach></c:if>
                            </div>
                            <div class="fhs-price"><fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" /> VND</div>
                            <div class="fhs-rating">
                                <c:forEach begin="1" end="5" var="i"><c:choose><c:when test="${i <= book.avgRating}">★</c:when><c:otherwise><span class="text-gray-300">★</span></c:otherwise></c:choose></c:forEach>
                                <span class="fhs-rating-count">(${book.reviewCount})</span>
                            </div>
                        </div>
                    </article>
                </c:forEach>
                <c:if test="${empty newBooks}">
                    <div class="col-span-full py-12 text-center text-gray-400">No new books are available yet.</div>
                </c:if>
            </div>
            <div class="fhs-section-foot"><a class="fhs-outline-btn" href="${pageContext.request.contextPath}/products?sort=newest">See all new arrivals</a></div>
        </section>
    </div>
</main>

<%@ include file="/views/layout/common/wishlist-heart.js.jsp" %>
<%@ include file="/views/layout/homepage/footer.jsp" %>

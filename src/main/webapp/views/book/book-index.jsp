<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<c:url var="clearFilterUrl" value="/products">
    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
    <c:if test="${not empty sort}"><c:param name="sort" value="${sort}" /></c:if>
</c:url>

<section class="hs-catalog-hero">
    <div class="relative z-10 hs-catalog-heading">
        <nav class="hs-catalog-breadcrumb" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <span aria-hidden="true">/</span>
            <span aria-current="page">
                <c:choose>
                    <c:when test="${not empty keyword}">Search results</c:when>
                    <c:when test="${not empty categoryID}"><c:out value="${categoryMap[categoryID]}" /></c:when>
                    <c:when test="${not empty selectedCategoryIDs}">Selected categories</c:when>
                    <c:otherwise>All Books</c:otherwise>
                </c:choose>
            </span>
        </nav>
        <h1 class="hs-catalog-title">
            <c:choose>
                <c:when test="${not empty keyword}">Results for “<em><c:out value="${keyword}" /></em>”</c:when>
                <c:when test="${not empty categoryID}"><c:out value="${categoryMap[categoryID]}" /></c:when>
                <c:when test="${not empty selectedCategoryIDs}">Selected Categories</c:when>
                <c:otherwise>All Books</c:otherwise>
            </c:choose>
            <span class="hs-catalog-count">(${totalBooks} books)</span>
        </h1>
    </div>
</section>

<main class="fhs-page-inner hs-catalog-layout flex flex-col lg:flex-row gap-4">


    <aside class="w-full lg:w-[240px] flex-shrink-0">
        <form method="get" action="${pageContext.request.contextPath}/products"
              id="catalogFilterForm" class="catalog-filter-form"
              onsubmit="return validateCatalogPriceRange(this)">
            <c:if test="${not empty keyword}">
                <input type="hidden" name="keyword" value="<c:out value='${keyword}' />">
            </c:if>
            <c:if test="${not empty sort}">
                <input type="hidden" name="sort" value="<c:out value='${sort}' />">
            </c:if>

            <div class="filter-card">
                <h3 class="catalog-filter-title">Price Range (VND)</h3>
                <div class="price-input-row">
                    <input type="number" name="minPrice" value="${minPrice}" placeholder="Min"
                           class="price-filter-input border border-gray-200 rounded-lg px-3 py-2 text-sm focus:border-primary outline-none"
                           min="0" step="1000" aria-describedby="priceRangeError">
                    <span class="price-input-divider" aria-hidden="true">—</span>
                    <input type="number" name="maxPrice" value="${maxPrice}" placeholder="Max"
                           class="price-filter-input border border-gray-200 rounded-lg px-3 py-2 text-sm focus:border-primary outline-none"
                           min="0" step="1000" aria-describedby="priceRangeError">
                </div>
                <p id="priceRangeError"
                   class="price-range-error<c:if test='${not empty priceRangeError}'> is-visible</c:if>"
                   role="alert" aria-live="polite"><c:out value="${priceRangeError}" /></p>
                <div class="price-filter-actions">
                    <button type="submit" class="price-filter-submit bg-primary text-white text-sm font-bold py-2 rounded-lg hover:bg-primary-dark transition-colors">
                        Apply Price Filter
                    </button>
                </div>
                <c:if test="${hasActiveFilters}">
                    <a href="${clearFilterUrl}"
                       class="price-filter-clear text-xs text-gray-400 hover:text-red-500">✕ Clear filter</a>
                </c:if>
            </div>

            <div class="filter-card">
                <h3 class="catalog-filter-title">Category</h3>
                <div class="catalog-filter-options">
                    <c:forEach var="entry" items="${categoryMap}">
                        <c:set var="categoryChecked" value="false" />
                        <c:forEach var="selectedCategory" items="${selectedCategoryIDs}">
                            <c:if test="${selectedCategory == entry.key}"><c:set var="categoryChecked" value="true" /></c:if>
                        </c:forEach>
                        <label class="catalog-filter-option">
                            <input type="checkbox" name="category" value="${entry.key}"
                                   <c:if test="${categoryChecked}">checked</c:if>
                                   onchange="this.form.requestSubmit()">
                            <span><c:out value="${entry.value}" /></span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <div class="filter-card">
                <h3 class="catalog-filter-title">Author</h3>
                <div class="catalog-filter-options catalog-filter-options-scroll">
                    <c:forEach var="entry" items="${authorMap}">
                        <c:set var="authorChecked" value="false" />
                        <c:forEach var="selectedAuthor" items="${selectedAuthorIDs}">
                            <c:if test="${selectedAuthor == entry.key}"><c:set var="authorChecked" value="true" /></c:if>
                        </c:forEach>
                        <label class="catalog-filter-option">
                            <input type="checkbox" name="author" value="${entry.key}"
                                   <c:if test="${authorChecked}">checked</c:if>
                                   onchange="this.form.requestSubmit()">
                            <span><c:out value="${entry.value}" /></span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <div class="filter-card">
                <h3 class="catalog-filter-title">Availability</h3>
                <div class="catalog-filter-options">
                    <label class="catalog-filter-option">
                        <input type="checkbox" name="availability" value="available"
                               <c:if test="${availabilityAvailable}">checked</c:if>
                               onchange="this.form.requestSubmit()">
                        <span>In stock</span>
                    </label>
                    <label class="catalog-filter-option">
                        <input type="checkbox" name="availability" value="out_of_stock"
                               <c:if test="${availabilityOutOfStock}">checked</c:if>
                               onchange="this.form.requestSubmit()">
                        <span>Out of stock</span>
                    </label>
                </div>
            </div>
        </form>
    </aside>

  
    <section class="flex-1 min-w-0 fhs-block p-4">
        
        <div class="catalog-sortbar mb-5 bg-[#fafafa] border border-outline-variant rounded-lg px-4 py-3">
            <form method="get" action="${pageContext.request.contextPath}/products" class="catalog-sort-group">
                <c:if test="${not empty keyword}"><input type="hidden" name="keyword" value="<c:out value='${keyword}' />"></c:if>
                <c:if test="${not empty minPrice}"><input type="hidden" name="minPrice" value="${minPrice}"></c:if>
                <c:if test="${not empty maxPrice}"><input type="hidden" name="maxPrice" value="${maxPrice}"></c:if>
                <c:forEach var="selectedCategory" items="${selectedCategoryIDs}">
                    <input type="hidden" name="category" value="${selectedCategory}">
                </c:forEach>
                <c:forEach var="selectedAuthor" items="${selectedAuthorIDs}">
                    <input type="hidden" name="author" value="${selectedAuthor}">
                </c:forEach>
                <c:forEach var="availabilityValue" items="${availability}">
                    <input type="hidden" name="availability" value="${availabilityValue}">
                </c:forEach>
                <span class="catalog-sort-label text-sm font-semibold text-gray-500">Sort by:</span>
                <button type="submit" name="sort" value="newest"
                        class="sort-btn <c:if test="${sort == 'newest' or empty sort}">active</c:if>">Newest</button>
                <button type="submit" name="sort" value="popular"
                        class="sort-btn <c:if test="${sort == 'popular'}">active</c:if>">Popular</button>
                <button type="submit" name="sort" value="price_asc"
                        class="sort-btn <c:if test="${sort == 'price_asc'}">active</c:if>">Lowest Price</button>
                <button type="submit" name="sort" value="price_desc"
                        class="sort-btn <c:if test="${sort == 'price_desc'}">active</c:if>">Highest Price</button>
                <button type="submit" name="sort" value="name"
                        class="sort-btn <c:if test="${sort == 'name'}">active</c:if>">A→Z</button>
            </form>
            <span class="catalog-result-count text-sm text-gray-400">${totalBooks} books</span>
        </div>

      
        <c:choose>
            <c:when test="${not empty books}">
                <div class="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-3 mb-8" id="book-grid">
                    <c:forEach var="book" items="${books}">
                    <div class="prod-card">
                        <div class="relative aspect-[2/3] bg-surface-container-low flex items-center justify-center overflow-hidden">
                            <c:choose>
                                <c:when test="${not empty book.thumbnailFirst}">
                                    <img alt="${book.title}" class="w-full h-full object-cover hover:scale-105 transition-transform duration-300" src="${book.thumbnailFirst}">
                                </c:when>
                                <c:otherwise>
                                    <i data-lucide="book-open" class="w-14 h-14 text-gray-200"></i>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${book.featured}">
                                <div class="absolute top-2.5 left-2.5 z-10 bg-[#8E24AA] text-white text-[10px] font-bold px-2 py-0.5 rounded-full">Hot</div>
                            </c:if>
                  
                            <c:if test="${book.status == 'out_of_stock' or book.stockQuantity == 0}">
                                <div class="hs-stock-overlay">
                                    <span class="hs-stock-badge">Out of Stock</span>
                                </div>
                            </c:if>
                            <jsp:include page="/views/layout/common/wishlist-heart.jsp">
                                <jsp:param name="wishBookId" value="${book.bookID}" />
                            </jsp:include>
                        </div>
                        <div class="p-3 flex flex-col flex-1">
                            <div class="text-[12px] text-gray-400 mb-1 truncate">
                                <c:if test="${not empty book.categoryName}"><span class="text-primary font-medium">${book.categoryName}</span></c:if>
                            </div>
                            <div class="text-[13px] font-semibold text-gray-800 mb-1 line-clamp-2 min-h-[36px]">
                                <a href="${pageContext.request.contextPath}/products?id=${book.bookID}" class="hover:text-primary transition-colors">${book.title}</a>
                            </div>
                            <div class="text-[12px] text-gray-400 mb-1 line-clamp-1">
                                <c:if test="${not empty book.authors}">
                                    <c:forEach var="a" items="${book.authors}" varStatus="s">${a}<c:if test="${!s.last}">, </c:if></c:forEach>
                                </c:if>
                            </div>
                            <div class="text-[#FDD835] text-[11px] mb-1.5 flex items-center gap-0.5">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= book.avgRating}">★</c:when>
                                        <c:otherwise><span class="text-gray-200">★</span></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span class="text-gray-400 text-[10px] ml-0.5">(${book.reviewCount})</span>
                            </div>
                            <div class="text-primary text-[16px] font-bold mb-2.5">
                                <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true"/> VND
                            </div>
                        </div>
                    </div>
                    </c:forEach>
                </div>

             
                <c:if test="${totalPages > 1}">
                <nav class="flex justify-center items-center gap-1.5 flex-wrap">
                    <c:if test="${page > 1}">
                        <c:url var="previousPageUrl" value="/products">
                            <c:param name="page" value="${page - 1}" />
                            <c:param name="size" value="${pageSize}" />
                            <c:if test="${not empty sort}"><c:param name="sort" value="${sort}" /></c:if>
                            <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
                            <c:if test="${not empty minPrice}"><c:param name="minPrice" value="${minPrice}" /></c:if>
                            <c:if test="${not empty maxPrice}"><c:param name="maxPrice" value="${maxPrice}" /></c:if>
                            <c:forEach var="selectedCategory" items="${selectedCategoryIDs}"><c:param name="category" value="${selectedCategory}" /></c:forEach>
                            <c:forEach var="selectedAuthor" items="${selectedAuthorIDs}"><c:param name="author" value="${selectedAuthor}" /></c:forEach>
                            <c:forEach var="availabilityValue" items="${availability}"><c:param name="availability" value="${availabilityValue}" /></c:forEach>
                        </c:url>
                        <a href="${previousPageUrl}"
                           class="w-9 h-9 flex items-center justify-center rounded-lg border border-gray-200 text-gray-600 hover:border-primary hover:text-primary transition-colors">
                            <i data-lucide="chevron-left" class="w-4 h-4"></i>
                        </a>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == page}">
                                <span class="w-9 h-9 flex items-center justify-center rounded-lg bg-primary text-white font-bold text-sm">${i}</span>
                            </c:when>
                            <c:when test="${i <= 2 or i >= totalPages-1 or (i >= page-2 and i <= page+2)}">
                                <c:url var="numberedPageUrl" value="/products">
                                    <c:param name="page" value="${i}" />
                                    <c:param name="size" value="${pageSize}" />
                                    <c:if test="${not empty sort}"><c:param name="sort" value="${sort}" /></c:if>
                                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
                                    <c:if test="${not empty minPrice}"><c:param name="minPrice" value="${minPrice}" /></c:if>
                                    <c:if test="${not empty maxPrice}"><c:param name="maxPrice" value="${maxPrice}" /></c:if>
                                    <c:forEach var="selectedCategory" items="${selectedCategoryIDs}"><c:param name="category" value="${selectedCategory}" /></c:forEach>
                                    <c:forEach var="selectedAuthor" items="${selectedAuthorIDs}"><c:param name="author" value="${selectedAuthor}" /></c:forEach>
                                    <c:forEach var="availabilityValue" items="${availability}"><c:param name="availability" value="${availabilityValue}" /></c:forEach>
                                </c:url>
                                <a href="${numberedPageUrl}"
                                    class="w-9 h-9 flex items-center justify-center rounded-lg border border-gray-200 text-gray-600 hover:border-primary hover:text-primary transition-colors text-sm">${i}</a>
                            </c:when>
                            <c:when test="${i == 3 and page > 5}">
                                <span class="w-9 h-9 flex items-center justify-center text-gray-400">…</span>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${page < totalPages}">
                        <c:url var="nextPageUrl" value="/products">
                            <c:param name="page" value="${page + 1}" />
                            <c:param name="size" value="${pageSize}" />
                            <c:if test="${not empty sort}"><c:param name="sort" value="${sort}" /></c:if>
                            <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
                            <c:if test="${not empty minPrice}"><c:param name="minPrice" value="${minPrice}" /></c:if>
                            <c:if test="${not empty maxPrice}"><c:param name="maxPrice" value="${maxPrice}" /></c:if>
                            <c:forEach var="selectedCategory" items="${selectedCategoryIDs}"><c:param name="category" value="${selectedCategory}" /></c:forEach>
                            <c:forEach var="selectedAuthor" items="${selectedAuthorIDs}"><c:param name="author" value="${selectedAuthor}" /></c:forEach>
                            <c:forEach var="availabilityValue" items="${availability}"><c:param name="availability" value="${availabilityValue}" /></c:forEach>
                        </c:url>
                        <a href="${nextPageUrl}"
                           class="w-9 h-9 flex items-center justify-center rounded-lg border border-gray-200 text-gray-600 hover:border-primary hover:text-primary transition-colors">
                            <i data-lucide="chevron-right" class="w-4 h-4"></i>
                        </a>
                    </c:if>
                </nav>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="text-center py-20 text-gray-400">
                    <i data-lucide="search-x" class="w-16 h-16 mx-auto mb-4 opacity-30"></i>
                    <c:choose>
                        <c:when test="${not empty keyword}">
                            <p class="text-lg font-semibold">No results for “<c:out value="${keyword}" />”.</p>
                            <p class="text-sm mt-1">Try a different keyword.</p>
                        </c:when>
                        <c:when test="${hasPriceFilter}">
                            <p class="text-lg font-semibold">No books found in this price range.</p>
                            <p class="text-sm mt-1">Try widening it.</p>
                        </c:when>
                        <c:otherwise>
                            <p class="text-lg font-semibold">No Books Found</p>
                            <p class="text-sm mt-1">Try changing your search term or filters.</p>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/products" class="hs-primary-button mt-4 inline-block px-6 py-2.5 text-sm font-bold">View All Books</a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<script>
    function validateCatalogPriceRange(form) {
        const minInput = form.elements.minPrice;
        const maxInput = form.elements.maxPrice;
        const errorElement = document.getElementById('priceRangeError');

        if (minInput.value !== '' && maxInput.value !== ''
                && Number(minInput.value) > Number(maxInput.value)) {
            minInput.value = '';
            maxInput.value = '';
            errorElement.textContent = 'Minimum price cannot be greater than maximum price.';
            errorElement.classList.add('is-visible');
            minInput.focus();
            return false;
        }

        errorElement.textContent = '';
        errorElement.classList.remove('is-visible');
        return true;
    }

    (function initPriceRangeValidation() {
        const form = document.getElementById('catalogFilterForm');
        const errorElement = document.getElementById('priceRangeError');
        if (!form || !errorElement) return;

        [form.elements.minPrice, form.elements.maxPrice].forEach(function (input) {
            input.addEventListener('input', function () {
                errorElement.textContent = '';
                errorElement.classList.remove('is-visible');
            });
        });
    })();
</script>

<%@ include file="/views/layout/common/wishlist-heart.js.jsp" %>
<%@ include file="/views/layout/homepage/footer.jsp" %>

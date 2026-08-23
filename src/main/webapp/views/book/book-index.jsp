<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<style>
.filter-card { background:transparent; border:1px solid var(--hs-outline-variant); border-radius:4px; padding:20px; }
.sort-btn { border:1px solid var(--hs-outline-variant); border-radius:4px; padding:7px 14px; font-size:13px; font-weight:500; transition:all .18s; cursor:pointer; background:var(--hs-surface); }
.sort-btn.active, .sort-btn:hover { border-color:var(--hs-primary); color:var(--hs-primary); background:var(--hs-surface-low); }
.prod-card { border:1px solid rgba(197,198,206,.65); border-radius:4px; overflow:hidden; background:#fff; display:flex; flex-direction:column; transition:box-shadow .2s, transform .2s; }
.prod-card:hover { box-shadow:0 16px 38px -24px rgba(4,22,46,.5); transform:translateY(-3px); }
.genre-pill { display:inline-block; padding:4px 12px; border-radius:999px; font-size:12px; font-weight:600; cursor:pointer; border:1.5px solid transparent; transition:all .18s; }
.genre-pill.active { background:var(--hs-primary); color:#fff; border-color:var(--hs-primary); }
.genre-pill:not(.active) { background:var(--hs-surface-low); color:var(--hs-on-surface-variant); border-color:var(--hs-outline-variant); }
.genre-pill:not(.active):hover { border-color:var(--hs-primary); color:var(--hs-primary); }
</style>

<section class="hs-catalog-hero">
<<<<<<< Updated upstream
    <div class="relative z-10">
        <div class="hs-eyebrow mb-2">HeavenScape Bookstore</div>
        <h1 class="font-headline-md text-[36px] md:text-[44px] font-semibold text-primary leading-tight">
            <c:choose>
                <c:when test="${not empty keyword}">Search Results: "<em class="text-tertiary-container not-italic">${keyword}</em>"</c:when>
                <c:when test="${not empty genreID}">Category: <em class="text-tertiary-container not-italic">${genreMap[genreID]}</em></c:when>
=======
    <div class="relative z-10 hs-catalog-heading">
        <nav class="hs-catalog-breadcrumb" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <span aria-hidden="true">/</span>
            <span aria-current="page">
                <c:choose>
                    <c:when test="${not empty keyword}">Search results</c:when>
                    <c:when test="${not empty genreID}"><c:out value="${genreMap[genreID]}" /></c:when>
                    <c:when test="${not empty selectedGenreIDs}">Selected genres</c:when>
                    <c:otherwise>All Books</c:otherwise>
                </c:choose>
            </span>
        </nav>
        <h1 class="hs-catalog-title">
            <c:choose>
                <c:when test="${not empty keyword}">Results for &ldquo;<em><c:out value="${keyword}" /></em>&rdquo;</c:when>
                <c:when test="${not empty genreID}"><c:out value="${genreMap[genreID]}" /></c:when>
                <c:when test="${not empty selectedGenreIDs}">Selected Genres</c:when>
>>>>>>> Stashed changes
                <c:otherwise>All Books</c:otherwise>
            </c:choose>
        </h1>
        <p class="text-on-surface-variant text-base mt-2">${totalBooks} titles</p>
    </div>
</section>

<main class="max-w-[1280px] mx-auto px-5 md:px-16 pb-16 flex flex-col lg:flex-row gap-6">


    <aside class="w-full lg:w-[240px] flex-shrink-0 space-y-4">
        <div class="filter-card">
            <h3 class="text-[14px] font-bold text-gray-700 mb-3 uppercase tracking-wide">Genre</h3>
            <div class="flex flex-col gap-1.5">
                <a href="${pageContext.request.contextPath}/products<c:if test="${not empty keyword}">?keyword=${keyword}</c:if>"
                   class="genre-pill <c:if test="${empty genreID}">active</c:if>">All</a>
                <c:forEach var="entry" items="${genreMap}">
                    <a href="${pageContext.request.contextPath}/products?genre=${entry.key}<c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty sort}">&sort=${sort}</c:if>"
                       class="genre-pill <c:if test="${genreID == entry.key}">active</c:if>">${entry.value}</a>
                </c:forEach>
            </div>
        </div>

<<<<<<< Updated upstream
        <div class="filter-card">
            <h3 class="text-[14px] font-bold text-gray-700 mb-3 uppercase tracking-wide">Price Range</h3>
            <form method="get" action="${pageContext.request.contextPath}/products" id="priceForm">
                <input type="hidden" name="genre"   value="${genreID}">
                <input type="hidden" name="keyword" value="${keyword}">
                <input type="hidden" name="sort"    value="${sort}">
                <div class="flex flex-col gap-2">
                    <input type="number" name="minPrice" value="${minPrice}" placeholder="Min (VND)"
                           class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:border-primary outline-none" min="0" step="1000">
                    <input type="number" name="maxPrice" value="${maxPrice}" placeholder="Max (VND)"
                           class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:border-primary outline-none" min="0" step="1000">
                    <button type="submit" class="w-full bg-primary text-white text-sm font-bold py-2 rounded-lg hover:bg-primary-dark transition-colors">
=======
            <div class="filter-card">
                <h3 class="catalog-filter-title">Price Range (VND)</h3>
                <div class="price-input-row">
                    <input type="number" name="minPrice" value="${minPrice}" placeholder="Min"
                           class="price-filter-input border border-gray-200 rounded-lg px-3 py-2 text-sm focus:border-primary outline-none"
                           min="0" step="1000" aria-describedby="priceRangeError">
                    <span class="price-input-divider" aria-hidden="true">&mdash;</span>
                    <input type="number" name="maxPrice" value="${maxPrice}" placeholder="Max"
                           class="price-filter-input border border-gray-200 rounded-lg px-3 py-2 text-sm focus:border-primary outline-none"
                           min="0" step="1000" aria-describedby="priceRangeError">
                </div>
                <p id="priceRangeError"
                   class="price-range-error<c:if test='${not empty priceRangeError}'> is-visible</c:if>"
                   role="alert" aria-live="polite"><c:out value="${priceRangeError}" /></p>
                <div class="price-filter-actions">
                    <button type="submit" class="price-filter-submit bg-primary text-white text-sm font-bold py-2 rounded-lg hover:bg-primary-dark transition-colors">
>>>>>>> Stashed changes
                        Apply Price Filter
                    </button>
                    <c:if test="${not empty minPrice or not empty maxPrice}">
                        <a href="${pageContext.request.contextPath}/products?genre=${genreID}&keyword=${keyword}&sort=${sort}"
                           class="text-center text-xs text-gray-400 hover:text-red-500">✕ Clear Price Filter</a>
                    </c:if>
                </div>
<<<<<<< Updated upstream
            </form>
        </div>
=======
                <c:if test="${hasActiveFilters}">
                    <a href="${clearFilterUrl}"
                       class="price-filter-clear text-xs text-gray-400 hover:text-red-500">&times; Clear filter</a>
                </c:if>
            </div>

            <div class="filter-card">
                <h3 class="catalog-filter-title">Genre</h3>
                <div class="catalog-filter-options">
                    <c:forEach var="entry" items="${genreMap}">
                        <c:set var="genreChecked" value="false" />
                        <c:forEach var="selectedGenre" items="${selectedGenreIDs}">
                            <c:if test="${selectedGenre == entry.key}"><c:set var="genreChecked" value="true" /></c:if>
                        </c:forEach>
                        <label class="catalog-filter-option">
                            <input type="checkbox" name="genre" value="${entry.key}"
                                   <c:if test="${genreChecked}">checked</c:if>
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
>>>>>>> Stashed changes
    </aside>

  
    <div class="flex-1 min-w-0">
        
<<<<<<< Updated upstream
        <div class="flex flex-wrap items-center gap-2 mb-6 bg-transparent border-y border-outline-variant px-0 py-4">
            <span class="text-sm font-semibold text-gray-500 mr-1">Sort by:</span>
            <a href="?<c:if test="${not empty keyword}">keyword=${keyword}&</c:if><c:if test="${not empty genreID}">genre=${genreID}&</c:if>sort=newest"
               class="sort-btn <c:if test="${sort == 'newest' or empty sort}">active</c:if>">Newest</a>
            <a href="?<c:if test="${not empty keyword}">keyword=${keyword}&</c:if><c:if test="${not empty genreID}">genre=${genreID}&</c:if>sort=popular"
               class="sort-btn <c:if test="${sort == 'popular'}">active</c:if>">Popular</a>
            <a href="?<c:if test="${not empty keyword}">keyword=${keyword}&</c:if><c:if test="${not empty genreID}">genre=${genreID}&</c:if>sort=price_asc"
               class="sort-btn <c:if test="${sort == 'price_asc'}">active</c:if>">Lowest Price</a>
            <a href="?<c:if test="${not empty keyword}">keyword=${keyword}&</c:if><c:if test="${not empty genreID}">genre=${genreID}&</c:if>sort=price_desc"
               class="sort-btn <c:if test="${sort == 'price_desc'}">active</c:if>">Highest Price</a>
            <a href="?<c:if test="${not empty keyword}">keyword=${keyword}&</c:if><c:if test="${not empty genreID}">genre=${genreID}&</c:if>sort=name"
               class="sort-btn <c:if test="${sort == 'name'}">active</c:if>"> A→Z</a>
            <span class="ml-auto text-sm text-gray-400">${totalBooks} books</span>
=======
        <div class="catalog-sortbar mb-5 bg-[#fafafa] border border-outline-variant rounded-lg px-4 py-3">
            <form method="get" action="${pageContext.request.contextPath}/products" class="catalog-sort-group">
                <c:if test="${not empty keyword}"><input type="hidden" name="keyword" value="<c:out value='${keyword}' />"></c:if>
                <c:if test="${not empty minPrice}"><input type="hidden" name="minPrice" value="${minPrice}"></c:if>
                <c:if test="${not empty maxPrice}"><input type="hidden" name="maxPrice" value="${maxPrice}"></c:if>
                <c:forEach var="selectedGenre" items="${selectedGenreIDs}">
                    <input type="hidden" name="genre" value="${selectedGenre}">
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
                        class="sort-btn <c:if test="${sort == 'name'}">active</c:if>">A-Z</button>
            </form>
            <span class="catalog-result-count text-sm text-gray-400">${totalBooks} books</span>
>>>>>>> Stashed changes
        </div>

      
        <c:choose>
            <c:when test="${not empty books}">
                <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5 mb-8" id="book-grid">
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
                                <div class="absolute top-2.5 right-2.5 bg-[#8E24AA] text-white text-[10px] font-bold px-2 py-0.5 rounded-full">Hot</div>
                            </c:if>
                  
                            <c:if test="${book.status == 'out_of_stock' or book.stockQuantity == 0}">
                                <div class="absolute inset-0 bg-black/40 flex items-center justify-center pointer-events-none">
                                    <span class="bg-white text-red-600 font-bold text-[11px] px-3 py-1 rounded-full">Out of Stock</span>
                                </div>
                            </c:if>
                            <jsp:include page="/views/layout/common/wishlist-heart.jsp">
                                <jsp:param name="wishBookId" value="${book.bookID}" />
                            </jsp:include>
                        </div>
                        <div class="p-3 flex flex-col flex-1">
                            <div class="text-[12px] text-gray-400 mb-1 truncate">
                                <c:if test="${not empty book.genreName}"><span class="text-primary font-medium">${book.genreName}</span></c:if>
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
                                        <c:when test="${i <= book.avgRating}">&#9733;</c:when>
                                        <c:otherwise><span class="text-gray-200">&#9733;</span></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span class="text-gray-400 text-[10px] ml-0.5">(${book.reviewCount})</span>
                            </div>
                            <div class="text-primary text-[16px] font-bold mb-2.5">
                                <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true"/> VND
                            </div>
                            <a href="${pageContext.request.contextPath}/products?id=${book.bookID}"
                               class="hs-primary-button mt-auto w-full py-2 text-[12px] font-bold flex items-center justify-center gap-1.5">
                                <i data-lucide="eye" class="w-3.5 h-3.5"></i> View Details
                            </a>
                        </div>
                    </div>
                    </c:forEach>
                </div>

             
                <c:if test="${totalPages > 1}">
                <nav class="flex justify-center items-center gap-1.5 flex-wrap">
                    <c:if test="${page > 1}">
<<<<<<< Updated upstream
                        <a href="?page=${page-1}<c:if test="${not empty sort}">&sort=${sort}</c:if><c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty genreID}">&genre=${genreID}</c:if><c:if test="${not empty minPrice}">&minPrice=${minPrice}</c:if><c:if test="${not empty maxPrice}">&maxPrice=${maxPrice}</c:if>"
=======
                        <c:url var="previousPageUrl" value="/products">
                            <c:param name="page" value="${page - 1}" />
                            <c:param name="size" value="${pageSize}" />
                            <c:if test="${not empty sort}"><c:param name="sort" value="${sort}" /></c:if>
                            <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
                            <c:if test="${not empty minPrice}"><c:param name="minPrice" value="${minPrice}" /></c:if>
                            <c:if test="${not empty maxPrice}"><c:param name="maxPrice" value="${maxPrice}" /></c:if>
                            <c:forEach var="selectedGenre" items="${selectedGenreIDs}"><c:param name="genre" value="${selectedGenre}" /></c:forEach>
                            <c:forEach var="selectedAuthor" items="${selectedAuthorIDs}"><c:param name="author" value="${selectedAuthor}" /></c:forEach>
                            <c:forEach var="availabilityValue" items="${availability}"><c:param name="availability" value="${availabilityValue}" /></c:forEach>
                        </c:url>
                        <a href="${previousPageUrl}"
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                                <a href="?page=${i}<c:if test="${not empty sort}">&sort=${sort}</c:if><c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty genreID}">&genre=${genreID}</c:if><c:if test="${not empty minPrice}">&minPrice=${minPrice}</c:if><c:if test="${not empty maxPrice}">&maxPrice=${maxPrice}</c:if>"
                                   class="w-9 h-9 flex items-center justify-center rounded-lg border border-gray-200 text-gray-600 hover:border-primary hover:text-primary transition-colors text-sm">${i}</a>
=======
                                <c:url var="numberedPageUrl" value="/products">
                                    <c:param name="page" value="${i}" />
                                    <c:param name="size" value="${pageSize}" />
                                    <c:if test="${not empty sort}"><c:param name="sort" value="${sort}" /></c:if>
                                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
                                    <c:if test="${not empty minPrice}"><c:param name="minPrice" value="${minPrice}" /></c:if>
                                    <c:if test="${not empty maxPrice}"><c:param name="maxPrice" value="${maxPrice}" /></c:if>
                                    <c:forEach var="selectedGenre" items="${selectedGenreIDs}"><c:param name="genre" value="${selectedGenre}" /></c:forEach>
                                    <c:forEach var="selectedAuthor" items="${selectedAuthorIDs}"><c:param name="author" value="${selectedAuthor}" /></c:forEach>
                                    <c:forEach var="availabilityValue" items="${availability}"><c:param name="availability" value="${availabilityValue}" /></c:forEach>
                                </c:url>
                                <a href="${numberedPageUrl}"
                                    class="w-9 h-9 flex items-center justify-center rounded-lg border border-gray-200 text-gray-600 hover:border-primary hover:text-primary transition-colors text-sm">${i}</a>
>>>>>>> Stashed changes
                            </c:when>
                            <c:when test="${i == 3 and page > 5}">
                                <span class="w-9 h-9 flex items-center justify-center text-gray-400">&hellip;</span>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${page < totalPages}">
<<<<<<< Updated upstream
                        <a href="?page=${page+1}<c:if test="${not empty sort}">&sort=${sort}</c:if><c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty genreID}">&genre=${genreID}</c:if><c:if test="${not empty minPrice}">&minPrice=${minPrice}</c:if><c:if test="${not empty maxPrice}">&maxPrice=${maxPrice}</c:if>"
=======
                        <c:url var="nextPageUrl" value="/products">
                            <c:param name="page" value="${page + 1}" />
                            <c:param name="size" value="${pageSize}" />
                            <c:if test="${not empty sort}"><c:param name="sort" value="${sort}" /></c:if>
                            <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
                            <c:if test="${not empty minPrice}"><c:param name="minPrice" value="${minPrice}" /></c:if>
                            <c:if test="${not empty maxPrice}"><c:param name="maxPrice" value="${maxPrice}" /></c:if>
                            <c:forEach var="selectedGenre" items="${selectedGenreIDs}"><c:param name="genre" value="${selectedGenre}" /></c:forEach>
                            <c:forEach var="selectedAuthor" items="${selectedAuthorIDs}"><c:param name="author" value="${selectedAuthor}" /></c:forEach>
                            <c:forEach var="availabilityValue" items="${availability}"><c:param name="availability" value="${availabilityValue}" /></c:forEach>
                        </c:url>
                        <a href="${nextPageUrl}"
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                    <p class="text-lg font-semibold">No Books Found</p>
                    <p class="text-sm mt-1">Try changing your search term or filters.</p>
=======
                    <c:choose>
                        <c:when test="${not empty keyword}">
                            <p class="text-lg font-semibold">No results for &ldquo;<c:out value="${keyword}" />&rdquo;.</p>
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
>>>>>>> Stashed changes
                    <a href="${pageContext.request.contextPath}/products" class="hs-primary-button mt-4 inline-block px-6 py-2.5 text-sm font-bold">View All Books</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<%@ include file="/views/layout/common/wishlist-heart.js.jsp" %>
<%@ include file="/views/layout/homepage/footer.jsp" %>

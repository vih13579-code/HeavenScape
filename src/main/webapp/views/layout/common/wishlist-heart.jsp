<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="resolvedBookId" value="${not empty param.wishBookId ? param.wishBookId : book.bookID}" />
<c:if test="${empty sessionScope.account or sessionScope.account.role == 'customer'}">
    <c:if test="${not empty resolvedBookId and resolvedBookId > 0}">
        <form method="post"
              action="${pageContext.request.contextPath}/wishlist"
              class="wishlist-form absolute top-2.5 left-2.5 z-20"
              data-book-id="${resolvedBookId}"
              onclick="event.stopPropagation();">
            <input type="hidden" name="wishBookId" value="${resolvedBookId}">
            <c:choose>
                <c:when test="${not empty wishlistBookIds and wishlistBookIds.contains(resolvedBookId)}">
                    <input type="hidden" name="wishAction" value="remove">
                    <button type="submit" class="wish-btn active" title="Remove from Wishlist" aria-label="Remove from Wishlist">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                             fill="#ef4444" stroke="#ef4444" stroke-width="2">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                        </svg>
                    </button>
                </c:when>
                <c:otherwise>
                    <input type="hidden" name="wishAction" value="add">
                    <button type="submit" class="wish-btn" title="Add to Wishlist" aria-label="Add to Wishlist">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                             fill="none" stroke="#374151" stroke-width="2">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                        </svg>
                    </button>
                </c:otherwise>
            </c:choose>
        </form>
    </c:if>
</c:if>

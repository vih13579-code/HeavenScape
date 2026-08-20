<%--
    Document   : pagination
    Created on : Jun 7, 2026, 12:56:52?PM
    Author     : DUY MINH
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="p-4 border-t flex items-center justify-between" style="border-color:#D9D9DC;">

    <%-- Hi?n th? th�ng tin trang --%>
    <span class="text-xs" style="color:#5C5C5F;">
        Trang ${currentPage} / ${totalPages}
    </span>

    <%-- N�t ph�n trang --%>
    <div class="flex items-center gap-1">

        <%-- N�t Previous --%>
        <c:choose>
            <c:when test="${currentPage <= 1}">
                <button class="p-2 border rounded opacity-40 cursor-not-allowed"
                        style="border-color:#D9D9DC;" disabled>
                    <span class="material-symbols-outlined" style="font-size:18px;color:#5C5C5F;">chevron_left</span>
                </button>
            </c:when>
            <c:otherwise>
                <a href="${baseUrl}&page=${currentPage - 1}"
                   class="p-2 border rounded hover:bg-surface-container-low transition-colors"
                   style="border-color:#D9D9DC;">
                    <span class="material-symbols-outlined" style="font-size:18px;color:#5C5C5F;">chevron_left</span>
                </a>
            </c:otherwise>
        </c:choose>

        <%-- S? trang (hi?n th? t?i ?a 5 trang, c?n gi?a trang hi?n t?i) --%>
        <c:set var="startPage" value="${currentPage - 2}" />
        <c:if test="${startPage < 1}"><c:set var="startPage" value="1" /></c:if>
        <c:set var="endPage"   value="${startPage + 4}" />
        <c:if test="${endPage > totalPages}">
            <c:set var="endPage"   value="${totalPages}" />
            <c:set var="startPage" value="${endPage - 4}" />
            <c:if test="${startPage < 1}"><c:set var="startPage" value="1" /></c:if>
        </c:if>

        <%-- Trang ??u + d?u ... n?u c?n --%>
        <c:if test="${startPage > 1}">
            <a href="${baseUrl}&page=1"
               class="w-8 h-8 flex items-center justify-center rounded border text-sm hover:bg-surface-container-low transition-colors"
               style="border-color:#D9D9DC; color:#5C5C5F;">1</a>
            <c:if test="${startPage > 2}">
                <span class="px-1 text-sm" style="color:#727783;">?</span>
            </c:if>
        </c:if>

        <%-- C�c trang gi?a --%>
        <c:forEach begin="${startPage}" end="${endPage}" var="p">
            <c:choose>
                <c:when test="${p == currentPage}">
                    <button class="w-8 h-8 rounded text-white text-sm font-semibold"
                            style="background:#C92127;">${p}</button>
                </c:when>
                <c:otherwise>
                    <a href="${baseUrl}&page=${p}"
                       class="w-8 h-8 flex items-center justify-center rounded border text-sm hover:bg-surface-container-low transition-colors"
                       style="border-color:#D9D9DC; color:#5C5C5F;">${p}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <%-- D?u ... + trang cu?i n?u c?n --%>
        <c:if test="${endPage < totalPages}">
            <c:if test="${endPage < totalPages - 1}">
                <span class="px-1 text-sm" style="color:#727783;">?</span>
            </c:if>
            <a href="${baseUrl}&page=${totalPages}"
               class="w-8 h-8 flex items-center justify-center rounded border text-sm hover:bg-surface-container-low transition-colors"
               style="border-color:#D9D9DC; color:#5C5C5F;">${totalPages}</a>
        </c:if>

        <%-- N�t Next --%>
        <c:choose>
            <c:when test="${currentPage >= totalPages}">
                <button class="p-2 border rounded opacity-40 cursor-not-allowed"
                        style="border-color:#D9D9DC;" disabled>
                    <span class="material-symbols-outlined" style="font-size:18px;color:#5C5C5F;">chevron_right</span>
                </button>
            </c:when>
            <c:otherwise>
                <a href="${baseUrl}&page=${currentPage + 1}"
                   class="p-2 border rounded hover:bg-surface-container-low transition-colors"
                   style="border-color:#D9D9DC;">
                    <span class="material-symbols-outlined" style="font-size:18px;color:#5C5C5F;">chevron_right</span>
                </a>
            </c:otherwise>
        </c:choose>

    </div>
</div>

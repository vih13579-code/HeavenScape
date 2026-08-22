<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<style>
    .oh-page { min-width: 0; padding-bottom: 28px; color: #333; }
    .oh-title { margin: 0 0 14px; color: #222; font-size: 21px; line-height: 1.3; font-weight: 800; text-transform: uppercase; }
    .oh-tabs { display: flex; align-items: stretch; margin-bottom: 14px; border-bottom: 1px solid #e5e7eb; overflow-x: auto; scrollbar-width: none; }
    .oh-tabs::-webkit-scrollbar { display: none; }
    .oh-tab { position: relative; flex: 1 0 auto; min-width: max-content; padding: 11px 16px; color: #555; font-size: 12px; font-weight: 600; text-align: center; white-space: nowrap; transition: color .15s ease; }
    .oh-tab:hover, .oh-tab.active { color: #c92127; }
    .oh-tab.active::after { content: ""; position: absolute; right: 12px; bottom: -1px; left: 12px; height: 2px; border-radius: 2px 2px 0 0; background: #c92127; }
    .oh-list { display: grid; gap: 12px; }
    .oh-card { overflow: hidden; border: 1px solid #dedede; border-radius: 7px; background: #fff; box-shadow: 0 1px 2px rgba(0, 0, 0, .025); }
    .oh-card-head { display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; padding: 13px 18px; border-bottom: 1px solid #ececec; }
    .oh-order-label { margin: 0 0 3px; color: #333; font-size: 12px; font-weight: 700; }
    .oh-order-code { color: #c92127; }
    .oh-order-date { color: #777; font-size: 11px; }
    .oh-status { flex: 0 0 auto; padding-top: 2px; font-size: 11px; font-weight: 800; text-transform: uppercase; white-space: nowrap; }
    .oh-status.pending { color: #b66a00; }
    .oh-status.processing { color: #1677d2; }
    .oh-status.shipping { color: #4f46b8; }
    .oh-status.completed, .oh-status.refunded { color: #16833b; }
    .oh-status.cancelled { color: #c92127; }
    .oh-status.refund-pending { color: #b66a00; }
    .oh-products { padding: 0 18px; }
    .oh-product-row { display: grid; grid-template-columns: minmax(0, 1fr) auto; align-items: center; gap: 20px; min-height: 112px; padding: 12px 0; border-bottom: 1px solid #efefef; }
    .oh-product-row:last-child { border-bottom: 0; }
    .oh-product-main { display: grid; grid-template-columns: 64px minmax(0, 1fr); align-items: center; gap: 14px; min-width: 0; }
    .oh-product-cover { width: 64px; height: 86px; display: flex; align-items: center; justify-content: center; overflow: hidden; border: 1px solid #e3e3e3; border-radius: 3px; background: #fafafa; }
    .oh-product-cover img { width: 100%; height: 100%; object-fit: contain; }
    .oh-product-cover .material-symbols-outlined { color: #bbb; font-size: 28px; }
    .oh-product-info { min-width: 0; }
    .oh-product-name { display: -webkit-box; overflow: hidden; color: #222; font-size: 13px; line-height: 1.4; font-weight: 700; -webkit-box-orient: vertical; -webkit-line-clamp: 2; }
    .oh-product-name:hover { color: #c92127; }
    .oh-product-author, .oh-product-quantity { margin-top: 3px; color: #777; font-size: 11px; line-height: 1.4; }
    .oh-product-quantity { color: #444; font-weight: 600; }
    .oh-product-price { color: #c92127; font-size: 15px; font-weight: 800; text-align: right; white-space: nowrap; }
    .oh-card-footer { padding: 13px 18px 14px; border-top: 1px solid #e8e8e8; }
    .oh-footer-summary { display: grid; grid-template-columns: minmax(0, 1fr) auto; align-items: baseline; gap: 18px; }
    .oh-payment { color: #555; font-size: 11px; }
    .oh-payment strong { margin-right: 7px; color: #333; }
    .oh-total { display: inline-flex; align-items: baseline; gap: 10px; color: #555; font-size: 11px; white-space: nowrap; }
    .oh-total strong { color: #c92127; font-size: 18px; font-weight: 800; }
    .oh-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 12px; }
    .oh-actions form { margin: 0; }
    .oh-btn { min-width: 130px; height: 36px; display: inline-flex; align-items: center; justify-content: center; padding: 0 18px; border: 1px solid #c92127; border-radius: 5px; font-size: 11px; font-weight: 800; text-transform: uppercase; transition: background .15s ease, color .15s ease; }
    .oh-btn.secondary { background: #fff; color: #c92127; }
    .oh-btn.secondary:hover { background: #fff2f3; }
    .oh-btn.primary { background: #c92127; color: #fff; }
    .oh-btn.primary:hover { background: #a8191f; }
    .oh-empty { padding: 54px 20px; border: 1px solid #dedede; border-radius: 7px; background: #fff; color: #777; text-align: center; }
    .oh-pagination { display: flex; align-items: center; justify-content: center; gap: 7px; margin-top: 16px; }
    .oh-page-btn { width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border: 1px solid #dedede; border-radius: 4px; background: #fff; color: #555; font-size: 12px; transition: border-color .15s ease, color .15s ease, background .15s ease; }
    .oh-page-btn:hover:not(.disabled), .oh-page-btn.active { border-color: #c92127; background: #c92127; color: #fff; }
    .oh-page-btn.disabled { color: #bbb; cursor: not-allowed; }
    .oh-pagination-ellipsis { color: #999; font-size: 12px; }

    @media (max-width: 720px) {
        .oh-tab { padding-right: 13px; padding-left: 13px; }
        .oh-card-head, .oh-products, .oh-card-footer { padding-right: 14px; padding-left: 14px; }
        .oh-product-row { grid-template-columns: 1fr; gap: 8px; }
        .oh-product-price { padding-left: 78px; text-align: left; }
        .oh-footer-summary { grid-template-columns: 1fr; gap: 8px; }
        .oh-total { justify-content: space-between; }
        .oh-actions { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); }
        .oh-actions > *, .oh-actions form, .oh-btn { width: 100%; min-width: 0; }
    }
</style>

<div class="fhs-page-inner">
    <div class="grid grid-cols-1 lg:grid-cols-[250px_minmax(0,1fr)] gap-4">
        <c:set var="activeMenu" value="orders" scope="request" />
        <%@ include file="/views/layout/profile/sidebar.jsp" %>

        <main class="oh-page">
            <h1 class="oh-title">My Orders</h1>

            <nav class="oh-tabs" aria-label="Order status filters">
                <a class="oh-tab ${empty status or status == '' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile/order-history">All</a>
                <a class="oh-tab ${status == 'pending' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile/order-history?status=pending">Pending Confirmation</a>
                <a class="oh-tab ${status == 'confirmed' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile/order-history?status=confirmed">Processing</a>
                <a class="oh-tab ${status == 'shipping' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile/order-history?status=shipping">Shipping</a>
                <a class="oh-tab ${status == 'completed' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile/order-history?status=completed">Completed</a>
                <a class="oh-tab ${status == 'cancelled' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile/order-history?status=cancelled">Cancelled</a>
                <a class="oh-tab ${status == 'pending_refund' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile/order-history?status=pending_refund">Refund Pending</a>
                <a class="oh-tab ${status == 'refunded' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile/order-history?status=refunded">Refunded</a>
            </nav>

            <section class="oh-list">
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="oh-empty">No orders were found for this status.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="order" items="${orders}">
                            <article class="oh-card">
                                <header class="oh-card-head">
                                    <div>
                                        <p class="oh-order-label">Order <span class="oh-order-code">#<c:out value="${order.orderCode}" /></span></p>
                                        <p class="oh-order-date"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy - HH:mm" /></p>
                                    </div>
                                    <c:choose>
                                        <c:when test="${order.status == 'pending'}"><span class="oh-status pending">Pending Confirmation</span></c:when>
                                        <c:when test="${order.status == 'confirmed'}"><span class="oh-status processing">Processing</span></c:when>
                                        <c:when test="${order.status == 'shipping'}"><span class="oh-status shipping">Shipping</span></c:when>
                                        <c:when test="${order.status == 'completed'}"><span class="oh-status completed">Completed</span></c:when>
                                        <c:when test="${order.status == 'cancelled' and order.paymentStatus == 'pending_refund'}"><span class="oh-status refund-pending">Refund Pending</span></c:when>
                                        <c:when test="${order.status == 'cancelled' and order.paymentStatus == 'refunded'}"><span class="oh-status refunded">Refunded</span></c:when>
                                        <c:when test="${order.status == 'cancelled'}"><span class="oh-status cancelled">Cancelled</span></c:when>
                                        <c:otherwise><span class="oh-status"><c:out value="${order.status}" /></span></c:otherwise>
                                    </c:choose>
                                </header>

                                <div class="oh-products">
                                    <c:choose>
                                        <c:when test="${empty order.orderDetails}">
                                            <div class="oh-product-row">
                                                <div class="oh-product-main">
                                                    <div class="oh-product-cover"><span class="material-symbols-outlined">menu_book</span></div>
                                                    <div class="oh-product-info"><p class="oh-product-name">Order details are unavailable.</p></div>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="detail" items="${order.orderDetails}">
                                                <div class="oh-product-row">
                                                    <div class="oh-product-main">
                                                        <a class="oh-product-cover" href="${pageContext.request.contextPath}/products?id=${detail.bookID}">
                                                            <c:choose>
                                                                <c:when test="${not empty detail.thumbnailFirst}"><img src="${detail.thumbnailFirst}" alt="${detail.title}" /></c:when>
                                                                <c:otherwise><span class="material-symbols-outlined">menu_book</span></c:otherwise>
                                                            </c:choose>
                                                        </a>
                                                        <div class="oh-product-info">
                                                            <a class="oh-product-name" href="${pageContext.request.contextPath}/products?id=${detail.bookID}"><c:out value="${detail.title}" /></a>
                                                            <p class="oh-product-author">
                                                                <c:choose>
                                                                    <c:when test="${not empty detail.authorsDisplay}"><c:out value="${detail.authorsDisplay}" /></c:when>
                                                                    <c:otherwise>Author information unavailable</c:otherwise>
                                                                </c:choose>
                                                            </p>
                                                            <p class="oh-product-quantity">x${detail.quantity}</p>
                                                        </div>
                                                    </div>
                                                    <p class="oh-product-price"><fmt:formatNumber value="${detail.subtotal}" type="number" groupingUsed="true" /> VND</p>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <footer class="oh-card-footer">
                                    <div class="oh-footer-summary">
                                        <p class="oh-payment">
                                            <strong>Payment:</strong>
                                            <c:choose>
                                                <c:when test="${order.paymentMethod == 'vnpay'}">Bank Transfer (VNPAY)</c:when>
                                                <c:when test="${order.paymentMethod == 'cod'}">Cash on Delivery (COD)</c:when>
                                                <c:otherwise><c:out value="${order.paymentMethod}" /></c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p class="oh-total"><span>Total:</span><strong><fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true" /> VND</strong></p>
                                    </div>

                                    <div class="oh-actions">
                                        <c:if test="${order.status == 'pending'}">
                                            <form method="POST" id="cancelForm_${order.orderID}" action="${pageContext.request.contextPath}/profile/order-history">
                                                <input type="hidden" name="action" value="cancel" />
                                                <input type="hidden" name="orderID" value="${order.orderID}" />
                                                <input type="hidden" name="redirect" value="list" />
                                                <input type="hidden" name="cancelReason" id="cancelReasonInput_${order.orderID}" value="" />
                                                <button type="button" class="oh-btn secondary" onclick="openCustomerCancelModalList(${order.orderID}, '${order.orderCode}')">Cancel Order</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${order.status == 'completed'}">
                                            <c:if test="${order.paymentMethod == 'cod' and order.paymentStatus == 'paid'}">
                                                <form method="POST" id="refundForm_${order.orderID}" action="${pageContext.request.contextPath}/profile/order-history">
                                                    <input type="hidden" name="action" value="requestRefund" />
                                                    <input type="hidden" name="orderID" value="${order.orderID}" />
                                                    <input type="hidden" name="redirect" value="list" />
                                                    <input type="hidden" name="refundReason" id="refundReasonInput_${order.orderID}" value="" />
                                                    <button type="button" class="oh-btn secondary" onclick="openCustomerRefundModalList(${order.orderID}, '${order.orderCode}')">Request Refund</button>
                                                </form>
                                            </c:if>
                                            <form method="POST" action="${pageContext.request.contextPath}/profile/order-history">
                                                <input type="hidden" name="action" value="buyAgain" />
                                                <input type="hidden" name="orderID" value="${order.orderID}" />
                                                <button type="submit" class="oh-btn secondary">Buy Again</button>
                                            </form>
                                        </c:if>
                                        <a class="oh-btn primary" href="${pageContext.request.contextPath}/profile/order-history?action=detail&orderID=${order.orderID}">View Details</a>
                                    </div>
                                </footer>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </section>

            <c:if test="${not empty orders}">
                <nav class="oh-pagination" aria-label="Order history pagination">
                    <c:choose>
                        <c:when test="${currentPage <= 1}"><span class="oh-page-btn disabled" aria-disabled="true">&lsaquo;</span></c:when>
                        <c:otherwise><a class="oh-page-btn" href="${baseUrl}&page=${currentPage - 1}" aria-label="Previous page">&lsaquo;</a></c:otherwise>
                    </c:choose>

                    <c:set var="startPage" value="${currentPage - 2}" />
                    <c:if test="${startPage < 1}"><c:set var="startPage" value="1" /></c:if>
                    <c:set var="endPage" value="${startPage + 4}" />
                    <c:if test="${endPage > totalPages}">
                        <c:set var="endPage" value="${totalPages}" />
                        <c:set var="startPage" value="${endPage - 4}" />
                        <c:if test="${startPage < 1}"><c:set var="startPage" value="1" /></c:if>
                    </c:if>

                    <c:if test="${startPage > 1}">
                        <a class="oh-page-btn" href="${baseUrl}&page=1">1</a>
                        <c:if test="${startPage > 2}"><span class="oh-pagination-ellipsis">...</span></c:if>
                    </c:if>
                    <c:forEach begin="${startPage}" end="${endPage}" var="pageNumber">
                        <c:choose>
                            <c:when test="${pageNumber == currentPage}"><span class="oh-page-btn active" aria-current="page">${pageNumber}</span></c:when>
                            <c:otherwise><a class="oh-page-btn" href="${baseUrl}&page=${pageNumber}">${pageNumber}</a></c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${endPage < totalPages}">
                        <c:if test="${endPage < totalPages - 1}"><span class="oh-pagination-ellipsis">...</span></c:if>
                        <a class="oh-page-btn" href="${baseUrl}&page=${totalPages}">${totalPages}</a>
                    </c:if>

                    <c:choose>
                        <c:when test="${currentPage >= totalPages}"><span class="oh-page-btn disabled" aria-disabled="true">&rsaquo;</span></c:when>
                        <c:otherwise><a class="oh-page-btn" href="${baseUrl}&page=${currentPage + 1}" aria-label="Next page">&rsaquo;</a></c:otherwise>
                    </c:choose>
                </nav>
            </c:if>
        </main>
    </div>
</div>

<div id="customerCancelModal" class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[200] p-4">
    <div class="bg-white w-full max-w-[460px] rounded-lg p-6 relative shadow-xl">
        <button type="button" onclick="closeCustomerCancelModal()" class="absolute top-3 right-4 text-2xl text-gray-400 hover:text-gray-600">&times;</button>
        <h3 class="text-lg font-bold text-[#c92127] mb-2" id="cancelModalTitle">Cancel Order</h3>
        <p class="text-sm text-gray-500 mb-3" id="cancelModalDescription">Please enter the reason you want to cancel this order.</p>
        <div id="cancelModalError" class="hidden mb-3 px-3 py-2 bg-red-50 border border-red-300 text-red-600 text-sm rounded"></div>
        <textarea id="customerCancelReasonText" rows="4" maxlength="50" class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-300" placeholder="Enter a cancellation reason (10-50 characters, including at least one letter)"></textarea>
        <div class="flex justify-end gap-3 mt-4">
            <button type="button" onclick="closeCustomerCancelModal()" class="px-4 py-2 border border-gray-300 rounded text-sm hover:bg-gray-100">Close</button>
            <button type="button" id="cancelModalSubmit" onclick="submitCustomerCancelFormList()" class="px-4 py-2 bg-[#c92127] text-white rounded text-sm font-semibold hover:bg-[#a8191f]">Confirm Cancellation</button>
        </div>
    </div>
</div>

<script>
    let currentCancelOrderId = null;
    let currentOrderRequestType = 'cancel';

    function openCustomerCancelModalList(orderId, orderCode) {
        currentCancelOrderId = orderId;
        currentOrderRequestType = 'cancel';
        document.getElementById('cancelModalTitle').textContent = 'Cancel Order #' + orderCode;
        document.getElementById('cancelModalDescription').textContent = 'Please enter the reason you want to cancel this order.';
        document.getElementById('cancelModalSubmit').textContent = 'Confirm Cancellation';
        openCustomerOrderRequestModal();
    }

    function openCustomerRefundModalList(orderId, orderCode) {
        currentCancelOrderId = orderId;
        currentOrderRequestType = 'refund';
        document.getElementById('cancelModalTitle').textContent = 'Request Refund #' + orderCode;
        document.getElementById('cancelModalDescription').textContent = 'Please enter the reason for requesting a refund.';
        document.getElementById('cancelModalSubmit').textContent = 'Submit Refund Request';
        openCustomerOrderRequestModal();
    }

    function openCustomerOrderRequestModal() {
        const reasonField = document.getElementById('customerCancelReasonText');
        reasonField.value = '';
        document.getElementById('cancelModalError').classList.add('hidden');
        const modal = document.getElementById('customerCancelModal');
        modal.classList.remove('hidden');
        modal.classList.add('flex');
        window.setTimeout(function () { reasonField.focus(); }, 0);
    }

    function showCancelModalError(message) {
        const errorBox = document.getElementById('cancelModalError');
        errorBox.textContent = message;
        errorBox.classList.remove('hidden');
    }

    function closeCustomerCancelModal() {
        const modal = document.getElementById('customerCancelModal');
        modal.classList.add('hidden');
        modal.classList.remove('flex');
        currentCancelOrderId = null;
    }

    function submitCustomerCancelFormList() {
        const reason = document.getElementById('customerCancelReasonText').value.trim();
        const isRefund = currentOrderRequestType === 'refund';
        const reasonName = isRefund ? 'refund reason' : 'cancellation reason';
        if (!reason) { showCancelModalError('Please enter a ' + reasonName + '.'); return; }
        if (reason.length < 10 || reason.length > 50) { showCancelModalError('The ' + reasonName + ' must be 10-50 characters long.'); return; }
        if (!/\p{L}/u.test(reason)) { showCancelModalError('The ' + reasonName + ' must contain at least one letter.'); return; }

        const reasonInput = document.getElementById((isRefund ? 'refundReasonInput_' : 'cancelReasonInput_') + currentCancelOrderId);
        const form = document.getElementById((isRefund ? 'refundForm_' : 'cancelForm_') + currentCancelOrderId);
        if (reasonInput && form) {
            reasonInput.value = reason;
            form.submit();
        }
    }

    document.getElementById('customerCancelModal').addEventListener('click', function (event) {
        if (event.target === this) { closeCustomerCancelModal(); }
    });
</script>

<%@ include file="/views/layout/homepage/footer.jsp" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<style>
    .od-page { min-width: 0; padding-bottom: 28px; color: #27272a; }
    .od-title { margin: 0 0 18px; font-size: 22px; line-height: 1.3; font-weight: 800; text-transform: uppercase; }
    .od-section-title { margin: 22px 0 10px; font-size: 14px; line-height: 1.3; font-weight: 800; text-transform: uppercase; }
    .od-card { border: 1px solid #dedfe2; border-radius: 7px; background: #fff; overflow: hidden; }

    .od-overview { display: grid; grid-template-columns: 190px minmax(0, 1fr) 220px; }
    .od-overview-cell { min-width: 0; padding: 18px 20px; }
    .od-overview-cell + .od-overview-cell { border-left: 1px solid #e5e5e7; }
    .od-label { margin-bottom: 7px; color: #55565a; font-size: 11px; font-weight: 600; }
    .od-code { color: #c92127; font-size: 15px; font-weight: 800; }
    .od-date { margin-top: 18px; color: #55565a; font-size: 11px; line-height: 1.55; }
    .od-date strong { display: block; margin-bottom: 2px; color: #333; }
    .od-status { margin-bottom: 14px; font-size: 12px; font-weight: 800; text-transform: uppercase; }
    .od-status.pending, .od-status.refund-pending { color: #b66a00; }
    .od-status.processing { color: #1677d2; }
    .od-status.shipping { color: #4f46b8; }
    .od-status.completed, .od-status.refunded { color: #16833b; }
    .od-status.cancelled { color: #c92127; }

    .od-progress { position: relative; display: grid; grid-template-columns: repeat(4, 1fr); margin-top: 8px; }
    .od-progress::before { content: ""; position: absolute; top: 9px; right: 12.5%; left: 12.5%; height: 2px; background: #dfe1e5; }
    .od-progress-fill { position: absolute; top: 9px; left: 12.5%; height: 2px; background: #c92127; }
    .od-step { position: relative; z-index: 1; min-width: 0; text-align: center; }
    .od-step-dot { width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; margin: 0 auto 7px; border: 2px solid #d0d3d8; border-radius: 50%; background: #fff; color: #fff; font-size: 11px; }
    .od-step.done .od-step-dot { border-color: #c92127; background: #c92127; }
    .od-step.current .od-step-dot { border-color: #1677d2; background: #1677d2; }
    .od-step:first-of-type.current .od-step-dot { border-color: #c92127; background: #c92127; }
    .od-step-name { display: block; color: #8a8b90; font-size: 10px; line-height: 1.3; white-space: nowrap; }
    .od-step.done .od-step-name { color: #55565a; }
    .od-step.current .od-step-name { color: #1677d2; font-weight: 700; }
    .od-step:first-of-type.current .od-step-name { color: #c92127; }
    .od-step-date { display: block; margin-top: 4px; color: #77787c; font-size: 9px; line-height: 1.35; }
    .od-cancel-info { padding: 10px 12px; border: 1px solid #f1c7c9; border-radius: 5px; background: #fff6f6; color: #a8191f; font-size: 11px; line-height: 1.5; }

    .od-payment-value { color: #333; font-size: 11px; line-height: 1.55; }
    .od-total-label { margin-top: 22px; color: #55565a; font-size: 11px; }
    .od-total-value { margin-top: 5px; color: #c92127; font-size: 18px; font-weight: 800; }

    .od-shipping { display: grid; grid-template-columns: minmax(190px, .7fr) minmax(0, 1.3fr); }
    .od-info-cell { min-width: 0; padding: 16px 20px; }
    .od-info-cell + .od-info-cell { border-left: 1px solid #ececef; }
    .od-info-heading { margin-bottom: 8px; color: #333; font-size: 11px; font-weight: 700; }
    .od-info-text { color: #444; font-size: 11px; line-height: 1.65; overflow-wrap: anywhere; }

    .od-items-head, .od-item { display: grid; grid-template-columns: minmax(0, 1fr) 150px 100px 160px; align-items: center; column-gap: 16px; }
    .od-items-head { min-height: 45px; padding: 0 20px; border-bottom: 1px solid #dedfe2; color: #444; font-size: 11px; font-weight: 700; }
    .od-item { min-height: 118px; padding: 14px 20px; border-bottom: 1px solid #e7e7e9; }
    .od-product { display: grid; grid-template-columns: 70px minmax(0, 1fr); align-items: center; gap: 14px; min-width: 0; }
    .od-cover { width: 70px; height: 92px; display: flex; align-items: center; justify-content: center; overflow: hidden; border: 1px solid #e2e2e4; border-radius: 3px; background: #fafafa; }
    .od-cover img { width: 100%; height: 100%; object-fit: contain; }
    .od-cover .material-symbols-outlined { color: #bbb; font-size: 27px; }
    .od-product-name { display: -webkit-box; overflow: hidden; color: #222; font-size: 12px; line-height: 1.45; font-weight: 700; -webkit-box-orient: vertical; -webkit-line-clamp: 2; }
    .od-product-name:hover { color: #c92127; }
    .od-product-author { margin-top: 5px; color: #77787c; font-size: 10px; line-height: 1.4; }
    .od-money, .od-quantity { color: #333; font-size: 11px; }
    .od-line-total { color: #c92127; font-size: 12px; font-weight: 800; text-align: right; }

    .od-summary { width: 390px; max-width: 100%; margin-left: auto; padding: 13px 20px 15px; }
    .od-summary-row { display: grid; grid-template-columns: 1fr auto; align-items: baseline; gap: 20px; padding: 5px 0; color: #55565a; font-size: 11px; }
    .od-summary-row strong { color: #333; font-weight: 700; white-space: nowrap; }
    .od-summary-row.discount strong { color: #16833b; }
    .od-summary-row.total { margin-top: 6px; padding-top: 11px; border-top: 1px solid #e4e4e6; color: #222; font-size: 12px; font-weight: 800; }
    .od-summary-row.total strong { color: #c92127; font-size: 18px; font-weight: 800; }
    .od-actions { display: flex; align-items: center; justify-content: space-between; gap: 12px; padding: 13px 20px; border-top: 1px solid #dedfe2; }
    .od-actions-right { display: flex; gap: 10px; margin-left: auto; }
    .od-actions form { margin: 0; }
    .od-btn { min-width: 130px; height: 36px; display: inline-flex; align-items: center; justify-content: center; padding: 0 18px; border: 1px solid #c92127; border-radius: 5px; font-size: 11px; font-weight: 800; text-transform: uppercase; }
    .od-btn.secondary { background: #fff; color: #c92127; }
    .od-btn.secondary:hover { background: #fff2f3; }
    .od-btn.primary { background: #c92127; color: #fff; }
    .od-btn.primary:hover { background: #a8191f; }

    @media (max-width: 900px) {
        .od-overview { grid-template-columns: 1fr 1fr; }
        .od-overview-cell:nth-child(2) { grid-column: 1 / -1; grid-row: 2; border-top: 1px solid #e5e5e7; border-left: 0; }
        .od-overview-cell:nth-child(3) { border-left: 1px solid #e5e5e7; }
        .od-items-head { display: none; }
        .od-item { grid-template-columns: minmax(0, 1fr) auto; row-gap: 8px; }
        .od-item .od-money::before { content: "Unit price: "; color: #77787c; }
        .od-item .od-quantity::before { content: "Quantity: "; color: #77787c; }
        .od-item .od-line-total { grid-column: 2; grid-row: 1; }
    }

    @media (max-width: 620px) {
        .od-overview, .od-shipping { grid-template-columns: 1fr; }
        .od-overview-cell:nth-child(2) { grid-column: auto; grid-row: auto; }
        .od-overview-cell + .od-overview-cell, .od-overview-cell:nth-child(3), .od-info-cell + .od-info-cell { border-top: 1px solid #e5e5e7; border-left: 0; }
        .od-item { display: grid; grid-template-columns: 1fr; }
        .od-product { grid-template-columns: 62px minmax(0, 1fr); }
        .od-cover { width: 62px; height: 82px; }
        .od-item .od-line-total { grid-column: auto; grid-row: auto; text-align: left; }
        .od-actions { align-items: stretch; flex-direction: column; }
        .od-actions-right { width: 100%; margin-left: 0; }
        .od-actions .od-btn, .od-actions-right form, .od-actions-right .od-btn { width: 100%; }
    }
</style>

<c:set var="statusStep" value="1" />
<c:if test="${order.status == 'confirmed'}"><c:set var="statusStep" value="2" /></c:if>
<c:if test="${order.status == 'shipping'}"><c:set var="statusStep" value="3" /></c:if>
<c:if test="${order.status == 'completed'}"><c:set var="statusStep" value="4" /></c:if>

<c:set var="itemSubtotal" value="0" />
<c:set var="totalQuantity" value="0" />
<c:forEach var="detail" items="${orderDetails}">
    <c:set var="itemSubtotal" value="${itemSubtotal + detail.subtotal}" />
    <c:set var="totalQuantity" value="${totalQuantity + detail.quantity}" />
</c:forEach>

<div class="fhs-page-inner">
    <div class="grid grid-cols-1 lg:grid-cols-[250px_minmax(0,1fr)] gap-4">
        <c:set var="activeMenu" value="orders" scope="request" />
        <%@ include file="/views/layout/profile/sidebar.jsp" %>

        <main class="od-page">
    <h1 class="od-title">Order Details</h1>

    <section class="od-card od-overview">
        <div class="od-overview-cell">
            <p class="od-label">Order Code</p>
            <p class="od-code">#<c:out value="${order.orderCode}" /></p>
            <p class="od-date">
                <strong>Order Date</strong>
                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy - HH:mm" />
            </p>
        </div>

        <div class="od-overview-cell">
            <p class="od-label">Order Status</p>
            <c:choose>
                <c:when test="${order.status == 'pending'}"><p class="od-status pending">Pending Confirmation</p></c:when>
                <c:when test="${order.status == 'confirmed'}"><p class="od-status processing">Processing</p></c:when>
                <c:when test="${order.status == 'shipping'}"><p class="od-status shipping">Shipping</p></c:when>
                <c:when test="${order.paymentStatus == 'refund_rejected'}"><p class="od-status cancelled">Refund Rejected</p></c:when>
                <c:when test="${order.status == 'completed'}"><p class="od-status completed">Completed</p></c:when>
                <c:when test="${order.status == 'cancelled' and order.paymentStatus == 'pending_refund'}"><p class="od-status refund-pending">Refund Pending</p></c:when>
                <c:when test="${order.status == 'cancelled' and order.paymentStatus == 'refunded'}"><p class="od-status refunded">Refunded</p></c:when>
                <c:when test="${order.status == 'cancelled'}"><p class="od-status cancelled">Cancelled</p></c:when>
                <c:otherwise><p class="od-status"><c:out value="${order.status}" /></p></c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${order.paymentStatus == 'refund_rejected'}">
                    <div class="od-cancel-info">
                        <strong>Refund request rejected:</strong>
                        <c:choose>
                            <c:when test="${not empty order.cancelReason}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(order.cancelReason, 'Refund rejected: ')}">
                                        <c:out value="${fn:substringAfter(order.cancelReason, 'Refund rejected: ')}" />
                                    </c:when>
                                    <c:otherwise><c:out value="${order.cancelReason}" /></c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>No rejection reason was recorded.</c:otherwise>
                        </c:choose>
                    </div>
                </c:when>
                <c:when test="${order.status == 'cancelled'}">
                    <div class="od-cancel-info">
                        <c:choose>
                            <c:when test="${order.paymentStatus == 'refunded'}"><strong>Refund by:</strong> Staff</c:when>
                            <c:otherwise>
                                <strong>Cancelled by:</strong>
                                <c:choose>
                                    <c:when test="${not empty order.cancelledByName}"><c:out value="${order.cancelledByName}" /></c:when>
                                    <c:otherwise>Account unavailable</c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose><br>
                        <c:choose>
                            <c:when test="${not empty order.cancelReason}"><strong>Cancellation reason:</strong> <c:out value="${order.cancelReason}" /></c:when>
                            <c:otherwise>This order was cancelled.</c:otherwise>
                        </c:choose>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="od-progress">
                        <c:choose>
                            <c:when test="${statusStep == 1}"><span class="od-progress-fill" style="width: 0;"></span></c:when>
                            <c:when test="${statusStep == 2}"><span class="od-progress-fill" style="width: 25%;"></span></c:when>
                            <c:when test="${statusStep == 3}"><span class="od-progress-fill" style="width: 50%;"></span></c:when>
                            <c:otherwise><span class="od-progress-fill" style="width: 75%;"></span></c:otherwise>
                        </c:choose>

                        <div class="od-step ${statusStep > 1 ? 'done' : 'current'}">
                            <span class="od-step-dot">&#10003;</span>
                            <span class="od-step-name">Order Placed</span>
                            <span class="od-step-date"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy" /><br><fmt:formatDate value="${order.createdAt}" pattern="HH:mm" /></span>
                        </div>
                        <div class="od-step ${statusStep > 2 ? 'done' : (statusStep == 2 ? 'current' : '')}">
                            <span class="od-step-dot">&#10003;</span>
                            <span class="od-step-name">Processing</span>
                        </div>
                        <div class="od-step ${statusStep > 3 ? 'done' : (statusStep == 3 ? 'current' : '')}">
                            <span class="od-step-dot">&#10003;</span>
                            <span class="od-step-name">Shipping</span>
                        </div>
                        <div class="od-step ${statusStep == 4 ? 'current' : ''}">
                            <span class="od-step-dot">&#10003;</span>
                            <span class="od-step-name">Completed</span>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="od-overview-cell">
            <p class="od-label">Payment</p>
            <p class="od-payment-value">
                <c:choose>
                    <c:when test="${order.paymentMethod == 'cod'}">Cash on Delivery (COD)</c:when>
                    <c:when test="${order.paymentMethod == 'vnpay'}">Bank Transfer (VNPAY)</c:when>
                    <c:otherwise><c:out value="${order.paymentMethod}" /></c:otherwise>
                </c:choose>
            </p>
            <p class="od-total-label">Total</p>
            <p class="od-total-value"><fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true" /> VND</p>
        </div>
    </section>

    <h2 class="od-section-title">Shipping Information</h2>
    <section class="od-card od-shipping">
        <div class="od-info-cell">
            <p class="od-info-heading">Recipient</p>
            <p class="od-info-text"><c:out value="${order.recipientName}" /><br><c:out value="${order.recipientPhone}" /></p>
        </div>
        <div class="od-info-cell">
            <p class="od-info-heading">Delivery Address</p>
            <p class="od-info-text">
                <c:out value="${order.street}" /><c:if test="${not empty order.district}">, <c:out value="${order.district}" /></c:if><c:if test="${not empty order.city}">, <c:out value="${order.city}" /></c:if>
            </p>
        </div>
    </section>

    <h2 class="od-section-title">Ordered Items (${fn:length(orderDetails)})</h2>
    <section class="od-card">
        <div class="od-items-head">
            <span>Product</span>
            <span>Unit Price</span>
            <span>Quantity</span>
            <span style="text-align: right;">Amount</span>
        </div>

        <c:forEach var="detail" items="${orderDetails}">
            <div class="od-item">
                <div class="od-product">
                    <a class="od-cover" href="${pageContext.request.contextPath}/products?id=${detail.bookID}">
                        <c:choose>
                            <c:when test="${not empty detail.thumbnailFirst}"><img src="${detail.thumbnailFirst}" alt="" /></c:when>
                            <c:otherwise><span class="material-symbols-outlined">menu_book</span></c:otherwise>
                        </c:choose>
                    </a>
                    <div>
                        <a class="od-product-name" href="${pageContext.request.contextPath}/products?id=${detail.bookID}"><c:out value="${detail.title}" /></a>
                        <p class="od-product-author">
                            <c:if test="${not empty detail.authorsDisplay}"><c:out value="${detail.authorsDisplay}" /></c:if>
                        </p>
                    </div>
                </div>
                <p class="od-money"><fmt:formatNumber value="${detail.unitPrice}" type="number" groupingUsed="true" /> VND</p>
                <p class="od-quantity">x${detail.quantity}</p>
                <p class="od-line-total"><fmt:formatNumber value="${detail.subtotal}" type="number" groupingUsed="true" /> VND</p>
            </div>
        </c:forEach>

        <div class="od-summary">
            <div class="od-summary-row">
                <span>Subtotal (${totalQuantity} items)</span>
                <strong><fmt:formatNumber value="${itemSubtotal}" type="number" groupingUsed="true" /> VND</strong>
            </div>
            <c:if test="${itemSubtotal > order.totalPrice}">
                <div class="od-summary-row discount">
                    <span>Voucher Discount</span>
                    <strong>- <fmt:formatNumber value="${itemSubtotal - order.totalPrice}" type="number" groupingUsed="true" /> VND</strong>
                </div>
            </c:if>
            <div class="od-summary-row total">
                <span>Total</span>
                <strong><fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true" /> VND</strong>
            </div>
        </div>

        <div class="od-actions">
            <a class="od-btn secondary" href="${pageContext.request.contextPath}/profile/order-history">Back to Orders</a>
            <div class="od-actions-right">
                <c:if test="${order.status == 'pending'}">
                    <form id="cancelOrderForm" method="POST" action="${pageContext.request.contextPath}/profile/order-history">
                        <input type="hidden" name="action" value="cancel" />
                        <input type="hidden" name="orderID" value="${order.orderID}" />
                        <input type="hidden" name="cancelReason" id="customerCancelReasonInput" value="" />
                        <button type="button" class="od-btn primary" onclick="openCustomerCancelModal()">Cancel Order</button>
                    </form>
                </c:if>
                <c:if test="${order.status == 'completed'}">
                    <c:if test="${order.paymentMethod == 'cod' and order.paymentStatus == 'paid'}">
                        <form id="refundOrderForm" method="POST" action="${pageContext.request.contextPath}/profile/order-history">
                            <input type="hidden" name="action" value="requestRefund" />
                            <input type="hidden" name="orderID" value="${order.orderID}" />
                            <input type="hidden" name="refundReason" id="customerRefundReasonInput" value="" />
                            <input type="hidden" name="refundBankName" id="customerRefundBankNameInput" value="" />
                            <input type="hidden" name="refundAccountNumber" id="customerRefundAccountNumberInput" value="" />
                            <input type="hidden" name="refundAccountHolder" id="customerRefundAccountHolderInput" value="" />
                            <button type="button" class="od-btn secondary" onclick="openCustomerRefundModal()">Request Refund</button>
                        </form>
                    </c:if>
                    <form method="POST" action="${pageContext.request.contextPath}/profile/order-history">
                        <input type="hidden" name="action" value="buyAgain" />
                        <input type="hidden" name="orderID" value="${order.orderID}" />
                        <button type="submit" class="od-btn primary">Buy Again</button>
                    </form>
                </c:if>
            </div>
        </div>
    </section>
        </main>
    </div>
</div>

<c:if test="${order.status == 'pending' or (order.status == 'completed' and order.paymentMethod == 'cod' and order.paymentStatus == 'paid')}">
    <div id="customerCancelModal" class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[200] p-4">
        <div class="bg-white w-full max-w-[460px] rounded-lg p-6 relative shadow-xl">
            <button type="button" onclick="closeCustomerCancelModal()" class="absolute top-3 right-4 text-2xl text-gray-400 hover:text-gray-600">&times;</button>
            <h3 class="text-lg font-bold text-[#c92127] mb-2" id="customerOrderModalTitle">Cancel Order</h3>
            <p class="text-sm text-gray-500 mb-3" id="customerOrderModalDescription">Please enter the reason you want to cancel this order.</p>
            <div id="cancelModalError" class="hidden mb-3 px-3 py-2 bg-red-50 border border-red-300 text-red-600 text-sm rounded"></div>
            <label for="customerCancelReasonText" class="mb-1 block text-sm font-semibold">Reason <span class="text-red-600 text-xs">*</span></label>
            <textarea id="customerCancelReasonText" rows="4" maxlength="50" class="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-300" placeholder="Enter a cancellation reason (10-50 characters, including at least one letter)"></textarea>
            <div id="customerRefundBankFields" class="hidden mt-3 space-y-3">
                <div><label for="customerRefundBankNameText" class="mb-1 block text-sm font-semibold">Bank Name *</label><input id="customerRefundBankNameText" maxlength="100" class="w-full border border-gray-300 rounded px-3 py-2 text-sm" placeholder="Example: Vietcombank" /></div>
                <div><label for="customerRefundAccountNumberText" class="mb-1 block text-sm font-semibold">Account Number *</label><input id="customerRefundAccountNumberText" inputmode="numeric" maxlength="20" class="w-full border border-gray-300 rounded px-3 py-2 text-sm" placeholder="6-20 digits" /></div>
                <div><label for="customerRefundAccountHolderText" class="mb-1 block text-sm font-semibold">Account Holder *</label><input id="customerRefundAccountHolderText" maxlength="100" class="w-full border border-gray-300 rounded px-3 py-2 text-sm uppercase" placeholder="NGUYEN VAN A" /></div>
            </div>
            <div class="flex justify-end gap-3 mt-4">
                <button type="button" onclick="closeCustomerCancelModal()" class="px-4 py-2 border border-gray-300 rounded text-sm hover:bg-gray-100">Close</button>
                <button type="button" id="customerOrderModalSubmit" onclick="submitCustomerCancelForm()" class="px-4 py-2 bg-[#c92127] text-white rounded text-sm font-semibold hover:bg-[#a8191f]">Confirm Cancellation</button>
            </div>
        </div>
    </div>

    <script>
        let currentOrderRequestType = 'cancel';

        function openCustomerCancelModal() {
            currentOrderRequestType = 'cancel';
            document.getElementById('customerOrderModalTitle').textContent = 'Cancel Order';
            document.getElementById('customerOrderModalDescription').textContent = 'Please enter the reason you want to cancel this order.';
            document.getElementById('customerOrderModalSubmit').textContent = 'Confirm Cancellation';
            document.getElementById('customerRefundBankFields').classList.add('hidden');
            openCustomerOrderRequestModal();
        }

        function openCustomerRefundModal() {
            currentOrderRequestType = 'refund';
            document.getElementById('customerOrderModalTitle').textContent = 'Request Refund';
            document.getElementById('customerOrderModalDescription').textContent = 'Please enter the reason for requesting a refund.';
            document.getElementById('customerOrderModalSubmit').textContent = 'Submit Refund Request';
            document.getElementById('customerRefundBankFields').classList.remove('hidden');
            openCustomerOrderRequestModal();
        }

        function openCustomerOrderRequestModal() {
            const modal = document.getElementById('customerCancelModal');
            const reasonField = document.getElementById('customerCancelReasonText');
            reasonField.value = '';
            ['customerRefundBankNameText', 'customerRefundAccountNumberText', 'customerRefundAccountHolderText'].forEach(function (id) {
                document.getElementById(id).value = '';
            });
            document.getElementById('cancelModalError').classList.add('hidden');
            modal.classList.remove('hidden');
            modal.classList.add('flex');
            window.setTimeout(function () { reasonField.focus(); }, 0);
        }

        function closeCustomerCancelModal() {
            const modal = document.getElementById('customerCancelModal');
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        }

        function showCancelModalError(message) {
            const errorBox = document.getElementById('cancelModalError');
            errorBox.textContent = message;
            errorBox.classList.remove('hidden');
        }

        function submitCustomerCancelForm() {
            const reason = document.getElementById('customerCancelReasonText').value.trim();
            const isRefund = currentOrderRequestType === 'refund';
            const reasonName = isRefund ? 'refund reason' : 'cancellation reason';
            if (!reason) { showCancelModalError('Please enter a ' + reasonName + '.'); return; }
            if (reason.length < 10 || reason.length > 50) { showCancelModalError('The ' + reasonName + ' must be 10-50 characters long.'); return; }
            if (!/\p{L}/u.test(reason)) { showCancelModalError('The ' + reasonName + ' must contain at least one letter.'); return; }

            const bankName = document.getElementById('customerRefundBankNameText').value.trim();
            const accountNumber = document.getElementById('customerRefundAccountNumberText').value.trim();
            const accountHolder = document.getElementById('customerRefundAccountHolderText').value.trim();

            if (isRefund && (bankName.length < 2 || !/^[\p{L}0-9 .&()/-]+$/u.test(bankName))) {
                showCancelModalError('Please enter a valid bank name.');
                return;
            }
            if (isRefund && !/^[0-9]{6,20}$/.test(accountNumber)) {
                showCancelModalError('The account number must contain 6-20 digits.');
                return;
            }
            if (isRefund && (accountHolder.length < 2 || !/^[\p{L} .'-]+$/u.test(accountHolder))) {
                showCancelModalError('Please enter a valid account holder name.');
                return;
            }

            document.getElementById(isRefund ? 'customerRefundReasonInput' : 'customerCancelReasonInput').value = reason;
            if (isRefund) {
                document.getElementById('customerRefundBankNameInput').value = bankName;
                document.getElementById('customerRefundAccountNumberInput').value = accountNumber;
                document.getElementById('customerRefundAccountHolderInput').value = accountHolder.toUpperCase();
            }
            document.getElementById(isRefund ? 'refundOrderForm' : 'cancelOrderForm').submit();
        }

        document.getElementById('customerCancelModal').addEventListener('click', function (event) {
            if (event.target === this) { closeCustomerCancelModal(); }
        });
    </script>
</c:if>

<%@ include file="/views/layout/homepage/footer.jsp" %>

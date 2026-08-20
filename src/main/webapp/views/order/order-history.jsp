<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<div class="fhs-page-inner">
    <div class="grid grid-cols-1 lg:grid-cols-[250px_minmax(0,1fr)] gap-4">

        <c:set var="activeMenu" value="orders" scope="request"/>
        <%@ include file="/views/layout/profile/sidebar.jsp" %>

        <div class="min-w-0">
            <section class="space-y-6">

                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <h1 class="text-2xl font-bold text-[#C92127]">My Order History</h1>
                </div>

                <div class="flex overflow-x-auto border-b border-gray-200 gap-8 no-scrollbar px-2">
                    <a href="${pageContext.request.contextPath}/profile/order-history"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${empty status or status == '' ? 'font-semibold text-[#C92127] border-b-2 border-[#C92127]' : 'font-medium text-gray-600 hover:text-[#C92127]'}">
                        All
                    </a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=pending"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'pending' ? 'font-semibold text-[#C92127] border-b-2 border-[#C92127]' : 'font-medium text-gray-600 hover:text-[#C92127]'}">
                        Pending Confirmation
                    </a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=confirmed"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'confirmed' ? 'font-semibold text-[#C92127] border-b-2 border-[#C92127]' : 'font-medium text-gray-600 hover:text-[#C92127]'}">
                        Confirmed
                    </a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=shipping"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'shipping' ? 'font-semibold text-[#C92127] border-b-2 border-[#C92127]' : 'font-medium text-gray-600 hover:text-[#C92127]'}">
                        Shipping
                    </a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=completed"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'completed' ? 'font-semibold text-[#C92127] border-b-2 border-[#C92127]' : 'font-medium text-gray-600 hover:text-[#C92127]'}">
                        Completed
                    </a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=cancelled"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'cancelled' ? 'font-semibold text-[#C92127] border-b-2 border-[#C92127]' : 'font-medium text-gray-600 hover:text-[#C92127]'}">
                        Cancelled
                    </a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=pending_refund"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'pending_refund' ? 'font-semibold text-[#C92127] border-b-2 border-[#C92127]' : 'font-medium text-gray-600 hover:text-[#C92127]'}">
                        Refund Pending
                    </a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=refunded"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'refunded' ? 'font-semibold text-[#C92127] border-b-2 border-[#C92127]' : 'font-medium text-gray-600 hover:text-[#C92127]'}">
                        Refunded
                    </a>
                </div>

                <div class="space-y-4">
                    <c:choose>
                        <c:when test="${empty orders}">
                            <div class="profile-card p-10 text-center text-gray-500">
                                You do not have any orders yet.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="order" items="${orders}">
                                <div class="profile-card p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                                    <div class="flex items-center gap-5">
                                        <div class="w-16 h-20 bg-gray-100 rounded overflow-hidden flex-shrink-0 border border-gray-200 flex items-center justify-center">
                                            <span class="material-symbols-outlined text-gray-400 text-3xl">receipt_long</span>
                                        </div>
                                        <div class="space-y-1">
                                            <p class="text-sm font-semibold text-[#C92127]">${order.orderCode}</p>
                                            <p class="text-xs text-gray-500">
                                                Order Date: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy" />
                                            </p>
                                            <p class="text-base font-bold text-gray-900">
                                                <fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true" /> VND
                                            </p>
                                        </div>
                                    </div>

                                    <div class="flex items-center justify-between sm:justify-end gap-4">
                                        <!-- Badge trạng thái đơn -->
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full bg-yellow-50 text-[#e65c00] text-xs font-semibold">Pending Confirmation</span>
                                            </c:when>
                                            <c:when test="${order.status == 'confirmed'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full bg-[#FDE8E9] text-[#C92127] text-xs font-semibold">Confirmed</span>
                                            </c:when>
                                            <c:when test="${order.status == 'shipping'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full bg-indigo-50 text-[#134aa4] text-xs font-semibold">Shipping</span>
                                            </c:when>
                                            <c:when test="${order.status == 'completed'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full bg-green-50 text-[#2E7D32] text-xs font-semibold">Completed</span>
                                            </c:when>
                                            <c:when test="${order.status == 'cancelled'}">
                                                <c:choose>
                                                    <c:when test="${order.paymentMethod == 'vnpay' && order.paymentStatus == 'pending_refund'}">
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full bg-amber-50 text-amber-600 text-xs font-semibold">Refund Pending</span>
                                                    </c:when>
                                                    <c:when test="${order.paymentMethod == 'vnpay' && order.paymentStatus == 'refunded'}">
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full bg-green-50 text-green-700 text-xs font-semibold">Refunded</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full bg-red-50 text-[#D32F2F] text-xs font-semibold">Cancelled</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center px-3 py-1 rounded-full bg-gray-100 text-gray-600 text-xs font-semibold">${order.status}</span>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:if test="${order.status == 'pending'}">
                                            <form method="POST" id="cancelForm_${order.orderID}" action="${pageContext.request.contextPath}/profile/order-history">
                                                <input type="hidden" name="action" value="cancel" />
                                                <input type="hidden" name="orderID" value="${order.orderID}" />
                                                <input type="hidden" name="redirect" value="list" />
                                                <input type="hidden" name="cancelReason" id="cancelReasonInput_${order.orderID}" value="" />
                                                <button type="button" onclick="openCustomerCancelModalList(${order.orderID}, '${order.orderCode}')"
                                                        class="px-5 py-2 border border-red-500 text-red-500 rounded-lg text-sm font-medium hover:bg-red-50 transition-colors">
                                                    Cancelled
                                                </button>
                                            </form>
                                        </c:if>

                                        <a href="${pageContext.request.contextPath}/profile/order-history?action=view&orderID=${order.orderID}">
                                            <button type="button" class="px-5 py-2 border border-[#C92127] text-[#C92127] rounded-lg text-sm font-medium hover:bg-[#FDE8E9] transition-colors">
                                                Details
                                            </button>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${not empty orders}">
                    <%@ include file="/views/layout/common/pagination.jsp" %>
                </c:if>

            </section>
        </div>

    </div>
</div>

<%@ include file="/views/layout/homepage/footer.jsp" %>

<!-- Modal nhập lý do hủy đơn hàng -->
<div id="customerCancelModal" class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[200]">
    <div class="bg-white w-[460px] rounded-xl p-6 relative shadow-xl">
        <button type="button" onclick="closeCustomerCancelModal()" class="absolute top-3 right-4 text-2xl text-gray-400 hover:text-gray-600">&times;</button>
        <h3 class="text-lg font-bold text-[#D32F2F] mb-2" id="cancelModalTitle">Cancel Order</h3>
        <p class="text-sm text-gray-500 mb-3">Please enter the reason you want to cancel this order.</p>

        <div id="cancelModalError" class="hidden mb-3 px-3 py-2 bg-red-50 border border-red-300 text-red-600 text-sm rounded-lg"></div>

        <textarea id="customerCancelReasonText" rows="4" maxlength="50"
                  class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-300"
                  placeholder="Enter a cancellation reason (10–50 characters, including at least one letter)"></textarea>

        <div class="flex justify-end gap-3 mt-4">
            <button type="button" onclick="closeCustomerCancelModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-sm hover:bg-gray-100">
                Close
            </button>
            <button type="button" onclick="submitCustomerCancelFormList()" class="px-4 py-2 bg-[#D32F2F] text-white rounded-lg text-sm font-semibold hover:opacity-90">
                Confirm Cancellation
            </button>
        </div>
    </div>
</div>

<script>
    let currentCancelOrderId = null;

    function openCustomerCancelModalList(orderId, orderCode) {
        currentCancelOrderId = orderId;
        const titleElem = document.getElementById('cancelModalTitle');
        if (titleElem) {
            titleElem.textContent = 'Cancel Order #' + orderCode;
        }
        const textElem = document.getElementById('customerCancelReasonText');
        if (textElem) {
            textElem.value = '';
            textElem.focus();
        }
        const errorElem = document.getElementById('cancelModalError');
        if (errorElem) {
            errorElem.textContent = '';
            errorElem.classList.add('hidden');
        }
        const modal = document.getElementById('customerCancelModal');
        if (modal) {
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        }
    }

    function showCancelModalError(message) {
        const errorElem = document.getElementById('cancelModalError');
        if (errorElem) {
            errorElem.textContent = message;
            errorElem.classList.remove('hidden');
        }
    }

    function closeCustomerCancelModal() {
        const modal = document.getElementById('customerCancelModal');
        if (modal) {
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        }
        currentCancelOrderId = null;
    }

    function submitCustomerCancelFormList() {
        const reasonElem = document.getElementById('customerCancelReasonText');
        const reason = reasonElem ? reasonElem.value.trim() : '';

        if (reason.length === 0) {
            showCancelModalError('Please enter a cancellation reason!');
            return;
        }
        if (reason.length < 10) {
            showCancelModalError('The cancellation reason must be at least 10 characters!');
            return;
        }
        if (reason.length > 50) {
            showCancelModalError('The cancellation reason cannot exceed 50 characters!');
            return;
        }
        const hasLetter = /[a-zA-ZÀ-ỹ]/.test(reason);
        if (!hasLetter) {
            showCancelModalError('The cancellation reason must contain at least one letter!');
            return;
        }

        if (currentCancelOrderId) {
            const reasonInput = document.getElementById('cancelReasonInput_' + currentCancelOrderId);
            const form = document.getElementById('cancelForm_' + currentCancelOrderId);
            if (reasonInput && form) {
                reasonInput.value = reason;
                form.submit();
            }
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const cancelModal = document.getElementById('customerCancelModal');
        if (cancelModal) {
            cancelModal.addEventListener('click', function (e) {
                if (e.target === cancelModal) {
                    closeCustomerCancelModal();
                }
            });
        }
    });
</script>

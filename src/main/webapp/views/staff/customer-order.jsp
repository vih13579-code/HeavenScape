<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Order Management - HeavenScape</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
            rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
              rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #F7F7F8;
            }

            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }

            ::-webkit-scrollbar {
                width: 6px;
            }

            ::-webkit-scrollbar-track {
                background: transparent;
            }

            ::-webkit-scrollbar-thumb {
                background: #D9D9DC;
                border-radius: 10px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: #727783;
            }
        </style>
    </head>

    <body class="bg-[#F7F7F8] text-[#1B1B1B] flex min-h-screen">
        <%@ include file="/views/layout/common/toast.jsp" %>
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen flex flex-col justify-between">

            <div class="p-6 max-w-[1280px] mx-auto flex-1 w-full space-y-6">

                <div class="hs-admin-page-heading">
                    <div>
                    <h1 class="hs-admin-page-title">Order List</h1>
                    <p class="hs-admin-page-subtitle">Manage and update the processing status of
                        HeavenScape.</p>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm border border-[#D9D9DC] overflow-hidden">

                    <div
                        class="p-4 border-b border-[#D9D9DC] flex flex-wrap items-center justify-between gap-4 bg-gray-50">
                        <div class="flex items-center gap-2 overflow-x-auto no-scrollbar">
                            <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=all&keyword=${keyword}"
                               class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${empty status or status == 'all' ? 'bg-[#C92127] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200 transition-colors'}">
                                All
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=pending&keyword=${keyword}"
                               class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'pending' ? 'bg-[#C92127] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200 transition-colors'}">
                                Pending Confirmation
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=confirmed&keyword=${keyword}"
                               class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'confirmed' ? 'bg-[#C92127] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200 transition-colors'}">
                                Confirmed
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=shipping&keyword=${keyword}"
                               class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'shipping' ? 'bg-[#C92127] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200 transition-colors'}">
                                Shipping
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=completed&keyword=${keyword}"
                               class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'completed' ? 'bg-[#C92127] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200 transition-colors'}">
                                Completed
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=cancelled&keyword=${keyword}"
                               class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'cancelled' ? 'bg-[#C92127] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200 transition-colors'}">
                                Cancelled
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=pending_refund&keyword=${keyword}"
                               class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'pending_refund' ? 'bg-[#C92127] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200 transition-colors'}">
                                Refund Pending
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=refunded&keyword=${keyword}"
                               class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'refunded' ? 'bg-[#C92127] text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200 transition-colors'}">
                                Refunded
                            </a>
                        </div>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-gray-50 border-b border-[#D9D9DC]">
                                    <th
                                        class="px-6 py-3.5 text-xs text-gray-500 uppercase tracking-wider font-semibold">
                                        Order Code</th>
                                    <th
                                        class="px-6 py-3.5 text-xs text-gray-500 uppercase tracking-wider font-semibold">
                                        Customer Name</th>
                                    <th
                                        class="px-6 py-3.5 text-xs text-gray-500 uppercase tracking-wider font-semibold">
                                        Order Date</th>
                                    <th
                                        class="px-6 py-3.5 text-xs text-gray-500 uppercase tracking-wider font-semibold">
                                        Payment</th>
                                    <th
                                        class="px-6 py-3.5 text-xs text-gray-500 uppercase tracking-wider font-semibold">
                                        Total Amount</th>
                                    <th
                                        class="px-6 py-3.5 text-xs text-gray-500 uppercase tracking-wider font-semibold">
                                        Status</th>
                                    <th
                                        class="px-6 py-3.5 text-xs text-gray-500 uppercase tracking-wider font-semibold text-right">
                                        Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <c:if test="${empty orderList}">
                                    <tr>
                                        <td colspan="7"
                                            class="px-6 py-8 text-center text-gray-500 text-sm">
                                            No orders found.
                                        </td>
                                    </tr>
                                </c:if>

                                <c:forEach var="order" items="${orderList}">
                                    <tr class="hover:bg-[#FDE8E9]/50 transition-colors">
                                        <td class="px-6 py-3.5">
                                            <span
                                                class="text-sm font-semibold text-[#C92127]">${order.orderCode}</span>
                                        </td>
                                        <td class="px-6 py-3.5">
                                            <span
                                                class="text-sm font-medium text-gray-900">${order.recipientName}</span>
                                        </td>
                                        <td class="px-6 py-3.5 text-sm text-gray-500">
                                            <fmt:formatDate value="${order.createdAt}"
                                                            pattern="HH:mm - dd/MM/yyyy" />
                                        </td>
                                        <td class="px-6 py-3.5">
                                            <c:choose>
                                                <c:when test="${order.paymentMethod == 'vnpay'}">
                                                    <span
                                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold bg-pink-50 text-[#880e4f]">
                                                        VNPAY
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span
                                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold bg-orange-50 text-[#e65100]">
                                                        COD
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-3.5 text-sm font-semibold text-gray-900">
                                            <fmt:formatNumber value="${order.totalPrice}"
                                                              pattern="#,###" />
                                            VND
                                        </td>
                                        <td class="px-6 py-3.5">
                                            <c:choose>
                                                <c:when test="${order.status == 'pending'}">
                                                    <span
                                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-amber-50 text-[#FFA000] text-xs font-semibold">Pending Confirmation</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'confirmed'}">
                                                    <span
                                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-[#FDE8E9] text-[#C92127] text-xs font-semibold">Confirmed</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'shipping'}">
                                                    <span
                                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-indigo-50 text-[#134aa4] text-xs font-semibold">Shipping</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'completed'}">
                                                    <span
                                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-green-50 text-[#2E7D32] text-xs font-semibold">Completed</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'cancelled'}">
                                                        <c:choose>
                                                            <c:when
                                                                test="${order.paymentMethod == 'vnpay' && order.paymentStatus == 'pending_refund'}">
                                                            <span
                                                                class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-amber-100 text-amber-700 text-xs font-semibold">Refund Pending</span>
                                                            </c:when>
                                                            <c:when
                                                                test="${order.paymentMethod == 'vnpay' && order.paymentStatus == 'refunded'}">
                                                            <span
                                                                class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-blue-100 text-[#134aa4] text-xs font-semibold">Refunded</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                            <span
                                                                class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-red-50 text-[#D32F2F] text-xs font-semibold">Cancelled</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <span
                                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-red-50 text-[#D32F2F] text-xs font-semibold">Cancelled</span>
                                                    </c:otherwise>
                                                </c:choose>
                                        </td>
                                        <td class="px-6 py-3.5 text-right">
                                            <div class="flex items-center justify-end gap-2">

                                                <c:choose>
                                                    <c:when test="${order.status == 'pending'}">
                                                        <form
                                                            action="${pageContext.request.contextPath}/dashboard/customer-order"
                                                            method="POST" class="inline-block m-0">
                                                            <input type="hidden" name="action"
                                                                   value="updateStatus">
                                                            <input type="hidden" name="orderID"
                                                                   value="${order.orderID}">
                                                            <input type="hidden" name="cancelReason"
                                                                   class="cancelReasonInput" value="">
                                                            <select name="status"
                                                                    onchange="confirmStatusChange(this)"
                                                                    class="bg-white border border-gray-300 text-gray-700 rounded-lg text-xs focus:ring-[#C92127] focus:border-[#C92127] px-2 py-1 cursor-pointer">
                                                                <option value="" disabled selected>--
                                                                    Select
                                                                    --</option>
                                                                <option value="confirmed">Confirmed
                                                                </option>
                                                                <option value="cancelled">Cancelled
                                                                </option>
                                                            </select>
                                                        </form>
                                                    </c:when>

                                                    <c:when test="${order.status == 'confirmed'}">
                                                        <form
                                                            action="${pageContext.request.contextPath}/dashboard/customer-order"
                                                            method="POST" class="inline-block m-0">
                                                            <input type="hidden" name="action"
                                                                   value="updateStatus">
                                                            <input type="hidden" name="orderID"
                                                                   value="${order.orderID}">
                                                            <input type="hidden" name="cancelReason"
                                                                   class="cancelReasonInput" value="">
                                                            <select name="status"
                                                                    onchange="confirmStatusChange(this)"
                                                                    class="bg-white border border-gray-300 text-gray-700 rounded-lg text-xs focus:ring-[#C92127] focus:border-[#C92127] px-2 py-1 cursor-pointer">
                                                                <option value="" disabled selected>--
                                                                    Select
                                                                    --</option>
                                                                <option value="shipping">Shipping
                                                                </option>
                                                                <option value="cancelled">Cancelled
                                                                </option>
                                                            </select>
                                                        </form>
                                                    </c:when>

                                                    <c:when test="${order.status == 'shipping'}">
                                                        <form
                                                            action="${pageContext.request.contextPath}/dashboard/customer-order"
                                                            method="POST" class="inline-block m-0">
                                                            <input type="hidden" name="action"
                                                                   value="updateStatus">
                                                            <input type="hidden" name="orderID"
                                                                   value="${order.orderID}">
                                                            <input type="hidden" name="cancelReason"
                                                                   class="cancelReasonInput" value="">
                                                            <select name="status"
                                                                    onchange="confirmStatusChange(this)"
                                                                    class="bg-white border border-gray-300 text-gray-700 rounded-lg text-xs focus:ring-[#C92127] focus:border-[#C92127] px-2 py-1 cursor-pointer">
                                                                <option value="" disabled selected>-- Select --</option>
                                                                <option value="completed">Completed
                                                                </option>
                                                                <option value="cancelled">Cancelled
                                                                </option>
                                                            </select>
                                                        </form>
                                                    </c:when>
                                                </c:choose>


                                                <a href="${pageContext.request.contextPath}/dashboard/customer-order?action=view&orderID=${order.orderID}"
                                                   class="p-1.5 bg-white border border-gray-300 text-[#C92127] rounded-lg hover:bg-[#FDE8E9] transition-all inline-flex items-center active:scale-95"
                                                   title="View Details">
                                                    <span
                                                        class="material-symbols-outlined text-[18px]">visibility</span>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Phân trang -->
                    <div class="p-4 border-t border-[#D9D9DC] flex items-center justify-between">
                        <p class="text-sm text-gray-500">Trang ${currentPage} / ${totalPages}</p>
                        <div class="flex items-center gap-2">
                            <a href="${currentPage > 1 ? baseUrl.concat('&page=').concat(currentPage - 1) : '#'}"
                               class="p-2 rounded-lg border border-gray-300 text-gray-600 hover:bg-gray-100 ${currentPage <= 1 ? 'opacity-30 pointer-events-none' : ''}">
                                <span class="material-symbols-outlined text-[16px]">chevron_left</span>
                            </a>

                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span
                                            class="w-8 h-8 flex items-center justify-center rounded-lg bg-[#C92127] text-white text-xs font-semibold">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${baseUrl}&page=${i}"
                                           class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-gray-100 text-gray-600 text-xs">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <a href="${currentPage < totalPages ? baseUrl.concat('&page=').concat(currentPage + 1) : '#'}"
                               class="p-2 rounded-lg border border-gray-300 text-gray-600 hover:bg-gray-100 ${currentPage >= totalPages ? 'opacity-30 pointer-events-none' : ''}">
                                <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                            </a>
                        </div>
                    </div>

                </div>
            </div>

            <%@ include file="/views/layout/dashboard/footer.jsp" %>
        </main>

        <!-- Modal Confirm Action -->
        <div id="confirmModal"
             class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[100]">
            <div class="bg-white w-[450px] rounded-xl p-6 relative">
                <button type="button"
                        class="absolute top-3 right-4 text-2xl hover:text-gray-500 close-confirm">&times;</button>
                <h3 class="text-xl font-bold mb-4" id="confirmTitle">Confirm Action</h3>
                <p class="text-gray-600 mb-6" id="confirmMessage">Are you sure you want to continue?</p>
                <div class="flex justify-end gap-3">
                    <button type="button"
                            class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100 close-confirm">Cancel</button>
                    <button type="button" id="confirmAction"
                            class="px-4 py-2 bg-[#C92127] text-white rounded-lg hover:opacity-90">Confirm</button>
                </div>
            </div>
        </div>

        <!-- Modal Nhập lý do hủy đơn -->
        <div id="listCancelReasonModal"
             class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[200]">
            <div class="bg-white w-[460px] rounded-xl p-6 relative shadow-xl">
                <button type="button" onclick="closeListCancelModal()"
                        class="absolute top-3 right-4 text-2xl text-gray-400 hover:text-gray-600">&times;</button>
                <h3 class="text-lg font-bold text-[#D32F2F] mb-2">Cancel Order</h3>
                <p class="text-sm text-gray-500 mb-3">Please enter a reason for cancelling this order.</p>
                <div id="listCancelError"
                     class="hidden mb-3 px-3 py-2 bg-red-50 border border-red-300 rounded-lg text-sm text-[#D32F2F] flex items-center gap-2">
                    <span class="material-symbols-outlined text-[16px]">error</span>
                    <span id="listCancelErrorText"></span>
                </div>
                <textarea id="listCancelReasonText" rows="4" maxlength="50"
                          class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-300"
                          placeholder="Enter a cancellation reason (10–50 characters, including at least one letter)"></textarea>
                <div class="flex justify-end gap-3 mt-4">
                    <button type="button" onclick="closeListCancelModal()"
                            class="px-4 py-2 border border-gray-300 rounded-lg text-sm hover:bg-gray-100">Close</button>
                    <button type="button" onclick="submitListCancelForm()"
                            class="px-4 py-2 bg-[#D32F2F] text-white rounded-lg text-sm font-semibold hover:opacity-90">Confirm Cancellation</button>
                </div>
            </div>
        </div>

        <script>
            let confirmModal = null;
            let pendingAction = null;
            let activeSelect = null;
            let currentSelectElement = null;

            function initConfirmModal() {
                confirmModal = document.getElementById('confirmModal');
                document.querySelectorAll('.close-confirm').forEach(function (btn) {
                    btn.addEventListener('click', closeConfirmModal);
                });

                if (confirmModal) {
                    confirmModal.addEventListener('click', function (e) {
                        if (e.target === confirmModal) {
                            closeConfirmModal();
                        }
                    });
                }

                const confirmBtn = document.getElementById('confirmAction');
                if (confirmBtn) {
                    confirmBtn.addEventListener('click', executeAction);
                }
            }

            function openConfirmModal(title, message, selectElement, action) {
                document.getElementById('confirmTitle').textContent = title;
                document.getElementById('confirmMessage').textContent = message;
                pendingAction = action;
                activeSelect = selectElement;

                if (confirmModal) {
                    confirmModal.classList.remove('hidden');
                    confirmModal.classList.add('flex');
                }
            }

            function closeConfirmModal() {
                if (confirmModal) {
                    confirmModal.classList.add('hidden');
                    confirmModal.classList.remove('flex');
                }
                pendingAction = null;
                if (activeSelect) {
                    activeSelect.value = "";
                    activeSelect = null;
                }
            }

            function executeAction() {
                if (pendingAction) {
                    pendingAction();
                    if (confirmModal) {
                        confirmModal.classList.add('hidden');
                        confirmModal.classList.remove('flex');
                    }
                    pendingAction = null;
                    activeSelect = null;
                }
            }

            function confirmStatusChange(selectElement) {
                const selectedOption = selectElement.options[selectElement.selectedIndex];
                const nextStatusLabel = selectedOption.text.trim();
                const selectedValue = selectedOption.value;

                if (selectedValue === 'cancelled') {
                    currentSelectElement = selectElement;
                    const modal = document.getElementById('listCancelReasonModal');
                    if (modal) {
                        modal.classList.remove('hidden');
                        modal.classList.add('flex');
                    }
                    document.getElementById('listCancelReasonText').value = '';
                    document.getElementById('listCancelReasonText').focus();
                } else {
                    openConfirmModal(
                            'Update Status',
                            "Are you sure you want to change this order's status to \"" + nextStatusLabel + "\"?",
                            selectElement,
                            function () {
                                selectElement.form.submit();
                            }
                    );
                }
            }

            function showListCancelError(msg) {
                document.getElementById('listCancelErrorText').textContent = msg;
                document.getElementById('listCancelError').classList.remove('hidden');
            }

            function submitListCancelForm() {
                const reason = document.getElementById('listCancelReasonText').value.trim();
                if (reason.length === 0) {
                    showListCancelError('Please enter a cancellation reason!');
                    return;
                }
                if (reason.length < 10) {
                    showListCancelError('The cancellation reason must be at least 10 characters!');
                    return;
                }
                if (reason.length > 50) {
                    showListCancelError('The cancellation reason cannot exceed 50 characters!');
                    return;
                }
                const hasLetter = /[a-zA-ZÀ-ỹ]/.test(reason);
                if (!hasLetter) {
                    showListCancelError('The cancellation reason must contain at least one letter!');
                    return;
                }

                if (currentSelectElement && currentSelectElement.form) {
                    const cancelInput = currentSelectElement.form.querySelector('.cancelReasonInput');
                    if (cancelInput) {
                        cancelInput.value = reason;
                    }
                    const modal = document.getElementById('listCancelReasonModal');
                    if (modal) {
                        modal.classList.add('hidden');
                        modal.classList.remove('flex');
                    }
                    currentSelectElement.form.submit();
                }
            }

            function closeListCancelModal() {
                const modal = document.getElementById('listCancelReasonModal');
                if (modal) {
                    modal.classList.add('hidden');
                    modal.classList.remove('flex');
                }
                document.getElementById('listCancelError').classList.add('hidden');
                if (currentSelectElement) {
                    currentSelectElement.value = '';
                    currentSelectElement = null;
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                initConfirmModal();

                const cancelModal = document.getElementById('listCancelReasonModal');
                if (cancelModal) {
                    cancelModal.addEventListener('click', function (e) {
                        if (e.target === cancelModal) {
                            closeListCancelModal();
                        }
                    });
                }
            });
        </script>
    </body>

</html>

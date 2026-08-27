<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <%-- File này là trang chi tiết đơn hàng của staff/admin. Chức năng chính: - xem thông tin chi tiết đơn hàng
                của khách - xem sản phẩm đã đặt, tổng tiền, phương thức thanh toán - cập nhật trạng thái theo bước:
                pending -> confirmed -> shipping -> completed
                - hủy đơn với lý do
                - xác nhận refund nếu đơn COD đang chờ hoàn tiền

                Dữ liệu được gửi từ CustomerOrderController qua request attribute:
                - order
                - orderDetails
                --%>

                <head>
                    <meta charset="utf-8">
                    <meta content="width=device-width, initial-scale=1.0" name="viewport">
                    <title>Order Details - HeavenScape</title>
                    <link rel="icon" type="image/png"
                        href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
                    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                        rel="stylesheet">
                    <style>
                        body {
                            font-family: 'Inter', system-ui, sans-serif;
                            background-color: #F7F7F8;
                        }

                        .material-symbols-outlined {
                            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                        }

                        .stepper-line::before {
                            content: '';
                            position: absolute;
                            left: 15px;
                            top: 24px;
                            bottom: 0;
                            width: 2px;
                            background-color: #D9D9DC;
                        }

                        .stepper-line:last-child::before {
                            display: none;
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

                            <main class="flex-1 md:ml-64 min-h-screen">
                                <div class="p-6 max-w-[1280px] mx-auto space-y-6">

                                    <div class="mb-4">
                                        <a href="${pageContext.request.contextPath}/dashboard/customer-order"
                                            class="flex items-center gap-2 text-[#C92127] font-bold text-sm hover:underline">
                                            <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                                            Back to List
                                        </a>
                                    </div>

                                    <%-- Phần header: hiển thị mã đơn và status badge. Từ status này staff biết đơn hàng
                                        đang ở giai đoạn nào. --%>
                                        <div
                                            class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                                            <div>
                                                <div class="flex items-center gap-3">
                                                    <h1 class="text-3xl font-bold text-[#1B1B1B]">Order
                                                        #${order.orderCode}</h1>

                                                    <span class="px-3 py-1 rounded-full text-sm font-semibold
                                  <c:choose>
                                      <c:when test=" ${order.status=='pending' }">bg-[#fff3cd] text-[#e65c00]</c:when>
                                                        <c:when test="${order.status == 'confirmed'}">bg-[#FDE8E9]
                                                            text-[#C92127]</c:when>
                                                        <c:when test="${order.status == 'shipping'}">bg-[#e0e7ff]
                                                            text-[#134aa4]</c:when>
                                                        <c:when test="${order.status == 'completed'}">bg-[#d4edda]
                                                            text-[#2E7D32]</c:when>
                                                        <c:otherwise>bg-[#ffdad6] text-[#D32F2F]</c:otherwise>
                                                        </c:choose>">
                                                        <c:choose>
                                                            <c:when test="${order.status == 'pending'}">Pending
                                                                Confirmation</c:when>
                                                            <c:when test="${order.status == 'confirmed'}">Confirmed
                                                            </c:when>
                                                            <c:when test="${order.status == 'shipping'}">Start Shipping
                                                            </c:when>
                                                        <c:when test="${order.paymentStatus == 'refund_rejected'}">Refund Rejected
                                                        </c:when>
                                                        <c:when test="${order.status == 'completed'}">Completed
                                                            </c:when>
                                                            <c:otherwise>Cancelled</c:otherwise>
                                                        </c:choose>
                                                    </span>

                                                    <c:if
                                                        test="${order.status == 'cancelled' && order.paymentMethod == 'cod'}">
                                                        <c:choose>
                                                            <c:when test="${order.paymentStatus == 'pending_refund'}">
                                                                <span
                                                                    class="px-3 py-1 rounded-full text-sm font-semibold flex items-center gap-1 bg-amber-50 text-amber-600 border border-amber-200">
                                                                    <span
                                                                        class="material-symbols-outlined text-[14px]">schedule</span>
                                                                    Refund Processing
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.paymentStatus == 'refunded'}">
                                                                <span
                                                                    class="px-3 py-1 rounded-full text-sm font-semibold flex items-center gap-1 bg-green-50 text-green-700 border border-green-200">
                                                                    <span class="material-symbols-outlined text-[14px]"
                                                                        style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                                                    Refunded
                                                                </span>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <%-- Nếu đơn chưa hoàn thành và chưa hủy thì show các nút chuyển trạng thái.
                                                Ví dụ: pending -> confirmed, confirmed -> shipping, shipping ->
                                                completed.
                                                --%>
                                                <c:if
                                                    test="${order.status != 'completed' && order.status != 'cancelled'}">
                                                    <div class="flex items-center gap-3">
                                                        <form
                                                            action="${pageContext.request.contextPath}/dashboard/customer-order"
                                                            method="POST" class="m-0 inline-block" id="statusForm">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="orderID"
                                                                value="${order.orderID}">
                                                            <input type="hidden" name="redirect" value="detail">

                                                            <c:choose>
                                                                <c:when test="${order.status == 'pending'}">
                                                                    <input type="hidden" name="status"
                                                                        value="confirmed">
                                                                    <button type="button"
                                                                        onclick="confirmActionDetail('Confirm Order', 'Are you sure you want to confirm this order?', 'statusForm')"
                                                                        class="flex items-center gap-2 px-4 py-2 bg-[#C92127] text-white rounded-lg text-sm font-semibold hover:opacity-90 shadow-sm transition-all">
                                                                        <span
                                                                            class="material-symbols-outlined text-[20px]">task_alt</span>
                                                                        Confirm Order
                                                                    </button>
                                                                </c:when>
                                                                <c:when test="${order.status == 'confirmed'}">
                                                                    <input type="hidden" name="status" value="shipping">
                                                                    <button type="button"
                                                                        onclick="confirmActionDetail('Start Shipping', 'Are you sure you want to start shipping this order?', 'statusForm')"
                                                                        class="flex items-center gap-2 px-4 py-2 bg-[#134aa4] text-white rounded-lg text-sm font-semibold hover:opacity-90 shadow-sm transition-all">
                                                                        <span
                                                                            class="material-symbols-outlined text-[20px]">local_shipping</span>
                                                                        Start Shipping
                                                                    </button>
                                                                </c:when>
                                                                <c:when test="${order.status == 'shipping'}">
                                                                    <input type="hidden" name="status"
                                                                        value="completed">
                                                                    <button type="button"
                                                                        onclick="confirmActionDetail('Complete Order', 'Are you sure you want to complete this order?', 'statusForm')"
                                                                        class="flex items-center gap-2 px-4 py-2 bg-[#2E7D32] text-white rounded-lg text-sm font-semibold hover:opacity-90 shadow-sm transition-all">
                                                                        <span
                                                                            class="material-symbols-outlined text-[20px]">check_circle</span>
                                                                        Complete Order
                                                                    </button>
                                                                </c:when>
                                                            </c:choose>
                                                        </form>

                                                        <form
                                                            action="${pageContext.request.contextPath}/dashboard/customer-order"
                                                            method="POST" class="m-0 inline-block" id="cancelForm">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="orderID"
                                                                value="${order.orderID}">
                                                            <input type="hidden" name="redirect" value="detail">
                                                            <input type="hidden" name="status" value="cancelled">
                                                            <input type="hidden" name="cancelReason"
                                                                id="cancelReasonInput" value="">
                                                            <button type="button" onclick="openCancelModal()"
                                                                class="flex items-center gap-2 px-4 py-2 bg-[#D32F2F] text-white rounded-lg text-sm font-semibold hover:opacity-90 shadow-sm transition-all">
                                                                <span
                                                                    class="material-symbols-outlined text-[20px]">cancel</span>
                                                                Cancel Order
                                                            </button>
                                                        </form>
                                                    </div>
                                                </c:if>
                                        </div>

                                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

                                            <div class="lg:col-span-2 space-y-6">

                                                <%-- Bảng sản phẩm trong đơn: hiển thị từng item, giá, số lượng, thành
                                                    tiền. Đây là phần mà staff kiểm tra chính xác đơn hàng của khách.
                                                    --%>
                                                    <div
                                                        class="bg-white rounded-xl shadow-sm overflow-hidden border border-[#D9D9DC]">
                                                        <div
                                                            class="p-6 border-b border-[#D9D9DC] bg-[#F7F7F8] flex justify-between items-center">
                                                            <h2 class="text-xl font-semibold text-[#1B1B1B]">Product
                                                                List</h2>
                                                            <span class="text-[#5C5C5F] text-sm">${orderDetails.size()}
                                                                items</span>
                                                        </div>
                                                        <div class="overflow-x-auto">
                                                            <table class="w-full text-left">
                                                                <thead class="bg-[#F5F7F9]">
                                                                    <tr>
                                                                        <th
                                                                            class="px-6 py-4 text-sm font-semibold text-[#5C5C5F]">
                                                                            Product</th>
                                                                        <th
                                                                            class="px-6 py-4 text-sm font-semibold text-[#5C5C5F]">
                                                                            Price</th>
                                                                        <th
                                                                            class="px-6 py-4 text-sm font-semibold text-[#5C5C5F]">
                                                                            Quantity</th>
                                                                        <th
                                                                            class="px-6 py-4 text-sm font-semibold text-[#5C5C5F] text-right">
                                                                            Total</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody class="divide-y divide-[#D9D9DC]">
                                                                    <c:forEach var="item" items="${orderDetails}">
                                                                        <tr
                                                                            class="hover:bg-[#FDE8E9] transition-colors">
                                                                            <td class="px-6 py-4">
                                                                                <div class="flex items-center gap-4">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty item.thumbnail}">
                                                                                            <img alt="${item.title}"
                                                                                                class="w-12 h-16 object-cover rounded-md shadow-sm"
                                                                                                src="${item.thumbnailFirst}">
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <div
                                                                                                class="w-12 h-16 flex items-center justify-center bg-[#FDE8E9] rounded text-[#D9D9DC]">
                                                                                                <span
                                                                                                    class="material-symbols-outlined text-[24px]">book</span>
                                                                                            </div>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                    <div>
                                                                                        <p
                                                                                            class="text-sm font-semibold text-[#C92127]">
                                                                                            ${item.title}</p>
                                                                                    </div>
                                                                                </div>
                                                                            </td>
                                                                            <td
                                                                                class="px-6 py-4 text-base text-[#1B1B1B]">
                                                                                <fmt:formatNumber
                                                                                    value="${item.unitPrice}"
                                                                                    pattern="#,###" />VND
                                                                            </td>
                                                                            <td
                                                                                class="px-6 py-4 text-base text-[#1B1B1B]">
                                                                                ${item.quantity}</td>
                                                                            <td
                                                                                class="px-6 py-4 text-base text-right font-bold text-[#1B1B1B]">
                                                                                <fmt:formatNumber
                                                                                    value="${item.subtotal}"
                                                                                    pattern="#,###" />VND
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </div>

                                                        <c:set var="staffBookSubtotal" value="0" />
                                                        <c:set var="staffTotalBookCount" value="0" />
                                                        <c:forEach var="item" items="${orderDetails}">
                                                            <c:set var="staffBookSubtotal"
                                                                value="${staffBookSubtotal + item.subtotal}" />
                                                            <c:set var="staffTotalBookCount"
                                                                value="${staffTotalBookCount + item.quantity}" />
                                                        </c:forEach>

                                                        <div class="p-6 bg-[#F7F7F8] border-t border-[#D9D9DC]">
                                                            <div class="flex flex-col items-end gap-2 text-sm">
                                                                <div class="flex justify-between w-72 text-[#5C5C5F]">
                                                                    <span>Subtotal (${staffTotalBookCount}
                                                                        items):</span>
                                                                    <span class="font-semibold text-[#1B1B1B]">
                                                                        <fmt:formatNumber value="${staffBookSubtotal}"
                                                                            pattern="#,###" /> VND
                                                                    </span>
                                                                </div>
                                                                <c:if test="${staffBookSubtotal > order.totalPrice}">
                                                                    <div
                                                                        class="flex justify-between w-72 text-green-700 font-semibold">
                                                                        <span>Voucher Discount:</span>
                                                                        <span>-
                                                                            <fmt:formatNumber
                                                                                value="${staffBookSubtotal - order.totalPrice}"
                                                                                pattern="#,###" /> VND
                                                                        </span>
                                                                    </div>
                                                                </c:if>
                                                                <div
                                                                    class="flex justify-between w-72 pt-2 border-t border-[#D9D9DC]">
                                                                    <span class="text-lg font-bold text-[#1B1B1B]">Total
                                                                        Payment:</span>
                                                                    <span class="text-lg font-bold text-[#C92127]">
                                                                        <fmt:formatNumber value="${order.totalPrice}"
                                                                            pattern="#,###" /> VND
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <%-- Hai phần bên dưới: Payment Status và Shipping info. staff có
                                                        thể check xem đơn đã thanh toán chưa, phương thức thanh toán
                                                        nào, tiến độ giao hàng. --%>
                                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                                            <div
                                                                class="bg-white p-6 rounded-xl shadow-sm border border-[#D9D9DC]">
                                                                <div class="flex items-center gap-2 mb-4">
                                                                    <span
                                                                        class="material-symbols-outlined text-[#C92127]">payments</span>
                                                                    <h3
                                                                        class="text-sm font-semibold text-[#1B1B1B] uppercase tracking-wider">
                                                                        Payment Status</h3>
                                                                </div>
                                                                <div class="space-y-3">
                                                                    <div class="flex justify-between items-center">
                                                                        <span
                                                                            class="text-sm text-[#5C5C5F]">Method:</span>
                                                                        <span
                                                                            class="text-sm font-semibold text-[#1B1B1B]">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${order.paymentMethod == 'cod'}">
                                                                                    Cash on Delivery (COD)</c:when>
                                                                                <c:otherwise>Bank Transfer (VNPAY)
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </span>
                                                                    </div>
                                                                    <div class="flex justify-between items-center">
                                                                        <span
                                                                            class="text-sm text-[#5C5C5F]">Status:</span>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${order.paymentStatus == 'paid'}">
                                                                                <span
                                                                                    class="px-3 py-1 bg-green-100 text-[#2E7D32] rounded-full text-xs font-semibold">Paid</span>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${order.paymentStatus == 'pending_refund'}">
                                                                                <span
                                                                                    class="px-3 py-1 bg-amber-100 text-amber-700 rounded-full text-xs font-semibold">Refund
                                                                                    Pending</span>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${order.paymentStatus == 'refunded'}">
                                                                                <span
                                                                                    class="px-3 py-1 bg-blue-100 text-[#134aa4] rounded-full text-xs font-semibold">Refunded</span>
                                                                            </c:when>
                                                                            <c:when test="${order.paymentStatus == 'refund_rejected'}">
                                                                                <span class="px-3 py-1 bg-red-100 text-[#D32F2F] rounded-full text-xs font-semibold">Refund Rejected</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span
                                                                                    class="px-3 py-1 bg-amber-100 text-[#FFA000] rounded-full text-xs font-semibold">Unpaid</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div
                                                                class="bg-white p-6 rounded-xl shadow-sm border border-[#D9D9DC]">
                                                                <div class="flex items-center gap-2 mb-4">
                                                                    <span
                                                                        class="material-symbols-outlined text-[#C92127]">local_shipping</span>
                                                                    <h3
                                                                        class="text-sm font-semibold text-[#1B1B1B] uppercase tracking-wider">
                                                                        Shipping</h3>
                                                                </div>
                                                                <div class="space-y-3">
                                                                    <div class="flex justify-between items-center">
                                                                        <span class="text-sm text-[#5C5C5F]">Estimated
                                                                            Delivery:</span>
                                                                        <span class="text-sm text-[#1B1B1B]">1–3 days
                                                                            after confirmation</span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                            </div>

                                            <div class="space-y-6">

                                                <div class="bg-white p-6 rounded-xl shadow-sm border border-[#D9D9DC]">
                                                    <h3 class="text-xl font-semibold text-[#1B1B1B] mb-6">Recipient</h3>
                                                    <div class="mb-6">
                                                        <p class="text-sm font-semibold text-[#1B1B1B]">
                                                            ${order.recipientName}</p>
                                                    </div>
                                                    <div class="space-y-4">
                                                        <div class="flex items-start gap-3">
                                                            <span
                                                                class="material-symbols-outlined text-[#727783] text-[20px]">mail</span>
                                                            <div>
                                                                <p class="text-xs text-[#5C5C5F]">Email</p>
                                                                <p class="text-sm text-[#C92127]">${order.customerEmail}
                                                                </p>
                                                            </div>
                                                        </div>
                                                        <div class="flex items-start gap-3">
                                                            <span
                                                                class="material-symbols-outlined text-[#727783] text-[20px]">phone</span>
                                                            <div>
                                                                <p class="text-xs text-[#5C5C5F]">Phone Number</p>
                                                                <p class="text-sm text-[#1B1B1B]">
                                                                    ${order.recipientPhone}</p>
                                                            </div>
                                                        </div>
                                                        <div class="flex items-start gap-3">
                                                            <span
                                                                class="material-symbols-outlined text-[#727783] text-[20px]">location_on</span>
                                                            <div>
                                                                <p class="text-xs text-[#5C5C5F]">Shipping Address</p>
                                                                <p class="text-sm text-[#1B1B1B] leading-relaxed">
                                                                    ${order.street}, ${order.district}, ${order.city}
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="bg-white p-6 rounded-xl shadow-sm border border-[#D9D9DC]">
                                                    <h3 class="text-xl font-semibold text-[#1B1B1B] mb-6">Order Progress
                                                    </h3>
                                                    <div class="space-y-6">

                                                        <c:set var="currentStep" value="0" />
                                                        <c:if test="${order.status == 'pending'}">
                                                            <c:set var="currentStep" value="1" />
                                                        </c:if>
                                                        <c:if test="${order.status == 'confirmed'}">
                                                            <c:set var="currentStep" value="2" />
                                                        </c:if>
                                                        <c:if test="${order.status == 'shipping'}">
                                                            <c:set var="currentStep" value="3" />
                                                        </c:if>
                                                        <c:if test="${order.status == 'completed'}">
                                                            <c:set var="currentStep" value="4" />
                                                        </c:if>

                                                        <c:choose>
                                                            <c:when test="${order.status == 'cancelled'}">
                                                                <div
                                                                    class="mb-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-xs text-red-700">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${order.paymentStatus == 'refunded'}">
                                                                            <strong>Refund by:</strong> Staff
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <strong>Cancelled by:</strong>
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${not empty order.cancelledByName}">
                                                                                    <c:out
                                                                                        value="${order.cancelledByName}" />
                                                                                </c:when>
                                                                                <c:otherwise>Account unavailable
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${order.paymentMethod == 'cod' && order.paymentStatus == 'pending_refund'}">
                                                                        <div class="space-y-3">
                                                                            <div
                                                                                class="flex flex-col gap-2 p-4 bg-amber-50 rounded-lg border border-amber-200">
                                                                                <div class="flex items-center gap-3">
                                                                                    <span
                                                                                        class="material-symbols-outlined text-amber-500 text-[22px]"
                                                                                        style="font-variation-settings: 'FILL' 1;">schedule</span>
                                                                                    <div class="flex-1">
                                                                                        <p
                                                                                            class="text-sm font-semibold text-amber-700">
                                                                                            Order Cancelled &mdash;
                                                                                            Refund Processing</p>
                                                                                        <p
                                                                                            class="text-xs text-amber-600 mt-0.5">
                                                                                            COD — Transfer Not Yet
                                                                                            Confirmed</p>
                                                                                    </div>
                                                                                </div>
                                                                                <c:if
                                                                                    test="${not empty order.cancelReason}">
                                                                                    <p
                                                                                        class="text-xs text-amber-600 pl-8">
                                                                                        <strong>Cancellation
                                                                                            Reason:</strong>
                                                                                        <c:out
                                                                                            value="${order.cancelReason}" />
                                                                                    </p>
                                                                                </c:if>
                                                                                <div class="mt-3 grid gap-1 rounded-lg border border-amber-200 bg-white p-3 text-xs text-gray-700">
                                                                                    <p><strong>Bank:</strong> <c:out value="${order.refundBankName}" /></p>
                                                                                    <p><strong>Account Number:</strong> <c:out value="${order.refundAccountNumber}" /></p>
                                                                                    <p><strong>Account Holder:</strong> <c:out value="${order.refundAccountHolder}" /></p>
                                                                                    <p class="mt-1 text-amber-700">Verify these details before transferring the refund.</p>
                                                                                </div>
                                                                            </div>

                                                                            <div class="flex flex-col gap-3 mt-3">

                                                                                    <!-- CONFIRM REFUND -->
                                                                                    <form
                                                                                        action="${pageContext.request.contextPath}/dashboard/customer-order"
                                                                                        method="POST"
                                                                                        id="confirmRefundForm">

                                                                                        <input type="hidden"
                                                                                            name="action"
                                                                                            value="confirmRefund">
                                                                                        <input type="hidden"
                                                                                            name="orderID"
                                                                                            value="${order.orderID}">

                                                                                        <button type="button" onclick="confirmActionDetail(
                    'Confirm Refund',
                    'Do you confirm that the refund was successfully transferred? The customer will be notified by email.',
                    'confirmRefundForm'
                )" class="w-full flex items-center justify-center gap-2 px-4 py-2.5 bg-green-600 text-white rounded-lg text-sm font-semibold hover:bg-green-700 shadow-sm transition-all">

                                                                                            <span
                                                                                                class="material-symbols-outlined text-[18px]">
                                                                                                payments
                                                                                            </span>

                                                                                            Confirm Refund

                                                                                        </button>
                                                                                    </form>


                                                                                    <!-- REJECT REFUND -->
                                                                                    <form
                                                                                        action="${pageContext.request.contextPath}/dashboard/customer-order"
                                                                                        method="POST"
                                                                                        id="rejectRefundForm">

                                                                                        <input type="hidden"
                                                                                            name="action"
                                                                                            value="rejectRefund">

                                                                                        <input type="hidden"
                                                                                            name="orderID"
                                                                                            value="${order.orderID}">

                                                                                        <input type="hidden"
                                                                                            name="rejectReason"
                                                                                            id="rejectReasonInput"
                                                                                            value="">

                                                                                        <button type="button"
                                                                                            onclick="openRejectRefundModal()"
                                                                                            class="w-full flex items-center justify-center gap-2 px-4 py-2.5 bg-red-600 text-white rounded-lg text-sm font-semibold hover:bg-red-700 shadow-sm transition-all">

                                                                                            <span
                                                                                                class="material-symbols-outlined text-[18px]">
                                                                                                cancel
                                                                                            </span>

                                                                                            Reject Refund

                                                                                        </button>

                                                                                    </form>

                                                                            </div>
                                                                    </c:when>

                                                                    <c:when
                                                                        test="${order.paymentMethod == 'cod' && order.paymentStatus == 'refunded'}">
                                                                        <div
                                                                            class="flex flex-col gap-2 p-4 bg-green-50 rounded-lg border border-green-200">
                                                                            <div class="flex items-center gap-3">
                                                                                <span
                                                                                    class="material-symbols-outlined text-green-600 text-[22px]"
                                                                                    style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                                                                <div>
                                                                                    <p
                                                                                        class="text-sm font-semibold text-green-700">
                                                                                        Order Cancelled &mdash; Refunded
                                                                                    </p>
                                                                                    <p
                                                                                        class="text-xs text-green-600 mt-0.5">
                                                                                        COD — Transfer Confirmed</p>
                                                                                </div>
                                                                            </div>
                                                                            <c:if
                                                                                test="${not empty order.cancelReason}">
                                                                                <p class="text-xs text-green-600 pl-8">
                                                                                    <strong>Cancellation
                                                                                        Reason:</strong>
                                                                                    <c:out
                                                                                        value="${order.cancelReason}" />
                                                                                </p>
                                                                            </c:if>
                                                                        </div>
                                                                    </c:when>

                                                                    <c:otherwise>
                                                                        <div
                                                                            class="flex flex-col gap-2 p-4 bg-red-50 rounded-lg border border-red-200">
                                                                            <div class="flex items-center gap-3">
                                                                                <span
                                                                                    class="material-symbols-outlined text-[#D32F2F] text-[22px]">cancel</span>
                                                                                <p
                                                                                    class="text-sm font-semibold text-[#D32F2F]">
                                                                                    Order Cancelled</p>
                                                                            </div>
                                                                            <c:if
                                                                                test="${not empty order.cancelReason}">
                                                                                <p class="text-xs text-[#D32F2F] pl-8">
                                                                                    <strong>Cancellation
                                                                                        Reason:</strong>
                                                                                    <c:out
                                                                                        value="${order.cancelReason}" />
                                                                                </p>
                                                                            </c:if>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>

                                                            <c:otherwise>
                                                                <div class="relative pl-8 stepper-line">
                                                                    <div
                                                                        class="absolute left-0 top-0 w-8 h-8 flex items-center justify-center z-10">
                                                                        <div
                                                                            class="w-3 h-3 rounded-full ${currentStep >= 4 ? 'bg-[#2E7D32]' : 'bg-[#D9D9DC]'}">
                                                                        </div>
                                                                    </div>
                                                                    <p
                                                                        class="text-sm font-semibold ${currentStep >= 4 ? 'text-[#2E7D32]' : 'text-[#1B1B1B]'}">
                                                                        Completed</p>
                                                                </div>

                                                                <div class="relative pl-8 stepper-line">
                                                                    <div
                                                                        class="absolute left-0 top-0 w-8 h-8 flex items-center justify-center z-10">
                                                                        <div
                                                                            class="w-3 h-3 rounded-full ${currentStep >= 3 ? 'bg-[#134aa4]' : 'bg-[#D9D9DC]'}">
                                                                        </div>
                                                                    </div>
                                                                    <p
                                                                        class="text-sm font-semibold ${currentStep >= 3 ? 'text-[#134aa4]' : 'text-[#1B1B1B]'}">
                                                                        Shipping</p>
                                                                </div>

                                                                <div class="relative pl-8 stepper-line">
                                                                    <div
                                                                        class="absolute left-0 top-0 w-8 h-8 flex items-center justify-center z-10">
                                                                        <div
                                                                            class="w-3 h-3 rounded-full ${currentStep >= 2 ? 'bg-[#C92127]' : 'bg-[#D9D9DC]'}">
                                                                        </div>
                                                                    </div>
                                                                    <p
                                                                        class="text-sm font-semibold ${currentStep >= 2 ? 'text-[#C92127]' : 'text-[#1B1B1B]'}">
                                                                        Confirmed</p>
                                                                </div>

                                                                <div class="relative pl-8 stepper-line">
                                                                    <div
                                                                        class="absolute left-0 top-0 w-8 h-8 flex items-center justify-center z-10">
                                                                        <div
                                                                            class="w-3 h-3 rounded-full ${currentStep >= 1 ? 'bg-[#FFA000]' : 'bg-[#D9D9DC]'}">
                                                                        </div>
                                                                    </div>
                                                                    <p
                                                                        class="text-sm font-semibold ${currentStep >= 1 ? 'text-[#FFA000]' : 'text-[#1B1B1B]'}">
                                                                        Pending Confirmation</p>
                                                                    <p class="text-sm text-[#5C5C5F]">
                                                                        <fmt:formatDate value="${order.createdAt}"
                                                                            pattern="HH:mm - dd/MM/yyyy" />
                                                                    </p>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                </div>
                            </main>

                            <%-- Modal xác nhận hành động trước khi staff đổi trạng thái đơn. Người dùng sẽ thấy popup
                                confirm để tránh thao tác nhầm. --%>
                                <div id="confirmModal"
                                    class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[100]">
                                    <div class="bg-white w-[450px] rounded-xl p-6 relative">
                                        <button type="button"
                                            class="absolute top-3 right-4 text-2xl hover:text-gray-500 close-confirm">&times;</button>
                                        <h3 class="text-xl font-bold mb-4" id="confirmTitle">Confirm Action</h3>
                                        <p class="text-gray-600 mb-6" id="confirmMessage">Are you sure you want to
                                            continue?</p>
                                        <div class="flex justify-end gap-3">
                                            <button type="button"
                                                class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100 close-confirm">Cancel</button>
                                            <button type="button" id="confirmAction"
                                                class="px-4 py-2 bg-[#C92127] text-white rounded-lg hover:opacity-90">Confirm</button>
                                        </div>
                                    </div>
                                </div>

                                <%-- Modal nhập lý do hủy đơn. Đây là logic bắt buộc để đảm bảo staff phải ghi rõ lý do
                                    hủy trước khi cập nhật trạng thái cancelled. --%>
                                    <div id="cancelReasonModal"
                                        class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[200]">
                                        <div class="bg-white w-[460px] rounded-xl p-6 relative shadow-xl">
                                            <button type="button" onclick="closeCancelModal()"
                                                class="absolute top-3 right-4 text-2xl text-gray-400 hover:text-gray-600">&times;</button>
                                            <h3 class="text-lg font-bold text-[#D32F2F] mb-2">Cancel Order</h3>
                                            <p class="text-sm text-gray-500 mb-3">Please enter a reason for cancelling
                                                this order.</p>
                                            <div id="cancelReasonError"
                                                class="hidden mb-3 px-3 py-2 bg-red-50 border border-red-300 rounded-lg text-sm text-[#D32F2F] flex items-center gap-2">
                                                <span class="material-symbols-outlined text-[16px]">error</span>
                                                <span id="cancelReasonErrorText"></span>
                                            </div>
                                            <label for="cancelReasonText"
                                                class="mb-1 block text-sm font-semibold">Cancellation Reason <span
                                                    class="text-red-600 text-xs">*</span></label>
                                            <textarea id="cancelReasonText" rows="4" maxlength="50"
                                                class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-300"
                                                placeholder="Enter a cancellation reason (10–50 characters, including at least one letter)"></textarea>
                                            <div class="flex justify-end gap-3 mt-4">
                                                <button type="button" onclick="closeCancelModal()"
                                                    class="px-4 py-2 border border-gray-300 rounded-lg text-sm hover:bg-gray-100">Close</button>
                                                <button type="button" onclick="submitCancelForm()"
                                                    class="px-4 py-2 bg-[#D32F2F] text-white rounded-lg text-sm font-semibold hover:opacity-90">Confirm
                                                    Cancellation</button>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="rejectRefundModal"
                                        class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[200]">
                                        <div class="bg-white w-[460px] rounded-xl p-6 relative shadow-xl">
                                            <button type="button" onclick="closeRejectRefundModal()"
                                                class="absolute top-3 right-4 text-2xl text-gray-400 hover:text-gray-600">&times;</button>
                                            <h3 class="text-lg font-bold text-[#D32F2F] mb-2">Reject Refund</h3>
                                            <p class="text-sm text-gray-500 mb-3">Explain why this refund request is being rejected. The reason will be sent to the customer.</p>
                                            <div id="rejectRefundError"
                                                class="hidden mb-3 px-3 py-2 bg-red-50 border border-red-300 rounded-lg text-sm text-[#D32F2F]">
                                            </div>
                                            <label for="rejectRefundReasonText" class="mb-1 block text-sm font-semibold">
                                                Rejection Reason <span class="text-red-600 text-xs">*</span>
                                            </label>
                                            <textarea id="rejectRefundReasonText" rows="4" maxlength="50"
                                                class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-300"
                                                placeholder="Enter a rejection reason (10-50 characters)"></textarea>
                                            <div class="flex justify-end gap-3 mt-4">
                                                <button type="button" onclick="closeRejectRefundModal()"
                                                    class="px-4 py-2 border border-gray-300 rounded-lg text-sm hover:bg-gray-100">Close</button>
                                                <button type="button" onclick="submitRejectRefundForm()"
                                                    class="px-4 py-2 bg-[#D32F2F] text-white rounded-lg text-sm font-semibold hover:opacity-90">Reject Refund</button>
                                            </div>
                                        </div>
                                    </div>

                                    <script>
                                        // JS trong file này xử lý:
                                        // - modal confirm trước khi đổi trạng thái đơn
                                        // - modal nhập lý do hủy đơn
                                        // - validate lý do hủy (độ dài, có chữ cái, không rỗng)
                                        // - submit form sau khi xác nhận
                                        let confirmModal = null;
                                        let pendingAction = null;

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

                                            const confirmActionBtn = document.getElementById('confirmAction');
                                            if (confirmActionBtn) {
                                                confirmActionBtn.addEventListener('click', executeAction);
                                            }
                                        }

                                        function openConfirmModal(title, message, action) {
                                            document.getElementById('confirmTitle').textContent = title;
                                            document.getElementById('confirmMessage').textContent = message;
                                            pendingAction = action;

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
                                        }

                                        function executeAction() {
                                            if (pendingAction) {
                                                pendingAction();
                                                closeConfirmModal();
                                            }
                                        }

                                        function confirmActionDetail(title, message, formId) {
                                            openConfirmModal(title, message, function () {
                                                document.getElementById(formId).submit();
                                            });
                                        }

                                        function showCancelError(msg) {
                                            document.getElementById('cancelReasonErrorText').textContent = msg;
                                            document.getElementById('cancelReasonError').classList.remove('hidden');
                                        }

                                        function openCancelModal() {
                                            const modal = document.getElementById('cancelReasonModal');
                                            if (modal) {
                                                modal.classList.remove('hidden');
                                                modal.classList.add('flex');
                                            }
                                            document.getElementById('cancelReasonText').focus();
                                            document.getElementById('cancelReasonError').classList.add('hidden');
                                        }

                                        function closeCancelModal() {
                                            const modal = document.getElementById('cancelReasonModal');
                                            if (modal) {
                                                modal.classList.add('hidden');
                                                modal.classList.remove('flex');
                                            }
                                            document.getElementById('cancelReasonText').value = '';
                                            document.getElementById('cancelReasonError').classList.add('hidden');
                                        }

                                        function submitCancelForm() {
                                            const reason = document.getElementById('cancelReasonText').value.trim();
                                            if (reason.length === 0) {
                                                showCancelError('Please enter a cancellation reason!');
                                                return;
                                            }
                                            if (reason.length < 10) {
                                                showCancelError('The cancellation reason must be at least 10 characters!');
                                                return;
                                            }
                                            if (reason.length > 50) {
                                                showCancelError('The cancellation reason cannot exceed 50 characters!');
                                                return;
                                            }
                                            const hasLetter = /[a-zA-ZÀ-ỹ]/.test(reason);
                                            if (!hasLetter) {
                                                showCancelError('The cancellation reason must contain at least one letter!');
                                                return;
                                            }
                                            document.getElementById('cancelReasonInput').value = reason;
                                            document.getElementById('cancelForm').submit();
                                        }

                                        function openRejectRefundModal() {
                                            const modal = document.getElementById('rejectRefundModal');
                                            const reason = document.getElementById('rejectRefundReasonText');
                                            document.getElementById('rejectRefundError').classList.add('hidden');
                                            reason.value = '';
                                            modal.classList.remove('hidden');
                                            modal.classList.add('flex');
                                            window.setTimeout(function () { reason.focus(); }, 0);
                                        }

                                        function closeRejectRefundModal() {
                                            const modal = document.getElementById('rejectRefundModal');
                                            modal.classList.add('hidden');
                                            modal.classList.remove('flex');
                                        }

                                        function submitRejectRefundForm() {
                                            const reason = document.getElementById('rejectRefundReasonText').value.trim();
                                            const error = document.getElementById('rejectRefundError');
                                            if (reason.length < 10 || reason.length > 50 || !/\p{L}/u.test(reason)) {
                                                error.textContent = 'The rejection reason must be 10-50 characters long and contain at least one letter.';
                                                error.classList.remove('hidden');
                                                return;
                                            }
                                            document.getElementById('rejectReasonInput').value = reason;
                                            document.getElementById('rejectRefundForm').submit();
                                        }

                                        document.addEventListener('DOMContentLoaded', function () {
                                            initConfirmModal();

                                            const cancelModal = document.getElementById('cancelReasonModal');
                                            if (cancelModal) {
                                                cancelModal.addEventListener('click', function (e) {
                                                    if (e.target === cancelModal) {
                                                        closeCancelModal();
                                                    }
                                                });
                                            }

                                            const rejectModal = document.getElementById('rejectRefundModal');
                                            if (rejectModal) {
                                                rejectModal.addEventListener('click', function (e) {
                                                    if (e.target === rejectModal) {
                                                        closeRejectRefundModal();
                                                    }
                                                });
                                            }
                                        });
                                    </script>
                </body>

            </html>

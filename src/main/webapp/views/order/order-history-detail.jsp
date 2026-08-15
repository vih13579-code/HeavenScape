<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<!DOCTYPE html>
<html lang="en" class="light">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Order Details ${order.orderCode} - HeavenScape</title>
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
            rel="stylesheet" />
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                display: inline-block;
                vertical-align: middle;
            }

            body {
                background-color: #f3faff;
            }
        </style>
    </head>

    <body class="text-[#071e27] antialiased bg-[#f3faff]">
        <%@ include file="/views/layout/common/toast.jsp" %>
        <main class="max-w-[1280px] mx-auto px-4 md:px-16 py-12">

            <div
                class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
                <div>
                    <nav class="flex items-center gap-2 mb-2">
                        <a class="text-xs font-medium text-[#424752] hover:text-[#004d99] transition-colors"
                           href="${pageContext.request.contextPath}/profile/order-history">
                            My Orders
                        </a>
                        <span
                            class="material-symbols-outlined text-xs text-[#727783]">chevron_right</span>
                        <span class="text-xs text-[#004d99] font-bold">Order Details</span>
                    </nav>

                    <div class="flex flex-wrap items-center gap-3">
                        <h1 class="text-2xl font-bold text-[#071e27]">Order ${order.orderCode}</h1>

                        <span class="px-3 py-1 font-bold text-xs rounded-full flex items-center
                              <c:choose>
                                  <c:when test=" ${order.status=='pending' }">bg-yellow-50 text-[#e65c00]</c:when>
                                  <c:when test="${order.status == 'confirmed'}">bg-blue-50 text-[#004d99]</c:when>
                                  <c:when test="${order.status == 'shipping'}">bg-indigo-50 text-[#134aa4]</c:when>
                                  <c:when test="${order.status == 'completed'}">bg-green-50 text-[#2E7D32]</c:when>
                                  <c:otherwise>bg-red-50 text-[#D32F2F]</c:otherwise>
                              </c:choose>">

                            <c:choose>
                                <c:when test="${order.status == 'pending'}">Pending Confirmation</c:when>
                                <c:when test="${order.status == 'confirmed'}">Confirmed</c:when>
                                <c:when test="${order.status == 'shipping'}">Shipping</c:when>
                                <c:when test="${order.status == 'completed'}">Completed</c:when>
                                <c:when test="${order.status == 'cancelled'}">Cancelled</c:when>
                                <c:otherwise>${order.status}</c:otherwise>
                            </c:choose>
                        </span>

                        <c:if test="${order.status == 'cancelled' && order.paymentMethod == 'vnpay'}">
                            <c:choose>
                                <c:when test="${order.paymentStatus == 'pending_refund'}">
                                    <span
                                        class="px-3 py-1 font-bold text-xs rounded-full flex items-center gap-1 bg-amber-50 text-amber-600 border border-amber-200">
                                        <span
                                            class="material-symbols-outlined text-[12px]">schedule</span>
                                        Refund Processing
                                    </span>
                                </c:when>
                                
                                <c:when test="${order.paymentStatus == 'refunded'}">
                                    <span
                                        class="px-3 py-1 font-bold text-xs rounded-full flex items-center gap-1 bg-green-50 text-green-700 border border-green-200">
                                        <span class="material-symbols-outlined text-[12px]"
                                              style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                        Refunded
                                    </span>
                                </c:when>
                            </c:choose>
                        </c:if>
                    </div>

                    <p class="text-xs text-[#424752] mt-1.5">
                        Order Date:
                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy • HH:mm" />
                    </p>
                </div>

                <div class="flex gap-3 w-full md:w-auto">
                    <c:if test="${order.status == 'pending'}">
                        <form id="cancelOrderForm" method="POST"
                              action="${pageContext.request.contextPath}/profile/order-history">
                            <input type="hidden" name="action" value="cancel" />
                            <input type="hidden" name="orderID" value="${order.orderID}" />
                            <input type="hidden" name="cancelReason" id="customerCancelReasonInput"
                                   value="" />
                            <button type="button" onclick="openCustomerCancelModal()"
                                    class="flex-1 md:flex-none px-5 py-2 bg-white border border-[#D32F2F] text-[#D32F2F] font-semibold text-sm rounded-lg hover:bg-red-50 transition-colors">
                                Cancel Order
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                <div class="lg:col-span-8 space-y-6">

                    <c:set var="step" value="1" />
                    <c:if test="${order.status == 'confirmed'}">
                        <c:set var="step" value="2" />
                    </c:if>
                    <c:if test="${order.status == 'shipping'}">
                        <c:set var="step" value="3" />
                    </c:if>
                    <c:if test="${order.status == 'completed'}">
                        <c:set var="step" value="4" />
                    </c:if>

                    <c:choose>
                        <c:when test="${order.status == 'cancelled'}">
                            <c:choose>

                                <c:when
                                    test="${order.paymentMethod == 'vnpay' && (order.paymentStatus == 'pending_refund' || order.paymentStatus == 'refunded')}">
                                    <c:set var="refStep" value="3" />
                                    <c:if test="${order.paymentStatus == 'refunded'}">
                                        <c:set var="refStep" value="4" />
                                    </c:if>

                                    <section
                                        class="bg-white p-6 rounded-xl border border-[#c2c6d4] shadow-sm">
                                        <h2 class="text-lg font-bold text-[#071e27] mb-6">
                                            Order &amp; Refund Status</h2>

                                        <div class="relative flex justify-between items-start">
                                            <div
                                                class="absolute top-5 left-0 w-full h-1 bg-gray-200 z-0 rounded-full">
                                                <div class="h-full rounded-full transition-all"
                                                     style="width: ${(refStep - 1) * 100 / 3}%; background: ${refStep >= 4 ? '#2E7D32' : (refStep >= 3 ? '#e65c00' : '#004d99')};">
                                                </div>
                                            </div>

                                            <div
                                                class="relative z-10 flex flex-col items-center text-center">
                                                <div
                                                    class="w-10 h-10 rounded-full bg-[#004d99] text-white flex items-center justify-center mb-2 shadow-sm">
                                                    <span
                                                        class="material-symbols-outlined text-[22px]"
                                                        style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                                </div>
                                                <span
                                                    class="text-xs font-bold text-[#004d99]">Order Placed</span>
                                                <span class="text-[11px] text-[#424752] mt-0.5">
                                                    <fmt:formatDate value="${order.createdAt}"
                                                                    pattern="dd/MM/yyyy" />
                                                </span>
                                            </div>

                                            <div
                                                class="relative z-10 flex flex-col items-center text-center">
                                                <div
                                                    class="w-10 h-10 rounded-full bg-red-100 text-[#D32F2F] border-2 border-[#D32F2F] flex items-center justify-center mb-2 shadow-sm">
                                                    <span
                                                        class="material-symbols-outlined text-[22px]"
                                                        style="font-variation-settings: 'FILL' 1;">cancel</span>
                                                </div>
                                                <span
                                                    class="text-xs font-bold text-[#D32F2F]">Cancelled</span>
                                            </div>

                                            <div
                                                class="relative z-10 flex flex-col items-center text-center ${refStep < 3 ? 'opacity-40' : ''}">
                                                <div
                                                    class="w-10 h-10 rounded-full flex items-center justify-center mb-2 shadow-sm ${refStep >= 4 ? 'bg-[#2E7D32] text-white' : (refStep == 3 ? 'bg-amber-50 text-amber-600 border-2 border-amber-500' : 'bg-gray-100 text-gray-400 border border-gray-200')}">
                                                    <span
                                                        class="material-symbols-outlined text-[22px]"
                                                        style="font-variation-settings: 'FILL' ${refStep >= 4 ? '1' : '0'};">
                                                        <c:choose>
                                                            <c:when test="${refStep >= 4}">
                                                                check_circle</c:when>
                                                            <c:otherwise>schedule</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                                <span
                                                    class="text-xs font-bold ${refStep == 3 ? 'text-amber-600' : (refStep >= 4 ? 'text-[#2E7D32]' : 'text-[#071e27]')}">Refund Pending</span>
                                                <c:if test="${refStep == 3}"><span
                                                        class="text-[10px] text-amber-500 mt-0.5">2–5 business days</span></c:if>
                                                </div>

                                                <div
                                                    class="relative z-10 flex flex-col items-center text-center ${refStep < 4 ? 'opacity-40' : ''}">
                                                <div
                                                    class="w-10 h-10 rounded-full flex items-center justify-center mb-2 shadow-sm ${refStep >= 4 ? 'bg-[#2E7D32] text-white' : 'bg-gray-100 text-gray-400 border border-gray-200'}">
                                                    <span
                                                        class="material-symbols-outlined text-[22px]"
                                                        style="font-variation-settings: 'FILL' ${refStep >= 4 ? '1' : '0'};">payments</span>
                                                </div>
                                                <span
                                                    class="text-xs font-bold ${refStep >= 4 ? 'text-[#2E7D32]' : 'text-[#071e27]'}">Refunded</span>
                                                <c:if test="${refStep >= 4}"><span
                                                        class="text-[10px] text-green-600 mt-0.5">Completed</span></c:if>
                                                </div>
                                            </div>

                                        <c:if test="${not empty order.cancelReason}">
                                            <div
                                                class="mt-6 p-3 bg-red-50 border border-red-200 rounded-lg text-xs text-[#D32F2F] flex items-start gap-2">
                                                <span
                                                    class="material-symbols-outlined text-[16px] mt-0.5">info</span>
                                                <span><strong>Cancellation Reason:</strong>
                                                    ${order.cancelReason}</span>
                                            </div>
                                        </c:if>

                                        <div class="mt-6 pt-4 border-t border-[#c2c6d4]">
                                            <c:choose>
                                                <c:when
                                                    test="${order.paymentStatus == 'pending_refund'}">
                                                    <div
                                                        class="text-xs text-amber-600 flex items-start gap-2">
                                                        <span
                                                            class="material-symbols-outlined text-[16px] mt-0.5 flex-shrink-0">info</span>
                                                        <div>
                                                            The amount <strong>
                                                                <fmt:formatNumber
                                                                    value="${order.totalPrice}"
                                                                    type="number"
                                                                    groupingUsed="true" /> VND
                                                            </strong> will be refunded to your VNPAY account within <strong>2–5 business days</strong>.<br>
                                                            You will receive a confirmation email when the refund is complete.
                                                        </div>
                                                    </div>
                                                </c:when>
                                                
                                                <c:otherwise>
                                                    <div
                                                        class="text-xs text-green-700 flex items-start gap-2">
                                                        <span
                                                            class="material-symbols-outlined text-[16px] mt-0.5 flex-shrink-0">check_circle</span>
                                                        <div>
                                                            The amount <strong>
                                                                <fmt:formatNumber
                                                                    value="${order.totalPrice}"
                                                                    type="number"
                                                                    groupingUsed="true" /> VND
                                                            </strong> has been refunded to your account.<br>
                                                            Please check your confirmation email for more details.
                                                        </div>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </section>
                                </c:when>

                                <c:otherwise>
                                    <section
                                        class="bg-red-50 border border-red-200 rounded-xl p-6 flex flex-col gap-2">
                                        <div class="flex items-center gap-3">
                                            <span
                                                class="material-symbols-outlined text-red-500">cancel</span>
                                            <p class="text-sm font-semibold text-red-700">
                                                This order was cancelled.</p>
                                        </div>
                                        <c:if test="${not empty order.cancelReason}">
                                            <p class="text-xs text-red-600 pl-8">
                                                <strong>Cancellation Reason:</strong>
                                                ${order.cancelReason}
                                            </p>
                                        </c:if>
                                    </section>
                                </c:otherwise>
                            </c:choose>
                        </c:when>

                        <c:otherwise>
                            <section
                                class="bg-white p-6 rounded-xl border border-[#c2c6d4] shadow-sm">
                                <h2 class="text-lg font-bold text-[#071e27] mb-6">
                                    Shipping Status</h2>

                                <div class="relative flex justify-between items-start">
                                    <div
                                        class="absolute top-5 left-0 w-full h-1 bg-gray-200 z-0 rounded-full">
                                        <div class="h-full bg-[#004d99] rounded-full transition-all"
                                             style="width: ${(step - 1) * 100 / 3}%;"></div>
                                    </div>

                                    <div
                                        class="relative z-10 flex flex-col items-center text-center">
                                        <div
                                            class="w-10 h-10 rounded-full bg-[#004d99] text-white flex items-center justify-center mb-2 shadow-sm">
                                            <span class="material-symbols-outlined text-[22px]"
                                                  style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                        </div>
                                        <span class="text-xs font-bold text-[#004d99]">Order Placed</span>
                                        <span class="text-[11px] text-[#424752] mt-0.5">
                                            <fmt:formatDate value="${order.createdAt}"
                                                            pattern="dd/MM/yyyy" />
                                        </span>
                                    </div>

                                    <div
                                        class="relative z-10 flex flex-col items-center text-center ${step < 2 ? 'opacity-40' : ''}">
                                        <div
                                            class="w-10 h-10 rounded-full flex items-center justify-center mb-2 shadow-sm ${step > 2 ? 'bg-[#004d99] text-white' : (step == 2 ? 'bg-[#e6f6ff] text-[#004d99] border-2 border-[#004d99]' : 'bg-gray-100 text-gray-500 border border-gray-200')}">
                                            <span class="material-symbols-outlined text-[22px]">
                                                <c:choose>
                                                    <c:when test="${step > 2}">check_circle
                                                    </c:when>
                                                    <c:otherwise>pending</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <span class="text-xs font-bold text-[#071e27]">Confirmed</span>
                                    </div>

                                    <div
                                        class="relative z-10 flex flex-col items-center text-center ${step < 3 ? 'opacity-40' : ''}">
                                        <div
                                            class="w-10 h-10 rounded-full flex items-center justify-center mb-2 shadow-sm ${step > 3 ? 'bg-[#004d99] text-white' : (step == 3 ? 'bg-[#e6f6ff] text-[#004d99] border-2 border-[#004d99]' : 'bg-gray-100 text-gray-500 border border-gray-200')}">
                                            <span
                                                class="material-symbols-outlined text-[22px]">local_shipping</span>
                                        </div>
                                        <span class="text-xs font-semibold text-[#071e27]">Shipping</span>
                                    </div>

                                    <div
                                        class="relative z-10 flex flex-col items-center text-center ${step < 4 ? 'opacity-40' : ''}">
                                        <div
                                            class="w-10 h-10 rounded-full flex items-center justify-center mb-2 shadow-sm ${step == 4 ? 'bg-[#004d99] text-white' : 'bg-gray-100 text-gray-500 border border-gray-200'}">
                                            <span
                                                class="material-symbols-outlined text-[22px]">package_2</span>
                                        </div>
                                        <span class="text-xs font-semibold text-[#071e27]">Delivered</span>
                                    </div>
                                </div>
                            </section>
                        </c:otherwise>
                    </c:choose>


                    <section
                        class="bg-white rounded-xl border border-[#c2c6d4] shadow-sm overflow-hidden">
                        <div class="p-5 border-b border-[#c2c6d4] bg-[#F5F7F9]">
                            <h2 class="text-base font-bold text-[#071e27]">Items in This Order (${orderDetails.size()})</h2>
                        </div>
                        <div class="divide-y divide-[#c2c6d4]">
                            <c:forEach var="item" items="${orderDetails}">
                                <div class="p-5 flex gap-5 hover:bg-[#F5F7F9] transition-colors group">
                                    <div
                                        class="w-20 h-28 bg-gray-100 rounded-lg overflow-hidden border border-gray-200 shadow-sm flex-shrink-0">
                                        <c:choose>
                                            <c:when test="${not empty item.thumbnail}">
                                                <img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                                                     alt="${item.title}" src="${item.thumbnailFirst}" />
                                            </c:when>
                                            <c:otherwise>
                                                <div
                                                    class="w-full h-full flex items-center justify-center text-gray-300">
                                                    <span
                                                        class="material-symbols-outlined text-3xl">menu_book</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="flex-1 flex flex-col justify-between">
                                        <div class="flex justify-between items-start gap-4">
                                            <div>
                                                <h3
                                                    class="font-bold text-[#071e27] text-base group-hover:text-[#004d99] transition-colors">
                                                    ${item.title}</h3>
                                                <p class="text-xs font-medium text-gray-500 mt-2">
                                                    Quantity: ${item.quantity}</p>
                                                <p class="text-xs text-[#424752] mt-0.5">
                                                    Unit Price:
                                                    <fmt:formatNumber value="${item.unitPrice}"
                                                                      type="number" groupingUsed="true" /> VND
                                                </p>
                                            </div>
                                            <p class="font-bold text-[#004d99] text-base">
                                                <fmt:formatNumber value="${item.subtotal}" type="number"
                                                                  groupingUsed="true" /> VND
                                            </p>
                                        </div>
                                        <div class="mt-3 flex items-center gap-3 text-xs">
                                            <a href="${pageContext.request.contextPath}/products?id=${item.bookID}"
                                               class="text-[#004d99] font-semibold hover:underline">
                                                View Details</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                </div>

                <div class="lg:col-span-4 space-y-6">

                    <section class="bg-white p-5 rounded-xl border border-[#c2c6d4] shadow-sm">
                        <div class="flex justify-between items-center mb-4">
                            <h2 class="text-xs font-bold uppercase tracking-wider text-[#424752]">
                                Delivery Address</h2>
                            <span
                                class="material-symbols-outlined text-[#004d99] text-[20px]">location_on</span>
                        </div>
                        <div class="space-y-1 text-sm">
                            <p class="font-bold text-[#071e27]">${order.recipientName}</p>
                            <p class="text-xs text-[#424752]">${order.recipientPhone}</p>
                            <p class="text-xs text-[#424752] leading-relaxed">${order.street},
                                ${order.district}, ${order.city}</p>
                        </div>
                    </section>

                    <section class="bg-white p-5 rounded-xl border border-[#c2c6d4] shadow-sm">
                        <div class="flex justify-between items-center mb-4">
                            <h2 class="text-xs font-bold uppercase tracking-wider text-[#424752]">
                                Payment</h2>
                            <span
                                class="material-symbols-outlined text-[#004d99] text-[20px]">payments</span>
                        </div>

                        <div
                            class="flex items-center gap-3 mb-5 p-3 bg-[#e6f6ff] rounded-lg border border-[#c2c6d4]">
                            <div
                                class="bg-white px-1.5 py-0.5 rounded border border-gray-200 shadow-sm flex items-center justify-center">
                                <span class="material-symbols-outlined text-[16px] text-[#424752]">
                                    <c:choose>
                                        <c:when test="${order.paymentMethod == 'cod'}">payments</c:when>
                                        <c:otherwise>credit_card</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            
                            <div>
                                <p class="text-xs font-bold text-[#071e27]">
                                    <c:choose>
                                        <c:when test="${order.paymentMethod == 'cod'}">Cash on Delivery (COD)</c:when>
                                        <c:otherwise>Bank Transfer (VNPAY)</c:otherwise>
                                    </c:choose>
                                </p>
                                
                                <p class="text-[11px] text-[#424752] mt-0.5">
                                    <c:choose>
                                        <c:when test="${order.paymentStatus == 'paid'}">Paid
                                        </c:when>
                                        
                                        <c:when test="${order.paymentStatus == 'pending_refund'}"><span
                                                class="text-amber-600 font-semibold">Refund Pending</span></c:when>
                                        
                                        <c:when test="${order.paymentStatus == 'refunded'}"><span
                                                class="text-green-700 font-semibold">Refunded</span>
                                        </c:when>
                                        
                                        <c:otherwise>Unpaid</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>

                        <c:set var="bookSubtotal" value="0" />
                        <c:set var="totalBookCount" value="0" />
                        <c:forEach var="item" items="${orderDetails}">
                            <c:set var="bookSubtotal" value="${bookSubtotal + item.subtotal}" />
                            <c:set var="totalBookCount" value="${totalBookCount + item.quantity}" />
                        </c:forEach>

                        <div class="space-y-2.5 text-xs">
                            <div class="flex justify-between items-center text-[#424752]">
                                <span>Subtotal (${totalBookCount} items)</span>
                                <span class="font-semibold text-[#071e27]">
                                    <fmt:formatNumber value="${bookSubtotal}" type="number"
                                                      groupingUsed="true" /> VND
                                </span>
                            </div>

                            <c:if test="${bookSubtotal > order.totalPrice}">
                                <div
                                    class="flex justify-between items-center text-green-700 font-semibold">
                                    <span>Voucher Discount</span>
                                    <span>-
                                        <fmt:formatNumber value="${bookSubtotal - order.totalPrice}"
                                                          type="number" groupingUsed="true" /> VND
                                    </span>
                                </div>
                            </c:if>

                            <div
                                class="pt-3 border-t border-[#c2c6d4] flex justify-between items-baseline">
                                <span class="text-sm font-bold text-[#071e27]">Total Payment</span>
                                <span class="text-lg font-bold text-[#004d99]">
                                    <fmt:formatNumber value="${order.totalPrice}" type="number"
                                                      groupingUsed="true" /> VND
                                </span>
                            </div>
                        </div>
                    </section>

                </div>
            </div>
        </main>

        <!-- Modal nhập lý do hủy đơn -->
        <div id="customerCancelModal"
             class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[200]">
            <div class="bg-white w-[460px] rounded-xl p-6 relative shadow-xl">
                <button type="button" onclick="closeCustomerCancelModal()"
                        class="absolute top-3 right-4 text-2xl text-gray-400 hover:text-gray-600">&times;</button>
                <h3 class="text-lg font-bold text-[#D32F2F] mb-2">Cancel Order</h3>
                <p class="text-sm text-gray-500 mb-3">Please enter the reason you want to cancel this order.</p>

                <div id="cancelModalError"
                     class="hidden mb-3 px-3 py-2 bg-red-50 border border-red-300 text-red-600 text-sm rounded-lg">
                </div>

                <textarea id="customerCancelReasonText" rows="4" maxlength="50"
                          class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-300"
                          placeholder="Enter a cancellation reason (10–50 characters, including at least one letter)"></textarea>

                <div class="flex justify-end gap-3 mt-4">
                    <button type="button" onclick="closeCustomerCancelModal()"
                            class="px-4 py-2 border border-gray-300 rounded-lg text-sm hover:bg-gray-100">
                        Close
                    </button>
                    <button type="button" onclick="submitCustomerCancelForm()"
                            class="px-4 py-2 bg-[#D32F2F] text-white rounded-lg text-sm font-semibold hover:opacity-90">
                        Confirm Cancellation
                    </button>
                </div>
            </div>
        </div>

        <script>
            function openCustomerCancelModal() {
                const modal = document.getElementById('customerCancelModal');
                const errEl = document.getElementById('cancelModalError');
                if (modal) {
                    modal.classList.remove('hidden');
                    modal.classList.add('flex');
                }
                document.getElementById('customerCancelReasonText').value = '';
                document.getElementById('customerCancelReasonText').focus();
                if (errEl) {
                    errEl.textContent = '';
                    errEl.classList.add('hidden');
                }
            }

            function showCancelModalError(message) {
                const errEl = document.getElementById('cancelModalError');
                if (errEl) {
                    errEl.textContent = message;
                    errEl.classList.remove('hidden');
                }
            }

            function closeCustomerCancelModal() {
                const modal = document.getElementById('customerCancelModal');
                if (modal) {
                    modal.classList.add('hidden');
                    modal.classList.remove('flex');
                }
            }

            function submitCustomerCancelForm() {
                const reason = document.getElementById('customerCancelReasonText').value.trim();
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
                document.getElementById('customerCancelReasonInput').value = reason;
                document.getElementById('cancelOrderForm').submit();
            }

            document.addEventListener('DOMContentLoaded', function () {
                const modal = document.getElementById('customerCancelModal');
                if (modal) {
                    modal.addEventListener('click', function (e) {
                        if (e.target === modal) {
                            closeCustomerCancelModal();
                        }
                    });
                }
            });
        </script>
    </body>

</html>
<%@ include file="/views/layout/homepage/footer.jsp" %>

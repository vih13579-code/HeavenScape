<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Order Placed Successfully - HeavenScape</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
              rel="stylesheet">
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
            rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
            }

            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 48;
            }

            .success-checkmark-animation {
                animation: scaleIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275) both;
            }

            @keyframes scaleIn {
                from {
                    transform: scale(0);
                    opacity: 0;
                }

                to {
                    transform: scale(1);
                    opacity: 1;
                }
            }
        </style>
    </head>

    <body class="bg-[#F5F7F9] text-[#1B1B1B] min-h-screen flex flex-col">
        <%@ include file="/views/layout/homepage/header.jsp" %>
        <%@ include file="/views/layout/common/toast.jsp" %>

        <main class="flex-grow pt-32 pb-12 px-4 md:px-16 max-w-[1280px] mx-auto w-full">
            <div class="max-w-2xl mx-auto flex flex-col items-center text-center">

                <div class="success-checkmark-animation bg-green-100 rounded-full p-6 mb-6">
                    <span class="material-symbols-outlined text-[70px] text-[#2E7D32] leading-none"
                          style="font-variation-settings: 'FILL' 1;">check_circle</span>
                </div>

                <h1 class="text-3xl md:text-4xl font-bold text-[#C92127] mb-3">
                    Order Placed Successfully!
                </h1>
                <p class="text-base text-gray-600 max-w-lg mb-8">
                    Thank you for shopping at HeavenScape. Your order code is
                    <span class="font-bold text-[#1B1B1B]">${order.orderCode}</span>. We will contact you soon to confirm your order.
                </p>

                <div
                    class="w-full bg-white border border-gray-200 rounded-2xl p-6 mb-8 shadow-sm text-left">
                    <h3 class="text-lg font-bold text-[#1B1B1B] mb-4 border-b border-gray-100 pb-3">
                        Order Summary
                    </h3>
                    <div class="space-y-3 text-sm">
                        <div class="flex justify-between items-center">
                            <span class="text-gray-500">Order Code</span>
                            <span class="font-bold text-[#1B1B1B]">${order.orderCode}</span>
                        </div>

                        <div class="flex justify-between items-center">
                            <span class="text-gray-500">Payment Method</span>
                            <span class="font-bold text-[#1B1B1B]">
                                <c:choose>
                                    <c:when test="${order.paymentMethod == 'cod'}">Cash on Delivery (COD)
                                    </c:when>
                                    <c:otherwise>Bank Transfer (VNPAY)</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="flex justify-between items-center">
                            <span class="text-gray-500">Status</span>
                            <span class="font-bold text-[#1B1B1B]">Pending Confirmation</span>
                        </div>

                        <div class="flex justify-between items-center pt-3 border-t border-gray-100">
                            <span class="text-base font-bold text-[#1B1B1B]">Total Payment</span>
                            <span class="text-xl font-extrabold text-[#C92127]">
                                <fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true" /> VND
                            </span>
                        </div>
                    </div>
                </div>

                <div class="flex flex-col sm:flex-row gap-4 w-full sm:w-auto">
                    <a href="${pageContext.request.contextPath}/profile/order-history"
                       class="px-6 py-3 rounded-full font-bold text-sm bg-[#fdd835] text-[#705e00] hover:shadow-md transition-all flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined text-[20px]">history</span>
                        View Order History
                    </a>
                    <a href="${pageContext.request.contextPath}/home"
                       class="px-6 py-3 rounded-full font-bold text-sm border-2 border-[#C92127] text-[#C92127] bg-transparent hover:bg-[#FDE8E9] transition-all flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined text-[20px]">shopping_bag</span>
                        Continue Shopping
                    </a>
                </div>

            </div>
        </main>

        <%@ include file="/views/layout/homepage/footer.jsp" %>
    </body>

</html>

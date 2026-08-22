<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<style>
    .fhs-checkout-body {
        background: #F0F0F0;
        color: #333;
        font-family: Arial, Helvetica, sans-serif;
        min-height: 100vh;
    }

    .fhs-checkout-page {
        max-width: 1230px;
        margin: 0 auto;
        padding: 22px 16px 48px;
        color: #333;
    }

    .fhs-checkout-heading {
        margin: 0 0 14px;
        font-size: 22px;
        line-height: 1.3;
        font-weight: 700;
        color: #333;
    }

    .fhs-checkout-progress {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 16px;
        padding: 12px 16px;
        background: #fff;
        border-radius: 8px;
        font-size: 12px;
        color: #777;
    }

    .fhs-checkout-progress .step {
        display: flex;
        align-items: center;
        gap: 7px;
        white-space: nowrap;
    }

    .fhs-checkout-progress .dot {
        width: 22px;
        height: 22px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        background: #D8D8D8;
        color: #fff;
        font-size: 11px;
        font-weight: 700;
    }

    .fhs-checkout-progress .done .dot,
    .fhs-checkout-progress .active .dot {
        background: #C92127;
    }

    .fhs-checkout-progress .active {
        color: #C92127;
        font-weight: 700;
    }

    .fhs-checkout-progress .line {
        flex: 1 1 60px;
        max-width: 90px;
        height: 1px;
        background: #E3E3E3;
    }

    .fhs-checkout-grid {
        display: grid;
        grid-template-columns: minmax(0, 1fr) 380px;
        gap: 14px;
        align-items: start;
    }

    .fhs-checkout-left {
        display: flex;
        flex-direction: column;
        gap: 12px;
        min-width: 0;
    }

    .fhs-checkout-left > :not([hidden]) ~ :not([hidden]) {
        margin-top: 0 !important;
    }

    /* FAHASA-like order: address -> payment -> order review */
    .fhs-checkout-left > section:nth-child(1) { order: 3; }
    .fhs-checkout-left > section:nth-child(2) { order: 1; }
    .fhs-checkout-left > section:nth-child(3) { order: 2; }

    .fhs-checkout-page section,
    .fhs-order-summary {
        background: #fff !important;
        border: 0 !important;
        border-radius: 8px !important;
        box-shadow: 0 1px 2px rgba(0,0,0,.04);
    }

    .fhs-checkout-page section > div:first-child,
    .fhs-checkout-page section > h2 {
        color: #333 !important;
    }

    .fhs-checkout-page section > div:first-child {
        padding: 15px 18px !important;
        border-bottom: 1px solid #E8E8E8 !important;
    }

    .fhs-checkout-page section > h2 {
        margin: 0 !important;
        padding: 15px 18px !important;
        border-bottom: 1px solid #E8E8E8;
        font-size: 15px !important;
        font-weight: 700 !important;
    }

    .fhs-checkout-page section h2 {
        color: #333 !important;
        font-size: 15px !important;
        font-weight: 700 !important;
    }

    .fhs-checkout-page section h2 svg {
        width: 18px;
        height: 18px;
        color: #C92127;
    }

    /* Address section */
    .fhs-checkout-left > section:nth-child(2) {
        padding: 0 18px 18px !important;
    }

    .fhs-checkout-left > section:nth-child(2) > .flex:first-child {
        margin: 0 -18px 16px !important;
        padding: 15px 18px !important;
        border-bottom: 1px solid #E8E8E8;
    }

    #btnShowAddressForm {
        border: 0 !important;
        padding: 5px 0 !important;
        border-radius: 0 !important;
        color: #C92127 !important;
        background: transparent !important;
        font-size: 12px !important;
    }

    #selectedAddressBox {
        border: 1px solid #DADADA !important;
        background: #fff !important;
        border-radius: 6px !important;
        padding: 14px 15px !important;
        display: grid !important;
        grid-template-columns: minmax(0, 1fr) auto;
        gap: 16px;
        align-items: center;
    }

    #selectedAddressBox:hover {
        border-color: #C92127 !important;
    }

    #selectedAddressBox > div {
        min-width: 0;
    }

    #selectedAddressBox button {
        flex: 0 0 auto;
        white-space: nowrap;
    }

    #selectedDefaultBadge,
    .default-option-badge {
        background: #C92127 !important;
        border-radius: 3px !important;
    }

    #addressDropdown {
        border: 1px solid #DADADA !important;
        border-radius: 6px !important;
        box-shadow: 0 8px 20px rgba(0,0,0,.12) !important;
    }

    .address-option {
        padding: 14px 15px !important;
        border-bottom: 1px solid #ECECEC !important;
    }

    .address-option:hover {
        background: #FFF7F7 !important;
    }

    /* Payment */
    .fhs-checkout-left > section:nth-child(3) {
        padding: 0 18px 18px !important;
    }

    .fhs-checkout-left > section:nth-child(3) > h2 {
        margin: 0 -18px 15px !important;
    }

    #paymentGroup {
        display: grid;
        gap: 8px;
    }

    .payment-card {
        min-height: 56px;
        padding: 11px 14px !important;
        border: 1px solid #DDDDDD !important;
        border-radius: 6px !important;
        background: #fff !important;
    }

    .payment-card:hover {
        border-color: #C92127 !important;
        background: #FFF9F9 !important;
    }

    .payment-card:has(input:checked) {
        border-color: #C92127 !important;
        background: #FFF5F5 !important;
        box-shadow: 0 0 0 1px rgba(201, 33, 39, .08);
    }

    .payment-card input[type="radio"] {
        appearance: none;
        width: 18px !important;
        height: 18px !important;
        flex: 0 0 18px;
        border: 1.5px solid #A7A7A7;
        border-radius: 50%;
        background: #fff;
        display: grid;
        place-content: center;
        outline: none;
        cursor: pointer;
    }

    .payment-card input[type="radio"]::before {
        content: "";
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background: #C92127;
        transform: scale(0);
        transition: transform .12s ease;
    }

    .payment-card input[type="radio"]:checked {
        border-color: #C92127;
    }

    .payment-card input[type="radio"]:checked::before {
        transform: scale(1);
    }

    .payment-card p {
        color: #333 !important;
    }

    .payment-card > div > div:first-child {
        width: 36px !important;
        height: 36px !important;
        border-radius: 6px !important;
        background: #FFF0F1 !important;
        color: #C92127 !important;
    }

    /* Review order */
    .fhs-checkout-left > section:nth-child(1) > div:first-child a {
        color: #C92127 !important;
    }

    .fhs-checkout-left > section:nth-child(1) .divide-y > div {
        padding: 16px 18px !important;
        gap: 14px !important;
    }

    .fhs-checkout-left > section:nth-child(1) .divide-y > div > div:first-child {
        width: 74px !important;
        height: 100px !important;
        border-radius: 4px !important;
        background: #FAFAFA !important;
        border: 1px solid #EFEFEF !important;
    }

    .fhs-checkout-left > section:nth-child(1) .divide-y img {
        object-fit: contain !important;
    }

    /* Summary */
    .fhs-checkout-aside {
        position: sticky;
        top: 16px;
    }

    .fhs-order-summary {
        padding: 0 !important;
        overflow: hidden;
    }

    .fhs-order-summary > h2 {
        margin: 0 !important;
        padding: 15px 18px !important;
        border-bottom: 1px solid #E8E8E8;
        border-left: 0 !important;
        color: #333 !important;
        font-size: 15px !important;
        font-weight: 700 !important;
    }

    .fhs-order-summary > div,
    .fhs-order-summary > form {
        margin-left: 18px;
        margin-right: 18px;
    }

    .fhs-order-summary > div:first-of-type {
        margin-top: 18px;
    }

    .fhs-voucher-heading {
        min-height: 24px;
        gap: 12px;
    }

    .fhs-voucher-heading > * {
        white-space: nowrap;
    }

    .fhs-voucher-controls {
        align-items: stretch;
    }

    .fhs-checkout-summary-row,
    .fhs-checkout-total-row {
        display: grid !important;
        grid-template-columns: minmax(0, 1fr) auto;
        align-items: baseline;
        gap: 16px;
    }

    .fhs-checkout-summary-row > :last-child,
    .fhs-checkout-total-row > :last-child {
        text-align: right;
        white-space: nowrap;
    }

    #voucherCodeInput {
        min-width: 0;
        height: 38px;
        border: 1px solid #D8D8D8 !important;
        border-radius: 5px !important;
        font-size: 13px !important;
    }

    #btnApplyVoucher,
    #btnRemoveVoucher {
        border-radius: 5px !important;
        min-width: 76px;
        padding: 0 12px !important;
        font-size: 12px !important;
    }

    #btnApplyVoucher {
        background: #C92127 !important;
    }

    #grandTotalDisplay {
        color: #C92127 !important;
        font-size: 22px !important;
    }

    .fhs-order-summary > form {
        margin-bottom: 18px;
    }

    #checkout-form button[type="submit"] {
        width: 100%;
        min-height: 46px;
        border-radius: 6px !important;
        background: #C92127 !important;
        color: #fff !important;
        box-shadow: none !important;
        transform: none !important;
        font-size: 14px !important;
        font-weight: 700 !important;
    }

    #checkout-form button[type="submit"]:hover {
        background: #A8191F !important;
    }

    /* Dialogs */
    #newAddressForm > div,
    #deleteAddressConfirm > div,
    #confirmOrderModal > div,
    #voucherListModal > div {
        border-radius: 8px !important;
    }

    #newAddressForm > div > div:first-child {
        background: #C92127 !important;
    }

    @media (max-width: 960px) {
        .fhs-checkout-grid {
            grid-template-columns: 1fr;
        }

        .fhs-checkout-aside {
            position: static;
        }
    }

    @media (max-width: 640px) {
        .fhs-checkout-page {
            padding: 14px 10px 32px;
        }

        .fhs-checkout-progress {
            gap: 6px;
            padding: 10px 12px;
            overflow-x: auto;
        }

        .fhs-checkout-progress .line {
            min-width: 24px;
        }

        .fhs-checkout-left > section:nth-child(1) .divide-y > div {
            flex-direction: row !important;
        }

        .fhs-checkout-left > section:nth-child(1) .divide-y > div > div:first-child {
            width: 66px !important;
            height: 90px !important;
            flex: 0 0 66px !important;
        }

        #newRecipientFields,
        #newAddressForm .grid-cols-2 {
            grid-template-columns: 1fr !important;
        }
    }
</style>


<body class="fhs-checkout-body">
    <main class="fhs-checkout-page">

        <h1 class="fhs-checkout-heading">Checkout</h1>

        <div class="fhs-checkout-progress" aria-label="Checkout progress">
            <span class="step done"><span class="dot">1</span>Cart</span>
            <span class="line"></span>
            <span class="step active"><span class="dot">2</span>Checkout</span>
            <span class="line"></span>
            <span class="step"><span class="dot">3</span>Complete</span>
        </div>

        <div class="fhs-checkout-grid">
            <div class="fhs-checkout-left">

                <!-- Payment -->
                <section
                    class="bg-surface rounded-xl style-card border border-outline-variant overflow-hidden">
                    <div
                        class="p-6 border-b border-surface-container flex items-center justify-between">
                        <h2 class="text-[16px] font-bold text-primary flex items-center gap-2">
                            <i data-lucide="shopping-bag"></i>
                            Review Your Order
                        </h2>
                        <a href="${pageContext.request.contextPath}/cart"
                           class="text-[13px] text-primary hover:underline font-medium">
                            ← Back to Cart
                        </a>
                    </div>

                    <div class="divide-y divide-surface-container">
                        <c:forEach var="item" items="${cartItems}">
                            <div
                                class="p-6 flex flex-col sm:flex-row gap-6 hover:bg-surface-variant/20 transition-colors">
                                <div
                                    class="w-24 h-36 bg-surface-container-low flex-shrink-0 rounded-lg overflow-hidden border border-outline-variant">
                                    <c:choose>
                                        <c:when test="${not empty item.thumbnail}">
                                            <img class="w-full h-full object-cover"
                                                 src="${item.thumbnailFirst}"
                                                 alt="${item.title}" />
                                        </c:when>
                                        <c:otherwise>
                                            <div
                                                class="w-full h-full flex items-center justify-center text-on-surface-variant">
                                                <i data-lucide="book-open"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="flex-grow">
                                    <div class="flex justify-between items-start">
                                        <div>
                                            <h3
                                                class="text-[15px] font-bold text-on-surface mb-1">
                                                ${item.title}</h3>
                                            <p class="text-[13px] text-on-surface-variant">
                                                ${item.authorsDisplay}</p>
                                            <div class="mt-4">
                                                <span
                                                    class="text-[13px] text-on-surface-variant">
                                                    Quantity: <strong>${item.quantity}</strong>
                                                </span>
                                            </div>
                                        </div>

                                        <span
                                            class="text-[17px] font-bold text-primary whitespace-nowrap">
                                            <fmt:formatNumber value="${item.subtotal}"
                                                              type="number" groupingUsed="true" /> VND
                                        </span>
                                    </div>

                                    <p class="text-[16px] text-on-surface-variant mt-1">
                                        Unit Price:
                                        <strong>
                                            <fmt:formatNumber value="${item.price}"
                                                              type="number" groupingUsed="true" /> VND
                                        </strong>
                                    </p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </section>

                <section
                    class="bg-surface rounded-xl style-card border border-outline-variant p-6">
                    <div class="flex items-center justify-between mb-5">
                        <h2 class="text-[16px] font-bold text-primary flex items-center gap-2">
                            <i data-lucide="truck"></i>
                            Shipping Address
                        </h2>

                        <button type="button" id="btnShowAddressForm"
                                class="text-[12px] font-bold text-primary border border-primary rounded-full px-4 py-1.5 hover:bg-primary hover:text-white transition">
                            + Add New
                        </button>
                    </div>

                    <div class="relative">
                        <div id="selectedAddressBox"
                             class="border-2 border-primary bg-primary/5 rounded-xl p-4 cursor-pointer flex items-center justify-between">
                            <div>
                                <p class="text-[14px] font-bold">
                                    <span id="selectedDefaultBadge"
                                          class="hidden text-[11px] bg-primary text-white px-2 py-1 rounded-full mr-2">
                                        Default
                                    </span>
                                    <span id="selectedNamePhone">No address selected</span>
                                </p>
                                <p id="selectedAddressText"
                                   class="text-[13px] text-on-surface-variant mt-1">
                                    Please add a shipping address before checkout.
                                </p>
                            </div>

                            <button type="button"
                                    class="text-primary font-bold text-[13px] flex items-center gap-1">
                                Change <i data-lucide="chevron-down" class="w-4 h-4"></i>
                            </button>
                        </div>

                        <div id="addressDropdown"
                             class="hidden absolute left-0 right-0 mt-2 bg-white border border-outline-variant rounded-xl shadow-lg z-40 overflow-hidden">

                            <c:choose>
                                <c:when test="${not empty addressList}">
                                    <c:forEach var="address" items="${addressList}">
                                        <c:set var="displayRecipientName"
                                               value="${not empty address.recipientName ? address.recipientName : sessionScope.account.fullname}" />
                                        <c:set var="displayRecipientPhone"
                                               value="${not empty address.recipientPhone ? address.recipientPhone : sessionScope.account.phone}" />

                                        <div class="address-option p-4 cursor-pointer hover:bg-primary/5 border-b"
                                             data-id="${address.addressID}" data-deleted="false"
                                             data-fullname="${fn:escapeXml(displayRecipientName)}"
                                             data-phone="${fn:escapeXml(displayRecipientPhone)}"
                                             data-street="${fn:escapeXml(address.street)}"
                                             data-ward="${fn:escapeXml(address.district)}"
                                             data-city="${fn:escapeXml(address.city)}"
                                             data-default="${address['default']}">
                                            <div class="flex justify-between gap-3">
                                                <div>
                                                    <p class="text-[14px] font-bold">
                                                        <span
                                                            class="default-option-badge ${address['default'] ? '' : 'hidden'} text-[11px] bg-primary text-white px-2 py-1 rounded-full mr-2">
                                                            Default
                                                        </span>
                                                        ${displayRecipientName} -
                                                        ${displayRecipientPhone}
                                                    </p>
                                                    <p
                                                        class="text-[13px] text-on-surface-variant mt-1">
                                                        ${address.street}, ${address.district},
                                                        ${address.city}
                                                    </p>
                                                </div>

                                                <button type="button"
                                                        class="delete-address-btn text-red-600 text-[12px] font-bold hover:underline">
                                                    Delete
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>

                                <c:otherwise>
                                    <div class="p-4 text-red-600 text-[13px] font-bold">
                                        You do not have an address yet. Please add a shipping address.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div id="deleteAddressConfirm"
                         class="hidden fixed inset-0 bg-black/40 z-[60] flex items-center justify-center">
                        <div class="bg-white rounded-xl w-[360px] shadow-xl p-6">
                            <h3 class="text-[16px] font-bold text-on-surface mb-2">Delete Address?
                            </h3>
                            <p class="text-[13px] text-on-surface-variant mb-5">
                                This address will be removed from the list. Are you sure
                                you want to delete it?
                            </p>
                            <div class="grid grid-cols-2 gap-3">
                                <button type="button" id="btnCancelDeleteAddress"
                                        class="bg-[#FFE3C2] text-[#1B1B1B] py-3 rounded font-bold text-[13px]">
                                    Cancel
                                </button>
                                <button type="button" id="btnConfirmDeleteAddress"
                                        class="bg-red-600 text-white py-3 rounded font-bold text-[13px]">
                                    Delete
                                </button>
                            </div>
                        </div>
                    </div>

                    <div id="newAddressForm"
                         class="hidden fixed inset-0 bg-black/40 z-50 flex items-center justify-center">
                        <div class="bg-white rounded-lg w-[430px] overflow-hidden shadow-xl">
                            <div
                                class="bg-primary text-white px-5 py-4 flex justify-between items-center">
                                <h3 class="font-bold text-[16px]">Add New Address</h3>
                                <button type="button" id="btnCloseAddressForm"
                                        class="text-white text-[24px] leading-none">×</button>
                            </div>

                            <div class="p-5 space-y-4">
                                <div id="newRecipientFields" class="grid grid-cols-2 gap-3">
                                    <div>
                                        <label class="block text-[12px] font-bold mb-1">Recipient Name</label>
                                        <input id="newFullname" type="text"
                                               placeholder="Enter full name"
                                               value="${sessionScope.account.fullname}"
                                               class="w-full border border-outline-variant rounded px-3 py-2 text-[13px]">
                                    </div>

                                    <div>
                                        <label class="block text-[12px] font-bold mb-1">Phone Number</label>
                                        <input id="newPhone" type="text"
                                               placeholder="Enter phone number"
                                               value="${sessionScope.account.phone}"
                                               class="w-full border border-outline-variant rounded px-3 py-2 text-[13px]">
                                    </div>
                                </div>

                                <div class="grid grid-cols-2 gap-3">
                                    <div>
                                        <label class="block text-[12px] font-bold mb-1">Province / City</label>
                                        <select id="newCity"
                                                class="w-full border border-outline-variant rounded px-3 py-2 text-[13px]">
                                            <option value="">Loading...</option>
                                        </select>
                                    </div>

                                    <div>
                                        <label class="block text-[12px] font-bold mb-1">Ward / Commune</label>
                                        <select id="newWard"
                                                class="w-full border border-outline-variant rounded px-3 py-2 text-[13px]">
                                            <option value="">Select Ward / Commune</option>
                                        </select>
                                    </div>
                                </div>

                                <div>
                                    <label class="block text-[12px] font-bold mb-1">Street Address</label>
                                    <textarea id="newStreet" rows="3"
                                              placeholder="House number, street name..."
                                              class="w-full border border-outline-variant rounded px-3 py-2 text-[13px]"></textarea>
                                </div>

                                <label
                                    class="flex items-center gap-2 bg-[#FDE8E9] px-3 py-2 rounded text-[12px]">
                                    <input type="checkbox" id="defaultAddress">
                                    Set as default shipping address
                                </label>

                                <div class="grid grid-cols-2 gap-3 pt-2">
                                    <button type="button" id="btnCancelAddress"
                                            class="bg-[#FFE3C2] text-[#1B1B1B] py-3 rounded font-bold text-[13px]">
                                        Cancel
                                    </button>

                                    <button type="button" id="btnSaveAddress"
                                            class="bg-primary text-white py-3 rounded font-bold text-[13px]">
                                        Save Address
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!--   Payment Method  -->
                <section
                    class="bg-surface rounded-xl style-card border border-outline-variant p-6">
                    <h2 class="text-[16px] font-bold text-primary flex items-center gap-2 mb-6">
                        <i data-lucide="wallet-cards"></i> Payment Method
                    </h2>

                    <div class="space-y-3" id="paymentGroup">
                        <label
                            class="payment-card flex items-center justify-between p-4 border border-outline-variant rounded-[10px] cursor-pointer hover:bg-surface-variant/20 transition-all">
                            <div class="flex items-center gap-4">
                                <div
                                    class="w-10 h-10 rounded-full bg-surface-container flex items-center justify-center text-on-surface-variant">
                                    <i data-lucide="credit-card"></i>
                                </div>
                                <div>
                                    <p class="text-[14px] font-bold">
                                        Bank Transfer (VNPAY)</p>
                                </div>
                            </div>
                            <input class="text-primary focus:ring-primary h-5 w-5"
                                   name="payment_method" form="checkout-form" type="radio"
                                   value="vnpay" />
                        </label>

                        <label
                            class="payment-card flex items-center justify-between p-4 border border-outline-variant rounded-[10px] cursor-pointer hover:bg-surface-variant/20 transition-all">
                            <div class="flex items-center gap-4">
                                <div
                                    class="w-10 h-10 rounded-full bg-surface-container flex items-center justify-center text-on-surface-variant">
                                    <i data-lucide="banknote"></i>
                                </div>
                                <div>
                                    <p class="text-[14px] font-bold">Cash on Delivery
                                        (COD)</p>
                                </div>
                            </div>
                            <input checked class="text-primary focus:ring-primary h-5 w-5"
                                   name="payment_method" form="checkout-form" type="radio"
                                   value="cod" />
                        </label>
                    </div>
                </section>
            </div>

            <aside class="fhs-checkout-aside">
                <div class="fhs-order-summary">
                    <h2>Order Summary</h2>

                    <div class="mb-5 fhs-voucher-section">
                        <div class="fhs-voucher-heading flex items-center justify-between mb-2">
                            <label class="text-[13px] font-bold text-on-surface block">Voucher Code</label>
                            <button type="button" id="btnShowVoucherList"
                                    class="text-[12px] font-bold text-primary hover:underline flex items-center gap-1">
                                <i data-lucide="ticket-percent" class="w-3.5 h-3.5"></i>
                                Store Vouchers
                            </button>
                        </div>
                        <div class="fhs-voucher-controls flex gap-2">
                            <input type="text" id="voucherCodeInput"
                                   placeholder="Enter voucher code" value="${appliedVoucherCode}"
                                   ${not empty appliedVoucherCode ? 'disabled' : '' }
                                   class="flex-grow border border-outline-variant rounded-lg px-3 py-2 text-[14px] uppercase
                                   focus:outline-none focus:ring-2 focus:ring-primary/40 disabled:bg-surface-variant/40" />
                            <button type="button" id="btnApplyVoucher"
                                    class="${not empty appliedVoucherCode ? 'hidden' : ''} px-4 py-2 rounded-lg bg-primary text-white text-[13px] font-bold hover:opacity-90 transition">
                                Apply
                            </button>
                            <button type="button" id="btnRemoveVoucher"
                                    class="${not empty appliedVoucherCode ? '' : 'hidden'} px-4 py-2 rounded-lg border border-red-400 text-red-600 text-[13px] font-bold hover:bg-red-50 transition">
                                Remove Code
                            </button>
                        </div>
                    </div>

                    <div class="space-y-3 mb-5 fhs-summary-lines">
                        <div class="fhs-checkout-summary-row text-[14px]">
                            <span class="text-on-surface-variant">Subtotal (${totalQuantity} items)</span>
                            <span id="subtotalDisplay" class="font-bold" data-value="${total}">
                                <fmt:formatNumber value="${total}" type="number"
                                                  groupingUsed="true" /> VND
                            </span>
                        </div>

                        <div class="fhs-checkout-summary-row text-[14px] text-green-600">
                            <span>Voucher Discount</span>
                            <span id="discountDisplay" class="font-bold"
                                  data-value="${empty appliedDiscount ? 0 : appliedDiscount}">
                                <c:choose>
                                    <c:when test="${not empty appliedDiscount and appliedDiscount > 0}">
                                        -
                                        <fmt:formatNumber value="${appliedDiscount}"
                                                          type="number" groupingUsed="true" /> VND
                                    </c:when>
                                    <c:otherwise>0 VND</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div
                            class="fhs-checkout-total-row pt-4 border-t border-surface-container">
                            <span class="text-[15px] font-bold text-primary">Total</span>
                            <span id="grandTotalDisplay"
                                  class="text-[22px] font-black text-primary">
                                <fmt:formatNumber
                                    value="${total - (empty appliedDiscount ? 0 : appliedDiscount)}"
                                    type="number" groupingUsed="true" /> VND
                            </span>
                        </div>
                    </div>

                    <form id="checkout-form"
                          action="${pageContext.request.contextPath}/checkout" method="POST">
                        <input type="hidden" name="addressID" id="checkoutAddressID" value="">
                        <input type="hidden" name="fullname" id="checkoutFullname" value="">
                        <input type="hidden" name="phone" id="checkoutPhone" value="">
                        <input type="hidden" name="street" id="checkoutStreet" value="">
                        <input type="hidden" name="ward" id="checkoutWard" value="">
                        <input type="hidden" name="city" id="checkoutCity" value="">
                        <input type="hidden" name="district" id="checkoutDistrict"
                               value="None">
                        <input type="hidden" name="isDefault" id="checkoutIsDefault"
                               value="false">
                        <input type="hidden" name="deletedAddressIds" id="deletedAddressIds"
                               value="">

                        <button type="submit" class="w-full bg-primary text-white py-3.5 rounded-full font-black text-[15px]
                                shadow-sm hover:bg-[#a9191f] hover:scale-[1.02] active:scale-[0.98] transition-all
                                flex items-center justify-center gap-2 uppercase tracking-wide">
                            PLACE ORDER
                        </button>
                    </form>
                </div>
            </aside>
        </div>
    </main>

    <%-- Confirm order modal --%>
    <div id="confirmOrderModal"
         class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[9999]">
        <div class="bg-white w-[450px] rounded-xl p-6 relative">
            <button type="button"
                    class="absolute top-3 right-4 text-2xl hover:text-gray-500"
                    id="btnCloseOrderConfirm">×</button>

            <h3 class="text-xl font-bold mb-4">Confirm Order</h3>
            <p class="text-gray-600 mb-6">Are you sure you want to place this order?</p>

            <div class="flex justify-end gap-3">
                <button type="button" id="btnCancelOrder"
                        class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100">
                    Cancel
                </button>
                
                
                
                <button type="button" id="btnConfirmOrder"
                        class="px-4 py-2 bg-[#C92127] text-white rounded-lg hover:opacity-90">
                    Confirm
                </button>
            </div>
        </div>
    </div>

    <%-- Voucher list modal --%>
    <div id="voucherListModal"
         class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[9999] p-4">
        <div
            class="bg-white w-full max-w-[480px] max-h-[80vh] rounded-xl relative flex flex-col">
            <div
                class="flex items-center justify-between p-5 border-b border-outline-variant">
                <h3 class="text-lg font-black text-primary">Store Vouchers</h3>
                <button type="button" id="btnCloseVoucherList"
                        class="text-2xl leading-none hover:text-gray-500">&times;</button>
            </div>
            <div id="voucherListBody" class="p-5 overflow-y-auto space-y-3 flex-grow">
                <p class="text-center text-on-surface-variant text-[13px]">Loading...
                </p>
            </div>
        </div>
    </div>

    <script>
        var vietnamProvinces = [];
        var addressIdCounter = Date.now();
        var deleteTargetOption = null;
        var deletedAddressIds = [];

        var ADDRESS_STORAGE_KEY = 'checkout_addresses_${sessionScope.account.id}';
        var DELETED_STORAGE_KEY = 'checkout_deleted_addresses_${sessionScope.account.id}';

        function showInputError(message) {
            showToast(message, true);
        }

        function escapeHtml(text) {
            return String(text || '')
                    .replaceAll('&', '&amp;')
                    .replaceAll('<', '&lt;')
                    .replaceAll('>', '&gt;')
                    .replaceAll('"', '&quot;')
                    .replaceAll("'", '&#039;');
        }

        function loadLocalAddresses() {
            try {
                return JSON.parse(localStorage.getItem(ADDRESS_STORAGE_KEY) || '[]');
            } catch (e) {
                return [];
            }
        }

        function saveLocalAddresses(addresses) {
            localStorage.setItem(ADDRESS_STORAGE_KEY, JSON.stringify(addresses));
        }

        function loadDeletedAddressIds() {
            try {
                return JSON.parse(localStorage.getItem(DELETED_STORAGE_KEY) || '[]');
            } catch (e) {
                return [];
            }
        }

        function saveDeletedAddressIds() {
            localStorage.setItem(DELETED_STORAGE_KEY, JSON.stringify(deletedAddressIds));
            document.getElementById('deletedAddressIds').value = deletedAddressIds.join(',');
        }

        function validateFullname(fullname) {
            var nameRegex = /^[A-Za-zÀ-ỹ\s]{2,50}$/;
            if (!fullname)
                return "Please enter the recipient's name.";
            if (!nameRegex.test(fullname))
                return 'The full name is invalid.';
            return '';
        }

        function validatePhone(phone) {
            var phoneRegex = /^(0|\+84)(3|5|7|8|9)[0-9]{8}$/;
            if (!phone)
                return 'Please enter a phone number.';
            if (!phoneRegex.test(phone))
                return 'The phone number is invalid.';
            return '';
        }

        function validateStreet(street) {
            var streetRegex = /[A-Za-zÀ-ỹ]/;
            if (!street)
                return 'Please enter a street address.';
            if (street.length < 5 || !streetRegex.test(street)) {
                return 'The address is invalid. Please provide a clear house number and street name.';
            }
            return '';
        }

        function validateAddressInput(fullname, phone, city, ward, street) {
            var error = validateFullname(fullname);
            if (error)
                return error;

            error = validatePhone(phone);
            if (error)
                return error;

            if (!city)
                return 'Please select a province or city.';
            if (!ward)
                return 'Please select a ward or commune.';

            error = validateStreet(street);
            if (error)
                return error;

            return '';
        }

        function setCheckoutAddress(addressID, fullname, phone, street, ward, city, isDefault) {
            document.getElementById('checkoutAddressID').value = addressID || '';
            document.getElementById('checkoutFullname').value = fullname || '';
            document.getElementById('checkoutPhone').value = phone || '';
            document.getElementById('checkoutStreet').value = street || '';
            document.getElementById('checkoutWard').value = ward || '';
            document.getElementById('checkoutCity').value = city || '';
            document.getElementById('checkoutDistrict').value = ward || 'None';
            document.getElementById('checkoutIsDefault').value = isDefault ? 'true' : 'false';

            document.getElementById('selectedNamePhone').textContent = fullname && phone
                    ? fullname + ' - ' + phone
                    : 'No address selected';

            document.getElementById('selectedAddressText').textContent = street && ward && city
                    ? street + ', ' + ward + ', ' + city
                    : 'Please add a shipping address before checkout.';

            var selectedBadge = document.getElementById('selectedDefaultBadge');
            if (isDefault)
                selectedBadge.classList.remove('hidden');
            else
                selectedBadge.classList.add('hidden');
        }

        function resetSelectedAddressBox() {
            setCheckoutAddress('', '', '', '', '', '', false);
        }

        function getVisibleAddressOptions() {
            return Array.prototype.slice.call(document.querySelectorAll('.address-option')).filter(function (option) {
                return option.dataset.deleted !== 'true' && !option.classList.contains('hidden');
            });
        }

        function refreshDefaultBadges() {
            document.querySelectorAll('.address-option').forEach(function (option) {
                var badge = option.querySelector('.default-option-badge');
                if (!badge)
                    return;

                if (option.dataset.default === 'true' && option.dataset.deleted !== 'true') {
                    badge.classList.remove('hidden');
                } else {
                    badge.classList.add('hidden');
                }
            });
        }

        function syncLocalAddressesFromDom() {
            var localAddresses = [];

            document.querySelectorAll('.address-option').forEach(function (option) {
                if (option.dataset.id && option.dataset.id.indexOf('new-') === 0 && option.dataset.deleted !== 'true') {
                    localAddresses.push({
                        id: option.dataset.id,
                        fullname: option.dataset.fullname,
                        phone: option.dataset.phone,
                        street: option.dataset.street,
                        ward: option.dataset.ward,
                        city: option.dataset.city,
                        isDefault: option.dataset.default === 'true'
                    });
                }
            });

            saveLocalAddresses(localAddresses);
        }

        function isSelectedOption(option) {
            return document.getElementById('checkoutStreet').value === option.dataset.street &&
                    document.getElementById('checkoutWard').value === option.dataset.ward &&
                    document.getElementById('checkoutCity').value === option.dataset.city &&
                    document.getElementById('checkoutPhone').value === option.dataset.phone;
        }

        function selectOption(option) {
            if (!option || option.dataset.deleted === 'true')
                return;

            setCheckoutAddress(
                    option.dataset.id,
                    option.dataset.fullname,
                    option.dataset.phone,
                    option.dataset.street,
                    option.dataset.ward,
                    option.dataset.city,
                    option.dataset.default === 'true'
                    );

            document.getElementById('addressDropdown').classList.add('hidden');
        }

        function createAddressOption(address) {
            var option = document.createElement('div');
            option.className = 'address-option p-4 cursor-pointer hover:bg-primary/5 border-b';
            option.dataset.id = address.id;
            option.dataset.deleted = 'false';
            option.dataset.fullname = address.fullname;
            option.dataset.phone = address.phone;
            option.dataset.street = address.street;
            option.dataset.ward = address.ward;
            option.dataset.city = address.city;
            option.dataset.default = address.isDefault ? 'true' : 'false';

            option.innerHTML =
                    '<div class="flex justify-between gap-3">' +
                    '<div>' +
                    '<p class="text-[14px] font-bold">' +
                    '<span class="default-option-badge ' + (address.isDefault ? '' : 'hidden') + ' text-[11px] bg-primary text-white px-2 py-1 rounded-full mr-2">Default</span>' +
                    escapeHtml(address.fullname) + ' - ' + escapeHtml(address.phone) +
                    '</p>' +
                    '<p class="text-[13px] text-on-surface-variant mt-1">' +
                    escapeHtml(address.street) + ', ' + escapeHtml(address.ward) + ', ' + escapeHtml(address.city) +
                    '</p>' +
                    '</div>' +
                    '<button type="button" class="delete-address-btn text-red-600 text-[12px] font-bold hover:underline">Delete</button>' +
                    '</div>';

            bindAddressOption(option);
            return option;
        }

        function softDeleteAddress(option) {
            if (!option)
                return;

            var wasSelected = isSelectedOption(option);
            var wasDefault = option.dataset.default === 'true';
            var deletedId = option.dataset.id;

            option.dataset.deleted = 'true';
            option.dataset.default = 'false';
            option.classList.add('hidden');

            if (deletedId && deletedId.indexOf('new-') !== 0 && !deletedAddressIds.includes(deletedId)) {
                deletedAddressIds.push(deletedId);
                saveDeletedAddressIds();
            }

            syncLocalAddressesFromDom();

            var remainingOptions = getVisibleAddressOptions();

            if (wasDefault && remainingOptions.length > 0) {
                remainingOptions[0].dataset.default = 'true';
                syncLocalAddressesFromDom();
            }

            refreshDefaultBadges();

            if (wasSelected && remainingOptions.length > 0)
                selectOption(remainingOptions[0]);
            if (remainingOptions.length === 0)
                resetSelectedAddressBox();

            showToast('Address deleted!', false);
        }

        function bindAddressOption(option) {
            option.addEventListener('click', function () {
                selectOption(this);
            });

            var deleteBtn = option.querySelector('.delete-address-btn');
            if (deleteBtn) {
                deleteBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    deleteTargetOption = option;
                    document.getElementById('deleteAddressConfirm').classList.remove('hidden');
                });
            }
        }

        function applyDeletedAddressesOnReload() {
            deletedAddressIds = loadDeletedAddressIds();
            saveDeletedAddressIds();

            document.querySelectorAll('.address-option').forEach(function (option) {
                if (deletedAddressIds.includes(option.dataset.id)) {
                    option.dataset.deleted = 'true';
                    option.dataset.default = 'false';
                    option.classList.add('hidden');
                }
            });
        }

        function renderLocalAddresses() {
            var dropdown = document.getElementById('addressDropdown');
            var localAddresses = loadLocalAddresses();

            localAddresses.forEach(function (address) {
                if (!document.querySelector('.address-option[data-id="' + address.id + '"]')) {
                    dropdown.appendChild(createAddressOption(address));
                }
            });
        }

        // Danh sách địa chỉ luôn lấy từ database do server render.
        // Không khôi phục địa chỉ từ localStorage để tránh dữ liệu giả hoặc dữ liệu đã xóa xuất hiện lại.
        document.querySelectorAll('.address-option').forEach(bindAddressOption);

        document.getElementById('btnCancelDeleteAddress').addEventListener('click', function () {
            deleteTargetOption = null;
            document.getElementById('deleteAddressConfirm').classList.add('hidden');
        });

        document.getElementById('btnConfirmDeleteAddress').addEventListener('click', function () {
            if (!deleteTargetOption) {
                document.getElementById('deleteAddressConfirm').classList.add('hidden');
                return;
            }

            var addressID = deleteTargetOption.dataset.id;
            var targetOption = deleteTargetOption;
            var confirmButton = this;
            confirmButton.disabled = true;

            fetch('${pageContext.request.contextPath}/checkout', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'},
                body: 'action=deleteAddressAjax&addressID=' + encodeURIComponent(addressID)
            })
                    .then(function (response) {
                        return response.json();
                    })
                    .then(function (data) {
                        confirmButton.disabled = false;

                        if (!data.success) {
                            showInputError(data.message || 'Could not delete the address.');
                            return;
                        }

                        softDeleteAddress(targetOption);
                        // Delete dấu vết localStorage cũ; database mới là nguồn dữ liệu duy nhất.
                        localStorage.removeItem(ADDRESS_STORAGE_KEY);
                        localStorage.removeItem(DELETED_STORAGE_KEY);
                    })
                    .catch(function () {
                        confirmButton.disabled = false;
                        showInputError('Could not connect to the server!');
                    })
                    .finally(function () {
                        deleteTargetOption = null;
                        document.getElementById('deleteAddressConfirm').classList.add('hidden');
                    });
        });

        document.getElementById('selectedAddressBox').addEventListener('click', function () {
            document.getElementById('addressDropdown').classList.toggle('hidden');
        });

        document.getElementById('btnShowAddressForm').addEventListener('click', function () {
            document.getElementById('newAddressForm').classList.remove('hidden');
        });

        document.getElementById('btnCloseAddressForm').addEventListener('click', closeAddressModal);
        document.getElementById('btnCancelAddress').addEventListener('click', closeAddressModal);

        var accountFullname = '${fn:escapeXml(sessionScope.account.fullname)}';
        var accountPhone = '${fn:escapeXml(sessionScope.account.phone)}';

        function resetRecipientFields() {
            document.getElementById('newFullname').value = accountFullname;
            document.getElementById('newPhone').value = accountPhone;
        }

        function closeAddressModal() {
            document.getElementById('newAddressForm').classList.add('hidden');
            resetRecipientFields();
        }

        async function loadVietnamProvinces() {
            var citySelect = document.getElementById('newCity');
            var wardSelect = document.getElementById('newWard');

            citySelect.innerHTML = '<option value="">Loading...</option>';
            wardSelect.innerHTML = '<option value="">Select Ward / Commune</option>';

            try {
                var response = await fetch('https://provinces.open-api.vn/api/v2/?depth=2');
                vietnamProvinces = await response.json();

                citySelect.innerHTML = '<option value="">Select Province / City</option>';

                vietnamProvinces.forEach(function (province) {
                    var option = document.createElement('option');
                    option.value = province.name;
                    option.textContent = province.name;
                    option.dataset.code = province.code;
                    citySelect.appendChild(option);
                });
            } catch (error) {
                citySelect.innerHTML = '<option value="">Could not load data</option>';
                showInputError('Could not load province and city data!');
            }
        }

        document.getElementById('newCity').addEventListener('change', async function () {
            var cityName = this.value;
            var wardSelect = document.getElementById('newWard');

            wardSelect.innerHTML = '<option value="">Loading wards and communes...</option>';

            var province = vietnamProvinces.find(function (item) {
                return item.name === cityName;
            });

            if (!province) {
                wardSelect.innerHTML = '<option value="">Select Ward / Commune</option>';
                return;
            }

            var wards = province.wards || province.communes || [];

            if (!wards.length && province.code) {
                try {
                    var response = await fetch('https://provinces.open-api.vn/api/v2/p/' + province.code + '?depth=2');
                    var provinceDetail = await response.json();
                    wards = provinceDetail.wards || provinceDetail.communes || [];
                } catch (error) {
                    wards = [];
                }
            }

            wardSelect.innerHTML = '<option value="">Select Ward / Commune</option>';

            wards.forEach(function (ward) {
                var option = document.createElement('option');
                option.value = ward.name;
                option.textContent = ward.name;
                wardSelect.appendChild(option);
            });
        });

        loadVietnamProvinces();
        refreshDefaultBadges();

        var defaultOption = document.querySelector('.address-option[data-default="true"]:not(.hidden)');
        var firstOption = getVisibleAddressOptions()[0];

        if (defaultOption)
            selectOption(defaultOption);
        else if (firstOption)
            selectOption(firstOption);
        else
            resetSelectedAddressBox();

        document.getElementById('btnSaveAddress').addEventListener('click', function () {
            var fullname = document.getElementById('newFullname').value.trim();
            var phone = document.getElementById('newPhone').value.trim();
            var city = document.getElementById('newCity').value;
            var ward = document.getElementById('newWard').value;
            var street = document.getElementById('newStreet').value.trim();
            var isDefault = document.getElementById('defaultAddress').checked;

            var error = validateAddressInput(fullname, phone, city, ward, street);
            if (error) {
                showInputError(error);
                return;
            }

            if (getVisibleAddressOptions().length === 0)
                isDefault = true;

            if (isDefault) {
                document.querySelectorAll('.address-option').forEach(function (option) {
                    option.dataset.default = 'false';
                });
            }

            fetch('${pageContext.request.contextPath}/checkout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                },
                body:
                        'action=saveAddress' +
                        '&fullname=' + encodeURIComponent(fullname) +
                        '&phone=' + encodeURIComponent(phone) +
                        '&street=' + encodeURIComponent(street) +
                        '&ward=' + encodeURIComponent(ward) +
                        '&city=' + encodeURIComponent(city) +
                        '&isDefault=' + encodeURIComponent(isDefault)
            })
                    .then(function (response) {
                        return response.json();
                    })
                    .then(function (data) {
                        if (!data.success) {
                            showInputError(data.message || 'Could not save the address to the database!');
                            return;
                        }

                        var address = {
                            id: String(data.addressID),
                            fullname: fullname,
                            phone: phone,
                            street: street,
                            ward: ward,
                            city: city,
                            isDefault: isDefault
                        };

                        var option = createAddressOption(address);
                        document.getElementById('addressDropdown').appendChild(option);

                        refreshDefaultBadges();
                        selectOption(option);

                        closeAddressModal();

                        document.getElementById('newStreet').value = '';
                        document.getElementById('defaultAddress').checked = false;

                        localStorage.removeItem(ADDRESS_STORAGE_KEY);
                        localStorage.removeItem(DELETED_STORAGE_KEY);
                        showToast('New address added!', false);
                    })
                    .catch(function () {
                        showInputError('Could not connect to the server!');
                    });
        });

        function formatMoney(value) {
            return Math.round(value).toLocaleString('en-US') + ' VND';
        }

        function updateOrderSummary(discountAmount, newTotal) {
            document.getElementById('discountDisplay').dataset.value = discountAmount;
            document.getElementById('discountDisplay').textContent = Number(discountAmount) > 0
                    ? '- ' + formatMoney(discountAmount)
                    : formatMoney(0);
            document.getElementById('grandTotalDisplay').textContent = formatMoney(newTotal);
        }

        document.getElementById('btnApplyVoucher').addEventListener('click', function () {
            var codeInput = document.getElementById('voucherCodeInput');
            var code = codeInput.value.trim();

            if (!code) {
                showToast('Please enter a voucher code.', true);
                return;
            }

            var btn = this;
            btn.disabled = true;

            fetch('${pageContext.request.contextPath}/checkout', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'},
                body: 'action=applyVoucher&code=' + encodeURIComponent(code)
            })
                    .then(function (response) {
                        return response.json();
                    })
                    .then(function (data) {
                        btn.disabled = false;

                        if (!data.success) {
                            showToast(data.message || 'Could not apply the voucher.', true);
                            return;
                        }

                        updateOrderSummary(data.discountAmount, data.newTotal);
                        codeInput.disabled = true;
                        document.getElementById('btnApplyVoucher').classList.add('hidden');
                        document.getElementById('btnRemoveVoucher').classList.remove('hidden');

                        showToast(data.message || 'Voucher applied successfully!', false);
                    })
                    .catch(function () {
                        btn.disabled = false;
                        showToast('Could not connect to the server!', true);
                    });
        });

        document.getElementById('btnRemoveVoucher').addEventListener('click', function () {
            fetch('${pageContext.request.contextPath}/checkout', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'},
                body: 'action=removeVoucher'
            })
                    .then(function (response) {
                        return response.json();
                    })
                    .then(function (data) {
                        if (!data.success) {
                            showToast('Could not remove the voucher.', true);
                            return;
                        }

                        var subtotal = parseFloat(document.getElementById('subtotalDisplay').dataset.value);
                        updateOrderSummary(0, subtotal);

                        var codeInput = document.getElementById('voucherCodeInput');
                        codeInput.disabled = false;
                        codeInput.value = '';

                        document.getElementById('btnApplyVoucher').classList.remove('hidden');
                        document.getElementById('btnRemoveVoucher').classList.add('hidden');

                        showToast('Voucher removed.', false);
                    })
                    .catch(function () {
                        showToast('Could not connect to the server!', true);
                    });
        });

        function formatCurrencyVND(n) {
            return Number(n).toLocaleString('en-US') + ' VND';
        }

        function renderVoucherItem(v) {
            var minOrderHtml = (v.minOrderValue !== null && v.minOrderValue !== undefined)
                    ? '<span class="inline-flex items-center gap-1"><i data-lucide="shopping-cart" class="w-3 h-3"></i>Minimum order ' + formatCurrencyVND(v.minOrderValue) + '</span>'
                    : '';
            var maxDiscountHtml = (v.maxDiscountValue !== null && v.maxDiscountValue !== undefined)
                    ? '<span class="inline-flex items-center gap-1"><i data-lucide="badge-percent" class="w-3 h-3"></i>Maximum discount ' + formatCurrencyVND(v.maxDiscountValue) + '</span>'
                    : '';

            var conditionsHtml = '';
            if (minOrderHtml || maxDiscountHtml) {
                conditionsHtml = '<div class="flex flex-wrap gap-x-4 gap-y-1 text-[12px] text-on-surface-variant mt-2">'
                        + minOrderHtml + maxDiscountHtml + '</div>';
            }

            return ''
                    + '<div class="border border-dashed border-primary/40 rounded-lg p-4 bg-primary/[0.03]">'
                    + '  <div class="flex items-center justify-between gap-3">'
                    + '    <div>'
                    + '      <p class="text-[15px] font-black text-primary">Save ' + v.discountPercent + '%</p>'
                    + '      <div class="flex items-center gap-2 mt-1">'
                    + '        <span class="px-2 py-1 bg-white border border-outline-variant rounded text-[13px] font-bold tracking-wide">' + escapeHtml(v.code) + '</span>'
                    + '        <button type="button" class="btn-copy-voucher text-primary hover:opacity-70" data-code="' + escapeHtml(v.code) + '" title="Copy Code">'
                    + '          <i data-lucide="copy" class="w-4 h-4"></i>'
                    + '        </button>'
                    + '      </div>'
                    + '    </div>'
                    + '    <span class="text-[11px] text-on-surface-variant whitespace-nowrap">Expires: ' + v.endDate + '</span>'
                    + '  </div>'
                    + conditionsHtml
                    + '</div>';
        }

        document.getElementById('btnShowVoucherList').addEventListener('click', function () {
            var modal = document.getElementById('voucherListModal');
            var body = document.getElementById('voucherListBody');
            modal.classList.remove('hidden');
            modal.classList.add('flex');
            body.innerHTML = '<p class="text-center text-on-surface-variant text-[13px]">Loading...</p>';

            fetch('${pageContext.request.contextPath}/checkout', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'},
                body: 'action=listVouchers'
            })
                    .then(function (response) {
                        return response.json();
                    })
                    .then(function (data) {
                        if (!data.success || !data.vouchers || data.vouchers.length === 0) {
                            body.innerHTML = '<p class="text-center text-on-surface-variant text-[13px]">There are currently no available vouchers.</p>';
                            return;
                        }
                        body.innerHTML = data.vouchers.map(renderVoucherItem).join('');
                        if (window.lucide)
                            lucide.createIcons();

                        body.querySelectorAll('.btn-copy-voucher').forEach(function (btn) {
                            btn.addEventListener('click', function () {
                                var code = btn.getAttribute('data-code');
                                navigator.clipboard.writeText(code).then(function () {
                                    showToast('Copied code ' + code, false);
                                });
                            });
                        });
                    })
                    .catch(function () {
                        body.innerHTML = '<p class="text-center text-red-500 text-[13px]">Could not load vouchers.</p>';
                    });
        });

        function closeVoucherListModal() {
            var modal = document.getElementById('voucherListModal');
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        }
        document.getElementById('btnCloseVoucherList').addEventListener('click', closeVoucherListModal);
        document.getElementById('voucherListModal').addEventListener('click', function (e) {
            if (e.target === this)
                closeVoucherListModal();
        });

        document.getElementById('checkout-form').addEventListener('submit', function (e) {
            var fullname = document.getElementById('checkoutFullname').value.trim();
            var phone = document.getElementById('checkoutPhone').value.trim();
            var street = document.getElementById('checkoutStreet').value.trim();
            var ward = document.getElementById('checkoutWard').value.trim();
            var city = document.getElementById('checkoutCity').value.trim();

            if (!fullname || !phone || !street || !ward || !city) {
                e.preventDefault();
                showInputError('You do not have an address yet. Please add a shipping address before checkout.');
                return false;
            }

            var error = validateAddressInput(fullname, phone, city, ward, street);
            if (error) {
                e.preventDefault();
                showInputError(error);
                return false;
            }

            e.preventDefault();
            syncLocalAddressesFromDom();

            const modal = document.getElementById('confirmOrderModal');
            if (modal) {
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            }
        });

        function closeOrderConfirmModal() {
            const modal = document.getElementById('confirmOrderModal');
            if (modal) {
                modal.classList.add('hidden');
                modal.classList.remove('flex');
            }
        }

        const btnCancelOrder = document.getElementById('btnCancelOrder');
        if (btnCancelOrder) {
            btnCancelOrder.addEventListener('click', closeOrderConfirmModal);
        }

        const btnCloseOrderConfirm = document.getElementById('btnCloseOrderConfirm');
        if (btnCloseOrderConfirm) {
            btnCloseOrderConfirm.addEventListener('click', closeOrderConfirmModal);
        }

        const confirmOrderModalOverlay = document.getElementById('confirmOrderModal');
        if (confirmOrderModalOverlay) {
            confirmOrderModalOverlay.addEventListener('click', function (e) {
                if (e.target === confirmOrderModalOverlay) {
                    closeOrderConfirmModal();
                }
            });
        }

        const btnConfirmOrder = document.getElementById('btnConfirmOrder');
        if (btnConfirmOrder) {
            btnConfirmOrder.addEventListener('click', function () {
                saveDeletedAddressIds();
                closeOrderConfirmModal();
                document.getElementById('checkout-form').submit();
            });
        }
    </script>

</body>
<%@ include file="/views/layout/homepage/footer.jsp" %>

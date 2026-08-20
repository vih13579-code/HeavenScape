<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/views/layout/homepage/header.jsp" %>

<%@ include file="/views/layout/common/toast.jsp" %>

<style>
    .hs-primary-button { background:#C92127; color:#fff; border-radius:9999px; transition: background .15s, transform .15s; text-align:center; }
    .hs-primary-button:hover { background:#8E171B; }
    .hs-cart-card { background:#fff; border:1px solid #E3E3E6; border-radius:12px; }
    .hs-summary-card { background:#fff; border:1px solid #E3E3E6; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,.04); }
    .hs-modal-card { border-radius:12px; box-shadow:0 20px 50px rgba(0,0,0,.2); }
</style>

    <main class="fhs-page-inner min-h-[716px] text-on-surface">

        <div class="mb-10 md:mb-12">
            <h1 class="text-[28px] md:text-[32px] font-bold text-primary mb-2">Your Cart</h1>
            <p class="text-lg text-on-surface-variant">
                You have <span id="cart-heading-count">${empty totalQuantity ? 0 : totalQuantity}</span> items in your cart.
            </p>
        </div>

        <c:choose>
            <c:when test="${empty cartItems}">
                <div
                    class="w-full flex flex-col items-center justify-center py-20 space-y-6 text-center">
                    <i data-lucide="shopping-cart" class="w-16 h-16 text-outline-variant"></i>
                    <p class="text-2xl text-[#5C5C5F]">Your cart is empty</p>
                    <a href="${pageContext.request.contextPath}/home"
                       class="hs-primary-button px-8 py-3 font-semibold">
                        Continue Shopping
                    </a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="grid grid-cols-12 gap-6">
                    <div class="col-span-12 lg:col-span-8 space-y-6" id="cart-list">
                        <c:forEach var="item" items="${cartItems}">

                            <div class="hs-cart-card p-6 flex flex-col sm:flex-row items-center sm:items-stretch gap-6
                                 transition-transform duration-200 ease-out hover:-translate-y-0.5"
                                 id="cart-item-${item.cartItemID}" data-stock="${item.stockQuantity}">

                                <div
                                    class="w-32 h-48 flex-shrink-0 overflow-hidden rounded bg-surface-container-low border border-outline-variant">
                                    <c:choose>
                                        <c:when test="${not empty item.thumbnail}">
                                            <img class="w-full h-full object-cover"
                                                 src="${item.thumbnailFirst}" alt="${item.title}" />
                                        </c:when>
                                        <c:otherwise>
                                            <div
                                                class="w-full h-full flex items-center justify-center text-outline-variant">
                                                <i data-lucide="book-open" class="w-10 h-10"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="flex-grow space-y-1">
                                    <a
                                        href="${pageContext.request.contextPath}/products?id=${item.bookID}">
                                        <h3
                                            class="font-headline-sm text-2xl font-semibold text-primary hover:underline">
                                            ${item.title}</h3>
                                    </a>
                                    <p class="text-sm text-on-surface-variant">Author:
                                        ${item.authorsDisplay}</p>
                                    <p class="text-base text-primary font-semibold mt-2">
                                        <fmt:formatNumber value="${item.price}" type="number"
                                                          groupingUsed="true" /> VND
                                    </p>
                                </div>

                                <div class="flex flex-col items-center md:items-end gap-4">
                                    <c:choose>
                                        <c:when test="${item.stockQuantity == 0}">
                                            <span
                                                class="text-xs font-bold text-white bg-red-500 px-3 py-1 rounded-full">Out of Stock</span>
                                            <div
                                                class="flex items-center border border-outline-variant rounded overflow-hidden bg-surface-container-low opacity-50">
                                                <button
                                                    class="px-3 py-1 font-bold cursor-not-allowed"
                                                    disabled>−</button>
                                                <span
                                                    class="px-4 py-1 text-base border-x border-outline-variant"
                                                    id="qty-${item.cartItemID}">${item.quantity}</span>
                                                <button
                                                    class="px-3 py-1 font-bold cursor-not-allowed"
                                                    disabled>+</button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div
                                                class="flex items-center border border-outline-variant rounded overflow-hidden bg-surface-container-lowest">
                                                <button
                                                    class="px-3 py-1 hover:bg-surface-container-low transition-colors font-bold"
                                                    onclick="updateQty(${item.cartItemID}, ${item.quantity - 1})">−</button>
                                                <span
                                                    class="px-4 py-1 text-base border-x border-outline-variant"
                                                    id="qty-${item.cartItemID}">${item.quantity}</span>
                                                <button
                                                    class="px-3 py-1 hover:bg-surface-container-low transition-colors font-bold"
                                                    onclick="updateQty(${item.cartItemID}, ${item.quantity + 1})">+</button>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="text-right">
                                        <p class="text-xs text-on-surface-variant">Subtotal</p>
                                        <p class="font-headline-sm text-xl font-semibold text-primary"
                                           id="subtotal-item-${item.cartItemID}">
                                            <fmt:formatNumber value="${item.subtotal}" type="number"
                                                              groupingUsed="true" /> VND
                                        </p>
                                    </div>

                                    <button
                                        class="text-[#D32F2F] hover:bg-[#ffdad6]/20 p-2 rounded-full transition-all duration-200"
                                        onclick="removeItem(${item.cartItemID})"
                                        title="Remove from Cart">
                                        <i data-lucide="trash-2" class="w-5 h-5"></i>
                                    </button>

                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="col-span-12 lg:col-span-4">
                        <div class="hs-summary-card p-6 md:p-8 sticky top-28 space-y-6">

                            <h2
                                class="font-headline-md text-3xl font-semibold text-primary border-b border-outline-variant pb-4">
                                Order Summary</h2>

                            <div class="space-y-4">
                                <div class="flex justify-between items-center text-base">
                                    <span class="text-on-surface-variant">
                                        Subtotal (<span id="item-count">${totalQuantity}</span> items)
                                    </span>
                                    <span class="font-semibold" id="summary-subtotal">
                                        <fmt:formatNumber value="${subtotal}" type="number"
                                                          groupingUsed="true" /> VND
                                    </span>
                                </div>
                            </div>

                            <p class="text-[12px] text-on-surface-variant -mt-2">
                                You can enter a voucher code during checkout.
                            </p>

                            <div class="border-t border-outline-variant pt-6">
                                <div class="flex justify-between items-end mb-8">
                                    <span class="font-headline-sm text-xl font-semibold text-primary">Total</span>
                                    <p class="font-headline-md text-primary font-semibold text-3xl"
                                       id="summary-total">
                                        <fmt:formatNumber value="${total}" type="number"
                                                          groupingUsed="true" /> VND
                                    </p>
                                </div>

                                <c:set var="hasInStock" value="false" />
                                <c:forEach var="item" items="${cartItems}">
                                    <c:if test="${item.stockQuantity > 0}">
                                        <c:set var="hasInStock" value="true" />
                                    </c:if>
                                </c:forEach>

                                <div id="checkout-btn-wrap">
                                    <c:choose>
                                        <c:when test="${hasInStock}">
                                            <a id="checkout-link"
                                               href="${pageContext.request.contextPath}/checkout">
                                                <button id="checkout-btn" class="hs-primary-button w-full py-4
                                                        font-semibold text-base transition-all duration-200
                                                        flex items-center justify-center gap-3 active:scale-95">
                                                    Proceed to Checkout
                                                    <i data-lucide="arrow-right" class="w-4 h-4"></i>
                                                </button>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <button id="checkout-btn"
                                                    class="w-full bg-gray-300 text-gray-500 py-4 rounded-xl
                                                    font-bold text-xl cursor-not-allowed flex items-center justify-center gap-3" disabled>
                                                CHECKOUT (OUT OF STOCK)
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div
                                class="pt-4 flex items-center gap-2 justify-center text-on-surface-variant text-xs">
                                <i data-lucide="shield-check" class="w-4 h-4"></i>
                                100% safe and secure checkout
                            </div>

                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <!-- Confirmation Modal -->
    <div id="confirmModal"
         class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[9999]">
        <div class="hs-modal-card bg-white w-full max-w-[450px] mx-5 p-6 relative">
            <button type="button"
                    class="absolute top-3 right-4 text-2xl hover:text-gray-500 close-confirm">×</button>

            <h3 class="text-xl font-bold mb-4" id="confirmTitle">Confirm Action</h3>
            <p class="text-gray-600 mb-6" id="confirmMessage">Are you sure you want to continue?</p>

            <div class="flex justify-end gap-3">
                <button type="button"
                        class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100 close-confirm">
                    Cancel
                </button>
                <button type="button" id="confirmAction"
                        class="hs-primary-button px-4 py-2 hover:opacity-90">
                    Confirm
                </button>
            </div>
        </div>
    </div>

    <script>
        const CART_URL = '${pageContext.request.contextPath}/cart';

        function formatPrice(amount) {
            return Number(amount).toLocaleString('en-US') + ' VND';
        }

        // Update lại số tiền và số lượng trên giao diện
        function updateSummary(data) {
            function setText(id, text) {
                const elem = document.getElementById(id);
                if (elem)
                    elem.textContent = text;
            }
            setText('summary-subtotal', formatPrice(data.subtotal));
            setText('summary-total', formatPrice(data.total));
            setText('item-count', data.cartCount);
            setText('cart-heading-count', data.cartCount);
            setText('cart-count', data.cartCount);
        }

        // Update số lượng tăng giảm bằng AJAX
        function updateQty(cartItemID, newQty) {
            if (newQty < 1) {
                return removeItem(cartItemID);
            }

            const card = document.getElementById('cart-item-' + cartItemID);
            const stock = parseInt(card.getAttribute('data-stock'), 10);
            if (newQty > stock) {
                showToast('Stock limit reached', true);
                return;
            }

            fetch(CART_URL, {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=update&cartItemID=' + cartItemID + '&quantity=' + newQty
            })
                    .then(function (res) {
                        return res.json();
                    })
                    .then(function (data) {
                        if (!data.ok) {
                            showToast(data.message || 'An error occurred', true);
                            return;
                        }

                        document.getElementById('qty-' + cartItemID).textContent = newQty;
                        document.getElementById('subtotal-item-' + cartItemID).textContent = formatPrice(data.itemSubtotal);

                        const buttons = card.querySelectorAll('button');
                        buttons[0].setAttribute('onclick', 'updateQty(' + cartItemID + ',' + (newQty - 1) + ')');
                        buttons[1].setAttribute('onclick', 'updateQty(' + cartItemID + ',' + (newQty + 1) + ')');

                        buttons[1].disabled = (newQty >= stock);
                        buttons[1].classList.toggle('opacity-40', newQty >= stock);
                        buttons[1].classList.toggle('cursor-not-allowed', newQty >= stock);
                        buttons[0].disabled = false;

                        updateSummary(data);
                        if (newQty >= stock) {
                            showToast('Stock limit reached (' + stock + ' books)', true);
                        } else {
                            showToast('Quantity updated');
                        }
                    })
                    .catch(function (err) {
                        console.error(err);
                        showToast('Could not connect to the server', true);
                    });
        }

        // Remove Item khỏi giỏ hàng
        function removeItem(cartItemID) {
            openConfirmModal('Remove Item', 'Are you sure you want to remove this item from your cart?', function () {
                fetch(CART_URL, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'action=remove&cartItemID=' + cartItemID
                })
                        .then(function (res) {
                            return res.json();
                        })
                        .then(function (data) {
                            if (data.ok) {
                                location.reload();
                            } else {
                                showToast(data.message || 'An error occurred', true);
                            }
                        })
                        .catch(function (err) {
                            console.error(err);
                            showToast('Could not connect to the server', true);
                        });
            });
        }

        // Kiểm tra nút bấm tăng giảm khi tải xong trang
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('[data-stock]').forEach(function (card) {
                const id = card.id.replace('cart-item-', '');
                const stock = parseInt(card.getAttribute('data-stock'), 10);
                const qty = parseInt(document.getElementById('qty-' + id).textContent, 10);
                const buttons = card.querySelectorAll('button');
                if (buttons.length >= 2) {
                    buttons[1].disabled = (qty >= stock);
                    buttons[1].classList.toggle('opacity-40', qty >= stock);
                    buttons[1].classList.toggle('cursor-not-allowed', qty >= stock);
                }
            });
        });

        // Popup Modal Confirm
        let pendingAction = null;

        function openConfirmModal(title, message, action) {
            document.getElementById('confirmTitle').textContent = title;
            document.getElementById('confirmMessage').textContent = message;
            pendingAction = action;

            const modal = document.getElementById('confirmModal');
            if (modal) {
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            }
        }

        function closeConfirmModal() {
            const modal = document.getElementById('confirmModal');
            if (modal) {
                modal.classList.add('hidden');
                modal.classList.remove('flex');
            }
            pendingAction = null;
        }

        const confirmActionBtn = document.getElementById('confirmAction');
        if (confirmActionBtn) {
            confirmActionBtn.addEventListener('click', function () {
                if (pendingAction) {
                    pendingAction();
                }
                closeConfirmModal();
            });
        }

        document.querySelectorAll('.close-confirm').forEach(function (btn) {
            btn.addEventListener('click', closeConfirmModal);
        });

        const confirmModalElem = document.getElementById('confirmModal');
        if (confirmModalElem) {
            confirmModalElem.addEventListener('click', function (e) {
                if (e.target === confirmModalElem) {
                    closeConfirmModal();
                }
            });
        }
    </script>

<%@ include file="/views/layout/homepage/footer.jsp" %>

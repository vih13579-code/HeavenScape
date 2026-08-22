<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<style>
    .fhs-cart-page {
        --fhs-red: #C92127;
        --fhs-red-hover: #A8191F;
        --fhs-bg: #F0F0F0;
        --fhs-card: #FFFFFF;
        --fhs-text: #333333;
        --fhs-muted: #777777;
        --fhs-border: #E6E6E6;
        --fhs-green: #2F8F46;
        font-family: Arial, Helvetica, sans-serif;
        color: var(--fhs-text);
        padding-top: 18px;
        padding-bottom: 28px;
    }

    .fhs-cart-title {
        display: flex;
        align-items: baseline;
        gap: 8px;
        margin: 0 0 14px;
        font-size: 20px;
        line-height: 1.3;
        font-weight: 700;
        text-transform: uppercase;
        color: #333;
    }

    .fhs-cart-title-count {
        font-size: 14px;
        font-weight: 400;
        text-transform: none;
        color: #555;
    }

    .fhs-cart-layout {
        display: grid;
        grid-template-columns: minmax(0, 1fr) 360px;
        gap: 18px;
        align-items: start;
    }

    .fhs-cart-card,
    .fhs-cart-summary {
        background: var(--fhs-card);
        border-radius: 8px;
        box-shadow: 0 1px 2px rgba(0,0,0,.04);
    }

    .fhs-cart-list-head {
        display: grid;
        grid-template-columns: minmax(260px, 1fr) 118px 140px 42px;
        gap: 12px;
        align-items: center;
        padding: 13px 20px;
        border-bottom: 1px solid var(--fhs-border);
        font-size: 13px;
        font-weight: 600;
        color: #555;
    }

    .fhs-cart-list-head span:nth-child(2),
    .fhs-cart-list-head span:nth-child(3) {
        text-align: center;
    }

    .fhs-cart-item {
        display: grid;
        grid-template-columns: minmax(260px, 1fr) 118px 140px 42px;
        gap: 12px;
        align-items: center;
        padding: 16px 20px;
        border-bottom: 1px solid var(--fhs-border);
    }

    .fhs-cart-item:last-child {
        border-bottom: 0;
    }

    .fhs-cart-product {
        display: flex;
        gap: 16px;
        align-items: flex-start;
        min-width: 0;
    }

    .fhs-cart-cover {
        width: 92px;
        height: 122px;
        flex: 0 0 92px;
        border: 1px solid #EFEFEF;
        border-radius: 4px;
        overflow: hidden;
        background: #FAFAFA;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .fhs-cart-cover img {
        width: 100%;
        height: 100%;
        object-fit: contain;
    }

    .fhs-cart-cover-placeholder {
        color: #AAA;
    }

    .fhs-cart-info {
        min-width: 0;
        padding-top: 2px;
    }

    .fhs-cart-name {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        font-size: 14px;
        line-height: 1.45;
        font-weight: 500;
        color: #333;
        transition: color .15s ease;
    }

    .fhs-cart-name:hover {
        color: var(--fhs-red);
    }

    .fhs-cart-author {
        margin-top: 5px;
        font-size: 12px;
        color: var(--fhs-muted);
    }

    .fhs-cart-unit-price {
        margin-top: 12px;
        font-size: 15px;
        font-weight: 700;
        color: var(--fhs-red);
    }

    .fhs-stock-badge {
        display: inline-block;
        margin-top: 8px;
        padding: 3px 8px;
        border-radius: 4px;
        background: #F4F4F4;
        color: #8A8A8A;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
    }

    .fhs-qty-wrap {
        display: flex;
        justify-content: center;
    }

    .hs-stepper {
        display: inline-flex;
        align-items: center;
        height: 32px;
        border: 1px solid #CFCFCF;
        border-radius: 4px;
        overflow: hidden;
        background: #fff;
    }

    .hs-stepper button {
        width: 31px;
        height: 30px;
        border: 0;
        background: #fff;
        color: #555;
        font-size: 18px;
        line-height: 1;
        cursor: pointer;
    }

    .hs-stepper button:hover:not(:disabled) {
        color: var(--fhs-red);
        background: #FAFAFA;
    }

    .hs-stepper button:disabled {
        cursor: not-allowed;
        color: #C5C5C5;
    }

    .hs-stepper span {
        width: 38px;
        text-align: center;
        font-size: 14px;
        font-weight: 600;
        color: #333;
        border-left: 1px solid #E5E5E5;
        border-right: 1px solid #E5E5E5;
    }

    .fhs-cart-subtotal {
        text-align: center;
        white-space: nowrap;
        font-size: 15px;
        font-weight: 700;
        color: var(--fhs-red);
    }

    .hs-remove-btn {
        width: 34px;
        height: 34px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 4px;
        color: #777;
        transition: all .15s ease;
        justify-self: center;
    }

    .hs-remove-btn:hover {
        color: var(--fhs-red);
        background: #FFF1F1;
    }

    .fhs-cart-summary {
        position: sticky;
        top: 18px;
        overflow: hidden;
    }

    .fhs-summary-row {
        display: flex;
        justify-content: space-between;
        gap: 16px;
        padding: 14px 18px;
        font-size: 14px;
        color: #555;
        border-bottom: 1px solid var(--fhs-border);
    }

    .fhs-summary-row strong {
        color: #333;
        text-align: right;
    }

    .fhs-summary-total {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        gap: 12px;
        padding: 16px 18px;
    }

    .fhs-summary-total-label {
        font-size: 15px;
        font-weight: 700;
        color: #333;
    }

    .fhs-summary-total-value {
        font-size: 21px;
        line-height: 1.15;
        font-weight: 700;
        color: var(--fhs-red);
        text-align: right;
        white-space: nowrap;
    }

    .fhs-checkout-area {
        padding: 0 18px 16px;
    }

    #checkout-btn {
        width: 100%;
        min-height: 46px;
        border-radius: 6px;
        background: var(--fhs-red);
        color: #fff;
        font-size: 14px;
        font-weight: 700;
        text-transform: uppercase;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        transition: background .15s ease;
    }

    #checkout-btn:hover:not(:disabled) {
        background: var(--fhs-red-hover);
    }

    .fhs-secure-note {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        padding: 0 18px 16px;
        color: #777;
        font-size: 11px;
    }

    .fhs-empty-cart {
        background: #fff;
        border-radius: 8px;
        min-height: 360px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 14px;
        text-align: center;
        padding: 40px 20px;
    }

    .fhs-empty-cart p {
        font-size: 16px;
        font-weight: 600;
        color: #555;
    }

    .fhs-continue-btn {
        min-width: 190px;
        padding: 12px 20px;
        border-radius: 6px;
        background: var(--fhs-red);
        color: white;
        font-size: 13px;
        font-weight: 700;
        text-transform: uppercase;
    }

    .hs-modal-card {
        border-radius: 8px;
        box-shadow: 0 20px 50px rgba(0,0,0,.2);
    }

    @media (max-width: 1024px) {
        .fhs-cart-layout {
            grid-template-columns: 1fr;
        }

        .fhs-cart-summary {
            position: static;
        }
    }

    @media (max-width: 680px) {
        .fhs-cart-page {
            padding-top: 14px;
        }

        .fhs-cart-list-head {
            display: none;
        }

        .fhs-cart-item {
            grid-template-columns: minmax(0, 1fr) 34px;
            gap: 12px;
            align-items: start;
        }

        .fhs-cart-product {
            grid-column: 1;
        }

        .fhs-qty-wrap {
            grid-column: 1;
            justify-content: flex-start;
            padding-left: 108px;
            margin-top: -43px;
        }

        .fhs-cart-subtotal {
            grid-column: 1;
            text-align: left;
            padding-left: 108px;
            margin-top: 12px;
        }

        .hs-remove-btn {
            grid-column: 2;
            grid-row: 1;
        }

        .fhs-cart-cover {
            width: 92px;
            height: 122px;
            flex-basis: 92px;
        }

        .fhs-summary-total-value {
            font-size: 19px;
        }
    }
</style>

<main class="fhs-page-inner fhs-cart-page">
    <h1 class="fhs-cart-title">
        Shopping Cart
        <span class="fhs-cart-title-count">(<span id="cart-heading-count">${empty totalQuantity ? 0 : totalQuantity}</span> products)</span>
    </h1>

    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="fhs-empty-cart">
                <i data-lucide="shopping-cart" class="w-16 h-16 text-gray-300"></i>
                <p>Your shopping cart is empty.</p>
                <a href="${pageContext.request.contextPath}/home" class="fhs-continue-btn">Continue Shopping</a>
            </div>
        </c:when>

        <c:otherwise>
            <c:set var="hasInStock" value="false" />
            <c:forEach var="item" items="${cartItems}">
                <c:if test="${item.stockQuantity > 0}">
                    <c:set var="hasInStock" value="true" />
                </c:if>
            </c:forEach>

            <div class="fhs-cart-layout">
                <section class="fhs-cart-card">
                    <div class="fhs-cart-list-head">
                        <span>Product</span>
                        <span>Quantity</span>
                        <span>Subtotal</span>
                        <span></span>
                    </div>

                    <div id="cart-list">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="fhs-cart-item" id="cart-item-${item.cartItemID}" data-stock="${item.stockQuantity}">
                                <div class="fhs-cart-product">
                                    <a class="fhs-cart-cover" href="${pageContext.request.contextPath}/products?id=${item.bookID}">
                                        <c:choose>
                                            <c:when test="${not empty item.thumbnail}">
                                                <img src="${item.thumbnailFirst}" alt="${item.title}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="fhs-cart-cover-placeholder">
                                                    <i data-lucide="book-open" class="w-8 h-8"></i>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </a>

                                    <div class="fhs-cart-info">
                                        <a href="${pageContext.request.contextPath}/products?id=${item.bookID}" class="fhs-cart-name">
                                            ${item.title}
                                        </a>
                                        <p class="fhs-cart-author">${item.authorsDisplay}</p>
                                        <p class="fhs-cart-unit-price">
                                            <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true" /> VND
                                        </p>
                                        <c:if test="${item.stockQuantity == 0}">
                                            <span class="fhs-stock-badge">Out of Stock</span>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="fhs-qty-wrap">
                                    <c:choose>
                                        <c:when test="${item.stockQuantity == 0}">
                                            <div class="hs-stepper opacity-50">
                                                <button type="button" disabled>−</button>
                                                <span id="qty-${item.cartItemID}">${item.quantity}</span>
                                                <button type="button" disabled>+</button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="hs-stepper">
                                                <button type="button" onclick="updateQty(${item.cartItemID}, ${item.quantity - 1})">−</button>
                                                <span id="qty-${item.cartItemID}">${item.quantity}</span>
                                                <button type="button" onclick="updateQty(${item.cartItemID}, ${item.quantity + 1})">+</button>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="fhs-cart-subtotal" id="subtotal-item-${item.cartItemID}">
                                    <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true" /> VND
                                </div>

                                <button type="button" class="hs-remove-btn" onclick="removeItem(${item.cartItemID})" title="Remove from cart">
                                    <i data-lucide="trash-2" class="w-5 h-5"></i>
                                </button>
                            </div>
                        </c:forEach>
                    </div>

                </section>

                <aside class="fhs-cart-summary">
                    <div class="fhs-summary-row">
                        <span>Subtotal (<span id="item-count">${totalQuantity}</span> items)</span>
                        <strong id="summary-subtotal">
                            <fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true" /> VND
                        </strong>
                    </div>

                    <div class="fhs-summary-total">
                        <span class="fhs-summary-total-label">Total</span>
                        <span class="fhs-summary-total-value" id="summary-total">
                            <fmt:formatNumber value="${total}" type="number" groupingUsed="true" /> VND
                        </span>
                    </div>

                    <div class="fhs-checkout-area" id="checkout-btn-wrap">
                        <c:choose>
                            <c:when test="${hasInStock}">
                                <a id="checkout-link" href="${pageContext.request.contextPath}/checkout" class="block">
                                    <button type="button" id="checkout-btn">
                                        Proceed to Checkout
                                    </button>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button type="button" id="checkout-btn" disabled
                                        style="background:#D5D5D5;color:#8A8A8A;cursor:not-allowed;">
                                    Out of Stock
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="fhs-secure-note">
                        <i data-lucide="shield-check" class="w-4 h-4"></i>
                        Secure checkout
                    </div>
                </aside>
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
                    class="px-4 py-2 bg-[#C92127] text-white rounded-md hover:bg-[#A8191F]">
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

                        const stepper = card.querySelector('.hs-stepper');
                        const buttons = stepper ? stepper.querySelectorAll('button') : [];
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
                const stepper = card.querySelector('.hs-stepper');
                        const buttons = stepper ? stepper.querySelectorAll('button') : [];
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

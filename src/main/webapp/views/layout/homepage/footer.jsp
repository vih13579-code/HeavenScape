<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="hs-site-footer">
    <div class="hs-container hs-footer-grid">
        <div class="hs-footer-brand flex flex-col gap-4">
            <div class="hs-footer-brand-mark">HEAVENSCAPE</div>
            <p class="max-w-sm text-sm leading-6 text-on-surface-variant">
                Online bookstore for authentic titles, convenient ordering and a simple reading journey.
            </p>
         </div>

        <div>
            <h2 class="hs-footer-title">Explore</h2>
            <nav class="hs-footer-links" aria-label="Explore HeavenScape">
                <a href="${pageContext.request.contextPath}/products">All Books</a>
                <a href="${pageContext.request.contextPath}/products?sort=newest">New Releases</a>
                <a href="${pageContext.request.contextPath}/products?sort=popular">Best Sellers</a>
                <a href="${pageContext.request.contextPath}/wishlist">Wishlist</a>
            </nav>
        </div>

        <div>
            <h2 class="hs-footer-title">Customer Support</h2>
            <nav class="hs-footer-links" aria-label="Customer Support">
                <a href="${pageContext.request.contextPath}/profile/order-history">Order History</a>
                <a href="#">Shipping Policy</a>
                <a href="#">Returns & Refunds</a>
                <a href="#">Privacy Policy</a>
            </nav>
        </div>

        <div>
            <h2 class="hs-footer-title">Contact</h2>
            <ul class="hs-footer-links">
                <li class="flex items-center gap-2"><i data-lucide="phone" class="icon-sm"></i> 1900 8386</li>
                <li class="flex items-center gap-2"><i data-lucide="mail" class="icon-sm"></i> support@heavenscape.vn</li>
                <li class="flex items-start gap-2"><i data-lucide="map-pin" class="icon-sm mt-1"></i> Can Tho, Vietnam</li>
            </ul>
        </div>
    </div>

    <div class="hs-container hs-footer-bottom">© 2026 HeavenScape. All rights reserved.</div>
</footer>

<button class="fixed bottom-6 right-6 w-12 h-12 bg-primary text-white rounded-full shadow-lg flex items-center justify-center hover:-translate-y-1 transition-all opacity-0 pointer-events-none z-[100]"
        id="scrollToTop" aria-label="Scroll to top">
    <i data-lucide="arrow-up" class="icon-lg"></i>
</button>

<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
<script>
    if (window.lucide) {
        lucide.createIcons();
    }

    (function () {
        const scrollButton = document.getElementById('scrollToTop');
        if (!scrollButton) {
            return;
        }

        function updateScrollButton() {
            const visible = window.scrollY > 300;
            scrollButton.classList.toggle('opacity-0', !visible);
            scrollButton.classList.toggle('pointer-events-none', !visible);
        }

        scrollButton.addEventListener('click', function () {
            window.scrollTo({top: 0, behavior: 'smooth'});
        });
        window.addEventListener('scroll', updateScrollButton, {passive: true});
        updateScrollButton();
    })();
</script>
</body>
</html>

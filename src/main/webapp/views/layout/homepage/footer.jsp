<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="hs-site-footer">
    <div class="hs-container hs-footer-grid">
        <div class="hs-footer-brand flex flex-col gap-4">
            <img src="${pageContext.request.contextPath}/assets/images/logo/logoHS_2.png"
                 alt="HeavenScape">
            <p class="max-w-sm text-sm leading-6 text-on-surface-variant">
                An online bookstore offering authentic titles, fast delivery,
                and a refined reading experience for every reader.
            </p>
        </div>

        <div>
            <h2 class="hs-footer-title">Explore</h2>
            <nav class="hs-footer-links" aria-label="Explore HeavenScape">
                <a href="${pageContext.request.contextPath}/products">All Books</a>
                <a href="${pageContext.request.contextPath}/products?sort=newest">New Releases</a>
                <a href="${pageContext.request.contextPath}/products?sort=popular">Featured Books</a>
            </nav>
        </div>

        <div>
            <h2 class="hs-footer-title">Support</h2>
            <nav class="hs-footer-links" aria-label="Customer Support">
                <a href="#">Shopping Guide</a>
                <a href="${pageContext.request.contextPath}/profile/order-history">Track Order</a>
                <a href="#">Returns and Refunds</a>
                <a href="#">Privacy Policy</a>
            </nav>
        </div>

        <div>
            <h2 class="hs-footer-title">Contact</h2>
            <ul class="hs-footer-links">
                <li class="flex items-center gap-2"><i data-lucide="phone" class="icon-sm"></i> 19006656</li>
                <li class="flex items-center gap-2"><i data-lucide="mail" class="icon-sm"></i> support@heavenscape.vn</li>
                <li class="flex items-start gap-2"><i data-lucide="map-pin" class="icon-sm mt-1"></i> Can Tho, Vietnam</li>
            </ul>
        </div>
    </div>

    <div class="hs-container hs-footer-bottom">
        © 2026 HeavenScape. All rights reserved.
    </div>
</footer>

<button class="fixed bottom-6 right-6 w-12 h-12 bg-primary text-white rounded-full shadow-lg flex items-center justify-center hover:-translate-y-1 transition-all opacity-0 pointer-events-none z-[100]"
        id="scrollToTop" aria-label="Scroll to top">
    <i data-lucide="arrow-up" class="icon-lg"></i>
</button>

<script src="${pageContext.request.contextPath}/assets/js/lucide.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>

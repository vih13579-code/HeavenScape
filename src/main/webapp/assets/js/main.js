/* ============================================
   HeavenScape - Main JavaScript
   ============================================ */

// Khởi tạo Lucide Icons
lucide.createIcons();

// ---------- Scroll To Top Button ----------
const scrollBtn = document.getElementById('scrollToTop');

window.addEventListener('scroll', function () {
    if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
        scrollBtn.classList.add('opacity-100', 'pointer-events-auto');
        scrollBtn.classList.remove('opacity-0', 'pointer-events-none');
    } else {
        scrollBtn.classList.remove('opacity-100', 'pointer-events-auto');
        scrollBtn.classList.add('opacity-0', 'pointer-events-none');
    }
});

scrollBtn.addEventListener('click', () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
});
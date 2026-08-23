<%-- 
    Document   : toast
    Created on : Jun 7, 2026, 12:56:45 PM
    Author     : DUY MINH
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div id="toast"
     class="fixed bottom-6 right-6 z-[70] flex items-center gap-3 px-4 py-3
            bg-white rounded-xl border shadow-card-hover
            transform translate-y-16 opacity-0 pointer-events-none"
     style="border-color:#D9D9DC; min-width:260px; transition: all 0.3s ease;">
    <span class="material-symbols-outlined" style="color:#2E7D32;" id="toastIcon">check_circle</span>
    <span class="text-sm font-medium" style="color:#1B1B1B;" id="toastMsg">Action completed successfully!</span>
    <button onclick="hideToast()" class="ml-auto" style="color:#727783;">
        <span class="material-symbols-outlined" style="font-size:18px;">close</span>
    </button>
</div>

<script>
function showToast(msg, isError, isWarning) {
    isError   = isError   || false;
    isWarning = isWarning || false;
    const toast = document.getElementById('toast');
    const icon  = document.getElementById('toastIcon');
    document.getElementById('toastMsg').textContent = msg;
    if (isError) {
        icon.textContent = 'error';
        icon.style.color = '#D32F2F';
    } else if (isWarning) {
        icon.textContent = 'warning';
        icon.style.color = '#E65100';
    } else {
        icon.textContent = 'check_circle';
        icon.style.color = '#2E7D32';
    }
    toast.classList.remove('translate-y-16', 'opacity-0', 'pointer-events-none');
    toast.classList.add('translate-y-0', 'opacity-100');
    setTimeout(hideToast, 4500);
}
function hideToast() {
    const toast = document.getElementById('toast');
    toast.classList.add('translate-y-16', 'opacity-0', 'pointer-events-none');
    toast.classList.remove('translate-y-0', 'opacity-100');
}

// Flash message từ server
// Dùng dataset thay vì nhúng thẳng vào JS string để tránh XSS / ký tự đặc biệt phá vỡ chuỗi
<c:if test="${not empty successMessage}">
    document.getElementById('toast').dataset.flashMsg   = '${fn:escapeXml(successMessage)}';
    document.getElementById('toast').dataset.flashType  = 'success';
    <c:remove var="successMessage" scope="session"/>
</c:if>
<c:if test="${not empty warningMessage}">
    document.getElementById('toast').dataset.flashMsg   = '${fn:escapeXml(warningMessage)}';
    document.getElementById('toast').dataset.flashType  = 'warning';
    <c:remove var="warningMessage" scope="session"/>
</c:if>
<c:if test="${not empty errorMessage}">
    document.getElementById('toast').dataset.flashMsg   = '${fn:escapeXml(errorMessage)}';
    document.getElementById('toast').dataset.flashType  = 'error';
    <c:remove var="errorMessage" scope="session"/>
</c:if>
window.addEventListener('load', function () {
    var t = document.getElementById('toast');
    if (!t.dataset.flashMsg) return;
    var type = t.dataset.flashType;
    if (type === 'warning') showToast(t.dataset.flashMsg, false, true);
    else showToast(t.dataset.flashMsg, type === 'error');
});
</script>

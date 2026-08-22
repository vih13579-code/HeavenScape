<%-- 
    Document   : reset-password
    Created on : Jun 12, 2026, 1:07:22 PM
    Author     : DUY MINH
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Reset Password | HeavenScape</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "error": "#D32F2F",
                            "on-primary": "#FFFFFF",
                            "outline": "#8F8F92",
                            "on-surface-variant": "#5C5C5F",
                            "on-error-container": "#93000A",
                            "surface": "#FFFFFF",
                            "primary-container": "#FDE8E9",
                            "on-primary-container": "#7A0F13",
                            "primary": "#C92127",
                            "on-surface": "#1B1B1B",
                            "background": "#F7F7F8",
                            "outline-variant": "#D9D9DC",
                            "error-container": "#FFDAD6",
                            "surface-container-low": "#F7F7F8",
                            "success": "#2E7D32",
                            "success-container": "#DDF4DE",
                            "on-success-container": "#0B3D0E"
                        },
                        "spacing": {
                            "stack-sm": "12px", "margin-mobile": "16px",
                            "margin-desktop": "64px", "base": "8px",
                            "stack-md": "24px", "stack-lg": "48px"
                        },
                        "fontFamily": {
                            "headline-xl": ["Inter"], "headline-sm": ["Inter"],
                            "headline-lg": ["Inter"], "body-md": ["Inter"],
                            "body-lg": ["Inter"], "headline-lg-mobile": ["Inter"],
                            "body-sm": ["Inter"], "headline-md": ["Inter"],
                            "label-sm": ["Inter"], "label-md": ["Inter"]
                        },
                        "fontSize": {
                            "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                            "headline-sm": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                            "headline-lg": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                            "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                            "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                            "headline-lg-mobile": ["28px", {"lineHeight": "36px", "fontWeight": "700"}],
                            "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                            "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                            "label-sm": ["12px", {"lineHeight": "16px", "fontWeight": "500"}],
                            "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.01em", "fontWeight": "600"}]
                        }
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Inter', sans-serif; background-color: #F7F7F8; }
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                vertical-align: middle;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(16px); }
                to   { opacity: 1; transform: translateY(0); }
            }
            .animate-fade-in { animation: fadeIn 0.4s ease both; }

            /* Strength bar */
            .strength-bar { height: 4px; border-radius: 2px; transition: all 0.3s; }
        </style>
        <link href="${pageContext.request.contextPath}/assets/css/auth.css" rel="stylesheet">
    </head>

    <body class="bg-background text-on-background min-h-screen flex flex-col">

        <header class="w-full px-4 md:px-margin-desktop h-16 flex items-center justify-between bg-transparent">
            <a href="${pageContext.request.contextPath}/home">
                <img src="${pageContext.request.contextPath}/assets/images/logo/logoHS_2.png"
                     alt="HeavenScape Logo" class="w-[220px] mb-3"/>
            </a>
            <div class="flex items-center gap-2 text-on-surface-variant text-sm">
                <span class="material-symbols-outlined text-primary">help_outline</span>
                <span class="hidden md:inline">Help</span>
            </div>
        </header>

        <main class="flex-grow flex items-center justify-center px-margin-mobile py-stack-lg">
            <div class="w-full max-w-md animate-fade-in">
                <div class="bg-surface border border-outline-variant/30 rounded-xl p-stack-lg shadow-[0_8px_30px_rgb(21,101,192,0.08)]">

                    <div class="flex justify-center mb-stack-md">
                        <div class="w-20 h-20 bg-primary-container rounded-full flex items-center justify-center shadow-inner">
                            <span class="material-symbols-outlined text-4xl text-on-primary"
                                  style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24;">key</span>
                        </div>
                    </div>

                    <div class="text-center mb-stack-lg">
                        <h1 class="font-headline-lg text-headline-lg text-on-surface mb-2">Reset Password</h1>
                        <p class="font-body-md text-body-md text-on-surface-variant">
                            Create a new password for the account<br>
                            <strong class="text-primary">${sessionScope.otp_email}</strong>
                        </p>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="mb-4 p-3 bg-error-container text-on-error-container border-l-4 border-error font-body-sm text-body-sm rounded-lg flex items-center gap-2">
                            <span class="material-symbols-outlined text-error text-[18px]">error</span>
                            <span>${errorMessage}</span>
                        </div>
                    </c:if>

                    <form class="space-y-stack-md" action="${pageContext.request.contextPath}/reset-password" method="POST"
                          id="resetForm" novalidate>

                        <%-- New Password --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="newPassword">New Password <span class="text-error text-xs">*</span></label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">lock</span>
                                <input class="w-full pl-10 pr-12 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="newPassword" name="newPassword" type="password"
                                       placeholder="At least 8 characters" required autofocus>
                                <button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-outline hover:text-primary transition-colors toggle-pw">
                                    <span class="material-symbols-outlined">visibility</span>
                                </button>
                            </div>
                            <%-- Thanh độ mạnh --%>
                            <div class="flex gap-1 mt-1" id="strengthBars">
                                <div class="strength-bar flex-1 bg-outline-variant" id="bar1"></div>
                                <div class="strength-bar flex-1 bg-outline-variant" id="bar2"></div>
                                <div class="strength-bar flex-1 bg-outline-variant" id="bar3"></div>
                                <div class="strength-bar flex-1 bg-outline-variant" id="bar4"></div>
                            </div>
                            <p class="font-body-sm text-body-sm text-on-surface-variant" id="strengthLabel"></p>
                        </div>

                        <%-- Confirm Password --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="confirmPassword">Confirm Password <span class="text-error text-xs">*</span></label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">lock_clock</span>
                                <input class="w-full pl-10 pr-12 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="confirmPassword" name="confirmPassword" type="password"
                                       placeholder="Re-enter your password" required>
                                <button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-outline hover:text-primary transition-colors toggle-pw">
                                    <span class="material-symbols-outlined">visibility</span>
                                </button>
                            </div>
                            <p class="font-body-sm hidden" id="matchMsg"></p>
                        </div>

                        <%-- Hint --%>
                        <p class="font-body-sm text-body-sm text-on-surface-variant text-[13px]">
                            <span class="material-symbols-outlined text-[14px] align-middle">info</span>
                            Use 8–15 characters with uppercase and lowercase letters and a number.
                        </p>

                        <button type="button" id="submitBtn"
                                class="w-full h-14 bg-primary text-on-primary font-headline-sm text-headline-sm rounded-lg shadow-md hover:bg-primary-container active:scale-[0.98] transition-all flex items-center justify-center gap-2">
                            <span class="material-symbols-outlined">check_circle</span>
                            Confirm Reset
                        </button>
                    </form>
                </div>
            </div>
        </main>

        <%-- Modal xác nhận trước khi đổi mật khẩu (thao tác quan trọng) --%>
        <div id="confirmModal" class="hidden fixed inset-0 z-50 flex items-center justify-center px-4" style="background:rgba(7,30,39,0.5)">
            <div class="bg-surface rounded-xl p-stack-lg max-w-sm w-full shadow-xl animate-fade-in">
                <div class="flex justify-center mb-4">
                    <div class="w-14 h-14 bg-primary-container rounded-full flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl text-on-primary">warning</span>
                    </div>
                </div>
                <h2 class="font-headline-sm text-headline-sm text-on-surface text-center mb-2">Confirm Password Reset</h2>
                <p class="font-body-sm text-body-sm text-on-surface-variant text-center mb-stack-md">
                    After confirmation, your current password will no longer work. Are you sure you want to continue?
                </p>
                <div class="flex gap-3">
                    <button type="button" id="cancelConfirmBtn"
                            class="flex-1 h-12 rounded-lg border border-outline-variant font-label-md text-label-md text-on-surface-variant hover:bg-surface-container-low transition-all">
                        Cancel
                    </button>
                    <button type="button" id="proceedConfirmBtn"
                            class="flex-1 h-12 rounded-lg bg-primary text-on-primary font-label-md text-label-md hover:bg-primary-container transition-all">
                        Confirm
                    </button>
                </div>
            </div>
        </div>

        <footer class="flex flex-col md:flex-row justify-between items-center w-full px-4 md:px-margin-desktop py-stack-md gap-4 bg-surface-container-low mt-auto">
            <img src="${pageContext.request.contextPath}/assets/images/logo/logoHS_2.png" alt="HeavenScape Logo" class="w-[220px] mb-3"/>
            <div class="flex gap-6 text-on-surface-variant">
                <a class="font-body-sm text-body-sm hover:text-primary transition-colors" href="#">Terms of Use</a>
                <a class="font-body-sm text-body-sm hover:text-primary transition-colors" href="#">Privacy Policy</a>
                <a class="font-body-sm text-body-sm hover:text-primary transition-colors" href="#">Contact</a>
            </div>
            <div class="font-label-sm text-label-sm text-on-surface-variant">© 2026 HeavenScape. All rights reserved.</div>
        </footer>

        <script>
            // Toggle hiện/ẩn mật khẩu
            document.querySelectorAll('.toggle-pw').forEach(btn => {
                btn.addEventListener('click', function () {
                    const input = this.previousElementSibling
                            ? this.parentElement.querySelector('input')
                            : null;
                    const inp = this.closest('.relative').querySelector('input');
                    const icon = this.querySelector('span');
                    if (inp.type === 'password') {
                        inp.type = 'text';
                        icon.innerText = 'visibility_off';
                    } else {
                        inp.type = 'password';
                        icon.innerText = 'visibility';
                    }
                });
            });

            // Thanh độ mạnh mật khẩu
            const newPwInput = document.getElementById('newPassword');
            const bars = [document.getElementById('bar1'), document.getElementById('bar2'),
                          document.getElementById('bar3'), document.getElementById('bar4')];
            const strengthLabel = document.getElementById('strengthLabel');
            const colors = ['#D32F2F', '#FFA000', '#F97316', '#2E7D32'];
            const labels = ['Very Weak', 'Weak', 'Medium', 'Strong'];

            function calcStrength(pw) {
                let score = 0;
                if (pw.length >= 8) score++;
                if (/[A-Z]/.test(pw)) score++;
                if (/[a-z]/.test(pw)) score++;
                if (/\d/.test(pw)) score++;
                return score;
            }

            newPwInput.addEventListener('input', function () {
                const score = calcStrength(this.value);
                bars.forEach((b, i) => {
                    b.style.backgroundColor = i < score ? colors[score - 1] : '#D9D9DC';
                });
                strengthLabel.textContent = this.value ? labels[score - 1] || '' : '';
                strengthLabel.style.color = this.value ? colors[score - 1] : '';
                checkMatch();
            });

            // Kiểm tra khớp mật khẩu
            const confirmInput = document.getElementById('confirmPassword');
            const matchMsg = document.getElementById('matchMsg');

            function checkMatch() {
                if (!confirmInput.value) { matchMsg.classList.add('hidden'); return; }
                if (newPwInput.value === confirmInput.value) {
                    matchMsg.textContent = '✓ Passwords match';
                    matchMsg.className = 'font-body-sm text-[#2E7D32]';
                } else {
                    matchMsg.textContent = '✗ Passwords do not match';
                    matchMsg.className = 'font-body-sm text-error';
                }
            }
            confirmInput.addEventListener('input', checkMatch);

            // Bấm "Confirm Reset" → validate rồi hiện modal xác nhận (thao tác quan trọng)
            const resetForm     = document.getElementById('resetForm');
            const confirmModal  = document.getElementById('confirmModal');
            const cancelBtn     = document.getElementById('cancelConfirmBtn');
            const proceedBtn    = document.getElementById('proceedConfirmBtn');

            document.getElementById('submitBtn').addEventListener('click', function () {
                const pw = newPwInput.value;
                const confirmVal = confirmInput.value;

                if (!pw || !confirmVal) {
                    matchMsg.textContent = '✗ Please complete both password fields.';
                    matchMsg.className = 'font-body-sm text-error';
                    matchMsg.classList.remove('hidden');
                    return;
                }
                if (pw !== confirmVal) {
                    matchMsg.textContent = '✗ Passwords do not match';
                    matchMsg.className = 'font-body-sm text-error';
                    matchMsg.classList.remove('hidden');
                    confirmInput.focus();
                    return;
                }
                confirmModal.classList.remove('hidden');
            });

            cancelBtn.addEventListener('click', function () {
                confirmModal.classList.add('hidden');
            });

            proceedBtn.addEventListener('click', function () {
                confirmModal.classList.add('hidden');
                const btn = document.getElementById('submitBtn');
                btn.innerHTML = '<span class="material-symbols-outlined" style="animation:spin 1s linear infinite;display:inline-block">sync</span> Processing...';
                btn.disabled = true;
                btn.classList.add('opacity-80');
                resetForm.submit();
            });
        </script>
    </body>
</html>

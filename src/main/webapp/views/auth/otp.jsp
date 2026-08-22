<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>OTP Verification | HeavenScape</title>
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
                            "success": "#2E7D32",
                            "success-container": "#DDF4DE",
                            "on-success-container": "#0B3D0E"
                        },
                        "spacing": {
                            "stack-sm": "12px",
                            "margin-mobile": "16px",
                            "margin-desktop": "64px",
                            "base": "8px",
                            "stack-md": "24px",
                            "stack-lg": "48px"
                        },
                        "fontFamily": {
                            "headline-xl": ["Inter"],
                            "headline-sm": ["Inter"],
                            "headline-lg": ["Inter"],
                            "body-md": ["Inter"],
                            "body-lg": ["Inter"],
                            "headline-lg-mobile": ["Inter"],
                            "body-sm": ["Inter"],
                            "headline-md": ["Inter"],
                            "label-sm": ["Inter"],
                            "label-md": ["Inter"]
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
            body {
                font-family: 'Inter', sans-serif;
                background-color: #F7F7F8;
            }
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                vertical-align: middle;
            }
            .otp-input {
                width: 100%;
                aspect-ratio: 1;
                text-align: center;
                font-size: 24px;
                font-weight: 700;
                border: 2px solid #D9D9DC;
                border-radius: 12px;
                outline: none;
                transition: all 0.2s;
                background: #fff;
                color: #1B1B1B;
                -moz-appearance: textfield;
            }
            .otp-input::-webkit-outer-spin-button,
            .otp-input::-webkit-inner-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }
            .otp-input:focus {
                border-color: #C92127;
                box-shadow: 0 0 0 3px rgba(0,77,153,0.15);
            }
            .otp-input.filled {
                border-color: #C92127;
                background: #F7F7F8;
            }
            .otp-input.error  {
                border-color: #D32F2F;
                background: #ffdad6;
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(16px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .animate-fade-in {
                animation: fadeIn 0.4s ease both;
            }
            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }
            .animate-spin {
                animation: spin 1s linear infinite;
                display: inline-block;
            }
        </style>
        <link href="${pageContext.request.contextPath}/assets/css/auth.css" rel="stylesheet">
    </head>

    <body class="bg-background text-on-background min-h-screen flex flex-col">
        <header class="w-full px-4 md:px-margin-desktop h-16 flex items-center justify-between bg-transparent">
            <div class="font-bold text-primary">
                <img src="${pageContext.request.contextPath}/assets/images/logo/logoHS_2.png" alt="HeavenScape Logo" class="w-[220px] mb-3"/>
            </div>
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
                                  style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24;">shield_person</span>
                        </div>
                    </div>

                    <div class="text-center mb-stack-lg">
                        <h1 class="font-headline-lg text-headline-lg text-on-surface mb-2">OTP Verification</h1>
                        <p class="font-body-md text-body-md text-on-surface-variant">
                            A verification code was sent to<br>
                            <strong class="text-primary">${sessionScope.otp_email}</strong>
                        </p>
                    </div>

                    <c:if test="${not empty sessionScope.otp_error}">
                        <div class="mb-4 p-3 bg-error-container text-on-error-container border-l-4 border-error font-body-sm text-body-sm rounded-lg flex items-center gap-2">
                            <span class="material-symbols-outlined text-error text-[18px]">error</span>
                            <span>${sessionScope.otp_error}</span>
                        </div>
                        <% session.removeAttribute("otp_error"); %>
                    </c:if>

                    <c:if test="${not empty sessionScope.otp_success}">
                        <div class="mb-4 p-3 bg-success-container text-on-success-container border-l-4 border-[#2E7D32] font-body-sm text-body-sm rounded-lg flex items-center gap-2">
                            <span class="material-symbols-outlined text-[18px]" style="color:#2E7D32">check_circle</span>
                            <span>${sessionScope.otp_success}</span>
                        </div>
                        <% session.removeAttribute("otp_success");%>
                    </c:if>

                    <form class="space-y-stack-lg" id="otp-form"
                          action="${pageContext.request.contextPath}/otp" method="POST">
                        <input type="hidden" name="action" value="verify">
                        <input type="hidden" name="otp" id="otpHidden">

                        <div class="flex justify-between gap-2 md:gap-4" id="otp-inputs">
                            <input class="otp-input" maxlength="1" placeholder="-" type="number">
                            <input class="otp-input" maxlength="1" placeholder="-" type="number">
                            <input class="otp-input" maxlength="1" placeholder="-" type="number">
                            <input class="otp-input" maxlength="1" placeholder="-" type="number">
                            <input class="otp-input" maxlength="1" placeholder="-" type="number">
                            <input class="otp-input" maxlength="1" placeholder="-" type="number">
                        </div>

                        <p class="text-error text-center font-body-sm text-body-sm hidden" id="otp-error-msg">
                            Please enter all 6 digits of the OTP.
                        </p>

                        <div class="space-y-stack-sm">
                            <button id="submitBtn"
                                    class="w-full h-14 bg-primary text-on-primary font-headline-sm text-headline-sm rounded-lg shadow-md hover:bg-primary-container active:scale-[0.98] transition-all flex items-center justify-center gap-2"
                                    type="submit">
                                Confirm
                            </button>

                            <div class="text-center py-base">
                                <p class="font-body-sm text-body-sm text-on-surface-variant" id="countdown-wrapper">
                                    Please wait <span class="text-primary font-semibold" id="countdown-timer">05:00</span> before requesting another code.
                                </p>
                                <p class="font-body-sm text-body-sm text-on-surface-variant hidden" id="resend-wrapper">
                                    Didn't receive the code?
                                    <a class="text-primary font-label-md font-semibold hover:underline transition-colors ml-1"
                                       href="#" id="resend-link">Resend Code Now</a>
                                </p>
                            </div>
                        </div>
                    </form>

                    <form id="resend-form" action="${pageContext.request.contextPath}/otp" method="POST" class="hidden">
                        <input type="hidden" name="action" value="resend">
                    </form>

                    <p class="mt-stack-md text-center font-body-sm text-body-sm text-on-surface-variant">
                        <c:choose>
                            <c:when test="${sessionScope.otp_flow == 'change_email'}">
                                <a href="${pageContext.request.contextPath}/profile" class="text-primary hover:underline">← Back to Profile</a>
                            </c:when>
                            <c:when test="${sessionScope.otp_flow == 'forgot'}">
                                <a href="${pageContext.request.contextPath}/forgot-password" class="text-primary hover:underline">← Back to Forgot Password</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/register" class="text-primary hover:underline">← Back to Registration</a>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
        </main>
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
            const inputs = document.querySelectorAll('.otp-input');
            const otpHidden = document.getElementById('otpHidden');
            const submitBtn = document.getElementById('submitBtn');
            const errorMsg = document.getElementById('otp-error-msg');
            const countdownWrap = document.getElementById('countdown-wrapper');
            const countdownEl = document.getElementById('countdown-timer');
            const resendWrap = document.getElementById('resend-wrapper');
            const resendLink = document.getElementById('resend-link');
            const resendForm = document.getElementById('resend-form');
            inputs.forEach((input, i) => {
                input.addEventListener('input', (e) => {
                    const val = e.target.value.replace(/\D/g, '');
                    e.target.value = val ? val[0] : '';
                    if (val && i < inputs.length - 1)
                        inputs[i + 1].focus();
                    updateState();
                });
                input.addEventListener('keydown', (e) => {
                    if (e.key === 'Backspace' && !input.value && i > 0) {
                        inputs[i - 1].focus();
                        inputs[i - 1].value = '';
                        updateState();
                    }
                });
                input.addEventListener('keypress', (e) => {
                    if (!/[0-9]/.test(e.key))
                        e.preventDefault();
                });
                input.addEventListener('paste', (e) => {
                    e.preventDefault();
                    const pasted = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g, '');
                    if (pasted.length === 6) {
                        inputs.forEach((b, idx) => {
                            b.value = pasted[idx] || '';
                        });
                        inputs[5].focus();
                        updateState();
                    }
                });
            });

            function updateState() {
                const val = [...inputs].map(b => b.value).join('');
                otpHidden.value = val;
                inputs.forEach(b => b.classList.toggle('filled', b.value !== ''));
            }
            let timerInterval;
            function startTimer(totalSec) {
                clearInterval(timerInterval);
                countdownWrap.classList.remove('hidden');
                resendWrap.classList.add('hidden');
                let remaining = totalSec;
                timerInterval = setInterval(() => {
                    remaining--;
                    const m = Math.floor(remaining / 60);
                    const s = remaining % 60;
                    countdownEl.textContent = String(m).padStart(2, '0') + ':' + String(s).padStart(2, '0');
                    if (remaining <= 0) {
                        clearInterval(timerInterval);
                        countdownWrap.classList.add('hidden');
                        resendWrap.classList.remove('hidden');
                    }
                }, 1000);
            }
            startTimer(300);
            resendLink.addEventListener('click', (e) => {
                e.preventDefault();
                resendForm.submit();
            });

            document.getElementById('otp-form').addEventListener('submit', (e) => {
                const otpCode = [...inputs].map(i => i.value).join('');
                if (otpCode.length < 6) {
                    e.preventDefault();
                    errorMsg.classList.remove('hidden');
                    inputs.forEach(b => b.classList.add('error'));
                } else {
                    errorMsg.classList.add('hidden');
                    inputs.forEach(b => b.classList.remove('error'));
                    submitBtn.innerHTML = '<span class="material-symbols-outlined animate-spin text-xl">sync</span> Verifying...';
                    submitBtn.disabled = true;
                    submitBtn.classList.add('opacity-80');
                }
            });
        </script>
    </body>
</html>

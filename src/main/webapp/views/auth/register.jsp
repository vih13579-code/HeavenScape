<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Create an Account | HeavenScape</title>
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
                            "surface-dim": "#E9E9EB",
                            "tertiary": "#F5A623",
                            "error": "#D32F2F",
                            "primary-fixed": "#FFDAD9",
                            "secondary": "#F97316",
                            "surface-container-high": "#EBEBED",
                            "on-primary": "#FFFFFF",
                            "outline": "#8F8F92",
                            "on-surface-variant": "#5C5C5F",
                            "on-error-container": "#93000A",
                            "on-tertiary": "#402D00",
                            "on-secondary": "#FFFFFF",
                            "on-primary-container": "#7A0F13",
                            "surface": "#FFFFFF",
                            "surface-container": "#F1F1F3",
                            "on-background": "#1B1B1B",
                            "warning": "#F9A825",
                            "surface-container-low": "#F7F7F8",
                            "surface-bright": "#FFFFFF",
                            "primary-container": "#FDE8E9",
                            "primary": "#C92127",
                            "on-surface": "#1B1B1B",
                            "background": "#F7F7F8",
                            "surface-variant": "#EFE0DF",
                            "secondary-container": "#FFE3C2",
                            "surface-container-lowest": "#FFFFFF",
                            "success": "#2E7D32",
                            "outline-variant": "#D9D9DC",
                            "error-container": "#FFDAD6"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "0.75rem",
                            "full": "9999px"
                        },
                        "spacing": {
                            "stack-sm": "12px",
                            "margin-mobile": "16px",
                            "margin-desktop": "64px",
                            "base": "8px",
                            "stack-md": "24px",
                            "stack-lg": "48px",
                            "gutter": "24px"
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
                    },
                },
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
            .login-card-shadow {
                box-shadow: 0 10px 25px -5px rgba(21, 101, 192, 0.08), 0 8px 10px -6px rgba(21, 101, 192, 0.08);
            }
        </style>
        <link href="${pageContext.request.contextPath}/assets/css/auth.css" rel="stylesheet">
    </head>
    <body class="min-h-screen flex flex-col">

        <header class="w-full px-4 md:px-margin-desktop h-16 flex items-center justify-between bg-transparent">
            <div class="font-bold text-primary">
                <img src="${pageContext.request.contextPath}/assets/images/logo/logoHS_2.png" alt="HeavenScape Logo" class="w-[220px] mb-3"/>
            </div>
            <div class="flex items-center gap-2 text-on-surface-variant text-sm">
                <span class="material-symbols-outlined text-primary">help_outline</span>
                <span class="hidden md:inline">Help</span>
            </div>
        </header>

        <main class="flex-grow flex items-center justify-center px-4 py-stack-lg">
            <div class="w-full max-w-[1100px] grid md:grid-cols-2 bg-surface rounded-[32px] overflow-hidden login-card-shadow">

                <%-- Form bên trái --%>
                <div class="p-8 md:p-12 flex flex-col justify-center order-2 md:order-1">
                    <div class="mb-6 text-center md:text-left">
                        <h1 class="font-headline-lg-mobile md:font-headline-lg text-headline-lg-mobile md:text-headline-lg text-on-surface mb-2">Create a New Account</h1>
                        <p class="font-body-md text-body-md text-on-surface-variant">Please complete the form to join HeavenScape.</p>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="mb-4 p-4 bg-error-container text-on-error-container border-l-4 border-error font-body-sm text-body-sm rounded-lg flex items-center gap-2">
                            <span class="material-symbols-outlined text-error">error</span>
                            <span>${errorMessage}</span>
                        </div>
                    </c:if>

                    <form id="registerForm" class="space-y-stack-md" action="${pageContext.request.contextPath}/register" method="POST" novalidate>

                        <%-- Full Name --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="fullname">Full Name</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">person</span>
                                <input class="w-full pl-10 pr-4 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="fullname" name="fullname" placeholder="John Doe" type="text">
                            </div>
                            <p class="text-error font-body-sm text-body-sm hidden input-error-msg" id="err-fullname"></p>
                        </div>

                        <%-- Email --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="email">Email</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">mail</span>
                                <input class="w-full pl-10 pr-4 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="email" name="email" placeholder="name@example.com" type="email">
                            </div>
                            <p class="text-error font-body-sm text-body-sm hidden input-error-msg" id="err-email"></p>
                        </div>

                        <%-- Phone Number --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="phone">Phone Number</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">call</span>
                                <input class="w-full pl-10 pr-4 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="phone" name="phone" placeholder="0912345678" type="tel">
                            </div>
                            <p class="text-error font-body-sm text-body-sm hidden input-error-msg" id="err-phone"></p>
                        </div>

                        <%-- Password --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="password">Password</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">lock</span>
                                <input class="w-full pl-10 pr-12 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="password" name="password" placeholder="••••••••" type="password">
                                <button class="absolute right-3 top-1/2 -translate-y-1/2 text-outline hover:text-primary transition-colors togglePasswordBtn" type="button" data-target="password">
                                    <span class="material-symbols-outlined">visibility</span>
                                </button>
                            </div>
                            <p class="text-error font-body-sm text-body-sm hidden input-error-msg" id="err-password"></p>
                        </div>

                        <%-- Confirm Password --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="confirmPassword">Confirm Password</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">enhanced_encryption</span>
                                <input class="w-full pl-10 pr-12 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="confirmPassword" name="confirmPassword" placeholder="••••••••" type="password">
                                <button class="absolute right-3 top-1/2 -translate-y-1/2 text-outline hover:text-primary transition-colors togglePasswordBtn" type="button" data-target="confirmPassword">
                                    <span class="material-symbols-outlined">visibility</span>
                                </button>
                            </div>
                            <p class="text-error font-body-sm text-body-sm hidden input-error-msg" id="err-confirm"></p>
                        </div>

                        <button class="w-full py-4 bg-primary text-on-primary font-headline-sm text-headline-sm rounded-lg hover:bg-primary-container active:opacity-80 transition-all shadow-md mt-4" type="submit">
                            Sign Up
                        </button>
                    </form>

                    <p class="mt-stack-lg text-center font-body-md text-body-md text-on-surface-variant">
                        Already have an account?
                        <a class="text-primary font-bold hover:underline transition-all" href="${pageContext.request.contextPath}/login">Log In</a>
                    </p>
                </div>

                <%-- Ảnh bên phải --%>
                <div class="relative hidden md:block overflow-hidden bg-primary-container order-1 md:order-2">
                    <img alt="Modern library" class="absolute inset-0 w-full h-full object-cover mix-blend-overlay opacity-60"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuA4wVc1Ts1NhWSFAjgUkkPPMo_QKOzJ9i1P-RJTZFOE8KjmheXWTqDtoNEoySdXCVnzZeasVx_mA7ojf2ItOK7GN4YWadNAbJRtx9LIAn1GkwYKWHVWn9z1hUeeSNnr1I3DBgVIsoG8cXOchKQBXDJJE8btanB4WvyhkKXSU48lCzGxkmKSTtiO4SAV6mLExsHZIZAQ1BhsqqUQ2AUiTsh9q_9QnVAlbHJRUjRlh575NNY1mxOwYWafrW_fKk8jrqJQWMeV6BvD2oPo">
                    <div class="relative z-10 h-full flex flex-col justify-end p-12 text-on-primary">
                        <h2 class="font-headline-lg text-headline-lg mb-4">Begin a New Journey of Discovery.</h2>
                        <p class="font-body-lg text-body-lg opacity-90 max-w-md">
                            Create an account today for personalized recommendations and your own saved book collection.
                        </p>
                        <div class="mt-8 flex gap-2">
                            <div class="w-2 h-2 rounded-full bg-white/40"></div>
                            <div class="w-2 h-2 rounded-full bg-white"></div>
                            <div class="w-2 h-2 rounded-full bg-white/40"></div>
                        </div>
                    </div>
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
            // Bật/tắt hiện mật khẩu
            document.querySelectorAll('.togglePasswordBtn').forEach(button => {
                button.addEventListener('click', function () {
                    const targetInput = document.getElementById(this.getAttribute('data-target'));
                    const icon = this.querySelector('span');
                    if (targetInput.type === 'password') {
                        targetInput.type = 'text';
                        icon.innerText = 'visibility_off';
                    } else {
                        targetInput.type = 'password';
                        icon.innerText = 'visibility';
                    }
                });
            });

            // Validation phía client
            document.getElementById('registerForm').addEventListener('submit', function (e) {
                let isValid = true;

                const fullname        = document.getElementById('fullname');
                const email           = document.getElementById('email');
                const phone           = document.getElementById('phone');
                const password        = document.getElementById('password');
                const confirmPassword = document.getElementById('confirmPassword');

                const emailRegex = /^[\w.+-]+@[\w-]+(\.[\w-]+)*\.[a-zA-Z]{2,}$/;
                const phoneRegex = /^(0[35789])\d{8}$/;

                // Delete lỗi cũ
                document.querySelectorAll('.input-error-msg').forEach(el => el.classList.add('hidden'));

                if (!fullname.value.trim()) {
                    showError('err-fullname', "Full name is required.");
                    isValid = false;
                } else if (fullname.value.trim().split(/\s+/).length < 2) {
                    showError('err-fullname', "Please enter a full name with at least two words.");
                    isValid = false;
                } else if (!/^[\p{L}\s]+$/u.test(fullname.value.trim())) {
                    showError('err-fullname', "Full name cannot contain numbers or special characters.");
                    isValid = false;
                }
                if (!email.value.trim()) {
                    showError('err-email', "Email is required.");
                    isValid = false;
                } else if (!emailRegex.test(email.value.trim())) {
                    showError('err-email', "Invalid email format.");
                    isValid = false;
                }
                if (!phone.value.trim()) {
                    showError('err-phone', "Phone number is required.");
                    isValid = false;
                } else if (!phoneRegex.test(phone.value.trim())) {
                    showError('err-phone', "Invalid phone number (10 digits, starting with 03, 05, 07, 08, or 09).");
                    isValid = false;
                }
                if (!password.value) {
                    showError('err-password', "Password is required.");
                    isValid = false;
                } else if (password.value.length < 6) {
                    showError('err-password', "Password must be at least 6 characters.");
                    isValid = false;
                }
                if (!confirmPassword.value) {
                    showError('err-confirm', "Please re-enter your password.");
                    isValid = false;
                } else if (password.value !== confirmPassword.value) {
                    showError('err-confirm', "Passwords do not match.");
                    isValid = false;
                }

                if (!isValid) e.preventDefault();
            });

            function showError(id, msg) {
                const el = document.getElementById(id);
                if (el) {
                    el.innerText = msg;
                    el.classList.remove('hidden');
                }
            }
        </script>
    </body>
</html>

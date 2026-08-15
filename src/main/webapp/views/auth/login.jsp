<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Log In | HeavenScape</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "surface-dim": "#c7dde9",
                            "tertiary": "#134aa4",
                            "error": "#D32F2F",
                            "primary-fixed": "#d6e3ff",
                            "secondary": "#705d00",
                            "on-tertiary-fixed": "#001945",
                            "surface-container-high": "#d5ecf8",
                            "on-primary": "#ffffff",
                            "outline": "#727783",
                            "on-surface-variant": "#424752",
                            "inverse-on-surface": "#dff4ff",
                            "on-error-container": "#93000a",
                            "on-tertiary": "#ffffff",
                            "on-secondary": "#ffffff",
                            "on-secondary-fixed-variant": "#544600",
                            "on-primary-container": "#dae5ff",
                            "surface": "#FFFFFF",
                            "on-tertiary-fixed-variant": "#00429c",
                            "surface-container": "#dbf1fe",
                            "on-background": "#071e27",
                            "tertiary-fixed": "#d9e2ff",
                            "warning": "#FFA000",
                            "surface-container-low": "#e6f6ff",
                            "surface-tint": "#005db7",
                            "surface-bright": "#f3faff",
                            "tertiary-container": "#3563be",
                            "primary-container": "#1565c0",
                            "primary": "#004d99",
                            "on-secondary-fixed": "#221b00",
                            "on-surface": "#071e27",
                            "on-primary-fixed": "#001b3d",
                            "background-alt": "#F5F7F9",
                            "surface-container-highest": "#cfe6f2",
                            "on-error": "#ffffff",
                            "background": "#f3faff",
                            "tertiary-fixed-dim": "#b0c6ff",
                            "surface-variant": "#cfe6f2",
                            "inverse-surface": "#1e333c",
                            "secondary-fixed": "#ffe16e",
                            "primary-fixed-dim": "#a9c7ff",
                            "secondary-container": "#fdd835",
                            "surface-container-lowest": "#ffffff",
                            "inverse-primary": "#a9c7ff",
                            "on-tertiary-container": "#dde5ff",
                            "secondary-fixed-dim": "#e8c41d",
                            "on-primary-fixed-variant": "#00468c",
                            "success": "#2E7D32",
                            "outline-variant": "#c2c6d4",
                            "on-secondary-container": "#705e00",
                            "error-container": "#ffdad6",
                            "success-container": "#E8F5E9",
                            "on-success-container": "#1B5E20"
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
                            "gutter": "24px",
                            "container-max": "1280px"
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
                background-color: #f3faff;
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
        <%@ include file="/views/layout/common/toast.jsp" %>

        <header class="w-full px-4 md:px-margin-desktop h-16 flex items-center justify-between bg-transparent">
            <div class="font-headline-md text-headline-md font-bold text-primary">
                <img src="${pageContext.request.contextPath}/assets/images/logo/logoHS_2.png"
                     alt="HeavenScape Logo" class="w-[220px] mb-3"/>
            </div>
            <div class="flex items-center gap-2 text-on-surface-variant font-body-sm text-body-sm">
                <span class="material-symbols-outlined text-primary">help_outline</span>
                <span class="hidden md:inline">Help</span>
            </div>
        </header>

        <main class="flex-grow flex items-center justify-center px-4 py-stack-lg">
            <div class="w-full max-w-[1100px] grid md:grid-cols-2 bg-surface rounded-[32px] overflow-hidden login-card-shadow">

                <div class="relative hidden md:block overflow-hidden bg-primary-container">
                    <img alt="Modern library" class="absolute inset-0 w-full h-full object-cover mix-blend-overlay opacity-60" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA4wVc1Ts1NhWSFAjgUkkPPMo_QKOzJ9i1P-RJTZFOE8KjmheXWTqDtoNEoySdXCVnzZeasVx_mA7ojf2ItOK7GN4YWadNAbJRtx9LIAn1GkwYKWHVWn9z1hUeeSNnr1I3DBgVIsoG8cXOchKQBXDJJE8btanB4WvyhkKXSU48lCzGxkmKSTtiO4SAV6mLExsHZIZAQ1BhsqqUQ2AUiTsh9q_9QnVAlbHJRUjRlh575NNY1mxOwYWafrW_fKk8jrqJQWMeV6BvD2oPo">
                    <div class="relative z-10 h-full flex flex-col justify-end p-12 text-on-primary">
                        <h2 class="font-headline-lg text-headline-lg mb-4">Discover the World, One Page at a Time.</h2>
                        <p class="font-body-lg text-body-lg opacity-90 max-w-md">
                            Join the HeavenScape community to discover exceptional books and a modern reading experience.
                        </p>
                        <div class="mt-8 flex gap-2">
                            <div class="w-2 h-2 rounded-full bg-white"></div>
                            <div class="w-2 h-2 rounded-full bg-white/40"></div>
                            <div class="w-2 h-2 rounded-full bg-white/40"></div>
                        </div>
                    </div>
                </div>

                <div class="p-8 md:p-16 flex flex-col justify-center">
                    <div class="mb-stack-lg text-center md:text-left">
                        <h1 class="font-headline-lg-mobile md:font-headline-lg text-headline-lg-mobile md:text-headline-lg text-on-surface mb-2">Welcome Back</h1>
                        <p class="font-body-md text-body-md text-on-surface-variant">Enter your details to access your account.</p>
                    </div>

                    <%-- Thông báo thành công (đăng ký / đặt lại mật khẩu thành công) --%>
                    <c:if test="${not empty sessionScope.register_success}">
                        <div class="mb-4 p-4 bg-success-container text-on-success-container border-l-4 border-success font-body-sm text-body-sm rounded-lg flex items-center gap-2">
                            <span class="material-symbols-outlined text-success">check_circle</span>
                            <span>${sessionScope.register_success}</span>
                        </div>
                        <% session.removeAttribute("register_success"); %>
                    </c:if>

                    <form class="space-y-stack-md" action="${pageContext.request.contextPath}/login" method="POST">
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="email">Email</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">mail</span>

                                <input class="w-full pl-10 pr-4 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none" 
                                       id="email" 
                                       name="email" 
                                       placeholder="name@example.com" 
                                       type="email" 
                                       value="${''}${not empty enteredEmail ? enteredEmail : cookie.savedEmail.value}" 
                                       required>
                            </div>
                        </div>

                        <div class="space-y-2">
                            <div class="flex justify-between items-center">
                                <label class="font-label-md text-label-md text-on-surface" for="password">Password</label>
                                <a class="font-label-sm text-label-sm text-primary hover:underline transition-all" href="${pageContext.request.contextPath}/forgot-password">Forgot Password?</a>
                            </div>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">lock</span>
                                <input class="w-full pl-10 pr-12 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none" id="password" name="password" placeholder="••••••••" type="password" required>
                                <button class="absolute right-3 top-1/2 -translate-y-1/2 text-outline hover:text-primary transition-colors" id="togglePasswordBtn" type="button">
                                    <span class="material-symbols-outlined">visibility</span>
                                </button>
                            </div>
                        </div>

                        <button class="w-full py-4 bg-primary text-on-primary font-headline-sm text-headline-sm rounded-lg hover:bg-primary-container active:opacity-80 transition-all shadow-md mt-4" type="submit">
                            Log In
                        </button>
                    </form>

                    <div class="relative my-stack-lg">
                        <div class="absolute inset-0 flex items-center">
                            <div class="w-full border-t border-outline-variant"></div>
                        </div>
                        <div class="relative flex justify-center text-body-sm text-label-sm">
                            <span class="px-4 bg-surface text-on-surface-variant font-body-sm">Or continue with</span>
                        </div>
                    </div>

                    <div class="w-full">
                        <button
                            type="button"
                            onclick="window.location.href = '${pageContext.request.contextPath}/auth/google/login'"
                            class="w-full flex items-center justify-center gap-3 py-3 bg-white border border-[#dadce0] rounded-lg hover:bg-[#f8f9fa] hover:shadow-md active:bg-[#f1f3f4] transition-all font-label-md text-label-md text-[#3c4043]"
                            style="font-family: 'Google Sans', Roboto, sans-serif; font-size: 14px; font-weight: 500; letter-spacing: 0.25px;"
                            >
                            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" class="w-5 h-5 flex-shrink-0">
                            <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
                            <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/>
                            <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/>
                            <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.18 1.48-4.97 2.31-8.16 2.31-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
                            <path fill="none" d="M0 0h48v48H0z"/>
                            </svg>
                            Continue with Google
                        </button>
                    </div>

                    <p class="mt-stack-lg text-center font-body-md text-body-md text-on-surface-variant">
                        Don't have an account? 
                        <a class="text-primary font-bold hover:underline transition-all" href="${pageContext.request.contextPath}/register">Sign Up Now</a>
                    </p>
                </div>
            </div>
        </main>

        <footer class="flex flex-col md:flex-row justify-between items-center w-full px-4 md:px-margin-desktop py-stack-md gap-4 bg-surface-container-low mt-auto">
            <img src="${pageContext.request.contextPath}/assets/images/logo/logoHS_2.png"
                 alt="HeavenScape Logo" class="w-[220px] mb-3"/>
            <div class="flex gap-6 text-on-surface-variant">
                <a class="font-body-sm text-body-sm hover:text-primary transition-colors" href="#">Terms of Use</a>
                <a class="font-body-sm text-body-sm hover:text-primary transition-colors" href="#">Privacy Policy</a>
                <a class="font-body-sm text-body-sm hover:text-primary transition-colors" href="#">Contact</a>
            </div>
            <div class="font-label-sm text-label-sm text-on-surface-variant">
                © 2026 HeavenScape. All rights reserved.
            </div>
        </footer>

        <script>
            document.getElementById('togglePasswordBtn')?.addEventListener('click', function () {
                const input = document.getElementById('password');
                const icon = this.querySelector('span');
                if (input.type === 'password') {
                    input.type = 'text';
                    icon.innerText = 'visibility_off';
                } else {
                    input.type = 'password';
                    icon.innerText = 'visibility';
                }
            });
        </script>
    </body>
</html>

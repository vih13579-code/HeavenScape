<%-- 
    Document   : forgot-password
    Created on : Jun 12, 2026, 1:06:12 PM
    Author     : DUY MINH
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Forgot Password | HeavenScape</title>
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
                            "on-primary": "#ffffff",
                            "outline": "#727783",
                            "on-surface-variant": "#424752",
                            "on-error-container": "#93000a",
                            "surface": "#FFFFFF",
                            "primary-container": "#1565c0",
                            "on-primary-container": "#dae5ff",
                            "primary": "#004d99",
                            "on-surface": "#071e27",
                            "background": "#f3faff",
                            "outline-variant": "#c2c6d4",
                            "error-container": "#ffdad6",
                            "surface-container-low": "#e6f6ff",
                            "success": "#2E7D32",
                            "success-container": "#E8F5E9",
                            "on-success-container": "#1B5E20"
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
            body { font-family: 'Inter', sans-serif; background-color: #f3faff; }
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                vertical-align: middle;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(16px); }
                to   { opacity: 1; transform: translateY(0); }
            }
            .animate-fade-in { animation: fadeIn 0.4s ease both; }
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

                    <%-- Icon --%>
                    <div class="flex justify-center mb-stack-md">
                        <div class="w-20 h-20 bg-primary-container rounded-full flex items-center justify-center shadow-inner">
                            <span class="material-symbols-outlined text-4xl text-on-primary"
                                  style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24;">lock_reset</span>
                        </div>
                    </div>

                    <%-- Tiêu đề --%>
                    <div class="text-center mb-stack-lg">
                        <h1 class="font-headline-lg text-headline-lg text-on-surface mb-2">Forgot Password</h1>
                        <p class="font-body-md text-body-md text-on-surface-variant">
                            Enter your registered email. We will send you an OTP for verification.
                        </p>
                    </div>

                    <%-- Thông báo lỗi từ server --%>
                    <c:if test="${not empty errorMessage}">
                        <div class="mb-4 p-3 bg-error-container text-on-error-container border-l-4 border-error font-body-sm text-body-sm rounded-lg flex items-center gap-2">
                            <span class="material-symbols-outlined text-error text-[18px]">error</span>
                            <span>${errorMessage}</span>
                        </div>
                    </c:if>

                    <%-- Form --%>
                    <form class="space-y-stack-md" action="${pageContext.request.contextPath}/forgot-password" method="POST">
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="email">Email Address</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">mail</span>
                                <input class="w-full pl-10 pr-4 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="email" name="email" type="email"
                                       placeholder="name@example.com"
                                       value="${not empty enteredEmail ? enteredEmail : ''}"
                                       required autofocus>
                            </div>
                        </div>

                        <button type="submit" id="submitBtn"
                                class="w-full h-14 bg-primary text-on-primary font-headline-sm text-headline-sm rounded-lg shadow-md hover:bg-primary-container active:scale-[0.98] transition-all flex items-center justify-center gap-2">
                            <span class="material-symbols-outlined">send</span>
                            Send Verification Code
                        </button>
                    </form>

                    <p class="mt-stack-md text-center font-body-sm text-body-sm text-on-surface-variant">
                        <a href="${pageContext.request.contextPath}/login" class="text-primary hover:underline">← Back to Login</a>
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
            // Loading state khi submit
            document.querySelector('form').addEventListener('submit', function () {
                const btn = document.getElementById('submitBtn');
                btn.innerHTML = '<span class="material-symbols-outlined animate-spin">sync</span> Sending...';
                btn.disabled = true;
                btn.classList.add('opacity-80');
            });
        </script>
    </body>
</html>

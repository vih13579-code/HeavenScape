<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <title>HeavenScape Admin - Add Staff Member</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "on-tertiary-fixed-variant": "#5C4200",
                            "background-alt": "#FFFFFF",
                            "on-secondary-container": "#7A3A00",
                            "tertiary": "#F5A623",
                            "tertiary-fixed-dim": "#F0C34D",
                            "primary-fixed-dim": "#FFB3B0",
                            "surface-tint": "#C92127",
                            "tertiary-fixed": "#FFE8A3",
                            "inverse-primary": "#FFB3B0",
                            "secondary": "#F97316",
                            "surface-container": "#F1F1F3",
                            "inverse-on-surface": "#F5F5F5",
                            "on-secondary": "#FFFFFF",
                            "on-primary-container": "#7A0F13",
                            "error": "#D32F2F",
                            "surface-variant": "#EFE0DF",
                            "on-error": "#FFFFFF",
                            "on-background": "#1B1B1B",
                            "surface-container-low": "#F7F7F8",
                            "on-tertiary": "#402D00",
                            "primary": "#C92127",
                            "tertiary-container": "#FFF3D6",
                            "error-container": "#FFDAD6",
                            "surface-container-lowest": "#FFFFFF",
                            "on-surface": "#1B1B1B",
                            "surface-container-highest": "#E3E3E6",
                            "on-tertiary-fixed": "#241A00",
                            "outline": "#8F8F92",
                            "surface-dim": "#E9E9EB",
                            "inverse-surface": "#303030",
                            "secondary-fixed-dim": "#FFB876",
                            "on-primary": "#FFFFFF",
                            "surface-container-high": "#EBEBED",
                            "secondary-container": "#FFE3C2",
                            "surface-bright": "#FFFFFF",
                            "on-surface-variant": "#5C5C5F",
                            "on-secondary-fixed-variant": "#7A3A00",
                            "on-primary-fixed": "#410006",
                            "warning": "#F9A825",
                            "primary-fixed": "#FFDAD9",
                            "background": "#F7F7F8",
                            "on-error-container": "#93000A",
                            "on-primary-fixed-variant": "#93000A",
                            "primary-container": "#FDE8E9",
                            "on-secondary-fixed": "#2B1700",
                            "outline-variant": "#D9D9DC",
                            "on-tertiary-container": "#402D00",
                            "surface": "#FFFFFF",
                            "success": "#2E7D32",
                            "secondary-fixed": "#FFDCC0"
                        }
                    }
                }
            }
        </script>
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                display: inline-block;
                vertical-align: middle;
            }
            body {
                font-family: 'Inter', sans-serif;
                background-color: #F7F7F8;
            }
            .glass-panel {
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }
            input:focus, select:focus, textarea:focus {
                outline: none;
                border-color: #F97316 !important;
                box-shadow: 0 0 0 2px rgba(21, 101, 192, 0.1);
            }
        </style>
    </head>
    <body class="text-on-surface">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <main class="min-h-screen ml-64">
            <div class="max-w-5xl mx-auto px-16 py-12">
                <div class="mb-8">
                    <a href="${pageContext.request.contextPath}/dashboard/account-management"
                       class="inline-flex items-center gap-1 text-sm text-on-surface-variant hover:text-primary transition-colors mb-4">
                        <span class="material-symbols-outlined text-base">arrow_back</span>
                        Back to Account Management
                    </a>
                    <h1 class="text-3xl font-bold text-on-surface mb-2">Add Staff Account</h1>
                    <p class="text-on-surface-variant">Enter the details to create a new account for the HeavenScape team.</p>
                </div>

                <section class="glass-panel rounded-xl shadow-sm p-8">
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-10">
                        <div class="space-y-6">
                            <h3 class="text-xl font-semibold text-on-surface flex items-center gap-2">
                                <span class="material-symbols-outlined text-primary">person</span>
                                Personal Information
                            </h3>
                            <div class="space-y-4">
                                <div class="flex flex-col gap-2">
                                    <label class="text-sm font-semibold text-on-surface">Full Name <span class="text-error">*</span></label>
                                    <input id="fullname" name="fullname"
                                           class="w-full h-12 px-4 rounded-lg border border-outline-variant bg-white text-base"
                                           placeholder="Full Name" type="text"/>
                                </div>
                                <div class="flex flex-col gap-2">
                                    <label class="text-sm font-semibold text-on-surface">Email Address <span class="text-error">*</span></label>
                                    <input id="email" name="email"
                                           class="w-full h-12 px-4 rounded-lg border border-outline-variant bg-white text-base"
                                           placeholder="example@heavenscape.vn" type="email"/>
                                </div>
                                <div class="flex flex-col gap-2">
                                    <label class="text-sm font-semibold text-on-surface">Phone Number <span class="text-error">*</span></label>
                                    <input id="phone" name="phone"
                                           class="w-full h-12 px-4 rounded-lg border border-outline-variant bg-white text-base"
                                           placeholder="094 4567 234" type="tel"/>
                                </div>
                            </div>
                        </div>
                        <div class="space-y-6">
                            <h3 class="text-xl font-semibold text-on-surface flex items-center gap-2">
                                <span class="material-symbols-outlined text-primary">badge</span>
                                Account Setup
                            </h3>
                            <div class="space-y-4">
                                <div class="flex flex-col gap-2">
                                    <label class="text-sm font-semibold text-on-surface">Role <span class="text-error">*</span></label>
                                    <input
                                        type="text"
                                        value="Staff"
                                        readonly
                                        class="w-full h-12 px-4 rounded-lg border border-outline-variant bg-gray-100 text-base cursor-not-allowed"
                                        />
                                </div>
                                <div class="flex flex-col gap-2">
                                    <label class="text-sm font-semibold text-on-surface">Temporary Password <span class="text-error">*</span></label>
                                    <div class="flex gap-2">
                                        <div class="relative flex-grow">
                                            <input id="temp-password" name="password"
                                                   class="w-full h-12 px-4 pr-10 rounded-lg border border-outline-variant bg-white text-base"
                                                   placeholder="••••••••" type="password"/>
                                            <button id="toggle-pw-visibility"
                                                    class="absolute right-3 top-3 text-on-surface-variant material-symbols-outlined"
                                                    type="button">visibility</button>
                                        </div>
                                        <button id="generate-btn"
                                                class="px-4 h-12 bg-surface-container-low border border-outline-variant text-on-surface rounded-lg text-sm font-semibold hover:bg-surface-container transition-all flex items-center gap-2 shrink-0"
                                                type="button">
                                            <span class="material-symbols-outlined text-lg">key</span>
                                            Generate
                                        </button>
                                    </div>
                                </div>
                                <div class="flex flex-col gap-2">
                                    <label class="text-sm font-semibold text-on-surface">Status <span class="text-error">*</span></label>
                                    <input
                                        type="text"
                                        value="Active"
                                        readonly
                                        class="w-full h-12 px-4 rounded-lg border border-outline-variant bg-gray-100 text-base cursor-not-allowed"
                                        />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="flex flex-col sm:flex-row justify-end gap-4 pt-8">
                        <a href="${pageContext.request.contextPath}/dashboard/account-management"
                           class="px-6 py-3 border border-outline-variant text-on-surface-variant rounded-lg text-sm font-semibold hover:bg-background-alt transition-colors text-center">
                            Cancel
                        </a>
                        <button id="submit-btn"
                                class="px-8 py-3 bg-primary text-white rounded-lg text-sm font-semibold shadow-md hover:opacity-90 active:scale-95 transition-all flex items-center justify-center gap-2"
                                type="button">
                            <span class="material-symbols-outlined text-xl">person_add</span>
                            Create Account
                        </button>
                    </div>
                </section>
            </div>
        </main>

        <script>
            document.getElementById('toggle-pw-visibility').addEventListener('click', function () {
                const pw = document.getElementById('temp-password');
                if (pw.type === 'password') {
                    pw.type = 'text';
                    this.textContent = 'visibility_off';
                } else {
                    pw.type = 'password';
                    this.textContent = 'visibility';
                }
            });
            document.getElementById('generate-btn').addEventListener('click', function () {
                const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*";
                let password = "";
                for (let i = 0; i < 12; i++) {
                    password += chars.charAt(Math.floor(Math.random() * chars.length));
                }
                const pw = document.getElementById('temp-password');
                pw.type = 'text';
                pw.value = password;
                document.getElementById('toggle-pw-visibility').textContent = 'visibility_off';

                this.classList.add('bg-green-100', 'border-green-400', 'text-green-700');
                setTimeout(() => {
                    this.classList.remove('bg-green-100', 'border-green-400', 'text-green-700');
                }, 800);
            });
            function showToast(message, isError = false) {
                const existing = document.getElementById('toast-msg');
                if (existing)
                    existing.remove();

                const div = document.createElement("div");
                div.id = "toast-msg";
                div.innerText = message;
                div.style.cssText = `
                    position: fixed; bottom: 24px; right: 24px;
                    padding: 14px 20px; border-radius: 10px;
                    color: white; z-index: 9999; font-size: 14px; font-weight: 500;
                    background: ${isError ? '#D32F2F' : '#2E7D32'};
                    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                    transition: opacity 0.3s;
                `;
                document.body.appendChild(div);
                setTimeout(() => {
                    div.style.opacity = '0';
                    setTimeout(() => div.remove(), 300);
                }, 2500);
            }

            // Submit
            document.getElementById('submit-btn').addEventListener('click', async function () {
                const fullname = document.getElementById('fullname').value.trim();
                const email = document.getElementById('email').value.trim();
                const phone = document.getElementById('phone').value.trim();
                const role = "staff";
                const password = document.getElementById('temp-password').value.trim();
                const status = "active";

                if (!fullname) {
                    showToast("Please enter a full name", true);
                    return;
                }
                if (!email) {
                    showToast("Please enter an email address", true);
                    return;
                }
                if (!password) {
                    showToast("Please enter a password", true);
                    return;
                }
                if (password.length < 6) {
                    showToast("Password must be at least 6 characters", true);
                    return;
                }
                const btn = this;
                btn.disabled = true;
                btn.innerHTML = '<span class="material-symbols-outlined animate-spin text-xl">progress_activity</span> Creating...';
                const formData = new URLSearchParams();
                formData.append("mode", "add");
                formData.append("fullname", fullname);
                formData.append("email", email);
                formData.append("phone", phone);
                formData.append("role", role);
                formData.append("password", password);
                formData.append("status", status);

                try {
                    const res = await fetch("${pageContext.request.contextPath}/dashboard/add-staff", {
                        method: "POST",
                        headers: {"Content-Type": "application/x-www-form-urlencoded"},
                        body: formData.toString()
                    });
                    const data = await res.json();
                    if (data.success) {
                        showToast("Staff account created successfully!");
                        setTimeout(() => {
                            window.location.href = "${pageContext.request.contextPath}/dashboard/account-management";
                        }, 1000);
                    } else {
                        showToast(data.message || "Could not create the account. Please try again.", true);
                        btn.disabled = false;
                        btn.innerHTML = '<span class="material-symbols-outlined text-xl">person_add</span> Create Account';
                    }
                } catch (err) {
                    console.error(err);
                    showToast("Server connection error", true);
                    btn.disabled = false;
                    btn.innerHTML = '<span class="material-symbols-outlined text-xl">person_add</span> Create Account';
                }
            });
        </script>
    </body>
</html>

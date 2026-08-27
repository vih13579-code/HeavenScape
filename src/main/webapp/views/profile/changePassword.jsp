<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ include file="/views/layout/homepage/header.jsp" %>
            <style>
                .input-style {
                    width: 100%;
                    padding: 12px 16px;
                    border: 1px solid #d1d5db;
                    border-radius: 10px;
                    font-size: 1rem;
                    transition: border-color 0.2s, box-shadow 0.2s;
                }

                .input-style:focus {
                    outline: none;
                    border-color: #C92127;
                    box-shadow: 0 0 0 3px rgba(37, 99, 235, .15);
                }

                .password-strength {
                    margin-top: 8px;
                    font-size: 0.875rem;
                }

                .strength-meter {
                    height: 4px;
                    background: #e5e7eb;
                    border-radius: 2px;
                    margin-top: 4px;
                    overflow: hidden;
                }

                .strength-bar {
                    height: 100%;
                    width: 0%;
                    background: #ef4444;
                    border-radius: 2px;
                    transition: width 0.3s, background-color 0.3s;
                }

                .strength-bar.weak {
                    width: 33%;
                    background: #ef4444;
                }

                .strength-bar.medium {
                    width: 66%;
                    background: #f59e0b;
                }

                .strength-bar.strong {
                    width: 100%;
                    background: #10b981;
                }

                .btn-submit {
                    background: #C92127;
                    color: white;
                    padding: 12px 24px;
                    border-radius: 10px;
                    border: none;
                    font-weight: 600;
                    cursor: pointer;
                    transition: opacity 0.2s, transform 0.1s;
                }

                .btn-submit:hover:not(:disabled) {
                    opacity: 0.9;
                }

                .btn-submit:active:not(:disabled) {
                    transform: scale(0.98);
                }

                .btn-submit:disabled {
                    opacity: 0.6;
                    cursor: not-allowed;
                }

                .password-requirement {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    font-size: 0.875rem;
                    margin-top: 4px;
                    color: #6b7280;
                }

                .requirement-icon {
                    width: 16px;
                    height: 16px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 0.75rem;
                    background: #f3f4f6;
                    color: #9ca3af;
                }

                .requirement-icon.met {
                    background: #d1fae5;
                    color: #059669;
                }

                .requirement-icon.not-met {
                    background: #fee2e2;
                    color: #dc2626;
                }

                .visibility-toggle {
                    position: absolute;
                    right: 12px;
                    top: 50%;
                    transform: translateY(-50%);
                    background: none;
                    border: none;
                    cursor: pointer;
                    color: #6b7280;
                    font-size: 1.25rem;
                    padding: 4px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .visibility-toggle:hover {
                    color: #C92127;
                }

                .password-input-wrapper {
                    position: relative;
                }

                /* Toast Notification */
                #toast-msg {
                    position: fixed;
                    bottom: 24px;
                    right: 24px;
                    padding: 16px 20px;
                    border-radius: 10px;
                    color: white;
                    z-index: 9999;
                    font-size: 14px;
                    font-weight: 500;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                    animation: slideIn 0.3s ease-out;
                }

                #toast-msg.success {
                    background: #10b981;
                }

                #toast-msg.error {
                    background: #ef4444;
                }

                @keyframes slideIn {
                    from {
                        transform: translateX(400px);
                        opacity: 0;
                    }

                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }

                @keyframes slideOut {
                    from {
                        transform: translateX(0);
                        opacity: 1;
                    }

                    to {
                        transform: translateX(400px);
                        opacity: 0;
                    }
                }
            </style>

            <div class="fhs-page-inner">
                <div class="grid grid-cols-1 lg:grid-cols-[250px_minmax(0,1fr)] gap-4">
                    <!-- Sidebar -->
                    <c:set var="activeMenu" value="password" scope="request" />
                    <%@ include file="/views/layout/profile/sidebar.jsp" %>
                        <div class="min-w-0">
                            <div class="profile-card p-8">
                                <div class="mb-8">
                                    <h1 class="text-3xl font-bold">Change Password</h1>
                                    <p class="text-gray-500 mt-2">
                                        To protect your account, never share your password
                                    </p>
                                </div>

                                <form id="changePasswordForm">
                                    <div class="space-y-6">
                                        <!-- Current Password -->
                                        <div>
                                            <label class="block mb-2 font-medium text-gray-700">
                                                Current Password <span class="text-red-600">*</span>
                                            </label>
                                            <div class="password-input-wrapper">
                                                <input type="password" id="currentPassword" name="currentPassword"
                                                    required class="input-style pr-10"
                                                    placeholder="Enter current password">
                                                <button type="button" class="visibility-toggle"
                                                    data-target="currentPassword">
                                                    <span class="material-symbols-outlined">visibility</span>
                                                </button>
                                            </div>
                                        </div>

                                        <div>
                                            <label class="block mb-2 font-medium text-gray-700">
                                                New Password <span class="text-red-600">*</span>
                                            </label>
                                            <div class="password-input-wrapper">
                                                <input type="password" id="newPassword" name="newPassword" required
                                                    minlength="8" maxlength="15" class="input-style pr-10"
                                                    placeholder="Enter new password">
                                                <button type="button" class="visibility-toggle"
                                                    data-target="newPassword">
                                                    <span class="material-symbols-outlined">visibility</span>
                                                </button>
                                            </div>
                                        </div>
                                        <div>
                                            <label class="block mb-2 font-medium text-gray-700">
                                                Confirm New Password <span class="text-red-600">*</span>
                                            </label>
                                            <div class="password-input-wrapper">
                                                <input type="password" id="confirmPassword" name="confirmPassword"
                                                    required minlength="8" maxlength="15" class="input-style pr-10"
                                                    placeholder="Confirm New Password">
                                                <button type="button" class="visibility-toggle"
                                                    data-target="confirmPassword">
                                                    <span class="material-symbols-outlined">visibility</span>
                                                </button>
                                            </div>
                                            <div id="confirmPasswordMatch"
                                                style="margin-top: 8px; font-size: 0.875rem; color: #6b7280;"></div>
                                        </div>

                                        <div class="pt-4">
                                            <button type="submit" id="submitBtn" class="btn-submit w-full md:w-auto">
                                                Update Password
                                            </button>
                                        </div>
                                    </div>
                                    <c:if test="${not empty sessionScope.error}">
                                        <div class="mb-4 p-3 bg-red-100 text-red-700 border border-red-300 rounded">
                                            <c:out value="${sessionScope.error}" />
                                        </div>

                                        <c:remove var="error" scope="session" />
                                    </c:if>
                                </form>
                            </div>
                        </div>
                </div>
            </div>

            <%@ include file="/views/layout/homepage/footer.jsp" %>

                <script>
                    document.querySelectorAll('.visibility-toggle').forEach(btn => {
                        btn.addEventListener('click', function (e) {
                            e.preventDefault();
                            const targetId = this.getAttribute('data-target');
                            const input = document.getElementById(targetId);
                            if (input.type === 'password') {
                                input.type = 'text';
                                this.innerHTML = '<span class="material-symbols-outlined">visibility_off</span>';
                            } else {
                                input.type = 'password';
                                this.innerHTML = '<span class="material-symbols-outlined">visibility</span>';
                            }
                        });
                    });

                    const newPasswordInput = document.getElementById('newPassword');

                    function checkConfirmPassword() {
                        const newPw = newPasswordInput.value;
                        const confirmPw = document.getElementById('confirmPassword').value;
                        const matchText = document.getElementById('confirmPasswordMatch');

                        if (!confirmPw) {
                            matchText.textContent = '';
                            return;
                        }

                        if (newPw === confirmPw) {
                            matchText.textContent = '✓ Passwords match';
                            matchText.style.color = '#10b981';
                        } else {
                            matchText.textContent = '✕ Passwords do not match';
                            matchText.style.color = '#ef4444';
                        }
                    }

                    newPasswordInput.addEventListener('input', checkConfirmPassword);
                    document.getElementById('confirmPassword').addEventListener('input', checkConfirmPassword);

                    function showToast(message, isError = false) {
                        const existing = document.getElementById('toast-msg');
                        if (existing)
                            existing.remove();

                        const div = document.createElement('div');
                        div.id = 'toast-msg';
                        div.className = isError ? 'error' : 'success';
                        div.textContent = message;
                        document.body.appendChild(div);

                        setTimeout(() => {
                            div.style.animation = 'slideOut 0.3s ease-out forwards';
                            setTimeout(() => div.remove(), 300);
                        }, 2500);
                    }

                    document.getElementById('changePasswordForm').addEventListener('submit', async function (e) {
                        e.preventDefault();

                        const currentPassword = document.getElementById('currentPassword').value;
                        const newPassword = document.getElementById('newPassword').value;
                        const confirmPassword = document.getElementById('confirmPassword').value;

                        // Validate client-side
                        if (!currentPassword) {
                            showToast('Please enter your current password', true);
                            return;
                        }
                        if (!newPassword) {
                            showToast('Please enter a new password', true);
                            return;
                        }
                        if (!confirmPassword) {
                            showToast('Please confirm your new password', true);
                            return;
                        }

                        if (/\s/.test(currentPassword)) {
                            showToast('Current password cannot contain spaces', true);
                            return;
                        }

                        if (/\s/.test(newPassword)) {
                            showToast('New password cannot contain spaces', true);
                            return;
                        }

                        if (/\s/.test(confirmPassword)) {
                            showToast('Password confirmation cannot contain spaces', true);
                            return;
                        }

                        if (newPassword !== confirmPassword) {
                            showToast('Passwords do not match', true);
                            return;
                        }

                        // Disable button
                        const submitBtn = document.getElementById('submitBtn');
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<span class="material-symbols-outlined">hourglass_empty</span> Processing...';

                        try {
                            const formData = new URLSearchParams();
                            formData.append('currentPassword', currentPassword);
                            formData.append('newPassword', newPassword);
                            formData.append('confirmPassword', confirmPassword);

                            const response = await fetch('${pageContext.request.contextPath}/profile/change-password', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                },
                                body: formData.toString()
                            });

                            const data = await response.json();

                            if (data.success) {
                                showToast(data.message || 'OTP has been sent to your email.');

                                setTimeout(() => {
                                    window.location.href = '${pageContext.request.contextPath}/otp';
                                }, 1500);
                                // showToast(data.message || 'Password changed successfully!');
                                // document.getElementById('changePasswordForm').reset();
                                // document.getElementById('confirmPasswordMatch').textContent = '';
                                // setTimeout(() => {
                                //     window.location.href = '${pageContext.request.contextPath}/profile';
                                // }, 1500);
                            } else {
                                showToast(data.message || 'Could not change the password. Please try again.', true);
                            }
                        } catch (error) {
                            console.error('Error:', error);
                            showToast('Server connection error', true);
                        } finally {
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = 'Update Password';
                        }
                    });
                </script>
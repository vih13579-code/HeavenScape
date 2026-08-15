<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Personal Profile - HeavenScape Admin</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
      rel="stylesheet"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined"
      rel="stylesheet"
    />
    <style>
      body {
        background: linear-gradient(135deg, #f0f4f9 0%, #e8eef7 100%);
        font-family: "Inter", sans-serif;
        min-height: 100vh;
      }
      .card-modern {
        background: white;
        border-radius: 18px;
        border: 1px solid #e2e8f0;
        box-shadow:
          0 4px 6px -1px rgba(0, 0, 0, 0.1),
          0 2px 4px -1px rgba(0, 0, 0, 0.06);
      }
      .input-premium {
        width: 100%;
        height: 52px;
        padding: 0 20px;
        border: 2px solid #e2e8f0;
        border-radius: 12px !important;
        transition: 0.3s;
        font-weight: 500;
        color: #1e293b;
      }
      .input-premium:focus {
        outline: none;
        border-color: #004d99;
        box-shadow: 0 0 0 4px rgba(0, 77, 153, 0.15);
      }
      .input-premium:disabled {
        background: #f8fafc;
        color: #64748b;
        cursor: not-allowed;
      }
      .form-label-modern {
        display: block;
        margin-bottom: 10px;
        font-size: 0.8rem;
        font-weight: 700;
        color: #334155;
        text-transform: uppercase;
      }
      .form-label-modern span {
        color: red;
      }
      .btn-submit {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        background: linear-gradient(135deg, #004d99, #003366);
        color: white;
        padding: 14px 28px;
        border-radius: 9999px;
        font-weight: 700;
        border: none;
        cursor: pointer;
        transition: 0.3s;
      }
      .btn-submit:hover:not(:disabled) {
        transform: translateY(-2px);
      }
      .btn-submit:disabled {
        background: #cbd5e1;
        color: #94a3b8;
        cursor: not-allowed;
      }
      .btn-outline-premium {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 0 20px;
        height: 52px;
        border-radius: 12px;
        border: 2px solid #004d99;
        color: #004d99;
        font-weight: 700;
        background: white;
        cursor: pointer;
        white-space: nowrap;
        transition: 0.3s;
      }
      .btn-outline-premium:hover {
        background: #004d99;
        color: white;
      }
      .info-card {
        background: #f8fafc;
        padding: 24px;
        border-radius: 14px;
        border: 1px solid #e2e8f0;
      }
      .info-label {
        font-size: 0.75rem;
        color: #64748b;
        font-weight: 700;
        margin-bottom: 6px;
        text-transform: uppercase;
      }
      .badge-status {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-weight: 600;
        background: #fef9c3;
        color: #854d0e;
        padding: 6px 16px;
        border-radius: 9999px;
        font-size: 0.85rem;
      }
      .separator {
        border-top: 2px solid #e2e8f0;
        margin: 28px 0;
      }
    </style>
  </head>

  <body class="text-slate-800">
    <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
    <div class="md:pl-64 flex flex-col flex-1 min-h-screen">
      <main class="py-12 px-4 sm:px-6 lg:px-8 max-w-7xl w-full mx-auto">
        <c:if test="${not empty sessionScope.message}">
          <div
            id="toastMessageData"
            class="hidden"
            data-message="${fn:escapeXml(sessionScope.message)}"
          ></div>
          <c:remove var="message" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.error}">
          <div
            id="toastErrorData"
            class="hidden"
            data-message="${fn:escapeXml(sessionScope.error)}"
          ></div>
          <c:remove var="error" scope="session" />
        </c:if>

        <div class="mb-10">
          <h1 class="text-4xl font-bold text-slate-900">Personal Profile</h1>
          <p class="text-slate-600 mt-2">
            Manage your account and update your personal information.
          </p>
        </div>

        <div class="lg:col-span-2">
          <div class="card-modern p-8 sm:p-10">
            <form
              action="${pageContext.request.contextPath}/profile"
              method="post"
              id="profileForm"
              class="space-y-6"
            >
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label class="form-label-modern" for="fullname">
                    Full Name <span>*</span>
                  </label>
                  <input
                    type="text"
                    name="fullname"
                    id="fullname"
                    value="${fn:escapeXml(account.fullname)}"
                    required
                    class="input-premium"
                    placeholder="Enter full name"
                  />
                  <p
                    id="fullnameError"
                    class="text-red-500 text-sm mt-1 hidden"
                  ></p>
                </div>
                <div>
                  <label class="form-label-modern" for="phone">
                    Phone Number <span>*</span>
                  </label>
                  <input
                    type="tel"
                    name="phone"
                    id="phone"
                    value="${fn:escapeXml(account.phone)}"
                    required
                    class="input-premium"
                    placeholder="0912345678"
                  />
                  <p
                    id="phoneError"
                    class="text-red-500 text-sm mt-1 hidden"
                  ></p>
                </div>
                <div>
                  <label class="form-label-modern text-slate-500">ID</label>
                  <input
                    type="text"
                    value="${account.id}"
                    disabled
                    class="input-premium font-mono"
                  />
                </div>
                <div>
                  <label class="form-label-modern text-slate-500">Email</label>
                  <div class="flex gap-2">
                    <input
                      type="email"
                      value="${account.email}"
                      disabled
                      class="input-premium"
                    />
                    <button
                      type="button"
                      id="openChangeEmailBtn"
                      class="btn-outline-premium"
                    >
                      Change Email
                    </button>
                  </div>
                </div>
              </div>
              <div class="flex justify-end">
                <button type="submit" id="saveBtn" class="btn-submit" disabled>
                  <span class="material-symbols-outlined">save</span>
                  Save Changes
                </button>
              </div>
            </form>
          </div>
        </div>
      </main>
    </div>

    <%@ include file="/views/layout/common/toast.jsp" %>

    <!-- Modal đổi email -->
    <div
      id="changeEmailModal"
      class="fixed inset-0 bg-black/50 hidden items-center justify-center z-50"
    >
      <div class="bg-white rounded-2xl p-6 w-full max-w-md mx-4 card-modern">
        <h3 class="text-xl font-bold mb-2 text-slate-800">Change Email Address</h3>
        <p class="text-slate-500 text-sm mb-4">
          We will send an OTP to the new email address for verification before updating it.
        </p>
        <form
          action="${pageContext.request.contextPath}/profile/change-email"
          method="post"
        >
          <label class="form-label-modern" for="newEmail">New Email</label>
          <input
            type="email"
            name="newEmail"
            id="newEmail"
            required
            placeholder="email-moi@example.com"
            class="input-premium mb-4"
          />
          <div class="flex justify-end gap-3">
            <button
              type="button"
              id="closeChangeEmailBtn"
              class="px-5 py-2.5 rounded-xl border border-slate-300 text-slate-600 hover:bg-slate-50"
            >
              Cancel
            </button>
            <button type="submit" class="btn-submit">Send OTP</button>
          </div>
        </form>
      </div>
    </div>

    <script>
      const openChangeEmailBtn = document.getElementById("openChangeEmailBtn");
      const closeChangeEmailBtn = document.getElementById(
        "closeChangeEmailBtn",
      );
      const changeEmailModal = document.getElementById("changeEmailModal");

      openChangeEmailBtn.addEventListener("click", () => {
        changeEmailModal.classList.remove("hidden");
        changeEmailModal.classList.add("flex");
      });
      closeChangeEmailBtn.addEventListener("click", () => {
        changeEmailModal.classList.add("hidden");
        changeEmailModal.classList.remove("flex");
      });
      changeEmailModal.addEventListener("click", (e) => {
        if (e.target === changeEmailModal) {
          changeEmailModal.classList.add("hidden");
          changeEmailModal.classList.remove("flex");
        }
      });
    </script>

    <script>
      const initialValues = {
        fullname: "${account.fullname}",
        phone: "${account.phone}",
      };

      const form = document.getElementById("profileForm");
      const saveBtn = document.getElementById("saveBtn");
      const fullnameInput = document.getElementById("fullname");
      const fullnameError = document.getElementById("fullnameError");
      const phoneInput = document.getElementById("phone");
      const phoneError = document.getElementById("phoneError");

      function setFieldError(inputEl, errorEl, message) {
        if (message) {
          errorEl.textContent = message;
          errorEl.classList.remove("hidden");
          inputEl.classList.add("border-red-500");
        } else {
          errorEl.textContent = "";
          errorEl.classList.add("hidden");
          inputEl.classList.remove("border-red-500");
        }
        return message === "";
      }

      function validateFullname() {
        const value = fullnameInput.value.trim();
        let message = "";

        if (!value) {
          message = "Full name is required";
        } else if (/\s{2,}/.test(value)) {
          message = "Full name cannot contain consecutive spaces";
        } else if (!/^[\p{L}]+( [\p{L}]+)+$/u.test(value)) {
          message =
            value.split(" ").filter(Boolean).length < 2
              ? 'Full name must contain at least two words, for example: "John Doe"'
              : "Full name may contain only letters and spaces";
        } else if (value.length > 50) {
          message = "Full name cannot exceed 50 characters";
        }

        return setFieldError(fullnameInput, fullnameError, message);
      }

      function validatePhone() {
        const value = phoneInput.value.trim();
        let message = "";

        if (!value) {
          message = "Phone number is required";
        } else if (!/^0\d{9}$/.test(value)) {
          message = "Phone number must contain 10 digits and start with 0";
        }

        return setFieldError(phoneInput, phoneError, message);
      }

      function checkFormChanges() {
        const fullnameValid = validateFullname();
        const phoneValid = validatePhone();
        const currentFullname = fullnameInput.value.trim();
        const currentPhone = phoneInput.value.trim();

        if (!fullnameValid || !phoneValid) {
          saveBtn.disabled = true;
          return;
        }

        const hasChanges =
          currentFullname !== initialValues.fullname ||
          currentPhone !== initialValues.phone;
        saveBtn.disabled = !hasChanges;
      }

      form.addEventListener("submit", function (e) {
        const fullnameValid = validateFullname();
        const phoneValid = validatePhone();

        if (!fullnameValid || !phoneValid) {
          e.preventDefault();
          const firstError = !fullnameValid
            ? fullnameError.textContent
            : phoneError.textContent;
          const focusTarget = !fullnameValid ? fullnameInput : phoneInput;
          focusTarget.focus();
          showToast(firstError, true);
        }
      });

      ["input", "change"].forEach((evt) => {
        fullnameInput.addEventListener(evt, checkFormChanges);
        phoneInput.addEventListener(evt, checkFormChanges);
      });

      checkFormChanges();

      document.addEventListener("DOMContentLoaded", function () {
        const msgEl = document.getElementById("toastMessageData");
        const errEl = document.getElementById("toastErrorData");

        if (msgEl && typeof showToast === "function") {
          showToast(msgEl.dataset.message);
        }
        if (errEl && typeof showToast === "function") {
          showToast(errEl.dataset.message, true);
        }
      });
    </script>
  </body>
</html>

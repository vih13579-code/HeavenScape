<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Personal Profile - HeavenScape Admin</title>
    <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
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
        border-color: #C92127;
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
        background: linear-gradient(135deg, #C92127, #8E171B);
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
        border: 2px solid #C92127;
        color: #C92127;
        font-weight: 700;
        background: white;
        cursor: pointer;
        white-space: nowrap;
        transition: 0.3s;
      }
      .btn-outline-premium:hover {
        background: #C92127;
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
    <style>
      :root { --primary:#c92127; --primary-dark:#94171b; --ink:#1b1b1b; --muted:#68696e; --border:#e2e3e7; }
      body { margin:0; background:#f5f6f8; color:var(--ink); }
      .profile-card { overflow:hidden; background:#fff; border:1px solid var(--border); border-radius:24px; box-shadow:0 14px 40px rgba(26,27,31,.07); }
      .profile-banner { position:relative; display:flex; align-items:center; gap:22px; min-height:168px; padding:32px 38px; overflow:hidden; background:linear-gradient(115deg,#232326 0%,#343438 58%,#8f171b 145%); }
      .profile-banner::after { position:absolute; top:-115px; right:-55px; width:330px; height:330px; content:""; border-radius:50%; background:rgba(201,33,39,.22); }
      .profile-avatar { position:relative; z-index:1; display:grid; width:88px; height:88px; flex:0 0 88px; place-items:center; border:4px solid rgba(255,255,255,.3); border-radius:24px; background:linear-gradient(145deg,#d82b31,#a6191e); box-shadow:0 12px 30px rgba(0,0,0,.22); color:#fff; font-size:2rem; font-weight:800; text-transform:uppercase; }
      .profile-identity { position:relative; z-index:1; min-width:0; }
      .profile-banner .profile-name { margin:0; color:#fff!important; -webkit-text-fill-color:#fff; font-size:clamp(1.55rem,3vw,2rem); font-weight:800; letter-spacing:-.025em; text-shadow:0 1px 2px rgba(0,0,0,.28); }
      .profile-email { margin:7px 0 14px; overflow:hidden; color:rgba(255,255,255,.7); font-size:.92rem; text-overflow:ellipsis; white-space:nowrap; }
      .profile-badges { display:flex; flex-wrap:wrap; gap:8px; }
      .profile-badge { display:inline-flex; align-items:center; gap:6px; padding:6px 11px; border:1px solid rgba(255,255,255,.14); border-radius:999px; background:rgba(255,255,255,.1); color:#fff; font-size:.7rem; font-weight:700; letter-spacing:.05em; text-transform:uppercase; }
      .status-dot { width:7px; height:7px; border-radius:50%; background:#5bd47b; box-shadow:0 0 0 3px rgba(91,212,123,.15); }
      .profile-layout { display:grid; grid-template-columns:310px minmax(0,1fr); }
      .account-panel { padding:32px; border-right:1px solid var(--border); background:#fbfbfc; }
      .section-kicker { margin:0 0 18px; color:#8a8b90; font-size:.7rem; font-weight:800; letter-spacing:.1em; text-transform:uppercase; }
      .account-item { display:flex; align-items:flex-start; gap:12px; padding:14px 0; border-bottom:1px solid #ececef; }
      .account-item-icon { display:grid; width:36px; height:36px; flex:0 0 36px; place-items:center; border-radius:10px; background:#f3e7e8; color:var(--primary); }
      .account-item-icon .material-symbols-outlined { font-size:19px; }
      .account-item-label { margin-bottom:4px; color:#898a8f; font-size:.72rem; font-weight:600; }
      .account-item-value { color:#292a2e; font-size:.84rem; font-weight:650; word-break:break-word; }
      .secondary-action { display:flex; align-items:center; gap:12px; width:100%; margin-top:10px; padding:12px 14px; border:1px solid #d7d8dc; border-radius:14px; background:#fff; color:#38393d; font-size:.82rem; font-weight:700; text-align:left; transition:.2s ease; }
      .secondary-action:first-of-type { margin-top:20px; }
      .secondary-action:hover { border-color:var(--primary); background:#fff8f8; }
      .secondary-action:focus-visible { outline:none; border-color:var(--primary); box-shadow:0 0 0 3px rgba(201,33,39,.18); }
      .secondary-action-icon { display:grid; place-items:center; width:36px; height:36px; flex:0 0 36px; border-radius:10px; background:#f3e7e8; color:var(--primary); transition:.2s ease; }
      .secondary-action-text { flex:1; min-width:0; }
      .secondary-action-title { display:block; color:#292a2e; font-size:.82rem; font-weight:700; }
      .secondary-action-caption { display:block; margin-top:2px; color:#898a8f; font-size:.71rem; font-weight:500; }
      .secondary-action-chevron { flex:0 0 auto; color:#c7c8cc; transition:.2s ease; }
      .secondary-action:hover .secondary-action-chevron { color:var(--primary); transform:translateX(2px); }
      .form-panel { padding:34px 38px 38px; }
      .form-panel-heading { margin-bottom:28px; }
      .form-panel-heading h2 { margin:0; color:#222327; font-size:1.3rem; font-weight:800; letter-spacing:-.015em; }
      .form-panel-heading p { margin:7px 0 0; color:var(--muted); font-size:.84rem; line-height:1.6; }
      .form-grid { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:24px; align-items:start; }
      .form-field { min-width:0; }
      .form-label-modern { display:block; margin-bottom:9px; color:#3c3d42; font-size:.78rem; font-weight:700; text-transform:none; }
      .required-mark { color:var(--primary); }
      .field-wrap { position:relative; }
      .field-icon { position:absolute; z-index:1; top:50%; left:16px; display:block; width:20px; height:20px; color:#8b8c91; font-size:20px; line-height:20px; pointer-events:none; transform:translateY(-50%); }
      .field-wrap > .input-premium { display:block; box-sizing:border-box; width:100%; height:50px; padding:0 16px 0 48px!important; border:1px solid #d8d9dd; border-radius:12px!important; outline:none; background:#fff; color:#26272b; font-family:"Inter",sans-serif; font-size:.92rem; font-weight:500; line-height:normal; transition:border-color .2s ease,box-shadow .2s ease; }
      .field-wrap > .input-premium:hover { border-color:#b7b8bd; }
      .field-wrap > .input-premium:focus { border-color:var(--primary); box-shadow:0 0 0 4px rgba(201,33,39,.1); }
      .field-wrap > .input-premium.field-invalid,
      .field-wrap > .input-premium.field-invalid:hover,
      .field-wrap > .input-premium.field-invalid:focus { border-color:#dc2626!important; box-shadow:0 0 0 3px rgba(220,38,38,.1); }
      .field-wrap:has(.field-invalid) .field-icon { color:#dc2626; }
      .field-message { min-height:34px; margin:7px 2px 0; overflow-wrap:anywhere; color:#77787d; font-size:.72rem; line-height:1.45; }
      .field-message.is-error { color:#d32f2f; font-weight:500; }
      .form-footer { display:flex; align-items:center; justify-content:space-between; gap:18px; margin-top:28px; padding-top:24px; border-top:1px solid #ececef; }
      .form-footer-note { display:flex; align-items:center; gap:8px; color:#85868b; font-size:.73rem; }
      .form-footer-note .material-symbols-outlined { font-size:17px; }
      .btn-submit { min-height:48px; justify-content:center; gap:10px; padding:12px 26px 12px 20px; border-radius:9999px; background:linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%); box-shadow:0 10px 20px -6px rgba(201,33,39,.45); font-size:.85rem; letter-spacing:.01em; transition:.2s ease; }
      .btn-submit:hover:not(:disabled) { box-shadow:0 12px 24px -6px rgba(201,33,39,.55); transform:translateY(-1px); }
      .btn-submit:disabled { background:#e1e2e5; box-shadow:none; color:#9b9ca1; }
      .btn-submit:focus-visible { outline:none; box-shadow:0 0 0 4px rgba(201,33,39,.25); }
      .btn-submit .material-symbols-outlined { display:grid; place-items:center; width:24px; height:24px; border-radius:999px; background:rgba(255,255,255,.18); font-size:15px; }
      .btn-submit:disabled .material-symbols-outlined { background:rgba(0,0,0,.06); }
      .modal-card { width:min(440px,calc(100vw - 32px)); border:1px solid #e3e4e7; border-radius:20px; background:#fff; box-shadow:0 24px 70px rgba(0,0,0,.2); }
      .modal-icon { display:grid; width:48px; height:48px; flex:0 0 48px; place-items:center; border-radius:14px; background:#f9e9ea; color:var(--primary); }
      @media (max-width:900px) { .profile-layout { grid-template-columns:1fr; } .account-panel { border-right:0; border-bottom:1px solid var(--border); } }
      @media (max-width:640px) { .profile-banner { align-items:flex-start; padding:26px 22px; } .profile-avatar { width:68px; height:68px; flex-basis:68px; border-radius:19px; font-size:1.55rem; } .account-panel,.form-panel { padding:26px 22px; } .form-grid { grid-template-columns:1fr; gap:18px; } .form-footer { align-items:stretch; flex-direction:column; } .btn-submit { width:100%; } }
    </style>
  </head>

  <body class="text-slate-800">
    <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
    <div class="md:pl-64 flex flex-col flex-1 min-h-screen">
      <main class="py-8 px-4 sm:px-6 lg:px-8 max-w-6xl w-full mx-auto">
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

        <div class="mb-7">
          <h1 class="text-3xl font-bold tracking-tight text-[#1B1B1B]">Personal Profile</h1>
          <p class="text-[#68696E] mt-2 text-sm">
            Manage your account and update your personal information.
          </p>
        </div>

        <section class="profile-card">
          <div class="profile-banner">
            <div class="profile-avatar" aria-hidden="true">${fn:substring(account.fullname, 0, 1)}</div>
            <div class="profile-identity">
              <h2 class="profile-name">${fn:escapeXml(account.fullname)}</h2>
              <p class="profile-email">${fn:escapeXml(account.email)}</p>
              <div class="profile-badges">
                <span class="profile-badge">
                  <span class="material-symbols-outlined" style="font-size:14px">shield_person</span>
                  ${fn:toUpperCase(account.role)}
                </span>
                <span class="profile-badge"><span class="status-dot"></span>${fn:toUpperCase(account.status)}</span>
              </div>
            </div>
          </div>

          <div class="profile-layout">
            <aside class="account-panel">
              <p class="section-kicker">Account overview</p>
              <div class="account-item">
                <div class="account-item-icon"><span class="material-symbols-outlined">badge</span></div>
                <div class="form-field">
                  <div class="account-item-label">Account ID</div>
                  <div class="account-item-value">#${account.id}</div>
                </div>
              </div>
              <div class="account-item">
                <div class="account-item-icon"><span class="material-symbols-outlined">alternate_email</span></div>
                <div class="min-w-0">
                  <div class="account-item-label">Email address</div>
                  <div class="account-item-value">${fn:escapeXml(account.email)}</div>
                </div>
              </div>
              <a href="${pageContext.request.contextPath}/dashboard/profile/change-password" class="secondary-action">
                <span class="secondary-action-icon"><span class="material-symbols-outlined" style="font-size:18px">lock_reset</span></span>
                <span class="secondary-action-text">
                  <span class="secondary-action-title">Change Password</span>
                  <span class="secondary-action-caption">Update your login credentials</span>
                </span>
                <span class="material-symbols-outlined secondary-action-chevron" style="font-size:18px">chevron_right</span>
              </a>
            </aside>

            <div class="form-panel">
              <div class="form-panel-heading">
                <h2>Personal information</h2>
                <p>Keep your name and contact number accurate for account-related communication.</p>
              </div>

            <form
              action="${pageContext.request.contextPath}/dashboard/profile"
              method="post"
              id="profileForm"
            >
              <div class="form-grid">
                <div class="form-field">
                  <label class="form-label-modern" for="fullname">
                    Full Name <span class="required-mark">*</span>
                  </label>
                  <div class="field-wrap">
                    <span class="material-symbols-outlined field-icon">person</span>
                    <input
                      type="text"
                      name="fullname"
                      id="fullname"
                      value="${fn:escapeXml(account.fullname)}"
                      data-initial-value="${fn:escapeXml(account.fullname)}"
                      required
                      maxlength="50"
                      autocomplete="name"
                      class="input-premium"
                      placeholder="Enter your full name"
                      aria-describedby="fullnameMessage"
                    />
                  </div>
                  <p id="fullnameMessage" class="field-message">Use your full name with at least two words.</p>
                </div>
                <div>
                  <label class="form-label-modern" for="phone">
                    Phone Number <span class="required-mark">*</span>
                  </label>
                  <div class="field-wrap">
                    <span class="material-symbols-outlined field-icon">call</span>
                    <input
                      type="tel"
                      name="phone"
                      id="phone"
                      value="${fn:escapeXml(account.phone)}"
                      data-initial-value="${fn:escapeXml(account.phone)}"
                      required
                      maxlength="10"
                      inputmode="numeric"
                      autocomplete="tel"
                      class="input-premium"
                      placeholder="0912345678"
                      aria-describedby="phoneMessage"
                    />
                  </div>
                  <p id="phoneMessage" class="field-message">Enter 10 digits, starting with 0.</p>
                </div>
              </div>

              <div class="form-footer">
                <div class="form-footer-note">
                  <span class="material-symbols-outlined">info</span>
                  The save button activates after a valid change.
                </div>
                <button type="submit" id="saveBtn" class="btn-submit" disabled>
                  <span class="material-symbols-outlined">save</span>
                  Save Changes
                </button>
              </div>
            </form>
          </div>
          </div>
        </section>
      </main>
    </div>

    <%@ include file="/views/layout/common/toast.jsp" %>

    <script>
  const form = document.getElementById("profileForm");
  const saveBtn = document.getElementById("saveBtn");
  const fullnameInput = document.getElementById("fullname");
  const fullnameMessage = document.getElementById("fullnameMessage");
  const phoneInput = document.getElementById("phone");
  const phoneMessage = document.getElementById("phoneMessage");
  const initialValues = {
    fullname: fullnameInput.dataset.initialValue || "",
    phone: phoneInput.dataset.initialValue || "",
  };

  const fieldHelp = {
    fullname: "Use your full name with at least two words.",
    phone: "Enter 10 digits, starting with 0.",
  };

  const touchedFields = {
    fullname: false,
    phone: false,
  };

  function setFieldError(inputEl, messageEl, message, helpText, showError) {
    if (message && showError) {
      messageEl.textContent = message;
      messageEl.classList.add("is-error");
      inputEl.classList.add("field-invalid");
      inputEl.setAttribute("aria-invalid", "true");
    } else {
      messageEl.textContent = helpText;
      messageEl.classList.remove("is-error");
      inputEl.classList.remove("field-invalid");
      inputEl.removeAttribute("aria-invalid");
    }
  }

  function validateFullname(
    showError = touchedFields.fullname && fullnameInput.value.trim() !== initialValues.fullname
  ) {
    const value = fullnameInput.value.trim();
    let message = "";

    if (!value) {
      message = "Full name is required";
    } else if (/\s{2,}/.test(value)) {
      message = "Full name cannot contain consecutive spaces";
    } else if (!/^[\p{L}]+( [\p{L}]+)+$/u.test(value)) {
      message =
        value.split(" ").filter(Boolean).length < 2
          ? 'Enter at least two words, for example: "John Doe"'
          : "Full name may contain only letters and spaces";
    } else if (value.length > 50) {
      message = "Full name cannot exceed 50 characters";
    }

    setFieldError(
      fullnameInput,
      fullnameMessage,
      message,
      fieldHelp.fullname,
      showError,
    );
    return message === "";
  }

  function validatePhone(
    showError = touchedFields.phone && phoneInput.value.trim() !== initialValues.phone
  ) {
    const value = phoneInput.value.trim();
    let message = "";

    if (!value) {
      message = "Phone number is required";
    } else if (!/^0\d{9}$/.test(value)) {
      message = "Phone number must contain 10 digits and start with 0";
    }

    setFieldError(
      phoneInput,
      phoneMessage,
      message,
      fieldHelp.phone,
      showError,
    );
    return message === "";
  }

  // Helper: field chỉ cần hợp lệ nếu nó ĐÃ được người dùng thay đổi.
  // Dữ liệu cũ (đã lưu từ trước, có thể không còn khớp rule mới) không bị
  // ép buộc phải hợp lệ nếu user không đụng tới field đó.
  function getFieldState() {
    const currentFullname = fullnameInput.value.trim();
    const currentPhone = phoneInput.value.trim();

    const fullnameChanged = currentFullname !== initialValues.fullname;
    const phoneChanged = currentPhone !== initialValues.phone;

    const fullnameValid = validateFullname();
    const phoneValid = validatePhone();

    return {
      currentFullname,
      currentPhone,
      fullnameChanged,
      phoneChanged,
      fullnameValid,
      phoneValid,
    };
  }

  function checkFormChanges() {
    const {
      fullnameChanged,
      phoneChanged,
      fullnameValid,
      phoneValid,
    } = getFieldState();

    // Chỉ chặn Save nếu field ĐÃ thay đổi mà lại không hợp lệ.
    const blockedByFullname = fullnameChanged && !fullnameValid;
    const blockedByPhone = phoneChanged && !phoneValid;

    if (blockedByFullname || blockedByPhone) {
      saveBtn.disabled = true;
      return;
    }

    const hasChanges = fullnameChanged || phoneChanged;
    saveBtn.disabled = !hasChanges;
  }

  form.addEventListener("submit", function (e) {
    touchedFields.fullname = fullnameInput.value.trim() !== initialValues.fullname;
    touchedFields.phone = phoneInput.value.trim() !== initialValues.phone;

    const {
      fullnameChanged,
      phoneChanged,
      fullnameValid,
      phoneValid,
    } = getFieldState();

    // Hiển thị lỗi trên UI (để user thấy rõ) nhưng chỉ chặn submit
    // nếu field bị lỗi đó thực sự đã bị thay đổi.
    validateFullname(fullnameChanged);
    validatePhone(phoneChanged);

    const blockedByFullname = fullnameChanged && !fullnameValid;
    const blockedByPhone = phoneChanged && !phoneValid;

    if (blockedByFullname || blockedByPhone) {
      e.preventDefault();
      const firstError = blockedByFullname
        ? fullnameMessage.textContent
        : phoneMessage.textContent;
      const focusTarget = blockedByFullname ? fullnameInput : phoneInput;
      focusTarget.focus();
      showToast(firstError, true);
    }
  });

  ["input", "change"].forEach((evt) => {
    fullnameInput.addEventListener(evt, () => {
      touchedFields.fullname = true;
      checkFormChanges();
    });
    phoneInput.addEventListener(evt, () => {
      touchedFields.phone = true;
      checkFormChanges();
    });
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

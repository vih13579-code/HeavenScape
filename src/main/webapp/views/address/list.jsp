<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<style>
    .address-list{
        display:flex;
        flex-direction:column;
        gap:12px;
    }
    .address-item{
        display:flex;
        align-items:center;
        gap:10px;
        flex-wrap:wrap;
    }
    .address-display{
        flex:1;
        min-width:260px;
        padding:12px 16px;
        border:1px solid #d1d5db;
        border-radius:10px;
        background:#fff;
        color:#111827;
    }
    .default-badge{
        display:inline-block;
        border:1px solid #2563eb;
        color:#2563eb;
        border-radius:5px;
        font-size:12px;
        padding:3px 8px;
        white-space:nowrap;
    }
    .address-actions{
        display:flex;
        align-items:center;
        gap:10px;
        white-space:nowrap;
    }
    .edit-btn,.default-btn,.add-address-btn{
        color:#2563eb;
        font-weight:700;
        background:none;
        border:0;
        cursor:pointer;
    }
    .delete-btn{
        color:#dc2626;
        font-weight:700;
        background:none;
        border:0;
        cursor:pointer;
    }
    .address-header-row{
        display:flex;
        align-items:center;
        justify-content:space-between;
        margin-bottom:20px;
        gap:16px;
    }
    .modal-overlay{
        position:fixed;
        inset:0;
        background:rgba(15,23,42,.45);
        z-index:9999;
        display:flex;
        align-items:center;
        justify-content:center;
        padding:20px;
    }
    .modal-overlay.hidden{display:none;}
    .address-modal{
        width:100%;
        max-width:430px;
        background:#fff;
        border-radius:12px;
        padding:22px;
        box-shadow:0 20px 50px rgba(0,0,0,.25);
    }
    .modal-title{
        font-size:20px;
        font-weight:800;
        margin-bottom:18px;
    }
    .modal-label{
        display:block;
        font-weight:600;
        margin-bottom:8px;
        font-size:14px;
    }
    .modal-field{
        width:100%;
        padding:12px 14px;
        border:1px solid #9ca3af;
        border-radius:4px;
        background:#fff;
    }
    .modal-grid{
        display:grid;
        grid-template-columns:1fr 1fr;
        gap:14px;
        margin-bottom:14px;
    }
    .modal-actions{
        display:grid;
        grid-template-columns:1fr 1fr;
        gap:12px;
        margin-top:18px;
    }
    .btn-cancel-modal{
        background:#dbeafe;
        color:#111827;
        border:0;
        border-radius:4px;
        padding:13px;
        font-weight:700;
        cursor:pointer;
    }
    .btn-save-modal{
        background:#1d4fa3;
        color:#fff;
        border:0;
        border-radius:4px;
        padding:13px;
        font-weight:800;
        cursor:pointer;
    }
</style>

<div class="max-w-7xl mx-auto py-10 px-4">
    <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">

        <c:set var="activeMenu" value="address" scope="request"/>
        <%@ include file="/views/layout/profile/sidebar.jsp" %>

        <div class="lg:col-span-3 space-y-6">
            <c:if test="${not empty sessionScope.message}">
                <div id="toastMessageData" class="hidden"
                     data-message="${fn:escapeXml(sessionScope.message)}"></div>
                <div class="bg-green-100 text-green-700 p-4 rounded-xl">
                    ${sessionScope.message}
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div id="toastErrorData" class="hidden"
                     data-message="${fn:escapeXml(sessionScope.error)}"></div>
                <div class="bg-red-100 text-red-700 p-4 rounded-xl">
                    ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <div class="profile-card p-8">
                <div class="address-header-row">
                    <div>
                        <h1 class="text-3xl font-bold">My Addresses</h1>
                        <p class="text-gray-500 mt-2">Manage your shipping addresses</p>
                    </div>

                    <button type="button"
                            class="add-address-btn"
                            onclick="openAddAddressModal()">
                        + Add New
                    </button>
                </div>

                <c:choose>
                    <c:when test="${not empty addresses}">
                        <div class="address-list">
                        <c:forEach var="address" items="${addresses}">
                            <div class="address-item" id="address-row-${address.addressID}">
                                <input type="hidden"
                                       id="street-${address.addressID}"
                                       value="${fn:escapeXml(address.street)}">

                                <input type="hidden"
                                       id="district-${address.addressID}"
                                       value="${fn:escapeXml(address.district)}">

                                <input type="hidden"
                                       id="city-${address.addressID}"
                                       value="${fn:escapeXml(address.city)}">

                                <div id="address-display-${address.addressID}"
                                     class="address-display">
                                    ${address.street}, ${address.district}, ${address.city}
                                </div>

                                <c:if test="${address['default']}">
                                    <span class="default-badge">Default</span>
                                </c:if>

                                <div class="address-actions">
                                    <c:if test="${!address['default']}">
                                        <form action="${pageContext.request.contextPath}/profile/address"
                                              method="post"
                                              style="display:inline;">
                                            <input type="hidden" name="action" value="setDefaultAddress">
                                            <input type="hidden" name="addressID" value="${address.addressID}">
                                            <button type="submit" class="default-btn">
                                                Set as Default
                                            </button>
                                        </form>
                                    </c:if>

                                    <button type="button"
                                            class="edit-btn"
                                            onclick="openAddressModal('${address.addressID}')">
                                        Edit
                                    </button>

                                    <form action="${pageContext.request.contextPath}/profile/address"
                                          method="post"
                                          style="display:inline;"
                                          onsubmit="openDeleteAddressModal(this); return false;">
                                        <input type="hidden" name="action" value="deleteAddress">
                                        <input type="hidden" name="addressID" value="${address.addressID}">
                                        <button type="submit" class="delete-btn">Delete</button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-white border border-gray-200 rounded-xl p-8 text-center text-gray-500">
                            You do not have any addresses yet.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</div>

<div id="editAddressModal" class="modal-overlay hidden">
    <div class="address-modal">
        <h2 class="modal-title" id="addressModalTitle">Edit Address</h2>

        <input type="hidden" id="modalMode" value="edit">
        <input type="hidden" id="modalAddressID">

        <div class="modal-grid">
            <div>
                <label class="modal-label">Province / City</label>
                <select id="modalCity" class="modal-field">
                    <option value="">Select Province / City</option>
                </select>
            </div>

            <div>
                <label class="modal-label">Ward / Commune</label>
                <select id="modalWard" class="modal-field">
                    <option value="">Select Ward / Commune</option>
                </select>
            </div>
        </div>

        <div>
            <label class="modal-label">Street Address</label>
            <textarea id="modalStreet"
                      rows="4"
                      class="modal-field"
                      placeholder="House number, street name..."></textarea>
        </div>

        <div class="modal-actions">
            <button type="button"
                    class="btn-cancel-modal"
                    onclick="closeAddressModal()">
                Cancel
            </button>

            <button type="button"
                    class="btn-save-modal"
                    onclick="saveAddressModal()">
                Save Address
            </button>
        </div>
    </div>
</div>

<div id="deleteAddressModal" class="modal-overlay hidden">
    <div class="address-modal" style="max-width:390px;">
        <div style="display:flex;align-items:center;justify-content:space-between;gap:16px;">
            <h2 class="modal-title" style="margin-bottom:0;">Delete Address</h2>
            <button type="button" onclick="closeDeleteAddressModal()"
                    style="border:0;background:none;font-size:24px;cursor:pointer;line-height:1;">&times;</button>
        </div>
        <p style="margin-top:18px;color:#424752;">Are you sure you want to delete this address?</p>
        <div class="modal-actions">
            <button type="button" class="btn-cancel-modal" onclick="closeDeleteAddressModal()">Cancel</button>
            <button type="button" class="btn-save-modal" onclick="confirmDeleteAddress()">Confirm</button>
        </div>
    </div>
</div>

<%@ include file="/views/layout/common/toast.jsp" %>

<script>
    var vietnamProvinces = [];
    var pendingDeleteAddressForm = null;

    function openDeleteAddressModal(form) {
        pendingDeleteAddressForm = form;
        document.getElementById('deleteAddressModal').classList.remove('hidden');
    }

    function closeDeleteAddressModal() {
        document.getElementById('deleteAddressModal').classList.add('hidden');
        pendingDeleteAddressForm = null;
    }

    function confirmDeleteAddress() {
        if (pendingDeleteAddressForm) {
            pendingDeleteAddressForm.submit();
        }
    }

    function validateStreet(street) {
        var trimmed = (street || '').trim();
        if (!trimmed) {
            return 'Please enter a street address.';
        }
        if (trimmed.length < 5 || !/[A-Za-zÀ-ỹ]/.test(trimmed)) {
            return 'The address is invalid. Please provide a clear house number and street name.';
        }
        return '';
    }

    function isSelectedOption(selectElement, value) {
        return Array.from(selectElement.options).some(function (option) {
            return option.value === value && value !== '';
        });
    }

    async function loadVietnamProvinces() {
        var citySelect = document.getElementById('modalCity');
        var wardSelect = document.getElementById('modalWard');

        citySelect.innerHTML = '<option value="">Loading...</option>';
        wardSelect.innerHTML = '<option value="">Select Ward / Commune</option>';

        try {
            var response = await fetch('https://provinces.open-api.vn/api/v2/?depth=2');
            vietnamProvinces = await response.json();

            citySelect.innerHTML = '<option value="">Select Province / City</option>';

            vietnamProvinces.forEach(function (province) {
                var option = document.createElement('option');
                option.value = province.name;
                option.textContent = province.name;
                option.dataset.code = province.code;
                citySelect.appendChild(option);
            });
        } catch (e) {
            citySelect.innerHTML = '<option value="">Could not load data</option>';
            showToast('Could not load province and city data!', true);
        }
    }

    async function loadWardsByCity(cityName, selectedWard) {
        var wardSelect = document.getElementById('modalWard');
        wardSelect.innerHTML = '<option value="">Loading wards and communes...</option>';

        var province = vietnamProvinces.find(function (item) {
            return item.name === cityName;
        });

        if (!province) {
            wardSelect.innerHTML = '<option value="">Select Ward / Commune</option>';
            return;
        }

        var wards = province.wards || province.communes || [];

        if (!wards.length && province.code) {
            try {
                var response = await fetch(
                    'https://provinces.open-api.vn/api/v2/p/' +
                    province.code +
                    '?depth=2'
                );

                var provinceDetail = await response.json();
                wards = provinceDetail.wards || provinceDetail.communes || [];
            } catch (e) {
                wards = [];
            }
        }

        wardSelect.innerHTML = '<option value="">Select Ward / Commune</option>';

        wards.forEach(function (ward) {
            var option = document.createElement('option');
            option.value = ward.name;
            option.textContent = ward.name;

            if (ward.name === selectedWard) {
                option.selected = true;
            }

            wardSelect.appendChild(option);
        });
    }

    async function openAddAddressModal() {
        document.getElementById('modalMode').value = 'add';
        document.getElementById('modalAddressID').value = '';
        document.getElementById('addressModalTitle').textContent = 'Add Address';
        document.getElementById('modalStreet').value = '';
        document.getElementById('editAddressModal').classList.remove('hidden');

        if (!vietnamProvinces.length) {
            await loadVietnamProvinces();
        }

        document.getElementById('modalCity').value = '';
        document.getElementById('modalWard').innerHTML =
            '<option value="">Select Ward / Commune</option>';
    }

    async function openAddressModal(addressID) {
        document.getElementById('modalMode').value = 'edit';
        document.getElementById('modalAddressID').value = addressID;
        document.getElementById('addressModalTitle').textContent = 'Edit Address';

        var street = document.getElementById('street-' + addressID).value;
        var ward = document.getElementById('district-' + addressID).value;
        var city = document.getElementById('city-' + addressID).value;

        document.getElementById('modalStreet').value = street;
        document.getElementById('editAddressModal').classList.remove('hidden');

        if (!vietnamProvinces.length) {
            await loadVietnamProvinces();
        }

        document.getElementById('modalCity').value = city;
        await loadWardsByCity(city, ward);
    }

    function closeAddressModal() {
        document.getElementById('editAddressModal').classList.add('hidden');
    }

    function saveAddressModal() {
        var mode = document.getElementById('modalMode').value;
        var addressID = document.getElementById('modalAddressID').value;
        var street = document.getElementById('modalStreet').value.trim();
        var city = document.getElementById('modalCity').value;
        var ward = document.getElementById('modalWard').value;

        var citySelect = document.getElementById('modalCity');
        var wardSelect = document.getElementById('modalWard');

        if (!city || !isSelectedOption(citySelect, city)) {
            showToast('Please select a valid province or city.', true);
            return;
        }

        if (!ward || !isSelectedOption(wardSelect, ward)) {
            showToast('Please select a valid ward or commune.', true);
            return;
        }

        var streetError = validateStreet(street);
        if (streetError) {
            showToast(streetError, true);
            return;
        }

        var action = mode === 'add' ? 'addAddressAjax' : 'updateAddressAjax';

        var body =
            'action=' + encodeURIComponent(action) +
            '&street=' + encodeURIComponent(street) +
            '&district=' + encodeURIComponent(ward) +
            '&city=' + encodeURIComponent(city);

        if (mode === 'edit') {
            body += '&addressID=' + encodeURIComponent(addressID);
        }

        fetch('${pageContext.request.contextPath}/profile/address', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
            },
            body: body
        })
        .then(function (response) {
            return response.json();
        })
        .then(function (data) {
            if (!data.success) {
                showToast(data.message || (mode === 'add'
                    ? 'Could not add the address!'
                    : 'Could not update the address!'), true);
                return;
            }

            if (mode === 'add') {
                window.location.href =
                    '${pageContext.request.contextPath}/profile/address';
                return;
            }

            document.getElementById('street-' + addressID).value = street;
            document.getElementById('district-' + addressID).value = ward;
            document.getElementById('city-' + addressID).value = city;

            document.getElementById('address-display-' + addressID).textContent =
                street + ', ' + ward + ', ' + city;

            closeAddressModal();
        })
        .catch(function () {
            showToast('Could not connect to the server!', true);
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        var citySelect = document.getElementById('modalCity');
        var modal = document.getElementById('editAddressModal');
        var deleteModal = document.getElementById('deleteAddressModal');
        var msgEl = document.getElementById('toastMessageData');
        var errEl = document.getElementById('toastErrorData');

        if (citySelect) {
            citySelect.addEventListener('change', function () {
                loadWardsByCity(this.value, '');
            });
        }

        if (modal) {
            modal.addEventListener('click', function (event) {
                if (event.target === this) {
                    closeAddressModal();
                }
            });
        }

        if (deleteModal) {
            deleteModal.addEventListener('click', function (event) {
                if (event.target === this) {
                    closeDeleteAddressModal();
                }
            });
        }

        if (msgEl) {
            showToast(msgEl.dataset.message);
        }

        if (errEl) {
            showToast(errEl.dataset.message, true);
        }
    });
</script>

<%@ include file="/views/layout/homepage/footer.jsp" %>

<%-- 
    Document   : voucher-modal
    Created on : Jun 7, 2026, 12:40:09 PM
    Author     : DUY MINH
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    #voucherForm .voucher-field-error {
        border-color: #d32f2f !important;
        box-shadow: 0 0 0 1px rgba(211, 47, 47, .12) !important;
    }
    #voucherForm .voucher-error-message {
        margin-top: 5px;
        color: #d32f2f;
        font-size: 11px;
        line-height: 1.4;
    }
    #voucherFormError {
        margin-bottom: 14px;
        padding: 9px 11px;
        border: 1px solid #efb5b8;
        border-radius: 6px;
        background: #fff4f4;
        color: #b91c23;
        font-size: 12px;
        line-height: 1.45;
    }
</style>

<div class="fixed inset-0 z-50 hidden modal-backdrop" id="voucherModal" style="background:rgba(30,51,60,0.5);">
    <div class="absolute inset-0" onclick="closeModal()"></div>
    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white rounded-2xl shadow-card-hover w-full max-w-xl max-h-[90vh] overflow-hidden flex flex-col">

        <div class="px-6 py-4 border-b flex justify-between items-center" style="border-color:#D9D9DC; background:#F5F7F9;">
            <h3 class="text-lg font-semibold" style="color:#1B1B1B;" id="modalTitle">Add New Voucher</h3>
            <button onclick="closeModal()" class="p-1 rounded-full hover:bg-error-container transition-colors" style="color:#5C5C5F;">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <div class="flex-1 overflow-y-auto p-6">
            <form method="post" action="${pageContext.request.contextPath}/dashboard/voucher-management"
                  class="space-y-4" id="voucherForm" novalidate>
                <input type="hidden" name="action" id="formAction" value="add"/>
                <input type="hidden" name="voucherID" id="formVoucherID" value=""/>
                <div id="voucherFormError" class="hidden" role="alert"></div>

                <div>
                    <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">
                        Voucher Code <span style="color:#D32F2F;">*</span>
                    </label>
                    <div class="flex">
                        <input id="inputCode" name="code" type="text"
                               class="flex-1 border rounded-l-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white uppercase"
                               style="border-color:#D9D9DC;"
                               placeholder="VD: SALE2024"
                               aria-describedby="errorCode"
                               oninput="updatePreview()"/>
                        <button type="button" onclick="randomCode()"
                                class="border border-l-0 rounded-r-lg px-4 text-sm font-medium transition-colors"
                                style="border-color:#D9D9DC; background:#FDE8E9; color:#C92127;"
                                title="Generate Random Code">
                            <span class="material-symbols-outlined" style="font-size:18px;">autorenew</span>
                        </button>
                    </div>
                    <p id="errorCode" class="voucher-error-message hidden" data-error-for="code"></p>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">
                            Discount (%) <span style="color:#D32F2F;">*</span>
                        </label>
                        <input id="inputDiscount" name="discountPercent" type="number" min="1" max="100"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#D9D9DC;"
                               placeholder="10"
                               aria-describedby="errorDiscount"
                               oninput="updatePreview()"/>
                        <p id="errorDiscount" class="voucher-error-message hidden" data-error-for="discountPercent"></p>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">
                            Quantity
                            <span class="text-xs font-normal" style="color:#5C5C5F;"></span>
                        </label>
                        <input id="inputQuantity" name="quantity" type="number" min="1"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#D9D9DC;"
                               placeholder="100"
                               aria-describedby="errorQuantity"/>
                        <p id="errorQuantity" class="voucher-error-message hidden" data-error-for="quantity"></p>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">
                            Minimum Order (VND)
                            <span class="text-xs font-normal" style="color:#5C5C5F;"></span>
                        </label>
                        <input id="inputMinOrder" name="minOrderValue" type="number" min="0" step="any"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#D9D9DC;"
                               placeholder="100000"
                               aria-describedby="errorMinOrder"
                               oninput="updatePreview()"/>
                        <p id="errorMinOrder" class="voucher-error-message hidden" data-error-for="minOrderValue"></p>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">
                            Maximum Discount (VND)
                            <span class="text-xs font-normal" style="color:#5C5C5F;"></span>
                        </label>
                        <input id="inputMaxDiscount" name="maxDiscountValue" type="number" min="0.01" step="any"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#D9D9DC;"
                               placeholder="50000"
                               aria-describedby="errorMaxDiscount"
                               oninput="updatePreview()"/>
                        <p id="errorMaxDiscount" class="voucher-error-message hidden" data-error-for="maxDiscountValue"></p>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">Start Date</label>
                        <input id="inputStartDate" name="startDate" type="date"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#D9D9DC;"
                               aria-describedby="errorStartDate"
                               oninput="updatePreview()"/>
                        <p id="errorStartDate" class="voucher-error-message hidden" data-error-for="startDate"></p>
                        <%-- min sẽ được set bằng JS khi mở modal tạo mới --%>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">End Date</label>
                        <input id="inputEndDate" name="endDate" type="date"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#D9D9DC;"
                               aria-describedby="errorEndDate"
                               oninput="updatePreview()"/>
                        <p id="errorEndDate" class="voucher-error-message hidden" data-error-for="endDate"></p>
                    </div>
                </div>

                <div id="statusSection" class="hidden">
                    <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">
                        Status <span style="color:#D32F2F;">*</span>
                    </label>
                    <select id="inputStatus" name="status"
                            required
                            class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                            style="border-color:#D9D9DC;">
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                </div>

            </form>

        </div>

        <div class="px-6 py-4 border-t flex justify-end gap-3" style="border-color:#D9D9DC;">
            <button type="button" onclick="closeModal()"
                    class="px-5 py-2.5 rounded-lg border text-sm font-semibold transition-colors"
                    style="border-color:#C92127; color:#C92127;">
                Cancel
            </button>
            <button type="submit" form="voucherForm" formnovalidate id="voucherSubmitButton"
                    class="px-5 py-2.5 rounded-lg text-white text-sm font-semibold transition-colors active:scale-95"
                    style="background:#C92127;">
                Create
            </button>
        </div>
    </div>
</div>

<div class="fixed inset-0 z-[60] hidden" id="deleteDialog" style="background:rgba(30,51,60,0.6);">
    <div class="absolute inset-0" onclick="closeDeleteDialog()"></div>
    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white rounded-xl shadow-card-hover w-full max-w-sm p-6 text-center">
        <div class="w-14 h-14 rounded-full flex items-center justify-center mx-auto mb-4"
             style="background:#ffdad6; color:#D32F2F;">
            <span class="material-symbols-outlined text-3xl">warning</span>
        </div>
        <h3 class="text-lg font-semibold mb-2" style="color:#1B1B1B;">Delete Voucher?</h3>
        <p class="text-sm mb-5" style="color:#5C5C5F;">
            Are you sure you want to delete voucher
            <strong class="font-mono" style="color:#C92127;" id="deleteCodeLabel"></strong>?
            This action cannot be undone.
        </p>
        <form method="post" action="${pageContext.request.contextPath}/dashboard/voucher-management" id="deleteForm">
            <input type="hidden" name="action" value="delete"/>
            <input type="hidden" name="voucherID" id="deleteVoucherID"/>
            <div class="flex justify-center gap-3">
                <button type="button" onclick="closeDeleteDialog()"
                        class="px-4 py-2 rounded-lg border text-sm font-medium"
                        style="border-color:#D9D9DC; color:#5C5C5F;">
                    Cancel
                </button>
                <button type="submit"
                        class="px-4 py-2 rounded-lg text-white text-sm font-medium"
                        style="background:#D32F2F;">
                    Delete Now
                </button>
            </div>
        </form>
    </div>
</div>

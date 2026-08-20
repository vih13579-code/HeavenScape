<%-- 
    Document   : voucher-modal
    Created on : Jun 7, 2026, 12:40:09 PM
    Author     : DUY MINH
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
                  class="space-y-4" id="voucherForm">
                <input type="hidden" name="action" id="formAction" value="add"/>
                <input type="hidden" name="voucherID" id="formVoucherID" value=""/>

                <div>
                    <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">
                        Voucher Code <span style="color:#D32F2F;">*</span>
                    </label>
                    <div class="flex">
                        <input id="inputCode" name="code" type="text" required
                               class="flex-1 border rounded-l-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white uppercase"
                               style="border-color:#D9D9DC;"
                               placeholder="VD: SALE2024"
                               oninput="updatePreview()"/>
                        <button type="button" onclick="randomCode()"
                                class="border border-l-0 rounded-r-lg px-4 text-sm font-medium transition-colors"
                                style="border-color:#D9D9DC; background:#FDE8E9; color:#C92127;"
                                title="Generate Random Code">
                            <span class="material-symbols-outlined" style="font-size:18px;">autorenew</span>
                        </button>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">
                            Discount (%) <span style="color:#D32F2F;">*</span>
                        </label>
                        <input id="inputDiscount" name="discountPercent" type="number" min="1" max="100" required
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#D9D9DC;"
                               placeholder="10"
                               oninput="updatePreview()"/>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">
                            Quantity
                            <span class="text-xs font-normal" style="color:#5C5C5F;"></span>
                        </label>
                        <input id="inputQuantity" name="quantity" type="number" min="1"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#D9D9DC;"
                               placeholder="100"/>
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
                               oninput="updatePreview()"/>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">
                            Maximum Discount (VND)
                            <span class="text-xs font-normal" style="color:#5C5C5F;"></span>
                        </label>
                        <input id="inputMaxDiscount" name="maxDiscountValue" type="number" min="0" step="any"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#D9D9DC;"
                               placeholder="50000"
                               oninput="updatePreview()"/>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">Start Date</label>
                        <input id="inputStartDate" name="startDate" type="date"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#D9D9DC;"
                               oninput="updatePreview()"/>
                        <%-- min sẽ được set bằng JS khi mở modal tạo mới --%>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">End Date</label>
                        <input id="inputEndDate" name="endDate" type="date"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#D9D9DC;"
                               oninput="updatePreview()"/>
                    </div>
                </div>

                <div id="statusSection" class="hidden">
                    <label class="block text-sm font-semibold mb-1.5" style="color:#1B1B1B;">Status</label>
                    <label class="inline-flex items-center cursor-pointer gap-3">
                        <input id="inputStatus" name="statusToggle" type="checkbox" class="sr-only peer"/>
                        <div class="relative w-11 h-6 rounded-full peer peer-checked:after:translate-x-full after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all"
                             style="background:#D9D9DC;" id="toggleBg"></div>
                        <span class="text-sm" style="color:#1B1B1B;" id="statusLabel">Disable</span>
                    </label>
                </div>

                <div class="hidden">
                    <button type="submit" id="submitBtn">Submit</button>
                </div>
            </form>

        </div>

        <div class="px-6 py-4 border-t flex justify-end gap-3" style="border-color:#D9D9DC;">
            <button type="button" onclick="closeModal()"
                    class="px-5 py-2.5 rounded-lg border text-sm font-semibold transition-colors"
                    style="border-color:#C92127; color:#C92127;">
                Cancel
            </button>
            <button type="button" onclick="document.getElementById('submitBtn').click()"
                    class="px-5 py-2.5 rounded-lg text-white text-sm font-semibold transition-colors active:scale-95"
                    style="background:#C92127;">
                Save Voucher
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

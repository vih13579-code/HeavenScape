<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>${formAction == 'create' ? 'Add New Book' : 'Edit Book'} - HeavenScape</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {extend: {
                        colors: {
                            "primary": "#004d99", "primary-container": "#1565c0",
                            "secondary-container": "#fdd835", "secondary": "#705d00",
                            "background": "#f3faff", "surface": "#ffffff",
                            "on-surface": "#071e27", "on-surface-variant": "#424752",
                            "outline-variant": "#c2c6d4", "success": "#2E7D32",
                            "error": "#D32F2F", "warning": "#FFA000",
                            "background-alt": "#F5F7F9"
                        },
                        fontFamily: {sans: ["Inter", "sans-serif"]}
                    }}
            }
        </script>
        <style>
            body {
                font-family: 'Inter', sans-serif;
            }
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                vertical-align: middle;
            }
            .field-label {
                display:block;
                font-size:13px;
                font-weight:600;
                color:#424752;
                margin-bottom:5px;
            }
            .field-input {
                width:100%;
                border:1px solid #c2c6d4;
                border-radius:10px;
                padding:9px 13px;
                font-size:14px;
                outline:none;
                transition:border .18s, box-shadow .18s;
            }
            .field-input:focus {
                border-color:#004d99;
                box-shadow:0 0 0 3px rgba(0,77,153,.1);
            }
            .field-input.error {
                border-color:#D32F2F;
                box-shadow:0 0 0 3px rgba(211,47,47,.08);
            }
            .err-msg {
                color:#D32F2F;
                font-size:12px;
                margin-top:3px;
                display:none;
            }
            .err-msg.show {
                display:block;
            }
            .lookup-row {
                display:flex;
                gap:8px;
                align-items:stretch;
            }
            .lookup-row .field-input {
                flex:1;
            }
            .lookup-add-btn {
                width:42px;
                min-width:42px;
                border:1px solid #c2c6d4;
                border-radius:10px;
                background:#f3faff;
                color:#004d99;
                font-size:22px;
                font-weight:700;
                line-height:1;
                display:flex;
                align-items:center;
                justify-content:center;
                transition:background .18s, border-color .18s;
            }
            .lookup-add-btn:hover {
                background:#e6f6ff;
                border-color:#004d99;
            }
            .lookup-modal-backdrop {
                position:fixed;
                inset:0;
                background:rgba(7,30,39,.45);
                z-index:60;
                display:flex;
                align-items:center;
                justify-content:center;
                padding:16px;
            }
            .lookup-modal {
                width:100%;
                max-width:420px;
                background:#fff;
                border-radius:16px;
                padding:22px;
                box-shadow:0 16px 40px rgba(0,77,153,.18);
            }
            .preview-img {
                width:120px;
                height:160px;
                border:1.5px dashed #c2c6d4;
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                overflow:hidden;
                background:#f3faff;
            }
            .preview-img img {
                width:100%;
                height:100%;
                object-fit:cover;
            }
            .preview-img-sm {
                width:80px;
                height:100px;
                border:1.5px dashed #c2c6d4;
                border-radius:8px;
                display:flex;
                align-items:center;
                justify-content:center;
                overflow:hidden;
                background:#f3faff;
            }
            .preview-img-sm img {
                width:100%;
                height:100%;
                object-fit:cover;
            }
        </style>
    </head>
    <body class="bg-background text-on-surface flex min-h-screen">

        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <%@ include file="/views/layout/common/toast.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen p-6">
            <div class="max-w-[820px] mx-auto">

                
                <div class="flex items-center gap-2 text-sm text-on-surface-variant mb-5">
                    <a href="${pageContext.request.contextPath}/dashboard/product-management" class="hover:text-primary transition-colors">Book Inventory</a>
                    <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                    <span class="text-on-surface font-semibold">${formAction == 'create' ? 'Add New Book' : 'Edit Book'}</span>
                </div>

                <div class="bg-surface rounded-2xl border border-outline-variant/30 overflow-hidden">
                    
                    <div class="px-6 py-4 border-b border-outline-variant/30 flex items-center gap-3">
                        <div class="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center">
                            <span class="material-symbols-outlined text-primary">${formAction == 'create' ? 'add_box' : 'edit'}</span>
                        </div>
                        <div>
                            <h2 class="font-bold text-lg">${formAction == 'create' ? 'Add New Book' : 'Edit Book'}</h2>
                            <p class="text-sm text-on-surface-variant">
                                <c:if test="${formAction == 'update'}">ID: ${book.bookID} · </c:if>
                                    Complete the information below
                                </p>
                            </div>
                        </div>

          
                    <form method="post" id="bookForm"
                          action="${pageContext.request.contextPath}/dashboard/product-management"
                          class="p-6 space-y-6" novalidate>
                        <input type="hidden" name="action" value="${formAction}">
                        <c:if test="${formAction == 'update'}">
                            <input type="hidden" name="bookID" value="${book.bookID}">
                        </c:if>

                        
                        <div class="flex flex-col gap-4">
                           
                            <div class="flex gap-4 items-start">
                                <div class="preview-img flex-shrink-0" id="thumbPreview">
                                    <c:choose>
                                        <c:when test="${not empty book.thumbnail}">
                                            <img src="${book.thumbnail}" id="thumbImg" alt="">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="material-symbols-outlined text-gray-300 text-4xl" id="thumbPlaceholder">image</span>
                                            <img id="thumbImg" alt="" class="hidden w-full h-full object-cover">
                                        </c:otherwise>
                                    </c:choose>

                                </div>
                                <div class="flex-1">
                                    <label class="field-label" for="thumbnail">Cover Image URL <span class="text-error">*</span></label>
                                    <input type="url" id="thumbnail" name="thumbnail" required
                                           class="field-input" placeholder="https://example.com/cover.jpg"
                                           value="${book.thumbnail}"
                                           oninput="previewThumb(this.value, 'thumbImg', 'thumbPlaceholder')">
                                    <div class="mt-2">
                                        <label class="inline-flex items-center gap-2 px-4 py-2 bg-blue-50 text-blue-600 rounded-lg cursor-pointer hover:bg-blue-100 transition-colors text-sm font-medium">
                                            <span class="material-symbols-outlined text-[18px]">upload</span>
                                            Upload Image to Cloudinary
                                            <input type="file" id="thumbFile" accept="image/*" class="hidden" onchange="uploadImage(this, 'thumbnail', 'thumbImg', 'thumbPlaceholder')">
                                        </label>
                                    </div>
                                    <p class="err-msg" id="thumbnailErr">Cover image URL is required</p>
                                    <p class="text-xs text-on-surface-variant mt-1.5">The main cover image appears in listings and on the product page.</p>
                                </div>
                            </div>
                            <%-- 3 ảnh phụ --%>
                            <div class="p-4 bg-blue-50/50 rounded-xl border border-blue-100">
                                <p class="text-[12px] font-bold text-on-surface-variant uppercase tracking-wide mb-3">Additional Images (Product Gallery)</p>
                                <div class="grid grid-cols-3 gap-3">
                                    <div>
                                        <div class="preview-img-sm mb-2" id="imgPreview2">
                                            <span class="material-symbols-outlined text-gray-300 text-2xl" id="imgPlaceholder2">image</span>
                                            <img id="imgThumb2" alt="" class="hidden w-full h-full object-cover">
                                        </div>
                                        <input type="url" id="image2" name="image2"
                                               class="field-input text-xs py-1.5" placeholder="Image 2 URL..."
                                               value="${image2}"
                                               oninput="previewThumb(this.value, 'imgThumb2', 'imgPlaceholder2')">
                                        <label class="inline-flex items-center gap-1 px-2 py-1 bg-blue-50 text-blue-600 rounded cursor-pointer hover:bg-blue-100 transition-colors text-xs mt-1">
                                            <span class="material-symbols-outlined text-[14px]">upload</span>
                                            Upload
                                            <input type="file" id="imgFile2" accept="image/*" class="hidden" onchange="uploadImage(this, 'image2', 'imgThumb2', 'imgPlaceholder2')">
                                        </label>
                                    </div>
                                    <div>
                                        <div class="preview-img-sm mb-2" id="imgPreview3">
                                            <span class="material-symbols-outlined text-gray-300 text-2xl" id="imgPlaceholder3">image</span>
                                            <img id="imgThumb3" alt="" class="hidden w-full h-full object-cover">
                                        </div>
                                        <input type="url" id="image3" name="image3"
                                               class="field-input text-xs py-1.5" placeholder="Image 3 URL..."
                                               value="${image3}"
                                               oninput="previewThumb(this.value, 'imgThumb3', 'imgPlaceholder3')">
                                        <label class="inline-flex items-center gap-1 px-2 py-1 bg-blue-50 text-blue-600 rounded cursor-pointer hover:bg-blue-100 transition-colors text-xs mt-1">
                                            <span class="material-symbols-outlined text-[14px]">upload</span>
                                            Upload
                                            <input type="file" id="imgFile3" accept="image/*" class="hidden" onchange="uploadImage(this, 'image3', 'imgThumb3', 'imgPlaceholder3')">
                                        </label>
                                    </div>
                                    <div>
                                        <div class="preview-img-sm mb-2" id="imgPreview4">
                                            <span class="material-symbols-outlined text-gray-300 text-2xl" id="imgPlaceholder4">image</span>
                                            <img id="imgThumb4" alt="" class="hidden w-full h-full object-cover">
                                        </div>
                                        <input type="url" id="image4" name="image4"
                                               class="field-input text-xs py-1.5" placeholder="Image 4 URL..."
                                               value="${image4}"
                                               oninput="previewThumb(this.value, 'imgThumb4', 'imgPlaceholder4')">
                                        <label class="inline-flex items-center gap-1 px-2 py-1 bg-blue-50 text-blue-600 rounded cursor-pointer hover:bg-blue-100 transition-colors text-xs mt-1">
                                            <span class="material-symbols-outlined text-[14px]">upload</span>
                                            Upload
                                            <input type="file" id="imgFile4" accept="image/*" class="hidden" onchange="uploadImage(this, 'image4', 'imgThumb4', 'imgPlaceholder4')">
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

      
                        <div>
                            <label class="field-label" for="title">Book Title <span class="text-error">*</span></label>
                            <input type="text" id="title" name="title" required
                                   class="field-input" placeholder="Enter book title..."
                                   value="${book.title}" maxlength="255">
                            <p class="err-msg" id="titleErr">Book title is required</p>
                        </div>


                        <div>
                            <label class="field-label" for="authors"> Author <span class="text-error">*</span></label>
                            <input type="text" id="authors" name="authors" required
                                   class="field-input" placeholder="John Doe, Jane Smith (separate names with commas)"
                                   value="<c:if test="${not empty book.authors}"><c:forEach var='a' items='${book.authors}' varStatus='s'>${a}<c:if test='${!s.last}'>, </c:if></c:forEach></c:if>">
                                           <p class="err-msg" id="authorsErr">Author name is required</p>
                                           <p class="text-xs text-on-surface-variant mt-1">For multiple authors, separate names with commas</p>
                                       </div>


                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="field-label" for="priceDisplay">Price (VND) <span class="text-error">*</span></label>
                                <input type="text" id="priceDisplay" inputmode="numeric" autocomplete="off"
                                       class="field-input" placeholder="0"
                                       value="<fmt:formatNumber value='${book.price}' maxFractionDigits='0' groupingUsed='false'/>">
                                <input type="hidden" id="price" name="price"
                                       value="<fmt:formatNumber value='${book.price}' maxFractionDigits='0' groupingUsed='false'/>">
                                <p class="err-msg" id="priceErr">Price must be greater than 0</p>
                            </div>
                            <div>
                                <label class="field-label" for="stockQuantity">Stock Quantity <span class="text-error">*</span></label>
                                <input type="number" id="stockQuantity" name="stockQuantity" required min="0"
                                       class="field-input" placeholder="0"
                                       value="${book.stockQuantity}">
                                <p class="err-msg" id="stockErr">Invalid quantity</p>
                            </div>
                        </div>


                        <div>
                            <label class="field-label" for="description">Description</label>
                            <textarea id="description" name="description" rows="4"
                                      class="field-input resize-y" placeholder="Enter book description...">${book.description}</textarea>
                        </div>


                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="field-label" for="genreID">Genre</label>
                                <div class="lookup-row">
                                    <select id="genreID" name="genreID" class="field-input">
                                        <option value="">-- Select Genre --</option>
                                        <c:forEach var="entry" items="${genreMap}">
                                            <option value="${entry.key}" <c:if test="${book.genreID == entry.key}">selected</c:if>>${entry.value}</option>
                                        </c:forEach>
                                    </select>
                                    <button type="button" class="lookup-add-btn" data-lookup-type="genre" data-target-select="genreID" title="Add Genre">+</button>
                                </div>
                            </div>
                            <div>
                                <label class="field-label" for="contentID">Format</label>
                                <div class="lookup-row">
                                    <select id="contentID" name="contentID" class="field-input">
                                        <option value="">-- Select Format --</option>
                                        <c:forEach var="entry" items="${contentMap}">
                                            <option value="${entry.key}" <c:if test="${book.contentID == entry.key}">selected</c:if>>${entry.value}</option>
                                        </c:forEach>
                                    </select>
                                    <button type="button" class="lookup-add-btn" data-lookup-type="content" data-target-select="contentID" title="Add Format">+</button>
                                </div>
                            </div>
                        </div>


                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="field-label" for="originID">Origin</label>
                                <div class="lookup-row">
                                    <select id="originID" name="originID" class="field-input">
                                        <option value="">-- Select Origin --</option>
                                        <c:forEach var="entry" items="${originMap}">
                                            <option value="${entry.key}" <c:if test="${book.originID == entry.key}">selected</c:if>>${entry.value}</option>
                                        </c:forEach>
                                    </select>
                                    <button type="button" class="lookup-add-btn" data-lookup-type="origin" data-target-select="originID" title="Add Origin">+</button>
                                </div>
                            </div>
                            <div>
                                <label class="field-label" for="seriesID">Series</label>
                                <div class="lookup-row">
                                    <select id="seriesID" name="seriesID" class="field-input">
                                        <option value="">-- None --</option>
                                        <c:forEach var="entry" items="${seriesMap}">
                                            <option value="${entry.key}" <c:if test="${book.seriesID == entry.key}">selected</c:if>>${entry.value}</option>
                                        </c:forEach>
                                    </select>
                                    <button type="button" class="lookup-add-btn" data-lookup-type="series" data-target-select="seriesID" title="Add Series">+</button>
                                </div>
                            </div>
                        </div>


                        <div class="grid grid-cols-3 gap-4">
                            <div>
                                <label class="field-label" for="totalPages">Page Count</label>
                                <input type="number" id="totalPages" name="totalPages" min="0"
                                       class="field-input" placeholder="0"
                                       value="${book.totalPages > 0 ? book.totalPages : ''}">
                            </div>
                            <div>
                                <label class="field-label" for="weight">Weight (g)</label>
                                <input type="number" id="weight" name="weight" min="0" step="0.01"
                                       class="field-input" placeholder="0.00"
                                       value="${book.weight}">
                            </div>
                            <div>
                                <label class="field-label" for="dimensions">Dimensions</label>
                                <input type="text" id="dimensions" name="dimensions"
                                       class="field-input" placeholder="13 x 20.5 cm"
                                       value="${book.dimensions}">
                            </div>
                        </div>


                        <div>
                            <label class="field-label" for="status">Status <span class="text-error">*</span></label>
                            <select id="status" name="status" class="field-input">
                                <option value="available"    <c:if test="${book.status == 'available' or empty book.status}">selected</c:if>>Available</option>
                                <option value="out_of_stock" <c:if test="${book.status == 'out_of_stock'}">selected</c:if>>Out of Stock</option>
                                <option value="discontinued" <c:if test="${book.status == 'discontinued'}">selected</c:if>>Discontinued</option>
                                </select>
                            <p class="err-msg" id="statusErr">A product with zero stock cannot be marked as available.</p>
                            </div>

                 
                        <div class="flex gap-3 pt-2 border-t border-outline-variant/30">
                            <button type="submit" id="submitBtn"
                                    class="flex-1 bg-primary text-white py-3 rounded-xl font-bold text-[15px] hover:opacity-90 transition-opacity flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined">${formAction == 'create' ? 'save' : 'update'}</span>
                                ${formAction == 'create' ? 'Save New Book' : 'Update Book'}
                            </button>
                            <a href="${pageContext.request.contextPath}/dashboard/product-management"
                               class="px-6 py-3 rounded-xl border border-outline-variant font-semibold text-[15px] text-on-surface-variant hover:bg-gray-50 transition-colors flex items-center gap-2">
                                <span class="material-symbols-outlined">close</span> Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <div id="lookupModal" class="lookup-modal-backdrop hidden">
            <div class="lookup-modal">
                <h3 id="lookupModalTitle" class="text-lg font-bold text-on-surface mb-1">Add New Item</h3>
                <p class="text-sm text-on-surface-variant mb-4">Enter a new name if it is not already in the list.</p>
                <input type="text" id="lookupModalInput" class="field-input" placeholder="Enter a name...">
                <p id="lookupModalError" class="err-msg mt-2"></p>
                <div class="flex justify-end gap-2 mt-5">
                    <button type="button" id="lookupModalCancel" class="px-4 py-2 rounded-lg border border-outline-variant text-sm font-semibold">Cancel</button>
                    <button type="button" id="lookupModalSave" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold">Add</button>
                </div>
            </div>
        </div>

        <script>

            function previewThumb(url, imgId, placeholderId) {
                const img = document.getElementById(imgId);
                const placeholder = document.getElementById(placeholderId);
                if (!img)
                    return;
                if (url && url.trim()) {
                    img.src = url.trim();
                    img.classList.remove('hidden');
                    if (placeholder)
                        placeholder.style.display = 'none';
                    img.onerror = () => {
                        img.classList.add('hidden');
                        if (placeholder)
                            placeholder.style.display = '';
                    };
                } else {
                    img.classList.add('hidden');
                    if (placeholder)
                        placeholder.style.display = '';
                }
            }

  
            function uploadImage(input, inputId, imgId, placeholderId) {
                const file = input.files[0];
                if (!file)
                    return;

                const formData = new FormData();
                formData.append('file', file);

                const uploadBtn = input.parentElement;
                const originalText = uploadBtn.innerHTML;
                uploadBtn.innerHTML = '<span class="material-symbols-outlined text-[14px] animate-spin">refresh</span> Uploading...';
                uploadBtn.classList.add('opacity-50', 'cursor-not-allowed');

                fetch('${pageContext.request.contextPath}/upload-image', {
                    method: 'POST',
                    body: formData
                })
                        .then(res => res.json())
                        .then(data => {
                            if (data.ok && data.url) {
                                document.getElementById(inputId).value = data.url;
                                previewThumb(data.url, imgId, placeholderId);
                                uploadBtn.innerHTML = originalText;
                                uploadBtn.classList.remove('opacity-50', 'cursor-not-allowed');
                            } else {
                                alert('Upload failed: ' + (data.message || 'Unknown error'));
                                uploadBtn.innerHTML = originalText;
                                uploadBtn.classList.remove('opacity-50', 'cursor-not-allowed');
                            }
                        })
                        .catch(err => {
                            console.error(err);
                            alert('Server connection error');
                            uploadBtn.innerHTML = originalText;
                            uploadBtn.classList.remove('opacity-50', 'cursor-not-allowed');
                        });
            }

            document.addEventListener('DOMContentLoaded', function () {
   
                const mainInput = document.getElementById('thumbnail');
                if (mainInput && mainInput.value) {
                    previewThumb(mainInput.value, 'thumbImg', 'thumbPlaceholder');
                }
              
                [2, 3, 4].forEach(i => {
                    const input = document.getElementById('image' + i);
                    if (input && input.value) {
                        previewThumb(input.value, 'imgThumb' + i, 'imgPlaceholder' + i);
                    }
                });
            });

            document.getElementById('bookForm').addEventListener('submit', function (e) {
                let valid = true;

                const title = document.getElementById('title');
                const titleErr = document.getElementById('titleErr');
                if (!title.value.trim()) {
                    title.classList.add('error');
                    titleErr.classList.add('show');
                    valid = false;
                } else {
                    title.classList.remove('error');
                    titleErr.classList.remove('show');
                }

                const thumbnail = document.getElementById('thumbnail');
                const thumbnailErr = document.getElementById('thumbnailErr');
                if (!thumbnail.value.trim()) {
                    thumbnail.classList.add('error');
                    thumbnailErr.classList.add('show');
                    valid = false;
                } else {
                    thumbnail.classList.remove('error');
                    thumbnailErr.classList.remove('show');
                }

                const authors = document.getElementById('authors');
                const authorsErr = document.getElementById('authorsErr');
                if (!authors.value.trim()) {
                    authors.classList.add('error');
                    authorsErr.classList.add('show');
                    valid = false;
                } else {
                    authors.classList.remove('error');
                    authorsErr.classList.remove('show');
                }

                const price = document.getElementById('price');
                const priceDisplay = document.getElementById('priceDisplay');
                const priceErr = document.getElementById('priceErr');
                if (!price.value || parseFloat(price.value) <= 0) {
                    priceDisplay.classList.add('error');
                    priceErr.classList.add('show');
                    valid = false;
                } else {
                    priceDisplay.classList.remove('error');
                    priceErr.classList.remove('show');
                }

                const stock = document.getElementById('stockQuantity');
                const stockErr = document.getElementById('stockErr');
                if (stock.value === '' || parseInt(stock.value) < 0) {
                    stock.classList.add('error');
                    stockErr.classList.add('show');
                    valid = false;
                } else {
                    stock.classList.remove('error');
                    stockErr.classList.remove('show');
                }

                const statusSelect = document.getElementById('status');
                const statusErr = document.getElementById('statusErr');
                const stockQtyForStatus = parseInt(stock.value, 10);
                if (statusSelect.value === 'available' && !isNaN(stockQtyForStatus) && stockQtyForStatus <= 0) {
                    statusSelect.classList.add('error');
                    statusErr.classList.add('show');
                    valid = false;
                } else {
                    statusSelect.classList.remove('error');
                    statusErr.classList.remove('show');
                }

                if (!valid) {
                    e.preventDefault();
                    document.querySelector('.field-input.error')?.scrollIntoView({behavior: 'smooth', block: 'center'});
                } else {
                    document.getElementById('submitBtn').disabled = true;
                    document.getElementById('submitBtn').textContent = 'Saving...';
                }
            });


            document.querySelectorAll('.field-input').forEach(el => {
                el.addEventListener('input', () => {
                    el.classList.remove('error');
                    const errId = el.id + 'Err';
                    const err = document.getElementById(errId);
                    if (err)
                        err.classList.remove('show');
                });
            });

            function checkStatusVsStock() {
                const stockEl = document.getElementById('stockQuantity');
                const statusEl = document.getElementById('status');
                const statusErrEl = document.getElementById('statusErr');
                const qty = parseInt(stockEl.value, 10);
                if (statusEl.value === 'available' && !isNaN(qty) && qty <= 0) {
                    statusEl.classList.add('error');
                    statusErrEl.classList.add('show');
                } else {
                    statusEl.classList.remove('error');
                    statusErrEl.classList.remove('show');
                }
            }
            document.getElementById('stockQuantity').addEventListener('input', checkStatusVsStock);
            document.getElementById('status').addEventListener('change', checkStatusVsStock);


            function formatVND(el) {
                const raw = el.value.replace(/\D/g, ''); 
                document.getElementById('price').value = raw;
                el.value = raw ? new Intl.NumberFormat('en-US').format(Number(raw)) : '';
            }
            const priceDisplayEl = document.getElementById('priceDisplay');
            formatVND(priceDisplayEl);
            priceDisplayEl.addEventListener('input', () => {
                formatVND(priceDisplayEl);
                priceDisplayEl.classList.remove('error');
                document.getElementById('priceErr').classList.remove('show');
            });


            const lookupLabels = {genre: 'genre', content: 'format', origin: 'origin', series: 'series'};
            let activeLookupType = '';
            let activeLookupSelectId = '';

            function openLookupModal(type, selectId) {
                activeLookupType = type;
                activeLookupSelectId = selectId;
                document.getElementById('lookupModalTitle').textContent = 'Add ' + (lookupLabels[type] || 'new item');
                document.getElementById('lookupModalInput').value = '';
                document.getElementById('lookupModalError').classList.remove('show');
                document.getElementById('lookupModal').classList.remove('hidden');
                document.getElementById('lookupModalInput').focus();
            }

            function closeLookupModal() {
                document.getElementById('lookupModal').classList.add('hidden');
                activeLookupType = '';
                activeLookupSelectId = '';
            }

            function appendLookupOption(selectId, id, name) {
                const select = document.getElementById(selectId);
                if (!select)
                    return;
                const existing = Array.from(select.options).find(opt => String(opt.value) === String(id));
                if (existing) {
                    select.value = String(id);
                    return;
                }
                const option = document.createElement('option');
                option.value = String(id);
                option.textContent = name;
                select.appendChild(option);
                select.value = String(id);
            }

            async function saveLookupItem() {
                const name = document.getElementById('lookupModalInput').value.trim();
                const errorEl = document.getElementById('lookupModalError');
                if (!name) {
                    errorEl.textContent = 'Please enter a name.';
                    errorEl.classList.add('show');
                    return;
                }
                const saveBtn = document.getElementById('lookupModalSave');
                saveBtn.disabled = true;
                saveBtn.textContent = 'Saving...';
                try {
                    const body = new URLSearchParams();
                    body.append('type', activeLookupType);
                    body.append('name', name);
                    const response = await fetch('${pageContext.request.contextPath}/api/lookup', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'},
                        body: body.toString()
                    });
                    const data = await response.json();
                    if (!data.ok) {
                        errorEl.textContent = data.message || 'Could not add the new item.';
                        errorEl.classList.add('show');
                        return;
                    }
                    appendLookupOption(activeLookupSelectId, data.id, data.name);
                    closeLookupModal();
                    if (typeof showToast === 'function') {
                        showToast('Added new ' + (lookupLabels[activeLookupType] || 'item') + ' successfully!', false);
                    }
                } catch (error) {
                    errorEl.textContent = 'Could not connect to the server.';
                    errorEl.classList.add('show');
                } finally {
                    saveBtn.disabled = false;
                    saveBtn.textContent = 'Add';
                }
            }

            document.querySelectorAll('.lookup-add-btn').forEach(btn => {
                btn.addEventListener('click', () => openLookupModal(btn.dataset.lookupType, btn.dataset.targetSelect));
            });
            document.getElementById('lookupModalCancel').addEventListener('click', closeLookupModal);
            document.getElementById('lookupModalSave').addEventListener('click', saveLookupItem);
            document.getElementById('lookupModalInput').addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    saveLookupItem();
                }
            });
            document.getElementById('lookupModal').addEventListener('click', function (e) {
                if (e.target === this) {
                    closeLookupModal();
                }
            });
        </script>
    </body>
</html>

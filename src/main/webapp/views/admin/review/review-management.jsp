<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <title>HeavenScape - Review Management</title>
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
                            "inverse-primary": "#FFB3B0",
                            "surface-bright": "#FFFFFF",
                            "on-error": "#FFFFFF",
                            "tertiary-fixed": "#FFE8A3",
                            "on-tertiary-fixed": "#241A00",
                            "tertiary": "#F5A623",
                            "error": "#D32F2F",
                            "secondary": "#F97316",
                            "surface-container-highest": "#E3E3E6",
                            "inverse-on-surface": "#F5F5F5",
                            "secondary-fixed": "#FFDCC0",
                            "surface": "#FFFFFF",
                            "on-tertiary-container": "#402D00",
                            "background": "#F7F7F8",
                            "secondary-fixed-dim": "#FFB876",
                            "primary-container": "#FDE8E9",
                            "on-secondary": "#FFFFFF",
                            "on-secondary-fixed": "#2B1700",
                            "tertiary-fixed-dim": "#F0C34D",
                            "primary-fixed": "#FFDAD9",
                            "on-background": "#1B1B1B",
                            "surface-container-low": "#F7F7F8",
                            "primary": "#C92127",
                            "inverse-surface": "#303030",
                            "surface-container-high": "#EBEBED",
                            "secondary-container": "#FFE3C2",
                            "tertiary-container": "#FFF3D6",
                            "on-surface-variant": "#5C5C5F",
                            "surface-variant": "#EFE0DF",
                            "warning": "#F9A825",
                            "on-tertiary-fixed-variant": "#5C4200",
                            "on-error-container": "#93000A",
                            "on-tertiary": "#402D00",
                            "primary-fixed-dim": "#FFB3B0",
                            "surface-dim": "#E9E9EB",
                            "outline": "#8F8F92",
                            "on-primary": "#FFFFFF",
                            "surface-container-lowest": "#FFFFFF",
                            "surface-container": "#F1F1F3",
                            "surface-tint": "#C92127",
                            "on-primary-fixed-variant": "#93000A",
                            "success": "#2E7D32",
                            "on-secondary-container": "#7A3A00",
                            "outline-variant": "#D9D9DC",
                            "on-surface": "#1B1B1B",
                            "error-container": "#FFDAD6",
                            "on-primary-container": "#7A0F13",
                            "on-secondary-fixed-variant": "#7A3A00",
                            "background-alt": "#FFFFFF",
                            "on-primary-fixed": "#410006"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "0.75rem",
                            "full": "9999px"
                        },
                        "spacing": {
                            "stack-lg": "48px",
                            "base": "8px",
                            "stack-sm": "12px",
                            "margin-mobile": "16px",
                            "container-max": "1280px",
                            "stack-md": "24px",
                            "margin-desktop": "64px",
                            "gutter": "24px"
                        },
                        "fontFamily": {
                            "label-md": ["Inter"],
                            "headline-md": ["Inter"],
                            "headline-xl": ["Inter"],
                            "label-sm": ["Inter"],
                            "body-sm": ["Inter"],
                            "body-md": ["Inter"],
                            "body-lg": ["Inter"],
                            "headline-lg-mobile": ["Inter"],
                            "headline-sm": ["Inter"],
                            "headline-lg": ["Inter"]
                        },
                        "fontSize": {
                            "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.01em", "fontWeight": "600"}],
                            "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                            "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                            "label-sm": ["12px", {"lineHeight": "16px", "fontWeight": "500"}],
                            "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                            "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                            "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                            "headline-lg-mobile": ["28px", {"lineHeight": "36px", "fontWeight": "700"}],
                            "headline-sm": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                            "headline-lg": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}]
                        }
                    },
                },
            }
        </script>
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #F7F7F8;
            }
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
            .stars-fill {
                font-variation-settings: 'FILL' 1;
            }
            .custom-scrollbar::-webkit-scrollbar {
                width: 6px;
            }
            .custom-scrollbar::-webkit-scrollbar-track {
                background: transparent;
            }
            .custom-scrollbar::-webkit-scrollbar-thumb {
                background: #FDE8E9;
                border-radius: 10px;
            }
            .shadow-tonal {
                box-shadow: 0 4px 20px -2px rgba(21, 101, 192, 0.08);
            }
        </style>
    </head>
    <body class="text-on-surface">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <main class="ml-64 flex-1 flex flex-col min-h-screen">
            <div class="p-6 flex-1 space-y-6 max-w-screen-xl mx-auto w-full">
                <div class="hs-admin-page-heading">
                    <div>
                        <h1 class="hs-admin-page-title">Review Management</h1>
                        <p class="hs-admin-page-subtitle">Review and moderate customer feedback.</p>
                    </div>
                </div>
                <section class="bg-surface p-stack-sm rounded-xl shadow-sm border border-outline-variant/50 mb-stack-md flex flex-wrap gap-4 items-center">
                    <div class="flex flex-1 gap-2 min-w-[300px]">
                        <div class="relative flex-1">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant text-[20px]" data-icon="search">search</span>
                            <input id="searchInput" class="w-full pl-10 pr-4 py-2 border border-outline-variant rounded-lg focus:ring-1 focus:ring-primary focus:outline-none font-body-sm text-body-sm"
                                   placeholder="Search by customer or book name..." type="text"
                                   value="${fn:escapeXml(searchValue)}"/>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <span class="font-label-sm text-label-sm text-on-surface-variant">Rating:</span>
                        <select id="ratingSelect" class="border border-outline-variant rounded-lg py-2 pl-3 pr-8 font-body-sm text-body-sm focus:ring-1 focus:ring-primary focus:outline-none appearance-none bg-no-repeat bg-[right_8px_center]">
                            <option value="" ${empty ratingValue ? 'selected' : ''}>All Ratings</option>
                            <option value="5" ${ratingValue == '5' ? 'selected' : ''}>5 sao</option>
                            <option value="4" ${ratingValue == '4' ? 'selected' : ''}>4 sao</option>
                            <option value="3" ${ratingValue == '3' ? 'selected' : ''}>3 sao</option>
                            <option value="2" ${ratingValue == '2' ? 'selected' : ''}>2 sao</option>
                            <option value="1" ${ratingValue == '1' ? 'selected' : ''}>1 sao</option>
                        </select>
                    </div>
                    <div class="flex items-center gap-3">
                        <span class="font-label-sm text-label-sm text-on-surface-variant">Status:</span>
                        <div id="statusGroup" class="flex bg-background-alt p-1 rounded-lg border border-outline-variant">
                            <button type="button" data-status="all"
                                    class="px-4 py-1.5 rounded-md font-label-sm text-label-sm transition-all ${statusValue == 'all' ? 'bg-surface shadow-sm text-primary' : 'text-on-surface-variant hover:text-on-surface'}">All</button>
                            <button type="button" data-status="pending"
                                    class="px-4 py-1.5 rounded-md font-label-sm text-label-sm transition-all ${statusValue == 'pending' ? 'bg-surface shadow-sm text-primary' : 'text-on-surface-variant hover:text-on-surface'}">Pending</button>
                            <button type="button" data-status="approved"
                                    class="px-4 py-1.5 rounded-md font-label-sm text-label-sm transition-all ${statusValue == 'approved' ? 'bg-surface shadow-sm text-primary' : 'text-on-surface-variant hover:text-on-surface'}">Approved</button>
                        </div>
                    </div>
                </section>
                <section class="bg-surface rounded-2xl shadow-tonal border border-outline-variant/30 overflow-hidden">
                    <div class="overflow-x-auto custom-scrollbar">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-surface-container-low border-b border-outline-variant">
                                    <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Customer</th>
                                    <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Book</th>
                                    <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Review</th>
                                    <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Content</th>
                                    <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Reply</th>
                                    <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Date</th>
                                    <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Status</th>
                                    <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-outline-variant/30">
                                <c:choose>
                                    <c:when test="${not empty reviews}">
                                        <c:forEach items="${reviews}" var="review">
                                            <tr class="hover:bg-surface-container-lowest transition-colors group ${review.isHidden ? 'opacity-50 bg-gray-100' : ''}">
                                                <td class="px-6 py-5">
                                                    <div class="flex items-center gap-3">
                                                        <span class="font-label-md text-label-md text-on-surface">${review.customerName}</span>
                                                        <c:if test="${review.isHidden}">
                                                            <span class="text-xs px-2 py-1 bg-gray-400 text-white rounded">Hidden</span>
                                                        </c:if>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-5">
                                                    <div class="flex items-center gap-3">
                                                       
                                                        <span class="font-body-sm text-body-sm text-on-surface max-w-[120px] line-clamp-2">${review.bookTitle}</span>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-5">
                                                    <div class="flex gap-0.5 text-secondary">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <span class="material-symbols-outlined text-[16px] ${i <= review.rating ? 'stars-fill' : ''}" data-icon="star" style="font-variation-settings: 'FILL' ${i <= review.rating ? '1' : '0'};">star</span>
                                                        </c:forEach>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-5">
                                                    <p class="font-body-sm text-body-sm text-on-surface-variant max-w-[200px] line-clamp-2">${review.comment}</p>
                                                </td>
                                                <td class="px-6 py-5">
                                                    <c:choose>
                                                        <c:when test="${not empty review.adminReply}">
                                                            <div class="max-w-[260px] rounded-lg border border-primary/20 bg-primary-container/40 px-3 py-2">
                                                                <div class="mb-1 flex items-center justify-between gap-2 text-primary">
                                                                    <div class="flex items-center gap-1.5">
                                                                        <span class="material-symbols-outlined text-[16px]" data-icon="reply">reply</span>
                                                                        <span class="font-label-sm text-label-sm">Staff/Admin reply</span>
                                                                    </div>
                                                                    <div class="flex items-center gap-1">
                                                                        <button type="button" data-edit-reply-btn
                                                                                data-review-id="${review.reviewID}"
                                                                                data-customer-name="${fn:escapeXml(review.customerName)}"
                                                                                data-book-title="${fn:escapeXml(review.bookTitle)}"
                                                                                data-rating="${review.rating}"
                                                                                data-comment="${fn:escapeXml(review.comment)}"
                                                                                data-reply="${fn:escapeXml(review.adminReply)}"
                                                                                class="rounded p-1 hover:bg-primary/10"
                                                                                title="Update Staff/Admin Reply">
                                                                            <span class="material-symbols-outlined text-[16px]">edit</span>
                                                                        </button>
                                                                        <button type="button" data-delete-reply-btn
                                                                                data-review-id="${review.reviewID}"
                                                                                class="rounded p-1 text-error hover:bg-error/10"
                                                                                title="Delete Staff/Admin Reply">
                                                                            <span class="material-symbols-outlined text-[16px]">delete</span>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                                <p class="whitespace-pre-line break-words font-body-sm text-body-sm text-on-surface"><c:out value="${review.adminReply}"/></p>
                                                                <c:if test="${review.adminReplyDate != null}">
                                                                    <span class="mt-1.5 block text-[11px] text-on-surface-variant">
                                                                        <fmt:formatDate value="${review.adminReplyDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                                    </span>
                                                                </c:if>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="font-body-sm text-body-sm italic text-on-surface-variant">Not replied yet</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-5">
                                                    <span class="font-body-sm text-body-sm text-on-surface-variant">
                                                        <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/>
                                                    </span>
                                                </td>
                                                <td class="px-6 py-5">
                                                    <c:choose>
                                                        <c:when test="${review.status == 'Approved'}">
                                                            <span class="px-3 py-1 bg-success/10 text-success rounded-full font-label-sm text-label-sm inline-block">Approved</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="px-3 py-1 bg-warning/10 text-warning rounded-full font-label-sm text-label-sm inline-block">Pending Approval</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-5 text-right">
                                                    <div class="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                                        <c:if test="${review.status != 'Approved' && !review.isHidden && review.customerStatus == 'active'}">
                                                            <button data-reply-btn 
                                                                    data-review-id="${review.reviewID}"
                                                                    data-customer-name="${review.customerName}"
                                                                    data-book-title="${review.bookTitle}"
                                                                    data-rating="${review.rating}"
                                                                    data-comment="${review.comment}"
                                                                    class="p-2 hover:bg-surface-container-low rounded-lg text-primary transition-all border border-transparent hover:border-primary/20" 
                                                                    title="Reply">
                                                                <span class="material-symbols-outlined text-[20px]" data-icon="reply">reply</span>
                                                            </button>
                                                        </c:if>
                                                        <button data-hide-btn 
                                                                data-review-id="${review.reviewID}"
                                                                class="p-2 hover:bg-warning/10 rounded-lg text-warning transition-all border border-transparent hover:border-warning/20" 
                                                                title="${review.isHidden ? 'Show Review' : 'Hide Review'}">
                                                            <span class="material-symbols-outlined text-[20px]" data-icon="${review.isHidden ? 'visibility' : 'visibility_off'}">
                                                                ${review.isHidden ? 'visibility' : 'visibility_off'}
                                                            </span>
                                                        </button>
                                                        <button data-lock-btn 
                                                                data-review-id="${review.reviewID}"
                                                                data-customer-id="${review.customerID}"
                                                                ${review.customerStatus == 'inactive' ? 'disabled' : ''}
                                                                class="p-2 hover:bg-error/10 rounded-lg text-error transition-all border border-transparent hover:border-error/20 ${review.customerStatus == 'inactive' ? 'opacity-50 cursor-not-allowed' : ''}" 
                                                                title="${review.customerStatus == 'inactive' ? 'Account is locked' : 'Lock Account'}">
                                                            <span class="material-symbols-outlined text-[20px]" data-icon="lock">lock</span>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" class="px-6 py-8 text-center">
                                                <p class="font-body-md text-on-surface-variant">No reviews found</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <div class="px-6 py-4 flex items-center justify-between border-t border-outline-variant bg-surface-container-lowest">
                        <span class="font-body-sm text-body-sm text-on-surface-variant">Showing ${reviews.size()} reviews</span>
                        <div class="flex gap-2">
                            <button class="p-2 rounded-lg border border-outline-variant hover:bg-surface-container-low disabled:opacity-50 disabled:cursor-not-allowed transition-all" disabled="">
                                <span class="material-symbols-outlined" data-icon="chevron_left">chevron_left</span>
                            </button>
                            <button class="w-10 h-10 rounded-lg bg-primary text-on-primary font-label-md text-label-md">1</button>
                            <button class="p-2 rounded-lg border border-outline-variant hover:bg-surface-container-low transition-all">
                                <span class="material-symbols-outlined" data-icon="chevron_right">chevron_right</span>
                            </button>
                        </div>
                    </div>
                </section>
            </div>

            <%@ include file="/views/layout/dashboard/footer.jsp" %>

        </main>
        <div id="confirmModal" class="fixed inset-0 bg-black/50 hidden items-center justify-center z-50">
            <div class="bg-white w-[450px] rounded-xl p-6 relative">
                <button class="absolute top-3 right-4 text-2xl hover:text-gray-500 close-confirm">×</button>
                <h3 class="text-xl font-bold mb-4" id="confirmTitle">Confirm Action</h3>
                <p class="text-gray-600 mb-6" id="confirmMessage">Are you sure you want to continue?</p>
                <div class="flex justify-end gap-3">
                    <button class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100 close-confirm">
                        Cancel
                    </button>
                    <button id="confirmAction" class="px-4 py-2 bg-primary text-white rounded-lg hover:opacity-90">
                        Confirm
                    </button>
                </div>
            </div>
        </div>

        <script>
            var replyModal = null;
            var replyForm = null;
            var closeReplyBtn = null;
            var confirmModal = null;
            var currentReviewID = null;
            var pendingAction = null;
            var REVIEW_API_URL = '${pageContext.request.contextPath}/dashboard/review-management';

            function initReplyModal() {
                if (!document.getElementById('replyModal')) {
                    createReplyModal();
                }
                replyModal = document.getElementById('replyModal');
                replyForm = document.getElementById('replyForm');
                closeReplyBtn = document.getElementById('closeReplyModal');
                if (closeReplyBtn) {
                    closeReplyBtn.addEventListener('click', closeModal);
                }
                if (replyForm) {
                    replyForm.addEventListener('submit', submitReply);
                }
                if (replyModal) {
                    replyModal.addEventListener('click', function (e) {
                        if (e.target === replyModal) {
                            closeModal();
                        }
                    });
                }
            }

            function initConfirmModal() {
                confirmModal = document.getElementById('confirmModal');
                document.querySelectorAll('.close-confirm').forEach(btn => {
                    btn.addEventListener('click', closeConfirmModal);
                });

                if (confirmModal) {
                    confirmModal.addEventListener('click', function (e) {
                        if (e.target === confirmModal) {
                            closeConfirmModal();
                        }
                    });
                }

                document.getElementById('confirmAction').addEventListener('click', executeAction);
            }

            function createReplyModal() {
                const modalHTML = `
                    <div id="replyModal" class="fixed inset-0 bg-black/50 hidden items-center justify-center z-50">
                        <div class="bg-white w-[600px] rounded-xl p-6 relative max-h-[90vh] overflow-y-auto">
                            <button id="closeReplyModal" class="absolute top-3 right-4 text-2xl hover:text-gray-500">×</button>
                            
                            <h3 id="replyModalTitle" class="text-xl font-bold mb-4">Reply to Review</h3>
                            
                            <div id="reviewPreview" class="mb-6 p-4 bg-gray-50 rounded-lg border border-gray-200">
                                <p class="text-sm text-gray-600 mb-2">
                                    <strong>Customer:</strong> <span id="previewCustomerName">-</span>
                                </p>
                                <p class="text-sm text-gray-600 mb-2">
                                    <strong>Book:</strong> <span id="previewBookTitle">-</span>
                                </p>
                                <p class="text-sm text-gray-600 mb-2">
                                    <strong>Review:</strong> <span id="previewRating">-</span>
                                </p>
                                <p class="text-sm text-gray-600">
                                    <strong>Content:</strong>
                                </p>
                                <p id="previewComment" class="text-sm text-gray-700 mt-1 italic">-</p>
                            </div>
                            
                            <form id="replyForm">
                                <input type="hidden" id="replyReviewID" name="reviewID" value="">
                                <input type="hidden" id="replyAction" name="action" value="reply">
                                
                                <div class="mb-4">
                                    <label class="block font-semibold mb-2">Your Reply</label>
                                    <textarea 
                                        name="reply" 
                                        id="replyContent"
                                        rows="6"
                                        maxlength="2000"
                                        required
                                        placeholder="Enter your reply..."
                                        class="w-full border border-gray-300 rounded-lg p-3 focus:ring-2 focus:ring-primary focus:outline-none">
                                    </textarea>
                                </div>
                                
                                <div class="flex justify-end gap-3">
                                    <button type="button" onclick="closeModal()" class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100">
                                        Cancel
                                    </button>
                                    <button type="submit" id="replySubmitButton" class="px-4 py-2 bg-primary text-white rounded-lg hover:opacity-90">
                                        Send Reply
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                `;

                document.body.insertAdjacentHTML('beforeend', modalHTML);
            }

            function openReplyModal(reviewID, customerName, bookTitle, rating, comment, existingReply, editMode) {
                currentReviewID = reviewID;
                const editing = editMode === true;

                document.getElementById('previewCustomerName').textContent = customerName;
                document.getElementById('previewBookTitle').textContent = bookTitle;
                document.getElementById('previewRating').textContent = '⭐'.repeat(rating);
                document.getElementById('previewComment').textContent = comment;
                document.getElementById('replyReviewID').value = reviewID;
                document.getElementById('replyAction').value = editing ? 'editReply' : 'reply';
                document.getElementById('replyContent').value = editing ? (existingReply || '') : '';
                document.getElementById('replyModalTitle').textContent = editing
                        ? 'Update Staff/Admin Reply'
                        : 'Reply to Review';
                document.getElementById('replySubmitButton').textContent = editing
                        ? 'Save Changes'
                        : 'Send Reply';

                replyModal.classList.remove('hidden');
                replyModal.classList.add('flex');
            }

            function closeModal() {
                if (replyModal) {
                    replyModal.classList.add('hidden');
                    replyModal.classList.remove('flex');
                }
            }

            function openConfirmModal(title, message, action) {
                document.getElementById('confirmTitle').textContent = title;
                document.getElementById('confirmMessage').textContent = message;
                pendingAction = action;

                confirmModal.classList.remove('hidden');
                confirmModal.classList.add('flex');
            }

            function closeConfirmModal() {
                confirmModal.classList.add('hidden');
                confirmModal.classList.remove('flex');
                pendingAction = null;
            }

            function executeAction() {
                if (pendingAction) {
                    pendingAction();
                    closeConfirmModal();
                }
            }

            function submitReply(e) {
                e.preventDefault();

                const formData = new URLSearchParams(new FormData(replyForm));

                fetch(REVIEW_API_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData.toString()
                })
                        .then(res => {
                            if (!res.ok)
                                throw new Error('Network response was not ok');
                            return res.json();
                        })
                        .then(data => {
                            if (data.success) {
                                showToast(data.message || 'Reply sent successfully');
                                closeModal();

                                // Reload trang sau 1 giây
                                setTimeout(() => {
                                    location.reload();
                                }, 1000);
                            } else {
                                showToast(data.message || 'An error occurred', true);
                            }
                        })
                        .catch(err => {
                            console.error('Error:', err);
                            showToast('An error occurred', true);
                        });
            }

            function deleteReply(reviewID) {
                const formData = new URLSearchParams();
                formData.append('action', 'deleteReply');
                formData.append('reviewID', reviewID);

                fetch(REVIEW_API_URL, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: formData.toString()
                })
                        .then(res => res.json())
                        .then(data => {
                            if (!data.success) {
                                showToast(data.message || 'Could not delete the reply', true);
                                return;
                            }
                            showToast(data.message || 'Reply deleted successfully');
                            setTimeout(() => location.reload(), 700);
                        })
                        .catch(err => {
                            console.error('Error:', err);
                            showToast('Could not connect to the server', true);
                        });
            }

            function hideReview(reviewID) {
                const formData = new URLSearchParams();
                formData.append('action', 'hide');
                formData.append('reviewID', reviewID);

                fetch(REVIEW_API_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData.toString()
                })
                        .then(res => res.json())
                        .then(data => {
                            if (data.success) {
                                showToast(data.message || 'Review hidden successfully');
                                setTimeout(() => {
                                    location.reload();
                                }, 1000);
                            } else {
                                showToast(data.message || 'An error occurred', true);
                            }
                        })
                        .catch(err => {
                            console.error('Error:', err);
                            showToast('An error occurred', true);
                        });
            }

            function lockAccount(reviewID, customerID) {
                const formData = new URLSearchParams();
                formData.append('action', 'lock');
                formData.append('reviewID', reviewID);
                formData.append('customerID', customerID);

                fetch(REVIEW_API_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData.toString()
                })
                        .then(res => res.json())
                        .then(data => {
                            if (data.success) {
                                showToast(data.message || 'Account locked successfully');
                                setTimeout(() => {
                                    location.reload();
                                }, 1000);
                            } else {
                                showToast(data.message || 'An error occurred', true);
                            }
                        })
                        .catch(err => {
                            console.error('Error:', err);
                            showToast('An error occurred', true);
                        });
            }

            function showToast(message, isError = false) {
                const toastContainer = document.getElementById('toastContainer') || createToastContainer();

                const toast = document.createElement('div');
                toast.className = `px-4 py-3 rounded-lg text-white mb-2 ${isError ? 'bg-red-500' : 'bg-green-500'}`;
                toast.textContent = message;

                toastContainer.appendChild(toast);

                setTimeout(() => {
                    toast.remove();
                }, 3000);
            }

            function createToastContainer() {
                const container = document.createElement('div');
                container.id = 'toastContainer';
                container.className = 'fixed bottom-4 right-4 z-[9999]';
                document.body.appendChild(container);
                return container;
            }

            document.addEventListener('DOMContentLoaded', function () {
                initReplyModal();
                initConfirmModal();
                initReplyButtons();
                initEditReplyButtons();
                initDeleteReplyButtons();
                initHideButtons();
                initLockButtons();
            });

            function initReplyButtons() {
                document.querySelectorAll('[data-reply-btn]').forEach(btn => {
                    btn.addEventListener('click', function (e) {
                        e.preventDefault();

                        const reviewID = this.dataset.reviewId;
                        const customerName = this.dataset.customerName;
                        const bookTitle = this.dataset.bookTitle;
                        const rating = this.dataset.rating;
                        const comment = this.dataset.comment;

                        openReplyModal(reviewID, customerName, bookTitle, rating, comment);
                    });
                });
            }

            function initEditReplyButtons() {
                document.querySelectorAll('[data-edit-reply-btn]').forEach(btn => {
                    btn.addEventListener('click', function (event) {
                        event.preventDefault();
                        openReplyModal(
                                this.dataset.reviewId,
                                this.dataset.customerName,
                                this.dataset.bookTitle,
                                this.dataset.rating,
                                this.dataset.comment,
                                this.dataset.reply,
                                true
                                );
                    });
                });
            }

            function initDeleteReplyButtons() {
                document.querySelectorAll('[data-delete-reply-btn]').forEach(btn => {
                    btn.addEventListener('click', function (event) {
                        event.preventDefault();
                        const reviewID = this.dataset.reviewId;
                        openConfirmModal(
                                'Delete Staff/Admin Reply',
                                'Are you sure you want to delete this staff/admin reply? The customer review will remain unchanged.',
                                () => deleteReply(reviewID)
                        );
                    });
                });
            }

            function initHideButtons() {
                document.querySelectorAll('[data-hide-btn]').forEach(btn => {
                    btn.addEventListener('click', function (e) {
                        e.preventDefault();
                        const reviewID = this.dataset.reviewId;

                        openConfirmModal(
                                'Hide Review',
                                'Are you sure you want to hide this review? It will no longer appear on the product page.',
                                () => hideReview(reviewID)
                        );
                    });
                });
            }

            function initLockButtons() {
                document.querySelectorAll('[data-lock-btn]').forEach(btn => {
                    btn.addEventListener('click', function (e) {
                        e.preventDefault();
                        const reviewID = this.dataset.reviewId;
                        const customerID = this.dataset.customerId;

                        openConfirmModal(
                                'Lock Account',
                                '⚠️ Are you sure you want to lock this customer account? They will no longer be able to sign in or use the system.',
                                () => lockAccount(reviewID, customerID)
                        );
                    });
                });
            }
            (function () {
                const searchInput = document.getElementById('searchInput');
                const ratingSelect = document.getElementById('ratingSelect');
                const statusButtons = document.querySelectorAll('#statusGroup button');

                function buildUrl(overrides) {
                    const params = new URLSearchParams(window.location.search);

                    const search = overrides.search !== undefined ? overrides.search : (searchInput ? searchInput.value : '');
                    const rating = overrides.rating !== undefined ? overrides.rating : (ratingSelect ? ratingSelect.value : '');
                    const status = overrides.status !== undefined ? overrides.status : (params.get('status') || 'all');

                    if (search) {
                        params.set('search', search);
                    } else {
                        params.delete('search');
                    }
                    if (rating) {
                        params.set('rating', rating);
                    } else {
                        params.delete('rating');
                    }
                    if (status && status !== 'all') {
                        params.set('status', status);
                    } else {
                        params.delete('status');
                    }

                    return REVIEW_API_URL + '?' + params.toString();
                }

                let debounceTimer = null;
                if (searchInput) {
                    searchInput.addEventListener('input', function () {
                        clearTimeout(debounceTimer);
                        debounceTimer = setTimeout(function () {
                            window.location.href = buildUrl({});
                        }, 500);
                    });
                }

                if (ratingSelect) {
                    ratingSelect.addEventListener('change', function () {
                        window.location.href = buildUrl({});
                    });
                }

                statusButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        window.location.href = buildUrl({status: this.dataset.status});
                    });
                });
            })();
        </script>
    </body>
</html>

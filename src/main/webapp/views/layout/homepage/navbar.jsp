<%@ page import="dao.CategoryDAO" %>
<%@ page import="model.Category" %>
<%@ page import="java.util.List" %>

<%
    CategoryDAO categoryDAO = new CategoryDAO();
    List<Category> categories = categoryDAO.getAllCategories();
%>

<div class="category-navbar-shell">
    <nav class="category-navbar" aria-label="Book Categories">
        <a class="cat-nav-home" href="<%= request.getContextPath() %>/products">
            <i data-lucide="layout-grid" class="icon-sm"></i>
            All Books
        </a>
        <%
            if (categories != null && !categories.isEmpty()) {
                for (Category category : categories) {
        %>
                    <a class="cat-nav-item"
                       href="<%= request.getContextPath() %>/products?category=<%= category.getCategoryID() %>">
                        <%= category.getCategoryName() %>
                    </a>
        <%
                }
            }
        %>
    </nav>
</div>

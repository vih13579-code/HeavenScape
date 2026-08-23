<%@ page import="dao.GenreDAO" %>
<%@ page import="model.Genre" %>
<%@ page import="java.util.List" %>

<%
    GenreDAO genreDAO = new GenreDAO();
    List<Genre> genres = genreDAO.getAllGenres();
%>

<div class="category-navbar-shell">
    <nav class="category-navbar" aria-label="Book Genres">
        <a class="cat-nav-home" href="<%= request.getContextPath() %>/products">
            <i data-lucide="layout-grid" class="icon-sm"></i>
            All Books
        </a>
        <%
            if (genres != null && !genres.isEmpty()) {
                for (Genre genre : genres) {
        %>
                    <a class="cat-nav-item"
                       href="<%= request.getContextPath() %>/products?genre=<%= genre.getGenreID() %>">
                        <%= genre.getGenreName() %>
                    </a>
        <%
                }
            }
        %>
    </nav>
</div>

<%@ page import="dao.GenreDAO" %>
<%@ page import="model.Genre" %>
<%@ page import="java.util.List" %>

<%
    GenreDAO genreDAO = new GenreDAO();
    List<Genre> genres = genreDAO.getAllGenres();
%>

<<<<<<< Updated upstream
<nav class="category-navbar" aria-label="Book Categories">
    <%
        if (genres != null && !genres.isEmpty()) {
            for (Genre genre : genres) {
    %>
                <a class="cat-nav-item"
                   href="<%= request.getContextPath() %>/products?genre=<%= genre.getGenreID() %>">
                    <i data-lucide="book-open"></i>
                    <%= genre.getGenreName() %>
                </a>
    <%
=======
<div class="Genre-navbar-shell">
    <nav class="genre-navbar" aria-label="Book Genres">
        <a class="genre-nav-home" href="<%= request.getContextPath() %>/products">
            <i data-lucide="layout-grid" class="icon-sm"></i>
            All Books
        </a>
        <%
            if (genres != null && !genres.isEmpty()) {
                for (Genre genre : genres) {
        %>
                    <a class="genre-nav-item"
                       href="<%= request.getContextPath() %>/products?genre=<%= genre.getGenreID() %>">
                        <%= genre.getGenreName() %>
                    </a>
        <%
                }
>>>>>>> Stashed changes
            }
        }
    %>
</nav>

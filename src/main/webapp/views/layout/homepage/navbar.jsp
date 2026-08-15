<%@ page import="dao.GenreDAO" %>
<%@ page import="model.Genre" %>
<%@ page import="java.util.List" %>

<%
    GenreDAO genreDAO = new GenreDAO();
    List<Genre> genres = genreDAO.getAllGenres();
%>

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
            }
        }
    %>
</nav>

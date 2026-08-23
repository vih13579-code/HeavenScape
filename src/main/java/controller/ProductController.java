package controller;

import dao.BookDAO;
import dao.ReviewDAO;
import dao.WishListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Book;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import model.Review;


public class ProductController extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 12;
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        String actionParam = req.getParameter("action");

        String action;
        if (idParam != null) {
            action = "detail";
        } else if (actionParam != null) {
            action = actionParam.trim().toLowerCase();
        } else {
            action = "list";
        }

        switch (action) {
            case "list":     showList(req, resp);             break;
            case "detail":   showDetail(req, resp, idParam);  break;
            case "featured": showFeatured(req, resp);         break;
            default:         show404(req, resp, "Unknown action: " + action);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }


    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page      = parsePage(req.getParameter("page"));
        int pageSize  = parsePageSize(req.getParameter("size"));
        String sort    = req.getParameter("sort");
        String keyword = normalizeText(req.getParameter("keyword"));
        String order   = buildOrderClause(sort);

        List<Integer> selectedGenreIDs = parsePositiveIntParams(req.getParameterValues("genre"));
        List<Integer> selectedAuthorIDs = parsePositiveIntParams(req.getParameterValues("author"));
        List<String> availability = parseAvailability(req.getParameterValues("availability"));
        Integer genreID = selectedGenreIDs.size() == 1 ? selectedGenreIDs.get(0) : null;
        BigDecimal minPrice = parsePriceParam(req.getParameter("minPrice"));
        BigDecimal maxPrice = parsePriceParam(req.getParameter("maxPrice"));
        String priceRangeError = null;
        if (minPrice != null && maxPrice != null && minPrice.compareTo(maxPrice) > 0) {
            priceRangeError = "Minimum price cannot be greater than maximum price.";
            minPrice = null;
            maxPrice = null;
        }

        int totalBooks = bookDAO.countBooksFiltered(keyword, selectedGenreIDs,
                selectedAuthorIDs, minPrice, maxPrice, availability);
        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);
        if (totalPages == 0) totalPages = 1;

        if (page > totalPages) {
            page = totalPages;
        }

        int offset = (page - 1) * pageSize;
        List<Book> books = bookDAO.getBooksFiltered(offset, pageSize, order,
                keyword, selectedGenreIDs, selectedAuthorIDs, minPrice, maxPrice,
                availability);

        Map<Integer, String> genreMap = bookDAO.getGenreMap();
        Map<Integer, String> authorMap = bookDAO.getCatalogAuthorMap();

        HttpSession session = req.getSession(false);
        java.util.Set<String> wishlistBookIds = new java.util.HashSet<>();
        if (session != null) {
            Account acc = (Account) session.getAttribute("account");
            if (acc != null && "customer".equals(acc.getRole())) {
                WishListDAO wDAO = new WishListDAO();
                wDAO.getWishlistItems(acc.getId())
                    .forEach(wi -> wishlistBookIds.add(String.valueOf(wi.getBookID())));
                session.setAttribute("wishlistCount", wDAO.countWishlistItems(acc.getId()));
            }
        }

        req.setAttribute("books",           books);
        req.setAttribute("page",            page);
        req.setAttribute("pageSize",        pageSize);
        req.setAttribute("totalPages",      totalPages);
        req.setAttribute("totalBooks",      totalBooks);
        req.setAttribute("sort",            sort);
        req.setAttribute("keyword",         keyword);
        req.setAttribute("genreID",         genreID);
        req.setAttribute("selectedGenreIDs", selectedGenreIDs);
        req.setAttribute("selectedAuthorIDs", selectedAuthorIDs);
        req.setAttribute("availability",    availability);
        req.setAttribute("availabilityAvailable", availability.contains("available"));
        req.setAttribute("availabilityOutOfStock", availability.contains("out_of_stock"));
        req.setAttribute("minPrice",        minPrice);
        req.setAttribute("maxPrice",        maxPrice);
        req.setAttribute("priceRangeError", priceRangeError);
        req.setAttribute("hasPriceFilter",  minPrice != null || maxPrice != null);
        req.setAttribute("hasActiveFilters", !selectedGenreIDs.isEmpty()
                || !selectedAuthorIDs.isEmpty() || !availability.isEmpty()
                || minPrice != null || maxPrice != null);
        req.setAttribute("genreMap",        genreMap);
        req.setAttribute("authorMap",       authorMap);
        req.setAttribute("wishlistBookIds", wishlistBookIds);

        req.getRequestDispatcher("/views/book/book-index.jsp").forward(req, resp);
    }

 
    private void showDetail(HttpServletRequest req, HttpServletResponse resp, String idParam)
            throws ServletException, IOException {

        int bookID = parseID(idParam);
        if (bookID <= 0) { show404(req, resp, "Invalid book ID: " + idParam); return; }

        Book book = bookDAO.getBookByID(bookID);
        if (book == null) { show404(req, resp, "No book found with ID = " + bookID); return; }

        List<Book> relatedBooks = bookDAO.getRelatedBooks(bookID, book.getGenreID(), 4);

        ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> reviews = reviewDAO.getReviewsByBook(bookID);

 
        boolean canReview = false;
        boolean inWishlist = false;
        java.util.Set<String> wishlistBookIds = new java.util.HashSet<>();

        HttpSession session = req.getSession(false);
        if (session != null) {
            Account acc = (Account) session.getAttribute("account");
            if (acc != null && "customer".equals(acc.getRole())) {
                canReview = reviewDAO.canReview(acc.getId(), bookID);
                WishListDAO wDAO = new WishListDAO();
                inWishlist = wDAO.isInWishlist(acc.getId(), bookID);
                wDAO.getWishlistItems(acc.getId()).forEach(wi -> wishlistBookIds.add(String.valueOf(wi.getBookID())));
            }
        }

        String addResult = req.getParameter("addResult");
        if ("success".equals(addResult)) {
            req.setAttribute("successMessage", "Added to cart!");
        } else if ("error".equals(addResult)) {
            req.setAttribute("errorMessage", "Could not add to cart.");
        }
        String wishResult = req.getParameter("wishResult");
        if ("added".equals(wishResult)) {
            req.setAttribute("successMessage", "Added to wishlist!");
        } else if ("removed".equals(wishResult)) {
            req.setAttribute("successMessage", "Removed from wishlist!");
        } else if ("wishError".equals(wishResult)) {
            String wishMessage = req.getParameter("wishMessage");
            req.setAttribute("errorMessage",
                    wishMessage != null && !wishMessage.isBlank()
                            ? wishMessage
                            : "Could not add to wishlist.");
        }

        req.setAttribute("book",             book);
        req.setAttribute("relatedBooks",     relatedBooks);
        req.setAttribute("reviews",          reviews);
        req.setAttribute("canReview",        canReview);
        req.setAttribute("inWishlist",       inWishlist);
        req.setAttribute("wishlistBookIds",  wishlistBookIds);

        req.getRequestDispatcher("/views/book/product-detail.jsp").forward(req, resp);
    }


    private void showFeatured(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Book> featuredBooks = bookDAO.getFeaturedByOrders(10);
        Map<Integer, String> genreMap = bookDAO.getGenreMap();
        Map<Integer, String> authorMap = bookDAO.getCatalogAuthorMap();

        req.setAttribute("featuredBooks", featuredBooks);
        req.setAttribute("books",         featuredBooks);
        req.setAttribute("page",          1);
        req.setAttribute("pageSize",      featuredBooks.size());
        req.setAttribute("totalPages",    1);
        req.setAttribute("totalBooks",    featuredBooks.size());
        req.setAttribute("sort",          "popular");
        req.setAttribute("genreMap",      genreMap);
        req.setAttribute("authorMap",     authorMap);
        req.setAttribute("selectedGenreIDs", Collections.emptyList());
        req.setAttribute("selectedAuthorIDs", Collections.emptyList());
        req.setAttribute("availability",  Collections.emptyList());
        req.setAttribute("availabilityAvailable", false);
        req.setAttribute("availabilityOutOfStock", false);
        req.setAttribute("hasPriceFilter", false);
        req.setAttribute("hasActiveFilters", false);

        HttpSession session = req.getSession(false);
        java.util.Set<String> wishlistBookIds = new java.util.HashSet<>();
        if (session != null) {
            Account acc = (Account) session.getAttribute("account");
            if (acc != null && "customer".equals(acc.getRole())) {
                WishListDAO wDAO = new WishListDAO();
                wDAO.getWishlistItems(acc.getId()).forEach(wi -> wishlistBookIds.add(String.valueOf(wi.getBookID())));
            }
        }
        req.setAttribute("wishlistBookIds", wishlistBookIds);

        req.getRequestDispatcher("/views/book/book-index.jsp").forward(req, resp);
    }

 
    private void show404(HttpServletRequest req, HttpServletResponse resp, String message)
            throws ServletException, IOException {
        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
        req.setAttribute("errorMessage", message);
        req.setAttribute("backUrl", req.getContextPath() + "/products");
        req.getRequestDispatcher("/views/error/404.jsp").forward(req, resp);
    }


    private int parsePage(String param) {
        if (param == null || param.trim().isEmpty()) return 1;
        try { int p = Integer.parseInt(param.trim()); return p < 1 ? 1 : p; }
        catch (Exception e) { return 1; }
    }

    private int parsePageSize(String param) {
        if (param == null || param.trim().isEmpty()) return DEFAULT_PAGE_SIZE;
        try { int s = Integer.parseInt(param.trim()); return s < 1 ? DEFAULT_PAGE_SIZE : s; }
        catch (Exception e) { return DEFAULT_PAGE_SIZE; }
    }

    private int parseID(String param) {
        if (param == null || param.trim().isEmpty()) return -1;
        try { return Integer.parseInt(param.trim()); } catch (Exception e) { return -1; }
    }

    private Integer parseIntParam(String param) {
        if (param == null || param.trim().isEmpty()) return null;
        try { int v = Integer.parseInt(param.trim()); return v > 0 ? v : null; }
        catch (Exception e) { return null; }
    }

    private String normalizeText(String value) {
        if (value == null) return null;
        String normalized = value.trim();
        return normalized.isEmpty() ? null : normalized;
    }

    private List<Integer> parsePositiveIntParams(String[] params) {
        LinkedHashSet<Integer> values = new LinkedHashSet<>();
        if (params != null) {
            for (String param : params) {
                Integer value = parseIntParam(param);
                if (value != null) {
                    values.add(value);
                }
            }
        }
        return new ArrayList<>(values);
    }

    private List<String> parseAvailability(String[] params) {
        LinkedHashSet<String> values = new LinkedHashSet<>();
        if (params != null) {
            for (String param : params) {
                if ("available".equals(param) || "out_of_stock".equals(param)) {
                    values.add(param);
                }
            }
        }
        return new ArrayList<>(values);
    }

    private BigDecimal parsePriceParam(String param) {
        if (param == null || param.trim().isEmpty()) return null;
        try { return new BigDecimal(param.trim()); } catch (Exception e) { return null; }
    }

    private String buildOrderClause(String sortBy) {
        if (sortBy == null || sortBy.trim().isEmpty()) {
            return " ORDER BY b.created_at DESC, b.bookID DESC ";
        }
        switch (sortBy.trim()) {
            case "name":
                return " ORDER BY b.title ASC, b.bookID ASC ";
            case "price_asc":
                return " ORDER BY b.price ASC, b.bookID ASC ";
            case "price_desc":
                return " ORDER BY b.price DESC, b.bookID ASC ";
            case "newest":
                return " ORDER BY b.created_at DESC, b.bookID DESC ";
            case "popular":
                // Keep the catalog's Popular order consistent with Shopping Trends:
                // completed-order sales first, then rating as the tie-breaker.
                return " ORDER BY (SELECT ISNULL(SUM(od.quantity), 0) "
                        + "FROM OrderDetail od "
                        + "JOIN [Order] ord ON ord.orderID = od.orderID "
                        + "WHERE od.bookID = b.bookID "
                        + "AND LOWER(LTRIM(RTRIM(ord.status))) = 'completed') DESC, "
                        + "avg_rating DESC, b.bookID ASC ";
            default:
                return " ORDER BY b.created_at DESC, b.bookID DESC ";
        }
    }
}

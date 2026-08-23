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
import java.util.List;
import java.util.Map;
import model.Review;


public class ProductController extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 12;
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // TODO: implement
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // TODO: implement
    }


    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
<<<<<<< Updated upstream
        // TODO: implement
=======

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
>>>>>>> Stashed changes
    }

 
    private void showDetail(HttpServletRequest req, HttpServletResponse resp, String idParam)
            throws ServletException, IOException {
<<<<<<< Updated upstream
        // TODO: implement
=======

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
>>>>>>> Stashed changes
    }


    private void showFeatured(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
<<<<<<< Updated upstream
        // TODO: implement
=======

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
>>>>>>> Stashed changes
    }

 
    private void show404(HttpServletRequest req, HttpServletResponse resp, String message)
            throws ServletException, IOException {
        // TODO: implement
    }


    private int parsePage(String param) {
        // TODO: implement
        return 0;
    }

    private int parsePageSize(String param) {
        // TODO: implement
        return 0;
    }

    private int parseID(String param) {
        // TODO: implement
        return 0;
    }

    private Integer parseIntParam(String param) {
        // TODO: implement
        return null;
    }

    private BigDecimal parsePriceParam(String param) {
        // TODO: implement
        return null;
    }

    private String buildOrderClause(String sortBy) {
        // TODO: implement
        return null;
    }
}
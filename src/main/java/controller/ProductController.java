package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

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
        String keyword = req.getParameter("keyword");
        String order   = buildOrderClause(sort);

  
        Integer    genreID  = parseIntParam(req.getParameter("genre"));
        BigDecimal minPrice = parsePriceParam(req.getParameter("minPrice"));
        BigDecimal maxPrice = parsePriceParam(req.getParameter("maxPrice"));

        int totalBooks = bookDAO.countBooksFiltered(keyword, genreID, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);
        if (totalPages == 0) totalPages = 1;


        if (page > totalPages) {
            resp.sendRedirect(req.getContextPath() + "/products?page=" + totalPages
                    + "&size=" + pageSize
                    + (sort    != null ? "&sort="    + sort    : "")
                    + (keyword != null ? "&keyword=" + keyword : "")
                    + (genreID != null ? "&genre="   + genreID : ""));
            return;
        }

        int offset = (page - 1) * pageSize;
        List<Book> books = bookDAO.getBooksFiltered(offset, pageSize, order,
                                                     keyword, genreID, minPrice, maxPrice);

 
        Map<Integer, String> genreMap = bookDAO.getGenreMap();

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
        req.setAttribute("minPrice",        minPrice);
        req.setAttribute("maxPrice",        maxPrice);
        req.setAttribute("genreMap",        genreMap);
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

        req.setAttribute("featuredBooks", featuredBooks);
        req.setAttribute("books",         featuredBooks);
        req.setAttribute("page",          1);
        req.setAttribute("pageSize",      featuredBooks.size());
        req.setAttribute("totalPages",    1);
        req.setAttribute("totalBooks",    featuredBooks.size());
        req.setAttribute("sort",          "popular");
        req.setAttribute("genreMap",      genreMap);

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

    private BigDecimal parsePriceParam(String param) {
        if (param == null || param.trim().isEmpty()) return null;
        try { return new BigDecimal(param.trim()); } catch (Exception e) { return null; }
    }

    private String buildOrderClause(String sortBy) {
        if (sortBy == null || sortBy.trim().isEmpty()) return " ORDER BY b.created_at DESC ";
        switch (sortBy.trim()) {
            case "name":       return " ORDER BY b.title ASC ";
            case "price_asc":  return " ORDER BY b.price ASC ";
            case "price_desc": return " ORDER BY b.price DESC ";
            case "newest":     return " ORDER BY b.created_at DESC ";
            case "popular":    return " ORDER BY review_count DESC ";
            default:           return " ORDER BY b.created_at DESC ";
        }
    }
}
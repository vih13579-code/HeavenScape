package controller;

import dao.BookDAO;
import dao.LookupDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import utils.RoleGuard;
import model.Book;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;


public class AdminProductController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final BookDAO bookDAO = new BookDAO();
    private final LookupDAO lookupDAO = new LookupDAO();

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

        req.setAttribute("activeMenu", "product-management");

        int page = parsePage(req.getParameter("page"));
        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");
        Integer genreID = parseIntParam(req.getParameter("genre"));

        int total = bookDAO.countBooksAdmin(keyword, status, genreID);
        int totalPages = Math.max(1, (int) Math.ceil((double) total / PAGE_SIZE));
        if (page > totalPages) {
            page = totalPages;
        }

        List<Book> books = bookDAO.getBooksAdmin((page - 1) * PAGE_SIZE, PAGE_SIZE, keyword, status, genreID);
        Map<Integer, String> genreMap = bookDAO.getGenreMap();

        req.setAttribute("books", books);
        req.setAttribute("total", total);
        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("keyword", keyword);
        req.setAttribute("status", status);
        req.setAttribute("genreID", genreID);
        req.setAttribute("genreMap", genreMap);

        req.getRequestDispatcher("/views/admin/product/product-management.jsp").forward(req, resp);
>>>>>>> Stashed changes
    }


    private void showForm(HttpServletRequest req, HttpServletResponse resp, Book book)
            throws ServletException, IOException {
<<<<<<< Updated upstream
        // TODO: implement
=======
        req.setAttribute("activeMenu", "product-management");
        lookupDAO.ensureDefaultLookups();
        req.setAttribute("book", book);
        req.setAttribute("genreMap", bookDAO.getGenreMap());
        req.setAttribute("originMap", bookDAO.getOriginMap());
        req.setAttribute("contentMap", bookDAO.getContentMap());
        req.setAttribute("seriesMap", bookDAO.getSeriesMap());
        req.setAttribute("publisherMap", bookDAO.getPublisherMap());
        req.setAttribute("formAction", "create");
        req.getRequestDispatcher("/views/admin/product/product-form.jsp").forward(req, resp);
>>>>>>> Stashed changes
    }

 
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
<<<<<<< Updated upstream
        // TODO: implement
=======
        req.setAttribute("activeMenu", "product-management");
        int bookID = parseID(req.getParameter("id"));
        if (bookID <= 0) {
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
            return;
        }
        Book book = bookDAO.getBookByID(bookID);
        if (book == null) {
            req.getSession().setAttribute("errorMessage", "Book not found!");
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
            return;
        }


        String[] imgParts = book.getThumbnail() != null ? book.getThumbnail().split("\\|", -1) : new String[0];
        String img1 = imgParts.length > 0 ? imgParts[0].trim() : "";
        String img2 = imgParts.length > 1 ? imgParts[1].trim() : "";
        String img3 = imgParts.length > 2 ? imgParts[2].trim() : "";
        String img4 = imgParts.length > 3 ? imgParts[3].trim() : "";
        book.setThumbnail(img1); 
        req.setAttribute("image2", img2);
        req.setAttribute("image3", img3);
        req.setAttribute("image4", img4);

        lookupDAO.ensureDefaultLookups();
        req.setAttribute("book", book);
        req.setAttribute("genreMap", bookDAO.getGenreMap());
        req.setAttribute("originMap", bookDAO.getOriginMap());
        req.setAttribute("contentMap", bookDAO.getContentMap());
        req.setAttribute("seriesMap", bookDAO.getSeriesMap());
        req.setAttribute("publisherMap", bookDAO.getPublisherMap());
        req.setAttribute("formAction", "update");
        req.getRequestDispatcher("/views/admin/product/product-form.jsp").forward(req, resp);
>>>>>>> Stashed changes
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
<<<<<<< Updated upstream
        // TODO: implement
=======
        HttpSession session = req.getSession();
        String stockError = validateStockQuantity(req.getParameter("stockQuantity"));
        if (stockError != null) {
            session.setAttribute("errorMessage", stockError);
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management?action=create");
            return;
        }
        String statusError = validateStatusVsStock(req.getParameter("stockQuantity"), req.getParameter("status"));
        if (statusError != null) {
            session.setAttribute("errorMessage", statusError);
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management?action=create");
            return;
        }
        String publisherError = validatePublisher(req.getParameter("publisherID"));
        if (publisherError != null) {
            session.setAttribute("errorMessage", publisherError);
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management?action=create");
            return;
        }
        Book b = buildBookFromRequest(req);
        String authors = req.getParameter("authors");
        boolean ok = bookDAO.createBook(b, authors, b.getGenreIDs(), account.getId());
        if (ok) {
            session.setAttribute("successMessage", "Book added successfully!");
        } else {
            session.setAttribute("errorMessage", "Could not add the book. Please try again!");
        }
        resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
>>>>>>> Stashed changes
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
<<<<<<< Updated upstream
        // TODO: implement
=======
        int bookID = parseID(req.getParameter("bookID"));
        if (bookID <= 0) {
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
            return;
        }
        HttpSession session = req.getSession();
        String stockError = validateStockQuantity(req.getParameter("stockQuantity"));
        if (stockError != null) {
            session.setAttribute("errorMessage", stockError);
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management?action=edit&id=" + bookID);
            return;
        }
        String statusError = validateStatusVsStock(req.getParameter("stockQuantity"), req.getParameter("status"));
        if (statusError != null) {
            session.setAttribute("errorMessage", statusError);
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management?action=edit&id=" + bookID);
            return;
        }
        String publisherError = validatePublisher(req.getParameter("publisherID"));
        if (publisherError != null) {
            session.setAttribute("errorMessage", publisherError);
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management?action=edit&id=" + bookID);
            return;
        }
        Book b = buildBookFromRequest(req);
        b.setBookID(bookID);
        String authors = req.getParameter("authors");
        boolean ok = bookDAO.updateBook(b, authors, b.getGenreIDs(), account.getId());
        if (ok) {
            session.setAttribute("successMessage", "Book updated successfully!");
        } else {
            session.setAttribute("errorMessage", "Update failed. Please try again!");
        }
        resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
>>>>>>> Stashed changes
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
        // TODO: implement
    }
    private void handleRestore(HttpServletRequest req, HttpServletResponse resp, Account account)
        throws IOException {
        // TODO: implement
}


    private String validateStockQuantity(String raw) {
        // TODO: implement
        return null;
    }


    private String validateStatusVsStock(String stockRaw, String statusRaw) {
        // TODO: implement
        return null;
    }

    private Book buildBookFromRequest(HttpServletRequest req) {
<<<<<<< Updated upstream
        // TODO: implement
        return null;
=======
        Book b = new Book();
        b.setTitle(req.getParameter("title"));
        b.setDescription(req.getParameter("description"));


        String thumb = clean(req.getParameter("thumbnail"));
        String img2 = clean(req.getParameter("image2"));
        String img3 = clean(req.getParameter("image3"));
        String img4 = clean(req.getParameter("image4"));
        StringBuilder allImages = new StringBuilder(thumb);
        if (!img2.isEmpty()) {
            allImages.append("|").append(img2);
        }
        if (!img3.isEmpty()) {
            allImages.append("|").append(img3);
        }
        if (!img4.isEmpty()) {
            allImages.append("|").append(img4);
        }
        b.setThumbnail(allImages.toString());

        try {
            b.setPrice(new BigDecimal(req.getParameter("price")));
        } catch (Exception e) {
            b.setPrice(BigDecimal.ZERO);
        }
        try {
            b.setStockQuantity(Integer.parseInt(req.getParameter("stockQuantity")));
        } catch (Exception e) {
            b.setStockQuantity(0);
        }
        try {
            b.setTotalPages(Integer.parseInt(req.getParameter("totalPages")));
        } catch (Exception e) {
            b.setTotalPages(0);
        }
        b.setDimensions(req.getParameter("dimensions"));
        try {
            String w = req.getParameter("weight");
            if (w != null && !w.isEmpty()) {
                b.setWeight(new BigDecimal(w));
            }
        } catch (Exception e) {
        }

        String requestedStatus = req.getParameter("status");
        requestedStatus = requestedStatus != null ? requestedStatus.trim() : "";

        String status;
        if ("discontinued".equals(requestedStatus)) {
            status = "discontinued";
        } else if (b.getStockQuantity() <= 0) {
            status = "out_of_stock";
        } else {
            status = !requestedStatus.isEmpty() ? requestedStatus : "available";
        }
        b.setStatus(status);
        b.setGenreIDs(parsePositiveIntParams(req.getParameterValues("genreID")));
        Integer cid = parseIntParam(req.getParameter("contentID"));
        if (cid != null) {
            b.setContentID(cid);
        }
        Integer sid = parseIntParam(req.getParameter("seriesID"));
        if (sid != null) {
            b.setSeriesID(sid);
        }
        Integer oid = parseIntParam(req.getParameter("originID"));
        if (oid != null) {
            b.setOriginID(oid);
        }
        Integer pid = parseIntParam(req.getParameter("publisherID"));
        if (pid != null) {
            b.setPublisherID(pid);
        }
        return b;
>>>>>>> Stashed changes
    }

    private String clean(String s) {
        // TODO: implement
        return null;
    }


    private Account requireStaff(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        // TODO: implement
        return null;
    }


    private int parsePage(String param) {
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
<<<<<<< Updated upstream
}
=======

    private List<Integer> parsePositiveIntParams(String[] params) {
        List<Integer> values = new java.util.ArrayList<>();
        if (params == null) {
            return values;
        }
        for (String param : params) {
            Integer value = parseIntParam(param);
            if (value != null && !values.contains(value)) {
                values.add(value);
            }
        }
        return values;
    }
}
>>>>>>> Stashed changes

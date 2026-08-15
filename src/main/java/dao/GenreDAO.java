package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Genre;
import utils.DBContext;

public class GenreDAO {

    private final DBContext db = new DBContext();

    public List<Genre> getAllGenres() {
        // TODO: implement
        return new ArrayList<Genre>();
    }

    public List<Genre> searchGenres(String keyword) {
        // TODO: implement
        return new ArrayList<Genre>();
    }

    public Genre getGenreById(int id) {
        // TODO: implement
        return null;
    }

    public boolean isGenreNameExists(String name) {
        // TODO: implement
        return false;
    }

    public boolean isGenreNameExists(String name, int exceptId) {
        // TODO: implement
        return false;
    }

    public boolean insertGenre(String name) {
        // TODO: implement
        return false;
    }

    public boolean updateGenre(int id, String name) {
        // TODO: implement
        return false;
    }

    public boolean deleteGenre(int id) {
        // TODO: implement
        return false;
    }

    public int countBooksByGenre(int id) {
        // TODO: implement
        return 0;
    }
}

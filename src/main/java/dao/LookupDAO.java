package dao;

import utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class LookupDAO {

    public void ensureDefaultLookups() {
<<<<<<< Updated upstream
        // TODO: implement
=======
        seedIfEmpty("Genre", "genre_name",
                new String[]{"Fiction", "Personal Development", "Business", "Children's Books", "Science"});
        seedIfEmpty("Content", "content_name",
                new String[]{"Paperback", "Hardcover", "Glossy Cover", "Audiobook"});
        seedIfEmpty("BookOrigin", "origin_name",
                new String[]{"Vietnam", "United States", "United Kingdom", "Japan", "South Korea", "China", "France"});
        seedIfEmpty("BookSeries", "series_name",
                new String[]{"Harry Potter", "Detective Conan", "Self-Help Books", "Classic Literature"});
>>>>>>> Stashed changes
    }

    public int findExistingId(String type, String name) {
        // TODO: implement
        return 0;
    }

    public int insertLookup(String type, String name) {
        // TODO: implement
        return 0;
    }

    private void seedIfEmpty(String table, String nameColumn, String[] values) {
        // TODO: implement
    }

    private int countRows(String table) {
        // TODO: implement
        return 0;
    }

    private LookupMeta resolveMeta(String type) {
<<<<<<< Updated upstream
        // TODO: implement
=======
        if (type == null) {
            return null;
        }
        String key = type.toLowerCase();
        if ("genre".equals(key)) {
            return new LookupMeta("Genre", "genreID", "genre_name");
        }
        if ("content".equals(key)) {
            return new LookupMeta("Content", "contentID", "content_name");
        }
        if ("origin".equals(key)) {
            return new LookupMeta("BookOrigin", "originID", "origin_name");
        }
        if ("series".equals(key)) {
            return new LookupMeta("BookSeries", "seriesID", "series_name");
        }
        if ("publisher".equals(key)) {
            return new LookupMeta("Publisher", "publisherID", "publisher_name");
        }
>>>>>>> Stashed changes
        return null;
    }

    private static final class LookupMeta {
        private final String table;
        private final String idColumn;
        private final String nameColumn;

        private LookupMeta(String table, String idColumn, String nameColumn) {
            // TODO: implement
            return null;
        }
    }
}

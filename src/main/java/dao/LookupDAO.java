package dao;

import utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class LookupDAO {

    public void ensureDefaultLookups() {
        seedIfEmpty("Genre", "genre_name",
                new String[]{"Fiction", "Personal Development", "Business", "Children's Books", "Science"});
        seedIfEmpty("Content", "content_name",
                new String[]{"Paperback", "Hardcover", "Glossy Cover", "Audiobook"});
        seedIfEmpty("BookOrigin", "origin_name",
                new String[]{"Vietnam", "United States", "United Kingdom", "Japan", "South Korea", "China", "France"});
        seedIfEmpty("BookSeries", "series_name",
                new String[]{"Harry Potter", "Detective Conan", "Self-Help Books", "Classic Literature"});
    }

    public int findExistingId(String type, String name) {
        LookupMeta meta = resolveMeta(type);
        if (meta == null || name == null || name.trim().isEmpty()) {
            return -1;
        }

        String sql = "SELECT " + meta.idColumn + " FROM " + meta.table
                + " WHERE " + meta.nameColumn + " = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int insertLookup(String type, String name) {
        String trimmed = name == null ? "" : name.trim();
        if (trimmed.isEmpty()) {
            return -1;
        }

        int existingId = findExistingId(type, trimmed);
        if (existingId > 0) {
            return existingId;
        }

        LookupMeta meta = resolveMeta(type);
        if (meta == null) {
            return -1;
        }

        String sql = "INSERT INTO " + meta.table + " (" + meta.nameColumn + ") VALUES (?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, trimmed);
            int affected = ps.executeUpdate();
            if (affected <= 0) {
                return -1;
            }
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    private void seedIfEmpty(String table, String nameColumn, String[] values) {
        if (countRows(table) > 0) {
            return;
        }
        String sql = "INSERT INTO " + table + " (" + nameColumn + ") VALUES (?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String value : values) {
                ps.setString(1, value);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private int countRows(String table) {
        String sql = "SELECT COUNT(*) FROM " + table;
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private LookupMeta resolveMeta(String type) {
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
        return null;
    }

    private static final class LookupMeta {
        private final String table;
        private final String idColumn;
        private final String nameColumn;

        private LookupMeta(String table, String idColumn, String nameColumn) {
            this.table = table;
            this.idColumn = idColumn;
            this.nameColumn = nameColumn;
        }
    }
}

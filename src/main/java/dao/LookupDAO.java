package dao;

import utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class LookupDAO {

    public void ensureDefaultLookups() {
        // TODO: implement
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
        // TODO: implement
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

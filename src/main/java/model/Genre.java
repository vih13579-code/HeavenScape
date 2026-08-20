package model;

public class Genre {
    private int genreID;
    private String genreName;
    private int bookCount;

    public Genre() {
    }

    public Genre(int genreID, String genreName) {
        this.genreID = genreID;
        this.genreName = genreName;
    }

    public Genre(int genreID, String genreName, int bookCount) {
        this.genreID = genreID;
        this.genreName = genreName;
        this.bookCount = bookCount;
    }

    public int getGenreID() {
        return genreID;
    }

    public void setGenreID(int genreID) {
        this.genreID = genreID;
    }

    public String getGenreName() {
        return genreName;
    }

    public void setGenreName(String genreName) {
        this.genreName = genreName;
    }

    public int getBookCount() {
        return bookCount;
    }

    public void setBookCount(int bookCount) {
        this.bookCount = bookCount;
    }
}

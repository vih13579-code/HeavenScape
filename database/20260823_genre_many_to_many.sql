USE [HeavenScape_finalDB];
GO

/* Run once after the supplied HeavenScape_finalDB schema. */
IF OBJECT_ID('dbo.Genre', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Genre (
        genreID INT IDENTITY(1,1) PRIMARY KEY,
        genre_name NVARCHAR(100) NOT NULL UNIQUE
    );
END;
GO

IF OBJECT_ID('dbo.BookGenre', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.BookGenre (
        bookID INT NOT NULL,
        genreID INT NOT NULL,
        CONSTRAINT PK_BookGenre PRIMARY KEY (bookID, genreID),
        CONSTRAINT FK_BookGenre_Book FOREIGN KEY (bookID) REFERENCES dbo.Book(bookID) ON DELETE CASCADE,
        CONSTRAINT FK_BookGenre_Genre FOREIGN KEY (genreID) REFERENCES dbo.Genre(genreID) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BookGenre_GenreID' AND object_id = OBJECT_ID('dbo.BookGenre'))
BEGIN
    CREATE INDEX IX_BookGenre_GenreID ON dbo.BookGenre (genreID, bookID);
END;
GO

/* Preserve existing category data when the old tables are present. */
IF OBJECT_ID('dbo.Category', 'U') IS NOT NULL
BEGIN
    INSERT INTO dbo.Genre (genre_name)
    SELECT DISTINCT c.category_name
    FROM dbo.Category c
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.Genre g WHERE LOWER(LTRIM(RTRIM(g.genre_name))) = LOWER(LTRIM(RTRIM(c.category_name)))
    );

    IF COL_LENGTH('dbo.Book', 'categoryID') IS NOT NULL
    BEGIN
        INSERT INTO dbo.BookGenre (bookID, genreID)
        SELECT b.bookID, g.genreID
        FROM dbo.Book b
        JOIN dbo.Category c ON c.categoryID = b.categoryID
        JOIN dbo.Genre g ON LOWER(LTRIM(RTRIM(g.genre_name))) = LOWER(LTRIM(RTRIM(c.category_name)))
        WHERE NOT EXISTS (
            SELECT 1 FROM dbo.BookGenre bg WHERE bg.bookID = b.bookID AND bg.genreID = g.genreID
        );
    END;
END;
GO

/* Also migrate a legacy Book.genreID column if one exists.
   Dynamic SQL is required because SQL Server compiles static column references
   before evaluating the COL_LENGTH condition. */
IF COL_LENGTH('dbo.Book', 'genreID') IS NOT NULL
BEGIN
    EXEC sys.sp_executesql N'
        INSERT INTO dbo.BookGenre (bookID, genreID)
        SELECT b.bookID, b.genreID
        FROM dbo.Book b
        WHERE b.genreID IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM dbo.BookGenre bg
              WHERE bg.bookID = b.bookID AND bg.genreID = b.genreID
          );';
END;
GO

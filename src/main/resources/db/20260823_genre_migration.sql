USE [HeavenScape_finalDB]
GO

/* Run after backing up HeavenScape_finalDB. */
IF OBJECT_ID(N'dbo.Genre', N'U') IS NULL
    AND OBJECT_ID(N'dbo.Category', N'U') IS NOT NULL
BEGIN
    EXEC sp_rename N'dbo.Category', N'Genre';
    EXEC sp_rename N'dbo.Genre.categoryID', N'genreID', N'COLUMN';
    EXEC sp_rename N'dbo.Genre.category_name', N'genre_name', N'COLUMN';
END;

IF OBJECT_ID(N'dbo.Genre', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Genre (
        genreID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Genre PRIMARY KEY,
        genre_name NVARCHAR(150) NOT NULL
    );
END;

IF OBJECT_ID(N'dbo.Category', N'U') IS NOT NULL
BEGIN
    INSERT INTO dbo.Genre (genre_name)
    SELECT c.category_name
    FROM dbo.Category c
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.Genre g
        WHERE LOWER(LTRIM(RTRIM(g.genre_name))) = LOWER(LTRIM(RTRIM(c.category_name)))
    );
END;

IF OBJECT_ID(N'dbo.BookGenre', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.BookGenre (
        bookID INT NOT NULL,
        genreID INT NOT NULL,
        CONSTRAINT PK_BookGenre PRIMARY KEY (bookID, genreID),
        CONSTRAINT FK_BookGenre_Book FOREIGN KEY (bookID) REFERENCES dbo.Book(bookID),
        CONSTRAINT FK_BookGenre_Genre FOREIGN KEY (genreID) REFERENCES dbo.Genre(genreID)
    );
END;

IF COL_LENGTH(N'dbo.Book', N'categoryID') IS NOT NULL
BEGIN
    IF OBJECT_ID(N'dbo.Category', N'U') IS NOT NULL
    BEGIN
        INSERT INTO dbo.BookGenre (bookID, genreID)
        SELECT b.bookID, g.genreID
        FROM dbo.Book b
        JOIN dbo.Category c ON c.categoryID = b.categoryID
        JOIN dbo.Genre g ON LOWER(LTRIM(RTRIM(g.genre_name))) = LOWER(LTRIM(RTRIM(c.category_name)))
        WHERE NOT EXISTS (
            SELECT 1 FROM dbo.BookGenre bg
            WHERE bg.bookID = b.bookID AND bg.genreID = g.genreID
        );
    END;

    IF OBJECT_ID(N'dbo.Category', N'U') IS NULL
    BEGIN
        INSERT INTO dbo.BookGenre (bookID, genreID)
        SELECT b.bookID, b.categoryID
        FROM dbo.Book b
        WHERE b.categoryID IS NOT NULL
          AND EXISTS (SELECT 1 FROM dbo.Genre g WHERE g.genreID = b.categoryID)
          AND NOT EXISTS (
              SELECT 1 FROM dbo.BookGenre bg
              WHERE bg.bookID = b.bookID AND bg.genreID = b.categoryID
          );
    END;

    IF EXISTS (
        SELECT 1 FROM sys.foreign_keys
        WHERE name = N'FK_Book_Category'
          AND parent_object_id = OBJECT_ID(N'dbo.Book')
    )
        ALTER TABLE dbo.Book DROP CONSTRAINT FK_Book_Category;

    ALTER TABLE dbo.Book DROP COLUMN categoryID;
END;

IF OBJECT_ID(N'dbo.Category', N'U') IS NOT NULL
    DROP TABLE dbo.Category;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'UX_Genre_Name'
      AND object_id = OBJECT_ID(N'dbo.Genre')
)
BEGIN
    CREATE UNIQUE INDEX UX_Genre_Name ON dbo.Genre(genre_name)
    WHERE genre_name IS NOT NULL;
END;
GO

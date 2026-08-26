USE [master]
GO
/****** Object:  Database [HeavenScape_finalDB]    Script Date: 8/23/2026 11:26:14 PM ******/
CREATE DATABASE [HeavenScape_finalDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HeavenScape_finalDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\HeavenScape_finalDB.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'HeavenScape_finalDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\HeavenScape_finalDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [HeavenScape_finalDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HeavenScape_finalDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HeavenScape_finalDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HeavenScape_finalDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HeavenScape_finalDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [HeavenScape_finalDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HeavenScape_finalDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET RECOVERY FULL 
GO
ALTER DATABASE [HeavenScape_finalDB] SET  MULTI_USER 
GO
ALTER DATABASE [HeavenScape_finalDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HeavenScape_finalDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HeavenScape_finalDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HeavenScape_finalDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [HeavenScape_finalDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [HeavenScape_finalDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'HeavenScape_finalDB', N'ON'
GO
ALTER DATABASE [HeavenScape_finalDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [HeavenScape_finalDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [HeavenScape_finalDB]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[accountID] [int] IDENTITY(1,1) NOT NULL,
	[fullname] [nvarchar](150) NOT NULL,
	[email] [nvarchar](150) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[phone] [nvarchar](20) NULL,
	[role] [nvarchar](20) NOT NULL,
	[status] [nvarchar](20) NOT NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[updated_by] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[accountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Address]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[addressID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[street] [nvarchar](255) NULL,
	[district] [nvarchar](100) NULL,
	[city] [nvarchar](100) NULL,
	[country] [nvarchar](100) NULL,
	[is_default] [bit] NULL,
	[recipient_name] [nvarchar](100) NULL,
	[recipient_phone] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[addressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Author]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Author](
	[authorID] [int] IDENTITY(1,1) NOT NULL,
	[fullname] [nvarchar](150) NOT NULL,
	[biography] [nvarchar](max) NULL,
	[nationality] [nvarchar](100) NULL,
	[birthdate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[authorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Book]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[bookID] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NULL,
	[price] [decimal](18, 2) NOT NULL,
	[stock_quantity] [int] NULL,
	[thumbnail] [nvarchar](500) NULL,
	[total_pages] [int] NULL,
	[dimensions] [nvarchar](100) NULL,
	[weight] [decimal](10, 2) NULL,
	[status] [nvarchar](50) NULL,
	[seriesID] [int] NULL,
	[originID] [int] NULL,
	[contentID] [int] NULL,
	[languageID] [int] NULL,
	[audienceID] [int] NULL,
	[purposeID] [int] NULL,
	[created_by] [int] NULL,
	[updated_by] [int] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[publisherID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[bookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookAuthor]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookAuthor](
	[bookAuthorID] [int] IDENTITY(1,1) NOT NULL,
	[bookID] [int] NOT NULL,
	[authorID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[bookAuthorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookGenre]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookGenre](
	[bookID] [int] NOT NULL,
	[genreID] [int] NOT NULL,
 CONSTRAINT [PK_BookGenre] PRIMARY KEY CLUSTERED 
(
	[bookID] ASC,
	[genreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookOrigin]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookOrigin](
	[originID] [int] IDENTITY(1,1) NOT NULL,
	[origin_name] [nvarchar](150) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[originID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookSeries]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookSeries](
	[seriesID] [int] IDENTITY(1,1) NOT NULL,
	[series_name] [nvarchar](150) NOT NULL,
	[description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[seriesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[cartID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[status] [nvarchar](20) NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[cartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CartItem]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CartItem](
	[cartItemID] [int] IDENTITY(1,1) NOT NULL,
	[cartID] [int] NOT NULL,
	[bookID] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[added_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[cartItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Content]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Content](
	[contentID] [int] IDENTITY(1,1) NOT NULL,
	[content_name] [nvarchar](150) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[contentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[customerID] [int] IDENTITY(1,1) NOT NULL,
	[fullname] [nvarchar](150) NOT NULL,
	[email] [nvarchar](150) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[phone] [nvarchar](20) NULL,
	[role] [nvarchar](20) NULL,
	[status] [nvarchar](20) NULL,
	[created_at] [datetime] NULL,
	[gender] [varchar](10) NULL,
	[dob] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerVoucher]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerVoucher](
	[customerVoucherID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[voucherID] [int] NOT NULL,
	[is_used] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[customerVoucherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Genre]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genre](
	[genreID] [int] IDENTITY(1,1) NOT NULL,
	[genre_name] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED 
(
	[genreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Intended_Audience]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Intended_Audience](
	[audienceID] [int] IDENTITY(1,1) NOT NULL,
	[audience_name] [nvarchar](150) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[audienceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Language]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Language](
	[languageID] [int] IDENTITY(1,1) NOT NULL,
	[language_name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[languageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[orderID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[addressID] [int] NOT NULL,
	[processed_by] [int] NULL,
	[status] [nvarchar](50) NULL,
	[payment_method] [nvarchar](50) NULL,
	[payment_status] [nvarchar](50) NULL,
	[refund_bank_name] [nvarchar](100) NULL,
	[refund_account_number] [varchar](20) NULL,
	[refund_account_holder] [nvarchar](100) NULL,
	[total_price] [decimal](18, 2) NULL,
	[created_at] [datetime] NULL,
	[cancel_reason] [nvarchar](500) NULL,
	[cancelled_by] [nvarchar](20) NULL,
	[voucherID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[orderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[orderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[orderID] [int] NOT NULL,
	[bookID] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[unit_price] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[orderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Publisher]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Publisher](
	[publisherID] [int] IDENTITY(1,1) NOT NULL,
	[publisher_name] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Publisher] PRIMARY KEY CLUSTERED 
(
	[publisherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Purpose]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Purpose](
	[purposeID] [int] IDENTITY(1,1) NOT NULL,
	[purpose_name] [nvarchar](150) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[purposeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Review]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Review](
	[reviewID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[bookID] [int] NOT NULL,
	[orderDetailID] [int] NOT NULL,
	[rating] [int] NULL,
	[comment] [nvarchar](max) NULL,
	[created_at] [datetime] NULL,
	[adminReply] [nvarchar](1000) NULL,
	[adminReplyDate] [datetime] NULL,
	[adminID] [int] NULL,
	[isHidden] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[reviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Voucher]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Voucher](
	[voucherID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](50) NOT NULL,
	[discount_percent] [decimal](5, 2) NULL,
	[quantity] [int] NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[status] [nvarchar](20) NULL,
	[is_deleted] [bit] NOT NULL,
	[min_order_value] [decimal](18, 2) NULL,
	[max_discount_value] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[voucherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WishList]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WishList](
	[wishlistID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[wishlistID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WishList_Item]    Script Date: 8/23/2026 11:26:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WishList_Item](
	[wishlistItemID] [int] IDENTITY(1,1) NOT NULL,
	[wishlistID] [int] NOT NULL,
	[bookID] [int] NOT NULL,
	[added_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[wishlistItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Account] ON 

INSERT [dbo].[Account] ([accountID], [fullname], [email], [password], [phone], [role], [status], [created_at], [updated_at], [updated_by]) VALUES (1, N'Admin', N'admin@heavenscape.com', N'e10adc3949ba59abbe56e057f20f883e', N'0849324423', N'admin', N'active', CAST(N'2026-06-04T12:07:24.427' AS DateTime), NULL, NULL)
INSERT [dbo].[Account] ([accountID], [fullname], [email], [password], [phone], [role], [status], [created_at], [updated_at], [updated_by]) VALUES (2, N'Staff', N'staff@heavenscape.com', N'e10adc3949ba59abbe56e057f20f883e', N'0987654321', N'staff', N'active', CAST(N'2026-06-04T12:07:24.430' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Account] OFF
GO
SET IDENTITY_INSERT [dbo].[Address] ON 

INSERT [dbo].[Address] ([addressID], [customerID], [street], [district], [city], [country], [is_default], [recipient_name], [recipient_phone]) VALUES (1, 11, N'600 CMT8', N'Phường Cái Khế', N'Thành phố Cần Thơ', N'__DELETED__', 0, N'Minh Duy', N'0915783916')
INSERT [dbo].[Address] ([addressID], [customerID], [street], [district], [city], [country], [is_default], [recipient_name], [recipient_phone]) VALUES (2, 11, N'123 cmt8', N'Phường Bình Dương', N'Thành phố Hồ Chí Minh', N'Vietnam', 1, N'Nguyễn Lê Duy Minh', N'0915783916')
INSERT [dbo].[Address] ([addressID], [customerID], [street], [district], [city], [country], [is_default], [recipient_name], [recipient_phone]) VALUES (4, 11, N'ádas1231', N'Phường Mường Lay', N'Tỉnh Điện Biên', N'Vietnam', 0, N'Nguyễn Lê Duy Minh', N'0915783916')
INSERT [dbo].[Address] ([addressID], [customerID], [street], [district], [city], [country], [is_default], [recipient_name], [recipient_phone]) VALUES (5, 13, N'123 MCK', N'Phường Ba Đình', N'Thành phố Hà Nội', N'Vietnam', 1, N'Nguyen Bao Duy', N'0908123456')
SET IDENTITY_INSERT [dbo].[Address] OFF
GO
SET IDENTITY_INSERT [dbo].[Author] ON 

INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (1, N'Dale Carnegie', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (2, N'Paulo Coelho', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (3, N'Rosie Nguyen', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (4, N'Ministry of Education and Training', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (5, N'Vladimir Nabokov', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (6, N'Tatsuki Fujimoto', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (7, N'Tatsuki Fujimoto', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (8, N'Gege Akutami', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (9, N'Minna no Nihongo', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (10, N'Gao Ming', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (11, N'Malcolm Mann', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (12, N'Steve Taylore-Knowles', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (13, N'Malcolm Mann', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (14, N'Nguyen Nhat Anh', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (15, N'Andy Weir', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (16, N'Rasmus Hoai Nam', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (17, N'Megan Stine', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (18, N'Who HQ', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (19, N'John O''Brien', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (20, N'Multiple Authors', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (21, N'Ayu Kuwagaki', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (22, N'Joseph Murphy', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (23, N'Yukinobu Tatsu', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (24, N'Claire Belton', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (25, N'Federico Mariani', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (26, N'Nguyen Thi Binh', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (27, N'Chase Hill', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (28, N'Jonah Berger', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (29, N'Rolf Dobelli', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (30, N'DK', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (31, N'Mark Wolynn', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (32, N'Gosho Aoyama', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (33, N'とよたろう', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (34, N'鳥山明', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (35, N'Yoshito Usui', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (36, N'Takata Mirei', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (37, N'Masashi Kishimoto', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (38, N'Tue Kien', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (39, N'Walter Isaacson', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (40, N'Nguyen Ngoc Ky', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (41, N'Thinknetic', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (42, N'Cambridge', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (43, N'Trác Nhã', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (44, N'ádasd', NULL, NULL, NULL)
INSERT [dbo].[Author] ([authorID], [fullname], [biography], [nationality], [birthdate]) VALUES (45, N'Joan Laporta', NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Author] OFF
GO
SET IDENTITY_INSERT [dbo].[Book] ON 

INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (1, N'Detective Conan - Novel - The Fallen Angel on the Highway', N'While on his way to Yokohama for a motorcycle festival, Conan unexpectedly finds himself caught up in an accident caused by a mysterious black motorcycle recklessly speeding down the highway. Captain Hagiwara Chihaya of the Kanagawa Prefectural Police''s 3rd Motor Traffic Squad pursues the suspect on her police motorcycle, and with her skillful driving and excellent situational awareness, she corners the criminal. Unfortunately, at the crucial moment, he manages to escape.
Following that incident, at the motorcycle festival, a new police motorcycle model called Angel was unveiled, attracting public attention. However, the story didn''t end there; the mysterious black motorcycle brazenly reappeared in the city center, spectacularly shaking off the police. Ultimately, what was the driver of this motorcycle, nicknamed Lucifer, plotting?', CAST(49500.00 AS Decimal(18, 2)), 45, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786776509/heavenscape/products/tieu-thuyet-tham-tu-lung-danh-conan_thien-than-sa-nga-tren-xa-lo_bia.webp.webp', 180, N'19 x 13', CAST(180.00 AS Decimal(10, 2)), N'available', 2, 4, 1, NULL, NULL, NULL, NULL, 2, CAST(N'2026-06-01T10:03:49.333' AS DateTime), CAST(N'2026-08-15T13:51:18.270' AS DateTime), 1)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (2, N'The Alchemist', N'Paulo Coelho follows Santiago, a young shepherd who travels in search of treasure and discovers the importance of pursuing his dreams and listening to his heart.', CAST(95000.00 AS Decimal(18, 2)), 36, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-02-20260811.jpg', 208, N'', NULL, N'available', 17, 9, 1, NULL, NULL, NULL, NULL, 2, CAST(N'2026-06-01T10:03:49.333' AS DateTime), CAST(N'2026-07-22T20:24:25.860' AS DateTime), 2)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (3, N'The Socratic Method of Questioning - Unlocking Critical Thinking and Deep Understanding', N'Have you ever wondered why simple questions can change the way we see the world? The Socratic Questioning Method is the key to unlocking the hidden power of questioning, an indispensable tool in critical thinking and problem-solving.

In the light of Socrates, you will learn how to transform questions not just into answers, but into profound insights and groundbreaking solutions to life''s challenges. This book is not only for those who love philosophy but also for anyone who wants to improve their problem-solving skills, decision-making abilities, and develop creative thinking.', CAST(105000.00 AS Decimal(18, 2)), 0, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786777459/heavenscape/products/8936225390492.jpg.jpg', 285, N'20.5 x 13 x 1.1', CAST(250.00 AS Decimal(10, 2)), N'out_of_stock', 17, 2, 1, NULL, NULL, NULL, NULL, 2, CAST(N'2026-06-01T10:03:49.333' AS DateTime), CAST(N'2026-08-15T14:05:03.430' AS DateTime), 3)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (4, N'Physics 10 (Connecting Knowledge) (Standard)', N'Physics 10 (Connecting Knowledge) (2023)', CAST(17000.00 AS Decimal(18, 2)), 15, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786777616/heavenscape/products/9786040310927_1.webp.webp', 139, N'', CAST(251.00 AS Decimal(10, 2)), N'available', 15, 1, 1, NULL, NULL, NULL, 1, 2, CAST(N'2026-06-25T19:12:49.327' AS DateTime), CAST(N'2026-08-15T14:07:54.743' AS DateTime), 4)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (5, N'Butterflies and Whales', N'Butterflies and Whales is a modern romance by Tue Kien about Ho Diep, a young woman facing a serious illness, and Kinh Du, a swimmer whose encounter with her develops into a story of love, healing, dreams, and the value of brief but meaningful moments in life.', CAST(111600.00 AS Decimal(18, 2)), 20, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786776730/heavenscape/products/bia-2d_ho-diep-va-kinh-ngu_17307.webp.webp', 272, N'15 x 24', NULL, N'available', 17, 6, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T06:57:52.487' AS DateTime), CAST(N'2026-08-15T13:52:54.320' AS DateTime), 5)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (6, N'Naruto Illustration Collection Uzumaki Naruto', N'Publisher''s Content Information The ultimate illustration collection!! The vividly colored ninja way of Naruto!! A wealth of content swirling with masterpieces!! ● Over 70 masterpieces carefully selected from illustrations published since 2009! ● Masashi Kishimoto''s top 10 favorite illustrations revealed with valuable comments! ● The complete version of the interview with Avi Arad, producer of "The Amazing Spider-Man 2"!! ● Bring powerful illustrations into your room! Special bonus large poster that can be hung on the wall!!', CAST(378000.00 AS Decimal(18, 2)), 4, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786776267/heavenscape/products/image_113093.webp.webp', 208, N'17.6 x 11.2 x 1.4', CAST(200.00 AS Decimal(10, 2)), N'available', 7, 4, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T07:01:47.220' AS DateTime), CAST(N'2026-08-15T13:45:10.350' AS DateTime), 6)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (7, N'Naruto - Volume 1 - Uzumaki Naruto (2025 Reprint)', N'The story takes place in the Hidden Leaf Village, with the main character being Naruto, a student at the Ninja training school who constantly causes trouble throughout the village!
Naruto has a grand dream: to achieve the title of Hokage—a position reserved for the most elite ninja—and surpass his predecessors.
However, the secret about Naruto''s true identity is…!?', CAST(30000.00 AS Decimal(18, 2)), 1, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786776197/heavenscape/products/naruto---tap-1---tb-2022_1.webp.webp', 192, N'17.6 x 11.3 x 0.9', CAST(160.00 AS Decimal(10, 2)), N'available', 7, 4, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T07:05:45.450' AS DateTime), CAST(N'2026-08-15T13:43:45.083' AS DateTime), 1)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (8, N'Visual Korean Vietnamese English Trilingual Dictionary', N'Visual Korean Vietnamese English Trilingual Dictionary

This pocket dictionary from Korean to Vietnamese to English helps you quickly learn over 6,000 Korean and English words and phrases.

 Everyday objects and scenes are vividly presented through numerous beautiful color photographs.

This document can be used effectively in any situation – at home, in the office, when eating out…

Easy to learn thanks to detailed references and indexes.', CAST(256000.00 AS Decimal(18, 2)), 50, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786777108/heavenscape/products/image_195509_1_44035.webp.webp', 324, N'26 x 19 x 1.6 cm', CAST(340.00 AS Decimal(10, 2)), N'available', 17, 1, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T07:16:22.183' AS DateTime), CAST(N'2026-08-15T13:59:17.857' AS DateTime), 7)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (9, N'The Art of Eloquence: How to Win the World - Hardcover (Reprint 2026)', N'Trac Nha presents practical methods for improving communication, speaking with tact, adapting to different people and situations, and using conversation skills to build relationships and create opportunities in work and everyday life.', CAST(150000.00 AS Decimal(18, 2)), 30, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786786075/heavenscape/products/8936238102334.jpg.jpg', 404, N'14.5 x 20.5 cm', CAST(600.00 AS Decimal(10, 2)), N'available', 17, 6, 2, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T08:15:20.010' AS DateTime), CAST(N'2026-08-15T16:28:43.710' AS DateTime), 5)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (10, N'IELTS Writing - Write a High-Quality Essay', N'IELTS Writing - Write a High-Quality Essay

In the context of English becoming the "global language" and AI changing the way we learn, the book IELTS Writing - Writing "Top-notch" essays encourages learners to cultivate critical thinking and the ability to develop coherent and persuasive ideas – skills that are increasingly important in a world where AI can write for humans.

Nguyen Hoang Huy (editor-in-chief) started with an IELTS Writing score of 6.5 and persevered to achieve a perfect 9.0. Throughout this journey, he honed his language skills, refined his thinking, learned how to analyze argumentative structures, and experimented with various methods. From this, Huy and his team have distilled and presented to readers three "exclusive" writing techniques:

- Temporal Contrast Analysis (TCA): a technique that helps you place an issue within a past-present context to build a profound argument.

- Character-Trait Linking (CTA): a technique that helps you explain behavior by combining individual characteristics and social factors.

- Context-Based Argumentation (CBA): a technique that helps you explore the multifaceted nature of a phenomenon or object.

These three techniques are specifically designed for IELTS Writing Task 2, but are also beneficial for writing essays at the university level, in research, or in professional settings.

In addition to the three techniques mentioned above, the book provides 15 selected sample essays, along with a vocabulary list organized by topic. Each essay is analyzed in detail, from the introduction and body to the conclusion. This is not only a study material for exams, but also a "thinking tool" to help learners master the art of essay writing in any field.', CAST(170820.00 AS Decimal(18, 2)), 20, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786785355/heavenscape/products/9786326100969.webp.webp', 240, N'24 x 16 x 1.2', CAST(400.00 AS Decimal(10, 2)), N'available', 17, 1, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T08:18:42.160' AS DateTime), CAST(N'2026-08-15T16:17:37.593' AS DateTime), 8)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (11, N'Cambridge IELTS 20 - Academic - With Audio + Answers (Savina)', N'Cambridge IELTS 20 - Academic

Prepare for IELTS with practice tests from Cambridge

Inside you''ll find four authentic test papers from Cambridge University Press & Assessment. They are the perfect way to practise - EXACTLY like the real test.

Why are they unique?

All our authentic practice tests go through the same design process as the IELTS test. We check every single part of our practice tests with real students under exam conditions, to make sure we give you the most authentic experience possible.

Be confident on test day

- Get to know the test format

- Understand the scoring system

- Train in examination techniques

Resource Bank includes

- Example Speaking test videos

- Audio for the Listening tests

- Answer keys with extra explanations

- Additional sample Writing answers', CAST(250000.00 AS Decimal(18, 2)), 10, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786785218/heavenscape/products/bia-1-ielts-20-aca.webp.webp', 144, N'24.5 x 19', CAST(220.00 AS Decimal(10, 2)), N'available', 17, 3, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T08:20:06.873' AS DateTime), CAST(N'2026-08-15T16:14:38.453' AS DateTime), 9)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (12, N'Give Me a Ticket to Childhood - Special Edition', N'Nguyen Nhat Anh revisits childhood through warm, humorous memories, contrasting the imagination of children with the routines and expectations of adult life.', CAST(377000.00 AS Decimal(18, 2)), 15, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786776844/heavenscape/products/nxbtre_full_22142021_051437.webp.webp', 208, N'20 x 13 x 1', CAST(220.00 AS Decimal(10, 2)), N'available', 17, 1, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T08:23:47.790' AS DateTime), CAST(N'2026-08-15T13:54:17.247' AS DateTime), 10)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (13, N'Project Hail Mary', N'Andy Weir follows Ryland Grace, a lone astronaut who awakens without his memories and must solve an interstellar scientific mystery to save humanity.', CAST(140000.00 AS Decimal(18, 2)), 30, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-13-20260811.jpg', 496, N'26 x 19 x 1.6 cm', CAST(750.00 AS Decimal(10, 2)), N'available', 17, 2, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T08:27:42.493' AS DateTime), CAST(N'2026-07-21T08:27:52.823' AS DateTime), 11)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (14, N'I Studied at University - Nguyen Ngoc Ky (Reprint)', N'AUTOBIOGRAPHY OF OUTSTANDING WRITER AND TEACHER NGUYEN NGOC KY I studied at university “There are people like seeds within us…”

Mr. Nguyen Ngoc Ky was born on June 28, 1947, in Hai Thanh, Hai Hau, Nam Dinh. He became paralyzed in both arms at the age of 4; he started school at 7 and used his feet to write. He was twice awarded a medal by President Ho Chi Minh for his outstanding academic achievements despite difficult circumstances. In 1970, Nguyen Ngoc Ky graduated from Hanoi University, Faculty of Literature, then became a teacher and was awarded the title of Distinguished Teacher in 1992, becoming the first Vietnamese writer to write with his feet.

Teacher Nguyen Ngoc Ky has been known to young people nationwide for the past 50 years and is considered a shining example through his stories in textbooks such as "Em Ky Goes to School" (Reading textbook for 3rd grade, 1964-1983), "Anh Ky Goes to School" (Storytelling textbook for 4th grade, 1983-2000), and "The Miraculous Feet" (Vietnamese language textbook for 4th grade, 2000 to present). If the book "I Go to School" introduced readers to Nguyen Ngoc Ky''s 12 years of schooling, then his second autobiography, "I Go to University," will further enhance readers'' understanding and admiration for the years Nguyen Ngoc Ky had to leave his hometown, relying on his feet for everything, especially in the extremely difficult circumstances when all schools had to relocate from the city to mountainous provinces, yet he still excelled academically.

My university studies were nurtured and formed during those years. This book was written by the author over 43 years, and completed during a time when his health was poor, requiring dialysis three times a week. Despite this, with extraordinary willpower and effort, he completed the book. Alongside this, he continued to work tirelessly, interacting with students at various schools, providing psychological and educational counseling via the 1088 hotline, and writing in Ho Chi Minh City. Recently, he and translator Bich Lan had a deeply moving exchange with over 300 cultural and library officials from 64 provinces and cities, organized by the Ministry of Culture, Sports and Tourism and First News in Da Nang. The exchange with translator Bich Lan brought many in the audience to tears.

The first book that Mr. Nguyen Ngoc Ky signed with his foot was given to the Deputy Minister of Culture, Sports and Tourism, Huynh Vinh Ai. His works are always imbued with profound humanistic and educational ideas. Yet, his expression is simple, innocent, witty, subtle, rich in imagery, rhythm, and emotion. "I Go to University" is one such work. If your soul has ever been moved and opened up to horizons of dreams about a bright path ahead with the heartfelt and meaningful pages of "I Go to School" by Mr. Nguyen Ngoc Ky...

This work will be published in a new edition by First News – Tri Viet in January 2014. Today, you will continue your journey back to the past, 45 years ago, almost half a century ago, as Mr. Ky recounts his story. "My University Life" is a story that will leave you speechless, making you suddenly realize that all the difficulties and challenges you faced seem incredibly small. Mr. Nguyen Ngoc Ky is currently writing his third book: "The Flame That Never Dies," a work that promises many very special, profound, and moving stories, much like Nick Vujicic''s "Life Without Limits."

The book "I Studied at University" by Professor Nguyen Ngoc Ky is published by First News and distributed at Tri Viet Bookstore, 11H Nguyen Thi Minh Khai Street, District 1, Ho Chi Minh City, and other bookstores nationwide.

My impressions of "I Studied at University": Reading "I Studied at University" by the esteemed poet and educator Nguyen Ngoc Ky felt like sitting right in front of him. His writing is full of emotion, as if he were confiding in me. The events unfold so realistically and tenderly. I was moved to tears by the genuine and everyday acts of kindness from Nhu, Hang, Hoa, Trang, Ms. Van, Mr. Diep Tu, Mr. Bui Ngoc Trac, Professor Hoang Nhu Mai, Hoang Xuan Nhi… so simple yet profoundly significant and meaningful. And so, Nguyen Ngoc Ky grew up with a compassion and humanity that is not easily found. Now, he has achieved success, serving as an example of overcoming hardship for the less fortunate and for young people to follow. "I Studied at University" is a very sincere and heartfelt expression of gratitude to people and to life. Yet it reflects the lingering feeling of gratitude that can never be fully repaid… Poet To Hoai: Every time I visited his house, Nguyen Ngoc Ky always gave me the pleasure of reading the freshly written manuscripts of his autobiography, "I Studied at University." Each story is a beautiful memory about the land and its people; each valuable lesson about morality, human nature, and the will to overcome adversity. The writing style is gentle, evocative, not pretentious or preachy. The more I read, the more truly captivated I become. I eagerly await the book''s release so I can buy it for my wife, children, and grandchildren to read. Afterwards, I will respectfully place it on the bookshelf next to "How Steel Was Tempered," "Life Without Limits," and "Never Give Up." To me, all four authors are idols. - Educator Tran Cang

Reading the autobiography "I Studied at University" by Professor [Name], I encountered stories about teachers – great personalities. These stories contributed significantly, providing me with valuable lessons in my career of "nurturing people." Through gentle, subtle, and profound narratives, "I Studied at University" is not just a personal account but has transformed into a story of LIFE on every page. And through these pages of LIFE, the sacred, profound, and deeply humanistic teacher-student relationship is present, along with all the pride in a unique period in the history of higher education in our country. A period long gone, but its mark is deeply etched in history because, amidst the countless hardships and shortages of war, both teachers and students persevered and strived to "teach well, learn well." The images of teachers like Professor Diep Tu, Professor Bui Ngoc Trac, and Professor [Name]... Nguy Nhu Kon Tum, Hoang Nhu Mai, Hoang Xuan Nhi… so simple yet profoundly significant and meaningful, these are valuable lessons for today''s teachers to follow…_Meritorious Teacher, Major General, Associate Professor, Doctor Do Ngoc Can. Each page is a memorable and impressive chapter in the author''s life.

Reading this book evokes feelings of compassion, respect, admiration, and a strange fascination. Thank you, Nguyen Ngoc Ky, for making us remember and cherish even more the arduous years that shaped our lives, our affections, and our poetry in the lecture halls of a bygone era. It''s even more meaningful that the more I read, the more the book instills in me a profound joy and deep faith in the invaluable traditional values ​​of our people and our country—values ​​that are not far away but are present all around us every day. _ Journalist Bich Van

Having studied together for four years during the vibrant and arduous university years at the Faculty of Literature, Hanoi University, during the resistance war against the US for national liberation, I recognized in Nguyen Ngoc Ky the extraordinary character of a disabled friend with a strong will and determination. And today, having read his writings, filled with memories, deep affection, and rich emotions—"I Studied at University"—my understanding of his extraordinary qualities has multiplied many times over, not only in his willpower and determination, but also in the richness of his soul, the subtlety in his behavior, and his intense desire to reach the pinnacle of success. - Poet Le Quang Trang

In recent years, the appearance of a series of diaries about the resistance war against the US, especially "Dang Thuy Tram''s Diary," has awakened the conscience of readers both domestically and internationally. Now, the distinguished teacher Nguyen Ngoc Ky has released his autobiography, "I Studied at University," which partly reflects the lives of those on the home front during those heroic years of the nation. Reading these pure and passionate pages, each of us cherishes a beloved time gone by. As one of his first students, today I understand even more the hardships and difficulties, yet the immense beauty, that he and his colleagues endured during the days of evacuation, and I am steadfast in continuing on the path I have chosen. - Poet Pham Quang Tien

He was an intelligent and determined young man who overcame all the difficulties of life, constantly striving towards the intellectual heights he aspired to. I once wrote an article titled "The Legend of Nguyen Ngoc Ky," sincerely expressing my admiration for his extraordinary abilities. But after reading his work, "I Studied at University," I was even more moved and utterly surprised by this legendary figure. It turns out that what I knew about Nguyen Ngoc Ky was far too little. He always possessed a sensitive, mysterious, and sincere heart that resonated with life; a rich and boundless soul with an extraordinary will and determination. With "I Studied at University," writer Nguyen Ngoc Ky also brings us a message of faith: the deep and boundless love between people never diminishes, no matter the circumstances. How much I admire writer and educator Nguyen Ngoc Ky! Nguyen Ngoc Ky gave his all and shone brightly in life. The flame of perseverance that you, as a university student, have truly become a lesson for many, will spread warmth and strength to every heart, especially those that are lonely, unfortunate, and hesitant in their first steps in life. Wishing you happiness and continued success in your noble career! _Journalist and poet Bui Thi Xuan Mai

Nguyen Ngoc Ky''s miraculous feet performed all the tasks required of his disabled hands. This was a physical effort. More importantly, Nguyen Ngoc Ky possessed a kind heart, a passionate love, a pure soul... A will to rise above adversity, without resentment, always optimistic, overcoming circumstances and destiny. A sharp intellect that allowed him to think and act for the benefit of humanity. Ngoc Ky demonstrated this sharpness in his autobiography "I Studied at University," told in a sincere and simple style. I can consider myself a fellow countryman and contemporary figure of Ngoc Ky. Reading Ky''s autobiography and recalling what I''ve heard and known about my fellow writer from my hometown, I am deeply moved. This collection of autobiographies is a tribute to life. Ky loved people – and people loved Ky. Literature reflects people. _Tran Dac Hien Khanh', CAST(70000.00 AS Decimal(18, 2)), 22, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786777347/heavenscape/products/image_244718_1_3286.webp.webp', 304, N'20.5 x 14.5', CAST(300.00 AS Decimal(10, 2)), N'available', 17, 1, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T08:30:19.983' AS DateTime), CAST(N'2026-08-15T14:03:15.090' AS DateTime), 7)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (15, N'Elon Musk''s Biography - Hardcover', N'Elon Musk''s biography is an exploration of the life and work of a modern-day icon, offering profound insights into the mind of a visionary driven by an unceasing pursuit of innovation and progress. It''s a fascinating book for anyone interested in the intersection of technology, entrepreneurship, and human psychology.

Walter Isaacson''s biography of Elon Musk delves into the life and personality of one of the most fascinating and controversial innovators of our time, Elon Musk. The biography takes the reader on an intimate journey through Musk''s tumultuous life, exploring his childhood experiences in South Africa, his complex relationship with his father, and his development into a visionary entrepreneur known for leading groundbreaking projects in electric vehicles, space exploration, and artificial intelligence, as well as his ambitious goals for humanity.

Isaacson painted a vivid picture of Musk as a "child" shaped by both physical and emotional scars from the past, including childhood bullying. Musk''s personality is characterized by his volatile temperament, high risk-taking capacity, and unwavering determination to pursue ambitious missions.

This biography provides a behind-the-scenes look at Musk''s business ventures, including SpaceX, Tesla, and his takeover of Twitter, shedding light on his leadership style, his obsession with detail, and his relentless pursuit of goals.

Isaacson also delves into Musk''s personal life, including his relationships and fatherhood, revealing fascinating details about his unique family dynamics and his desire to raise intelligent children.

Throughout the book, Isaacson offers a balanced perspective on Musk''s strengths and weaknesses, highlighting his exceptional ability to drive change and innovation while acknowledging his lack of empathy and the challenges he faces in social interactions.

While the biography offers a comprehensive and detailed look at Musk''s life and career, it also leaves room for readers to ponder the enigmatic aspects of his personality and the complexity of his ambitions. Isaacson''s meticulous research and access to Musk''s inner circle make it a valuable resource for anyone seeking to understand the man behind the transformative technologies of our time.', CAST(432000.00 AS Decimal(18, 2)), 36, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786777258/heavenscape/products/elonmusk_1.webp.webp', 756, N'24 x 16 x 3.9', CAST(900.00 AS Decimal(10, 2)), N'available', 17, 2, 2, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T08:50:31.553' AS DateTime), CAST(N'2026-08-15T14:01:41.997' AS DateTime), 12)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (16, N'Literature 12 - Volume 2', N'This book will introduce students to interesting and useful content about the 12th grade Literature subject.

With its rich and engaging presentation style, attractive and user-friendly format, this book is compiled with a focus on developing students'' qualities and competencies. The knowledge in the book will come to students naturally, stemming from real-life situations and helping them learn how to solve problems encountered in life.', CAST(30000.00 AS Decimal(18, 2)), 100, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786777555/heavenscape/products/9786040392770.webp.webp', 140, N'32 x 22.5 x 0.5', CAST(160.00 AS Decimal(10, 2)), N'available', 17, 1, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-21T08:57:45.117' AS DateTime), CAST(N'2026-08-15T14:06:26.010' AS DateTime), 4)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (17, N'I See Yellow Flowers In The Green Grass', N'I see yellow flowers in the green grass is a story of childhood in a poor village in central Vietnam, a childhood that belonged to this very author. When writing this story, it has been my hope that you, reader, will meet some part of your own childhood here too.

Koike Natsu, a college sophomore in Tokyo, wrote to me after reading the Japanese translation of this story: “I see yellow flowers in the green grass stirs my nostalgia for innocent days. When I were little, I also used to play with a toad just like Tường, but I no longer see those animals around my house anymore. People from the city often say, ‘the countryside is so boring, there''s nothing happening there.’ But I don''t think the same. There''s so much in villages to learn about, as your book shows us. Thiều''s village is full of beautiful landscapes, grasses and trees, wind, plus all kind of insects. In Tokyo, such serene spaces are being lost day by day. I have a great nostalgia for them.”

I share Koike Natsu''s feeling, as I always acutely miss the absence of my own childhood. The world of childhood haunts me. I often ache for the old innocent days, often when I am aware of being so distant from them now. The only way I can possibly draw them back to me is to write. I see yellow flowers in the green grass is among my attempts to realize this desire.

I hope you can meet your own childhood self in this book, even when the life and habits of the kids in this book are not the same as yours. I believe that what belongs to the soul can be the same, whenever and wherever you are.

I only have the simple wish that this book can be a map for you. A map with which you can find some paths back to the treasure that you thought was forever lost: your own magical Childhood.

I wish you a good trip.

(Nguyễn Nhật Ánh)', CAST(230000.00 AS Decimal(18, 2)), 16, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786776894/heavenscape/products/8934974188636.webp.webp', 376, N'24 x 16 x 2.1', CAST(270.00 AS Decimal(10, 2)), N'available', 17, 1, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-22T13:38:00.000' AS DateTime), CAST(N'2026-08-15T13:55:33.043' AS DateTime), 10)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (18, N'It Didn''t Start With You', N'Mark Wolynn explores how unresolved trauma and destructive family patterns can be passed from one generation to the next, and offers a practical approach to recognizing inherited emotional patterns and breaking the cycle.', CAST(547000.00 AS Decimal(18, 2)), 21, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786775593/heavenscape/products/it%20didnt.webp.webp', 256, N'21.5 x 13.5', CAST(260.00 AS Decimal(10, 2)), N'available', 8, 2, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-22T13:40:26.580' AS DateTime), CAST(N'2026-08-15T13:34:26.970' AS DateTime), 13)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (19, N'Shin - Crayon Shin-chan - Long Story - Volume 8 - Shin and the Princess of the Universe (Reprint 2024)', N'With captivating storytelling talent, the author transforms the pages of his books into playgrounds overflowing with the laughter of innocent children and a colorful world of childhood. Gentle yet profound educational lessons are also cleverly interwoven into each story. Shin may be a mischievous and energetic boy. His pranks may sometimes go too far, sparing no one. But after the "incidents" caused by Shin, adults realize they need to pay more attention to children, and young readers will surely have the opportunity to reflect on themselves and distinguish between good and bad in life.', CAST(24000.00 AS Decimal(18, 2)), 4, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786776129/heavenscape/products/shin-cau-be-but-chi_truyen-dai_tap-8_tb-2024.webp.webp', 208, N'13 x 20.5', CAST(230.00 AS Decimal(10, 2)), N'available', 7, 4, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-22T13:43:39.173' AS DateTime), CAST(N'2026-08-15T13:42:14.130' AS DateTime), 1)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (20, N'Dragon Ball Super 5', N'In Dragon Ball Super 5, Goku, having perfected Super Saiyan Blue, uses Beerus''s techniques in his battle with Zamasu, but is defeated by a counterattack. Meanwhile, Zamasu''s Potara fusion breaks, separating him from Goku Black! Can Trunks defeat Goku Black?!', CAST(108000.00 AS Decimal(18, 2)), 11, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786775883/heavenscape/products/dbsuper.webp.webp', 192, N'17.7 x 11.2', CAST(300.00 AS Decimal(10, 2)), N'available', 7, 4, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-22T13:45:19.177' AS DateTime), CAST(N'2026-08-15T13:41:40.737' AS DateTime), 1)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (21, N'Detective Conan - Volume 104', N'The mysterious death of the genius chess player "Koji Haneda". The truth behind the forgotten case. After 17 years, now, everything will come to light...', CAST(23750.00 AS Decimal(18, 2)), 2, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786775734/heavenscape/products/conan104.jpg.jpg', 180, N'17.6 x 11.3', CAST(326.00 AS Decimal(10, 2)), N'available', 2, 4, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-22T13:47:59.983' AS DateTime), CAST(N'2026-08-15T13:37:13.593' AS DateTime), 1)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (22, N'100 Things to Know About Science', N'An accessible, highly illustrated introduction to science that presents one hundred fascinating facts about subjects ranging from particle physics to genes and DNA.', CAST(345000.00 AS Decimal(18, 2)), 0, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-22-20260811.jpg', 128, N'24 x 16 x 2.1', CAST(527.00 AS Decimal(10, 2)), N'out_of_stock', 9, 3, 2, NULL, NULL, NULL, 2, NULL, CAST(N'2026-07-22T13:49:38.933' AS DateTime), NULL, 14)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (23, N'Telling the Life Stories of Geniuses: Albert Einstein - A Difficult Childhood and a Great Scientific Life', N'This book contains anecdotes about the life of the brilliant scientist Albert Einstein, who changed the world and the way science was understood at the time.

Due to his Jewish ancestry, Albert Einstein faced discrimination from the very beginning of his schooling. His scientific career was also fraught with difficulties due to objective circumstances and the times, but with his extraordinary intellect, he produced research that revolutionized modern science.

In 1999, he was honored by Time magazine as the Person of the Century. Before his death, he wrote a letter donating his brain to anthropologists for research. The great writer Bernard Shaw called Albert Einstein the "EIGHTH GREATEST MAN" of the scientific world, after Pythagoras, Aristotle, Ptolemy, Copernicus, Galileo, Kepler, and Newton.', CAST(51000.00 AS Decimal(18, 2)), 17, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786776986/heavenscape/products/image_237520.webp.webp', 158, N'14.5 x 20.5 cm', CAST(200.00 AS Decimal(10, 2)), N'available', 14, 1, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-22T13:52:13.990' AS DateTime), CAST(N'2026-08-15T13:56:51.043' AS DateTime), 15)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (24, N'The Psychology Book - Big Ideas Simply Explained', N'The Psychology Book introduces major ideas, experiments, theories, and influential thinkers in psychology through clear explanations and accessible visual presentation, covering how the study of the mind and human behavior has developed over time.', CAST(698400.00 AS Decimal(18, 2)), 29, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786775465/heavenscape/products/big%20ideas.webp.webp', 360, N'24 x 20.3', CAST(1170.00 AS Decimal(10, 2)), N'available', 8, 2, 1, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-22T13:54:55.630' AS DateTime), CAST(N'2026-08-15T13:32:13.570' AS DateTime), 16)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (25, N'The Art of Thinking Clearly', N'The Art of Thinking Clearly by world-class thinker and entrepreneur Rolf Dobelli is an eye-opening look at human psychology and reasoning — essential reading for anyone who wants to avoid “cognitive errors” and make better choices in all aspects of their lives.
Have you ever: Invested time in something that, with hindsight, just wasn’t worth it? Or continued doing something you knew was bad for you? These are examples of cognitive biases, simple errors we all make in our day-to-day thinking. But by knowing what they are and how to spot them, we can avoid them and make better decisions.
Simple, clear, and always surprising, this indispensable book will change the way you think and transform your decision-making—work, at home, every day. It reveals, in 99 short chapters, the most common errors of judgment, and how to avoid them.', CAST(243000.00 AS Decimal(18, 2)), 6, N'https://res.cloudinary.com/duwjwn3lx/image/upload/v1786775311/heavenscape/products/The%20Art%20of%20Thinking%20Clearly.webp.webp', 384, N'17.1 x 2.4 x 10.6', CAST(187.00 AS Decimal(10, 2)), N'available', 17, 2, 2, NULL, NULL, NULL, 2, 2, CAST(N'2026-07-22T13:57:26.100' AS DateTime), CAST(N'2026-08-15T13:30:14.497' AS DateTime), 17)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [created_by], [updated_by], [created_at], [updated_at], [publisherID]) VALUES (26, N'FC Barcelona', N'ádads', CAST(125000.00 AS Decimal(18, 2)), 10, N'https://res.cloudinary.com/llfxqkny/image/upload/v1787389018/heavenscape/products/FCB_wallpaper-cd1edd9d-4486-49f5-b843-fc64c3f350fd.jpg', 122, N'12', CAST(125.00 AS Decimal(10, 2)), N'available', 15, 10, 4, NULL, NULL, NULL, 2, 2, CAST(N'2026-08-22T15:57:24.427' AS DateTime), CAST(N'2026-08-23T02:11:30.433' AS DateTime), 15)
SET IDENTITY_INSERT [dbo].[Book] OFF
GO
SET IDENTITY_INSERT [dbo].[BookAuthor] ON 

INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (8, 2, 2)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (30, 13, 15)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (47, 22, 25)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (53, 25, 29)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (54, 24, 30)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (55, 18, 31)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (57, 21, 32)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (62, 20, 33)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (63, 20, 34)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (64, 19, 35)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (65, 19, 36)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (66, 7, 37)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (67, 6, 37)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (70, 1, 32)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (71, 5, 38)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (72, 12, 14)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (73, 17, 14)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (74, 23, 16)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (75, 8, 30)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (76, 15, 39)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (77, 14, 40)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (78, 3, 41)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (79, 16, 20)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (80, 4, 20)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (81, 11, 42)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (82, 10, 20)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (83, 9, 43)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (85, 26, 45)
SET IDENTITY_INSERT [dbo].[BookAuthor] OFF
GO
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (1, 1)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (5, 1)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (12, 1)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (13, 1)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (17, 1)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (2, 2)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (3, 2)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (22, 2)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (4, 3)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (16, 3)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (9, 5)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (18, 5)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (24, 5)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (25, 5)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (8, 6)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (10, 6)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (11, 6)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (14, 7)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (15, 7)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (26, 7)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (6, 8)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (7, 8)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (19, 8)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (20, 8)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (21, 8)
INSERT [dbo].[BookGenre] ([bookID], [genreID]) VALUES (23, 9)
GO
SET IDENTITY_INSERT [dbo].[BookOrigin] ON 

INSERT [dbo].[BookOrigin] ([originID], [origin_name]) VALUES (1, N'Vietnam')
INSERT [dbo].[BookOrigin] ([originID], [origin_name]) VALUES (2, N'United States')
INSERT [dbo].[BookOrigin] ([originID], [origin_name]) VALUES (3, N'United Kingdom')
INSERT [dbo].[BookOrigin] ([originID], [origin_name]) VALUES (4, N'Japan')
INSERT [dbo].[BookOrigin] ([originID], [origin_name]) VALUES (5, N'South Korea')
INSERT [dbo].[BookOrigin] ([originID], [origin_name]) VALUES (6, N'China')
INSERT [dbo].[BookOrigin] ([originID], [origin_name]) VALUES (7, N'France')
INSERT [dbo].[BookOrigin] ([originID], [origin_name]) VALUES (8, N'Russia')
INSERT [dbo].[BookOrigin] ([originID], [origin_name]) VALUES (9, N'Brazil')
INSERT [dbo].[BookOrigin] ([originID], [origin_name]) VALUES (10, N'Spain')
SET IDENTITY_INSERT [dbo].[BookOrigin] OFF
GO
SET IDENTITY_INSERT [dbo].[BookSeries] ON 

INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (1, N'Harry Potter', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (2, N'Detective Conan', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (3, N'Self-Help Books', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (4, N'Classic Literature', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (5, N'Textbooks', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (6, N'International Manga', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (7, N'Manga & Comics', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (8, N'Top 100 Bestselling Books of 2026', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (9, N'100 Things to Know About', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (10, N'A Pusheen Book', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (11, N'Dandadan', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (12, N'Destination Grammar & Vocabulary', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (13, N'Jujutsu Kaisen', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (14, N'Kể Chuyện Cuộc Đời Các Thiên Tài', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (15, N'Kết Nối Tri Thức Với Cuộc Sống', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (16, N'Minna no Nihongo', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (17, N'Standalone', NULL)
INSERT [dbo].[BookSeries] ([seriesID], [series_name], [description]) VALUES (18, N'Who HQ', NULL)
SET IDENTITY_INSERT [dbo].[BookSeries] OFF
GO
SET IDENTITY_INSERT [dbo].[Cart] ON 

INSERT [dbo].[Cart] ([cartID], [customerID], [status], [created_at], [updated_at]) VALUES (5, 11, N'checked_out', CAST(N'2026-08-10T12:38:43.023' AS DateTime), NULL)
INSERT [dbo].[Cart] ([cartID], [customerID], [status], [created_at], [updated_at]) VALUES (6, 12, N'active', CAST(N'2026-08-12T15:29:25.300' AS DateTime), NULL)
INSERT [dbo].[Cart] ([cartID], [customerID], [status], [created_at], [updated_at]) VALUES (7, 13, N'active', CAST(N'2026-08-22T16:58:56.437' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Cart] OFF
GO
SET IDENTITY_INSERT [dbo].[CartItem] ON 

INSERT [dbo].[CartItem] ([cartItemID], [cartID], [bookID], [quantity], [added_at]) VALUES (8, 6, 1, 1, CAST(N'2026-08-12T15:29:25.317' AS DateTime))
INSERT [dbo].[CartItem] ([cartItemID], [cartID], [bookID], [quantity], [added_at]) VALUES (29, 7, 7, 1, CAST(N'2026-08-22T17:00:36.150' AS DateTime))
SET IDENTITY_INSERT [dbo].[CartItem] OFF
GO
SET IDENTITY_INSERT [dbo].[Content] ON 

INSERT [dbo].[Content] ([contentID], [content_name]) VALUES (1, N'Paperback')
INSERT [dbo].[Content] ([contentID], [content_name]) VALUES (2, N'Hardcover')
INSERT [dbo].[Content] ([contentID], [content_name]) VALUES (3, N'Glossy Cover')
INSERT [dbo].[Content] ([contentID], [content_name]) VALUES (4, N'Audiobook')
SET IDENTITY_INSERT [dbo].[Content] OFF
GO
SET IDENTITY_INSERT [dbo].[Customer] ON 

INSERT [dbo].[Customer] ([customerID], [fullname], [email], [password], [phone], [role], [status], [created_at], [gender], [dob]) VALUES (11, N'Nguyễn Lê Duy Minh', N'duyminhnguyen247@gmail.com', N'acc90d86e202e53c381541ed2521ee18', N'0915783916', N'customer', N'active', CAST(N'2026-08-10T12:38:22.980' AS DateTime), N'Female', CAST(N'2004-10-01' AS Date))
INSERT [dbo].[Customer] ([customerID], [fullname], [email], [password], [phone], [role], [status], [created_at], [gender], [dob]) VALUES (12, N'Minh Duy', N'duyminhnguyenle3619@gmail.com', N'b14e7c766ce93527677960a14365be83', N'0915783916', N'customer', N'active', CAST(N'2026-08-12T15:29:01.870' AS DateTime), NULL, NULL)
INSERT [dbo].[Customer] ([customerID], [fullname], [email], [password], [phone], [role], [status], [created_at], [gender], [dob]) VALUES (13, N'Nguyen Bao Duy', N'tommynguyen9240@gmail.com', N'd2f8ea10fa0d3a7d41a5562d942aee91', N'0908123456', N'customer', N'active', CAST(N'2026-08-21T14:43:25.390' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Customer] OFF
GO
SET IDENTITY_INSERT [dbo].[CustomerVoucher] ON 

INSERT [dbo].[CustomerVoucher] ([customerVoucherID], [customerID], [voucherID], [is_used]) VALUES (1, 11, 6, 1)
INSERT [dbo].[CustomerVoucher] ([customerVoucherID], [customerID], [voucherID], [is_used]) VALUES (2, 11, 3, 1)
SET IDENTITY_INSERT [dbo].[CustomerVoucher] OFF
GO
SET IDENTITY_INSERT [dbo].[Genre] ON 

INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (7, N'Biographies & Memoirs')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (8, N'Comics & Manga')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (6, N'Foreign Languages')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (9, N'History')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (2, N'Life Skills')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (1, N'Literature')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (5, N'Psychology')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (3, N'Textbooks')
SET IDENTITY_INSERT [dbo].[Genre] OFF
GO
SET IDENTITY_INSERT [dbo].[Order] ON 

INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (1, 11, 1, 2, N'cancelled', N'cod', N'refunded', CAST(257000.00 AS Decimal(18, 2)), CAST(N'2026-08-10T14:42:49.103' AS DateTime), N'Sách bị rách', N'staff', NULL)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (2, 11, 1, NULL, N'cancelled', N'cod', N'unpaid', CAST(292500.00 AS Decimal(18, 2)), CAST(N'2026-08-20T23:58:00.810' AS DateTime), N'Order was not approved within two days', N'system', NULL)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (3, 11, 1, 2, N'cancelled', N'cod', N'refunded', CAST(95000.00 AS Decimal(18, 2)), CAST(N'2026-08-21T14:47:47.070' AS DateTime), N'Không hay!', N'staff', NULL)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (4, 11, 1, 2, N'cancelled', N'cod', N'refunded', CAST(111600.00 AS Decimal(18, 2)), CAST(N'2026-08-21T14:59:34.277' AS DateTime), N'Tôi đặt nhầm', N'staff', NULL)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (5, 11, 1, 2, N'completed', N'cod', N'paid', CAST(30000.00 AS Decimal(18, 2)), CAST(N'2026-08-21T15:35:52.593' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (6, 11, 1, 2, N'cancelled', N'cod', N'refunded', CAST(49500.00 AS Decimal(18, 2)), CAST(N'2026-08-21T17:56:59.447' AS DateTime), N'Sách bị lỗi', N'staff', NULL)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (7, 11, 1, NULL, N'cancelled', N'cod', N'unpaid', CAST(49500.00 AS Decimal(18, 2)), CAST(N'2026-08-21T21:55:53.903' AS DateTime), N'abcdrururu', N'user', NULL)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (8, 11, 2, 2, N'completed', N'cod', N'paid', CAST(39600.00 AS Decimal(18, 2)), CAST(N'2026-08-21T21:58:57.737' AS DateTime), NULL, NULL, 6)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (9, 11, 2, NULL, N'cancelled', N'cod', N'unpaid', CAST(170000.00 AS Decimal(18, 2)), CAST(N'2026-08-21T22:10:08.250' AS DateTime), N'Order was not approved within two days', N'system', NULL)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (10, 11, 2, 2, N'cancelled', N'cod', N'unpaid', CAST(698400.00 AS Decimal(18, 2)), CAST(N'2026-08-22T11:26:03.307' AS DateTime), N'Hiện tại hết hàng sorry bạn', N'staff', NULL)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (11, 11, 2, 2, N'cancelled', N'cod', N'unpaid', CAST(2177500.00 AS Decimal(18, 2)), CAST(N'2026-08-22T15:54:00.103' AS DateTime), N'hehehehehehehee', N'staff', 3)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (12, 13, 5, NULL, N'pending', N'cod', N'unpaid', CAST(218700.00 AS Decimal(18, 2)), CAST(N'2026-08-22T17:00:05.573' AS DateTime), NULL, NULL, 3)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (13, 11, 2, NULL, N'pending', N'cod', N'unpaid', CAST(93750.00 AS Decimal(18, 2)), CAST(N'2026-08-23T02:12:41.653' AS DateTime), NULL, NULL, 7)
INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason], [cancelled_by], [voucherID]) VALUES (14, 11, 2, 2, N'cancelled', N'cod', N'pending_refund', CAST(112500.00 AS Decimal(18, 2)), CAST(N'2026-08-23T23:06:03.953' AS DateTime), N'Tôi không còn nhu cầu', N'user', 3)
SET IDENTITY_INSERT [dbo].[Order] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderDetail] ON 

INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (1, 1, 1, 1, CAST(120000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (2, 1, 25, 1, CAST(137000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (3, 2, 25, 1, CAST(243000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (4, 2, 1, 1, CAST(49500.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (5, 3, 2, 1, CAST(95000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (6, 4, 5, 1, CAST(111600.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (7, 5, 7, 1, CAST(30000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (8, 6, 1, 1, CAST(49500.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (9, 7, 1, 1, CAST(49500.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (10, 8, 1, 1, CAST(49500.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (11, 9, 4, 10, CAST(17000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (12, 10, 24, 1, CAST(698400.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (13, 11, 1, 45, CAST(49500.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (14, 12, 25, 1, CAST(243000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (15, 13, 26, 1, CAST(125000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (16, 14, 26, 1, CAST(125000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[OrderDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[Publisher] ON 

INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (11, N'Ballantine Books')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (9, N'Cambridge University Press & Assessment')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (16, N'DK')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (17, N'Harper')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (2, N'HarperOne')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (12, N'NXB Công Thương')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (3, N'NXB Dân Trí')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (4, N'NXB Giáo Dục Việt Nam')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (1, N'NXB Kim Đồng')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (8, N'NXB Phụ Nữ Việt Nam')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (15, N'NXB Thanh Niên')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (7, N'NXB Tổng Hợp TP.HCM')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (10, N'NXB Trẻ')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (5, N'NXB Văn Học')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (6, N'Shueisha')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (14, N'Usborne Publishing')
INSERT [dbo].[Publisher] ([publisherID], [publisher_name]) VALUES (13, N'Vermilion')
SET IDENTITY_INSERT [dbo].[Publisher] OFF
GO
SET IDENTITY_INSERT [dbo].[Review] ON 

INSERT [dbo].[Review] ([reviewID], [customerID], [bookID], [orderDetailID], [rating], [comment], [created_at], [adminReply], [adminReplyDate], [adminID], [isHidden]) VALUES (1, 11, 1, 1, 5, N'Sách quá hay!', CAST(N'2026-08-11T15:27:52.847' AS DateTime), N'Cảm ơn bạn rất nhiều !!!!', CAST(N'2026-08-21T01:47:51.340' AS DateTime), 2, 0)
SET IDENTITY_INSERT [dbo].[Review] OFF
GO
SET IDENTITY_INSERT [dbo].[Voucher] ON 

INSERT [dbo].[Voucher] ([voucherID], [code], [discount_percent], [quantity], [start_date], [end_date], [status], [is_deleted], [min_order_value], [max_discount_value]) VALUES (3, N'SALE2028', CAST(10.00 AS Decimal(5, 2)), 10, CAST(N'2026-07-24T00:00:00.000' AS DateTime), CAST(N'2026-08-31T00:00:00.000' AS DateTime), N'active', 0, CAST(100000.00 AS Decimal(18, 2)), CAST(40000.00 AS Decimal(18, 2)))
INSERT [dbo].[Voucher] ([voucherID], [code], [discount_percent], [quantity], [start_date], [end_date], [status], [is_deleted], [min_order_value], [max_discount_value]) VALUES (5, N'HS69GMHY', CAST(10.00 AS Decimal(5, 2)), 10000, CAST(N'2026-07-25T00:00:00.000' AS DateTime), CAST(N'2026-07-31T00:00:00.000' AS DateTime), N'active', 1, CAST(1000000.00 AS Decimal(18, 2)), CAST(100000.00 AS Decimal(18, 2)))
INSERT [dbo].[Voucher] ([voucherID], [code], [discount_percent], [quantity], [start_date], [end_date], [status], [is_deleted], [min_order_value], [max_discount_value]) VALUES (6, N'SWP', CAST(20.00 AS Decimal(5, 2)), 10, CAST(N'2026-07-25T00:00:00.000' AS DateTime), CAST(N'2026-08-31T00:00:00.000' AS DateTime), N'active', 0, CAST(10000.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)))
INSERT [dbo].[Voucher] ([voucherID], [code], [discount_percent], [quantity], [start_date], [end_date], [status], [is_deleted], [min_order_value], [max_discount_value]) VALUES (7, N'FCB', CAST(25.00 AS Decimal(5, 2)), 10, CAST(N'2026-08-21T00:00:00.000' AS DateTime), CAST(N'2026-09-01T00:00:00.000' AS DateTime), N'active', 0, CAST(99000.00 AS Decimal(18, 2)), CAST(40000.00 AS Decimal(18, 2)))
INSERT [dbo].[Voucher] ([voucherID], [code], [discount_percent], [quantity], [start_date], [end_date], [status], [is_deleted], [min_order_value], [max_discount_value]) VALUES (8, N'TES T', CAST(15.00 AS Decimal(5, 2)), 10, CAST(N'2026-08-21T00:00:00.000' AS DateTime), CAST(N'2026-08-23T00:00:00.000' AS DateTime), N'active', 1, CAST(199000.00 AS Decimal(18, 2)), CAST(20000.00 AS Decimal(18, 2)))
INSERT [dbo].[Voucher] ([voucherID], [code], [discount_percent], [quantity], [start_date], [end_date], [status], [is_deleted], [min_order_value], [max_discount_value]) VALUES (9, N'SUMMERTIME26', CAST(50.00 AS Decimal(5, 2)), 5, CAST(N'2026-08-21T00:00:00.000' AS DateTime), CAST(N'2026-09-30T00:00:00.000' AS DateTime), N'active', 0, CAST(499999.00 AS Decimal(18, 2)), CAST(100000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[Voucher] OFF
GO
SET IDENTITY_INSERT [dbo].[WishList] ON 

INSERT [dbo].[WishList] ([wishlistID], [customerID], [created_at]) VALUES (5, 11, CAST(N'2026-08-11T03:52:40.020' AS DateTime))
SET IDENTITY_INSERT [dbo].[WishList] OFF
GO
SET IDENTITY_INSERT [dbo].[WishList_Item] ON 

INSERT [dbo].[WishList_Item] ([wishlistItemID], [wishlistID], [bookID], [added_at]) VALUES (1, 5, 22, CAST(N'2026-08-21T23:03:51.990' AS DateTime))
SET IDENTITY_INSERT [dbo].[WishList_Item] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Account__AB6E616423EC01A2]    Script Date: 8/23/2026 11:26:14 PM ******/
ALTER TABLE [dbo].[Account] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Address_CustomerID]    Script Date: 8/23/2026 11:26:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_Address_CustomerID] ON [dbo].[Address]
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Book_CreatedBy]    Script Date: 8/23/2026 11:26:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_Book_CreatedBy] ON [dbo].[Book]
(
	[created_by] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Book_PublisherID]    Script Date: 8/23/2026 11:26:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_Book_PublisherID] ON [dbo].[Book]
(
	[publisherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_BookGenre_GenreID]    Script Date: 8/23/2026 11:26:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_BookGenre_GenreID] ON [dbo].[BookGenre]
(
	[genreID] ASC,
	[bookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Cart__B611CB9C688692F2]    Script Date: 8/23/2026 11:26:14 PM ******/
ALTER TABLE [dbo].[Cart] ADD UNIQUE NONCLUSTERED 
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CartItem_CartID]    Script Date: 8/23/2026 11:26:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_CartItem_CartID] ON [dbo].[CartItem]
(
	[cartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Customer__AB6E61648634CF6B]    Script Date: 8/23/2026 11:26:14 PM ******/
ALTER TABLE [dbo].[Customer] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_Customer_Voucher]    Script Date: 8/23/2026 11:26:14 PM ******/
ALTER TABLE [dbo].[CustomerVoucher] ADD  CONSTRAINT [UQ_Customer_Voucher] UNIQUE NONCLUSTERED 
(
	[customerID] ASC,
	[voucherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Genre_GenreName]    Script Date: 8/23/2026 11:26:14 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_Genre_GenreName] ON [dbo].[Genre]
(
	[genre_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Order_CustomerID]    Script Date: 8/23/2026 11:26:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_Order_CustomerID] ON [dbo].[Order]
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderDetail_OrderID]    Script Date: 8/23/2026 11:26:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrderDetail_OrderID] ON [dbo].[OrderDetail]
(
	[orderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Publisher_Name]    Script Date: 8/23/2026 11:26:14 PM ******/
ALTER TABLE [dbo].[Publisher] ADD  CONSTRAINT [UQ_Publisher_Name] UNIQUE NONCLUSTERED 
(
	[publisher_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Review_BookID]    Script Date: 8/23/2026 11:26:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_Review_BookID] ON [dbo].[Review]
(
	[bookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Voucher__357D4CF94747E3E6]    Script Date: 8/23/2026 11:26:14 PM ******/
ALTER TABLE [dbo].[Voucher] ADD UNIQUE NONCLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ('active') FOR [status]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Address] ADD  DEFAULT ((0)) FOR [is_default]
GO
ALTER TABLE [dbo].[Book] ADD  DEFAULT ((0)) FOR [stock_quantity]
GO
ALTER TABLE [dbo].[Book] ADD  DEFAULT ('available') FOR [status]
GO
ALTER TABLE [dbo].[Book] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Cart] ADD  DEFAULT ('active') FOR [status]
GO
ALTER TABLE [dbo].[Cart] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[CartItem] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[CartItem] ADD  DEFAULT (getdate()) FOR [added_at]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ('customer') FOR [role]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ('active') FOR [status]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[CustomerVoucher] ADD  DEFAULT ((0)) FOR [is_used]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT ('pending') FOR [status]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT ('unpaid') FOR [payment_status]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Review] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Review] ADD  DEFAULT ((0)) FOR [isHidden]
GO
ALTER TABLE [dbo].[Voucher] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[WishList] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[WishList_Item] ADD  DEFAULT (getdate()) FOR [added_at]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_UpdatedBy] FOREIGN KEY([updated_by])
REFERENCES [dbo].[Account] ([accountID])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [FK_Account_UpdatedBy]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD FOREIGN KEY([audienceID])
REFERENCES [dbo].[Intended_Audience] ([audienceID])
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD FOREIGN KEY([contentID])
REFERENCES [dbo].[Content] ([contentID])
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD FOREIGN KEY([created_by])
REFERENCES [dbo].[Account] ([accountID])
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD FOREIGN KEY([languageID])
REFERENCES [dbo].[Language] ([languageID])
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD FOREIGN KEY([originID])
REFERENCES [dbo].[BookOrigin] ([originID])
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD FOREIGN KEY([purposeID])
REFERENCES [dbo].[Purpose] ([purposeID])
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD FOREIGN KEY([seriesID])
REFERENCES [dbo].[BookSeries] ([seriesID])
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD FOREIGN KEY([updated_by])
REFERENCES [dbo].[Account] ([accountID])
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Book_Publisher] FOREIGN KEY([publisherID])
REFERENCES [dbo].[Publisher] ([publisherID])
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK_Book_Publisher]
GO
ALTER TABLE [dbo].[BookAuthor]  WITH CHECK ADD FOREIGN KEY([authorID])
REFERENCES [dbo].[Author] ([authorID])
GO
ALTER TABLE [dbo].[BookAuthor]  WITH CHECK ADD FOREIGN KEY([bookID])
REFERENCES [dbo].[Book] ([bookID])
GO
ALTER TABLE [dbo].[BookGenre]  WITH CHECK ADD  CONSTRAINT [FK_BookGenre_Book] FOREIGN KEY([bookID])
REFERENCES [dbo].[Book] ([bookID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BookGenre] CHECK CONSTRAINT [FK_BookGenre_Book]
GO
ALTER TABLE [dbo].[BookGenre]  WITH CHECK ADD  CONSTRAINT [FK_BookGenre_Genre] FOREIGN KEY([genreID])
REFERENCES [dbo].[Genre] ([genreID])
GO
ALTER TABLE [dbo].[BookGenre] CHECK CONSTRAINT [FK_BookGenre_Genre]
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[CartItem]  WITH CHECK ADD FOREIGN KEY([bookID])
REFERENCES [dbo].[Book] ([bookID])
GO
ALTER TABLE [dbo].[CartItem]  WITH CHECK ADD FOREIGN KEY([cartID])
REFERENCES [dbo].[Cart] ([cartID])
GO
ALTER TABLE [dbo].[CustomerVoucher]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[CustomerVoucher]  WITH CHECK ADD FOREIGN KEY([voucherID])
REFERENCES [dbo].[Voucher] ([voucherID])
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([addressID])
REFERENCES [dbo].[Address] ([addressID])
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([processed_by])
REFERENCES [dbo].[Account] ([accountID])
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Voucher] FOREIGN KEY([voucherID])
REFERENCES [dbo].[Voucher] ([voucherID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Voucher]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD FOREIGN KEY([bookID])
REFERENCES [dbo].[Book] ([bookID])
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD FOREIGN KEY([orderID])
REFERENCES [dbo].[Order] ([orderID])
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD FOREIGN KEY([bookID])
REFERENCES [dbo].[Book] ([bookID])
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD FOREIGN KEY([orderDetailID])
REFERENCES [dbo].[OrderDetail] ([orderDetailID])
GO
ALTER TABLE [dbo].[WishList]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[WishList_Item]  WITH CHECK ADD FOREIGN KEY([bookID])
REFERENCES [dbo].[Book] ([bookID])
GO
ALTER TABLE [dbo].[WishList_Item]  WITH CHECK ADD FOREIGN KEY([wishlistID])
REFERENCES [dbo].[WishList] ([wishlistID])
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD CHECK  (([role]='staff' OR [role]='admin'))
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD CHECK  (([status]='inactive' OR [status]='active'))
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD CHECK  (([status]='discontinued' OR [status]='out_of_stock' OR [status]='available'))
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD CHECK  (([status]='abandoned' OR [status]='checked_out' OR [status]='active'))
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD CHECK  (([status]='banned' OR [status]='inactive' OR [status]='active'))
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD CHECK  (([status]='cancelled' OR [status]='completed' OR [status]='shipping' OR [status]='confirmed' OR [status]='pending'))
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [CK_Order_PaymentStatus] CHECK  (([payment_status]='refund_rejected' OR [payment_status]='pending_refund' OR [payment_status]='refunded' OR [payment_status]='paid' OR [payment_status]='unpaid'))
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [CK_Order_PaymentStatus]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD CHECK  (([rating]>=(1) AND [rating]<=(5)))
GO
USE [master]
GO
ALTER DATABASE [HeavenScape_finalDB] SET  READ_WRITE 
GO

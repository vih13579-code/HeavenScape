USE [master]
GO

CREATE DATABASE [HeavenScapeDB]
GO

USE [HeavenScapeDB]
GO

/****** Object:  Table [dbo].[Account]    Script Date: 8/12/2026 3:34:42 PM ******/
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
/****** Object:  Table [dbo].[Address]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[Author]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[Book]    Script Date: 8/12/2026 3:34:43 PM ******/
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
	[genreID] [int] NULL,
	[created_by] [int] NULL,
	[updated_by] [int] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[bookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookAuthor]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[BookOrigin]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[BookSeries]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[Cart]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[CartItem]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[Content]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[Customer]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[CustomerVoucher]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[Genre]    Script Date: 8/12/2026 3:34:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genre](
	[genreID] [int] IDENTITY(1,1) NOT NULL,
	[genre_name] [nvarchar](150) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[genreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Intended_Audience]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[Language]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[Order]    Script Date: 8/12/2026 3:34:43 PM ******/
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
	[total_price] [decimal](18, 2) NULL,
	[created_at] [datetime] NULL,
	[cancel_reason] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[orderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[Purpose]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[Review]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[Voucher]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[WishList]    Script Date: 8/12/2026 3:34:43 PM ******/
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
/****** Object:  Table [dbo].[WishList_Item]    Script Date: 8/12/2026 3:34:43 PM ******/
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

INSERT [dbo].[Address] ([addressID], [customerID], [street], [district], [city], [country], [is_default], [recipient_name], [recipient_phone]) VALUES (1, 11, N'600 CMT8', N'Phường Cái Khế', N'Thành phố Cần Thơ', N'Vietnam', 1, N'Minh Duy', N'0915783916')
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
SET IDENTITY_INSERT [dbo].[Author] OFF
GO
SET IDENTITY_INSERT [dbo].[Book] ON 

INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (1, N'How to Win Friends and Influence People', N'Dale Carnegie presents timeless principles for communicating effectively, building strong relationships, and positively influencing others in both personal and professional life.', CAST(120000.00 AS Decimal(18, 2)), 46, N'http://res.cloudinary.com/duwjwn3lx/image/upload/v1786428238/heavenscape/products/how_to_win_friends_and_influence_people_1_2019_01_21_16_02_46.webp.webp', 304, N'', NULL, N'available', 17, 2, 1, NULL, NULL, NULL, 1, NULL, 2, CAST(N'2026-06-01T10:03:49.333' AS DateTime), CAST(N'2026-08-11T13:04:03.553' AS DateTime))
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (2, N'The Alchemist', N'Paulo Coelho follows Santiago, a young shepherd who travels in search of treasure and discovers the importance of pursuing his dreams and listening to his heart.', CAST(95000.00 AS Decimal(18, 2)), 37, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-02-20260811.jpg', 208, N'', NULL, N'available', 17, 9, 1, NULL, NULL, NULL, 2, NULL, 2, CAST(N'2026-06-01T10:03:49.333' AS DateTime), CAST(N'2026-07-22T20:24:25.860' AS DateTime))
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (3, N'How Much Is Youth Worth?', N'Rosie Nguyen shares practical reflections for young people seeking direction, encouraging purposeful living, self-discovery, courage, and appreciation for the years of youth.', CAST(105000.00 AS Decimal(18, 2)), 0, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-03-20260811.jpg', 285, N'', NULL, N'out_of_stock', 17, 1, 1, NULL, NULL, NULL, 2, NULL, 2, CAST(N'2026-06-01T10:03:49.333' AS DateTime), CAST(N'2026-07-21T07:17:46.703' AS DateTime))
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (4, N'Vietnamese Language Grade 1', N'An introductory Grade 1 textbook that helps children develop foundational Vietnamese reading, writing, vocabulary, and communication skills.', CAST(50000.00 AS Decimal(18, 2)), 15, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-04-20260811.jpg', 184, N'', NULL, N'available', 15, 1, 1, NULL, NULL, NULL, 3, 1, 2, CAST(N'2026-06-25T19:12:49.327' AS DateTime), CAST(N'2026-07-21T07:23:28.140' AS DateTime))
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (5, N'Lolita (2024 Reprint)', N'Vladimir Nabokov''s celebrated and controversial novel is narrated by Humbert Humbert and is renowned for its intricate prose, unreliable perspective, and exploration of obsession and self-deception.', CAST(120000.00 AS Decimal(18, 2)), 20, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-05-20260811.jpg', 368, N'15x24', NULL, N'available', 17, 2, 1, NULL, NULL, NULL, 1, 2, 2, CAST(N'2026-07-21T06:57:52.487' AS DateTime), CAST(N'2026-07-21T08:59:21.283' AS DateTime))
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (6, N'Goodbye, Eri', N'Tatsuki Fujimoto tells the story of Yuta, a young filmmaker whose attempt to document his mother''s final days leads him to Eri and blurs the boundary between memory, cinema, and reality.', CAST(136000.00 AS Decimal(18, 2)), 4, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-06-20260811.jpg', 208, N'17.6 x 11.2 x 1.4', CAST(200.00 AS Decimal(10, 2)), N'available', 17, 4, 1, NULL, NULL, NULL, 8, 2, 2, CAST(N'2026-07-21T07:01:47.220' AS DateTime), CAST(N'2026-07-22T13:43:57.997' AS DateTime))
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (7, N'Jujutsu Kaisen, Vol. 26: Heading South', N'The unprecedented battle between Satoru Gojo and Ryomen Sukuna reaches a decisive stage as both fighters push their cursed techniques and domains to their limits.', CAST(30000.00 AS Decimal(18, 2)), 2, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-07-20260811.jpg', 192, N'17.6 x 11.3 x 0.9', CAST(160.00 AS Decimal(10, 2)), N'available', 13, 4, 1, NULL, NULL, NULL, 8, 2, 2, CAST(N'2026-07-21T07:05:45.450' AS DateTime), CAST(N'2026-07-22T13:43:47.670' AS DateTime))
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (8, N'Minna no Nihongo Elementary Japanese I - Main Textbook (New Edition, 2023 Reprint)', N'A widely used beginner Japanese textbook with structured lessons, sentence patterns, dialogues, examples, and exercises for learners building practical language skills.', CAST(149000.00 AS Decimal(18, 2)), 50, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-08-20260811.jpg', 324, N'26 x 19 x 1.6 cm', CAST(340.00 AS Decimal(10, 2)), N'available', 16, 4, 1, NULL, NULL, NULL, 6, 2, 2, CAST(N'2026-07-21T07:16:22.183' AS DateTime), CAST(N'2026-07-21T08:15:38.780' AS DateTime))
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (9, N'Genius on the Left, Lunatic on the Right (2021 Reprint)', N'Based on conversations and case studies, this book explores unusual ways of thinking and invites readers to reconsider the fragile boundary between genius, mental illness, and accepted reality.', CAST(120000.00 AS Decimal(18, 2)), 30, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-09-20260811.jpg', 424, N'24 x 16 x 2.1', CAST(450.00 AS Decimal(10, 2)), N'available', 17, 6, 1, NULL, NULL, NULL, 5, 2, 2, CAST(N'2026-07-21T08:15:20.010' AS DateTime), CAST(N'2026-07-21T08:28:02.123' AS DateTime))
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (10, N'Destination B1: Grammar and Vocabulary with Answer Key (2025 Reprint)', N'A structured B1-level study guide covering essential English grammar and vocabulary, with topic-based units, review sections, practice activities, and an answer key.', CAST(150000.00 AS Decimal(18, 2)), 20, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-10-20260811.jpg', 248, N'29 x 21 x 1.2', CAST(500.00 AS Decimal(10, 2)), N'available', 12, 3, 1, NULL, NULL, NULL, 6, 2, NULL, CAST(N'2026-07-21T08:18:42.160' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (11, N'Destination B2: Grammar and Vocabulary with Answer Key (2025 Reprint)', N'A comprehensive B2-level resource that develops English grammar and vocabulary through clear explanations, focused exercises, review units, and exam-oriented practice.', CAST(150000.00 AS Decimal(18, 2)), 10, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-11-20260811.jpg', 246, N'29 x 21 x 1.2', CAST(560.00 AS Decimal(10, 2)), N'available', 12, 3, 1, NULL, NULL, NULL, 6, 2, NULL, CAST(N'2026-07-21T08:20:06.873' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (12, N'Give Me a Ticket Back to Childhood (2023 Reprint)', N'Nguyen Nhat Anh revisits childhood through warm, humorous memories, contrasting the imagination of children with the routines and expectations of adult life.', CAST(77000.00 AS Decimal(18, 2)), 15, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-12-20260811.jpg', 208, N'20 x 13 x 1', CAST(220.00 AS Decimal(10, 2)), N'available', 17, 1, 1, NULL, NULL, NULL, 1, 2, NULL, CAST(N'2026-07-21T08:23:47.790' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (13, N'Project Hail Mary', N'Andy Weir follows Ryland Grace, a lone astronaut who awakens without his memories and must solve an interstellar scientific mystery to save humanity.', CAST(140000.00 AS Decimal(18, 2)), 30, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-13-20260811.jpg', 496, N'26 x 19 x 1.6 cm', CAST(750.00 AS Decimal(10, 2)), N'available', 17, 2, 1, NULL, NULL, NULL, 1, 2, 2, CAST(N'2026-07-21T08:27:42.493' AS DateTime), CAST(N'2026-07-21T08:27:52.823' AS DateTime))
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (14, N'Stories of Great Lives: Marie Curie - An Outstanding Female Scientist', N'An accessible biography of Marie Curie that introduces her scientific discoveries, perseverance, achievements, and lasting influence on modern science.', CAST(60000.00 AS Decimal(18, 2)), 22, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-14-20260811.jpg', 213, N'20.5 x 14.5', CAST(240.00 AS Decimal(10, 2)), N'available', 14, 1, 1, NULL, NULL, NULL, 7, 2, NULL, CAST(N'2026-07-21T08:30:19.983' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (15, N'Who Is Michelle Obama?', N'An illustrated biography introducing Michelle Obama''s childhood, education, career, public service, and years as First Lady of the United States.', CAST(132000.00 AS Decimal(18, 2)), 36, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-15-20260811.jpg', 112, N'19.4 x 14.1 x 0.7', CAST(120.00 AS Decimal(10, 2)), N'available', 18, 2, 1, NULL, NULL, NULL, 7, 2, NULL, CAST(N'2026-07-21T08:50:31.553' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (16, N'Vietnam Geography Atlas', N'A reference atlas with maps, charts, and geographic information about Vietnam''s natural features, population, regions, economy, and administrative divisions.', CAST(30000.00 AS Decimal(18, 2)), 100, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-16-20260811.jpg', 32, N'32 x 22.5 x 0.5', CAST(200.00 AS Decimal(10, 2)), N'available', 17, 1, 1, NULL, NULL, NULL, 3, 2, NULL, CAST(N'2026-07-21T08:57:45.117' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (17, N'Lemon and the Murderer', N'A psychological mystery by Ayu Kuwagaki that explores guilt, violence, hidden motives, and the unsettling truths surrounding a murder.', CAST(139000.00 AS Decimal(18, 2)), 16, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-17-20260811.png', 256, N'24 x 16 x 2.1', CAST(270.00 AS Decimal(10, 2)), N'available', 17, 4, 1, NULL, NULL, NULL, 1, 2, NULL, CAST(N'2026-07-22T13:38:00.000' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (18, N'The Power of Your Subconscious Mind', N'Joseph Murphy explains how beliefs, mental habits, and visualization can influence behavior, confidence, relationships, achievement, and personal well-being.', CAST(100000.00 AS Decimal(18, 2)), 21, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-18-20260811.jpg', 320, N'13 x 20.5', CAST(340.00 AS Decimal(10, 2)), N'available', 17, 2, 1, NULL, NULL, NULL, 5, 2, NULL, CAST(N'2026-07-22T13:40:26.580' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (19, N'Dandadan, Vol. 1', N'Momo believes in ghosts while Okarun believes in aliens. Their challenge to prove each other wrong pulls them into a chaotic supernatural adventure filled with strange powers and unexpected danger.', CAST(45000.00 AS Decimal(18, 2)), 4, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-19-20260811.jpg', 208, N'13 x 20.5', CAST(230.00 AS Decimal(10, 2)), N'available', 11, 4, 1, NULL, NULL, NULL, 8, 2, NULL, CAST(N'2026-07-22T13:43:39.173' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (20, N'Dandadan, Vol. 2', N'Momo and Okarun continue their frantic supernatural battle against Turbo Granny and a giant spirit, combining action, comedy, romance, and paranormal chaos.', CAST(40000.00 AS Decimal(18, 2)), 11, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-20-20260811.jpg', 210, N'13 x 20.5', CAST(230.00 AS Decimal(10, 2)), N'available', 11, 4, 1, NULL, NULL, NULL, 8, 2, NULL, CAST(N'2026-07-22T13:45:19.177' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (21, N'The Many Lives of Pusheen the Cat', N'A full-color comic collection in which Pusheen becomes a unicorn, mermaid, dragon, dinosaur, and many other imaginative characters in a series of cozy and humorous adventures.', CAST(370000.00 AS Decimal(18, 2)), 2, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-21-20260811.jpg', 192, N'20.5 x 14.5', CAST(326.00 AS Decimal(10, 2)), N'available', 10, 2, 1, NULL, NULL, NULL, 8, 2, NULL, CAST(N'2026-07-22T13:47:59.983' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (22, N'100 Things to Know About Science', N'An accessible, highly illustrated introduction to science that presents one hundred fascinating facts about subjects ranging from particle physics to genes and DNA.', CAST(345000.00 AS Decimal(18, 2)), 0, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-22-20260811.jpg', 128, N'24 x 16 x 2.1', CAST(527.00 AS Decimal(10, 2)), N'out_of_stock', 9, 3, 2, NULL, NULL, NULL, 2, 2, NULL, CAST(N'2026-07-22T13:49:38.933' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (23, N'The Paris Agreement: A Victory of Vietnam''s Independence, Sovereignty, and Just Cause', N'Nguyen Thi Binh recounts the negotiations and historical significance of the 1973 Paris Peace Accords, highlighting Vietnam''s diplomacy, determination, sovereignty, and pursuit of peace.', CAST(151000.00 AS Decimal(18, 2)), 17, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-23-20260811.jpg', 239, N'20.5 x 14.5', CAST(250.00 AS Decimal(10, 2)), N'available', 17, 1, 2, NULL, NULL, NULL, 9, 2, NULL, CAST(N'2026-07-22T13:52:13.990' AS DateTime), CAST(N'2026-07-22T20:24:25.857' AS DateTime))
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (24, N'Stop Trying to Please Everyone', N'A practical guide to recognizing people-pleasing habits, setting healthy boundaries, communicating with confidence, and building a freer and more balanced life.', CAST(105000.00 AS Decimal(18, 2)), 29, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-24-20260811.jpg', 172, N'20.5 x 14.5', CAST(230.00 AS Decimal(10, 2)), N'available', 17, 2, 1, NULL, NULL, NULL, 5, 2, NULL, CAST(N'2026-07-22T13:54:55.630' AS DateTime), NULL)
INSERT [dbo].[Book] ([bookID], [title], [description], [price], [stock_quantity], [thumbnail], [total_pages], [dimensions], [weight], [status], [seriesID], [originID], [contentID], [languageID], [audienceID], [purposeID], [genreID], [created_by], [updated_by], [created_at], [updated_at]) VALUES (25, N'The Catalyst: How to Change Anyone''s Mind', N'Jonah Berger explains how effective persuasion works by removing barriers to change. Through research and real-world cases, he presents practical tools for reducing resistance and inspiring voluntary action.', CAST(137000.00 AS Decimal(18, 2)), 6, N'https://res.cloudinary.com/duwjwn3lx/image/upload/heavenscape/products/book-cover-25-20260811.jpg', 288, N'20.5 x 14.5', CAST(359.00 AS Decimal(10, 2)), N'available', 17, 2, 2, NULL, NULL, NULL, 5, 2, NULL, CAST(N'2026-07-22T13:57:26.100' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Book] OFF
GO
SET IDENTITY_INSERT [dbo].[BookAuthor] ON 

INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (8, 2, 2)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (19, 3, 3)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (20, 4, 4)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (23, 8, 9)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (24, 10, 11)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (25, 10, 12)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (26, 11, 13)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (27, 11, 12)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (28, 12, 14)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (30, 13, 15)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (31, 9, 10)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (32, 14, 16)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (33, 15, 17)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (34, 15, 18)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (35, 15, 19)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (36, 16, 20)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (39, 5, 5)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (40, 17, 21)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (41, 18, 22)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (42, 19, 23)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (43, 7, 8)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (44, 6, 7)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (45, 20, 23)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (46, 21, 24)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (47, 22, 25)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (48, 23, 26)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (49, 24, 27)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (50, 25, 28)
INSERT [dbo].[BookAuthor] ([bookAuthorID], [bookID], [authorID]) VALUES (52, 1, 1)
SET IDENTITY_INSERT [dbo].[BookAuthor] OFF
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

INSERT [dbo].[Cart] ([cartID], [customerID], [status], [created_at], [updated_at]) VALUES (4, 10, N'active', CAST(N'2026-07-24T15:26:59.877' AS DateTime), NULL)
INSERT [dbo].[Cart] ([cartID], [customerID], [status], [created_at], [updated_at]) VALUES (5, 11, N'active', CAST(N'2026-08-10T12:38:43.023' AS DateTime), NULL)
INSERT [dbo].[Cart] ([cartID], [customerID], [status], [created_at], [updated_at]) VALUES (6, 12, N'active', CAST(N'2026-08-12T15:29:25.300' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Cart] OFF
GO
SET IDENTITY_INSERT [dbo].[CartItem] ON 

INSERT [dbo].[CartItem] ([cartItemID], [cartID], [bookID], [quantity], [added_at]) VALUES (6, 5, 1, 1, CAST(N'2026-08-11T13:05:56.730' AS DateTime))
INSERT [dbo].[CartItem] ([cartItemID], [cartID], [bookID], [quantity], [added_at]) VALUES (7, 5, 25, 1, CAST(N'2026-08-12T14:59:07.880' AS DateTime))
INSERT [dbo].[CartItem] ([cartItemID], [cartID], [bookID], [quantity], [added_at]) VALUES (8, 6, 1, 1, CAST(N'2026-08-12T15:29:25.317' AS DateTime))
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

INSERT [dbo].[Customer] ([customerID], [fullname], [email], [password], [phone], [role], [status], [created_at], [gender], [dob]) VALUES (10, N'Nguyen Thi A', N'truongngoctran2209@gmail.com', N'e10adc3949ba59abbe56e057f20f883e', N'0987654321', N'customer', N'active', CAST(N'2026-07-24T15:26:08.027' AS DateTime), N'Male', CAST(N'2003-07-24' AS Date))
INSERT [dbo].[Customer] ([customerID], [fullname], [email], [password], [phone], [role], [status], [created_at], [gender], [dob]) VALUES (11, N'Minh Duy', N'duyminhnguyen247@gmail.com', N'acc90d86e202e53c381541ed2521ee18', N'0915783916', N'customer', N'active', CAST(N'2026-08-10T12:38:22.980' AS DateTime), NULL, NULL)
INSERT [dbo].[Customer] ([customerID], [fullname], [email], [password], [phone], [role], [status], [created_at], [gender], [dob]) VALUES (12, N'Minh Duy', N'duyminhnguyenle3619@gmail.com', N'b14e7c766ce93527677960a14365be83', N'0915783916', N'customer', N'active', CAST(N'2026-08-12T15:29:01.870' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Customer] OFF
GO
SET IDENTITY_INSERT [dbo].[Genre] ON 

INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (1, N'Literature')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (2, N'Life Skills')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (3, N'Textbooks')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (5, N'Psychology')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (6, N'Foreign Languages')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (7, N'Biographies & Memoirs')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (8, N'Comics & Manga')
INSERT [dbo].[Genre] ([genreID], [genre_name]) VALUES (9, N'History')
SET IDENTITY_INSERT [dbo].[Genre] OFF
GO
SET IDENTITY_INSERT [dbo].[Order] ON 

INSERT [dbo].[Order] ([orderID], [customerID], [addressID], [processed_by], [status], [payment_method], [payment_status], [total_price], [created_at], [cancel_reason]) VALUES (1, 11, 1, 2, N'completed', N'cod', N'paid', CAST(257000.00 AS Decimal(18, 2)), CAST(N'2026-08-10T14:42:49.103' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Order] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderDetail] ON 

INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (1, 1, 1, 1, CAST(120000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetail] ([orderDetailID], [orderID], [bookID], [quantity], [unit_price]) VALUES (2, 1, 25, 1, CAST(137000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[OrderDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[Review] ON 

INSERT [dbo].[Review] ([reviewID], [customerID], [bookID], [orderDetailID], [rating], [comment], [created_at], [adminReply], [adminReplyDate], [adminID], [isHidden]) VALUES (1, 11, 1, 1, 5, N'Sách quá hay!', CAST(N'2026-08-11T15:27:52.847' AS DateTime), NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[Review] OFF
GO
SET IDENTITY_INSERT [dbo].[Voucher] ON 

INSERT [dbo].[Voucher] ([voucherID], [code], [discount_percent], [quantity], [start_date], [end_date], [status], [is_deleted], [min_order_value], [max_discount_value]) VALUES (3, N'SALE2027', CAST(10.00 AS Decimal(5, 2)), 10, CAST(N'2026-07-24T00:00:00.000' AS DateTime), CAST(N'2026-08-31T00:00:00.000' AS DateTime), N'active', 0, CAST(100000.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)))
INSERT [dbo].[Voucher] ([voucherID], [code], [discount_percent], [quantity], [start_date], [end_date], [status], [is_deleted], [min_order_value], [max_discount_value]) VALUES (5, N'HS69GMHY', CAST(10.00 AS Decimal(5, 2)), 10000, CAST(N'2026-07-25T00:00:00.000' AS DateTime), CAST(N'2026-07-31T00:00:00.000' AS DateTime), N'active', 1, CAST(1000000.00 AS Decimal(18, 2)), CAST(100000.00 AS Decimal(18, 2)))
INSERT [dbo].[Voucher] ([voucherID], [code], [discount_percent], [quantity], [start_date], [end_date], [status], [is_deleted], [min_order_value], [max_discount_value]) VALUES (6, N'SWP', CAST(20.00 AS Decimal(5, 2)), 10, CAST(N'2026-07-25T00:00:00.000' AS DateTime), CAST(N'2026-08-15T00:00:00.000' AS DateTime), N'active', 0, CAST(1000000.00 AS Decimal(18, 2)), CAST(100000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[Voucher] OFF
GO
SET IDENTITY_INSERT [dbo].[WishList] ON 

INSERT [dbo].[WishList] ([wishlistID], [customerID], [created_at]) VALUES (4, 10, CAST(N'2026-07-24T20:43:05.367' AS DateTime))
INSERT [dbo].[WishList] ([wishlistID], [customerID], [created_at]) VALUES (5, 11, CAST(N'2026-08-11T03:52:40.020' AS DateTime))
SET IDENTITY_INSERT [dbo].[WishList] OFF
GO
SET IDENTITY_INSERT [dbo].[WishList_Item] ON 

INSERT [dbo].[WishList_Item] ([wishlistItemID], [wishlistID], [bookID], [added_at]) VALUES (2, 5, 3, CAST(N'2026-08-11T15:28:44.803' AS DateTime))
SET IDENTITY_INSERT [dbo].[WishList_Item] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Account__AB6E61640EE5A8F3]    Script Date: 8/12/2026 3:34:43 PM ******/
ALTER TABLE [dbo].[Account] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Cart__B611CB9C0AA0BF3D]    Script Date: 8/12/2026 3:34:43 PM ******/
ALTER TABLE [dbo].[Cart] ADD UNIQUE NONCLUSTERED 
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Customer__AB6E6164C274028E]    Script Date: 8/12/2026 3:34:43 PM ******/
ALTER TABLE [dbo].[Customer] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_Customer_Voucher]    Script Date: 8/12/2026 3:34:43 PM ******/
ALTER TABLE [dbo].[CustomerVoucher] ADD  CONSTRAINT [UQ_Customer_Voucher] UNIQUE NONCLUSTERED 
(
	[customerID] ASC,
	[voucherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Voucher__357D4CF9A3DA9B2A]    Script Date: 8/12/2026 3:34:43 PM ******/
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
ALTER TABLE [dbo].[Book]  WITH CHECK ADD FOREIGN KEY([genreID])
REFERENCES [dbo].[Genre] ([genreID])
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
ALTER TABLE [dbo].[BookAuthor]  WITH CHECK ADD FOREIGN KEY([authorID])
REFERENCES [dbo].[Author] ([authorID])
GO
ALTER TABLE [dbo].[BookAuthor]  WITH CHECK ADD FOREIGN KEY([bookID])
REFERENCES [dbo].[Book] ([bookID])
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
ALTER TABLE [dbo].[Order]  WITH CHECK ADD CHECK  (([payment_status]='unpaid' OR [payment_status]='paid' OR [payment_status]='refunded' OR [payment_status]='pending_refund'))
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD CHECK  (([status]='cancelled' OR [status]='completed' OR [status]='shipping' OR [status]='confirmed' OR [status]='pending'))
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [CK_Order_PaymentStatus] CHECK  (([payment_status]='pending_refund' OR [payment_status]='refunded' OR [payment_status]='paid' OR [payment_status]='unpaid'))
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [CK_Order_PaymentStatus]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD CHECK  (([rating]>=(1) AND [rating]<=(5)))
GO
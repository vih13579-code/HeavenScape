# HeavenScape

Online Bookstore System

HeavenScape is a full-stack Java web application developed for an online bookstore. Customers can browse books, search for products, place orders, make purchases, and submit reviews. Store staff can manage the system through an administration dashboard.

Academic project — FPT University - SWP391.3w - Group2.

---

## Tech Stack

### Frontend

- HTML5, CSS3, JavaScript
- Tailwind CSS
- JSP with JSTL

### Backend

- Java
- Jakarta EE 10 using Servlets
- MVC2 architecture

### Database

- Microsoft SQL Server
- Database connection through `mssql-jdbc`

### Integrations

- Cloudinary — image uploading
- VNPAY — online payment
- Google OAuth — social authentication
- Jakarta Mail — email and OTP delivery

### Build and Runtime

- Maven
- Apache Tomcat 10.1
- NetBeans IDE

---

## Getting Started

### Prerequisites

| Tool          | Version                          |
|---------------|----------------------------------|
| JDK           | 11+                              |
| Apache Tomcat | 10.1                             |
| SQL Server    | Any recent version               |
| IDE           | VScode or NetBeans (recommended) |

### Setup

```bash
# Clone the repository
git clone: https://github.com/vih13579-code/HeavenScape.git

# Open the project using your IDE
# Configure Apache Tomcat 10.1
# Create the SQL Server database and configure the database connection
#   (see src/main/java/utils/DBContext.java)
# Run web/database/20260822_order_cancellation_voucher.sql after the base dump
#   to add cancellation-source and order-voucher tracking columns
# Run database/20260823_genre_many_to_many.sql
#   to migrate book classification to the Genre many-to-many schema
# Configure Google OAuth and VNPAY credentials in web.xml / VNPayConfig
# Build and run the application

HeavenScape/
├── src/main/java/
│   ├── controller/       Servlet controllers
│   ├── dao/              Data access objects
│   ├── model/            Entity/model classes
│   ├── filter/           Servlet filters
│   └── utils/            Shared utilities (database, email, uploads, configuration)
├── src/main/webapp/
│   ├── views/            JSP pages
│   ├── assets/           CSS, JavaScript, and images
│   └── WEB-INF/          web.xml and beans.xml
├── pom.xml
└── README.md

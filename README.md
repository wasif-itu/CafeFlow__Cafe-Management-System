# ☕ CafeFlow — Café Management System

> A full-stack Java web application built as part of my Web Technologies coursework at Information Technology University (ITU).
> **Student:** Muhammad Wasif | **ID:** BSCS23020

---

## What is CafeFlow?

CafeFlow is a web-based café management system I built to simulate the complete digital experience of a modern café. The idea was to go beyond a static website and build something where customers can actually browse a live menu, manage a shopping cart, and place orders — while the café admin has a full dashboard to manage products and track orders in real time.

The project covers the full request-response cycle: from the browser hitting a JSP page, through Java Servlets, down to a MySQL database — and back.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Java EE — Servlets (`javax.servlet`) |
| View Layer | JavaServer Pages (JSP), JSTL |
| Frontend | HTML5, CSS3, Vanilla JavaScript |
| Database | MySQL 8.x |
| JDBC Driver | mysql-connector-j 8.3.0 |
| Password Hashing | SHA-256 (`java.security.MessageDigest`) |
| Build Tool | Apache Ant |
| Server | Apache Tomcat (Servlet 3.1 / JSP 2.3) |

---

## Project Structure

```
bscs23020_project/
├── build.xml
├── src/
│   └── java/
│       ├── api/
│       │   └── OrderDetailsServlet.java       # REST: GET /api/orders/{id}
│       ├── bean/
│       │   └── Order.java                     # JavaBean for order data
│       ├── dao/
│       │   ├── CafeTableDAO.java              # Queries cafe_tables
│       │   └── ReservationDAO.java            # Insert / query reservations
│       ├── listener/
│       │   └── AppContextListener.java        # Opens DB connection on startup
│       ├── model/
│       │   └── User.java                      # User model (id, username, email, role)
│       ├── Servlet/
│       │   ├── CategoryServlet.java           # Returns categories as JSON
│       │   ├── LoginServlet.java              # Login, session, cookies
│       │   ├── LogoutServlet.java             # Invalidates session
│       │   ├── MenuServlet.java               # Returns products as JSON
│       │   ├── PlaceOrderServlet.java         # Inserts order into DB
│       │   ├── ProductServlet.java            # Admin product CRUD
│       │   ├── RegisterServlet.java           # New user registration
│       │   └── UpdateOrderStatusServlet.java  # Admin order status update
│       └── Util/
│           └── DBUtil.java                    # JDBC connection helper
└── web/
    ├── lib/
    │   ├── jbcrypt-0.4.jar
    │   └── mysql-connector-j-8.3.0.jar
    ├── WEB-INF/
    │   └── web.xml                            # Servlet mappings
    └── src/
        ├── css/
        │   ├── index.css                      # Login/signup styles
        │   ├── menu_css.css                   # Menu & card styles
        │   └── style.css                      # Global styles
        ├── js/
        │   ├── loginscript.js                 # Sign-in/sign-up panel toggle
        │   ├── menu_script.js                 # Cart logic (add, quantity)
        │   └── script.js                      # Sidebar nav, password toggle
        ├── jsp/
        │   ├── header.jsp
        │   └── footer.jsp
        └── veiws/
            ├── landing.jsp                    # Home page
            ├── login_new.jsp                  # Login + Register (single page)
            ├── menu_new.jsp                   # Dynamic menu browser
            ├── cart_new.jsp                   # Shopping cart
            ├── checkout_new.jsp               # Checkout form
            └── admin_new.jsp                  # Admin dashboard
```

---

## Features

### Customer Side

**Landing Page**
The home page greets logged-in users by name (pulled from the HTTP session) and shows a login prompt for guests. It has navigation to the menu, cart, and table booking.

**Menu Page**
This is the most dynamic part of the customer experience. On page load, the menu page fires two `fetch()` calls — one to `/api/menu` to get all products from the database, and one to `/api/categories` for the category list. Products are then grouped and rendered under their respective category headers. Each product card shows the name, description, price, and image. I built quantity controls (+ / −) per item, and clicking "Add to Cart" stores the item in `localStorage` as a JSON array so the cart persists across navigation. A floating cart button is fixed to the bottom-right corner for quick access.

**Cart Page**
Reads the cart from `localStorage` and renders everything in a table. Quantity can be adjusted inline and the subtotal recalculates live. Individual items can be removed. The total is shown at the bottom with a button to proceed to checkout.

**Checkout Page**
Collects customer name, contact, delivery address, and payment method (Cash or Card). The cart contents are passed as a hidden field and submitted to `PlaceOrderServlet`. If the user isn't logged in, they get redirected to the login page. On a successful order insert, a confirmation message appears on the same page using `RequestDispatcher.forward()`.

**Login & Registration**
I implemented both on a single page with a CSS flip animation between the Sign In and Sign Up panels. Registration hashes the password with SHA-256 before storing it and assigns the `user` role. Login hashes the submitted password and compares it to the stored hash. After a successful login, the user ID, username, and role are saved to the session. Admins are redirected to the admin dashboard; regular users go to the landing page. There's also a "Remember Me" checkbox that sets 7-day browser cookies. Error messages (wrong credentials, missing fields) are forwarded back and displayed inline.

**Table Reservation (Backend)**
I built the DAO layer for reservations fully: `CafeTableDAO` fetches all tables with their capacity and availability, and `ReservationDAO` handles inserting new reservations and querying them by date. The front-end reservation page (`reservation.jsp`) is a work in progress and not included in this submission.

---

### Admin Dashboard

Only accessible to users with the `admin` role. The dashboard has a sidebar with two tabs.

**Manage Orders**
Loads all orders from the database on page load. Each order is displayed in a table with all its details (ID, customer name, contact, address, payment method, items, status, date). Each row has a status dropdown pre-selected to the current status with options: Pending, In Progress, Delivered, Cancelled. Submitting the dropdown posts to `UpdateOrderStatusServlet`, which runs the update query and redirects back to the dashboard.

**Update Menu**
Admins can add new products by filling in the name, price, description, category (Beverage / Food / Bakery / Other / Uncategorized), and uploading an image (up to 5 MB). The image is saved server-side under `/images/` with a timestamp prefix to prevent filename collisions, and the path is stored in the database. Existing products appear in a table with Edit and Delete buttons. On edit, the form pre-fills with the product's current data; if no new image is uploaded, the existing image path is kept.

---

## API Endpoints

| Method | URL | Servlet | Returns |
|---|---|---|---|
| GET | `/api/menu` | `MenuServlet` | JSON array of all products |
| GET | `/api/categories` | `CategoryServlet` | JSON array of category names |
| GET | `/api/orders/{id}` | `OrderDetailsServlet` | JSON object of a single order |

---

## Architecture

```
Browser (JSP / HTML / JS)
         |
         v
  Java Servlets  <---- web.xml mappings
         |
         v
  Model / Bean / DAO
         |
         v
      MySQL (cafe_ms)
```

`AppContextListener` runs at application startup and opens a database connection, storing it in `ServletContext` so servlets can access it without opening a new connection per request.

---

## Database Schema

The app connects to a MySQL database named `cafe_ms`.

```sql
CREATE TABLE users (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50)  NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  email    VARCHAR(100),
  role     VARCHAR(20)  DEFAULT 'user'
);

CREATE TABLE products (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100)  NOT NULL,
  price       DECIMAL(10,2) NOT NULL,
  description TEXT,
  image_path  VARCHAR(255),
  category    VARCHAR(50)
);

CREATE TABLE orders (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  customer_name  VARCHAR(100),
  contact        VARCHAR(50),
  address        TEXT,
  payment_method VARCHAR(50),
  items          TEXT,
  status         VARCHAR(50)  DEFAULT 'In Progress',
  order_date     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cafe_tables (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  capacity     INT,
  is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE reservations (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  user_id          INT,
  table_id         INT,
  reservation_time DATETIME
);
```

---

## Setup & Running Locally

**Prerequisites:** JDK 8+, Apache Tomcat 9.x, MySQL 8.x, Apache Ant

1. Clone or unzip the project.

2. Set up the database:
```sql
CREATE DATABASE cafe_ms;
USE cafe_ms;
-- run the CREATE TABLE statements above
```

3. Update your credentials in `src/java/Util/DBUtil.java`:
```java
private static final String DB_URL      = "jdbc:mysql://localhost:3306/cafe_ms";
private static final String DB_USER     = "your_username";
private static final String DB_PASSWORD = "your_password";
```

4. Build:
```
ant -f build.xml
```

5. Deploy to Tomcat's `webapps/` and start the server. The app opens at:
```
http://localhost:8080/<context-root>/
```

6. To test the admin dashboard, insert an admin user manually:
```sql
INSERT INTO users (username, password, email, role)
VALUES ('admin', '<sha256-of-your-password>', 'admin@cafe.com', 'admin');
```

---

## Known Issues & Limitations

These are things I'm aware of and would address in a production version:

- **Password in cookie:** The "Remember Me" feature stores the plaintext password in a browser cookie. This is noted in the code and would be replaced with a secure token in a real system.
- **Single shared DB connection:** `AppContextListener` opens one `Connection` for the app's lifetime. This is not thread-safe. A proper connection pool (HikariCP or DBCP) would replace this.
- **Cart is client-side only:** The cart lives in `localStorage` and is not persisted to the database. Clearing browser storage loses the cart.
- **`reservation.jsp` not included:** The DAO and database schema for table reservations are complete, but the front-end page is still a work in progress.
- **`veiws` typo:** The views directory is consistently named `veiws` across the whole project. It doesn't break anything since all references are consistent, but it should be corrected.
- **`ProductServlet` package issue:** `ProductServlet.java` references a `util.DatabaseConnector` class that isn't in the source tree (the rest of the project uses `Util.DBUtil`). This needs to be reconciled before the servlet compiles.

---

## Author

**Muhammad Wasif**
BSCS23020 — Information Technology University (ITU), Lahore

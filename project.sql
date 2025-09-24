--
-- A complete relational database schema for a Library Management System.
-- This file includes tables for books, authors, members, and borrowings,
-- demonstrating various types of relationships and constraints.
--

-- --------------------------------------------------------
-- Database Creation
-- --------------------------------------------------------
-- Create the main database for the library system.
CREATE DATABASE IF NOT EXISTS library_management;

-- Use the newly created database for all subsequent operations.
USE library_management;

-- --------------------------------------------------------
-- Table Structure for 'Publishers'
-- Demonstrates a primary key and a unique constraint.
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(255) NOT NULL UNIQUE,
    location VARCHAR(255)
);

-- --------------------------------------------------------
-- Table Structure for 'Authors'
-- Demonstrates a simple table with a primary key.
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL,
    birth_year INT
);

-- --------------------------------------------------------
-- Table Structure for 'Books'
-- This table has a FOREIGN KEY to 'Publishers', creating a one-to-many relationship
-- (one publisher can have many books).
-- It also includes a unique constraint on the ISBN.
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) NOT NULL UNIQUE,
    publication_year INT,
    publisher_id INT,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id) ON DELETE SET NULL
);

-- --------------------------------------------------------
-- Table Structure for 'Book_Author'
-- This is a linking table that resolves the many-to-many relationship
-- between 'Books' and 'Authors' (one book can have multiple authors,
-- and one author can write multiple books).
-- The combination of book_id and author_id forms a composite primary key.
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS Book_Author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- Table Structure for 'Members'
-- This table stores information about library members.
-- It uses a unique constraint on email and phone number.
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) UNIQUE,
    join_date DATE DEFAULT (CURRENT_DATE)
);

-- --------------------------------------------------------
-- Table Structure for 'Borrowings'
-- This table tracks which member has borrowed which book.
-- It has two FOREIGN KEY constraints, one to 'Books' and one to 'Members',
-- demonstrating a one-to-many relationship from both sides
-- (one member can borrow many books, and one book can be borrowed many times).
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS Borrowings (
    borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    borrow_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- Sample Data Insertion
-- --------------------------------------------------------

-- Inserting sample data into 'Publishers'
INSERT INTO Publishers (publisher_name, location) VALUES
('Penguin Random House', 'New York'),
('HarperCollins', 'New York'),
('Simon & Schuster', 'New York'),
('Hachette Book Group', 'Boston'),
('Macmillan Publishers', 'London');

-- Inserting sample data into 'Authors'
INSERT INTO Authors (author_name, birth_year) VALUES
('Jane Austen', 1775),
('George Orwell', 1903),
('J.R.R. Tolkien', 1892),
('Agatha Christie', 1890),
('Stephen King', 1947);

-- Inserting sample data into 'Books'
INSERT INTO Books (title, isbn, publication_year, publisher_id) VALUES
('Pride and Prejudice', '9780141439518', 1813, 1),
('1984', '9780451524935', 1949, 1),
('The Hobbit', '9780547928227', 1937, 5),
('Murder on the Orient Express', '9780062073491', 1934, 2),
('It', '9781501175464', 1986, 3);

-- Inserting sample data into 'Book_Author'
-- This links books to their authors.
INSERT INTO Book_Author (book_id, author_id) VALUES
(1, 1), -- Pride and Prejudice by Jane Austen
(2, 2), -- 1984 by George Orwell
(3, 3), -- The Hobbit by J.R.R. Tolkien
(4, 4), -- Murder on the Orient Express by Agatha Christie
(5, 5); -- It by Stephen King

-- Inserting sample data into 'Members'
INSERT INTO Members (first_name, last_name, email, phone) VALUES
('Alice', 'Johnson', 'alice.j@example.com', '555-123-4567'),
('Bob', 'Smith', 'bob.s@example.com', '555-987-6543'),
('Charlie', 'Brown', 'charlie.b@example.com', '555-111-2222');

-- Inserting sample data into 'Borrowings'
-- This shows which members have borrowed which books.
INSERT INTO Borrowings (book_id, member_id, due_date) VALUES
(1, 1, '2025-10-15'),
(2, 2, '2025-10-20'),
(4, 3, '2025-10-25');

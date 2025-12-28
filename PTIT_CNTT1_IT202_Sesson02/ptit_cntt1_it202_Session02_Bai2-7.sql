CREATE DATABASE vpbank_fee_collection;
USE vpbank_fee_collection;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    cccd VARCHAR(12) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_account_balance
        CHECK (balance >= 0),

    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE partners (
    partner_id INT AUTO_INCREMENT PRIMARY KEY,
    partner_name VARCHAR(100) NOT NULL UNIQUE,
    bank_account VARCHAR(30) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tuition_bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    partner_id INT NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    bill_code VARCHAR(50) NOT NULL UNIQUE,
    amount DECIMAL(15,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'UNPAID',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_bill_amount
        CHECK (amount > 0),

    CONSTRAINT fk_bill_partner
        FOREIGN KEY (partner_id)
        REFERENCES partners(partner_id)
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    bill_id INT NOT NULL UNIQUE,
    amount DECIMAL(15,2) NOT NULL,
    transaction_status VARCHAR(20) DEFAULT 'PENDING',
    transaction_time DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_transaction_amount
        CHECK (amount > 0),

    CONSTRAINT fk_transaction_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id),

    CONSTRAINT fk_transaction_bill
        FOREIGN KEY (bill_id)
        REFERENCES tuition_bills(bill_id)
);

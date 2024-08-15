CREATE DATABASE IF NOT EXISTS linkster;

-- this is a demo site, so the password ("linkster", hashed) is hard-coded here in the setup script
CREATE USER IF NOT EXISTS 'linkster'@'%' IDENTIFIED WITH mysql_native_password BY '$2a$10$uNeBxcrRH1EzOrYyWE79vOLltnRJl/OYMQM4wBPyEj9XjQcE7CKN2';
GRANT ALL PRIVILEGES ON linkster.* TO 'linkster'@'%';

USE linkster;

-- TABLE USER
-- all pasword wil be encrypted using SHA2
CREATE TABLE users (
  id INT(11) NOT NULL AUTO_INCREMENT,
  fullname VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  password VARCHAR(60) NOT NULL,
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) AUTO_INCREMENT=2;

-- drop table users

DESCRIBE users;

INSERT INTO users (id, email, password, fullname) 
  VALUES (1, 'linksterinc@gmail.com', 'linkster', 'Marcia Linkster');

SELECT * FROM users;

-- LINKS TABLE
CREATE TABLE links (
  id INT(11) NOT NULL,
  title VARCHAR(150) NOT NULL,
  url VARCHAR(255) NOT NULL,
  description TEXT,
  user_id INT(11),
  created_at timestamp NOT NULL DEFAULT current_timestamp,
  CONSTRAINT fk_user FOREIGN KEY(user_id) REFERENCES users(id)
);

ALTER TABLE links
  ADD PRIMARY KEY (id);

ALTER TABLE links
  MODIFY id INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT = 2;

INSERT INTO links (
    title,
    url,
    description,
    user_id
) VALUES (
    "Stanke.dev",
    "https://stanke.dev",
    "The best. Site. Ever!",
    1
);

DESCRIBE links;
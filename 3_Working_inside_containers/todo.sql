DROP DATABASE IF EXISTS todo;
CREATE DATABASE IF NOT EXISTS todo;

USE todo;

DROP TABLE IF EXISTS list, list_items;

CREATE TABLE list (
  id            INT           NOT NULL    AUTO_INCREMENT,
  list_name     VARCHAR(20)   NOT NULL,
  description   VARCHAR(100)  NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE list_items (
  id            INT               NOT NULL    AUTO_INCREMENT,
  list_id       INT               NOT NULL,
  task          VARCHAR(200)      NOT NULL,
  complete      ENUM ('Y','N')    NOT NULL    DEFAULT 'N',
  FOREIGN KEY (list_id) REFERENCES list (id) ON DELETE CASCADE,
  PRIMARY KEY (id)
);


-- Creating sample data to populate our todo backend
INSERT INTO list VALUES(NULL, 'Shopping', 'A list of groceries to get when we next go shopping');
INSERT INTO list VALUES(NULL, 'Work', 'A list of all the things I need to do at work this week');
INSERT INTO list VALUES(NULL, 'Movies', 'A list of all the movies I must watch this year!');
INSERT INTO list VALUES(NULL, 'Restaurants', 'A list of the restaurants that have been recommended for me to try');


INSERT INTO list_items (list_id, task) VALUES(1, 'Eggs');
INSERT INTO list_items (list_id, task) VALUES(1, 'Milk');
INSERT INTO list_items (list_id, task) VALUES(1, 'Ham');
INSERT INTO list_items (list_id, task) VALUES(1, 'Cheese');
INSERT INTO list_items (list_id, task) VALUES(1, 'Coffee');
INSERT INTO list_items (list_id, task) VALUES(1, 'Bread');

INSERT INTO list_items (list_id, task) VALUES(2, 'Reply to my managers E-mail');
INSERT INTO list_items (list_id, task) VALUES(2, 'Submit code for this workshop');
INSERT INTO list_items (list_id, task) VALUES(2, 'Learn how to run Docker containers');
INSERT INTO list_items (list_id, task) VALUES(2, 'Install security patches');

INSERT INTO list_items (list_id, task) VALUES(3, 'Captain America: Civil War');
INSERT INTO list_items (list_id, task) VALUES(3, 'Black Panther');
INSERT INTO list_items (list_id, task) VALUES(3, 'Avengers: Infinity War');
INSERT INTO list_items (list_id, task) VALUES(3, 'Deadpool 2');

INSERT INTO list_items (list_id, task) VALUES(4, 'Five Guys');
INSERT INTO list_items (list_id, task) VALUES(4, 'Wagamama');
INSERT INTO list_items (list_id, task) VALUES(4, 'The Breakfast Club');
INSERT INTO list_items (list_id, task) VALUES(4, 'Wahaca');
INSERT INTO list_items (list_id, task) VALUES(4, 'Bad Egg');

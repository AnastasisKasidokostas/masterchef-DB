-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for masterchef
DROP DATABASE IF EXISTS `masterchef`;
CREATE DATABASE IF NOT EXISTS `masterchef` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `masterchef`;

-- Dumping structure for table masterchef.cook
DROP TABLE IF EXISTS `cook`;
CREATE TABLE IF NOT EXISTS `cook` (
  `cook_id` int(11) NOT NULL AUTO_INCREMENT,
  `cook_name` varchar(100) NOT NULL,
  `cook_surname` varchar(100) NOT NULL,
  `gender` enum('male','female','other') DEFAULT 'other',
  `phone_number` varchar(20) DEFAULT NULL,
  `date_of_birth` date NOT NULL,
  `age` int(3) NOT NULL,
  `classification` enum('3rd cook','2nd cook','1st cook','chefs assistant','chef') NOT NULL,
  `username` varchar(16) NOT NULL,
  `password` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`cook_id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.episode
DROP TABLE IF EXISTS `episode`;
CREATE TABLE IF NOT EXISTS `episode` (
  `episode_id` int(11) NOT NULL AUTO_INCREMENT,
  `episode_number` int(11) unsigned NOT NULL,
  `season` int(11) unsigned NOT NULL,
  `episode_date` date NOT NULL,
  PRIMARY KEY (`episode_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.episode_cuisine_cook_recipe
DROP TABLE IF EXISTS `episode_cuisine_cook_recipe`;
CREATE TABLE IF NOT EXISTS `episode_cuisine_cook_recipe` (
  `episode_id` int(11) NOT NULL,
  `national_cuisine_id` int(11) NOT NULL,
  `cook_id` int(11) NOT NULL,
  `recipe_id` int(11) NOT NULL,
  PRIMARY KEY (`episode_id`,`national_cuisine_id`),
  KEY `national_cuisine_id` (`national_cuisine_id`),
  KEY `cook_id` (`cook_id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `episode_cuisine_cook_recipe_ibfk_1` FOREIGN KEY (`episode_id`) REFERENCES `episode` (`episode_id`),
  CONSTRAINT `episode_cuisine_cook_recipe_ibfk_2` FOREIGN KEY (`national_cuisine_id`) REFERENCES `national_cuisine` (`national_cuisine_id`),
  CONSTRAINT `episode_cuisine_cook_recipe_ibfk_3` FOREIGN KEY (`cook_id`) REFERENCES `cook` (`cook_id`),
  CONSTRAINT `episode_cuisine_cook_recipe_ibfk_4` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`recipe_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.equipment
DROP TABLE IF EXISTS `equipment`;
CREATE TABLE IF NOT EXISTS `equipment` (
  `recipe_id` int(11) NOT NULL,
  `equipment_id` int(11) NOT NULL AUTO_INCREMENT,
  `equipment_name` varchar(100) NOT NULL,
  `equipment_user_instruction` text DEFAULT NULL,
  PRIMARY KEY (`equipment_id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `equipment_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`recipe_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.food_groups
DROP TABLE IF EXISTS `food_groups`;
CREATE TABLE IF NOT EXISTS `food_groups` (
  `food_group_id` int(11) NOT NULL AUTO_INCREMENT,
  `food_group_name` varchar(100) NOT NULL,
  `food_group_description` text DEFAULT NULL,
  PRIMARY KEY (`food_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.ingredient
DROP TABLE IF EXISTS `ingredient`;
CREATE TABLE IF NOT EXISTS `ingredient` (
  `ingredient_id` int(11) NOT NULL AUTO_INCREMENT,
  `ingredient_name` varchar(100) NOT NULL,
  `food_group_id` int(11) DEFAULT NULL,
  `ingredient_protein` decimal(5,2) unsigned DEFAULT 0.00,
  `ingredient_carbs` decimal(5,2) unsigned DEFAULT 0.00,
  `ingredient_fat` decimal(5,2) unsigned DEFAULT 0.00,
  `ingredient_calories` decimal(6,2) unsigned GENERATED ALWAYS AS (4 * `ingredient_protein` + 4 * `ingredient_carbs` + 9 * `ingredient_fat`) STORED,
  PRIMARY KEY (`ingredient_id`),
  KEY `fk_food_group_id` (`food_group_id`),
  CONSTRAINT `fk_food_group_id` FOREIGN KEY (`food_group_id`) REFERENCES `food_groups` (`food_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.judge
DROP TABLE IF EXISTS `judge`;
CREATE TABLE IF NOT EXISTS `judge` (
  `judge_id` int(11) NOT NULL,
  `episode_id` int(11) NOT NULL,
  `cook_id` int(11) NOT NULL,
  `score` int(11) DEFAULT NULL,
  PRIMARY KEY (`judge_id`,`episode_id`,`cook_id`),
  KEY `episode_id` (`episode_id`),
  KEY `cook_id` (`cook_id`),
  CONSTRAINT `judge_ibfk_1` FOREIGN KEY (`judge_id`) REFERENCES `cook` (`cook_id`),
  CONSTRAINT `judge_ibfk_2` FOREIGN KEY (`episode_id`) REFERENCES `episode` (`episode_id`),
  CONSTRAINT `judge_ibfk_3` FOREIGN KEY (`cook_id`) REFERENCES `cook` (`cook_id`),
  CONSTRAINT `chk_judge_cook_diff` CHECK (`judge_id` <> `cook_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.meal
DROP TABLE IF EXISTS `meal`;
CREATE TABLE IF NOT EXISTS `meal` (
  `meal_id` int(11) NOT NULL AUTO_INCREMENT,
  `meal_name` varchar(50) NOT NULL,
  PRIMARY KEY (`meal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.national_cuisine
DROP TABLE IF EXISTS `national_cuisine`;
CREATE TABLE IF NOT EXISTS `national_cuisine` (
  `national_cuisine_id` int(11) NOT NULL AUTO_INCREMENT,
  `national_cuisine_name` varchar(100) NOT NULL,
  PRIMARY KEY (`national_cuisine_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.national_cuisine_cooks
DROP TABLE IF EXISTS `national_cuisine_cooks`;
CREATE TABLE IF NOT EXISTS `national_cuisine_cooks` (
  `national_cuisine_id` int(11) NOT NULL,
  `cook_id` int(11) NOT NULL,
  PRIMARY KEY (`national_cuisine_id`,`cook_id`),
  KEY `national_cuisine_id` (`national_cuisine_id`) USING BTREE,
  KEY `cook_id` (`cook_id`) USING BTREE,
  CONSTRAINT `national_cuisine_cooks_ibfk_1` FOREIGN KEY (`national_cuisine_id`) REFERENCES `national_cuisine` (`national_cuisine_id`),
  CONSTRAINT `national_cuisine_cooks_ibfk_2` FOREIGN KEY (`cook_id`) REFERENCES `cook` (`cook_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for procedure masterchef.RandomAssignEpisodeCuisineCookRecipe
DROP PROCEDURE IF EXISTS `RandomAssignEpisodeCuisineCookRecipe`;
DELIMITER //
CREATE PROCEDURE `RandomAssignEpisodeCuisineCookRecipe`()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_episode_id INT;
    DECLARE v_national_cuisine_id INT;
    DECLARE v_cook_id INT;
    DECLARE v_recipe_id INT;
    DECLARE i INT;
    DECLARE cur CURSOR FOR SELECT episode_id FROM episode;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_episode_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Assign 10 cuisine-cook-recipe pairs to the current episode
        SET i = 0;
        WHILE i < 10 DO
            -- Select a random national cuisine
            SET v_national_cuisine_id = (
                SELECT nc.national_cuisine_id
                FROM national_cuisine nc
                LEFT JOIN episode_cuisine_cook_recipe ec ON nc.national_cuisine_id = ec.national_cuisine_id AND ec.episode_id = v_episode_id
                WHERE ec.national_cuisine_id IS NULL
                ORDER BY RAND()
                LIMIT 1
            );

            -- Select a random cook
            SET v_cook_id = (
                SELECT ncc.cook_id
                FROM national_cuisine_cooks ncc
                LEFT JOIN episode_cuisine_cook_recipe ec ON ncc.cook_id = ec.cook_id AND ec.episode_id = v_episode_id
                WHERE ncc.national_cuisine_id = v_national_cuisine_id AND ec.cook_id IS NULL
                ORDER BY RAND()
                LIMIT 1
            );

            -- Select a random recipe
            SET v_recipe_id = (
                SELECT r.recipe_id
                FROM recipe r
                LEFT JOIN episode_cuisine_cook_recipe ec ON r.recipe_id = ec.recipe_id AND ec.episode_id = v_episode_id
                WHERE r.national_cuisine_id = v_national_cuisine_id AND ec.recipe_id IS NULL
                ORDER BY RAND()
                LIMIT 1
            );

            -- Check if valid IDs were obtained
            IF v_national_cuisine_id IS NOT NULL AND v_cook_id IS NOT NULL AND v_recipe_id IS NOT NULL THEN
                -- Insert the random assignment into the episode_cuisine_cook_recipe table
                INSERT INTO episode_cuisine_cook_recipe (episode_id, national_cuisine_id, cook_id, recipe_id) VALUES (v_episode_id, v_national_cuisine_id, v_cook_id, v_recipe_id);
                SET i = i + 1;
            END IF;
        END WHILE;
    END LOOP;
    
    CLOSE cur;
END//
DELIMITER ;

-- Dumping structure for procedure masterchef.RandomAssignJudges
DROP PROCEDURE IF EXISTS `RandomAssignJudges`;
DELIMITER //
CREATE PROCEDURE `RandomAssignJudges`()
BEGIN
    DECLARE done_episode INT DEFAULT 0;
    DECLARE v_episode_id INT;
    DECLARE v_cook_id INT;
    DECLARE v_judge_id1 INT;
    DECLARE v_judge_id2 INT;
    DECLARE v_judge_id3 INT;
    DECLARE v_score INT;

    DECLARE cur_episode CURSOR FOR SELECT DISTINCT episode_id FROM episode_cuisine_cook_recipe;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_episode = 1;

    OPEN cur_episode;

    episode_loop: LOOP
        FETCH cur_episode INTO v_episode_id;
        IF done_episode THEN
            LEAVE episode_loop;
        END IF;

        -- Select 3 random judges for the current episode
        SET v_judge_id1 = (SELECT cook_id FROM cook ORDER BY RAND() LIMIT 1);
        SET v_judge_id2 = (SELECT cook_id FROM cook WHERE cook_id != v_judge_id1 ORDER BY RAND() LIMIT 1);
        SET v_judge_id3 = (SELECT cook_id FROM cook WHERE cook_id NOT IN (v_judge_id1, v_judge_id2) ORDER BY RAND() LIMIT 1);

        BEGIN
            DECLARE done_cook INT DEFAULT 0;
            DECLARE cur_cook CURSOR FOR SELECT cook_id FROM episode_cuisine_cook_recipe WHERE episode_id = v_episode_id;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_cook = 1;

            OPEN cur_cook;

            cook_loop: LOOP
                FETCH cur_cook INTO v_cook_id;
                IF done_cook THEN
                    LEAVE cook_loop;
                END IF;

                -- Generate random scores and assign to the judges
                SET v_score = FLOOR(1 + RAND() * 5);
                INSERT INTO judge (judge_id, episode_id, cook_id, score) VALUES (v_judge_id1, v_episode_id, v_cook_id, v_score);

                SET v_score = FLOOR(1 + RAND() * 5);
                INSERT INTO judge (judge_id, episode_id, cook_id, score) VALUES (v_judge_id2, v_episode_id, v_cook_id, v_score);

                SET v_score = FLOOR(1 + RAND() * 5);
                INSERT INTO judge (judge_id, episode_id, cook_id, score) VALUES (v_judge_id3, v_episode_id, v_cook_id, v_score);
            END LOOP;

            CLOSE cur_cook;
        END;
    END LOOP;

    CLOSE cur_episode;
END//
DELIMITER ;

-- Dumping structure for table masterchef.recipe
DROP TABLE IF EXISTS `recipe`;
CREATE TABLE IF NOT EXISTS `recipe` (
  `recipe_id` int(11) NOT NULL AUTO_INCREMENT,
  `recipe_name` varchar(100) NOT NULL,
  `recipe_description` text DEFAULT NULL,
  `category` enum('Cooking','Pastry') NOT NULL DEFAULT 'Cooking',
  `difficulty` int(11) NOT NULL CHECK (`difficulty` between 1 and 5),
  `preparation_time` int(10) unsigned NOT NULL DEFAULT 0,
  `cooking_time` int(10) unsigned NOT NULL DEFAULT 0,
  `total_time` int(11) GENERATED ALWAYS AS (`preparation_time` + `cooking_time`) STORED,
  `portions` int(11) unsigned NOT NULL DEFAULT 1,
  `basic_ingredient_id` int(11) DEFAULT NULL,
  `national_cuisine_id` int(11) DEFAULT NULL,
  `total_protein` decimal(6,2) unsigned DEFAULT 0.00,
  `total_carbs` decimal(6,2) unsigned DEFAULT 0.00,
  `total_fat` decimal(6,2) unsigned DEFAULT 0.00,
  `total_calories` decimal(10,2) unsigned GENERATED ALWAYS AS (4 * `total_protein` + 4 * `total_carbs` + 9 * `total_fat`) STORED,
  PRIMARY KEY (`recipe_id`),
  UNIQUE KEY `recipe_name` (`recipe_name`),
  KEY `fk_basic_ingredient_id` (`basic_ingredient_id`),
  KEY `fk_national_cuisine_id` (`national_cuisine_id`),
  CONSTRAINT `fk_basic_ingredient_id` FOREIGN KEY (`basic_ingredient_id`) REFERENCES `recipe_ingredient` (`ingredient_id`),
  CONSTRAINT `fk_national_cuisine_id` FOREIGN KEY (`national_cuisine_id`) REFERENCES `national_cuisine` (`national_cuisine_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.recipe_ingredient
DROP TABLE IF EXISTS `recipe_ingredient`;
CREATE TABLE IF NOT EXISTS `recipe_ingredient` (
  `recipe_id` int(11) NOT NULL,
  `ingredient_id` int(11) NOT NULL,
  `quantity` decimal(10,2) unsigned DEFAULT 100.00,
  `unit` varchar(100) NOT NULL DEFAULT 'gr',
  `specify_quantity` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`recipe_id`,`ingredient_id`),
  KEY `fk_ingredient_id` (`ingredient_id`),
  CONSTRAINT `fk_ingredient_id` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`),
  CONSTRAINT `fk_recipe_id` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`recipe_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.recipe_meal
DROP TABLE IF EXISTS `recipe_meal`;
CREATE TABLE IF NOT EXISTS `recipe_meal` (
  `recipe_id` int(11) NOT NULL,
  `meal_id` int(11) NOT NULL,
  PRIMARY KEY (`recipe_id`,`meal_id`),
  KEY `meal_id` (`meal_id`),
  CONSTRAINT `recipe_meal_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`recipe_id`),
  CONSTRAINT `recipe_meal_ibfk_2` FOREIGN KEY (`meal_id`) REFERENCES `meal` (`meal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.recipe_tag
DROP TABLE IF EXISTS `recipe_tag`;
CREATE TABLE IF NOT EXISTS `recipe_tag` (
  `recipe_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`recipe_id`,`tag_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `recipe_tag_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`recipe_id`),
  CONSTRAINT `recipe_tag_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.recipe_thematic_section
DROP TABLE IF EXISTS `recipe_thematic_section`;
CREATE TABLE IF NOT EXISTS `recipe_thematic_section` (
  `recipe_id` int(11) NOT NULL,
  `thematic_section_id` int(11) NOT NULL,
  PRIMARY KEY (`recipe_id`,`thematic_section_id`),
  KEY `thematic_section_id` (`thematic_section_id`),
  CONSTRAINT `recipe_thematic_section_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`recipe_id`),
  CONSTRAINT `recipe_thematic_section_ibfk_2` FOREIGN KEY (`thematic_section_id`) REFERENCES `thematic_section` (`thematic_section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.steps
DROP TABLE IF EXISTS `steps`;
CREATE TABLE IF NOT EXISTS `steps` (
  `recipe_id` int(11) NOT NULL,
  `step_id` int(11) NOT NULL AUTO_INCREMENT,
  `step_number` int(11) unsigned NOT NULL,
  `step_instriction` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`step_id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `steps_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`recipe_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.tag
DROP TABLE IF EXISTS `tag`;
CREATE TABLE IF NOT EXISTS `tag` (
  `tag_id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(100) NOT NULL,
  PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table masterchef.thematic_section
DROP TABLE IF EXISTS `thematic_section`;
CREATE TABLE IF NOT EXISTS `thematic_section` (
  `thematic_section_id` int(11) NOT NULL AUTO_INCREMENT,
  `thematic_section_name` varchar(100) NOT NULL,
  `thematic_section_description` text DEFAULT NULL,
  PRIMARY KEY (`thematic_section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for procedure masterchef.update_recipe_nutrition
DROP PROCEDURE IF EXISTS `update_recipe_nutrition`;
DELIMITER //
CREATE PROCEDURE `update_recipe_nutrition`()
BEGIN
    UPDATE recipe r
    JOIN (
        SELECT 
            ri.recipe_id,
            SUM(i.ingredient_protein * ri.quantity / 100) AS total_protein,
            SUM(i.ingredient_carbs * ri.quantity / 100) AS total_carbs,
            SUM(i.ingredient_fat * ri.quantity / 100) AS total_fat
        FROM 
            recipe_ingredient ri
        JOIN 
            ingredient i ON ri.ingredient_id = i.ingredient_id
        GROUP BY 
            ri.recipe_id
    ) AS nutrition ON r.recipe_id = nutrition.recipe_id
    SET 
        r.total_protein = nutrition.total_protein,
        r.total_carbs = nutrition.total_carbs,
        r.total_fat = nutrition.total_fat;
END//
DELIMITER ;

-- Dumping structure for trigger masterchef.before_ingredient_update
DROP TRIGGER IF EXISTS `before_ingredient_update`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER before_ingredient_update 
BEFORE UPDATE ON ingredient 
FOR EACH ROW 
BEGIN
    CALL update_recipe_nutrition();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger masterchef.before_insert_cook
DROP TRIGGER IF EXISTS `before_insert_cook`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_insert_cook` BEFORE INSERT ON `cook` FOR EACH ROW BEGIN
    IF (TIMESTAMPDIFF(YEAR, NEW.date_of_birth, CURDATE()) < 18) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cook must be at least 18 years old';
    END IF;
    IF (TIMESTAMPDIFF(YEAR, NEW.date_of_birth, CURDATE()) >90) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cook must not be more than 90 years old';
    END IF;
    SET NEW.age = FLOOR(DATEDIFF(CURDATE(), NEW.date_of_birth) / 365);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger masterchef.before_recipe_ingredient_delete
DROP TRIGGER IF EXISTS `before_recipe_ingredient_delete`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER before_recipe_ingredient_delete 
BEFORE DELETE ON recipe_ingredient 
FOR EACH ROW 
BEGIN
    CALL update_recipe_nutrition();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger masterchef.before_recipe_ingredient_insert
DROP TRIGGER IF EXISTS `before_recipe_ingredient_insert`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER before_recipe_ingredient_insert 
BEFORE INSERT ON recipe_ingredient 
FOR EACH ROW 
BEGIN
    CALL update_recipe_nutrition();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger masterchef.before_recipe_ingredient_update
DROP TRIGGER IF EXISTS `before_recipe_ingredient_update`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER before_recipe_ingredient_update 
BEFORE UPDATE ON recipe_ingredient 
FOR EACH ROW 
BEGIN
    CALL update_recipe_nutrition();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger masterchef.before_update_cook
DROP TRIGGER IF EXISTS `before_update_cook`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_update_cook` BEFORE UPDATE ON `cook` FOR EACH ROW BEGIN
    IF (TIMESTAMPDIFF(YEAR, NEW.date_of_birth, CURDATE()) < 18) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cook must be at least 18 years old';
    END IF;
    IF (TIMESTAMPDIFF(YEAR, NEW.date_of_birth, CURDATE()) >90) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cook must not be more than 90 years old';
    END IF;
    SET NEW.age = FLOOR(DATEDIFF(CURDATE(), NEW.date_of_birth) / 365);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

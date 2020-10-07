
CREATE TABLE `aliases` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alias` varchar(70) NOT NULL,
  KEY `index` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

LOCK TABLES `aliases` WRITE;

INSERT INTO `aliases` VALUES (1,'ben'),(2,'ed'),(3,'matt'),(4,'simon'),(5,'geoff');
UNLOCK TABLES;


CREATE TABLE `groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(70) NOT NULL,
  `routeId` int(10) unsigned NOT NULL,
  KEY `index` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

LOCK TABLES `groups` WRITE;
INSERT INTO `groups` VALUES (1,'user',1),(2,'admin',2),(3,'superadmin',3);
UNLOCK TABLES;

CREATE TABLE `passwords` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(256) NOT NULL,
  `salt` varchar(256) NOT NULL,
  KEY `index` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

LOCK TABLES `passwords` WRITE;
INSERT INTO `passwords` VALUES (4,'00b04671d6a4b10a3ad5e00428aea50812911950aa50b90bd12646665bce6d1e497b45b83489d7589a7de5324f64a2fa86684010f1cbd034d17b3b219798e992','G<{D4nz~>wIGhBRT?=_4Z=f$?bcAa&'),(8,'da88fb88e9e72d69727d99fe819d5f488ba87b52386eddbf014635e843a9832e02d930ea79d4229f0864abe67661bef15b3a9c973f58253d5654f320963d7763','5Y$CXuPvrO1;%x?_pqXPeu[T5.LDFr'),(9,'009a582cf750603789d1dd62bde0852e83cf91281d39bdff3c9d513bea48c0c465d76bbc7949d6048a2b352da8eecdb657516118ee103cc9bd53e6f754083ef4','<2s,s>7=N8a8[-UU$kJt2?0&oUG{$L'),(10,'527f673d83110ae45398102922500e40f168d562937320d9dceb64420756f4cfe56516b9d8dfb88ce36b1ddd542acc337a6abee71bf80b52c1250d6714752385','1PZW8CZ5_DUee,E2a{E86v>1joi:qI'),(11,'7e8c7b58afe1df4fa315d7213503fec565a7d6de427d461e4e48d48c27dae68e6ebc5fbb59b097fbea694178632f7a3ffd81447f98a5a0965e38b64ea93d29f9','v,jpmGb2s}q[dZ<E1Ro>;2@5Et$v$'),(12,'f15f3b16c17b45b24d69871ec707ef08157ee6a4baf74dd9fa6cac5cf3dda95d81de62621df7225cafa05c9d86b7109c99d3519710fdcd6d59b2cdfeb369089a','uD:vh0MQ&-v)&=;U;[U+f@l[sOwysM');
UNLOCK TABLES;

CREATE TABLE `routes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `route` varchar(70) NOT NULL,
  UNIQUE KEY `route` (`route`),
  KEY `index` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
INSERT INTO `routes` VALUES (1,'user'),(2,'admin'),(3,'superadmin');
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aliasId` int(10) unsigned NOT NULL,
  `passwordId` int(10) unsigned NOT NULL,
  `groupId` int(10) unsigned NOT NULL,
  UNIQUE KEY `aliasId` (`aliasId`),
  KEY `index` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,8,1),(2,2,9,3),(3,3,10,2),(4,4,11,1),(5,5,12,2);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `users_view`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `users_view` (
  `id` tinyint NOT NULL,
  `name` tinyint NOT NULL,
  `group` tinyint NOT NULL,
  `route` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

DELIMITER ;;
CREATE FUNCTION `alias_add`(`alias_input` VARCHAR(70) CHARSET utf8) RETURNS int(10) unsigned
    MODIFIES SQL DATA
BEGIN
    DECLARE alias_id INT(10) UNSIGNED;
    SELECT `id` INTO alias_id
        FROM `aliases` 
        WHERE `aliases`.`alias` = alias_input
        LIMIT 1;
    IF alias_id IS NULL THEN
        INSERT INTO `aliases`
            (`aliases`.`alias`)
            VALUES
            (alias_input);
        RETURN LAST_INSERT_ID();
    END IF;
    RETURN (SELECT alias_id);
END ;;
DELIMITER ;

DELIMITER ;;
CREATE FUNCTION `domain_add`(`domain_input` VARCHAR(70) CHARSET utf8) RETURNS int(10) unsigned
    MODIFIES SQL DATA
BEGIN
    DECLARE domain_id INT(10) UNSIGNED;
    SELECT `id` INTO domain_id
        FROM `domains` 
        WHERE `domains`.`domain` = domain_input
        LIMIT 1;
    IF domain_id IS NULL THEN
        INSERT INTO `domains`
            (`domains`.`domain`)
            VALUES
            (domain_input);
        RETURN LAST_INSERT_ID();
    END IF;
    RETURN (SELECT domain_id);
END ;;
DELIMITER ;

DELIMITER ;;
CREATE FUNCTION `group_add`(`name` VARCHAR(70) CHARSET utf8, `route_id` INT UNSIGNED) RETURNS int(10) unsigned
    MODIFIES SQL DATA
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM `routes`
      WHERE `routes`.`id` = route_id LIMIT 1
  ) THEN
    RETURN NULL;
  END IF;
  INSERT INTO `groups` 
      (`groups`.`name`, `groups`.`routeId`)
      VALUES
      (name,route_id);
  RETURN LAST_INSERT_ID();
END ;;
DELIMITER ;

DELIMITER ;;
CREATE  FUNCTION `hash_get`(`data_input` VARCHAR(128) CHARSET utf8, `salt_input` VARCHAR(128) CHARSET utf8) RETURNS varchar(256) CHARSET utf8
    NO SQL
BEGIN
  RETURN (
    SELECT SHA2(
      CONCAT(
        data_input,
        salt_input
      ),
      512
    )
  );
END ;;
DELIMITER ;

DELIMITER ;;
CREATE  FUNCTION `password_add`(`password_input` VARCHAR(70) CHARSET utf8) RETURNS int(10) unsigned
    MODIFIES SQL DATA
BEGIN
    DECLARE SALT VARCHAR(30);
    DECLARE PASSWORDHASH VARCHAR(256);
    SET SALT = (SELECT randomchar(30));
    SET PASSWORDHASH = (SELECT hash_get(password_input, SALT));
    INSERT INTO `passwords`
      (`passwords`.`hash`, `passwords`.`salt`)
      VALUES
      (PASSWORDHASH, SALT);
    RETURN LAST_INSERT_ID();
END ;;
DELIMITER ;

DELIMITER ;;
CREATE  FUNCTION `password_check`(`username` VARCHAR(70) CHARSET utf8, `password_input` VARCHAR(70) CHARSET utf8) RETURNS varchar(70) CHARSET utf8
    NO SQL
BEGIN
  IF EXISTS (SELECT 
    1
    FROM
      `users`
    LEFT JOIN
     `aliases`
    ON
     `users`.`aliasId`=`aliases`.`id`
    LEFT JOIN
     `passwords`
    ON
     `users`.`passwordId`=`passwords`.`id`
    WHERE
     `aliases`.`alias` = username
    AND
      `passwords`.`hash` = (SELECT hash_get(password_input,`passwords`.`salt`))
  )
  THEN
     RETURN (
       SELECT
         `routes`.`route`
       FROM
         `users`
       LEFT JOIN
           `groups`
       ON
         `users`.`groupId` = `groups`.`id`
       LEFT JOIN
         `routes`
       ON
         `groups`.`routeId` = `routes`.`id`
       LEFT JOIN
         `aliases`
       ON
         `users`.`aliasId` = `aliases`.`id`
       WHERE
         `aliases`.`alias`= username         
     ); 
  END IF;
  RETURN NULL;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE  FUNCTION `randomchar`(`char_count` INT UNSIGNED) RETURNS varchar(1024) CHARSET utf8
    NO SQL
BEGIN 
  DECLARE CHARACTERS VARCHAR(86) default '$-_+$%=&()?@;:#~[]{},.<>ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  DECLARE OUTPUT VARCHAR(1000) default '';
  DECLARE I INT default 1;
  IF char_count > 1024 THEN
      SET char_count = 1024 ;
  END IF;
  WHILE I <= char_count DO
    SET OUTPUT = CONCAT(
        OUTPUT, 
        (
            SELECT substring(
                CHARACTERS,
                rand()*86,
                1
            )
        )
    );
    SET I = I + 1;
  END WHILE;  
  RETURN OUTPUT;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE  FUNCTION `route_add`(`route_input` VARCHAR(70) CHARSET utf8) RETURNS int(10) unsigned
    MODIFIES SQL DATA
BEGIN
    DECLARE ROUTEID INT(10) UNSIGNED;
    SELECT `id` INTO ROUTEID
    FROM `routes` 
        WHERE `routes`.`route` = route_input
        LIMIT 1;
    IF ROUTEID IS NULL THEN
        INSERT INTO `routes`
            (`routes`.`route`)
            VALUES
            (route_input);
        RETURN LAST_INSERT_ID();
    END IF;
    RETURN (SELECT ROTEID);
END ;;
DELIMITER ;

DELIMITER ;;
CREATE  FUNCTION `user_add`(`username` VARCHAR(70) CHARSET utf8, `group_id` INT UNSIGNED, `password_input` VARCHAR(70) CHARSET utf8) RETURNS int(10) unsigned
    MODIFIES SQL DATA
BEGIN
   DECLARE ALIASID INT(10) UNSIGNED;
   DECLARE ALIASCOUNT TINYINT(2) UNSIGNED;
   DECLARE PASSWORDID INT(10) UNSIGNED;   
   SET ALIASID = (SELECT alias_add(username));
   SELECT COUNT(`id`) INTO ALIASCOUNT FROM `users` WHERE `users`.`aliasId` = ALIASID LIMIT 1;
   IF ALIASCOUNT > 0 THEN
      RETURN NULL;
   END IF;
   IF NOT EXISTS( SELECT 1 FROM `groups` WHERE `groups`.`id` = group_id LIMIT 1) THEN
       RETURN NULL;
   END IF;
   SET PASSWORDID = (SELECT password_add(password_input));
   INSERT INTO `users` 
     (`users`.`aliasId`, `users`.`groupId`, `users`.`passwordId`)
     VALUES (ALIASID, group_id, PASSWORDID);
   RETURN LAST_INSERT_ID();
END ;;
DELIMITER ;

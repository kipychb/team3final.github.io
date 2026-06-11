CREATE DATABASE  IF NOT EXISTS `flower` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `flower`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: flower
-- ------------------------------------------------------
-- Server version	8.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `MemberID` int NOT NULL,
  `ProductID` int NOT NULL,
  `Quantity` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`MemberID`,`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (11344250,46,1),(11344251,19,1),(11344251,24,1);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_us`
--

DROP TABLE IF EXISTS `contact_us`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_us` (
  `ContactID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) NOT NULL,
  `ContactMethod` text NOT NULL,
  `Contents` text NOT NULL,
  PRIMARY KEY (`ContactID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_us`
--

LOCK TABLES `contact_us` WRITE;
/*!40000 ALTER TABLE `contact_us` DISABLE KEYS */;
INSERT INTO `contact_us` VALUES (1,'愛妳長長久久','用愛感應','我最討厭的就是事後道歉??\r\n殺～～～～殺～～～～殺～～～～');
/*!40000 ALTER TABLE `contact_us` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `counter`
--

DROP TABLE IF EXISTS `counter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `counter` (
  `visitCount` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`visitCount`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `counter`
--

LOCK TABLES `counter` WRITE;
/*!40000 ALTER TABLE `counter` DISABLE KEYS */;
INSERT INTO `counter` VALUES (106);
/*!40000 ALTER TABLE `counter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guestbook`
--

DROP TABLE IF EXISTS `guestbook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guestbook` (
  `GuestbookID` int NOT NULL AUTO_INCREMENT,
  `MemberID` int NOT NULL,
  `ProductID` varchar(45) NOT NULL,
  `Rating` decimal(2,1) NOT NULL DEFAULT '0.0',
  `Contents` text NOT NULL,
  `DateTime` datetime NOT NULL,
  PRIMARY KEY (`GuestbookID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guestbook`
--

LOCK TABLES `guestbook` WRITE;
/*!40000 ALTER TABLE `guestbook` DISABLE KEYS */;
INSERT INTO `guestbook` VALUES (1,11344251,'1',0.0,'爛透了...','2026-06-02 00:00:00'),(2,11344250,'2',0.0,'讚透了','2026-05-02 00:00:00'),(3,11344250,'1',0.0,'123','2026-06-02 21:14:29'),(4,11344251,'1',0.0,'134好吃','2026-06-02 21:14:50'),(5,11344250,'21',3.0,'23123132','2026-06-04 01:41:39'),(6,11344250,'21',4.0,'123123123123','2026-06-04 01:41:45'),(7,11344251,'21',1.0,'我比較喜歡 134','2026-06-04 01:53:31'),(8,11344250,'8',4.0,'我想買給又德，他肯定會很愛的 <3','2026-06-04 14:42:51'),(9,11344251,'7',4.0,'SB才買','2026-06-04 22:12:11'),(10,11344250,'29',1.0,'傻逼才買','2026-06-04 22:16:52'),(11,11344251,'46',3.0,'誰長這麼醜','2026-06-11 00:20:09');
/*!40000 ALTER TABLE `guestbook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `MemberID` int NOT NULL AUTO_INCREMENT,
  `MemberName` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Password` varchar(45) NOT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Rank` varchar(45) NOT NULL DEFAULT '可悲會員',
  `Birthday` date DEFAULT '2025-01-01',
  PRIMARY KEY (`MemberID`)
) ENGINE=InnoDB AUTO_INCREMENT=11344254 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (11344250,'傻逼','123@gmail.com','123','09123456789','傻逼中心','管理員','2025-01-22'),(11344251,'逼逼拉餔','456@gmail.com','456','09456789123','我家','可悲會員','2006-04-25'),(11344252,'王國城','guochen@gmail.com','asdasdasd','null',NULL,'可悲會員','2025-01-01'),(11344253,'123','123456@gmail.com','123456','123','123','管理員','2025-01-01');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_coupons`
--

DROP TABLE IF EXISTS `member_coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_coupons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `coupon_amount` int DEFAULT '150',
  `claimed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_coupons`
--

LOCK TABLES `member_coupons` WRITE;
/*!40000 ALTER TABLE `member_coupons` DISABLE KEYS */;
INSERT INTO `member_coupons` VALUES (1,11344253,150,'2026-06-08 07:14:48','已使用'),(2,11344250,150,'2026-06-09 13:50:43','已使用');
/*!40000 ALTER TABLE `member_coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `OrderID` int NOT NULL,
  `ProductID` int NOT NULL,
  `Quantity` int unsigned NOT NULL DEFAULT '0',
  `Price` int NOT NULL DEFAULT '0',
  `Subtotal` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`OrderID`,`ProductID`),
  KEY `fk_orderdetail_order_idx` (`OrderID`),
  CONSTRAINT `fk_orderdetail_order` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (1,1,1,0,9487.00),(2,1,2,0,18974.00),(2,2,1,0,114514.00),(3,1,2,0,18974.00),(3,2,1,0,114514.00),(4,1,1,0,9487.00),(5,1,1,0,9487.00),(6,2,2,1500,3000.00),(6,16,3,2800,8400.00),(6,29,1,2300,2300.00),(7,1,2,2000,4000.00),(8,23,1,2000,2000.00),(9,1,1,2000,2000.00),(9,15,1,2100,2100.00),(9,17,1,2500,2500.00),(9,31,3,2000,6000.00),(10,11,1,2500,2500.00),(10,18,1,2000,2000.00),(10,25,1,2000,2000.00),(11,29,1,2300,2300.00),(12,19,1,2000,2000.00),(13,29,41,2300,94300.00),(14,7,1,2000,2000.00),(15,5,1,2000,2000.00),(16,16,3,2800,8400.00);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `MemberID` int NOT NULL,
  `OrderDate` date DEFAULT NULL,
  `OrderType` varchar(50) DEFAULT NULL,
  `TotalAmount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `OrderStatus` enum('已付款','已出貨','完成') NOT NULL DEFAULT '已付款',
  PRIMARY KEY (`OrderID`),
  KEY `fk_order_member_idx` (`MemberID`),
  CONSTRAINT `fk_order_member` FOREIGN KEY (`MemberID`) REFERENCES `member` (`MemberID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,11344250,'2026-06-02',NULL,9487.00,'已付款'),(2,11344250,'2026-06-02',NULL,133488.00,'已付款'),(3,11344250,'2026-06-02',NULL,0.00,'已付款'),(4,11344250,'2026-06-02',NULL,0.00,'已付款'),(5,11344250,'2026-06-02',NULL,0.00,'已付款'),(6,11344250,'2026-06-04','linepay',13820.00,'已付款'),(7,11344250,'2026-06-04','credit',4120.00,'已付款'),(8,11344251,'2026-06-04','transfer',2120.00,'已付款'),(9,11344250,'2026-06-04','credit',12720.00,'已付款'),(10,11344250,'2026-06-04','linepay',6620.00,'已付款'),(11,11344252,'2026-06-04','linepay',2420.00,'已付款'),(12,11344251,'2026-06-04','credit',2120.00,'已付款'),(13,11344250,'2026-06-04','credit',94420.00,'已付款'),(14,11344253,'2026-06-07','credit',2120.00,'已付款'),(15,11344250,'2026-06-07','transfer',2120.00,'已付款'),(16,11344253,'2026-06-09','credit',8520.00,'已付款');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `ProductID` int NOT NULL AUTO_INCREMENT,
  `ProductName` varchar(100) NOT NULL DEFAULT 'null',
  `Category` enum('fresh','dried') DEFAULT NULL,
  `Price` int NOT NULL DEFAULT '0',
  `Quantity` int NOT NULL DEFAULT '0',
  `Series` enum('For Lover','For Myself','For Friend','For Elders') DEFAULT NULL,
  `Size` varchar(100) DEFAULT NULL,
  `Material` varchar(255) DEFAULT NULL,
  `AppreciationPeriod` varchar(100) DEFAULT NULL,
  `SaveMethods` varchar(500) DEFAULT NULL,
  `Language` varchar(255) DEFAULT NULL,
  `Idea` text,
  `Image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ProductID`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'摯愛Love in Bloom','fresh',2000,57,'For Lover','約 28（長）x24（寬）公分','紅玫瑰、白石竹、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','熱烈的愛、永恆的承諾','內斂的情感透過這束花的盛放將贈予者炙熱的愛意傳遞給對方——「妳/你值得世界上最美好的事物。」',NULL),(2,'半熟戀人Semi-Ripe Romance','dried',1500,38,'For Lover','約 30（長）x16（寬）公分','紅玫瑰、棉花、索拉花、尤加利葉、乾燥果實','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','堅定、深沉且不凋零的愛','「半熟」象徵著彼此已經過了最初的羞澀與試探，擁有一定的默契與理解，但依然保有那種臉紅心跳的感覺，是種最舒服且迷人的狀態。',NULL),(3,'悸動Soft blush','fresh',2000,49,'For Lover','約 28（長）x24（寬）公分','粉玫瑰、白石竹、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','初遇的悸動、純粹的欣賞','柔和的淡粉色花瓣象徵愛戀的羞澀與臉頰的紅潤，那份純粹的悸動輕輕牽引著兩顆逐漸靠近的真心。',NULL),(4,'如沐陽光Golden Glow','dried',1800,56,'For Lover','約30（長）x16（寬）公分','黃玫瑰、兔尾草、棉花、索拉花、米花、尤加利葉','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','我生命中最明亮的溫暖','這束花代表著祈願親愛的你/妳始終身處光譜的中心，被生命中所有的美好圍繞，你/妳是我生命中最明亮的存在。',NULL),(5,'暮光夢境Twilight Fantasy','fresh',2000,50,'For Lover','約 28（長）x24（寬）公分','紫玫瑰、星辰花、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','永恆的愛、浪漫真情、珍貴獨特','薰衣草色的玫瑰是暮光中獨有的夢境，願這份愛如同這片刻的柔光，永遠將你/妳溫柔擁抱。',NULL),(6,'唯一The Only','dried',2000,48,'For Lover','約30（長）x16（寬）公分','紫玫瑰、羽毛、兔尾草、乾燥細枝、尤加利葉、卡斯比亞','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','珍貴、唯一、堅定不移','視覺上的絕對唯一傳遞著極致的偏愛，以最堅定的姿態，在時光的長河中靜靜盛開。',NULL),(7,'日暮頌歌Apricot Ember','fresh',2000,59,'For Lover','約 28（長）x24（寬）公分','蜜桃色玫瑰、白石竹、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','真摯的祝福與感謝','玫瑰的顏色如同夕陽西下時的餘暉，溫暖而莊嚴的讚歌，表達贈予者誠摯的謝意。',NULL),(8,'靈魂眷戀Soulful Attachment','dried',2000,60,'For Lover','約30（長）x16（寬）公分','康乃馨、乾燥酸漿果、索拉花、米花、紫薊花、棉花、情人草','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','靈魂深處的連結，永不凋零','這束花使用帶有灰調的莫蘭迪紫代表了心靈上的契合與安寧，適合送給生命中難得可貴的靈魂伴侶。',NULL),(9,'微光詩意Glimmering Verse','fresh',2200,49,'For Myself','約30（長）x20（寬）公分','玫瑰、桔梗、薰衣草、白石竹、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','靜待花開，溫柔以待','這束花採用低飽和度的粉與白為主調，如同純粹的心緒與未盡的溫柔，其中穿插的優雅紫意，它似一首安靜的詩，獻給懂得在喧囂中保持溫柔與自我的你。',NULL),(10,'星辰大海The Sea of Stars','dried',2000,60,'For Myself','約30（長）x16（寬）公分','玫瑰、兔尾草、棉花、索拉花、星辰花、米花','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','在喧囂的世界裡，依然擁有安放靈魂的區域','這束花象徵著「自我」的多面性——可以堅強理智，也可以柔軟感性，始終有個地方接納所有情緒的自己。',NULL),(11,'仲夏時光 Midsummer Gleam','fresh',2500,56,'For Myself','約 28（長）x24（寬）公分','繡球花、玫瑰、太陽花','鮮花保存約5~7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','接納所有，向陽而生','這束花呈現積極向上、充滿療癒的風格，提醒著自己值得被愛、值得擁有所有的晴朗。請像花束般，熱烈而溫柔地向陽而生。',NULL),(12,'花園Garden','dried',2300,49,'For Myself','約 22（長）x25（寬）公分','永生康乃馨、永生繡球、迷你玫瑰、尤加利葉、桉樹果、水晶花、滿天星、千日紅','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','自我成長的力量','這束花獻給那個努力灌溉心靈的自己，在這座『花園』裡隨時都能找回平靜與力量。親愛的，請繼續在自己的節奏裡，優雅盛開。',NULL),(13,'午後淺眠Afternoon Solace','fresh',2000,58,'For Myself','約 21（長）x18（寬）公分','蜜桃色玫瑰、小蒼蘭、香檳色康乃馨、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','內在的平和，是最好的妝容','這束花象徵著從日常的奔波中抽離出來，給予自己一段不受打擾、充滿溫馨感的休憩時間。獻給在不斷前進中，懂得停下來，溫柔對待自己的你/妳，願你/妳始終安靜而有力地生活著。',NULL),(14,'內心獨白Inner monologue','dried',1800,44,'For Myself','約30（長）x16（寬）公分','白玫瑰、繡球花、棉花、米花','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','華麗的自處','這束花設計給「懂得與自己獨處」的人，送給自己這束花是在向世界宣示：我不需要別人的掌聲，我就是自己最優雅的觀眾。',NULL),(15,'留白時刻Moment of Stillness','fresh',2100,59,'For Myself','約 21（長）x18（寬）公分','白向日葵、白玫瑰、洋桔梗、雪柳、尤加利葉、白百合','鮮花保存約5~7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','在簡約中，找回內在的自由與呼吸。','這束花象徵著刻意放慢腳步，在忙碌的生活中，為自己創造出一片沒有雜訊的「空白時間」。它代表洗淨鉛華，讓心靈擁有喘息的空白頁。',NULL),(16,'祝願Wish','dried',2800,42,'For Myself','約 42（長）x21（寬）公分','玫瑰、小雛菊、尤加利葉、兔尾草、小星花、棉花','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','祝願與希望','我們習慣於把祝福送給他人，卻忘了自己也需要被溫柔以待。看著這束花，我才發現生命本該如此豐盈。祝願自己一切都好，像這簇花叢綻放成斑斕、絢爛的樣子。',NULL),(17,'沿途拾光Light Along the Way','fresh',2500,41,'For Friend','約28（長）x24（寬）公分','飛燕草、玫瑰、鬱金香、藍心草','鮮花保存約5~7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','感謝你的光芒，照亮我前行的路','這束花象徵著真摯、不變的友誼，並感謝朋友在人生旅途中給予的陪伴、鼓勵與希望。它代表的是一種穩定、溫暖且充滿活力的支持力量。',NULL),(18,'波光粼粼Shimmering','dried',2000,42,'For Friend','約30（高）*16（寬）公分','白玫瑰、松果、棉花、兔尾草、尤加利葉、木質乾燥材','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','即便流轉於歲月，依然清澈、閃耀且充滿希望','這束花選用白、銀、大地色系的花材，是為了實踐：「無論外界如何更迭，你依舊是那個清澈如初、閃耀如星、滿懷希望的自己。」的理念',NULL),(19,'橘色暖流Amber Glow','fresh',2000,59,'For Friend','約21（長）x18（寬）公分','非洲菊、杏色玫瑰、繡球花、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','願你在繁華世界中，始終保有最熱烈的光芒。','這束花象徵著堅定、溫暖且充滿希望的情誼。它代表著支持朋友去追求夢想，並在疲憊時，永遠能從這份友誼中獲得如陽光般的能量。',NULL),(20,'煦日知己Sunny Soulmate','dried',1300,40,'For Friend','約20（高）x12（寬）公分','星辰、滿天星、鹿角草、松果、黑種草','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','溫暖且充滿支持的力量','選擇大地色與鵝黃色的結合反映了友情的真諦：在對方沮喪時給予支撐，在對方快樂時分享光亮。',NULL),(21,'微風信箋Summer Breeze Letter','fresh',2500,57,'For Friend','約28（長）x24（寬）公分','粉色鬱金香、白色玫瑰、大飛燕草、白翠珠、藍星花、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','最好的情誼，是靈魂的安穩與相契。','這束花象徵著一種如微風般輕柔卻無處不在的陪伴。它代表對朋友最純粹的祝福，感謝對方的存在，讓彼此的生活變得更加清澈與平靜。',NULL),(22,'緋光之境Crimson Horizon','dried',2000,54,'For Friend','約30（高）x16（寬）公分','玫瑰、繡球花、兔尾草、棉花、尤加利葉','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','生命力的綻放','這束花表達著生命本質的紅艷與光彩因沉澱而顯得更加瑰麗且動人。',NULL),(23,'晨曦絮語Morning Whispers','fresh',2000,46,'For Friend','約21（長）x18（寬）公分','黃玫瑰、粉康乃馨、黃鈕扣菊、尤加利葉','鮮花保存約5～7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','溫暖且真誠的關懷','這束花象徵著友誼中細膩的陪伴與理解，它像清晨陽光下的低語，始終給人溫柔與安寧。',NULL),(24,'蔚藍Azure','dried',2000,47,'For Friend','約30（高）x16（寬）公分','康乃馨、玫瑰、棉花、兔尾草、星辰花、尤加利葉','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','保有溫柔的堅韌、不被世俗渾濁的清澈。','這束花為傳達贈予者的祝願——「願這抹藍能成為你/妳心中的一片清澈海域，不被世俗所抹滅。」',NULL),(25,'歲月靜好Timeless Grace','fresh',2000,44,'For Elders','約21（長）x18（寬）公分','淡粉玫瑰、酒紅色康乃馨、淡紫洋桔梗、波斯菊、尤加利葉','鮮花保存約5～7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','願在時光的流轉中，始終被溫柔包圍，歲月無憂，日日生香。','這束花選用了飽和度較高的紫色調，代表著長輩如沉香般深厚而內斂的生命質感。深色康乃馨與淺色玫瑰的交織，如同長輩溫暖的叮嚀與我們心中永恆的敬意。',NULL),(26,'慢時Slow Time','dried',1500,41,'For Elders','約22（長）x25（寬）公分','永生康乃馨、永生繡球、乾燥玫瑰、旱雪蓮、尤加利葉、星辰花、水晶花、兔尾草','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','時光不語，愛在花開花落間恆常。','以莫蘭迪色系與永生花材為主，刻意營造一種「停格」的美感，永生花傳達一種長久的陪伴。',NULL),(27,'錦時映照Glowing Epoch','fresh',2500,51,'For Elders','約28（長）x24（寬）公分','康乃馨、玫瑰、鬱金香、紫色飛燕草','鮮花保存約5～7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','對歲月的敬意與永恆的祝福','這束花象徵著長輩豐富的人生閱歷與豁達的心境。康乃馨的溫厚與鬱金香的高雅並存，展現出長輩在家庭中既是避風港，也是典範的雙重意象。',NULL),(28,'織心Texture of Love','dried',2500,48,'For Elders','約42（長）x21（寬）公分','永生康乃馨、永生繡球、乾燥玫瑰、旱雪蓮、尤加利葉、星辰花、水晶花、兔尾草','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','將歲月織成詩，送給豐富我生命的妳。','經時間淬煉的乾燥玫瑰相互堆疊，好似歲月的優雅與深度；點綴其間的兔尾草與星辰花，則帶出生命中柔軟而綿長的情感支撐。',NULL),(29,'月光拾遺Moonlight Keepsake','fresh',2300,87,'For Elders','約28（長）x24（寬）公分','紫色滾邊桔梗、綠色康乃馨、白玫瑰、翠珠花、尤加利葉','鮮花保存約5～7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','對長輩優雅風骨的致敬','紫色與綠色的和諧交織，象徵著一種如月光般安靜而強大的守護，代表我們對長輩健康長壽、心境永保青春的真摯祝願。',NULL),(30,'綻紅Crimson Grace','dried',1800,47,'For Elders','約30（長）x16（寬）公分','乾燥玫瑰、兔尾草、尤加利葉、旱雪蓮、水晶花、星辰花、繡球花、金色葉材、木棉花','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','紅潤常在，喜樂安康','紅色的深淺變化，映襯出生命的豐富層次，這束花代表著祈願受贈者喜樂安康。',NULL),(31,'恬靜時光Serene Bloom','fresh',2000,38,'For Elders','約21（長）x18（寬）公分','黃玫瑰、紫色洋桔梗、粉紫色小菊、尤加利葉','鮮花保存約5～7天','避免陽光直射、避免大力碰撞、避免潮濕環境、放置通風涼爽處、澆水時避開花瓣避免水傷，如有水傷或乾枯泛黃可將花瓣剝除','歲月沉澱後的安穩與喜悅','明亮的黃與靜謐的紫交織，象徵對長輩生活豐盛、內心平靜的深深祝願，代表著我們心中那份如午後陽光般，溫暖而長久的敬愛與感謝。',NULL),(32,'德馨知遇Virtue & Grace','dried',2000,49,'For Elders','約30（長）x16（寬）公分','白玫瑰、羽毛、松果、棉花、藍刺菊、尤加利葉','乾燥/永生花良好保存1年以上','避免大力碰撞、避免潮濕環境','歲月長久，芬芳永駐','錯落有致的松果與乾燥果實，象徵著長輩一生所累積的智慧與成就，這款花的核心是生命的回饋與致敬，用來感謝長輩如山般穩重、如林般深邃的教誨。',NULL),(45,'測試','fresh',2000,99,'For Lover','約 28x24 公分','玫瑰、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免潮濕環境','中文','',''),(46,'測試30','fresh',2500,99,'For Lover','約 28x24 公分','玫瑰、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免潮濕環境','中文','123','56197221-cd0d-4bd2-a1ce-cd502273e2a9.png'),(47,'測試565','fresh',15,99,'For Lover','約 28x24 公分','玫瑰、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免潮濕環境','中文','145','6a6fe3a7-4de9-4e71-ae47-ff85e00ca7c3.png'),(48,'屁眼','fresh',5200,99,'For Lover','約 28x24 公分','玫瑰、尤加利葉','鮮花保存約5~7天','避免陽光直射、避免潮濕環境','中文','','78d36ae8-2cc1-4331-9f36-d1a1897274b2.png');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz`
--

DROP TABLE IF EXISTS `quiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz` (
  `QuestionID` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL,
  `OptA` text NOT NULL,
  `OptB` text NOT NULL,
  `OptC` text NOT NULL,
  `OptD` text NOT NULL,
  `OptE` text NOT NULL,
  PRIMARY KEY (`QuestionID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz`
--

LOCK TABLES `quiz` WRITE;
/*!40000 ALTER TABLE `quiz` DISABLE KEYS */;
INSERT INTO `quiz` VALUES (1,'Step 1: 收到一份不喜歡的禮物，你的反應是？','即使不喜歡，也會誇張地表示感謝和驚喜。','溫和地收下，但會默默收起來，不常使用。','仔細研究禮物的設計或功能，分析它的價值。','轉頭就將它送給另一個需要的朋友。','很快向送禮人表達，並誠實說出更喜歡的款式。'),(2,'Step 2: 週末早晨，你會如何開始這一天？','立即規劃一個戶外活動或約見朋友。','徹底清潔和整理房間，享受安靜時光。','泡一杯茶，坐在窗邊，戴上耳機專注閱讀。','聯絡所有朋友，詢問有沒有突發的有趣計畫。','準備一頓精緻早餐，決定去哪裡隨心探索。'),(3,'Step 3: 遇到一個新加入的團體，你會？','積極主動地向所有人介紹自己，並找話題。','觀察周圍，只對談吐沉穩的人表示好奇。','傾向於保持沉默，除非被點到名才發言。','找到笑點，用幽默感打破冰點。','默默關注，為那些比較孤單的人提供幫助。'),(4,'Step 4: 當你感到疲倦時，最能給你充電的是？','參加一場熱鬧的派對或音樂會。','在無人打擾的環境中，進行深度冥想或休息。','獨自散步，讓思緒隨著腳步慢慢沉澱。','成功解決一個難題後，聽到他人的讚美。','收到家人或伴侶的一個擁抱與肯定。'),(5,'Step 5: 在花店，你通常會被哪種花束吸引？','顏色鮮豔、造型大膽，視覺衝擊力強的。','單一花材、高雅簡約，只有白綠兩色的。','花瓣層次豐富、香氣柔和，結構線條分明的。','陽光感十足、造型活潑，能照亮空間的。','造型隨性、多種顏色混搭，帶著野外氣息的。');
/*!40000 ALTER TABLE `quiz` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `MemberID` int NOT NULL,
  `ProductID` int NOT NULL,
  PRIMARY KEY (`MemberID`,`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
INSERT INTO `wishlist` VALUES (11344250,3),(11344250,8),(11344250,11),(11344250,20),(11344250,22),(11344250,25),(11344250,29),(11344250,46),(11344251,17),(11344251,19),(11344252,17),(11344252,29);
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-11 14:05:02

-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 18, 2022 at 12:55 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 7.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `share_learning`
--

-- --------------------------------------------------------

--
-- Table structure for table `cartItem`
--

CREATE TABLE `cartItem` (
  `id` bigint(20) NOT NULL,
  `bookId` bigint(20) NOT NULL,
  `sellingUserId` bigint(20) NOT NULL,
  `buyingUserId` bigint(20) NOT NULL,
  `bookCount` int(11) NOT NULL,
  `pricePerPiece` float NOT NULL,
  `wishlisted` tinyint(4) NOT NULL DEFAULT 2,
  `postType` enum('S','B') NOT NULL DEFAULT 'S',
  `postedOn` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cartItem`
--

INSERT INTO `cartItem` (`id`, `bookId`, `sellingUserId`, `buyingUserId`, `bookCount`, `pricePerPiece`, `wishlisted`, `postType`, `postedOn`) VALUES
(1, 1, 4, 2, 2, 300, 1, 'S', '2022-05-06 04:02:12'),
(2, 2, 2, 1, 2, 150, 2, 'S', '2022-05-06 09:12:37'),
(3, 3, 1, 3, 1, 1200, 2, 'S', '2022-05-06 09:12:37'),
(5, 3, 1, 2, 2, 300, 1, 'B', '2022-05-06 10:01:37'),
(6, 3, 1, 3, 2, 1500, 1, 'B', '2022-05-06 10:02:11'),
(7, 2, 1, 2, 2, 400, 1, 'B', '2022-05-06 14:43:02');

-- --------------------------------------------------------

--
-- Table structure for table `chat`
--

CREATE TABLE `chat` (
  `id` bigint(20) NOT NULL,
  `incoming_id` int(255) NOT NULL,
  `outgoing_id` int(255) NOT NULL,
  `message` text NOT NULL,
  `message_sent_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `chat`
--

INSERT INTO `chat` (`id`, `incoming_id`, `outgoing_id`, `message`, `message_sent_date`) VALUES
(1, 2, 1, 'This is aa test', '2021-12-25 02:21:22'),
(2, 1, 2, 'Okay I got it !!', '2021-12-25 03:00:44'),
(3, 2, 1, 'kl', '2021-12-25 03:21:22'),
(4, 2, 1, 'Is it okay?', '2021-12-25 03:22:54'),
(5, 1, 2, 'Yup, Perfect', '2021-12-25 03:23:35'),
(22, 2, 1, 'hello', '2021-12-27 00:30:48'),
(23, 2, 1, 'who are you', '2021-12-27 00:30:57'),
(24, 2, 1, 'who are you?', '2021-12-27 00:38:23');

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `id` bigint(20) NOT NULL,
  `userId` bigint(20) NOT NULL,
  `bookName` varchar(256) NOT NULL,
  `author` varchar(256) DEFAULT NULL,
  `description` text NOT NULL,
  `boughtDate` date NOT NULL,
  `price` float NOT NULL,
  `bookCount` int(5) NOT NULL,
  `pictures` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `wishlisted` tinyint(1) NOT NULL DEFAULT 2,
  `postType` enum('S','B') NOT NULL DEFAULT 'S',
  `postRating` float DEFAULT NULL,
  `postedOn` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`id`, `userId`, `bookName`, `author`, `description`, `boughtDate`, `price`, `bookCount`, `pictures`, `wishlisted`, `postType`, `postRating`, `postedOn`) VALUES
(1, 1, 'C Programming Fundamentals II Edition', 'Rahul Rimal', 'This is a test book. Sell it here!!This is a test book. Sell it here!!This is a test book. Sell it here!!This is a test book. Sell it here!!', '2020-11-05', 600, 2, 'picc.jpeg,FB_IMG_16479972034889796.jpg,IMG-20220329-WA0094-01.jpeg', 1, 'S', 4, '2021-07-26 08:51:28'),
(2, 1, 'C Programming Fundamentals II Edition', 'Rahul Rimal', 'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Natus, distinctio velit harum accusantium ab laudantium, incidunt excepturi repudiandae corporis eveniet iste alias fugit maxime fuga delectus praesentium illum inventore repellendus.', '2020-11-05', 600, 1, 'picc.jpeg,FB_IMG_16479972034889796.jpg,IMG-20220329-WA0094-01.jpeg', 2, 'B', 4, '2021-07-26 08:51:28'),
(3, 3, 'Mathematics II', 'Surendra Jha', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', '2021-02-17', 400, 4, 'picc.jpeg,FB_IMG_16479972034889796.jpg,IMG-20220329-WA0094-01.jpeg', 1, 'B', 2, '2021-07-26 08:53:17'),
(4, 3, 'Computer Networking', 'Krishna Prasad Rimal', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', '2021-07-02', 900, 2, '', 1, 'S', 2.5, '2021-07-26 08:53:17'),
(13, 1, 'Test Book name with api 2', 'Krishna Pd. Rimal', 'This is a test description of test book with api. This is a test from app through api', '2020-01-01', 500, 5, 'picc.jpeg,FB_IMG_16479972034889796.jpg,IMG-20220329-WA0094-01.jpeg', 2, 'S', 5, '2021-11-01 13:22:10'),
(14, 1, 'Babal Book', NULL, 'This is a babal book written by babal writer Rahul Rimal', '2020-11-05', 300, 2, 'picc.jpeg,FB_IMG_16479972034889796.jpg,IMG-20220329-WA0094-01.jpeg', 2, 'S', 0, '2022-05-03 08:16:25'),
(62, 1, 'Test book 2 final', 'Awesome Author', 'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwggggggggggggggggggggggggggd', '2079-01-19', 1000, 1, 'scaled_image_picker3939131905568855667.png', 1, 'S', NULL, '2022-05-17 05:44:26'),
(63, 1, 'Tessm', 'Awesomn', 'This ijust a book tha t is babal andawesmeeeee and babaaaa', '2079-01-19', 30, 1, 'scaled_image_picker6397022581525176995.jpg,scaled_image_picker5439196730878050039.jpg,scaled_image_picker3456649358449060281.png', 1, 'S', NULL, '2022-05-18 04:39:18');

-- --------------------------------------------------------

--
-- Table structure for table `replies`
--

CREATE TABLE `replies` (
  `id` bigint(20) NOT NULL,
  `postId` bigint(20) NOT NULL,
  `userId` bigint(20) NOT NULL,
  `body` text NOT NULL,
  `createdDate` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `replies`
--

INSERT INTO `replies` (`id`, `postId`, `userId`, `body`, `createdDate`) VALUES
(1, 1, 1, 'I liked this book. I\'ll like to order this one!!', '2021-07-29 17:48:28'),
(2, 1, 2, 'I\'ll like to get this one. for double the price!!', '2021-07-29 17:48:28'),
(3, 2, 2, 'This is just a test comment', '2022-04-25 00:54:54'),
(4, 63, 1, 'This is a babal comment', '2022-05-18 08:25:52');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` bigint(20) NOT NULL COMMENT 'Session ID',
  `userId` bigint(20) NOT NULL,
  `accessToken` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'access token',
  `accessTokenExpiry` datetime NOT NULL COMMENT 'Access token expiry date/time',
  `refreshToken` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'refresh token',
  `refreshTokenExpiry` datetime NOT NULL COMMENT 'refresh token expiry date/time'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Sessions Table';

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `userId`, `accessToken`, `accessTokenExpiry`, `refreshToken`, `refreshTokenExpiry`) VALUES
(1, 1, 'ZjNlNTU5OGYyNTk4ZjMwMTQ1MTNkZDFlYzI5MGY3MzNiOTRjNzc1YmRkNTM2N2YxMzEzNjM1MzAzODM0MzczMTM5MzA=', '2023-05-03 20:32:33', 'MDJiYzc0ZDc1NDU3YjlkOGY2OGMxYjUwZTg1ZWM5YjAxMDJhZjQwZWRiOTY5ODZkMzEzNjM1MzEzNjMwMzEzNTM1MzM=', '2022-05-17 20:12:33'),
(2, 1, 'YmNlYWU4NzRmNjU3ZDU0NjJmZWNjZDAzY2ViNzU3ODFiZTI3NDg0ZDBlNmE1M2I3MzEzNjM1MzAzODM0MzczMTM5MzE=', '2022-04-25 06:44:51', 'MzZjZTVkNmJlNzk4ZDJiZGJjMjAxZmYyMWQxNzIyNjljMzY1NjFiY2RjZTc5NmYzMzEzNjM1MzAzODM0MzczMTM5MzE=', '2022-05-09 06:24:51'),
(3, 1, 'MjZhNWEzOTcwZDJmYjM2YWJjZDk0MDFlOWJiODNmNzJiZTliYmMzNzQxZjdkM2YyMzEzNjM1MzAzODM0MzgzODMxMzg=', '2022-04-25 07:11:58', 'ZDkxNDRmZjJkNjBlODdkYmU4OGQyNDdmY2EzZDllNDllZmZjZTc3ZmIwNDdiMzYzMzEzNjM1MzAzODM0MzgzODMxMzg=', '2022-05-09 06:51:58'),
(4, 1, 'NDA2OTA0YTk4OGI2MjQ1ZGIzNzczMmU0NDFlN2I4YjIxOWQ2MDgxNTQ5YzljMjk4MzEzNjM1MzAzODM0MzgzODMxMzk=', '2022-04-25 07:11:59', 'Yzg5Y2FiYzUwMTViNmIxZTVhNzMxM2ViN2JmZjI5Njg5MzFlZjJlOWU1NTQwN2VlMzEzNjM1MzAzODM0MzgzODMxMzk=', '2022-05-09 06:51:59'),
(5, 1, 'M2RlNWJjOWY3YzRhOTQzZTVkOWNhOTI5MDcyNzgwMjQxZGY0YjE5MWFiNWVhNTAzMzEzNjM1MzEzNTM0MzAzMzM4Mzg=', '2022-05-03 03:33:08', 'OWM1YWNlMWY0ZjRjMDZlN2NlMDE4ZWM3NzJiNmIxMjUxNGJmN2U4ODYzNTMxNGE5MzEzNjM1MzEzNTM0MzAzMzM4Mzg=', '2022-05-17 03:13:08'),
(6, 1, 'ZWJlYjk0MmJhNDZlNGMyN2M3YTc4YzU5MTRhOGI4ZmUxYWM2Nzk0NTcxNzljNDdkMzEzNjM1MzAzODM0MzkzNzMyMzg=', '2022-04-25 07:27:08', 'MDRhZjRmZTg1ZDRmMjU5ZTlhODgwNjM5M2FmMWUzYTc4NTRkNTYxOTI4OGZlMGRmMzEzNjM1MzAzODM0MzkzNzMyMzg=', '2022-05-09 07:07:08'),
(7, 1, 'MzkyNTIzZmFkYzM3Yzg4NjM0ZmJiMDlhZjYwN2EyY2M4MjIwMWY4ZmI4NjQ5NmQ5MzEzNjM1MzAzODM1MzAzMDM3Mzg=', '2022-04-25 07:32:58', 'ZGNhNzNjNDczMjJiMjBkMzk1ZmY2MWEwMjg2M2QxNjg2ZjM5YTkyNTRlNDIzNTY3MzEzNjM1MzAzODM1MzAzMDM3Mzg=', '2022-05-09 07:12:58'),
(9, 1, 'MDUzMTY4MzBlYThkNjcxMTUwN2Q1YzYyNDIzZTJkNDI4YTZmZGUwZTcxNGJiYjczMzEzNjM1MzAzODM1MzAzODMwMzQ=', '2022-04-25 07:45:04', 'ZjVlYmUwZTllMjBiMGQ4OWZjODBkYTNlY2ExOTBlN2E0ZjNiZTkyNmIyMTU2NTYxMzEzNjM1MzAzODM1MzAzODMwMzQ=', '2022-05-09 07:25:04'),
(10, 1, 'Mzk5OTc4MGQwY2Q4ZjYxMzdiZThiYTVlNmU2NjJmNDRjMjlkYWEyOGMzZmEwNDU2MzEzNjM1MzAzODM1MzIzNDM4MzY=', '2022-04-25 08:13:06', 'YTZmOWRhYjIwYjQ5NTk5OTg4ZmNiZjMzNmM4YzIxYmM2ZmNiNzk4NWFiNjZkNTE4MzEzNjM1MzAzODM1MzIzNDM4MzY=', '2022-05-09 07:53:06'),
(11, 1, 'ZmJiNGZhODY2MDc3YzU1OGFhMTcyNjZiYzViNDU1MmNmZjI2YjFmNTc0NmY2ODkwMzEzNjM1MzAzODM1MzIzNjM1MzI=', '2022-04-25 08:15:52', 'ZDdkYjAzYWU3ZjI0YTNhMjdhNWRkNDc1MjYxNWNlMWQwZWFjMGUxOTFjMWQ3MjgyMzEzNjM1MzAzODM1MzIzNjM1MzI=', '2022-05-09 07:55:52'),
(12, 1, 'OTk2YmZlNjAyN2RmMjY3YWQ3MGUxMjY0YTdlNTQzYTk2MjA5N2QwN2Y4NjNhZjk4MzEzNjM1MzAzODM1MzMzODMyMzA=', '2022-04-25 08:35:20', 'NGJlNzllZDUyZmU4MWM4NDc2NjkxY2ZhMmY4ZjkzNmU5ZGJiM2VjZWQ0NDI4ODM4MzEzNjM1MzAzODM1MzMzODMyMzA=', '2022-05-09 08:15:20'),
(13, 1, 'NjI2NTY1ZDVjY2QzMWEwYjIzZTg4NWY2MjNlYjFjMGNhMTQ5YmRmYjNiMTU4MWQwMzEzNjM1MzAzODM1MzUzMzMyMzE=', '2022-04-25 09:00:21', 'ZjQzNDJlNWIxZDBjMjdlYzJlOTc5M2VkMTFkYmY4MjJkNzUxOTZlZWYyZGJiODU3MzEzNjM1MzAzODM1MzUzMzMyMzE=', '2022-05-09 08:40:21'),
(14, 1, 'ZmVmNWZiZDlmNjIyNzRkZDAyMjk5Mzk2YjBmNzA5YzNmOGFmZTViZDJiMjBlMjBmMzEzNjM1MzAzODM1MzUzNDMwMzY=', '2022-04-25 09:01:46', 'M2ViZDk5YzVhNGZiMTQzZGExNTNiYTQ0ODk4YjRlM2UyN2M3NjU3MTFkYTQxN2U1MzEzNjM1MzAzODM1MzUzNDMwMzY=', '2022-05-09 08:41:46'),
(15, 1, 'NzRkNjQ2Yjk4NGRhYTAzODM4Y2Y0OGM5NGJkMWE2N2E1ZGIzMjA4MjgwOTRmOWFmMzEzNjM1MzAzODM1MzUzNjMwMzU=', '2022-04-25 09:05:05', 'Zjk0M2RhMTE2ZmM4MTZlMzBmOWFkZWY2OWJjNzJiYzdiMzI3NzJhMGI4Yzc3NzY0MzEzNjM1MzAzODM1MzUzNjMwMzU=', '2022-05-09 08:45:05'),
(16, 1, 'ZjAxNDE2ZTM1Mjc3NWM3YjJhOWVjYWYzMDU0NjBmNzlmYzlkNTc5N2EwYjBhMTVmMzEzNjM1MzAzODM1MzUzNjM4MzM=', '2022-04-25 09:06:23', 'ZWY1MzE0MWRmMGEyNDM2YTZhNjI2NjI0NTNmYzJkY2ZhN2Y3YzNiNmNmYjVjMDM5MzEzNjM1MzAzODM1MzUzNjM4MzM=', '2022-05-09 08:46:23'),
(17, 1, 'ZjUxMTE2ZDBjY2U0MTQ4MjlmNzYzYTdjZjc5MTFhZGE4YmU3MTg3M2MwNjJmZTdmMzEzNjM1MzAzODM1MzUzODMyMzA=', '2022-04-25 09:08:40', 'YzNkNTdlOTMwNTRmZDU2MDY2MmYzMTRjZGNmNWFmZTMwODk3YzQzYjIzMGFmNDA2MzEzNjM1MzAzODM1MzUzODMyMzA=', '2022-05-09 08:48:40'),
(18, 1, 'ZTg0YTM5NDZiYzY4Njk4ZmJhYjY0MWI3N2Q5NDJjZDgxY2FjZGEzNzFlM2M2NzM5MzEzNjM1MzEzMTMwMzYzOTMzMzA=', '2022-04-28 06:53:50', 'OGFkZWI3NTUyNTdmYjU4MmY5YmVlNzgyZDYyOGRiOGVlMzMxN2IyZWU4ZDM1ZWJhMzEzNjM1MzEzMTMwMzYzOTMzMzA=', '2022-05-12 06:33:50'),
(19, 1, 'MDdhNDE0YTM1MzE2OGM3ODA3OGFkYjI2M2FlOGY4NjZmNzczMzhiMzg0Yjk5MGYwMzEzNjM1MzEzMTMxMzAzNjMwMzg=', '2022-04-28 07:55:08', 'NTcyYTE1MDU3MDk2NmRjM2FjYTVjZTYwMmJhOTBiYjljNTllOTI4NjgwMTY5NTI2MzEzNjM1MzEzMTMxMzAzNjMwMzg=', '2022-05-12 07:35:08'),
(20, 1, 'ZWRhNmY5YzViODdiNDdjYzVlZDc0ZmEzNjRkOWNlYTE1NzBlY2E4ZWUwNmE2NjA2MzEzNjM1MzEzMTMxMzAzNjMwMzg=', '2022-04-28 07:55:08', 'NWFmYWI0OGI3YzBkZWRmOTVhN2ZjNTc0MmViZWNhZjZlZjYxYjI1YzhjY2EwODEwMzEzNjM1MzEzMTMxMzAzNjMwMzg=', '2022-05-12 07:35:08'),
(21, 1, 'YTZlZWM5OWNlN2YwYWExNzI5ZDlkZGRmN2MwYzZmZWUwNTkxOWZiZDNjMzI1YTdjMzEzNjM1MzEzMTMxMzUzNDM5MzA=', '2022-04-28 09:16:30', 'YjY2YzhjNDdhMWY0NjQ5ZDFjODJkYjBhNDY4MDY0OThiODYwZDI1YTU0OTlkYTA1MzEzNjM1MzEzMTMxMzUzNDM5MzA=', '2022-05-12 08:56:30'),
(22, 1, 'ZmY0YzFhYjkzYjhlZjMwMjAxMDAwNzIyY2U1NjA0NmU5ZjJhZTFmODZiN2Q4ZDQxMzEzNjM1MzEzMTMxMzUzNzMxMzg=', '2022-04-28 09:20:18', 'NTM2MDBiNGJmZTE2Y2YwMTY3MDU5YjY2ZWUxODRjNGZhZTUyZGU0NTJlODhhZDFkMzEzNjM1MzEzMTMxMzUzNzMxMzg=', '2022-05-12 09:00:18'),
(23, 1, 'MjlkOThkZDNhODRhNGZiNmEwZTY2MTQwOWFiODRlOGZmZDljYjI0NzdmOTZjYTk5MzEzNjM1MzEzMTMxMzczNzM4Mzg=', '2022-04-28 09:54:48', 'MTk0NGYwNWI4MGQ1YTA3MmYzZGZjYmM5YjJiZDBiYjk4ZjdhMTJjYmQ1NWI2YmZjMzEzNjM1MzEzMTMxMzczNzM4Mzg=', '2022-05-12 09:34:48'),
(24, 1, 'N2I0ODJjNTZkZDc1ZjlkOTFhNTVlMzY5ZTkzOWY2MGJjYTZiN2JkOTRiMGI5ZDllMzEzNjM1MzEzMTM5MzMzMjMyMzM=', '2022-04-29 06:52:03', 'MmFkMzYyODBkOGVhMGY5MjQyYjE1ZTY3ZDc5MTY0MTBlOGU1NjUzNDZkMDExZDEwMzEzNjM1MzEzMTM5MzMzMjMyMzM=', '2022-05-13 06:32:03'),
(25, 1, 'ZDk2NjhiOTg0YjNkOTc4YzBmOTk2ZjIzOWE3MjJiMmEzNGNlMDc1NGRmMTIxMTFmMzEzNjM1MzEzMTM5MzMzNjM2MzU=', '2022-04-29 06:59:25', 'ZGIyMjhlMjU4NmNlNjYwNGRhY2I4N2FjYzExY2EwNTc0MWVjMWM1NTlkODRkMzlmMzEzNjM1MzEzMTM5MzMzNjM2MzU=', '2022-05-13 06:39:25'),
(26, 1, 'NzJkNmViMzJjNjQ5Yjc0ZTRlNjI4OWQ2NDgxNWVlNzUwYTQxZDA1ZGQ4ZjAxYjBmMzEzNjM1MzEzMTM5MzMzNzM2Mzg=', '2022-04-29 07:01:08', 'ZDlhZWRhZmUwZTM0Y2ZlOTQyNGNmYTcwNGIxZjE3ZmJkNjZjMDljZWNmNjIzY2ZjMzEzNjM1MzEzMTM5MzMzNzM2Mzg=', '2022-05-13 06:41:08'),
(27, 1, 'N2FmNTViYzRhNjAzNGIzYTQyN2JmZjc1NzI0MzdkMTYxNzZjZjNlMjdkODIxNDFjMzEzNjM1MzEzMTM5MzkzODM0MzI=', '2022-04-29 08:42:22', 'ZjA4N2JiMDE1ZDg0MTA2NWRkZjEwMjdkNTVjMGI5NzAxMjJjZjA5ZTdlYjU5MTk1MzEzNjM1MzEzMTM5MzkzODM0MzI=', '2022-05-13 08:22:22'),
(29, 1, 'MTExNWM1YjU2ZWE2YWFjMmRiNTlkODAyZTc4MzQwZjQwNmM5NDRjMTM1YzUwOGRiMzEzNjM1MzEzNDM3MzEzODM4MzE=', '2022-05-02 12:16:21', 'NDkyM2I3ZTNmMzRlZWQxMjdiMmU1NGNiZDZhNTYzYWY4YjFkYjBmMTNlZGI4NjU2MzEzNjM1MzEzNDM3MzEzODM4MzE=', '2022-05-16 11:56:21'),
(30, 1, 'ODNjNTRjMjMwODc5ZjY0MjlkOGQ1YjhhNDIyN2NlNmM4NmM5OTQ5ZTUzOTNmNTc1MzEzNjM1MzEzNDM3MzIzMjMyMzI=', '2022-05-02 12:22:02', 'YmI5MDg5ODg2NjJkMTY1YjdiMGJiYjYxZWRhMGExOTBmMmU4ZThkMzZhZjU2OWRkMzEzNjM1MzEzNDM3MzIzMjMyMzI=', '2022-05-16 12:02:02'),
(32, 1, 'YjA4YjI3NDAzNmU4YjBiYzRhY2ZiNmI3YTA3ZGI0ODIxNjQ5MmY4MjQzOGJlYTgyMzEzNjM1MzEzNTM0MzMzMzMwMzg=', '2022-05-03 08:06:48', 'YmU0YzY1ZjU5NzdlYjc1MGI2MWYwYWMxMmU0ZTU0ZGJlYWY3ZDkyNGRjMTdkYWYxMzEzNjM1MzEzNTM0MzMzMzMwMzg=', '2022-05-17 07:46:48'),
(33, 1, 'MWNlYjk0NDY3OTMxYmIyNTA1NjgzNGI1ODU1NGYzNGEzNGE0MTJiNjUwYmNiNWNkMzEzNjM1MzEzNTM1MzAzNDM4MzY=', '2022-05-03 10:06:26', 'YmRjYjhlYTU0ZjkzODIwY2I2NThiOWYzOWRmNTc5ODNiZjE2YWRiN2MxM2U5MDViMzEzNjM1MzEzNTM1MzAzNDM4MzY=', '2022-05-17 09:46:26'),
(34, 1, 'YTQ3YzkzNWVkYjUyYTJkYTkwZDljMjAwMDVjMGY3NTYzMDExMTU4MTk3MWVkOWEyMzEzNjM1MzEzNTM1MzEzMjM3MzA=', '2022-05-03 10:19:30', 'MWZhMzdmMDBiODY4MjBlZmZiZjRhMGUyMzFiNzMzZWFmOTRhYjJiYmQ4ZjEwOWQ0MzEzNjM1MzEzNTM1MzEzMjM3MzA=', '2022-05-17 09:59:30'),
(35, 1, 'ZDhiYWMyNzhmZTQ1NTIyOTVmODZlZGM5MTE4OWQzNzZiNTViNGNlYmE4N2IyMWJjMzEzNjM1MzEzNTM1MzEzNDMyMzg=', '2022-05-03 10:22:08', 'YjMxMWNmZTQ4MTAyZDMwNzljYjk0YzA1YWNjYjIxYzU5YzhhYWU1MTBjMDdhMmVjMzEzNjM1MzEzNTM1MzEzNDMyMzg=', '2022-05-17 10:02:08'),
(36, 1, 'YTUyMDczOTMwZDI5NDUwMDhmMjNkZjk0ODQ4ODgzMTEzOGZkMjlhMTBhZTE5YzNlMzEzNjM1MzEzNTM2MzMzMTMxMzU=', '2022-05-03 13:36:55', 'Yzk2NWM0YTcwMDVkY2YxOTAzMjkzYTMzZjQ5MDQxNTRjM2JhOWMxMzY2ZjNhZThhMzEzNjM1MzEzNTM2MzMzMTMxMzU=', '2022-05-17 13:16:55'),
(37, 1, 'YzFhYWNkNTUyMzg3ZWJkYjEwNzU2MDc1NjgxYTEyYTk5Mjc5NGQ1ODI4NjJhN2YxMzEzNjM1MzEzNzMxMzgzNzM4MzI=', '2022-05-05 08:51:22', 'NWI0NzBkOGM1YmMwZmQyNzE1MjM0Mzk5ZDhkNjA1NDk1NTA3Zjk0YzllY2RiYTllMzEzNjM1MzEzNzMxMzgzNzM4MzI=', '2022-05-19 08:31:22'),
(39, 1, 'OTk4YzljOWM2ZTMxNTNhODc5OTIxZGJiNWRiNmJjYWFhZDRjNGNmNDQ2MmI0N2YyMzEzNjM1MzEzNzMxMzgzODM0MzE=', '2022-05-05 08:52:21', 'NzM4MjEzZDg5MGY0YmNlNjhmYmI2ZTZjNDU1MTBkNzIxMzcwNjVjMjMxNmRkOGQ2MzEzNjM1MzEzNzMxMzgzODM0MzE=', '2022-05-19 08:32:21'),
(42, 2, 'MDZmNDM1NjBhYWRiNjA4YmY1YzUxYWJiZWY3MGY1MzBiZDYyZDEwYTVmMDhmZDdjMzEzNjM1MzEzNzMyMzAzNjMyMzA=', '2022-05-05 09:22:00', 'NjE4YTBkOTZjYzliNWFkMGNkZDJjYzE1ZjI4NGVkYTY0MWU2NmIzNjc3MTM3YzI2MzEzNjM1MzEzNzMyMzAzNjMyMzA=', '2022-05-19 09:02:00'),
(45, 1, 'YjMyYjhmYTYyZWNhZTg2YTE5YWVkZDNiNmUxYWExNzBiOWU5ZTEzZmI2NzAzZTY4MzEzNjM1MzEzODM0MzEzNjM3MzA=', '2022-05-06 15:14:30', 'NzJjNDE5Yjk3YjBlYmIzMWU5N2FjM2QyM2E5Y2Y2YzUwODJhODRkMGYyNWRhMWFiMzEzNjM1MzEzODM0MzEzNjM3MzA=', '2022-05-20 14:54:30'),
(46, 1, 'MGM3MzM2ODI3MDdlNTBlMTNlNTMyZjkzMTAyMjFkNjMzY2FkYmJmZmI5MWVkNDhiMzEzNjM1MzEzODM5MzMzODMwMzA=', '2022-05-07 05:43:20', 'OGViODUwNjczZjI3NDZlNTkzOWQyOTkwYTNjZTg5YjQ3MDE2OTRlOTU0Y2ZhNjEwMzEzNjM1MzEzODM5MzMzODMwMzA=', '2022-05-21 05:23:20'),
(47, 1, 'M2FkZTc2Y2FmMmY5YWVlNTJjYzdmN2NiNjdhZDE0YmRlYTIyOTRkY2I2Y2M2NDQxMzEzNjM1MzEzOTMzMzAzNjMxMzQ=', '2022-05-07 15:56:54', 'YmJmYWMwNzAxMDhkYTNlYjI0Zjc5N2U5ZGNjMDRmZGJkYWQyNjNhYmEwZTczYTFhMzEzNjM1MzEzOTMzMzAzNjMxMzQ=', '2022-05-21 15:36:54'),
(49, 1, 'NzE3M2U1NjA4ODBmZjg2N2UzMjkxZGQ0ZTU0M2Y0Mzc2NWQyM2E3YmQ0N2Y3Yzg0MzEzNjM1MzIzNTM0MzUzMzM4MzQ=', '2022-05-14 18:43:04', 'MDgzNjQ1MWM5MzFkZjE1NmEwYTRkMzJhOTg4ODY3ODg1MDJiNjI5NjdiMDgwYTJiMzEzNjM1MzIzNTM0MzUzMzM4MzQ=', '2022-05-28 18:23:04'),
(50, 1, 'OTQ3ZGExMDQ3MDVkODZlZmRiMDJhMWVjOGJjMDcyOGQxNWE0YWI2MThmNWJlNjMzMzEzNjM1MzIzNTM2MzEzMTM5MzE=', '2022-05-14 23:06:31', 'M2IyOGQ3YWY4MDE5MmQyYTljZDExZDlhYzc4YWJkMjczNGIzM2I4MjUwMmQ2Y2IwMzEzNjM1MzIzNTM2MzEzMTM5MzE=', '2022-05-28 22:46:31'),
(51, 1, 'NjdhZGNmODYxYTk0OWFiNWRhZTZkYjI4ZmEyZTVmZTQ1ZDgwODI4OGJiYzY2Nzg2MzEzNjM1MzIzNTM2MzEzNTM0MzI=', '2022-05-15 02:57:22', 'YmUwNDM5OTRmODk4ZTU2ODI3NDg3NGZjNTJlM2MxNjk0NGFmZGQ3ZDBjNGM4MzMwMzEzNjM1MzIzNTM2MzEzNTM0MzI=', '2022-05-29 02:37:22'),
(52, 1, 'NTgwYTA0M2QwMzM0YjQ4ZGJmMDYyOTFlMGIxNDc3MGJlN2IzNjhkYjc2N2UxNDkwMzEzNjM1MzIzNTM4MzIzNjM1MzQ=', '2022-05-15 05:04:14', 'MmUxNTgwNzU4YjE3ZDg1NjgwZTIyODEzZGU0OWU4NTc4ZjIxZjYwODJhNjczMTc4MzEzNjM1MzIzNTM4MzIzNjM1MzQ=', '2022-05-29 04:44:14'),
(53, 1, 'ODE0MjBiYmY0MjI3MjgyYTNmMDk4NWVjNDYxZTk0NjhkODA3Nzc2NTg3OGVkODUwMzEzNjM1MzIzNTM4MzIzNzM1MzM=', '2022-05-15 08:50:53', 'NzE0ZjMwOGJkNmQ1OTA0ZGYzMGJkNDljMDk0NTY4NzBiNDU4MTVjMzhhM2M2Njg0MzEzNjM1MzIzNTM4MzIzNzM1MzM=', '2022-05-29 08:30:53'),
(54, 1, 'MTlkMDE2MTkxOWE4NTg2MWU3MGQwYjZkNjRhNTdkZDk3YjU3ODgyODFhM2EzZGU5MzEzNjM1MzIzNzMyMzMzODMxMzI=', '2022-05-16 20:16:52', 'OGUxNDE1MTBlZGI4NjFjZDMwYTRmMGQ5ZjRhNTgzYWM4YmM2MzFkOGZiZmQzOWM0MzEzNjM1MzIzNzMyMzMzODMxMzI=', '2022-05-30 19:56:52'),
(56, 1, 'MDQyNzdiYzMzM2Q4YmYwMTI1OWJmYTYzY2VlZmIzZjE5ZDc3ZDY5ZTEyMmViYzczMzEzNjM1MzIzNzM2MzQzMDMyMzA=', '2022-05-17 07:27:00', 'MWQyNTEwNDBiNTA1YjQ0Y2FhNTcxZGFjNmY5YmRlYzg2YWQ5NWUxZWI3ZTJkMTYxMzEzNjM1MzIzNzM2MzQzMDMyMzA=', '2022-05-31 07:07:00'),
(57, 1, 'MjQxMTkwZDlhYWI4MDc5ZjZiNjg0MGQ0Nzg2ODI4MjI3ZWM3Mzc2MDhiOWEzZDI4MzEzNjM1MzIzNzM2MzQzMTMyMzE=', '2022-05-17 11:13:41', 'MDM5NjQzODAwMzA0YTEwYTFlYzRjZDc5YWFlZTlhZjUzMjMxODUyZWFiNjZkMGViMzEzNjM1MzIzNzM2MzQzMTMyMzE=', '2022-05-31 10:53:41'),
(58, 1, 'ZGMwMzI5ODhkM2Q4ZDlkNjQzNzhlMmExY2RmMzFjZWIyM2YwMmE5ZjQzZGZlZGE3MzEzNjM1MzIzODM0MzgzNTM2MzE=', '2022-05-18 06:56:01', 'YzVjZDYxZTkyMzZhZGZkOWU4MDRkZWExYmJmMjljYmJhNmFjMWRhYTRhOTNmNGQzMzEzNjM1MzIzODM0MzgzNTM2MzE=', '2022-06-01 06:36:01'),
(59, 1, 'MGI0ZDFlMDhiZjE0ZTc2NzJmMmQ4MmIwNDZhN2Q0NDIxMTYxMzgzMmNhOGYwYjdlMzEzNjM1MzIzODM0MzgzOTMzMzY=', '2022-05-18 10:47:16', 'YmVhMThhZWEzMTFhMTRkY2EzZDU3ZWQyY2Y5YzhiNWU4M2Y1N2NjMDYzZWJiOTdmMzEzNjM1MzIzODM0MzgzOTMzMzY=', '2022-06-01 10:27:16');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `email` varchar(256) DEFAULT NULL,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `picture` varchar(256) DEFAULT NULL,
  `class` varchar(256) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `followers` text DEFAULT NULL,
  `userCreatedDate` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `email`, `firstName`, `lastName`, `picture`, `class`, `description`, `followers`, `userCreatedDate`) VALUES
(1, 'rahulR', '12345678', 'rahul@mail.com', 'Rahul', 'Rimal', 'scaled_image_picker8746423382058716650.jpg', '15', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', '2,3', '2021-07-26 09:00:19'),
(2, 'shreeR', 'newTestPass', 'shree@mail.com', 'Srijana', 'Rimal', 'Share Your Learning.png', 'Bachelors', 'this is a testthis is a test this is a test this is a test this is a test this is a test', NULL, '2021-07-26 09:02:20'),
(3, 'surendraR', '12345678', 'surendra@mail.com', 'Surendra', 'Rana', 'portrait.jpg', '9', NULL, NULL, '2021-07-26 09:02:20'),
(23, 'ewTdfdfest,', 'sadkkkkass', 'test@mail.com', 'newFirst', 'newLast', NULL, 'CSIT', 'hy thereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee', NULL, '2021-10-29 03:25:58'),
(25, 'TestU', '12345678', NULL, 'test', 'last', NULL, NULL, NULL, NULL, '2022-05-11 15:53:42');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cartItem`
--
ALTER TABLE `cartItem`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `replies`
--
ALTER TABLE `replies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `accesstoken` (`accessToken`),
  ADD UNIQUE KEY `refreshtoken` (`refreshToken`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cartItem`
--
ALTER TABLE `cartItem`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `replies`
--
ALTER TABLE `replies`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `sessions`
--
ALTER TABLE `sessions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Session ID', AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

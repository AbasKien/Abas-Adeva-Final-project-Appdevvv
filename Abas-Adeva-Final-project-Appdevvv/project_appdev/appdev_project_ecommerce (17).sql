-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 13, 2024 at 09:40 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `appdev_project_ecommerce`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int NOT NULL,
  `userId` int NOT NULL,
  `productId` int NOT NULL,
  `quantity` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `userId`, `productId`, `quantity`, `created_at`) VALUES
(73, 13, 1, 3, '2024-12-09 02:33:52');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `contact_number` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `address` text COLLATE utf8mb4_general_ci NOT NULL,
  `payment_method` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` enum('pending','ship','delivered','cancelled','complete') COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `contact_number`, `address`, `payment_method`, `total_price`, `status`, `created_at`) VALUES
(35, 8, '09878768768', 'ilaya calapan city', 'cod', 166.00, 'complete', '2024-12-08 20:55:40'),
(36, 8, '09878768768', 'ilaya calapan city', 'cod', 148.00, 'complete', '2024-12-08 20:56:19'),
(37, 8, '09878768768', 'ilaya calapan city', 'cod', 618.00, 'complete', '2024-12-08 21:44:35'),
(38, 8, '09878768768', 'ilaya calapan city', 'cod', 758.00, 'complete', '2024-12-08 22:01:39'),
(39, 8, '09878768768', 'ilaya calapan city', 'cod', 242.00, 'cancelled', '2024-12-08 22:07:31'),
(40, 8, '09878768768', 'ilaya calapan city', 'cod', 238.00, 'complete', '2024-12-08 22:42:15'),
(41, 13, '09878768768', 'ilaya calapan city', 'cod', 157.00, 'complete', '2024-12-08 23:21:17'),
(42, 13, '09878768768', 'ilaya calapan city', 'cod', 148.00, 'cancelled', '2024-12-08 23:26:19'),
(43, 13, '09878768768', 'ilaya calapan city', 'cod', 148.00, 'complete', '2024-12-09 02:11:35'),
(44, 13, '09878768768', 'ilaya calapan city', 'cod', 148.00, 'complete', '2024-12-09 02:17:26'),
(45, 8, '09878768768', 'ilaya calapan city', 'cod', 112.00, 'complete', '2024-12-09 02:23:36'),
(46, 8, '09878768768', 'ilaya calapan city', 'cod', 135.00, 'complete', '2024-12-12 15:26:55'),
(47, 8, '09878768768', 'ilaya calapan city', 'cod', 98.00, 'complete', '2024-12-12 15:45:23'),
(48, 8, '09878768768', 'ilaya calapan city', 'cod', 106.00, 'complete', '2024-12-12 15:48:52'),
(49, 8, '09878768768', 'ilaya calapan city', 'cod', 139.00, 'complete', '2024-12-12 15:51:50'),
(50, 8, '09878768768', 'ilaya calapan city', 'cod', 76.00, 'complete', '2024-12-12 16:04:07'),
(51, 8, '09878768768', 'ilaya calapan city', 'cod', 233.00, 'complete', '2024-12-12 16:09:51'),
(52, 8, '09878768768', 'ilaya calapan city', 'cod', 165.00, 'cancelled', '2024-12-12 16:25:23'),
(53, 8, '38374747348', 'ilaya calapan city', 'cod', 145.00, 'complete', '2024-12-12 19:17:12'),
(54, 8, '38374747348', 'sdjkbaasdasdas\nwqss', 'cod', 93.00, 'cancelled', '2024-12-12 19:20:00'),
(55, 8, '09878768768', 'ilaya calapan city', 'cod', 93.00, 'delivered', '2024-12-12 19:22:54'),
(56, 8, '09878768768', 'ilaya calapan city', 'cod', 163.00, 'complete', '2024-12-12 19:55:11'),
(57, 8, '09878768768', 'ilaya calapan city', 'cod', 284.00, 'cancelled', '2024-12-12 20:03:33'),
(58, 8, '09878768768', 'ilaya calapan city', 'cod', 163.00, 'complete', '2024-12-12 20:12:17'),
(59, 8, '09878768768', 'ilaya calapan city', 'cod', 90.00, 'delivered', '2024-12-12 22:04:36');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int NOT NULL,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(42, 35, 1, 12, 9.00),
(43, 36, 1, 10, 9.00),
(44, 37, 2, 70, 8.00),
(45, 38, 3, 20, 35.00),
(46, 39, 2, 23, 8.00),
(47, 40, 1, 20, 9.00),
(48, 41, 1, 11, 9.00),
(49, 42, 1, 10, 9.00),
(50, 43, 1, 10, 9.00),
(51, 44, 1, 10, 9.00),
(52, 45, 1, 6, 9.00),
(53, 46, 2, 4, 8.00),
(54, 46, 1, 5, 9.00),
(55, 47, 2, 5, 8.00),
(56, 48, 2, 6, 8.00),
(57, 49, 1, 9, 9.00),
(58, 50, 1, 2, 9.00),
(59, 51, 3, 5, 35.00),
(60, 52, 10, 1, 56.00),
(61, 52, 2, 2, 8.00),
(62, 52, 3, 1, 35.00),
(63, 53, 2, 1, 8.00),
(64, 53, 1, 1, 9.00),
(65, 53, 3, 2, 35.00),
(66, 54, 3, 1, 35.00),
(67, 55, 3, 1, 35.00),
(68, 56, 3, 3, 35.00),
(69, 57, 3, 2, 35.00),
(70, 57, 4, 2, 78.00),
(71, 58, 3, 3, 35.00),
(72, 59, 2, 4, 8.00);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `stock` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `image_url`, `stock`, `created_at`) VALUES
(1, 'Pencil', 'For writing', 9.00, '/uploads/1733058441762-pencil.jpg', 121, '2024-12-01 13:07:21'),
(2, 'White Folder', 'Long', 8.00, '/uploads/1733652884213-8.jpg', 120, '2024-12-02 13:44:40'),
(3, 'Paper Clip', 'Per Box', 35.00, '/uploads/1733221687898-chalk.jpg', 80, '2024-12-03 10:28:07'),
(4, 'Gtech', 'black', 78.00, '/uploads/1733586328524-Gtech.jpg', 101, '2024-12-07 15:45:28'),
(5, ' Brown Envelop', 'Short', 4.00, '/uploads/1733599834336-envelop.jpg', 104, '2024-12-07 19:30:34'),
(6, 'Manila Paper', 'Brown', 6.00, '/uploads/1733653047605-7 manila paper.jpg', 116, '2024-12-08 04:06:48'),
(7, 'Short Bond Paper', 'Hard Copy', 169.00, '/uploads/1733653087403-280.webp', 150, '2024-12-08 10:18:07'),
(8, 'Correction Tape', 'Medium', 35.00, '/uploads/1733653120706-35.jpg', 50, '2024-12-08 10:18:40'),
(9, 'Notebook', 'Per piece', 23.00, '/uploads/1733653194336-23.jpg', 60, '2024-12-08 10:19:54'),
(10, 'Diploma Holder', 'A4', 56.00, '/uploads/1733653293538-30.jpg', 80, '2024-12-08 10:21:33'),
(11, 'Packing Tape', 'Clear', 48.00, '/uploads/1733653376445-7a2a18b05fbc6a10bd30e1a9325cdc3d.jpg', 130, '2024-12-08 10:22:56'),
(12, 'Long Bond Paper', 'Hard Copy', 210.00, '/uploads/1733653546451-280.webp', 110, '2024-12-08 10:25:46'),
(13, 'A4 Bond Paper', 'Hard Copy', 189.00, '/uploads/1733653636628-280.webp', 120, '2024-12-08 10:27:16'),
(14, 'Scissors', 'Medium', 60.00, '/uploads/1733653705356-45.jpg', 50, '2024-12-08 10:28:25'),
(15, 'Glue', '40g', 15.00, '/uploads/1733653789754-OIP.jpg', 140, '2024-12-08 10:29:49'),
(16, 'Black ink', 'Epson', 101.00, '/uploads/1733653858293-329.png', 130, '2024-12-08 10:30:58'),
(17, ' Yellow ink', 'Epson', 101.00, '/uploads/1733653876122-329.png', 40, '2024-12-08 10:31:16'),
(18, 'Cyan ink', 'Epson', 101.00, '/uploads/1733653892370-329.png', 39, '2024-12-08 10:31:32'),
(19, 'Magenta ink', 'Epson', 98.00, '/uploads/1733653910517-329.png', 45, '2024-12-08 10:31:50'),
(33, 'Chalk', 'Writing', 5.00, '/uploads/1734021133327-61a0b63c-4445-4ff2-b246-ade87f2bca0e.jpg', 100, '2024-12-12 16:32:13');

-- --------------------------------------------------------

--
-- Table structure for table `product_quantity_logs`
--

CREATE TABLE `product_quantity_logs` (
  `id` int NOT NULL,
  `product_id` int NOT NULL,
  `previous_quantity` int NOT NULL,
  `quantity_changed` int NOT NULL,
  `new_quantity` int NOT NULL,
  `reason` enum('Restock','Order','Return') COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_quantity_logs`
--

INSERT INTO `product_quantity_logs` (`id`, `product_id`, `previous_quantity`, `quantity_changed`, `new_quantity`, `reason`, `created_at`) VALUES
(50, 1, 0, 5, 5, 'Restock', '2024-12-08 06:27:42'),
(51, 1, 5, 10, 15, 'Restock', '2024-12-08 06:27:48'),
(52, 2, 0, 5, 5, 'Restock', '2024-12-08 06:31:31'),
(53, 3, 0, 5, 5, 'Restock', '2024-12-08 06:34:44'),
(54, 5, 0, 4, 4, 'Restock', '2024-12-08 06:34:49'),
(55, 4, 0, 4, 4, 'Restock', '2024-12-08 06:34:52'),
(56, 6, 0, 6, 6, 'Restock', '2024-12-08 06:34:57'),
(57, 1, 12, 5, 17, 'Restock', '2024-12-08 06:35:22'),
(58, 2, 5, 5, 10, 'Restock', '2024-12-08 06:40:44'),
(59, 4, 4, 100, 104, 'Restock', '2024-12-08 06:41:34'),
(60, 1, 17, -2, 15, 'Order', '2024-12-08 06:45:22'),
(61, 1, 17, -2, 15, 'Order', '2024-12-08 07:35:45'),
(62, 1, 15, 5, 20, 'Restock', '2024-12-08 07:37:11'),
(63, 1, 20, 5, 25, 'Restock', '2024-12-08 08:16:02'),
(64, 7, 0, 150, 150, 'Restock', '2024-12-08 10:33:50'),
(65, 8, 0, 50, 50, 'Restock', '2024-12-08 10:34:03'),
(66, 9, 0, 60, 60, 'Restock', '2024-12-08 10:34:08'),
(67, 10, 0, 80, 80, 'Restock', '2024-12-08 10:34:15'),
(68, 11, 0, 30, 30, 'Restock', '2024-12-08 10:34:22'),
(69, 12, 0, 110, 110, 'Restock', '2024-12-08 10:34:32'),
(70, 13, 0, 120, 120, 'Restock', '2024-12-08 10:34:39'),
(71, 14, 0, 50, 50, 'Restock', '2024-12-08 10:34:46'),
(72, 15, 0, 40, 40, 'Restock', '2024-12-08 10:34:53'),
(73, 16, 0, 30, 30, 'Restock', '2024-12-08 10:35:01'),
(74, 17, 0, 40, 40, 'Restock', '2024-12-08 10:35:08'),
(75, 18, 0, 39, 39, 'Restock', '2024-12-08 10:35:13'),
(76, 19, 0, 45, 45, 'Restock', '2024-12-08 10:35:20'),
(77, 2, 10, -2, 8, 'Order', '2024-12-08 10:36:20'),
(78, 2, 8, 100, 108, 'Restock', '2024-12-08 14:51:29'),
(79, 5, 4, 100, 104, 'Restock', '2024-12-08 14:51:40'),
(80, 3, 5, 100, 105, 'Restock', '2024-12-08 14:51:47'),
(81, 6, 6, 10, 16, 'Restock', '2024-12-08 15:20:23'),
(84, 1, 20, 30, 50, 'Restock', '2024-12-08 17:59:14'),
(85, 1, 40, 10, 50, 'Restock', '2024-12-08 18:11:19'),
(86, 1, 30, -10, 20, 'Order', '2024-12-08 18:16:15'),
(87, 1, 20, -10, 10, 'Order', '2024-12-08 18:18:09'),
(88, 1, 20, 100, 120, 'Restock', '2024-12-08 18:21:43'),
(89, 1, 120, -20, 100, 'Order', '2024-12-08 18:22:41'),
(90, 2, 108, -8, 100, 'Order', '2024-12-08 18:26:14'),
(91, 1, 100, 1, 101, 'Restock', '2024-12-08 19:17:58'),
(92, 2, 100, -1, 99, 'Order', '2024-12-08 20:00:26'),
(93, 1, 101, 9, 110, 'Restock', '2024-12-08 20:02:08'),
(94, 1, 110, -1, 109, 'Order', '2024-12-08 20:12:17'),
(95, 1, 109, -9, 100, 'Order', '2024-12-08 20:20:35'),
(96, 1, 100, -10, 90, 'Order', '2024-12-08 20:37:15'),
(97, 1, 68, 2, 70, 'Restock', '2024-12-08 21:23:45'),
(98, 1, 70, 10, 80, 'Restock', '2024-12-08 21:26:14'),
(99, 1, 80, 1, 81, 'Restock', '2024-12-08 21:36:44'),
(100, 1, 81, 1, 82, 'Restock', '2024-12-08 21:38:51'),
(102, 1, 92, -10, 82, 'Order', '2024-12-08 21:43:07'),
(103, 1, 94, -12, 82, 'Order', '2024-12-08 21:44:01'),
(104, 2, 99, -70, 29, 'Order', '2024-12-08 21:45:11'),
(105, 3, 105, -20, 85, 'Order', '2024-12-08 22:04:17'),
(106, 1, 82, 1, 83, 'Restock', '2024-12-08 22:18:33'),
(107, 1, 83, 8, 91, 'Restock', '2024-12-08 22:19:28'),
(108, 1, 91, -20, 71, 'Order', '2024-12-08 22:42:59'),
(109, 2, 29, 100, 129, 'Restock', '2024-12-08 22:43:30'),
(110, 1, 71, 30, 101, 'Restock', '2024-12-08 22:43:37'),
(111, 6, 16, 100, 116, 'Restock', '2024-12-08 22:43:42'),
(112, 11, 30, 100, 130, 'Restock', '2024-12-08 22:43:49'),
(113, 15, 40, 100, 140, 'Restock', '2024-12-08 22:44:00'),
(114, 16, 30, 100, 130, 'Restock', '2024-12-08 22:44:04'),
(115, 1, 101, -11, 90, 'Order', '2024-12-08 23:23:01'),
(116, 1, 90, 10, 100, 'Restock', '2024-12-08 23:23:31'),
(119, 1, 100, 10, 110, 'Restock', '2024-12-08 23:28:52'),
(120, 1, 110, -10, 100, 'Order', '2024-12-09 02:16:13'),
(121, 1, 100, -10, 90, 'Order', '2024-12-09 02:17:49'),
(122, 1, 90, 10, 100, 'Restock', '2024-12-09 02:20:30'),
(123, 1, 100, -6, 94, 'Order', '2024-12-09 02:23:55'),
(125, 2, 129, -4, 125, 'Order', '2024-12-12 15:27:41'),
(126, 1, 94, -5, 89, 'Order', '2024-12-12 15:27:41'),
(127, 2, 125, -5, 120, 'Order', '2024-12-12 15:46:30'),
(128, 2, 120, -6, 114, 'Order', '2024-12-12 15:49:16'),
(129, 1, 89, -9, 80, 'Order', '2024-12-12 15:52:16'),
(130, 1, 80, -2, 78, 'Order', '2024-12-12 16:04:30'),
(131, 3, 85, -5, 80, 'Order', '2024-12-12 16:10:13'),
(132, 33, 0, 100, 100, 'Restock', '2024-12-12 16:32:35'),
(133, 1, 78, 2, 80, 'Restock', '2024-12-12 17:25:50'),
(134, 2, 114, -1, 113, 'Order', '2024-12-12 19:18:03'),
(135, 1, 80, -1, 79, 'Order', '2024-12-12 19:18:03'),
(136, 3, 80, -2, 78, 'Order', '2024-12-12 19:18:03'),
(137, 3, 72, -3, 69, 'Order', '2024-12-12 20:12:53'),
(138, 1, 79, 11, 90, 'Restock', '2024-12-12 20:30:28'),
(140, 3, 72, -3, 69, 'Order', '2024-12-12 20:45:12'),
(141, 1, 90, 11, 101, 'Restock', '2024-12-12 20:45:35'),
(142, 2, 113, 11, 124, 'Restock', '2024-12-12 20:45:45'),
(143, 3, 69, 11, 80, 'Restock', '2024-12-12 20:45:58'),
(144, 1, 101, 4, 105, 'Restock', '2024-12-12 20:47:26'),
(145, 1, 105, 5, 110, 'Restock', '2024-12-12 20:47:39'),
(146, 1, 110, 2, 112, 'Restock', '2024-12-12 20:49:14'),
(147, 1, 112, 1, 113, 'Restock', '2024-12-12 20:53:33'),
(148, 1, 113, 1, 114, 'Restock', '2024-12-12 20:55:04'),
(149, 1, 114, 1, 115, 'Restock', '2024-12-12 20:56:02'),
(150, 1, 115, 1, 116, 'Restock', '2024-12-12 20:57:39'),
(151, 1, 116, 1, 117, 'Restock', '2024-12-12 20:59:49'),
(152, 1, 117, 3, 120, 'Restock', '2024-12-12 21:07:06'),
(154, 1, 120, 1, 121, 'Restock', '2024-12-12 21:13:40');

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `fullname` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`id`, `user_id`, `fullname`, `email`, `phone`, `address`, `created_at`, `updated_at`) VALUES
(6, 6, 'Kien Eros M. Abas', 'd64853974@gmail.com', NULL, NULL, '2024-12-08 14:17:53', '2024-12-08 14:17:53'),
(8, 8, 'Kien Eros M. Abas', 'abaskien@gmail.com', '09878768768', 'ilaya calapan city', '2024-12-08 20:53:37', '2024-12-08 20:55:24'),
(13, 13, 'Kien Eros M. Abas', 'med696200@gmail.com', '09878768768', 'ilaya calapan city', '2024-12-08 23:18:08', '2024-12-08 23:20:54');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int UNSIGNED NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `fullname` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `role` enum('admin','client') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'client',
  `otp` varchar(6) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `otp_expires` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `fullname`, `email`, `password`, `is_verified`, `created_at`, `updated_at`, `role`, `otp`, `otp_expires`) VALUES
(6, 'Admin', 'd64853974@gmail.com', '$2b$10$abNdJAD8X.2VsH/bDyeJxOYYWntl2RatSajjBTZXUVghQqlEuB4Re', 1, '2024-12-08 14:17:53', '2024-12-12 20:20:33', 'admin', '745756', '2024-12-12 20:30:33'),
(8, 'Kien Eros M. Abas', 'abaskien@gmail.com', '$2b$10$CDT4aX9X.DXX.YTgDwbIO.n5ir.mYHsKk0P3Kw3MSUOrdSPtjEwJe', 1, '2024-12-08 20:53:37', '2024-12-08 23:00:30', 'client', NULL, NULL),
(13, 'Kien Eros M. Abas', 'med696200@gmail.com', '$2b$10$ZW1r2NuoydfgokLWRNZsmersnmNWZ/TYIOkY2kjuV3VqnJzo0dszm', 1, '2024-12-08 23:18:08', '2024-12-12 15:25:53', 'client', '527160', '2024-12-12 15:35:54');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`),
  ADD KEY `productId` (`productId`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_quantity_logs`
--
ALTER TABLE `product_quantity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`session_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `product_quantity_logs`
--
ALTER TABLE `product_quantity_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=155;

--
-- AUTO_INCREMENT for table `profiles`
--
ALTER TABLE `profiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `product_quantity_logs`
--
ALTER TABLE `product_quantity_logs`
  ADD CONSTRAINT `product_quantity_logs_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `profiles`
--
ALTER TABLE `profiles`
  ADD CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

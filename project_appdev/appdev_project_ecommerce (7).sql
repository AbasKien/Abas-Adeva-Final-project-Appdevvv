-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 30, 2024 at 02:33 PM
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
) ENGINE=InnoDB DEFAULT CHARSET=armscii8;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `address` text NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` varchar(20) DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `contact_number`, `address`, `payment_method`, `total_price`, `status`, `created_at`) VALUES
(1, 21, '09878768768', 'ilaya calapan city', 'cod', 88.00, 'cancelled', '2024-11-30 13:12:43'),
(2, 21, '09878768768', 'ilaya calapan city', 'cod', 823.00, 'pending', '2024-11-30 13:19:48'),
(3, 21, '09150232461', 'ilaya calapan city', 'cod', 208.00, 'pending', '2024-11-30 13:35:47'),
(4, 21, '09150232461', 'ilaya calapan city', 'check_payment', 208.00, 'pending', '2024-11-30 13:38:48'),
(5, 21, '09150232461', 'ilaya calapan city', 'check_payment', 208.00, 'pending', '2024-11-30 13:40:30'),
(6, 21, '09150232461', 'ilaya calapan city', 'check_payment', 208.00, 'pending', '2024-11-30 13:43:45'),
(7, 21, '09150232461', 'ilaya calapan city', 'cod', 208.00, 'pending', '2024-11-30 13:52:14'),
(8, 21, '09150232461', 'ilaya calapan city', 'check_payment', 208.00, 'pending', '2024-11-30 14:03:11'),
(9, 21, '09150232461', 'ilaya calapan city', 'check_payment', 208.00, 'pending', '2024-11-30 14:14:10');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int NOT NULL,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`, `created_at`) VALUES
(1, 1, 1, 2, 15.00, '2024-11-30 13:12:43'),
(2, 2, 1, 1, 15.00, '2024-11-30 13:19:48'),
(3, 2, 3, 5, 150.00, '2024-11-30 13:19:48'),
(4, 3, 4, 1, 150.00, '2024-11-30 13:35:47'),
(5, 4, 3, 1, 150.00, '2024-11-30 13:38:48'),
(6, 5, 3, 1, 150.00, '2024-11-30 13:40:30'),
(7, 6, 3, 1, 150.00, '2024-11-30 13:43:45'),
(8, 7, 3, 1, 150.00, '2024-11-30 13:52:14'),
(9, 8, 3, 1, 150.00, '2024-11-30 14:03:11'),
(10, 9, 3, 1, 150.00, '2024-11-30 14:14:10');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `stock` int DEFAULT '0',
  `stock_limit` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=armscii8;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `image_url`, `stock`, `stock_limit`, `created_at`) VALUES
(1, 'Pencil', 'Pencil', 15.00, '/uploads/1732909593108-pencil.jpg', 99, NULL, '2024-11-29 19:46:33'),
(3, 'bandpaper', 'bandpaper', 150.00, '/uploads/1732911855296-bondpapers.gif', 89, NULL, '2024-11-29 20:24:15'),
(4, 'notebook', 'a', 150.00, '/uploads/1732915212077-notebook.jpg', 99, NULL, '2024-11-29 21:20:12'),
(5, 'JEANELLE BALAY', 'aa', 1000.00, '/uploads/1732915588394-chalk.jpg', 1, NULL, '2024-11-29 21:26:28'),
(6, 'e', 'a', 22.00, '/uploads/1732915893790-3edf533a-ae1f-4af9-83e4-6f82bb6bd8fb.jpg', 11, NULL, '2024-11-29 21:31:33');

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `fullname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=armscii8;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`id`, `user_id`, `fullname`, `email`, `phone`, `address`, `created_at`, `updated_at`) VALUES
(3, 21, 'Kien Eros M. Abas', 'abaskien@gmail.com', '09150232461', 'ilaya calapan city', '2024-11-30 13:10:09', '2024-11-30 13:32:04');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int UNSIGNED NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=armscii8;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`session_id`, `expires`, `data`) VALUES
('HRUSU6wBE1lszAMrhKgwAPMW2MTSMvWH', 1733063475, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2024-12-01T14:00:18.969Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"userId\":21,\"role\":\"client\",\"email\":\"abaskien@gmail.com\"}'),
('Mm7nyR8Ak9JmD80tg6b5tKO7ryCofEqI', 1733058327, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2024-12-01T12:58:19.141Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"userId\":20,\"role\":\"client\",\"email\":\"abaskien@gmail.com\"}'),
('YGyYBTTGXTKoKUOmNghOqRScVhBsoPSh', 1733061134, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2024-12-01T13:49:11.590Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"userId\":21,\"role\":\"client\",\"email\":\"abaskien@gmail.com\"}');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `fullname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `verification_token` varchar(255) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `role` enum('admin','client') NOT NULL DEFAULT 'client'
) ENGINE=InnoDB DEFAULT CHARSET=armscii8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `fullname`, `email`, `password`, `verification_token`, `is_verified`, `created_at`, `updated_at`, `role`) VALUES
(17, 'mac', 'adevamac2004@gmail.com', '$2b$10$ot4WAasxF51.1POFVaoaveYAZsWoYAg.SAg.YE4hsCkjKDyrp6pvC', NULL, 1, '2024-11-15 20:09:48', '2024-11-15 20:18:13', 'admin'),
(21, 'Kien Eros M. Abas', 'abaskien@gmail.com', '$2b$10$rpBb./vZtspmJ8NnpbJq8.hrEkpTsa9U5z/wOjpCD5FZPCFBVEWhK', '08c50d15174ca6db26cd7093ce9a8394ae61313e20cb36581ae521b03e284cc8', 1, '2024-11-30 13:10:09', '2024-11-30 13:10:26', 'client');

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `profiles`
--
ALTER TABLE `profiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

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
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `profiles`
--
ALTER TABLE `profiles`
  ADD CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

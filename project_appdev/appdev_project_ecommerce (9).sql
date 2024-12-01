-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 01, 2024 at 09:16 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

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
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `payment_method` enum('check_payment','cod') NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `order_status` enum('pending','completed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `name`, `address`, `payment_method`, `total_price`, `order_status`, `created_at`) VALUES
(3, 'Kien Eros M. Abas', 'sdjkbaasdasdas\nwqss', 'cod', 1222.00, 'pending', '2024-11-19 18:36:09'),
(5, 'Kien Eros M. Abas', 'sdjkbaasdasdas\nwqss', 'check_payment', 200.00, 'pending', '2024-11-24 14:38:27'),
(9, 'JEANELLE BALAY', 'sdjkbaasdasdas', 'cod', 158.00, 'pending', '2024-11-24 15:46:24');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `stock` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `image_url`, `stock`, `created_at`) VALUES
(22, 'Manila Paper', 'brown', 7.00, '/uploads/1733038142790-7 manila paper.jpg', 56, '2024-12-01 07:29:02'),
(23, 'Brown Envelope', 'Short', 5.00, '/uploads/1733038172612-4.jpg', 30, '2024-12-01 07:29:32'),
(24, 'Bond Paper Rim', 'A4', 280.00, '/uploads/1733038200596-280.webp', 50, '2024-12-01 07:30:00'),
(25, 'Gtech black ink', 'per piece', 68.00, '/uploads/1733038244710-65.jpg', 40, '2024-12-01 07:30:44');

-- --------------------------------------------------------

--
-- Table structure for table `product_quantity_logs`
--

CREATE TABLE `product_quantity_logs` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `previous_quantity` int(11) NOT NULL,
  `quantity_changed` int(11) NOT NULL,
  `new_quantity` int(11) NOT NULL,
  `reason` enum('Restock','Order','Return') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_quantity_logs`
--

INSERT INTO `product_quantity_logs` (`id`, `product_id`, `previous_quantity`, `quantity_changed`, `new_quantity`, `reason`, `created_at`) VALUES
(28, 22, 0, 50, 50, 'Restock', '2024-12-01 07:30:50'),
(29, 23, 0, 30, 30, 'Restock', '2024-12-01 07:30:58'),
(30, 24, 0, 50, 50, 'Restock', '2024-12-01 07:31:05'),
(31, 25, 0, 40, 40, 'Restock', '2024-12-01 07:31:09'),
(32, 22, 50, 6, 56, 'Restock', '2024-12-01 08:14:54');

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int(11) UNSIGNED NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`session_id`, `expires`, `data`) VALUES
('YyiZenK7ORxlxcYdCPsK9j4JxWc0_mJg', 1733127298, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2024-12-02T06:30:41.922Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"userId\":17,\"role\":\"admin\"}');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `fullname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `verification_token` varchar(255) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `role` enum('admin','client') NOT NULL DEFAULT 'client'
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `fullname`, `email`, `password`, `verification_token`, `is_verified`, `created_at`, `updated_at`, `role`) VALUES
(17, 'mac', 'adevamac2004@gmail.com', '$2b$10$ot4WAasxF51.1POFVaoaveYAZsWoYAg.SAg.YE4hsCkjKDyrp6pvC', NULL, 1, '2024-11-16 04:09:48', '2024-11-27 14:05:36', 'admin'),
(20, 'JEANELLE BALAY', 'abaskien@gmail.com', '$2b$10$D0m2ElthI.a52O3a9oQk0.ULVmxoYfadPqd3Vjd2wEgaJ.ilcZAF.', NULL, 1, '2024-11-24 18:49:47', '2024-11-24 18:49:57', 'client');

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
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_quantity_logs`
--
ALTER TABLE `product_quantity_logs`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `product_quantity_logs`
--
ALTER TABLE `product_quantity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `profiles`
--
ALTER TABLE `profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

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
-- Constraints for table `profiles`
--
ALTER TABLE `profiles`
  ADD CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

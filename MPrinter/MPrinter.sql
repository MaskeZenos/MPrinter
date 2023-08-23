CREATE TABLE `MPrinter` (
  `id` int(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `grade` int(10) NOT NULL DEFAULT 1,
  `paper` int(3) NOT NULL DEFAULT 100,
  `moneyinside` int(10) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


ALTER TABLE `MPrinter`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `MPrinter`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
COMMIT;

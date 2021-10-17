-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-10-2021 a las 22:59:47
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `geniat`
--
CREATE DATABASE IF NOT EXISTS `geniat` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `geniat`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `sp_actualiza_publicacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualiza_publicacion` (IN `p_sTitulo` VARCHAR(100), IN `p_sDescripcion` VARCHAR(100), IN `p_sCorreo` VARCHAR(100), IN `p_sPassword` VARCHAR(100), IN `p_nIdPublicacion` INT)  BEGIN
DECLARE result_msg    TEXT;
	DECLARE result_code INT DEFAULT 0;
     
	DECLARE EXIT HANDLER FOR 1452 SELECT 'Usuario no existe' AS result_msg, result_code;
    
	SET @p_nIdUsuario = 0;
    SELECT `nIdUsuario` INTO  @p_nIdUsuario   FROM `usuarios` WHERE sCorreo=p_sCorreo AND sPassword=p_sPassword;
    
    IF @p_nIdUsuario > 0 THEN
		UPDATE plublicacion SET sTitulo =p_sTitulo, sDescripcion=p_sDescripcion WHERE nIdPublicacion=p_nIdPublicacion;
        
        IF ROW_COUNT() > 0 THEN
			SET result_msg = 'Update Exitoso.';
			SET result_code = 1;
		ELSE
			SET result_msg = 'Datos ya Actualizados.';
			SET result_code = 0;
		END IF;
	ELSE 
		SET result_msg = 'Token invalido';
			SET result_code = 0;
    END IF;
	    
    SELECT result_msg, result_code;

END$$

DROP PROCEDURE IF EXISTS `sp_eliminar_publicacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_publicacion` (IN `p_sCorreo` VARCHAR(100), IN `p_sPassword` VARCHAR(100), IN `p_nIdPublicacion` INT)  BEGIN
	DECLARE result_msg    TEXT;
	DECLARE result_code INT DEFAULT 0;
     
	DECLARE EXIT HANDLER FOR 1452 SELECT 'Usuario no existe' AS result_msg, result_code;
    
	SET @p_nIdUsuario = 0;
    SELECT `nIdUsuario` INTO  @p_nIdUsuario   FROM `usuarios` WHERE sCorreo=p_sCorreo AND sPassword=p_sPassword;
    
    IF @p_nIdUsuario > 0 THEN
		UPDATE plublicacion SET nStatus =0 WHERE nIdPublicacion=p_nIdPublicacion;
        
        IF ROW_COUNT() > 0 THEN
			SET result_msg = 'Eliminado Exitoso.';
			SET result_code = 1;
		ELSE
			SET result_msg = 'Datos ya Eliminado o no Existente';
			SET result_code = 0;
		END IF;
	ELSE 
		SET result_msg = 'Token invalido';
			SET result_code = 0;
    END IF;
	    
    SELECT result_msg, result_code;
END$$

DROP PROCEDURE IF EXISTS `sp_insert_publicacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_publicacion` (IN `p_sTitulo` VARCHAR(100), IN `p_sDescripcion` VARCHAR(100), IN `p_sCorreo` VARCHAR(100), IN `p_sPassword` VARCHAR(100))  BEGIN
	DECLARE result_msg    TEXT;
	DECLARE result_code INT DEFAULT 0;
     
	DECLARE EXIT HANDLER FOR 1452 SELECT 'Usuario no existe' AS result_msg, result_code;
    
	SET @p_nIdUsuario = 0;
    SELECT `nIdUsuario` INTO  @p_nIdUsuario   FROM `usuarios` WHERE sCorreo=p_sCorreo AND sPassword=p_sPassword;
    
    IF @p_nIdUsuario > 0 THEN
		INSERT INTO `plublicacion`(`nIdPublicacion`, `nIdUsuario`, `sTitulo`, `sDescripcion`, `dFecRegistro`, `dFecMovimiento`) 
		VALUES (null,@p_nIdUsuario,p_sTitulo,p_sDescripcion,curdate(),now());
        
        IF ROW_COUNT() > 0 THEN
			SET result_msg = 'Insert Exitoso.';
			SET result_code = last_insert_id();
		ELSE
			SET result_msg = 'Error al insertar.';
			SET result_code = 0;
		END IF;
	ELSE 
		SET result_msg = 'Token invalido';
			SET result_code = 0;
    END IF; 

    SELECT result_msg, result_code;
END$$

DROP PROCEDURE IF EXISTS `sp_inser_publicacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inser_publicacion` (IN `p_nIdUsuario` INT, IN `p_sTitulo` VARCHAR(100), IN `p_sDescripcion` VARCHAR(100))  BEGIN
	DECLARE result_msg    TEXT;
	DECLARE result_code INT DEFAULT 0;
    
	DECLARE EXIT HANDLER FOR 1452 SELECT 'Usuario no existe' AS result_msg, result_code;
    
	INSERT INTO `plublicacion`(`nIdPublicacion`, `nIdUsuario`, `sTitulo`, `sDescripcion`, `dFecRegistro`, `dFecMovimiento`) 
    VALUES (null,p_nIdUsuario,p_sTitulo,p_sDescripcion,curdate(),now());
    
    IF ROW_COUNT() > 0 THEN
		SET result_msg = 'Insert Exitoso.';
        SET result_code = 1;
	ELSE
		SET result_msg = 'Error al insertar.';
        SET result_code = 0;
	END IF;
    
    SELECT result_msg, result_code;
    
END$$

DROP PROCEDURE IF EXISTS `sp_login`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login` (IN `p_sCorreo` VARCHAR(100), IN `p_sPassword` VARCHAR(100))  BEGIN
	SELECT `nIdUsuario`, `sNombre`, `sApellido`, `sCorreo`, `sPassword`, `nRol` 
    FROM `usuarios` WHERE sCorreo=p_sCorreo AND sPassword=p_sPassword;
END$$

DROP PROCEDURE IF EXISTS `sp_registro_usuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registro_usuario` (IN `p_sNombre` VARCHAR(100), IN `p_sApellido` VARCHAR(100), IN `p_sCorreo` VARCHAR(100), IN `p_sPassword` VARCHAR(100), IN `p_nRol` INT)  BEGIN
	DECLARE result_msg    TEXT;
	DECLARE result_code INT DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR 1062 SELECT 'Correo duplicado' AS result_msg, result_code;
    DECLARE EXIT HANDLER FOR 1452 SELECT 'Rol no existe' AS result_msg, result_code;

	INSERT INTO `usuarios`(`nIdUsuario`, `sNombre`, `sApellido`, `sCorreo`, `sPassword`, `nRol`, `dFecCreacion`, `sFecMovimiento`) 
    VALUES (NULL,p_sNombre,p_sApellido,p_sCorreo,p_sPassword,p_nRol,NOW(),NOW());

    IF ROW_COUNT() > 0 THEN
		SET result_msg = 'Insert Exitoso.';
        SET result_code = 1;
	ELSE
		SET result_msg = 'Error al insertar.';
        SET result_code = 0;
	END IF;
    
    SELECT result_msg, result_code;
END$$

DROP PROCEDURE IF EXISTS `sp_select_publicacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_select_publicacion` (IN `p_sCorreo` VARCHAR(100), IN `p_sPassword` VARCHAR(100))  BEGIN
DECLARE result_msg    TEXT;
	DECLARE result_code INT DEFAULT 0;
     
	DECLARE EXIT HANDLER FOR 1452 SELECT 'Usuario no existe' AS result_msg, result_code;
    
	SET @p_nIdUsuario = 0;
    SELECT `nIdUsuario` INTO  @p_nIdUsuario   FROM `usuarios` WHERE sCorreo=p_sCorreo AND sPassword=p_sPassword;
    
    SELECT pub.sTitulo,pub.sDescripcion as sDesPublicacion,pub.dFecRegistro,concat(usu.sNombre,' ',usu.sApellido) as nombre,rol.nIdRol,rol.sDescripcion FROM `plublicacion` AS pub 
	INNER JOIN usuarios AS usu ON pub.nIdUsuario=usu.nIdUsuario
	INNER JOIN cat_rol AS rol ON usu.nRol=rol.nIdRol
	WHERE usu.nIdUsuario=@p_nIdUsuario and nStatus=1;	

			
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_rol`
--

DROP TABLE IF EXISTS `cat_rol`;
CREATE TABLE `cat_rol` (
  `nIdRol` int(11) NOT NULL,
  `sDescripcion` varchar(100) NOT NULL,
  `dFecCreacion` datetime NOT NULL,
  `sFecMovimiento` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `cat_rol`
--

INSERT INTO `cat_rol` (`nIdRol`, `sDescripcion`, `dFecCreacion`, `sFecMovimiento`) VALUES
(1, 'Rol Basico', '2021-10-16 00:50:52', '2021-10-16 05:51:10'),
(2, 'Rol Medio', '2021-10-16 00:50:52', '2021-10-16 05:51:43'),
(3, 'Rol Medio Alto', '2021-10-16 00:50:52', '2021-10-16 05:52:01'),
(4, 'Rol Alto Medio', '2021-10-16 00:50:52', '2021-10-16 05:52:17'),
(5, 'Rol Alto', '2021-10-16 00:50:52', '2021-10-16 05:52:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plublicacion`
--

DROP TABLE IF EXISTS `plublicacion`;
CREATE TABLE `plublicacion` (
  `nIdPublicacion` int(11) NOT NULL,
  `nIdUsuario` int(11) NOT NULL,
  `sTitulo` varchar(100) NOT NULL,
  `sDescripcion` varchar(200) NOT NULL,
  `nStatus` int(11) NOT NULL DEFAULT 1 COMMENT '1=activo, 0=inactivo',
  `dFecRegistro` date NOT NULL,
  `dFecMovimiento` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `plublicacion`
--

INSERT INTO `plublicacion` (`nIdPublicacion`, `nIdUsuario`, `sTitulo`, `sDescripcion`, `nStatus`, `dFecRegistro`, `dFecMovimiento`) VALUES
(1, 1, 'Publicacion1', 'noticias del dia', 1, '2021-10-17', '2021-10-17 20:48:55'),
(2, 1, 'Publicacion2', 'noticias del dia', 0, '2021-10-17', '2021-10-17 20:50:32'),
(3, 1, 'Publicacion3', 'noticias del dia actualizacion', 1, '2021-10-17', '2021-10-17 20:50:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios` (
  `nIdUsuario` int(11) NOT NULL,
  `sNombre` varchar(100) NOT NULL,
  `sApellido` varchar(100) NOT NULL,
  `sCorreo` varchar(100) NOT NULL,
  `sPassword` varchar(100) NOT NULL,
  `nRol` int(11) NOT NULL,
  `dFecCreacion` datetime NOT NULL,
  `sFecMovimiento` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`nIdUsuario`, `sNombre`, `sApellido`, `sCorreo`, `sPassword`, `nRol`, `dFecCreacion`, `sFecMovimiento`) VALUES
(1, 'Zurisaddai', 'Hernandez', 'zuri_15@hotmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 1, '2021-10-17 15:45:38', '2021-10-17 20:45:38'),
(2, 'Karla', 'Guzman', 'karla@hotmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 2, '2021-10-17 15:46:22', '2021-10-17 20:46:22');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cat_rol`
--
ALTER TABLE `cat_rol`
  ADD PRIMARY KEY (`nIdRol`);

--
-- Indices de la tabla `plublicacion`
--
ALTER TABLE `plublicacion`
  ADD PRIMARY KEY (`nIdPublicacion`),
  ADD KEY `nIdUsuario` (`nIdUsuario`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`nIdUsuario`),
  ADD UNIQUE KEY `sCorreo` (`sCorreo`),
  ADD KEY `nRol` (`nRol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cat_rol`
--
ALTER TABLE `cat_rol`
  MODIFY `nIdRol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `plublicacion`
--
ALTER TABLE `plublicacion`
  MODIFY `nIdPublicacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `nIdUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `plublicacion`
--
ALTER TABLE `plublicacion`
  ADD CONSTRAINT `plublicacion_ibfk_1` FOREIGN KEY (`nIdUsuario`) REFERENCES `usuarios` (`nIdUsuario`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`nRol`) REFERENCES `cat_rol` (`nIdRol`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

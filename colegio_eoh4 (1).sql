-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-12-2019 a las 09:08:01
-- Versión del servidor: 10.4.6-MariaDB
-- Versión de PHP: 7.3.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `colegio_eoh4`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_curso` (IN `_id_curso` TINYINT(2), IN `_id_director_curso` SMALLINT(5), IN `_numero_curso` SMALLINT(4))  NO SQL
BEGIN
UPDATE `curso` SET `numero_curso`=_numero_curso,`id_director_curso`= _id_director_curso WHERE id_curso = _id_curso;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_estudiante` (IN `_id_estudiante` SMALLINT(5), IN `_nombre_estudiante` VARCHAR(20), IN `_apellido_estudiante` VARCHAR(20), IN `_identificacion_estudiante` INT(11), IN `_telefono_estudiante` BIGINT(11), IN `_estado_estudiante` TINYINT(1), IN `_id_curso` TINYINT(2))  NO SQL
BEGIN

UPDATE estudiante SET nombre_estudiante = _nombre_estudiante, apellido_estudiante = _apellido_estudiante, identificacion_estudiante = _identificacion_estudiante,  telefono_estudiante = _telefono_estudiante, estado_estudiante = _estado_estudiante, id_curso = _id_curso WHERE id_estudiante = _id_estudiante;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_estudiante_profesor` (IN `_nombre_estudiante` VARCHAR(20), IN `_apellido_estudiante` VARCHAR(20), IN `_telefono_estudiante` BIGINT(11), IN `_id_estudiante` SMALLINT(5))  NO SQL
BEGIN
UPDATE estudiante SET nombre_estudiante = _nombre_estudiante, apellido_estudiante = _apellido_estudiante, telefono_estudiante = _telefono_estudiante WHERE id_estudiante = _id_estudiante;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_materia` (IN `_id_materia` TINYINT(2), IN `_nombre_materia` VARCHAR(20))  NO SQL
BEGIN
UPDATE materia SET nombre_materia = _nombre_materia WHERE id_materia = _id_materia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_nota` (IN `_nombre_nota` VARCHAR(30), IN `_periodo` VARCHAR(13), IN `_nota` DOUBLE(4,1), IN `_id_nota` SMALLINT(5), IN `_id_materia` INT)  BEGIN
UPDATE nota SET nombre_nota = _nombre_nota, periodo_nota = _periodo, id_materia = _id_materia, nota = _nota WHERE id_nota = _id_nota;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_nota_final` (IN `_id_estudiante` SMALLINT(5), IN `_id_materia` SMALLINT(5), IN `_id_profesor` SMALLINT(5), IN `_periodo_nota` INT)  BEGIN
DECLARE promedio double(4,2);
DECLARE desempeño tinyint(1);
SELECT calcular_promedio(_id_estudiante, _id_materia, _periodo) INTO promedio;
SELECT calcular_desempeño(promedio) INTO desempeño;
UPDATE nota SET promedio_nota = promedio, desempeño_nota = desempeño WHERE id_estudiante = _id_estudiante AND id_materia = _id_materia AND id_persona = _id_profesor AND periodo_nota = _periodo_nota AND nota IS null;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_observador` (IN `_id_observacion` SMALLINT(5), IN `_descripcion_observacion` VARCHAR(254), IN `_compromiso_observacion` VARCHAR(254))  NO SQL
BEGIN
UPDATE observacion SET descripcion_observacion = _descripcion_observacion,
compromiso_observacion = _compromiso_observacion WHERE id_observacion = _id_observacion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_persona` (IN `_nombre_persona` VARCHAR(20), IN `_apellido_persona` VARCHAR(20), IN `_telefono` BIGINT(11), IN `_identificacion` INT(11), IN `_id_persona` SMALLINT(5), IN `_id_rol` TINYINT(1))  NO SQL
BEGIN
UPDATE persona SET nombre_persona=_nombre_persona, apellido_persona = _apellido_persona, telefono=_telefono, identificacion= _identificacion WHERE id_persona = _id_persona AND id_rol = _id_rol;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_persona_administrador` (IN `_nombre_persona` VARCHAR(20), IN `_apellido_persona` VARCHAR(20), IN `_telefono` BIGINT(11), IN `_identificacion` INT(11), IN `_id_persona` SMALLINT(1), IN `_id_rol` TINYINT(1), IN `_estado` INT)  NO SQL
BEGIN
UPDATE persona SET nombre_persona=_nombre_persona, apellido_persona = _apellido_persona, telefono=_telefono, identificacion=_identificacion  WHERE id_persona = _id_persona AND id_rol =_id_rol ;

UPDATE usuario SET estado_usuario=_estado  WHERE id_persona =_id_persona  AND id_rol =_id_rol ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_usuario` (IN `_nombre_usuario` VARCHAR(20), IN `_correo_usuario` VARCHAR(254), IN `_new_correo_usuario` VARCHAR(254), IN `_clave` VARCHAR(20), IN `_new_clave` VARCHAR(20))  NO SQL
BEGIN
IF _new_clave = "" THEN
UPDATE usuario SET nombre_usuario = _nombre_usuario, correo_usuario = _new_correo_usuario WHERE correo_usuario = _correo_usuario AND clave = _clave;
ELSE
UPDATE usuario SET nombre_usuario = _nombre_usuario, clave = _new_clave, correo_usuario = _new_correo_usuario WHERE correo_usuario = _correo_usuario AND clave = _clave;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consultar_curso_principal` (IN `_id_director_curso` SMALLINT(5))  NO SQL
SELECT id_curso, numero_curso FROM curso WHERE id_director_curso = _id_director_curso$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consultar_datos_observador` (IN `_id_observacion` SMALLINT(5))  NO SQL
BEGIN
SELECT id_observacion, descripcion_observacion, compromiso_observacion FROM observacion WHERE id_observacion = _id_observacion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consultar_datos_persona` (IN `_id_persona` SMALLINT(5), IN `_id_rol` TINYINT(1))  NO SQL
BEGIN
SELECT per.id_persona, per.nombre_persona, per.apellido_persona, per.telefono, per.identificacion, usu.estado_usuario FROM persona AS per INNER JOIN usuario AS usu ON usu.id_persona = per.id_persona WHERE per.id_persona = _id_persona AND per.id_rol = _id_rol;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consultar_detalles_estudiante` (IN `_id_estudiante` SMALLINT(5))  NO SQL
BEGIN
SELECT det_est.fecha_detalle_estudiante, det_est.descripcion_detalle_estudiante, CONCAT(est.nombre_estudiante, ' ', est.apellido_estudiante) AS nombre_completo_estudiante, per.id_persona, CONCAT(per.nombre_persona, ' ', per.apellido_persona) AS nombre_completo_profesor FROM estudiante AS est INNER JOIN detalle_estudiante AS det_est ON det_est.id_estudiante = est.id_estudiante INNER JOIN persona AS per ON det_est.id_persona = per.id_persona WHERE est.id_estudiante = _id_estudiante;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consultar_detalles_nota` (IN `_id_nota` INT(8))  BEGIN
SELECT det_not.fecha_detalle_nota, det_not.descripcion_detalle_nota, CONCAT(est.nombre_estudiante, ' ', est.apellido_estudiante) AS nombre_completo_estudiante, per.id_persona, CONCAT(per.nombre_persona, ' ', per.apellido_persona) AS nombre_completo_profesor FROM nota AS noo INNER JOIN detalle_nota AS det_not ON det_not.id_nota = noo.id_nota  INNER JOIN estudiante AS est ON est.id_estudiante = noo.id_estudiante INNER JOIN persona AS per ON det_not.id_persona = per.id_persona WHERE noo.id_estudiante = _id_nota ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consultar_detalles_observacion` (IN `_id_observacion` SMALLINT(5))  NO SQL
BEGIN
SELECT det_obs.fecha_detalle_observador, det_obs.descripcion_detalle_observador, CONCAT(est.nombre_estudiante, ' ', est.apellido_estudiante) AS nombre_completo_estudiante, per.id_persona, CONCAT(per.nombre_persona, ' ', per.apellido_persona) AS nombre_completo_profesor FROM observacion AS obs INNER JOIN detalle_observador AS det_obs ON det_obs.id_observacion = obs.id_observacion INNER JOIN estudiante AS est ON est.id_estudiante = obs.id_estudiante INNER JOIN persona AS per ON det_obs.id_persona = per.id_persona WHERE obs.id_observacion = _id_observacion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consultar_informacion_estudiante_administrador` (IN `_id_estudiante` SMALLINT(5))  NO SQL
BEGIN
SELECT est.nombre_estudiante, est.apellido_estudiante, est.identificacion_estudiante, est.telefono_estudiante, est.estado_estudiante, cur.numero_curso FROM estudiante AS est LEFT JOIN curso AS cur ON est.id_curso = cur.id_curso WHERE id_estudiante = _id_estudiante;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consultar_informacion_estudiante_profesor` (IN `_id_estudiante` SMALLINT(5), IN `_id_curso` TINYINT(2))  NO SQL
BEGIN
SELECT nombre_estudiante, apellido_estudiante, telefono_estudiante FROM estudiante WHERE id_estudiante = _id_estudiante AND id_curso = _id_curso;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consultar_observaciones_profesor` (IN `_id_estudiante` SMALLINT(5), IN `_id_persona` SMALLINT(5))  NO SQL
BEGIN
SELECT id_observacion, descripcion_observacion, compromiso_observacion FROM observacion AS obs INNER JOIN estudiante AS est ON obs.id_estudiante = est.id_estudiante WHERE est.id_estudiante = _id_estudiante AND obs.id_persona = _id_persona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consultar_perfil_profesor` (IN `_id_persona` SMALLINT(5))  NO SQL
BEGIN
SELECT CONCAT(per.nombre_persona, ' ', per.apellido_persona) AS nombre_completo_profesor, per.telefono, per.identificacion, usu.correo_usuario FROM persona AS per INNER JOIN usuario AS usu ON per.id_persona = usu.id_persona WHERE per.id_persona = _id_persona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_curso` (IN `_numero_curso` SMALLINT(4))  NO SQL
BEGIN
INSERT INTO curso (numero_curso) VALUES (_numero_curso);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_estudiante` (IN `_nombre_estudiante` VARCHAR(20), IN `_apellido_estudiante` VARCHAR(20), IN `_identificacion_estudiante` INT(11), IN `_telefono_estudiante` BIGINT(11), IN `_estado_estudiante` TINYINT(1))  NO SQL
BEGIN
INSERT INTO estudiante (nombre_estudiante,apellido_estudiante,identificacion_estudiante,telefono_estudiante, estado_estudiante) VALUES (_nombre_estudiante, _apellido_estudiante, _identificacion_estudiante, _telefono_estudiante, _estado_estudiante);

SELECT id_estudiante FROM estudiante WHERE id_estudiante = LAST_INSERT_ID();

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_materia` (IN `_nombre_materia` VARCHAR(20))  NO SQL
BEGIN
INSERT INTO materia (nombre_materia) VALUES (_nombre_materia);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_observacion` (IN `_descripcion_observacion` VARCHAR(254), IN `_compromiso_observacion` VARCHAR(254), IN `_id_estudiante` SMALLINT(5), IN `_id_persona` SMALLINT(5))  NO SQL
BEGIN
INSERT INTO observacion (descripcion_observacion, compromiso_observacion, id_estudiante, id_persona) VALUES (_descripcion_observacion, _compromiso_observacion, _id_estudiante, _id_persona);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `detalle_estudiante` (IN `_id_persona` SMALLINT(5), IN `_id_estudiante` SMALLINT(5), IN `tipo_detalle` TINYINT(1))  BEGIN
IF(tipo_detalle = 1) THEN
INSERT INTO detalle_estudiante(descripcion_detalle_estudiante,id_persona, id_estudiante) VALUES ("Se ha registrado el Estudiante", _id_persona, _id_estudiante);
ELSEIF(tipo_detalle = 2) THEN
INSERT INTO detalle_estudiante(descripcion_detalle_estudiante, id_persona, id_estudiante) VALUES ("Se han actualizado datos del Estudiante", _id_persona, _id_estudiante);
ELSE
INSERT INTO detalle_estudiante(descripcion_detalle_estudiante, id_persona, id_estudiante) VALUES ("Se ha inhabilitado el Estudiante", _id_persona, _id_estudiante);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_materia` (IN `_id_materia` TINYINT(2))  NO SQL
BEGIN
DELETE FROM materia WHERE id_materia = _id_materia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `enlazar_estudiante` (IN `_identificacion` INT(11), IN `_id_persona` SMALLINT(5))  NO SQL
BEGIN
DECLARE _id_estudiante SMALLINT(5);

SELECT id_estudiante INTO _id_estudiante FROM estudiante WHERE identificacion_estudiante = _identificacion;

INSERT INTO estudiante_acudiente (id_estudiante, id_persona) VALUES (_id_estudiante, _id_persona);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `enlazar_materia_curso` (IN `_id_materia` TINYINT(2), IN `_id_curso` TINYINT(2), IN `_id_persona` SMALLINT(5))  NO SQL
BEGIN
INSERT INTO materia_curso (id_materia, id_curso, id_persona) VALUES (_id_materia, _id_curso, _id_persona);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `guardar_datos_registro` (IN `_id_persona` SMALLINT(5), IN `_clave` VARCHAR(20), IN `_correo_usuario` VARCHAR(254))  NO SQL
BEGIN
UPDATE usuario SET clave = _clave, correo_usuario = _correo_usuario WHERE id_usuario = _id_persona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `habilitar_inhabilitar_usuario` (IN `_correo_usuario` VARCHAR(254), IN `_clave` VARCHAR(20), IN `_opcion` TINYINT(1))  NO SQL
BEGIN

UPDATE usuario SET estado_usuario = _opcion WHERE correo_usuario = _correo_usuario AND clave = _clave;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ingreso_del_usuario` (IN `_id_usuario` SMALLINT(5))  NO SQL
UPDATE usuario SET primera_vez = 0 WHERE id_usuario = _id_usuario$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_nota_final` (IN `_id_estudiante` SMALLINT(5), IN `_periodo_nota` INT, IN `_id_profesor` SMALLINT(5), IN `_id_materia` SMALLINT(5))  BEGIN
DECLARE promedio double(4,2);
DECLARE desempeño tinyint(1);
SELECT calcular_promedio(_id_estudiante, _id_materia,_periodo ) INTO promedio;
SELECT calcular_desempeño(promedio) INTO desempeño;
INSERT INTO nota (promedio_nota, desempeño_nota, id_estudiante, periodo_nota, id_persona, id_materia) VALUES (promedio, desempeño, _id_estudiante, _periodo_nota, _id_profesor, _id_materia);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_acudiente` ()  BEGIN
SELECT id_persona, CONCAT(nombre_persona, ' ', apellido_persona) AS nombre_completo_acudiente, telefono, identificacion FROM persona WHERE id_rol = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_acudientes_estudiante` (IN `_id_estudiante` SMALLINT(5))  NO SQL
BEGIN
SELECT CONCAT(per.nombre_persona, ' ', per.apellido_persona) AS nombre_completo_acudiente, per.telefono, per.identificacion FROM persona AS per INNER JOIN estudiante_acudiente AS est_acu ON est_acu.id_persona = per.id_persona where est_acu.id_estudiante = _id_estudiante;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_cursos` ()  NO SQL
SELECT cur.id_curso, cur.numero_curso, CONCAT(per.nombre_persona, ' ', per.apellido_persona) AS nombre_completo_profesor FROM curso AS cur LEFT JOIN persona AS per ON per.id_persona = cur.id_director_curso$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_cursos_materia` (IN `_id_materia` TINYINT(2))  NO SQL
BEGIN
SELECT cur.id_curso, cur.numero_curso, CONCAT(per.nombre_persona, ' ', per.apellido_persona) AS nombre_completo_profesor FROM materia AS mat INNER JOIN materia_curso AS mat_cur ON mat.id_materia = mat_cur.id_materia INNER JOIN curso AS cur ON cur.id_curso = mat_cur.id_curso INNER JOIN persona AS per ON per.id_persona = mat_cur.id_persona WHERE mat.id_materia = _id_materia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_cursos_profesor` (IN `_id_persona` SMALLINT(5))  NO SQL
BEGIN
SELECT mat.nombre_materia, cur.id_curso, cur.numero_curso FROM materia_curso AS mat_cur INNER JOIN curso AS cur ON cur.id_curso = mat_cur.id_curso INNER JOIN materia AS mat ON mat.id_materia = mat_cur.id_materia INNER JOIN persona AS per ON per.id_persona = mat_cur.id_persona WHERE per.id_persona = _id_persona AND cur.id_curso != (SELECT id_curso FROM curso WHERE id_director_curso = _id_persona);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_estudiante2` ()  BEGIN
SELECT id_estudiante, CONCAT(nombre_estudiante, ' ', apellido_estudiante) AS nombre_completo_estudiante, identificacion_estudiante, telefono_estudiante FROM estudiante;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_estudiantes` (IN `_estado` TINYINT(1), IN `_id_curso` TINYINT(2))  NO SQL
BEGIN
SELECT id_estudiante, CONCAT(nombre_estudiante, ' ', apellido_estudiante) AS nombre_completo_estudiante, identificacion_estudiante, telefono_estudiante FROM estudiante WHERE estado_estudiante = _estado AND id_curso = _id_curso;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_estudiantes_director_curso` (IN `_id_director_curso` SMALLINT(5), IN `_id_curso` TINYINT(2), IN `_estado` TINYINT(1))  NO SQL
SELECT est.id_estudiante, CONCAT(est.nombre_estudiante, ' ',est.apellido_estudiante) AS nombre_completo_estudiante, est.identificacion_estudiante, est.telefono_estudiante FROM curso AS cur INNER JOIN estudiante AS est ON est.id_curso = cur.id_curso WHERE cur.id_director_curso = _id_director_curso AND cur.id_curso = _id_curso AND estado_estudiante = _estado$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_estudiantes_enlazados` (IN `_id_persona` SMALLINT(5))  NO SQL
BEGIN
SELECT DISTINCT est.id_estudiante, est.nombre_estudiante, est.apellido_estudiante, est.identificacion_estudiante, est.telefono_estudiante, cur.numero_curso FROM estudiante_acudiente AS est_acu INNER JOIN persona AS per ON per.id_persona = est_acu.id_persona INNER JOIN estudiante AS est ON est.id_estudiante = est_acu.id_estudiante INNER JOIN curso AS cur ON cur.id_curso = est.id_curso WHERE est_acu.id_persona = _id_persona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_informacion_profesor_administrador` (IN `_id_per` SMALLINT(5))  BEGIN
SELECT nombre_persona, apellido_persona, telefono, identificacion FROM persona
WHERE id_persona = _id_per ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_materias` ()  NO SQL
BEGIN
SELECT * FROM materia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_materias_curso_profesor` (IN `_id_persona` SMALLINT(5), IN `_id_curso` TINYINT(2))  NO SQL
BEGIN
SELECT mat.id_materia, mat.nombre_materia FROM materia AS mat INNER JOIN materia_curso AS mat_cur ON mat_cur.id_materia = mat.id_materia INNER JOIN materia_profesor AS mat_pro ON mat_pro.id_materia = mat.id_materia WHERE mat_pro.id_persona = _id_persona AND mat_cur.id_curso = _id_curso;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_notas` (IN `_periodo_nota` ENUM('1','2','3','4'), IN `_id_estudiante` SMALLINT(5), IN `_id_materia` SMALLINT(2))  BEGIN
SELECT id_nota, nombre_nota, periodo_nota, nota, id_estudiante, id_persona, id_materia FROM nota WHERE id_estudiante = _id_estudiante AND id_materia = _id_materia AND nota IS not null AND periodo_nota = _periodo_nota; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_observaciones_estudiante` (IN `_id_estudiante` SMALLINT(5))  NO SQL
BEGIN
SELECT obs.id_observacion, obs.descripcion_observacion, obs.compromiso_observacion, CONCAT(est.nombre_estudiante, ' ', est.apellido_estudiante) AS nombre_completo_estudiante FROM observacion AS obs INNER JOIN estudiante AS est ON obs.id_estudiante = est.id_estudiante WHERE est.id_estudiante = _id_estudiante;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_profesores` ()  NO SQL
SELECT id_persona, CONCAT(nombre_persona, ' ', apellido_persona) AS nombre_completo_profesor, telefono, identificacion FROM persona WHERE id_rol = 2$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_profesores_curso` (IN `_id_curso` TINYINT(2))  NO SQL
SELECT DISTINCT per.id_persona ,CONCAT(per.nombre_persona, ' ', per.apellido_persona) AS nombre_completo_profesor FROM materia_curso AS mat_cur INNER JOIN persona AS per ON per.id_persona = mat_cur.id_persona INNER JOIN curso AS cur ON mat_cur.id_curso = cur.id_curso WHERE mat_cur.id_curso = _id_curso$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_profesores_sin_curso` ()  NO SQL
BEGIN
SELECT id_persona, CONCAT(nombre_persona, ' ', apellido_persona) AS nombre_completo_profesor FROM persona WHERE id_persona NOT IN (SELECT cur.id_director_curso
                       FROM curso AS cur INNER JOIN persona AS per ON cur.id_director_curso = per.id_persona) AND id_rol = 2;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mostrar_materias` (IN `_id_estudiante` SMALLINT(5))  BEGIN
SELECT DISTINCT nta.id_materia, mat.nombre_materia FROM nota nta 
INNER JOIN materia mat ON nta.id_materia = mat.id_materia WHERE
nta.id_estudiante = _id_estudiante and nota is not null;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_estudiante` (IN `_Nombre_est` VARCHAR(20), IN `_apellido_est` VARCHAR(20), IN `_identificacion_est` INT(11), IN `_telefono_est` BIGINT(11), IN `_estado_est` TINYINT(1))  BEGIN
INSERT INTO estudiante (nombre_estudiante, apellido_estudiante, identificacion_estudiante, telefono_estudiante, estado_estudiante) VALUES (_Nombre_est, _apellido_est, _identificacion_est, _telefono_est, _estado_est);

SELECT id_estudiante FROM estudiante WHERE id_estudiante = LAST_INSERT_ID();

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_nota` (IN `_nombre_nota` VARCHAR(30), IN `_periodo_nota` ENUM('1','2','3','4'), IN `_nota` DOUBLE(4,1), IN `_id_estudiante` SMALLINT(5), IN `_id_materia` SMALLINT(2), IN `_id_persona` SMALLINT(5))  BEGIN

DECLARE validacion tinyint(1);

SELECT validar_nota_final(_periodo_nota,_id_estudiante,_id_persona,_id_materia) INTO validacion;

INSERT INTO nota (nombre_nota, periodo_nota, nota, id_estudiante, id_materia, id_persona) VALUES (_nombre_nota, _periodo_nota, _nota,  _id_estudiante, _id_materia, _id_persona);

IF validacion = 0 THEN

CALL insertar_nota_final(_id_estudiante,_id_materia,_id_persona,_periodo_nota);

ELSE

CALL actualizar_nota_final(_id_estudiante,_id_materia,_id_persona,_periodo_nota);

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_persona` (IN `_nombre_persona` VARCHAR(20), IN `_apellido_persona` VARCHAR(20), IN `_telefono` BIGINT(11), IN `_identificacion` INT(11), IN `_id_rol` TINYINT(1))  NO SQL
BEGIN
INSERT INTO persona (nombre_persona,apellido_persona,telefono,identificacion, id_rol) VALUES (_nombre_persona, _apellido_persona, _telefono, _identificacion, _id_rol);

SELECT id_usuario FROM usuario WHERE id_usuario = LAST_INSERT_ID();

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `validar_datos_usuario` (IN `_correo_usuario` VARCHAR(254), IN `_clave` VARCHAR(20))  NO SQL
BEGIN
SELECT correo_usuario, clave FROM usuario WHERE correo_usuario = _correo_usuario AND clave = _clave;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `validar_si_hay_notas` (IN `_id_estudiante` SMALLINT(5))  BEGIN
SELECT nota FROM nota WHERE id_estudiante = _id_estudiante;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `validar_usuario` (IN `_correo_usuario` VARCHAR(254), IN `_clave` VARCHAR(20))  NO SQL
BEGIN
SELECT * FROM usuario WHERE correo_usuario = _correo_usuario AND clave = _clave;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_desempeño` (`_promedio` DOUBLE(4,2)) RETURNS TINYINT(1) BEGIN
DECLARE desempeño tinyint(1);
IF (_promedio < 3) THEN
SET desempeño = 1;
ELSEIF (_promedio > 3 AND _promedio <= 3.5) THEN
SET desempeño = 2;
ELSEIF (_promedio > 3.5 AND _promedio <= 4.5 ) THEN
SET desempeño = 3;
ELSEIF (_promedio > 4.5) THEN
SET desempeño = 4;
END IF;
RETURN desempeño;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_promedio` (`_id_estudiante` SMALLINT(5), `_id_materia` SMALLINT(5), `_periodo` ENUM('1','2','3','4')) RETURNS DOUBLE(4,2) BEGIN
DECLARE numNotas SMALLINT(2);
DECLARE sumaNotas double(4,2);
DECLARE promedio double(4,2);
select count(nota)
into numNotas
from nota
where id_estudiante = _id_estudiante AND id_materia = _id_materia AND id_nota is not null AND periodo_nota = _periodo;
select sum(nota) INTO sumaNotas from nota
WHERE id_estudiante = _id_estudiante AND id_materia = _id_materia AND periodo_nota = _periodo;
SET promedio = sumaNotas/numNotas;
RETURN promedio;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `validar_nota_final` (`_periodo_nota` ENUM('1','2','3','4'), `_id_estudiante` SMALLINT(5), `_id_profesor` SMALLINT(5), `_id_materia` TINYINT(2)) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE validacion tinyint(1);
SELECT COUNT(promedio_nota) INTO validacion FROM nota WHERE nota IS NULL AND periodo_nota = _periodo_nota AND id_estudiante = _id_estudiante AND id_profesor = _id_profesor AND id_materia = _id_materia;
RETURN validacion;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `curso`
--

CREATE TABLE `curso` (
  `id_curso` tinyint(2) NOT NULL,
  `numero_curso` smallint(4) NOT NULL,
  `id_director_curso` smallint(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `curso`
--

INSERT INTO `curso` (`id_curso`, `numero_curso`, `id_director_curso`) VALUES
(1, 101, 26),
(2, 102, 25),
(3, 103, 27),
(4, 201, 29),
(5, 202, 30),
(6, 203, 31),
(7, 301, 32),
(8, 302, 33),
(9, 303, 34),
(10, 401, 35),
(11, 402, 36),
(12, 403, 39),
(13, 501, NULL),
(14, 502, NULL),
(15, 503, NULL),
(16, 601, NULL),
(17, 602, NULL),
(18, 603, NULL),
(19, 701, NULL),
(20, 702, NULL),
(21, 703, NULL),
(22, 801, NULL),
(23, 802, NULL),
(24, 803, NULL),
(25, 901, NULL),
(26, 902, NULL),
(27, 903, NULL),
(28, 1001, NULL),
(29, 1002, NULL),
(30, 1003, NULL),
(31, 1101, NULL),
(32, 1102, NULL),
(33, 1103, NULL),
(36, 1201, 43),
(0, 1203, NULL),
(41, 1214, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_estudiante`
--

CREATE TABLE `detalle_estudiante` (
  `id` smallint(5) NOT NULL,
  `fecha_detalle_estudiante` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `descripcion_detalle_estudiante` varchar(250) NOT NULL,
  `id_persona` smallint(5) NOT NULL,
  `id_estudiante` smallint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `detalle_estudiante`
--

INSERT INTO `detalle_estudiante` (`id`, `fecha_detalle_estudiante`, `descripcion_detalle_estudiante`, `id_persona`, `id_estudiante`) VALUES
(1, '2019-12-03 21:15:31', 'Se han actualizado datos del Estudiante', 24, 4),
(2, '2019-12-03 21:24:14', 'Se han actualizado datos del Estudiante', 24, 4),
(3, '2019-12-03 21:24:44', 'Se han actualizado datos del Estudiante', 24, 3),
(4, '2019-12-09 15:59:40', 'Se ha registrado el Estudiante', 41, 14),
(5, '2019-12-10 18:59:12', 'Se han actualizado datos del Estudiante', 25, 4),
(6, '2019-12-10 19:20:58', 'Se han actualizado datos del Estudiante', 41, 12),
(7, '2019-12-10 19:25:54', 'Se han actualizado datos del Estudiante', 41, 12),
(8, '2019-12-10 19:30:00', 'Se han actualizado datos del Estudiante', 41, 12),
(9, '2019-12-10 19:30:00', 'Se han actualizado datos del Estudiante', 41, 12),
(10, '2019-12-10 19:30:04', 'Se han actualizado datos del Estudiante', 41, 12),
(11, '2019-12-10 19:30:14', 'Se han actualizado datos del Estudiante', 41, 12),
(12, '2019-12-10 19:30:44', 'Se han actualizado datos del Estudiante', 41, 12),
(13, '2019-12-10 19:31:07', 'Se han actualizado datos del Estudiante', 41, 12),
(14, '2019-12-10 21:52:25', 'Se ha registrado el Estudiante', 41, 17),
(15, '2019-12-10 21:53:37', 'Se ha registrado el Estudiante', 41, 20),
(16, '2019-12-11 07:23:11', 'Se ha registrado el Estudiante', 41, 21),
(17, '2019-12-11 07:24:08', 'Se han actualizado datos del Estudiante', 41, 6),
(18, '2019-12-11 07:24:20', 'Se han actualizado datos del Estudiante', 41, 6),
(19, '2019-12-11 07:24:25', 'Se han actualizado datos del Estudiante', 41, 6),
(20, '2019-12-11 07:30:38', 'Se han actualizado datos del Estudiante', 25, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_nota`
--

CREATE TABLE `detalle_nota` (
  `id` smallint(5) NOT NULL,
  `fecha_detalle_nota` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `descripcion_detalle_nota` varchar(250) NOT NULL,
  `id_persona` smallint(5) NOT NULL,
  `id_nota` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `detalle_nota`
--

INSERT INTO `detalle_nota` (`id`, `fecha_detalle_nota`, `descripcion_detalle_nota`, `id_persona`, `id_nota`) VALUES
(1, '2019-12-03 04:54:07', 'Se ha registrado la observación', 39, 2),
(2, '2019-12-11 01:57:28', 'Se ha registrado la observación', 24, 3),
(3, '2019-12-11 02:25:55', 'Se ha actualizado la nota', 24, 3),
(4, '2019-12-11 03:52:33', 'Se ha registrado la observación', 39, 4),
(5, '2019-12-11 04:09:33', 'Se ha actualizado la nota', 39, 2),
(6, '2019-12-11 07:33:10', 'Se ha actualizado la nota', 39, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_observador`
--

CREATE TABLE `detalle_observador` (
  `id` smallint(5) NOT NULL,
  `fecha_detalle_observador` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `descripcion_detalle_observador` varchar(250) NOT NULL,
  `id_persona` smallint(5) NOT NULL,
  `id_observacion` smallint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `detalle_observador`
--

INSERT INTO `detalle_observador` (`id`, `fecha_detalle_observador`, `descripcion_detalle_observador`, `id_persona`, `id_observacion`) VALUES
(1, '2019-11-28 15:41:25', 'Se ha registrado la observación', 24, 1),
(2, '2019-11-28 15:50:09', 'Se ha registrado la observación', 24, 2),
(3, '2019-12-02 23:00:54', 'Se ha actualizado la observación', 24, 2),
(4, '2019-12-02 23:01:03', 'Se ha actualizado la observación', 24, 2),
(5, '2019-12-02 23:22:48', 'Se ha actualizado la observación', 24, 2),
(6, '2019-12-02 23:22:51', 'Se ha actualizado la observación', 24, 2),
(7, '2019-12-02 23:22:56', 'Se ha registrado la observación', 24, 3),
(8, '2019-12-02 23:23:15', 'Se ha actualizado la observación', 24, 3),
(9, '2019-12-02 23:34:30', 'Se ha registrado la observación', 24, 4),
(10, '2019-12-03 00:15:40', 'Se ha registrado la observación', 24, 5),
(11, '2019-12-03 00:15:48', 'Se ha actualizado la observación', 24, 5),
(12, '2019-12-03 00:18:51', 'Se ha actualizado la observación', 24, 1),
(13, '2019-12-03 00:18:59', 'Se ha registrado la observación', 24, 6),
(14, '2019-12-11 07:31:50', 'Se ha registrado la observación', 25, 7),
(15, '2019-12-11 07:32:34', 'Se ha actualizado la observación', 25, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante`
--

CREATE TABLE `estudiante` (
  `id_estudiante` smallint(5) NOT NULL,
  `nombre_estudiante` varchar(20) NOT NULL,
  `apellido_estudiante` varchar(20) NOT NULL,
  `identificacion_estudiante` int(11) NOT NULL,
  `telefono_estudiante` bigint(11) NOT NULL,
  `estado_estudiante` tinyint(1) NOT NULL,
  `id_curso` tinyint(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `estudiante`
--

INSERT INTO `estudiante` (`id_estudiante`, `nombre_estudiante`, `apellido_estudiante`, `identificacion_estudiante`, `telefono_estudiante`, `estado_estudiante`, `id_curso`) VALUES
(3, 'Robertico', 'Cardenas', 1001234567, 3208408880, 1, 1),
(4, 'Andres', 'Salas', 1001240010, 7646713, 1, 2),
(5, 'Carlos', 'Pinilla', 1004510111, 7641140, 1, NULL),
(6, 'Dayana', 'Sanchez', 1000456987, 7641140, 1, 29),
(8, 'Carlitos', 'Pinillitos', 7641140, 1234561231, 1, NULL),
(9, 'Daniela', 'Paz', 1234512341, 7641140, 1, NULL),
(12, 'Cristian', 'Ortega', 1001724103, 3222290570, 1, 13),
(13, 'Andrea', 'Ortega', 1001272558, 7641140, 2, NULL),
(14, 'Sebastian', 'Amaya', 1001272536, 7641140, 1, NULL),
(15, 'Carlitosporque', 'meabandonaste', 1001272544, 3054091063, 1, NULL),
(16, 'Carlitosporque', 'meabandonaste', 1001254444, 7641140, 1, NULL),
(17, 'Carlitosporque', 'meabandonaste', 1012001201, 7641140, 1, NULL),
(20, 'Carlos', 'meabandonaste', 1001240403, 7641140, 1, NULL),
(21, 'Santiago', 'Sanchez', 1000123651, 3114696620, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante_acudiente`
--

CREATE TABLE `estudiante_acudiente` (
  `id_estudiante_acudiente` int(11) NOT NULL,
  `id_estudiante` smallint(5) NOT NULL,
  `id_persona` smallint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `estudiante_acudiente`
--

INSERT INTO `estudiante_acudiente` (`id_estudiante_acudiente`, `id_estudiante`, `id_persona`) VALUES
(3, 3, 8),
(5, 3, 52),
(6, 3, 54),
(2, 4, 8),
(1, 4, 26),
(8, 9, 8),
(9, 12, 8),
(7, 12, 48);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materia`
--

CREATE TABLE `materia` (
  `id_materia` tinyint(2) NOT NULL,
  `nombre_materia` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `materia`
--

INSERT INTO `materia` (`id_materia`, `nombre_materia`) VALUES
(11, 'Calculo'),
(19, 'Ciencias'),
(3, 'Economia'),
(7, 'Educacion Fisica'),
(2, 'Español'),
(12, 'Etica'),
(4, 'Filosofia'),
(6, 'Fisica'),
(18, 'Informatica'),
(8, 'Ingles'),
(1, 'Matematicas'),
(5, 'Quimica'),
(9, 'Sociales'),
(10, 'Trigonometria');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materia_curso`
--

CREATE TABLE `materia_curso` (
  `id_materia_curso` tinyint(3) NOT NULL,
  `id_materia` tinyint(2) NOT NULL,
  `id_curso` tinyint(2) NOT NULL,
  `id_persona` smallint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `materia_curso`
--

INSERT INTO `materia_curso` (`id_materia_curso`, `id_materia`, `id_curso`, `id_persona`) VALUES
(73, 1, 1, 26),
(74, 2, 2, 24),
(75, 9, 1, 24),
(77, 5, 24, 24),
(78, 3, 1, 24),
(79, 8, 7, 24),
(80, 1, 2, 26),
(81, 1, 3, 24),
(82, 11, 5, 25),
(83, 11, 7, 26),
(88, 11, 1, 29),
(90, 11, 14, 30),
(96, 11, 2, 24),
(97, 11, 21, 31),
(98, 18, 16, 44),
(102, 11, 16, 34),
(103, 11, 33, 51),
(105, 19, 9, 26);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nota`
--

CREATE TABLE `nota` (
  `id_nota` int(8) NOT NULL,
  `nombre_nota` varchar(30) NOT NULL,
  `periodo_nota` enum('1','2','3','4') NOT NULL,
  `nota` double(4,1) NOT NULL,
  `promedio_nota` double(4,1) NOT NULL,
  `desempeño_nota` varchar(13) NOT NULL,
  `id_estudiante` smallint(5) NOT NULL,
  `id_materia` tinyint(2) NOT NULL,
  `id_persona` smallint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `nota`
--

INSERT INTO `nota` (`id_nota`, `nombre_nota`, `periodo_nota`, `nota`, `promedio_nota`, `desempeño_nota`, `id_estudiante`, `id_materia`, `id_persona`) VALUES
(2, 'Tarea 1', '1', 4.5, 0.0, '', 4, 2, 39),
(3, 'tarea 3', '3', 3.4, 0.0, '', 12, 3, 24),
(4, 'sfadg', '1', 4.0, 0.0, '', 4, 1, 39);

--
-- Disparadores `nota`
--
DELIMITER $$
CREATE TRIGGER `insertar_detalle_nota_AI` AFTER INSERT ON `nota` FOR EACH ROW BEGIN
INSERT INTO detalle_nota(descripcion_detalle_nota, id_persona, id_nota) VALUES ('Se ha registrado la observación', new.id_persona, new.id_nota);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertar_detalle_nota_AU` AFTER UPDATE ON `nota` FOR EACH ROW BEGIN
INSERT INTO detalle_nota(descripcion_detalle_nota, id_persona, id_nota) VALUES ('Se ha actualizado la nota', old.id_persona, old.id_nota);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `observacion`
--

CREATE TABLE `observacion` (
  `id_observacion` smallint(5) NOT NULL,
  `descripcion_observacion` varchar(254) NOT NULL,
  `compromiso_observacion` varchar(254) NOT NULL,
  `id_estudiante` smallint(5) NOT NULL,
  `id_persona` smallint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `observacion`
--

INSERT INTO `observacion` (`id_observacion`, `descripcion_observacion`, `compromiso_observacion`, `id_estudiante`, `id_persona`) VALUES
(1, 'adadad', 'adadad', 3, 24),
(2, 'Le pegó a un niñaasdasd', 'Promete no pegarle a más niñasasdasd', 4, 24),
(3, 'Ahora sí algo serio', 'Jaja\r\n', 4, 24),
(4, 'dfsdf', 'sdfsd', 4, 24),
(5, 'sdfsdfsdfsdfsdfsd', 'sdfsdfsdfsfsdfsdfsdfs', 4, 24),
(6, 'ffffff', 'fffff', 3, 24),
(7, 'El estudiante le pego a un profesor', 'no podrá venir a clase por 3 días', 4, 25);

--
-- Disparadores `observacion`
--
DELIMITER $$
CREATE TRIGGER `insertar_detalle_observacion_AI` AFTER INSERT ON `observacion` FOR EACH ROW BEGIN
INSERT INTO detalle_observador(descripcion_detalle_observador, id_persona, id_observacion) VALUES ('Se ha registrado la observación', new.id_persona, new.id_observacion);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertar_detalle_observacion_AU` AFTER UPDATE ON `observacion` FOR EACH ROW BEGIN
INSERT INTO detalle_observador(descripcion_detalle_observador, id_persona, id_observacion) VALUES ('Se ha actualizado la observación', old.id_persona, old.id_observacion);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `id_persona` smallint(5) NOT NULL,
  `nombre_persona` varchar(20) NOT NULL,
  `apellido_persona` varchar(20) NOT NULL,
  `telefono` bigint(11) NOT NULL,
  `identificacion` int(10) NOT NULL,
  `id_rol` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`id_persona`, `nombre_persona`, `apellido_persona`, `telefono`, `identificacion`, `id_rol`) VALUES
(8, 'Alejandro', 'Penha', 3054091063, 1001272534, 1),
(10, 'Carlos', 'Pinilla', 7641140, 1001272535, 1),
(24, 'Felipe', 'Hernandez', 3054091063, 1200140001, 2),
(25, 'OED', 'Pinilla', 3112884747, 1839470, 2),
(26, 'Stefaniaa', 'Quevedo', 7641140, 1001272531, 2),
(27, 'Sergio', 'Pinilla', 9577220379, 1000783666, 2),
(29, 'Maicol', 'Martinez', 5586714813, 1000783668, 2),
(30, 'Juliana', 'Gomez', 1097353056, 1000783100, 2),
(31, 'Estefania', 'Muñoz', 2484411377, 1011292635, 2),
(32, 'Valentina', 'Miranda', 5476967269, 1021292635, 2),
(33, 'Emiliano', 'Saveda', 5761067729, 1021295635, 2),
(34, 'Dayana', 'Forero', 3229201245, 1222520100, 2),
(35, 'Jimena', 'Hernandez', 6283109035, 1021245640, 2),
(36, 'Junior', 'Alberto', 9686358360, 2147483647, 2),
(39, 'Juan', 'Pablo', 2351300997, 1021265640, 2),
(41, 'Carlos', 'Bautista', 3229215801, 1000410706, 3),
(42, 'Carlos', 'Pinilla', 7641140, 1004510001, 1),
(43, 'Daniela', 'Paz', 3194270955, 1000336116, 2),
(44, ' fvf', 'cfx', 543536, 35543265, 2),
(46, 'Gloria', 'Castro', 7641140, 1001241240, 1),
(48, 'Alejandraa', 'pinillaa', 76741140, 1001569874, 1),
(49, 'OED', 'meabandona', 76457040, 1400475200, 2),
(50, 'Carlos', 'Pinilla', 7641140, 1101010101, 1),
(51, 'William', 'Martinez', 7641140, 1013210101, 2),
(52, 'Jhon', 'Sanchez', 7643240, 1000258369, 1),
(53, 'Dayana', 'Castro', 76741140, 1012101010, 1),
(54, 'Alejandraa', 'Guzman', 761140, 1011010100, 1),
(56, 'OED', 'meabandonaste', 76414110, 1222345432, 2),
(57, 'Daniel', 'Suarez', 3229204512, 1000456123, 1),
(60, 'Andres', 'Ortega', 3125698754, 1000236569, 1),
(61, 'Erick', 'Hernandez', 3222952154, 1022456978, 2);

--
-- Disparadores `persona`
--
DELIMITER $$
CREATE TRIGGER `asignar_persona_ai` AFTER INSERT ON `persona` FOR EACH ROW BEGIN
INSERT INTO usuario(id_usuario, id_rol, id_persona) VALUES (new.id_persona ,new.id_rol, new.id_persona);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id_rol` tinyint(1) NOT NULL,
  `tipo_rol` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id_rol`, `tipo_rol`) VALUES
(1, 'Acudiente'),
(3, 'Administrador'),
(2, 'Profesor');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` smallint(5) NOT NULL,
  `nombre_usuario` varchar(20) DEFAULT NULL,
  `clave` varchar(20) NOT NULL,
  `correo_usuario` varchar(254) DEFAULT NULL,
  `estado_usuario` tinyint(1) NOT NULL,
  `primera_vez` tinyint(1) NOT NULL DEFAULT 1,
  `id_rol` tinyint(1) NOT NULL,
  `id_persona` smallint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `nombre_usuario`, `clave`, `correo_usuario`, `estado_usuario`, `primera_vez`, `id_rol`, `id_persona`) VALUES
(8, 'Carlos8906', '123', 'pinillacarlos892@gmail.com', 1, 0, 1, 8),
(10, NULL, '', NULL, 0, 1, 1, 10),
(24, 'Alejo', 'Mordecai8906@', 'carlitos@gmail.com', 1, 0, 2, 24),
(25, 'Carlos786', '123', 'capinilla@gmail.com', 1, 0, 2, 25),
(26, NULL, '', NULL, 0, 1, 2, 26),
(27, NULL, '', NULL, 0, 1, 2, 27),
(29, NULL, '', NULL, 0, 1, 2, 29),
(30, NULL, '', NULL, 0, 1, 2, 30),
(31, NULL, '', NULL, 0, 1, 2, 31),
(32, NULL, '', NULL, 0, 1, 2, 32),
(33, NULL, '', NULL, 0, 1, 2, 33),
(34, NULL, '', NULL, 1, 1, 2, 34),
(35, NULL, '', NULL, 0, 1, 2, 35),
(36, NULL, '', NULL, 0, 1, 2, 36),
(39, NULL, '', NULL, 0, 1, 2, 39),
(41, 'Carlitos8906', 'Alejo123@', 'pinilla@gmail.com', 1, 0, 3, 41),
(42, NULL, '', NULL, 0, 1, 1, 42),
(43, NULL, '', NULL, 0, 1, 2, 43),
(44, NULL, '', NULL, 0, 1, 2, 44),
(46, NULL, '', NULL, 0, 1, 1, 46),
(48, NULL, '', NULL, 1, 1, 1, 48),
(49, NULL, '', NULL, 0, 1, 2, 49),
(50, NULL, '', NULL, 0, 1, 1, 50),
(51, NULL, '', NULL, 0, 1, 2, 51),
(52, NULL, '', NULL, 1, 1, 1, 52),
(53, NULL, '', NULL, 0, 1, 1, 53),
(54, NULL, '', NULL, 1, 1, 1, 54),
(57, NULL, '', NULL, 0, 1, 1, 57),
(60, NULL, 'ZFT7661a@', 'camilocomservices@gmail.com', 0, 1, 1, 60),
(61, NULL, 'TKM1807a@', 'camilocom@gmail.com', 0, 1, 2, 61);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `curso`
--
ALTER TABLE `curso`
  ADD PRIMARY KEY (`id_curso`),
  ADD UNIQUE KEY `numero_curso` (`numero_curso`),
  ADD UNIQUE KEY `numero_curso_2` (`numero_curso`,`id_director_curso`),
  ADD UNIQUE KEY `id_persona` (`id_director_curso`);

--
-- Indices de la tabla `detalle_estudiante`
--
ALTER TABLE `detalle_estudiante`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_persona` (`id_persona`),
  ADD KEY `id_estudiante` (`id_estudiante`);

--
-- Indices de la tabla `detalle_nota`
--
ALTER TABLE `detalle_nota`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_persona` (`id_persona`),
  ADD KEY `id_nota` (`id_nota`);

--
-- Indices de la tabla `detalle_observador`
--
ALTER TABLE `detalle_observador`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_persona` (`id_persona`),
  ADD KEY `id_observacion` (`id_observacion`);

--
-- Indices de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD PRIMARY KEY (`id_estudiante`),
  ADD UNIQUE KEY `identificacion_estudiante` (`identificacion_estudiante`),
  ADD KEY `id_curso` (`id_curso`);

--
-- Indices de la tabla `estudiante_acudiente`
--
ALTER TABLE `estudiante_acudiente`
  ADD PRIMARY KEY (`id_estudiante_acudiente`),
  ADD UNIQUE KEY `id_estudiante_2` (`id_estudiante`,`id_persona`),
  ADD KEY `id_persona` (`id_persona`),
  ADD KEY `id_estudiante` (`id_estudiante`);

--
-- Indices de la tabla `materia`
--
ALTER TABLE `materia`
  ADD PRIMARY KEY (`id_materia`),
  ADD UNIQUE KEY `materia` (`nombre_materia`);

--
-- Indices de la tabla `materia_curso`
--
ALTER TABLE `materia_curso`
  ADD PRIMARY KEY (`id_materia_curso`),
  ADD UNIQUE KEY `id_materia_2` (`id_materia`,`id_curso`),
  ADD KEY `id_materia` (`id_materia`),
  ADD KEY `id_curso` (`id_curso`),
  ADD KEY `id_persona` (`id_persona`);

--
-- Indices de la tabla `nota`
--
ALTER TABLE `nota`
  ADD PRIMARY KEY (`id_nota`),
  ADD KEY `id_estudiante` (`id_estudiante`),
  ADD KEY `id_materia` (`id_materia`),
  ADD KEY `id_persona` (`id_persona`);

--
-- Indices de la tabla `observacion`
--
ALTER TABLE `observacion`
  ADD PRIMARY KEY (`id_observacion`),
  ADD KEY `id_estudiante` (`id_estudiante`),
  ADD KEY `id_persona` (`id_persona`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`id_persona`),
  ADD UNIQUE KEY `identificacion` (`identificacion`),
  ADD KEY `id_rol` (`id_rol`) USING BTREE;

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `rol` (`tipo_rol`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo_usuario` (`correo_usuario`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  ADD KEY `id_rol` (`id_rol`),
  ADD KEY `id_persona` (`id_persona`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `curso`
--
ALTER TABLE `curso`
  MODIFY `id_curso` tinyint(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT de la tabla `detalle_estudiante`
--
ALTER TABLE `detalle_estudiante`
  MODIFY `id` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `detalle_nota`
--
ALTER TABLE `detalle_nota`
  MODIFY `id` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `detalle_observador`
--
ALTER TABLE `detalle_observador`
  MODIFY `id` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  MODIFY `id_estudiante` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `estudiante_acudiente`
--
ALTER TABLE `estudiante_acudiente`
  MODIFY `id_estudiante_acudiente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `materia`
--
ALTER TABLE `materia`
  MODIFY `id_materia` tinyint(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `materia_curso`
--
ALTER TABLE `materia_curso`
  MODIFY `id_materia_curso` tinyint(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT de la tabla `nota`
--
ALTER TABLE `nota`
  MODIFY `id_nota` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `observacion`
--
ALTER TABLE `observacion`
  MODIFY `id_observacion` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `id_persona` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id_rol` tinyint(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `curso`
--
ALTER TABLE `curso`
  ADD CONSTRAINT `curso_ibfk_1` FOREIGN KEY (`id_director_curso`) REFERENCES `persona` (`id_persona`);

--
-- Filtros para la tabla `detalle_estudiante`
--
ALTER TABLE `detalle_estudiante`
  ADD CONSTRAINT `detalle_estudiante_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`),
  ADD CONSTRAINT `detalle_estudiante_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_estudiante`);

--
-- Filtros para la tabla `detalle_nota`
--
ALTER TABLE `detalle_nota`
  ADD CONSTRAINT `detalle_nota_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`),
  ADD CONSTRAINT `detalle_nota_ibfk_2` FOREIGN KEY (`id_nota`) REFERENCES `nota` (`id_nota`);

--
-- Filtros para la tabla `detalle_observador`
--
ALTER TABLE `detalle_observador`
  ADD CONSTRAINT `detalle_observador_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`),
  ADD CONSTRAINT `detalle_observador_ibfk_2` FOREIGN KEY (`id_observacion`) REFERENCES `observacion` (`id_observacion`);

--
-- Filtros para la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD CONSTRAINT `estudiante_ibfk_1` FOREIGN KEY (`id_curso`) REFERENCES `curso` (`id_curso`);

--
-- Filtros para la tabla `estudiante_acudiente`
--
ALTER TABLE `estudiante_acudiente`
  ADD CONSTRAINT `estudiante_acudiente_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_estudiante`),
  ADD CONSTRAINT `estudiante_acudiente_ibfk_2` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`);

--
-- Filtros para la tabla `materia_curso`
--
ALTER TABLE `materia_curso`
  ADD CONSTRAINT `materia_curso_ibfk_1` FOREIGN KEY (`id_materia`) REFERENCES `materia` (`id_materia`),
  ADD CONSTRAINT `materia_curso_ibfk_2` FOREIGN KEY (`id_curso`) REFERENCES `curso` (`id_curso`),
  ADD CONSTRAINT `materia_curso_ibfk_3` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`);

--
-- Filtros para la tabla `nota`
--
ALTER TABLE `nota`
  ADD CONSTRAINT `nota_ibfk_1` FOREIGN KEY (`id_materia`) REFERENCES `materia` (`id_materia`),
  ADD CONSTRAINT `nota_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_estudiante`),
  ADD CONSTRAINT `nota_ibfk_3` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`);

--
-- Filtros para la tabla `observacion`
--
ALTER TABLE `observacion`
  ADD CONSTRAINT `observacion_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_estudiante`),
  ADD CONSTRAINT `observacion_ibfk_2` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`);

--
-- Filtros para la tabla `persona`
--
ALTER TABLE `persona`
  ADD CONSTRAINT `persona_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`),
  ADD CONSTRAINT `usuario_ibfk_2` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

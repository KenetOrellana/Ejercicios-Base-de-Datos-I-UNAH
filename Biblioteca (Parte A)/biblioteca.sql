/*
Alumno: KENET FRANCISCO ORELLANA MEZA
# de cuenta: 20141011708 
*/

USE biblioteca;

DROP TABLE IF EXISTS ofrece;
DROP TABLE IF EXISTS escribe;
DROP TABLE IF EXISTS autores;
DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS ubicaciones;
DROP TABLE IF EXISTS prestamos;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS lectores;

CREATE TABLE IF NOT EXISTS empleados(
	no_empleado INT,
    p_nombre VARCHAR(50) NOT NULL,
    s_nombre VARCHAR(50) DEFAULT NULL,
    p_apellido VARCHAR(50) NOT NULL,
    s_apellido VARCHAR(50) NULL,
    identidad VARCHAR(15) NULL COMMENT 'El formato es XXXX-XXXX-XXXXX',
    dir_residencia VARCHAR(200) NULL,
    fec_nacimiento DATE,
    estado_civil VARCHAR(50) NULL,
    sexo VARCHAR(50),
    dia_ingreso INT NULL,
    mes_ingreso INT NULL,
    anio_ingreso INT NULL,
    cargo VARCHAR(50) NULL,
    CONSTRAINT PK_EMPLEADOS PRIMARY KEY (no_empleado),
    CONSTRAINT UNIQUE UK_IDENTIDAD_EMP (identidad),
    CONSTRAINT CK_SEXO_EMP CHECK (sexo in ('Masculino', 'Femenino', 'No registrado'))
);

CREATE TABLE IF NOT EXISTS lectores(
	no_carnet INT,
    nombre_completo VARCHAR(200) NULL,
    identidad VARCHAR(15) NULL COMMENT 'El formato es XXXX-XXXX-XXXXX',
    dir_residencia VARCHAR(200) NULL,
    estado_civil VARCHAR(50) NULL,
    sexo VARCHAR(50),
    dia_ingreso_lector INT NULL,
    mes_ingreso_lector INT NULL,
    anio_ingreso_lector INT NULL,    
    CONSTRAINT PK_LECTORES PRIMARY KEY (no_carnet),
    CONSTRAINT UNIQUE UK_IDENTIDAD_LECT (identidad),
    CONSTRAINT CK_SEXO_LECT CHECK (sexo in ('Masculino', 'Femenino', 'No registrado'))
);

CREATE TABLE IF NOT EXISTS prestamos(
	id_prestamo INT AUTO_INCREMENT,
    fecha_prestamo DATETIME DEFAULT CURRENT_TIMESTAMP(),
    fecha_retorno DATE,
    lectores_no_carnet INT NOT NULL,
    empleados_no_empleado INT NOT NULL,
    CONSTRAINT PK_PRESTAMOS PRIMARY KEY (id_prestamo),
    CONSTRAINT FK_PRESTAMOS_LECTORES FOREIGN KEY (lectores_no_carnet) REFERENCES lectores(no_carnet) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_PRESTAMOS_EMPLEADOS FOREIGN KEY (empleados_no_empleado) REFERENCES empleados(no_empleado)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS ubicaciones (
	id_ubicacion INT NOT NULL,
    columna INT NULL,
    fila INT NULL,    
    num_estante INT NULL,
    CONSTRAINT PK_UBICACIONES PRIMARY KEY (id_ubicacion)
);

CREATE TABLE IF NOT EXISTS libros (
	isbn VARCHAR(50) NOT NULL,
    edicion INT NULL,
    cantidad_ejemplares INT NULL,
    categoria VARCHAR(50) NULL,
    editorial VARCHAR(50) NULL,
    fecha_publicacion DATE NULL,
    ubicaciones_id_ubicacion INT NOT NULL,
    CONSTRAINT PK_LIBROS PRIMARY KEY (isbn),
    CONSTRAINT FK_LIBROS_UBICACIONES FOREIGN KEY (ubicaciones_id_ubicacion) REFERENCES ubicaciones (id_ubicacion)
);

CREATE TABLE IF NOT EXISTS ofrece (
	prestamos_id_prestamo INT NOT NULL,
	libros_isbn VARCHAR(50) NOT NULL,
	CONSTRAINT PK_OFRECE PRIMARY KEY (prestamos_id_prestamo, libros_isbn),
	CONSTRAINT FK_OFRECE_PRESTAMOS FOREIGN KEY (prestamos_id_prestamo) REFERENCES prestamos (id_prestamo),
	CONSTRAINT FK_OFRECE_LIBROS FOREIGN KEY (libros_isbn) REFERENCES libros (isbn)
);

CREATE TABLE IF NOT EXISTS autores (
	id_autor INT NOT NULL,
	nombre_completo VARCHAR(200) NULL,
	identidad VARCHAR(15) NULL,
	sexo VARCHAR(50) NULL,
	fec_nacimiento VARCHAR(50) NULL,
	CONSTRAINT PK_AUTORES PRIMARY KEY (id_autor),
	CONSTRAINT UNIQUE UK_IDENTIDAD_AUT (identidad)
);

CREATE TABLE IF NOT EXISTS escribe (
	autores_id_autor INT NOT NULL,
	libros_isbn VARCHAR(50) NOT NULL
);

ALTER TABLE escribe ADD PRIMARY KEY (autores_id_autor, libros_isbn);
-- ALTER TABLE escribe DROP PRIMARY KEY;

ALTER TABLE escribe ADD CONSTRAINT FK_ESCRIBE_AUTORES FOREIGN KEY (autores_id_autor) REFERENCES autores(id_autor);
ALTER TABLE escribe ADD CONSTRAINT FK_ESCRIBE_LIBROS FOREIGN KEY (libros_isbn) REFERENCES libros(isbn);
-- alter table escribe drop foreign key FK_ESCRIBE_AUTORES;

ALTER TABLE libros MODIFY COLUMN edicion INT NOT NULL;
ALTER TABLE libros MODIFY COLUMN edicion VARCHAR(50) NULL;
ALTER TABLE libros MODIFY COLUMN edicion INT NOT NULL COMMENT 'Este campo almacena la edicion del libro';

/*Esta sección de ALTER TABLE empleados la coloqué entre comentarios ya que se está agregando una columna 
salario_mensual y al ejecutar genera error

ALTER TABLE empleados ADD COLUMN salario decimal(10,2) not null;
ALTER TABLE empleados CHANGE COLUMN salario salario_mensual decimal(10,2) not null;*/

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO empleados (no_empleado, p_nombre, s_nombre, p_apellido, s_apellido, identidad, dir_residencia, fec_nacimiento, estado_civil, sexo, dia_ingreso, mes_ingreso, anio_ingreso, cargo) 
VALUES (117081, 'Bryan', 'Giovanni', 'Rochez', 'Mejia', '1006-1995-00453', 'Colonia Cerro Grande, Sector 2', '1995-01-01', 'Casado', 'Masculino', 1, 3, 2015, 'Director de biblioteca'),
(117082, 'Jonathan', 'Josue', 'Rubio', 'Toro', '0801-1996-34607', 'Colonia Hato de Enmedio, Sector 5', '1996-10-21', 'Casado', 'Masculino', 7, 2, 2016, 'Jefe de area'),
(117083, 'Daniela', 'Marivel', 'Zelaya', 'Ucles', '1006-1994-76543', 'Colonia San Miguel, Bloque G', '1994-07-15', 'Casada', 'Femenino', 8, 6, 2018, 'Responsable de desarrollo de colecciones'),
(117084, 'Eunice', 'Carolina', 'Medina', 'Andara', '1006-1992-56782', 'Barrio La Concordia, Calle Las Mercedes', '1992-04-30', 'Soltera', 'Femenino', 14, 11, 2008, 'Responsable departamento de servicios al publico'),
(117085, 'Carlos', 'Adalberto', 'Martinez', 'Valladares', '0801-1991-00223', 'Residencial El Trapiche', '1991-04-12', 'Soltero', 'Masculino', 5, 6, 2006, 'Ayudante de biblioteca'),
(117086, 'Julio', 'Salvador', 'Cordoba', 'Figueroa', '0501-1995-34764', 'Barrio Buenos Aires, Calle Principal', '1995-09-17', 'Casado', 'Masculino', 1, 3, 2015, 'Auxiliar de biblioteca'),
(117087, 'Sofia', 'Melissa', 'Maradiaga', 'Valeriano', '0601-1990-67243', 'Colonia El Carrizal', '1991-01-24', 'Soltera', 'Femenino', 25, 9, 2014, 'Bibliotecario de información y referencia'),
(117088, 'Jorge', 'Tulio', 'Martinez', 'Ruiz', '0301-1987-57374', 'Colonia Villa Olimpica', '1987-12-10', 'Casado', 'Masculino', 7, 3, 2011, 'Responsable unidad de catalogo'),
(117089, 'Patricia', 'Maria', 'Sanchez', 'Maradiaga', '0701-1984-57837', 'Colonia Kennedy', '1984-05-31', 'Casada', 'Femenino', 26, 9, 2018, 'Bibliotecario de fondo antiguo'),
(1170810, 'Juan', 'Jose', 'Bonilla', 'Garcia', '0201-1984-35685', 'Barrio Morazan, Calle Sin Sol', '1984-04-16', 'Soltero', 'Masculino', 12, 7, 2020, 'Bibliotecario infantil y juvenil');

INSERT INTO lectores (no_carnet, nombre_completo, identidad, dir_residencia, estado_civil, sexo, dia_ingreso_lector, mes_ingreso_lector, anio_ingreso_lector) 
VALUES (4563721, 'Maria Mireya Acevedo Manriquez', '0801-1997-16999', 'Colonia Las Uvas', 'Soltera', 'Femenino', 1, 10, 2012),
(4563722, 'Jose Israel Alcantar Camacho', '0801-1988-14979', 'Barrio Buenos Aires', 'Soltero', 'Masculino', 3, 7, 2017),
(4563723, 'Maria Ofelia Aguilar Lemus', '0801-1989-56929', 'Colonia Arturo Quezada', 'Casada', 'Femenino', 8, 10, 2015),
(4563724, 'Victor Hugo Alejo Guerrero', '1006-1979-00546', 'Colonia La Esperanza', 'Casado', 'Masculino', 24, 5, 2014),
(4563725, 'Enrique Ali Altamirano Garcia', '0201-1968-63945', 'Colonia El Sitio', 'Soltero', 'Masculino', 11, 2, 2016),
(4563726, 'Jacinta Guillermina Alderete Porras', '1006-1986-02345', 'Barrio Los Dolores', 'Casada', 'Femenino', 6, 3, 2017),
(4563727, 'Jesus David Alvarado Barbosa', '1006-1990-45627', 'Colonia Miraflores', 'Soltero', 'Masculino', 20, 4, 2007),
(4563728, 'Castro Alfredo Aragon Jimenez', '0301-1999-87234', 'Residencial Plaza', 'Casado', 'Masculino', 12, 7, 2018),
(4563729, 'Javier Leonardo Arredondo Ovalle', '0201-1995-45823', 'Prados Universitarios', 'Casado', 'Masculino', 2, 11, 2011),
(45637210, 'Arturo Ramiro Amaya Salvador', '0801-1996-37383', 'Colonia Humuya', 'Soltero', 'Masculino', 3, 12, 2014);

INSERT INTO autores (id_autor, nombre_completo, identidad, sexo, fec_nacimiento) 
VALUES (67371, 'Gabriel Garcia Marquez', '6053-1927-53450', 'Masculino', '1927-03-06'),
(67372, 'Miguel de Cervantes Saavedra', '8075-1547-86783', 'Masculino', '1547-09-29'),
(67373, 'Hugh David Young', '7365-1930-45657', 'Masculino', '1927-11-03'),
(67374, 'Ramon Amaya Amador', '1807-1916-00743', 'Masculino', '1916-04-29'),
(67375, 'Jose Froylan de Jesus Canales', '1501-1875-71249', 'Masculino', '1875-07-07'),
(67376, 'Clementina Suarez Zelaya', '1501-1902-74035', 'Femenino', '1902-04-12'),
(67377, 'Lucila Gamero de Medina', '0703-1873-00123', 'Femenino', '1873-06-12'),
(67378, 'Maria Eugenia Ramos', '0801-1959-07542', 'Femenino', '1959-11-26'),
(67379, 'Juan Ramon Molina', '0801-1875-55249', 'Masculino', '1875-04-17'),
(673710, 'Rafael Heliodoro Valle', '0801-1891-45001', 'Masculino', '1891-09-01');

INSERT INTO ubicaciones (id_ubicacion, columna, fila, num_estante) 
VALUES (5791, 2, 3, 12),
(5792, 4, 23, 55),
(5793, 10, 32, 8),
(5794, 65, 9, 16),
(5795, 11, 13, 4),
(5796, 19, 33, 65),
(5797, 1, 27, 3),
(5798, 5, 42, 80),
(5799, 33, 20, 50),
(57910, 7, 68, 90);

INSERT INTO libros (isbn, edicion, cantidad_ejemplares, categoria, editorial, fecha_publicacion, ubicaciones_id_ubicacion) 
VALUES ('978-84-2391-900-0-1708', 2, 3, 'Literatura', 'Espasa-Calpe', '1982-06-30', 5791),
('978-84-3761-315-4-1568', 10, 600, 'Literatura', 'Catedra', '2006-01-19', 5792),
('978-08-0537-826-9-3209', 8, 1000, 'Matematicas y ciencias naturales', 'Pearson Education', '2000-04-30', 5793),
('978-99-9266-338-7-1792', 26, 20, 'Literatura', 'Editorial Ramon Amaya Amador', '2010-11-29', 5794),
('978-09-8878-122-1-3265', 15, 180, 'Literatura', 'Casasola Editores', '2013-11-01', 5795),
('978-99-9263-274-1-5589', 22, 150, 'Literatura', 'Editorial Universitaria', '2013-11-29', 5796),
('978-99-9263-372-4-6575', 42, 300, 'Literatura', 'Guaymuras', '2008-04-30', 5797),
('978-99-9261-208-8-1452', 12, 130, 'Literatura', 'Ediciones Guardabarranco', '2000-07-30', 5798),
('978-99-9268-502-0-2454', 8, 50, 'Literatura', 'Inversiones Editorial Poeta Sosa', '2016-02-29', 5799),
('978-06-6688-371-1-5426', 11, 100, 'Literatura', 'Forgotten Books', '2019-02-14', 57910);

INSERT INTO prestamos (id_prestamo, fecha_prestamo, fecha_retorno, lectores_no_carnet, empleados_no_empleado) 
VALUES (17024581, '2017-03-06', '2017-03-15', 4563721, 117081),
(17024582, '2017-05-08', '2017-05-25', 4563722, 117082),
(17024583, '2017-11-12', '2017-12-01', 4563723, 117083),
(17024584, '2019-10-12', '2019-10-20', 4563724, 117084),
(17024585, '2019-02-28', '2019-03-17', 4563725, 117085),
(17024586, '2020-09-06', '2020-09-19', 4563726, 117086),
(17024587, '2020-02-09', '2020-02-26', 4563727, 117087),
(17024588, '2021-12-01', '2021-12-22', 4563728, 117088),
(17024589, '2022-10-17', '2022-10-31', 4563729, 117089),
(170245810, '2022-11-11', '2022-11-16', 45637210, 1170810);

INSERT INTO ofrece (prestamos_id_prestamo, libros_isbn) 
VALUES (17024581, '978-84-2391-900-0-1708'),
(17024582, '978-84-3761-315-4-1568'),
(17024583, '978-08-0537-826-9-3209'),
(17024584, '978-99-9266-338-7-1792'),
(17024585, '978-09-8878-122-1-3265'),
(17024586, '978-99-9263-274-1-5589'),
(17024587, '978-99-9263-372-4-6575'),
(17024588, '978-99-9261-208-8-1452'),
(17024589, '978-99-9268-502-0-2454'),
(170245810, '978-06-6688-371-1-5426');

INSERT INTO escribe (autores_id_autor, libros_isbn) 
VALUES (67371, '978-84-2391-900-0-1708'),
(673712, '978-84-3761-315-4-1568'),
(673713, '978-08-0537-826-9-3209'),
(673714, '978-99-9266-338-7-1792'),
(673715, '978-09-8878-122-1-3265'),
(673716, '978-99-9263-274-1-5589'),
(673717, '978-99-9263-372-4-6575'),
(673718, '978-99-9261-208-8-1452'),
(673719, '978-99-9268-502-0-2454'),
(6737110, '978-06-6688-371-1-5426');

/*DESCRIBE AUTORES;

select * from autores;
select * from escribe;
select * from libros;
INSERT INTO autores (id_autor, nombre_completo, identidad, fec_nacimiento, sexo) 
VALUES (1, 'MARIA PONCE', '0807-1234-13765', '1990-02-17', 'Femenino');

INSERT INTO autores ( sexo) 
VALUES (null);

INSERT INTO autores VALUES (2, 'KARLA PEREZ', '0101-1237-13265', 'Femenino', '2001-02-17');

INSERT INTO escribe VALUES (2, 'ad-123');

DELETE FROM escribe WHERE autores_id_autor=2;
DELETE FROM autores WHERE id_autor=0 OR id_autor=3;
DELETE FROM autores;

truncate autores;
delete from escribe;

commit;
rollback;

SET FOREIGN_KEY_CHECKS=0;
SET FOREIGN_KEY_CHECKS=1;
set autocommit=0;
set autocommit=1;

UPDATE autores SET nombre_completo='MARIA PONCE AGUIRRE', identidad='0807-1234-13700' WHERE id_autor=1;
UPDATE autores SET id_autor=1 WHERE id_autor=3;*/

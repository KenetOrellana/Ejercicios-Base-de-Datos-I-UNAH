/*
Alumno: KENET FRANCISCO ORELLANA MEZA
# de cuenta: 20141011708 
*/

USE colegio;

DROP TABLE IF EXISTS alumnos;
DROP TABLE IF EXISTS notas;
DROP TABLE IF EXISTS promedios_anuales;
DROP TABLE IF EXISTS promedios_globales;
DROP TABLE IF EXISTS carreras;
DROP TABLE IF EXISTS asignaturas;
DROP TABLE IF EXISTS cursos;
DROP TABLE IF EXISTS secciones;
DROP TABLE IF EXISTS matriculas;
DROP TABLE IF EXISTS empleados_docente;
DROP TABLE IF EXISTS clases_por_seccion;

CREATE TABLE IF NOT EXISTS alumnos(
	rne VARCHAR(255) NOT NULL,
    primerNombre VARCHAR(255) NOT NULL,
    segundoNombre VARCHAR(255) NULL,
    primerApellido VARCHAR(255) NOT NULL,
    segundoApellido VARCHAR(255) NULL,
    genero VARCHAR(255) NOT NULL,
    fechaNac DATETIME NOT NULL,
    fechaIngreso DATETIME NOT NULL,
    lugarNac VARCHAR(255) NOT NULL,
    tipoSangre VARCHAR(255) NOT NULL,
    nombrePadre VARCHAR(255) NULL,
    nombreMadre VARCHAR(255) NULL,
    encargado VARCHAR(255) NULL,
    telefono VARCHAR(255) NULL,
    direccion VARCHAR(255) NOT NULL,
    eMail VARCHAR(255) NOT NULL,
    instProcedencia VARCHAR(255) NOT NULL,
    CONSTRAINT PK_ALUMNOS PRIMARY KEY (rne),
    CONSTRAINT CK_GENERO_ALUM CHECK (genero in ('Masculino', 'Femenino', 'No registrado'))
);

CREATE TABLE IF NOT EXISTS notas(
	idNota INT NOT NULL,
    idMatricula INT NOT NULL,
    idEmpleado VARCHAR(255) NOT NULL,
    idAsignatura VARCHAR(255) NOT NULL,
    nota1 DECIMAL(5,2) NULL,
    nota2 DECIMAL(5,2) NULL,
    nota3 DECIMAL(5,2) NULL,
    nota4 DECIMAL(5,2) NULL,
    promedio DECIMAL(5,2) NULL,
    recuperacion1 DECIMAL(5,2) NULL,
    recuperacion2 DECIMAL(5,2) NULL,
    fechaNota1 DATETIME NULL,
    fechaNota2 DATETIME NULL,
    fechaNota3 DATETIME NULL,
    fechaNota4 DATETIME NULL,
    fechaRecuperacion1 DATETIME,
    fechaRecuperacion2 DATETIME,
    CONSTRAINT PK_NOTAS PRIMARY KEY (idNota),
    CONSTRAINT CK_NOTA1_NOTAS CHECK (nota1 >=0 AND nota1 <=100),
    CONSTRAINT CK_NOTA2_NOTAS CHECK (nota2 >=0 AND nota2 <=100),
    CONSTRAINT CK_NOTA3_NOTAS CHECK (nota3 >=0 AND nota3 <=100),
    CONSTRAINT CK_NOTA4_NOTAS CHECK (nota4 >=0 AND nota4 <=100),
    CONSTRAINT CK_PROMEDIO_NOTAS CHECK (promedio >=0 AND promedio <=100),
    CONSTRAINT CK_RECUPERACION1_NOTAS CHECK (recuperacion1 >=0 AND recuperacion1 <=100),
    CONSTRAINT CK_RECUPERACION2_NOTAS CHECK (recuperacion2 >=0 AND recuperacion2 <=100)
);

CREATE TABLE IF NOT EXISTS promedios_anuales(
    rne VARCHAR(255) NOT NULL,
    anio INT NOT NULL,
    promedio DECIMAL(5,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS promedios_globales(
    rne VARCHAR(255) NOT NULL,
    promedio DECIMAL(5,2) NULL,
    añoInicial INT NULL,
    añoFinal INT NULL
);

CREATE TABLE IF NOT EXISTS carreras(
    idCarrera VARCHAR(4) NOT NULL,
    carrera VARCHAR(255) NOT NULL,
    abrevCarrera VARCHAR(3) NOT NULL,
    CONSTRAINT PK_CARRERAS PRIMARY KEY (idCarrera)
);

CREATE TABLE IF NOT EXISTS asignaturas(
    idAsignatura VARCHAR(255) NOT NULL,
    idCurso VARCHAR(255) NOT NULL,
    nombreAsignatura VARCHAR(255) NOT NULL,
    abreviaturaAsignatura VARCHAR(255) NOT NULL,
    horasSemanales SMALLINT NOT NULL,
    CONSTRAINT PK_ASIGNATURAS PRIMARY KEY (idAsignatura)
);

CREATE TABLE IF NOT EXISTS cursos(
    idCurso VARCHAR(255) NOT NULL,
    nombreCurso VARCHAR(255) NULL,
    idCarrera VARCHAR(4) NOT NULL,
    CONSTRAINT PK_CURSOS PRIMARY KEY (idCurso)
);

CREATE TABLE IF NOT EXISTS secciones(
    idSeccion VARCHAR(255) NOT NULL,
    idCurso VARCHAR(255) NOT NULL,
    cuposMatriculados SMALLINT NULL,
    cuposMaximos SMALLINT NOT NULL,
    nombreSeccion VARCHAR(255) NOT NULL,
    CONSTRAINT PK_SECCIONES PRIMARY KEY (idSeccion)
);

CREATE TABLE IF NOT EXISTS matriculas(
    idMatricula INT NOT NULL,
    rne VARCHAR(255) NOT NULL,
    id_curso VARCHAR(255) NOT NULL,
    idSeccion VARCHAR(255) NOT NULL,
    anioLectivo SMALLINT NOT NULL,
    fechaMatricula DATETIME NOT NULL,
    repite TINYINT(1) NOT NULL,
    CONSTRAINT PK_MATRICULAS PRIMARY KEY (idMatricula),
    CONSTRAINT CK_ANIOLECTIVO_MATRICULAS CHECK (anioLectivo >= 2020)
);

CREATE TABLE IF NOT EXISTS empleados_docente(
    idEmpleado VARCHAR(255) NOT NULL,
    nombreEmpleado VARCHAR(255) NOT NULL,
    apellidoEmpleado VARCHAR(255) NOT NULL,
    telefono VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    horasTrabajo SMALLINT NOT NULL,
    registroImprema VARCHAR(255) NOT NULL,
    fechaIngreso DATETIME NOT NULL,
    CONSTRAINT PK_EMPLEADOS_DOCENTE PRIMARY KEY (idEmpleado)
);

CREATE TABLE IF NOT EXISTS clases_por_seccion(
    id INT NOT NULL,
    idEmpleado VARCHAR(255) NOT NULL,
    idAsignatura VARCHAR(255) NOT NULL,
    idSeccion VARCHAR(255) NOT NULL,
    anio SMALLINT NOT NULL,
    CONSTRAINT PK_CLASES_POR_SECCION PRIMARY KEY (id)
);

ALTER TABLE promedios_anuales ADD PRIMARY KEY (rne,anio);
ALTER TABLE promedios_globales ADD PRIMARY KEY (rne);
ALTER TABLE promedios_anuales ADD CONSTRAINT FK_PROMEDIOS_ANUALES_ALUMNOS FOREIGN KEY (rne) REFERENCES alumnos(rne);
ALTER TABLE promedios_globales ADD CONSTRAINT FK_PROMEDIOS_GLOBALES_ALUMNOS FOREIGN KEY (rne) REFERENCES alumnos(rne);
ALTER TABLE notas ADD CONSTRAINT FK_NOTAS_MATRICULAS FOREIGN KEY (idMatricula) REFERENCES matriculas(idMatricula);
ALTER TABLE notas ADD CONSTRAINT FK_NOTAS_EMPLEADOS_DOCENTES FOREIGN KEY (idEmpleado) REFERENCES empleados_docentes(idEmpleado);
ALTER TABLE notas ADD CONSTRAINT FK_NOTAS_ASIGNATURAS FOREIGN KEY (idAsignatura) REFERENCES asignaturas(idAsignatura);
ALTER TABLE asignaturas ADD CONSTRAINT FK_ASIGNATURAS_CURSOS FOREIGN KEY (idCurso) REFERENCES cursos(idCurso);
ALTER TABLE cursos ADD CONSTRAINT FK_CURSOS_CARRERAS FOREIGN KEY (idCarrera) REFERENCES carreras(idCarrera);
ALTER TABLE matriculas ADD CONSTRAINT FK_MATRICULAS_ALUMNOS FOREIGN KEY (rne) REFERENCES alumnos(rne);
ALTER TABLE matriculas ADD CONSTRAINT FK_MATRICULAS_CURSOS FOREIGN KEY (id_curso) REFERENCES cursos(idCurso);
ALTER TABLE matriculas ADD CONSTRAINT FK_MATRICULAS_SECCIONES FOREIGN KEY (idSeccion) REFERENCES secciones(idSeccion);
ALTER TABLE secciones ADD CONSTRAINT FK_SECCIONES_CURSOS FOREIGN KEY (idCurso) REFERENCES cursos(idCurso);
ALTER TABLE clases_por_seccion ADD CONSTRAINT FK_CLASES_POR_SECCION_EMPLEADOS_DOCENTES FOREIGN KEY (idEmpleado) REFERENCES empleados_docentes(idEmpleado);
ALTER TABLE clases_por_seccion ADD CONSTRAINT FK_CLASES_POR_SECCION_ASIGNATURAS FOREIGN KEY (idAsignatura) REFERENCES asignaturas(idAsignatura);
ALTER TABLE clases_por_seccion ADD CONSTRAINT FK_CLASES_POR_SECCION_SECCIONES FOREIGN KEY (idSeccion) REFERENCES secciones(idSeccion);

SET FOREIGN_KEY_CHECKS=0;

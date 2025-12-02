create DATABASE BDTEC
go
use BDTEC
go
CREATE TABLE PLAZA (
    ID_PLAZA INT NOT NULL,
    HORARIO VARCHAR(50),
	HORAS INT
);

CREATE TABLE DEPARTAMENTO (
    ID_DEPARTAMENTO INT NOT NULL,
	NOMBRE VARCHAR(50)
);

CREATE TABLE EMPLEADO (
    ID_EMPLEADO INT NOT NULL,
    ID_PLAZA INT NOT NULL,
    ID_DEPARTAMENTO INT NOT NULL,
    NOMBRE VARCHAR(100),
    APELLIDO_MAT VARCHAR(60),
    APELLIDO_PAT VARCHAR(60),
    CAMPUS VARCHAR(50),
	VIGENCIA INT CONSTRAINT DF_DOCENTE_VIGENTE DEFAULT (1),
	CORREO VARCHAR(50),
    TELEFONO VARCHAR(15),
    CONSTRAINT PK_DOCENTE PRIMARY KEY (ID_EMPLEADO),
    CONSTRAINT CHK_DOCENTE_VIGENTE CHECK (VIGENCIA IN (0,1))
);

CREATE TABLE DOCUMENTO (
    ID_DOCUMENTO INT NOT NULL IDENTITY(1,1),
    NOMBRE VARCHAR(50),
	DATOS_JSON NVARCHAR(MAX)
);

CREATE TABLE EMPLEADOSXDOCUMENTO (
    ID_EMPLEADO INT NOT NULL,
    ID_DOCUMENTO INT NOT NULL,
    DATOS_JSON NVARCHAR(MAX) NULL,
    CONSTRAINT CK_DOC_ACT_JSO CHECK (ISJSON(DATOS_JSON)=1)
);
-- =====================================
-- PRIMARY KEYS
-- =====================================

ALTER TABLE PLAZA
ADD CONSTRAINT PK_PLAZA PRIMARY KEY (ID_PLAZA);

ALTER TABLE DEPARTAMENTO
ADD CONSTRAINT PK_DEPARTAMENTO PRIMARY KEY (ID_DEPARTAMENTO);

ALTER TABLE DOCUMENTO
ADD CONSTRAINT PK_ACTIVIDAD PRIMARY KEY (ID_DOCUMENTO);

ALTER TABLE EMPLEADOSXDOCUMENTO
ADD CONSTRAINT PK_EMPLEADOSXACTIVIDADES PRIMARY KEY (ID_EMPLEADO, ID_DOCUMENTO);

-- =====================================
-- FOREIGN KEYS
-- =====================================

ALTER TABLE EMPLEADO
ADD CONSTRAINT FK_EMPLEADO_PLAZA FOREIGN KEY (ID_PLAZA)
REFERENCES PLAZA(ID_PLAZA);

ALTER TABLE EMPLEADO
ADD CONSTRAINT FK_EMPLEADO_DEPARTAMENTO FOREIGN KEY (ID_DEPARTAMENTO)
REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO);

ALTER TABLE EMPLEADOSXDOCUMENTO
ADD CONSTRAINT FK_EMPLEADOSXACTIVIDADES_EMPLEADO FOREIGN KEY (ID_EMPLEADO)
REFERENCES EMPLEADO(ID_EMPLEADO);

ALTER TABLE EMPLEADOSXDOCUMENTO
ADD CONSTRAINT FK_EMPLEADOSXACTIVIDADES_ACTIVIDAD FOREIGN KEY (ID_DOCUMENTO)
REFERENCES DOCUMENTO(ID_DOCUMENTO);

-- =====================================
-- CHECKS y DEFAULTS (ejemplos)
-- =====================================

ALTER TABLE EMPLEADO
ADD CONSTRAINT CHK_CORREO CHECK (CORREO LIKE '%@%');

ALTER TABLE PLAZA
ADD CONSTRAINT CHK_HORARIO CHECK (HORARIO IS NOT NULL);
-- =====================================
go
CREATE OR ALTER VIEW VISTA_EMPLEADOS_COMPLETA AS
SELECT 
    e.ID_EMPLEADO,
    e.NOMBRE AS NOMBRE_EMPLEADO,
    e.CORREO AS CORREO_EMPLEADO,
    e.TELEFONO,
    e.CAMPUS,
    p.HORARIO AS HORARIO_PLAZA,
    d.nombre as NOMBRE_DEPARTAMENTO
FROM EMPLEADO e
JOIN PLAZA p ON e.ID_PLAZA = p.ID_PLAZA
JOIN DEPARTAMENTO d ON e.ID_DEPARTAMENTO = d.ID_DEPARTAMENTO;
go
insert into PLAZA (ID_PLAZA,HORARIO,HORAS)
VALUES (1,'COMPLETO',40)

insert into PLAZA (ID_PLAZA,HORARIO,HORAS)
VALUES (2,'MEDIO TIEMPO',20)
INSERT INTO DEPARTAMENTO (ID_DEPARTAMENTO, NOMBRE)
VALUES
(1, 'Departamento Académico'),
(2, 'Dirección General del TecNM'),
(3, 'DDIE del TecNM'),
(4, 'Dirección del Instituto Tecnológico'),
(5, 'Instituto Organizador'),
(6, 'Departamento de Desarrollo Académico'),
(7, 'Departamento de Ciencias Básicas'),
(8, 'Departamento de Servicios Escolares');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CORREO, TELEFONO)
VALUES (1, 1, 1, 'Carlos', 'Ramírez', 'González', 'Culiacán', 1,'carlos.rg@itc.mx', '6671234567');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CORREO, TELEFONO)
VALUES (2, 2, 2, 'María', 'Lozano', 'Hernández', 'Culiacán', 1, 'maria.lh@itc.mx', '6672345678');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CORREO, TELEFONO)
VALUES (3, 1, 3, 'Jorge', 'Pérez', 'Cárdenas', 'Guamúchil', 1,  'jorge.pc@itc.mx', '6673456789');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CORREO, TELEFONO)
VALUES (4, 2, 4, 'Ana', 'Soto', 'Valenzuela', 'Culiacán', 1, 'ana.sv@itc.mx', '6674567890');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CORREO, TELEFONO)
VALUES (5, 1, 5, 'Ricardo', 'Mendoza', 'Torres', 'Los Mochis', 1, 'ricardo.mt@itc.mx', '6675678901');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CORREO, TELEFONO)
VALUES (6, 1, 5, 'Ricardo', 'Quintero', 'Torres', 'Los Mochis', 1, 'Quintero.t@itc.mx', '6675678901');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CORREO, TELEFONO)
VALUES (7, 1, 5, 'JUAN', 'HERNANDEZ', 'Lopez', 'Los Mochis', 1, 'j.lopez@tecnm.mx', '6674923943');


INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES 
('Copia Examen de Grado', '{
    "VAR_PROFESOR": "",
    "VAR_GRADO": "",
    "VAR_MAESTRIA": "",
    "VAR_CIUDAD_ESTADO": "",
    "VAR_DIA": "",
    "VAR_MES": "",
    "VAR_ANIO": "",
    "VAR_TITULO_TESIS": "",
    "VAR_JEFE_DIRECCION_GENERAL": "",
    "VAR_JEFE_SERVICIOS_ESCOLARES": "",
    "VAR_FIRMA_DIRECCION_GENERAL": "",
    "VAR_FIRMA_SERVICIOS_ESCOLARES": ""
}');




INSERT INTO DOCUMENTO(NOMBRE, DATOS_JSON) VALUES ('Constancia Cumplimiento SPD',
'{
  "VAR_FOLIO_CONSTANCIA": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_ASIGNATURA_ASESORIA": "",
  "VAR_PERIODO_CONSTANCIA": "",
  "VAR_TOTAL_ESTUDIANTES": "",
  "VAR_DIA_CONSTANCIA": "",
  "VAR_MES_CONSTANCIA": "",
  "VAR_ANIO_CONSTANCIA": "",
  "VAR_JEFE_CIENCIAS_BASICAS": "",
  "VAR_JEFE_SUBDIRECCION_ACADEMICA": "",
  "VAR_FIRMA_CIENCIAS_BASICAS": "",
  "VAR_FIRMA_SUBDIRECCION_ACADEMICA": ""
}');
INSERT INTO DOCUMENTO(NOMBRE, DATOS_JSON) VALUES ('Constancia DDIE (Competencias de Tutores)',
'{
  "VAR_FOLIO_CONSTANCIA": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_DURACION_HRS": "",
  "VAR_PERIODO": "",
  "VAR_DIA": "",
  "VAR_MES": "",
  "VAR_ANIO": "",
  "VAR_JEFE_DOCENCIA_E_INNOVACION_EDUCATIVA": "",
  "VAR_FIRMA_DOCENCIA_E_INNOVACION_EDUCATIVA": ""
}');
INSERT INTO DOCUMENTO(NOMBRE, DATOS_JSON) VALUES ('Oficio Comisión (Proyecto Estratégico)',
'{
  "VAR_OFICIO_COMISION": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_NOMBRE_CURSO": "",
  "VAR_FECHA_INICIO_COMISION": "",
  "VAR_FECHA_FIN_COMISION": "",
  "VAR_JEFE_DEPARTAMENTO_ACADEMICO": "",
  "VAR_FIRMA_DEPARTAMENTO_ACADEMICO": ""
}');

INSERT INTO DOCUMENTO(NOMBRE, DATOS_JSON) VALUES ('Oficio Comisión (Ambientes Virtuales)',
'{
  "VAR_OFICIO_COMISION": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_NOMBRE_CURSO": "",
  "VAR_FECHA_INICIO_COMISION": "",
  "VAR_FECHA_FIN_COMISION": "",
  "VAR_JEFE_DEPARTAMENTO_ACADEMICO": "",
  "VAR_FIRMA_DEPARTAMENTO_ACADEMICO": ""
}');

INSERT INTO DOCUMENTO(NOMBRE, DATOS_JSON) VALUES ('Oficio Comisión (curso_diplomado)',
'{
  "VAR_OFICIO_COMISION": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_NOMBRE_CURSO": "",
  "VAR_INSTITUCION_CURSO": "",
  "VAR_FECHA_INICIO_COMISION": "",
  "VAR_FECHA_FIN_COMISION": "",
  "VAR_JEFE_DEPARTAMENTO_ACADEMICO": "",
  "VAR_FIRMA_DEPARTAMENTO_ACADEMICO": ""
}');

INSERT INTO DOCUMENTO(NOMBRE, DATOS_JSON) VALUES ('Oficio Comisión (curso-diplomado DDIE)',
'{
  "VAR_OFICIO_COMISION": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_NOMBRE_CURSO": "",
  "VAR_FECHA_INICIO_COMISION": "",
  "VAR_FECHA_FIN_COMISION": "",
  "VAR_JEFE_DEPARTAMENTO_ACADEMICO": "",
  "VAR_FIRMA_DEPARTAMENTO_ACADEMICO": ""
}');

INSERT INTO DOCUMENTO(NOMBRE, DATOS_JSON) VALUES ('Oficio Comisión (Educación Inclusiva)',
'{
  "VAR_OFICIO_COMISION": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_NOMBRE_CURSO": "",
  "VAR_FECHA_INICIO_COMISION": "",
  "VAR_FECHA_FIN_COMISION": "",
  "VAR_JEFE_DEPARTAMENTO_ACADEMICO": "",
  "VAR_FIRMA_DEPARTAMENTO_ACADEMICO": ""
}');







INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Copia Examen de Grado', '{
"VAR_PROFESOR":"",
"VAR_GRADO":"",
"VAR_MAESTRIA":"",
"VAR_CIUDAD_ESTADO":"",
"VAR_DIA":"",
"VAR_MES":"",
"VAR_ANIO":"",
"VAR_TITULO_TESIS":"",
"VAR_DIRECTOR":"",
"VAR_JEFE_ESCOLARES":"",
"VAR_FIRMA_DIR":"",
"VAR_FIRMA_JEF":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Oficio de Autorización de Apertura','{
"VAR_NUM_OFICIO":"",
"VAR_FECHA":"",
"VAR_NOMBRE_INSTITUTO":"",
"VAR_NIVEL_PROGRAMA":"",
"VAR_NOMBRE_PROGRAMA":"",
"VAR_CLAVE_REGISTRO":"",
"VAR_PERIODO_INICIO":"",
"VAR_DIRECTOR":"",
"VAR_FIRMA":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia con Nombres de Participantes','{
"VAR_DEPARTAMENTO":"",
"VAR_FECHA":"",
"VAR_JEFE_NOMBRE":"",
"VAR_NIVEL":"",
"VAR_PROGRAMA":"",
"VAR_FECHA_INICIO":"",
"VAR_FECHA_FIN":"",
"VAR_SUBDIRECTOR":"",
"NOMBRE_PARTICIPANTE_1":"",	
"NUMERO_1":"",
"NOMBRE_PARTICIPANTE_2":"",	
"NUMERO_2":"",
"NOMBRE_PARTICIPANTE_3":"",	
"NUMERO_3":"",
"VAR_FIRMA_SUB":"",
"VAR_FIRMA_JEFE":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia de Participación','{
"VAR_JEFE_DEP":"",
"VAR_PROFESOR":"",
"VAR_ID_PROFESOR":"",
"VAR_DEPARTAMENTO":"",
"VAR_FECHA_INICIO":"",
"VAR_FECHA_TERMINO":"",
"VAR_FECHA_EMISION":"",
"VAR_FIRMA_JEF":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia de Participación 1.4.8.2','{
"VAR_INSTITUTO":"",
"VAR_LUGAR_FECHA":"",
"VAR_PROFESOR":"",
"VAR_JEFE_DEPTO":"",
"VAR_LICENCIATURA":"",
"VAR_FECHA_INICIO":"",
"VAR_FECHA_FIN":"",
"VAR_MODULO1":"",
"VAR_MODULO2":"",
"VAR_SUBDIRECTOR":"",
"VAR_FIRMA_SUB":"",
"VAR_FIRMA_JEFE":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Oficio de Comisión','{
"VAR_NUM_OFICIO":"",
"VAR_LUGAR_FECHA":"",
"VAR_PROFESOR":"",
"VAR_DEPARTAMENTO":"",
"VAR_PROGRAMA":"",
"VAR_OBJETIVO_COMISION":"",
"VAR_FECHA_INICIO":"",
"VAR_FECHA_FIN":"",
"VAR_JEFE_DEP":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Oficio de Registro de Módulos','{
"VAR_NUM_REGISTRO":"",
"VAR_LUGAR_FECHA":"",
"VAR_DIRECTOR_INSTITUTO":"",
"VAR_INSTITUTO":"",
"VAR_LICENCIATURA":"",
"VAR_CLAVE1":"",
"VAR_CLAVE2":"",
"VAR_MODULO1":"",
"VAR_MODULO2":"",
"VAR_HORAS1":"",
"VAR_HORAS2":"",
"VAR_FECHA_INI1":"",
"VAR_FECHA_INI2":"",
"VAR_FECHA_FIN1":"",
"VAR_FECHA_FIN2":"",
"VAR_DIRECTOR_DOCENCIA":"",
"VAR_FIRMA":""
}');

-- MIGUELAX

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia de participación en cuerpos colegiados', '{
"Var_Fecha":"",
"Var_Oficio":"",
"Var_Nombre":"",
"Var_Semestre":"",
"Var_NumDictamen":"",
"Var_TotalAlumnos":"",
"Var_AlumnosConCredito":"",
"Var_Sello":"",
"Var_FirmaJefaDpto":"",
"Var_NombreJefaDpto":"",
"Var_PuestoJefaDpto":"",
"Var_FirmaJefeCentro":"",
"Var_FirmaResponsable":"",
"Var_NombreJefeCentro":"",
"Var_PuestoJefeCentro":"",
"Var_NombreResponsable":"",
"Var_PuestoResponsable":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Recursos educativos digitales', '{
"Var_Fecha":"",
"Var_Oficio":"",
"Var_Nombre":"",
"Var_Semestre":"",
"Var_Asignatura":"",
"Var_ProgramaNombre":"",
"Var_Sello":"",
"Var_NombreJefa":"",
"Var_PuestoJefa":"",
"Var_FirmaJefa":"",
"Var_NombrePresidente":"",
"Var_PuestoPresidente":"",
"Var_FirmaPresidente":"",
"Var_NombreResponsable":"",
"Var_PuestoResponsable":"",
"Var_FirmaResponsable":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Formato de implementación de estrategias', '{
"Var_Fecha":"",
"Var_Oficio":"",
"Var_Nombre":"",
"Var_Asignatura":"",
"Var_Estrategia":"",
"Var_ProgramaNombre":"",
"Var_Habilidades":"",
"Var_Sello":"",
"Var_FirmaJefa":"",
"Var_NombreJefa":"",
"Var_PuestoJefa":"",
"Var_FirmaPresidente":"",
"Var_FirmaResponsable":"",
"Var_NombrePresidente":"",
"Var_PuestoPresidente":"",
"Var_NombreResponsable":"",
"Var_PuestoResponsable":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Formato asesorías estudiantes', '{
"Var_Fecha":"",
"Var_Oficio":"",
"Var_Nombre":"",
"Var_Rol":"",
"Var_NombreDeCurso":"",
"Var_FechaInicio":"",
"Var_FechaFin":"",
"Var_Alcance":"",
"Var_funcionesRealizadas":"",
"Var_Sello":"",
"Var_FirmaTitular":"",
"Var_NombreTitular":"",
"Var_PuestoTitular":"",
"Var_FirmaResponsable":"",
"Var_NombreResponsable":"",
"Var_PuestoResponsable":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia asesoría lugares', '{
"Var_Fecha":"",
"Var_Oficio":"",
"Var_Nombre":"",
"Var_NombreProyecto":"",
"Var_NombreEvento":"",
"Var_Nivel":"",
"Var_Lugar":"",
"Var_FechaInicio":"",
"Var_FechaFin":"",
"Var_NumDictamen":"",
"Var_Sello":"",
"Var_FirmaTitular":"",
"Var_NombreTitular":"",
"Var_PuestoTitular":"",
"Var_FirmaResponsable":"",
"Var_NombreResponsable":"",
"Var_PuestoResponsable":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia de participación como jurado', '{
"Var_Fecha":"",
"Var_Oficio":"",
"Var_Nombre":"",
"Var_NombreEvento":"",
"Var_FechaInicio":"",
"Var_FechaFin":"",
"Var_Nivel":"",
"Var_Sello":"",
"Var_FirmaTitular":"",
"Var_NombreTitular":"",
"Var_PuestoTitular":"",
"Var_FirmaResponsable":"",
"Var_NombreResponsable":"",
"Var_PuestoResponsable":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Participación de comités', '{
"Var_Fecha":"",
"Var_Oficio":"",
"Var_Nombre":"",
"Var_NombreEvento":"",
"Var_FechaInicio":"",
"Var_FechaFin":"",
"Var_Nivel":"",
"Var_Sello":"",
"Var_FirmaTitular":"",
"Var_NombreTitular":"",
"Var_PuestoTitular":"",
"Var_FirmaResponsable":"",
"Var_NombreResponsable":"",
"Var_PuestoResponsable":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Oficio de Comisión por la persona titular del ITec', '{
"Var_Fecha":"",
"Var_Oficio":"",
"Var_Nombre":"",
"Var_Cargo":"",
"Var_NombreEvento":"",
"Var_FechaInicio":"",
"Var_FechaFin":"",
"Var_Nivel":"",
"Var_Sello":"",
"Var_FirmaTitular":"",
"Var_NombreTitular":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia de la institución organizadora', '{
"Var_NombreInstitucion":"",
"Var_LugarEvento":"",
"Var_Fecha":"",
"Var_Nombre":"",
"Var_Cargo":"",
"Var_NombreEvento":"",
"Var_FechaInicio":"",
"Var_FechaFin":"",
"Var_Nivel":"",
"Var_FirmaTitular":"",
"Var_NombreTitular":"",
"Var_PuestoTitular":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Participación en auditorías de sistemas de gestión', '{
"Var_Fecha":"",
"Var_Nombre":"",
"Var_RolAuditor":"",
"Var_sistema":"",
"Var_FechaInicio":"",
"Var_FechaFin":"",
"Var_LugarAuditoria":"",
"Var_FirmaTitular":"",
"Var_NombreTitular":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Consejo Nacional de Acreditación','{
"V_FECHA_INICIO":"",
"V_FECHA_FINAL":"",
"V_ESTADO":"",
"V_FECHA":"",
"VAR_FIRMA":"",
"VAR_PRESIDENTE":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia de Productos Obtenidos y su Impacto','{
"VAR_FECHA":"",
"VAR_NOMB_DOCENTE":"",
"VAR_NOMB_MATERIA":"",
"VAR_NOMB_ESTRATEGIA":"",
"VAR_NOMB_CARRERA":"",
"VAR_DESC_PRODUCTO":"",
"VAR_DESC_IMPACTO":"",
"VAR_DIA":"",
"VAR_MES":"",
"VAR_AÑO":"",
"VAR_FIRMA1":"",
"VAR_JEFE_DEPTO1":"",
"VAR_FIRMA2":"",
"VAR_JEFE_DEPTO2":"",
"VAR_FIRMA3":"",
"VAR_JEFE_DEPTO3":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia de Trabajo','{
"VAR_FECHA":"",
"VAR_NOMB_DOCENTE":"",
"VAR_NOMB_ASIGNATURA":"",
"VAR_NOMB_CARRERA":"",
"VAR_DIA":"",
"VAR_MES":"",
"VAR_AÑO":"",
"VAR_FIRMA1":"",
"VAR_JEFE_DEPTO1":"",
"VAR_FIRMA2":"",
"VAR_JEFE_DEPTO2":"",
"VAR_FIRMA3":"",
"VAR_JEFE_DEPTO3":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia de Tutoría','{
"VAR_NOM_DOCENTE":"",
"VAR_DEPARTAMENTO":"",
"VAR_PERIODO1":"",
"VAR_CANTIDAD_ALUMNOS1":"",
"VAR_CARRERA1":"",
"VAR_PERIODO2":"",
"VAR_CANTIDAD_ALUMNOS2":"",
"VAR_CARRERA2":"",
"VAR_TOTAL_ALUMNOS":"",
"VAR_FIRMA1":"",
"VAR_JEFE_DEPTO1":"",
"VAR_FIRMA2":"",
"VAR_JEFE_DEPTO2":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia Exención Examen Licenciatura','{
"VAR_FOLIO":"",
"VAR_NOMBRE_COMPLETO":"",
"VAR_NOCONTROL":"",
"VAR_INSTITUTO":"",
"VAR_CLAVE":"",
"VAR_CARRERA":"",
"VAR_OPCION_TITULACION":"",
"VAR_DIA":"",
"VAR_MES":"",
"VAR_AÑO":"",
"VAR_FIRMA1":"",
"VAR_NOMBRE_PRESI":"",
"VAR_CEDULA_PRESI":"",
"VAR_FIRMA2":"",
"VAR_NOMBRE_SECRE":"",
"VAR_CEDULA_SECRE":"",
"VAR_FIRMA3":"",
"VAR_NOMBRE_VOCAL":"",
"VAR_CEDULA_VOCAL":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia Exención Examen Maestría','{
"VAR_FOLIO":"",
"VAR_NOMBRE_COMPLETO":"",
"VAR_NOCONTROL":"",
"VAR_INSTITUTO":"",
"VAR_CLAVE":"",
"VAR_CARRERA":"",
"VAR_OPCION_TITULACION":"",
"VAR_DIA":"",
"VAR_MES":"",
"VAR_AÑO":"",
"VAR_FIRMA1":"",
"VAR_NOMBRE_PRESI":"",
"VAR_CEDULA_PRESI":"",
"VAR_FIRMA2":"",
"VAR_NOMBRE_SECRE":"",
"VAR_CEDULA_SECRE":"",
"VAR_FIRMA3":"",
"VAR_NOMBRE_VOCAL":"",
"VAR_CEDULA_VOCAL":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia Exención Examen Maestría (Codirector)','{
"VAR_FOLIO":"",
"VAR_NOMBRE_COMPLETO":"",
"VAR_NOCONTROL":"",
"VAR_INSTITUTO":"",
"VAR_CLAVE":"",
"VAR_CARRERA":"",
"VAR_OPCION_TITULACION":"",
"VAR_DIA":"",
"VAR_MES":"",
"VAR_AÑO":"",
"VAR_FIRMA1":"",
"VAR_NOMBRE_PRESI":"",
"VAR_CEDULA_PRESI":"",
"VAR_FIRMA2":"",
"VAR_NOMBRE_SECRE":"",
"VAR_CEDULA_SECRE":"",
"VAR_FIRMA3":"",
"VAR_NOMBRE_VOCAL":"",
"VAR_CEDULA_VOCAL":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia Exención Examen Doctorado','{
"VAR_FOLIO":"",
"VAR_NOMBRE_COMPLETO":"",
"VAR_NOCONTROL":"",
"VAR_INSTITUTO":"",
"VAR_CLAVE":"",
"VAR_CARRERA":"",
"VAR_OPCION_TITULACION":"",
"VAR_DIA":"",
"VAR_MES":"",
"VAR_AÑO":"",
"VAR_FIRMA1":"",
"VAR_NOMBRE_PRESI":"",
"VAR_CEDULA_PRESI":"",
"VAR_FIRMA2":"",
"VAR_NOMBRE_SECRE":"",
"VAR_CEDULA_SECRE":"",
"VAR_FIRMA3":"",
"VAR_NOMBRE_VOCAL":"",
"VAR_CEDULA_VOCAL":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia Exención Examen Doctorado (Codirector)','{
"VAR_FOLIO":"",
"VAR_NOMBRE_COMPLETO":"",
"VAR_NOCONTROL":"",
"VAR_INSTITUTO":"",
"VAR_CLAVE":"",
"VAR_CARRERA":"",
"VAR_OPCION_TITULACION":"",
"VAR_DIA":"",
"VAR_MES":"",
"VAR_AÑO":"",
"VAR_FIRMA1":"",
"VAR_NOMBRE_PRESI":"",
"VAR_CEDULA_PRESI":"",
"VAR_FIRMA2":"",
"VAR_NOMBRE_SECRE":"",
"VAR_CEDULA_SECRE":"",
"VAR_FIRMA3":"",
"VAR_NOMBRE_VOCAL":"",
"VAR_CEDULA_VOCAL":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia Exención Examen Especialización','{
"VAR_FOLIO":"",
"VAR_NOMBRE_COMPLETO":"",
"VAR_NOCONTROL":"",
"VAR_INSTITUTO":"",
"VAR_CLAVE":"",
"VAR_CARRERA":"",
"VAR_OPCION_TITULACION":"",
"VAR_DIA":"",
"VAR_MES":"",
"VAR_AÑO":"",
"VAR_FIRMA1":"",
"VAR_NOMBRE_PRESI":"",
"VAR_CEDULA_PRESI":"",
"VAR_FIRMA2":"",
"VAR_NOMBRE_SECRE":"",
"VAR_CEDULA_SECRE":"",
"VAR_FIRMA3":"",
"VAR_NOMBRE_VOCAL":"",
"VAR_CEDULA_VOCAL":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia SINODAL Técnico Superior','{
"VAR_NOMB_DOCENTE":"",
"VAR_FECHA_INICIO":"",
"VAR_FECHA_FIN":"",
"VAR_FOLIO1":"",
"VAR_FECHA1":"",
"VAR_NOM_ALUM1":"",
"VAR_CARRERA1":"",
"VAR_FUNCION1":"",
"VAR_FOLIO2":"",
"VAR_FECHA2":"",
"VAR_NOM_ALUM2":"",
"VAR_CARRERA2":"",
"VAR_FUNCION2":"",
"VAR_FOLIO3":"",
"VAR_FECHA3":"",
"VAR_NOM_ALUM3":"",
"VAR_CARRERA3":"",
"VAR_FUNCION3":"",
"VAR_LDIA":"",
"VAR_LMES":"",
"VAR_LAÑO":"",
"VAR_FIRMA":"",
"VAR_JEFE_DEPTO":""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES ('Constancia SINODAL Maestría','{
"VAR_NOMB_DOCENTE":"",
"VAR_FECHA_INICIO":"",
"VAR_FECHA_FIN":"",
"VAR_FOLIO1":"",
"VAR_FECHA1":"",
"VAR_NOM_ALUM1":"",
"VAR_CARRERA1":"",
"VAR_FUNCION1":"",
"VAR_FOLIO2":"",
"VAR_FECHA2":"",
"VAR_NOM_ALUM2":"",
"VAR_CARRERA2":"",
"VAR_FUNCION2":"",
"VAR_FOLIO3":"",
"VAR_FECHA3":"",
"VAR_NOM_ALUM3":"",
"VAR_CARRERA3":"",
"VAR_FUNCION3":"",
"VAR_LDIA":"",
"VAR_LMES":"",
"VAR_LAÑO":"",
"VAR_FIRMA":"",
"VAR_JEFE_DEPTO":""
}');



INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES 
('Oficio Comisión (Proyecto Estratégico)',
'{
  "VAR_OFICIO_COMISION": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_NOMBRE_CURSO": "",
  "VAR_FECHA_INICIO_COMISION": "",
  "VAR_FECHA_FIN_COMISION": "",
  "VAR_NOMBRE_JEFE_DDA": "",
  "VAR_FIRMA_JEFE_DDA": ""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES 
('Constancia Cumplimiento SPD',
'{
  "VAR_FOLIO_CONSTANCIA": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_ASIGNATURA_ASESORIA": "",
  "VAR_PERIODO_CONSTANCIA": "",
  "VAR_TOTAL_ESTUDIANTES": "",
  "VAR_DIA_CONSTANCIA": "",
  "VAR_MES_CONSTANCIA": "",
  "VAR_ANIO_CONSTANCIA": "",
  "VAR_NOMBRE_JEFE_CB": "",
  "VAR_NOMBRE_SUBDIRECTOR_ACADEMICO": "",
  "VAR_FIRMA_JEFE_CD": "",
  "VAR_FIRMA_SUB_ACADEM": ""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES 
('Constancia DDIE (Competencias de Tutores)',
'{
  "VAR_FOLIO_CONSTANCIA": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_DURACION_HRS": "",
  "VAR_PERIODO": "",
  "VAR_DIA": "",
  "VAR_MES": "",
  "VAR_ANIO": "",
  "VAR_NOMBRE_DIRECTOR_DDIE": "",
  "VAR_FIRMA_DIRECTOR_DDIE": ""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES 
('Oficio Comisión (Ambientes Virtuales)',
'{
  "VAR_OFICIO_COMISION": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_NOMBRE_CURSO": "",
  "VAR_FECHA_INICIO_COMISION": "",
  "VAR_FECHA_FIN_COMISION": "",
  "VAR_NOMBRE_JEFE_DDA": "",
  "VAR_FIRMA_JEFE_DDA": ""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES 
('Oficio Comisión (curso_diplomado)',
'{
  "VAR_OFICIO_COMISION": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_NOMBRE_CURSO": "",
  "VAR_INSTITUCION_CURSO": "",
  "VAR_FECHA_INICIO_COMISION": "",
  "VAR_FECHA_FIN_COMISION": "",
  "VAR_NOMBRE_JEFE_DDA": "",
  "VAR_FIRMA_JEFE_DDA": ""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES 
('Oficio Comisión (curso-diplomado DDIE)',
'{
  "VAR_OFICIO_COMISION": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_NOMBRE_CURSO": "",
  "VAR_FECHA_INICIO_COMISION": "",
  "VAR_FECHA_FIN_COMISION": "",
  "VAR_NOMBRE_JEFE_DDA": "",
  "VAR_FIRMA_JEFE_DDA": ""
}');

INSERT INTO DOCUMENTO (NOMBRE, DATOS_JSON) VALUES 
('Oficio Comisión (Educación Inclusiva)',
'{
  "VAR_OFICIO_COMISION": "",
  "VAR_NOMBRE_DOCENTE": "",
  "VAR_NOMBRE_CURSO": "",
  "VAR_FECHA_INICIO_COMISION": "",
  "VAR_FECHA_FIN_COMISION": "",
  "VAR_NOMBRE_JEFE_DDA": "",
  "VAR_FIRMA_JEFE_DDA": ""
}');

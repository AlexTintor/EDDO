CREATE OR ALTER VIEW VISTA_EMPLEADOS_COMPLETA AS
SELECT 
    e.ID_EMPLEADO,
    e.NOMBRE AS NOMBRE_EMPLEADO,
    e.CORREO AS CORREO_EMPLEADO,
    e.CONTRASENA,
    e.TELEFONO,
    e.CAMPUS,
    t.NOMBRE AS TIPO_EMPLEADO,
    p.HORARIO AS HORARIO_PLAZA,
    d.nombre as NOMBRE_DEPARTAMENTO,
    d.CORREO AS CORREO_DEPARTAMENTO
FROM EMPLEADO e
JOIN DEPARTAMENTO d ON e.ID_DEPARTAMENTO = d.ID_DEPARTAMENTO;

go
SELECT * FROM VISTA_EMPLEADOS_COMPLETA;
go
CREATE OR ALTER VIEW VISTA_EMPLEADOS_ACTIVIDADES AS
SELECT 
    e.ID_EMPLEADO,
    e.NOMBRE AS NOMBRE_EMPLEADO,
    e.CORREO AS CORREO_EMPLEADO,
    e.CONTRASENA,
    e.TELEFONO,
    e.CAMPUS,
    t.NOMBRE AS TIPO_EMPLEADO,
    p.HORARIO AS HORARIO_PLAZA,
    d.CORREO AS CORREO_DEPARTAMENTO,
    d.NOMBRE AS NOMBRE_DEPARTAMENTO,
    a.ID_ACTIVIDAD,
    a.NOMBRE AS NOMBRE_ACTIVIDAD,
    a.REQUISITO,
    ta.ID_TIPO_ACTIVIDAD,
    ta.NOMBRE AS NOMBRE_TIPO_ACTIVIDAD,
    ta.FECHA_INICIO,
    ta.FECHA_FIN
FROM EMPLEADO e
JOIN TIPO_EMPLEADO t ON e.ID_TIPO = t.ID_TIPO
JOIN PLAZA p ON e.ID_PLAZA = p.ID_PLAZA
JOIN DEPARTAMENTO d ON e.ID_DEPARTAMENTO = d.ID_DEPARTAMENTO
LEFT JOIN EMPLEADOSXACTIVIDADES exa ON e.ID_EMPLEADO = exa.ID_EMPLEADO
LEFT JOIN ACTIVIDAD a ON exa.ID_ACT = a.ID_ACTIVIDAD
LEFT JOIN TIPO_ACTIVIDAD ta ON a.ID_TIPO_ACTIVIDAD = ta.ID_TIPO_ACTIVIDAD;
go
select * from VISTA_EMPLEADOS_ACTIVIDADES;
go
-- =====================================
-- TIPO_EMPLEADO
-- =====================================
INSERT INTO TIPO_EMPLEADO (ID_TIPO, NOMBRE) VALUES
(1, 'Administrativo'),
(2, 'Operativo'),
(3, 'Técnico'),
(4, 'Gerente');

-- =====================================
-- PLAZA
-- =====================================
INSERT INTO PLAZA (ID_PLAZA, HORARIO) VALUES
(1, '08:00-16:00'),
(2, '09:00-17:00'),
(3, '10:00-18:00');

-- =====================================
-- DEPARTAMENTO
-- =====================================
INSERT INTO DEPARTAMENTO (ID_DEPARTAMENTO, NOMBRE) VALUES
(1, 'Ventas'),
(2, 'Recursos Humano@t'),
(3, 'Técnico'),
(4, 'Administración'),
(5, 'Marketing'),
(6, 'Finanzas'),
(7, 'Compras'),
(8, 'Logística'),
(9, 'Calidad'),
(10, 'IT');
-- =====================================
INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, CAMPUS, TELEFONO, CORREO, CONTRA) VALUES
(1, 1, 1, 'Ana Torres', 'Culiacán', '6671234567', 'ana.torres@tecnm.mx', 'ana123'),
(2, 2, 2, 'Juan Pérez', 'Culiacán', '6672345678', 'juan.perez@tecnm.mx', 'jp123'),
(3, 3, 3, 'María López', 'Culiacán', '6673456789', 'maria.lopez@tecnm.mx', 'ml123'),
(4, 1, 4, 'Carlos Ruiz', 'Culiacán', '6674567890', 'carlos.ruiz@tecnm.mx', 'cr123'),
(5, 2, 5, 'Sofía Martínez', 'Culiacán', '6675678901', 'sofia.martinez@tecnm.mx', 'sm123'),
(6, 3, 6, 'Pedro Sánchez', 'Culiacán', '6676789012', 'pedro.sanchez@tecnm.mx', 'ps123'),
(7, 1, 7, 'Laura Díaz', 'Culiacán', '6677890123', 'laura.diaz@tecnm.mx', 'ld123'),
(8, 2, 8, 'Miguel Herrera', 'Culiacán', '6678901234', 'miguel.herrera@tecnm.mx', 'mh123'),
(9, 3, 9, 'Elena Vargas', 'Culiacán', '6679012345', 'elena.vargas@tecnm.mx', 'ev123'),
(10, 1, 10, 'Luis Torres', 'Culiacán', '6670123456', 'luis.torres@tecnm.mx', 'lt123'),
(1000,1,3, 'Carlos Gómez','Culiacán','6675558954', 'carlos@eddo.mx','abcd');
-- =====================================
-- TIPO_ACTIVIDAD
-- =====================================
INSERT INTO TIPO_ACTIVIDAD (ID_TIPO_ACTIVIDAD, NOMBRE, FECHA_INICIO, FECHA_FIN) VALUES
(1, 'Capacitación', '2025-11-01', '2025-11-30'),
(2, 'Proyecto', '2025-11-05', '2025-12-05'),
(3, 'Mantenimiento', '2025-11-10', '2025-11-20');

-- =====================================
-- ACTIVIDAD
-- =====================================
INSERT INTO ACTIVIDAD (ID_ACTIVIDAD, ID_TIPO_ACTIVIDAD, NOMBRE, REQUISITO) VALUES
(1, 1, 'Curso SQL', 'Ninguno'),
(2, 1, 'Curso Excel', 'Ninguno'),
(3, 2, 'Proyecto Web', 'Saber HTML/CSS'),
(4, 2, 'Proyecto App', 'Saber Java'),
(5, 3, 'Mantenimiento Servidor', 'Experiencia'),
(6, 3, 'Mantenimiento PC', 'Experiencia'),
(7, 1, 'Curso React', 'Saber JS'),
(8, 2, 'Proyecto Base de Datos', 'SQL Básico'),
(9, 3, 'Mantenimiento Red', 'Experiencia'),
(10, 1, 'Curso Liderazgo', 'Ninguno');

-- =====================================
-- EMPLEADOSXACTIVIDADES
-- =====================================
INSERT INTO EMPLEADOSXACTIVIDADES (ID_EMPLEADO, ID_ACT) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 5),
(4, 4),
(5, 6),
(6, 7),
(7, 8),
(8, 9),
(9, 10),
(10, 1);

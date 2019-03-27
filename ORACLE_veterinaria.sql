CREATE DATABASE veterinaria;
USE veterinaria;

/*TABLA VETERINARIO*/
CREATE TABLE VETERINARIO
(
    cedula CHAR(12) PRIMARY KEY,
    nombre VARCHAR(75) NOT NULL,
    numero_de_telefono VARCHAR(13) NOT NULL,
    ano_de_titulacion DATE NOT NULL,
    ano_de_ingreso DATE NOT NULL,
    salario VARCHAR(12) NOT NULL,
    tipo VARCHAR(9) NOT NULL,
    numero_de_licencia_de_conduccion CHAR(15) UNIQUE,
    ubicacion VARCHAR(20)
);
ALTER TABLE VETERINARIO
    ADD CONSTRAINT chk_cedula_veterinario CHECK (cedula>0);
ALTER TABLE VETERINARIO
    ADD CONSTRAINT chk_subtipo_veterinario CHECK (( tipo='comun' AND 
                                                    numero_de_licencia_de_conduccion IS NULL AND
                                                    ubicacion IS NULL)
                                                    OR
                                                    (tipo='visitador' AND 
                                                    numero_de_licencia_de_conduccion IS NOT NULL AND
                                                    ubicacion IS NOT NULL))
;

/*TABLA CLIENTE O RESPONSABLE*/

CREATE TABLE CLIENTE
(
    cedula CHAR(12) PRIMARY KEY,
    nombre VARCHAR(75) NOT NULL,
    numero_de_telefono VARCHAR(13) NOT NULL,
    tipo VARCHAR(8) NOT NULL,
    nombre_de_granja VARCHAR(30),
    numero_animales VARCHAR(12),
    direccion_de_granja VARCHAR(30)
);
ALTER TABLE CLIENTE
    ADD CONSTRAINT chk_cedula_cliente CHECK (cedula>0);
ALTER TABLE CLIENTE
    ADD CONSTRAINT chk_subtipo_cliente CHECK ((tipo='comun' AND 
                                                    nombre_de_granja IS NULL AND
                                                    direccion_de_granja IS NULL AND
                                                    numero_animales IS NULL)
                                                    OR
                                                    (tipo='granjero' AND 
                                                    nombre_de_granja IS NOT NULL AND
                                                    direccion_de_granja IS NOT NULL AND
                                                    numero_animales IS NOT NULL))
;

/*TABLA ANIMAL*/

CREATE TABLE ANIMAL
(
    nombre VARCHAR(30) NOT NULL,
    edad VARCHAR(3),
    especie VARCHAR(30) NOT NULL,
    peso VARCHAR(6) NOT NULL,
    tipo VARCHAR(10) NOT NULL
);
ALTER TABLE ANIMAL
    ADD CONSTRAINT chk_edad_animal CHECK (edad>0);
ALTER TABLE ANIMAL
    ADD CONSTRAINT chk_peso_animal CHECK (peso>0);
ALTER TABLE ANIMAL
    ADD CONSTRAINT chk_subtipo_animal CHECK (tipo='produccion' OR tipo='domestico');

ALTER TABLE ANIMAL
    ADD cedula_dueno CHAR(12) NOT NULL;
ALTER TABLE ANIMAL
    ADD CONSTRAINT fk_cedula_dueno FOREIGN KEY (cedula_dueno) REFERENCES CLIENTE(cedula);

ALTER TABLE ANIMAL
    ADD CONSTRAINT pk_animal PRIMARY KEY (nombre,cedula_dueno);

/*TABLA VISITA*/

CREATE TABLE VISITA
(
    fecha DATE NOT NULL,
    motivo VARCHAR(100) NOT NULL
);

ALTER TABLE VISITA
    ADD cedula_visitador CHAR(12) NOT NULL ;
ALTER TABLE VISITA
    ADD cedula_granjero CHAR(12) NOT NULL ;

ALTER TABLE VISITA
    ADD CONSTRAINT fk_cedula_visitador FOREIGN KEY (cedula_visitador) REFERENCES VETERINARIO(cedula);
ALTER TABLE VISITA
    ADD CONSTRAINT fk_cedula_granjero FOREIGN KEY (cedula_granjero) REFERENCES CLIENTE(cedula);

ALTER TABLE VISITA
    ADD CONSTRAINT pk_visita PRIMARY KEY (fecha, cedula_visitador, cedula_granjero);

/*TABLA REVISÓN*/

CREATE TABLE REVISION
(
    observacion VARCHAR(80) NOT NULL
);

ALTER TABLE REVISION
    ADD cedula_granjero CHAR(12) NOT NULL ;
ALTER TABLE REVISION
    ADD cedula_visitador CHAR(12) NOT NULL ;
ALTER TABLE REVISION
    ADD fecha_visita DATE NOT NULL ;
ALTER TABLE REVISION
    ADD nombre_animal VARCHAR(30) NOT NULL ;

ALTER TABLE REVISION
    ADD CONSTRAINT fk_visita FOREIGN KEY (fecha_visita, cedula_visitador, cedula_granjero) REFERENCES VISITA(fecha, cedula_visitador, cedula_granjero);
ALTER TABLE REVISION
    ADD CONSTRAINT fk_animal FOREIGN KEY (nombre_animal, cedula_granjero) REFERENCES ANIMAL(nombre, cedula_dueno);
 
ALTER TABLE REVISION
    ADD CONSTRAINT pk_revision PRIMARY KEY (fecha_visita, cedula_visitador, cedula_granjero, nombre_animal);

/*TABLA INGRESO*/

CREATE TABLE INGRESO
(
    fecha DATE NOT NULL,
    problema VARCHAR(200) NOT NULL
);

ALTER TABLE INGRESO
    ADD cedula_dueno CHAR(12) NOT NULL ;
ALTER TABLE INGRESO
    ADD nombre_animal VARCHAR(30) NOT NULL ;

ALTER TABLE INGRESO
    ADD CONSTRAINT fk_animal_produccion FOREIGN KEY (nombre_animal,cedula_dueno) REFERENCES ANIMAL(nombre,cedula_dueno);

ALTER TABLE INGRESO
    ADD CONSTRAINT pk_ingreso PRIMARY KEY (fecha, nombre_animal, cedula_dueno);

/*TABLA MEDICAMENTO*/

CREATE TABLE MEDICAMENTO
(
    nombre VARCHAR(30) PRIMARY KEY,
    precio VARCHAR(12) NOT NULL,
    fecha_de_caducidad DATE NOT NULL,
    dosis_por_peso VARCHAR(60) NOT NULL
);

ALTER TABLE MEDICAMENTO
    ADD CONSTRAINT chk_precio_medicamento CHECK (precio>0);
ALTER TABLE MEDICAMENTO 
    ADD CONSTRAINT chk_dosis_por_peso_medicamento CHECK (dosis_por_peso>0);

/*TABLA PAGO*/

CREATE TABLE PAGO
(
    id VARCHAR(10) PRIMARY KEY,
    saldo VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    total VARCHAR(10) NOT NULL
);
ALTER TABLE PAGO
    ADD CONSTRAINT chk_saldo_pago CHECK (saldo>=0 and saldo<=total);
ALTER TABLE PAGO
    ADD CONSTRAINT chk_id_pago CHECK(id>0);
ALTER TABLE PAGO
    ADD CONSTRAINT chk_total_pago CHECK (total>=0);

ALTER TABLE PAGO 
    ADD cedula_deudor CHAR(12) NOT NULL;
ALTER TABLE PAGO 
    ADD cedula_fiador CHAR(12) NOT NULL;

ALTER TABLE PAGO    
    ADD CONSTRAINT fk_cedula_deudor FOREIGN KEY (cedula_deudor) REFERENCES CLIENTE(cedula);
ALTER TABLE PAGO
    ADD CONSTRAINT fk_cedula_fiador FOREIGN KEY (cedula_fiador) REFERENCES CLIENTE(cedula);

/*TABLA SERVICIO*/

CREATE TABLE SERVICIO
(
    id VARCHAR (10) PRIMARY KEY,
    fecha DATE NOT NULL,
    valor VARCHAR(12) NOT NULL,
    descuento VARCHAR(3) NOT NULL
);

ALTER TABLE SERVICIO
    ADD id_pago VARCHAR(10) NOT NULL;
ALTER TABLE SERVICIO
    ADD cedula_dueno CHAR(12) NOT NULL;
ALTER TABLE SERVICIO
    ADD fecha_revision DATE;
ALTER TABLE SERVICIO
    ADD cedula_veterinario_visitador CHAR(12);
ALTER TABLE SERVICIO
    ADD nombre_animal VARCHAR(50) NOT NULL;
ALTER TABLE SERVICIO
    ADD fecha_ingreso DATE;

Alter TABLE SERVICIO
    ADD CONSTRAINT chk_tipo_servicio CHECK((fecha_revision IS NOT NULL AND cedula_veterinario_visitador IS NOT NULL AND
                                            fecha_ingreso IS NULL) OR (fecha_ingreso IS NOT NULL AND 
                                            fecha_revision IS NULL AND cedula_veterinario_visitador IS NULL));

ALTER TABLE SERVICIO
    ADD CONSTRAINT fk_id_pago FOREIGN KEY (id_pago) REFERENCES PAGO(id);
ALTER TABLE SERVICIO
    ADD CONSTRAINT fk_revision FOREIGN KEY (fecha_revision, cedula_veterinario_visitador, cedula_dueno, nombre_animal) 
        REFERENCES REVISION(fecha_visita, cedula_visitador, cedula_granjero, nombre_animal);
ALTER TABLE SERVICIO
    ADD CONSTRAINT fk_ingreso FOREIGN KEY (fecha_ingreso, nombre_animal, cedula_dueno) 
        REFERENCES INGRESO(fecha, nombre_animal, cedula_dueno);

/*la clave alternativa*/
ALTER TABLE SERVICIO 
    ADD CONSTRAINT ak_servicio UNIQUE (fecha,id_pago,cedula_dueno,fecha_revision,cedula_veterinario_visitador,nombre_animal,fecha_ingreso);

/*TABLA TRATAMIENTO*/

CREATE TABLE TRATAMIENTO
(
    dosis VARCHAR(60) NOT NULL,
    tiempo VARCHAR(15) NOT NULL,
    descripcion VARCHAR(70) NOT NULL   
);

ALTER TABLE TRATAMIENTO
    ADD CONSTRAINT chk_tiempo_tratamiento CHECK (tiempo>0);

ALTER TABLE TRATAMIENTO
    ADD cedula_veterinario_recetador CHAR(12) NOT NULL;
ALTER TABLE TRATAMIENTO 
    ADD id_servicio VARCHAR(10) NOT NULL;
ALTER TABLE TRATAMIENTO 
    ADD nombre_medicamento VARCHAR(30) NOT NULL;

ALTER TABLE TRATAMIENTO    
    ADD CONSTRAINT fk_cedula_veterinario_recetador FOREIGN KEY (cedula_veterinario_recetador) REFERENCES VETERINARIO;
ALTER TABLE TRATAMIENTO 
    ADD CONSTRAINT fk_servicio FOREIGN KEY (id_servicio) REFERENCES SERVICIO(id);
ALTER TABLE TRATAMIENTO
    ADD CONSTRAINT fk_nombre_medicamento FOREIGN KEY (nombre_medicamento) REFERENCES MEDICAMENTO(nombre);

ALTER TABLE TRATAMIENTO
    ADD CONSTRAINT pk_tratamiento PRIMARY KEY (cedula_veterinario_recetador, id_servicio, nombre_medicamento);
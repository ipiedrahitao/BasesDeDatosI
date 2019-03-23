CREATE DATABASE veterinaria;
USE veterinaria;

/*TABLA VETERINARIO*/
CREATE TABLE VETERINARIO
(
    cedula NUMBER(12) PRIMARY KEY,/*ponerle límite inferior a estas variables:~~~*/
    nombre VARCHAR(75) NOT NULL,
    numero_de_telefono VARCHAR(13) NOT NULL,/*~~~*/
    ano_de_titulacion NUMBER(12) NOT NULL,/*poner esto y año de ingreso en date y que en el e-r sea fecha en vez de año*/
    ano_de_ingreso NUMBER(12) NOT NULL,
    salario NUMBER(12) NOT NULL,
    tipo VARCHAR(9) NOT NULL,
    numero_de_licencia_de_conduccion VARCHAR(15) UNIQUE,/*~~~*/
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
    cedula NUMBER(12) PRIMARY KEY,/*~~~*/
    nombre VARCHAR(75) NOT NULL,
    numero_de_telefono VARCHAR(13) NOT NULL/*~~~*/,
    tipo VARCHAR(8) NOT NULL,
    nombre_de_granja VARCHAR(30),
    numero_animales NUMBER(12),
    direccion_de_granja VARCHAR(30)
);
ALTER TABLE CLIENTE
    ADD CONSTRAINT chk_cedula_cliente CHECK (cedula>0);
ALTER TABLE CLIENTE
    ADD CONSTRAINT chk_subtipo_cliente CHECK ((tipo='comun' AND 
                                                    direccion_de_granja IS NULL AND
                                                    numero_animales IS NULL)
                                                    OR
                                                    (tipo='granjero' AND 
                                                    direccion_de_granja IS NOT NULL AND
                                                    numero_animales IS NOT NULL))
;

/*TABLA ANIMAL*/

CREATE TABLE ANIMAL
(
    nombre VARCHAR(30) NOT NULL,
    edad NUMBER(3),
    especie VARCHAR(30) NOT NULL,
    peso number(6) NOT NULL,
    tipo VARCHAR(10) NOT NULL/*el máximo sería 9 si se cambia lo de producción*/
);
ALTER TABLE ANIMAL
    ADD CONSTRAINT chk_edad_animal CHECK (edad>0);
ALTER TABLE ANIMAL
    ADD CONSTRAINT chk_peso_animal CHECK (peso>0);
ALTER TABLE ANIMAL
    ADD CONSTRAINT chk_subtipo_animal CHECK (tipo='prooduccion' OR tipo='granjero');/*cambiar prooduccion por produccion*/

ALTER TABLE ANIMAL
    ADD cedula_dueno NUMBER(12) NOT NULL ;/*~~~*/
ALTER TABLE ANIMAL
    ADD CONSTRAINT fk_cedula_dueno FOREIGN KEY (cedula_dueno) REFERENCES CLIENTE(cedula);

ALTER TABLE ANIMAL
    ADD CONSTRAINT pk_animal PRIMARY KEY (nombre, cedula_dueno);

/*TABLA VISITA*/

CREATE TABLE VISITA
(
    fecha DATE NOT NULL,
    motivo VARCHAR(100) NOT NULL
);

ALTER TABLE VISITA
    ADD cedula_visitador NUMBER(12) NOT NULL ;/*~~~*/
ALTER TABLE VISITA
    ADD CONSTRAINT fk_cedula_visitador FOREIGN KEY (cedula_visitador) REFERENCES VETERINARIO(cedula);/*no hace falta checkear que el veterinario si sea de tipo visitador?*/
ALTER TABLE VISITA
    ADD cedula_granjero NUMBER(12) NOT NULL ;/*~~~*/
ALTER TABLE VISITA
    ADD CONSTRAINT fk_cedula_granjero FOREIGN KEY (cedula_granjero) REFERENCES CLIENTE(cedula);/*no hace falta checkear que el dueño si sea de tipo granjero?*/

ALTER TABLE VISITA
    ADD CONSTRAINT pk_visita PRIMARY KEY (fecha, cedula_visitador, cedula_granjero);

/*TABLA REVISÓN*/

CREATE TABLE REVISION
(
    observacion VARCHAR(80) NOT NULL
);

ALTER TABLE REVISION
    ADD cedula_granjero NUMBER(12) NOT NULL ;/*~~~*/
ALTER TABLE REVISION
    ADD cedula_visitador NUMBER(12) NOT NULL ;/*~~~*/
ALTER TABLE REVISION
    ADD fecha_visita DATE NOT NULL ;
ALTER TABLE REVISION
    ADD nombre_animal VARCHAR(30) NOT NULL ;

ALTER TABLE REVISION
    ADD CONSTRAINT fk_visita FOREIGN KEY (fecha_visita, cedula_visitador, cedula_granjero) REFERENCES VISITA(fecha,cedula_visitador,cedula_granjero);
/*creo que faltaba la clave foránea con respecto a animal*/
ALTER TABLE REVISION
    ADD CONSTRAINT fk_animal FOREIGN KEY (nombre_animal, cedula_granjero) REFERENCES ANIMAL(nombre,cedula_granjero);
    
ALTER TABLE REVISION
    ADD CONSTRAINT pk_revision PRIMARY KEY (fecha_visita, cedula_visitador, cedula_granjero, nombre_animal);

/*TABLA INGRESO*/

CREATE TABLE INGRESO
(
    fecha DATE NOT NULL,
    problema VARCHAR(200) NOT NULL
);

ALTER TABLE INGRESO
    ADD cedula_dueno NUMBER(12) NOT NULL ;/*~~~*/
/*Faltaba el nombre del animal en la clave foránea ni tenía clave primaria, depronto fue que yo la borré sin querer
ALTER TABLE INGRESO
    ADD nombre_animal VARCHAR(30) NOT NULL ;
ALTER TABLE INGRESO
    ADD CONSTRAINT fk_animal_produccion FOREIGN KEY (nombre_animal,cedula_dueno) REFERENCES ANIMAL(nombre,cedula_dueno);

ALTER TABLE INGRESO
    ADD CONSTRAINT pk_ingreso PRIMARY KEY (fecha, nombre_animal, cedula_dueno);*/

/*TABLA MEDICAMENTO*/

CREATE TABLE MEDICAMENTO
(
    nombre VARCHAR(30) PRIMARY KEY,
    precio NUMBER(12) NOT NULL,
    fecha_de_caducidad DATE NOT NULL,
    dosis_por_peso VARCHAR(60) NOT NULL
);
ALTER TABLE MEDICAMENTO
    ADD CONSTRAINT chk_precio_medicamento CHECK (precio>0);
ALTER TABLE MEDICAMENTO /*faltaba esto*/
    ADD CONSTRAINT chk_dosis_por_peso_medicamento CHECK (dosis_por_peso>0);

/*TABLA TRATAMIENTO*/

CREATE TABLE TRATAMIENTO
(
    dosis VARCHAR(60) NOT NULL,
    tiempo NUMBER(12) NOT NULL,
    descripcion VARCHAR(70) NOT NULL   
);
ALTER TABLE TRATAMIENTO
    ADD CONSTRAINT chk_tiempo_tratamiento CHECK (tiempo>0);

/* no faltan las claves foráneas y la clave primaria?*/

/*TABLA PAGO*/

CREATE TABLE PAGO
(
    id NUMBER(10) UNIQUE,/*primary key*/
    saldo NUMBER(10) NOT NULL,
    fecha DATE NOT NULL,
    --ESTO LO AGREGO PARA EL EJERCICIO
    total NUMBER(10) NOT NULL
);
ALTER TABLE PAGO
    ADD CONSTRAINT chk_saldo_pago CHECK (saldo>=0 and saldo<=total);
ALTER TABLE PAGO
    ADD CONSTRAINT chk_id_pago CHECK(id>0);
ALTER TABLE PAGO
    ADD CONSTRAINT chk_total_pago CHECK (total>=0);

ALTER TABLE PAGO 
    ADD cedula_deudor NUMBER(12) NOT NULL;
ALTER TABLE PAGO    
    ADD CONSTRAINT fk_cedula_deudor FOREIGN KEY (cedula_deudor) REFERENCES CLIENTE(cedula);
ALTER TABLE PAGO 
    ADD cedula_fiador NUMBER(12) NOT NULL;
ALTER TABLE PAGO
    ADD CONSTRAINT fk_cedula_fiador FOREIGN KEY (cedula_fiador) REFERENCES CLIENTE(cedula);
/*quitando los clientes de la clave primaria quedaría solo el id de clave primaria, las céudlas sólo serían claves foráneas*/
ALTER TABLE PAGO
    ADD CONSTRAINT pk_pago PRIMARY KEY (id,cedula_deudor,cedula_fiador);

/*TABLA SERVICIO*/

CREATE TABLE SERVICIO
(
    fecha DATE NOT NULL,
    valor NUMBER(12) NOT NULL,
    descuento NUMBER(3) NOT NULL
);
ALTER TABLE SERVICIO
    ADD CONSTRAINT chk_valor_servicio CHECK (valor>=0);
ALTER TABLE SERVICIO
    ADD CONSTRAINT chk_descuento_servicio CHECK (descuento>=0);

/* no faltan las claves foráneas y la clave primaria?*/




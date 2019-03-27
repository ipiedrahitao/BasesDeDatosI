DROP DATABASE IF EXISTS VETERINARIA;
CREATE DATABASE VETERINARIA;
USE VETERINARIA;

CREATE TABLE CLIENTE
(
    cedula INTEGER(12) PRIMARY KEY,
    nombre VARCHAR(75) NOT NULL,
    numero_de_telefono VARCHAR(13) NOT NULL,
    tipo VARCHAR(8) NOT NULL,
    nombre_de_granja VARCHAR(30),
    numero_animales INTEGER(12),
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

CREATE TABLE PAGO
(
    id INTEGER(10) PRIMARY KEY,
    saldo INTEGER(10) NOT NULL,
    fecha DATE NOT NULL, -- yyyy-mm-dd
    total INTEGER(10) NOT NULL
);
ALTER TABLE PAGO
    ADD CONSTRAINT chk_saldo_pago CHECK (saldo>=0 AND saldo<=total);
ALTER TABLE PAGO
    ADD CONSTRAINT chk_id_pago CHECK (id>0);
ALTER TABLE PAGO
    ADD CONSTRAINT chk_total_pago CHECK (total>=0);
ALTER TABLE PAGO 
    ADD cedula_deudor INTEGER(12) NOT NULL;
ALTER TABLE PAGO
    ADD CONSTRAINT fk_deudor_pago FOREIGN KEY (cedula_deudor) REFERENCES CLIENTE(cedula) ON DELETE CASCADE;
ALTER TABLE PAGO 
    ADD cedula_fiador INTEGER(12) NOT NULL;
ALTER TABLE PAGO
    ADD CONSTRAINT fk_fiador_pago FOREIGN KEY (cedula_fiador) REFERENCES CLIENTE(cedula) ON DELETE CASCADE;
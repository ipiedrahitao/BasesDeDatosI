<?php 
require('../models/conex.php');
class Cliente{
    public static function cedulaExiste($cedula){
        $query="SELECT * 
                FROM CLIENTE 
                WHERE cedula='$cedula'";
        return mysqli_query(Connex::conn(),$query)->num_rows>0;
    }
    public static function todos(){
        $query="SELECT * 
                FROM CLIENTE;";
        $res=mysqli_query(Connex::conn(),$query);
        $rows=Array();
        if ($res->num_rows > 0) {
            while($row = $res->fetch_assoc()) {
                $rows[]=$row;
            }
            return $rows;
        } else {
            return false;
        }
    }
    public static function registrarCliente($cedula,$nombre,$telefono,$tipo,$nombre_de_granja,$direccion_de_granja,$numero_de_animales){
        if(Cliente::cedulaExiste($cedula)){
            return false;
        }
        else{
            if ($tipo=='granjero') {
                $query="INSERT INTO CLIENTE (cedula,nombre,numero_de_telefono,tipo,nombre_de_granja,direccion_de_granja,numero_animales)
                        VALUES ('$cedula','$nombre','$telefono','$tipo','$nombre_de_granja','$direccion_de_granja','$numero_de_animales');";
            } else {
                $query="INSERT INTO CLIENTE (cedula,nombre,numero_de_telefono,tipo)
                        VALUES ('$cedula','$nombre','$telefono','$tipo');";
            }
            $res=mysqli_query(Connex::conn(),$query);
            if ($res) {
                return true;
            }else{
                // echo("Error description: " . mysqli_error($res));
                return false;
            }
        }
    }
    public static function eliminarCliente($cedula){
        if(!Cliente::cedulaExiste($cedula)){
            return false;
        }else{
            $query="DELETE FROM CLIENTE     
                    WHERE '$cedula'=cedula;";
            $res=mysqli_query(Connex::conn(),$query);
            if ($res) {
                return true;
            }else{
                // echo("Error description: " . mysqli_error($res));
                return false;
            }
        }
    }
    public static function buscarClientesSinPago(){
        $query="SELECT * 
                FROM CLIENTE 
                WHERE cedula NOT IN (SELECT DISTINCT cedula_deudor 
                                    FROM PAGO);";
        $res=mysqli_query(Connex::conn(),$query);
        $rows=Array();
        if ($res->num_rows > 0) {
            while($row = $res->fetch_assoc()) {
                $rows[]=$row;
            }
            return $rows;
        } else {
            return false;
        }
    }
    public static function buscarFiadores(){
        $query="SELECT c.cedula,c.nombre, COUNT(p.cedula_fiador) AS fiando 
                FROM CLIENTE AS c, PAGO AS p 
                WHERE c.cedula=p.cedula_fiador 
                GROUP BY p.cedula_fiador;";
        $res=mysqli_query(Connex::conn(),$query);
        $rows=Array();
        if ($res->num_rows > 0) {
            while($row = $res->fetch_assoc()) {
                $rows[]=$row;
            }
            $query="SELECT c.cedula,c.nombre, 0 AS fiando FROM CLIENTE AS c WHERE c.cedula NOT IN (SELECT DISTINCT p.cedula_fiador FROM PAGO AS p);";
            $res=mysqli_query(Connex::conn(),$query);
            if ($res->num_rows > 0) {
                while($row = $res->fetch_assoc()) {
                    $rows[]=$row;
                }
            }
            return $rows;
        } else {
            return false;
        }
    }
    public static function buscarFiadoresDelMismo(){
        $query="SELECT c.*
                FROM CLIENTE AS c, PAGO AS p 
                WHERE c.cedula=p.cedula_fiador AND 0 = (SELECT COUNT(p2.cedula_fiador) #Cuenta los pagos de este fiador con otros deudores
                                                        FROM PAGO AS p2 
                                                        WHERE p2.cedula_fiador=p.cedula_fiador AND p2.cedula_deudor!=p.cedula_deudor)
                GROUP BY p.cedula_deudor 
                HAVING COUNT(p.cedula_fiador)>=2;";
        $res=mysqli_query(Connex::conn(),$query);
        $rows=Array();
        if ($res->num_rows > 0) {
            while($row = $res->fetch_assoc()) {
                $rows[]=$row;
            }
            return $rows;
        } else {
            return false;
        }
    }
}


?>
<?php 
require('../models/conex.php');
class Pago{
    public static function idExiste($id){
        $query="SELECT * 
                FROM PAGO 
                WHERE id='$id'";
        return mysqli_query(Connex::conn(),$query)->num_rows>0;
    }
    public static function registrarPago($id,
                                        $saldo,
                                        $fecha,
                                        $total,
                                        $cedula_deudor,
                                        $cedula_fiador){
        if(Pago::idExiste($id)){
            return false;
        }
        else{            
            $query="INSERT INTO PAGO (id,saldo,fecha,total,cedula_deudor,cedula_fiador)
                    VALUES ('$id','$saldo','$fecha','$total','$cedula_deudor','$cedula_fiador');";
            $res=mysqli_query(Connex::conn(),$query);
            if ($res) {
                return true;
            }else{
                echo("Error description: " . mysqli_error($res));
                return false;
            }
        }
    }
    public static function eliminarPago($id){
        if(!Pago::idExiste($id)){
            return false;
        }else{
            $query="DELETE FROM PAGO     
                    WHERE '$id'=id;";
            $res=mysqli_query(Connex::conn(),$query);
            if ($res) {
                return true;
            }else{
                echo("Error description: " . mysqli_error($res));
                return false;
            }
        }
    }
    public static function buscarPagosQueFia($cedula_fiador){
        $query="SELECT * 
                FROM PAGO 
                WHERE cedula_fiador='$cedula_fiador');";
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
    public static function buscarDeudoresYSusFiadores(){
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
    public static function buscarFiadoresDelMismo($id){
        $query="SELECT c.* 
                FROM CLIENTE AS c, PAGO AS p
                WHERE p.id='$id' and c.cedula=p.cedula_deudor;";
        $res=mysqli_query(Connex::conn(),$query);
        $rows=Array();
        if ($res->num_rows > 0) {
            while($row = $res->fetch_assoc()) {
                $rows[]=$row;
            }
            $cedula_deudor=$rows[0]->cedula;
            $query="SELECT c.* 
            FROM CLIENTE AS c, PAGO AS p
            WHERE p.cedula_deudor='$cedula_deudor' and c.cedula=p.cedula_fiador;";
            $res=mysqli_query(Connex::conn(),$query);
            if ($res->num_rows > 0) {
                while($row = $res->fetch_assoc()) {
                    $rows[]=$row;
                }
                return $rows;
            }else{
                return false;
            }
        } else {
            return false;
        }
    }
}


?>
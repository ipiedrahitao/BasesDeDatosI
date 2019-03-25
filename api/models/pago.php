<?php 
require_once('../models/conex.php');
class Pago{
    public static function todos(){
        $query="SELECT * 
                FROM PAGO;";
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
    public static function idExiste($id){
        $query="SELECT * 
                FROM PAGO 
                WHERE id='$id'";
        return mysqli_query(Connex::conn(),$query)->num_rows>0;
    }
    public static function registrarPago($id,
                                        $saldo,
                                        $total,
                                        $cedula_deudor,
                                        $cedula_fiador){
        if(Pago::idExiste($id)){
            return false;
        }
        else{            
            $query="INSERT INTO PAGO (id,saldo,fecha,total,cedula_deudor,cedula_fiador)
                    VALUES ('$id','$saldo',CURRENT_DATE(),'$total','$cedula_deudor','$cedula_fiador');";
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
                // echo("Error description: " . mysqli_error($res));
                return false;
            }
        }
    }
    public static function buscarPagosQueFia($cedula_fiador){
        $query="SELECT * 
                FROM PAGO 
                WHERE cedula_fiador='$cedula_fiador';";
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
    public static function buscarDeudorYSusFiadores($id){
        $query="SELECT c.*
                FROM CLIENTE AS c, PAGO AS p 
                WHERE c.cedula=p.cedula_deudor AND p.id='$id';";
        $res=mysqli_query(Connex::conn(),$query);
        $rows=Array();
        if ($res->num_rows > 0) {
            while($row = $res->fetch_assoc()) {
                $rows[]=$row;
            }
            $cedula_deudor=$rows[0]["cedula"];
            $query="SELECT DISTINCT c.*
                FROM CLIENTE AS c, PAGO AS p 
                WHERE c.cedula=p.cedula_fiador AND p.cedula_deudor='$cedula_deudor';";
            $res=mysqli_query(Connex::conn(),$query);
            if ( $res->num_rows > 0) {
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
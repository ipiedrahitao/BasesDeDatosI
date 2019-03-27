<?php 
require_once('../models/pago.php');
require_once('../models/cliente.php');
if (isset($_POST['opcion'])) {
    $opcion=$_POST['opcion'];
} else if(isset($_GET['opcion'])){
    $opcion=$_GET['opcion'];
}
$respuesta=Array();
switch($opcion){
    case 'todosLosPagos':
        $respuesta['mensaje']=Pago::todos();
        if($respuesta['mensaje']){
            $respuesta['exito']=true;
        }else{
            $respuesta['exito']=false;
        }
        break;
    case 'insertarPago':
        $id=$_POST['id'];
        $saldo=$_POST['saldo'];
        $total=$_POST['total'];
        $cedula_deudor=$_POST['cedula_deudor'];
        $cedula_fiador=$_POST['cedula_fiador'];
        if($id>0){
            if ($saldo>$total) {
                $respuesta['mensaje']='Ese saldo no concuerda con el total a pagar, intenta otro por favor.';
                $respuesta['exito']=False;
            } else {
                $respuesta['exito']=Pago::registrarPago($id,
                                                        $saldo,
                                                        $total,
                                                        $cedula_deudor,
                                                        $cedula_fiador
                                                        );
                if (!$respuesta['exito']) {
                    $respuesta['mensaje']='Es posible que ese número de id ya exista, intenta otro por favor';
                }
            }
            
        }else{
            $respuesta['mensaje']='Ese número de id es inválido, intenta otro por favor.';
            $respuesta['exito']=False;
        }
        break;
    case 'eliminarPago':
        $id=$_POST['id'];
        $respuesta['exito']=Pago::eliminarPago($id);
        $respuesta['mensaje']='Operación exitosa';        
        if (!$respuesta['exito']) {
            $respuesta['mensaje']='Es posible que ese número de id no exista, intenta otro por favor';
        }
        break;
    case 'buscarPagosQueFia': #todos los pagos a los cuales el cliente fía(o sea, de los cuales el cliente es fiador).
        $cedula_fiador=$_GET['cedula_fiador'];
        if (Cliente::cedulaExiste($cedula_fiador)) {
            $respuesta['mensaje']=Pago::buscarPagosQueFia($cedula_fiador);
            if($respuesta['mensaje']){
                $respuesta['exito']=true;
            }else{
                $respuesta['mensaje']='No hay datos.';  
                $respuesta['exito']=false;
            }
        } else {
            $respuesta['mensaje']='Es posible que ese número de cédula no exista, intenta otro por favor';
            $respuesta['exito']=false;
        }
        break;
    case 'buscarDeudorYSusFiadores': #el deudor del pago y a continuación todos los datos de los clientes que 
                                       #son fiadores de al menos un pago que pertenezca al deudor del pago 
                                       #ingresado en la búsqueda. Ejemplo: si se ingresa el id 899 y se trata de 
                                       #un pago de Pedro, se deben imprimir los datos de todos los clientes que 
                                       #son fiadores de al menos un pago de Pedro.
        $id=$_GET['id'];
        if (Pago::idExiste($id) && $id!=null) {
            $respuesta['mensaje']=Pago::buscarDeudorYSusFiadores($id);
            if($respuesta['mensaje']){
                $respuesta['exito']=true;
            }else{
                $respuesta['mensaje']='No hay datos.';  
                $respuesta['exito']=false;
            }
        } else {
            $respuesta['mensaje']='Es posible que ese número de id no exista, intenta otro por favor';
            $respuesta['exito']=false;
        }
        
        break;
        
}
echo json_encode($respuesta);
?>
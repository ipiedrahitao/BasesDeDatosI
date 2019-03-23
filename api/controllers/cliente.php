<?php 
require('../models/cliente.php');
if (isset($_POST['opcion'])) {
    $opcion=$_POST['opcion'];
} else if(isset($_GET['opcion'])){
    $opcion=$_GET['opcion'];
}
$respuesta=Array();
switch($opcion){
    case 'todosLosClientes':
        $respuesta['mensaje']=Cliente::todos();
        if($respuesta['mensaje']){
            $respuesta['exito']=true;
        }else{
            $respuesta['exito']=false;
        }
        break;
    case 'insertarCliente':
        $cedula=$_POST['cedula'];
        $nombre=$_POST['nombre'];
        $telefono=$_POST['telefono'];
        $tipo=$_POST['tipo'];
        if ($cedula == null || $nombre == null || $telefono == null || $tipo == null) {
            $respuesta['exito']=false;
            $respuesta['mensaje']='Todos los campos son obligatorios, intenta de nuevo por favor';
            break;
        }
        if($cedula>0){
            if($tipo=='comun'){
                $nombre_de_granja=null;
                $direccion_de_granja=null;
                $numero_de_animales=null;
            }else if($tipo=='granjero'){
                $nombre_de_granja=$_POST['nombre_de_granja'];
                $direccion_de_granja=$_POST['direccion_de_granja'];
                $numero_de_animales=$_POST['numero_de_animales'];
                if ($nombre_de_granja == null || $direccion_de_granja == null || $numero_de_animales == null) {
                    $respuesta['exito']=false;
                    $respuesta['mensaje']='Todos los campos son obligatorios, intenta de nuevo por favor';
                    break;
                }
            }
            $respuesta['exito']=Cliente::registrarCliente( $cedula,
                                                    $nombre,
                                                    $telefono,
                                                    $tipo,
                                                    $nombre_de_granja,
                                                    $direccion_de_granja,
                                                    $numero_de_animales
                                                );
            if (!$respuesta['exito']) {
                $respuesta['mensaje']='Operación sin exito, intenta de nuevo por favor';
            }
            
        }else{
            $respuesta['mensaje']='Operación sin exito, intenta de nuevo por favor';
            $respuesta['exito']=False;
        }
        break;
    case 'eliminarCliente':
        $cedula=$_POST['cedula'];
        $respuesta['exito']=Cliente::eliminarCliente($cedula);
        if (!$respuesta['exito']) {
            $respuesta['mensaje']='Operación sin exito, intenta de nuevo por favor';
        }
        break;
    case 'buscarClientesSinPago': #todos los datos de los clientes que no tienen ni un solo pago.
        $respuesta['mensaje']=Cliente::buscarClientesSinPago();
        if($respuesta['mensaje']){
            $respuesta['exito']=true;
        }else{
            $respuesta['exito']=false;
        }
        break;
    case 'buscarClientesFiadores': #el id de cada cliente, su nombre y el número de pagos del cual es fiador.
        $respuesta['mensaje']=Cliente::buscarFiadores();
        if($respuesta['mensaje']){
            $respuesta['exito']=true;
        }else{
            $respuesta['exito']=false;
        }
        break;
    case 'buscarClientesFiadoresDelMismo':  #todos los datos de los clientes tal que todos los pagos que el cliente es fiador son todos del mismo deudor. 
                                            #Por ejemplo, un cliente que es fiador de 5 pagos y todos los 5 pagos son de Pepe. 
                                            #Nota: El cliente debe ser al menos fiador de dos pagos para que sea mostrado
        $respuesta['mensaje']=Cliente::buscarFiadoresDelMismo();
        if($respuesta['mensaje']){
            $respuesta['exito']=true;
        }else{
            $respuesta['exito']=false;
        }
        break;
        
}
echo json_encode($respuesta);
?>
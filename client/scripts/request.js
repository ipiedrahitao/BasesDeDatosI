$(document).ready(()=>{
    $("#btnRegistrarCliente,#btnRegistrarPago").click(function(evento){
        evento.preventDefault();
        var datos = $(this).parent().serializeArray();
        switch ($(this).parent().attr("id")) {
            case "formCliente":
                if (datos.length==8) {
                    datos[7].value='granjero';
                } else {
                    datos.push({name:'tipo', value:'comun'});
                }
                controller="cliente";
                break;
            case "formPago":
                datos.push({name:'cedula_deudor', value:$("#cedula_deudor").val()});
                datos.push({name:'cedula_fiador', value:$("#cedula_fiador").val()});                
                controller="pago";                
                break;
        }
        ejecutarAJAX(datos,controller,"post",(res)=>{   
            if (res.exito) {
                $(".myForm")[0].reset();
                $(".myForm")[1].reset();
            } 
            mostrarMensaje(res);
        });
      });
    $("#btnSeleccionarFiador,#btnSeleccionarDeudor").click(function(evento) {
        evento.preventDefault();
        ejecutarAJAX({opcion:"todosLosClientes"},"cliente","get",(res)=>{               
            if (!res.exito) {
                mostrarMensaje(res);                
            } else {
                var tabla = "<thead><tr><th>Cédula</th><th>Nombre</th></tr></thead><tbody>";
                $.each(res.mensaje,function (i,val) {
                    tabla +=
                    "<tr class='infoCliente'><td>" +
                    val.cedula +
                    "</td><td>" +
                    val.nombre +
                    "</td></tr>";
                });
                tabla+="</tbody>";
                $(".tablaClientes").html(tabla);
            }
        });

    });
    $("#btnTipoICliente,#btnTipoIICliente,#btnTipoIIICliente").click(function (evento) {
        evento.preventDefault();
        if ($(this).attr("id")=="btnTipoICliente" ) {
            opc="buscarClientesSinPago";
            callback=(res)=>{
                var tabla = "<thead><tr><th>Cédula</th><th>Nombre</th><th>Teléfono</th><th>Tipo</th><th>Nombre de la granja</th><th>Número de animales</th><th>Dirección de granja</th></tr></thead><tbody>";
                $.each(res.mensaje,function (i,val) {
                    tabla +=
                    "<tr><td>" +
                    val.cedula +
                    "</td><td>" +
                    val.nombre +
                    "</td><td>" +
                    val.numero_de_telefono +
                    "</td><td>" +
                    val.tipo +
                    "</td><td>" +
                    val.nombre_de_granja +
                    "</td><td>" +
                    val.numero_animales +
                    "</td><td>" +
                    val.direccion_de_granja +
                    "</td></tr>";
                });
                tabla+="</tbody>";
                $(".tablaClientes").html(tabla);
            }
        } else if ($(this).attr("id")=="btnTipoIICliente") {
            opc="buscarClientesFiadores";
            callback=(res)=>{
                var tabla = "<thead><tr><th>Cédula</th><th>Nombre</th><th>Fiando</th></tr></thead><tbody>";
                $.each(res.mensaje,function (i,val) {
                    tabla +=
                    "<tr><td>" +
                    val.cedula +
                    "</td><td>" +
                    val.nombre +
                    "</td><td>" +
                    val.fiando +
                    "</td></tr>";
                });
                tabla+="</tbody>";
                $(".tablaClientes").html(tabla);
            }
        }else{
            opc="buscarClientesFiadoresDelMismo";
            callback=(res)=>{
                var tabla = "<thead><tr><th>Cédula</th><th>Nombre</th><th>Teléfono</th><th>Tipo</th><th>Nombre de la granja</th><th>Número de animales</th><th>Dirección de granja</th></tr></thead><tbody>";
                $.each(res.mensaje,function (i,val) {
                    tabla +=
                    "<tr><td>" +
                    val.cedula +
                    "</td><td>" +
                    val.nombre +
                    "</td><td>" +
                    val.numero_de_telefono +
                    "</td><td>" +
                    val.tipo +
                    "</td><td>" +
                    val.nombre_de_granja +
                    "</td><td>" +
                    val.numero_animales +
                    "</td><td>" +
                    val.direccion_de_granja +
                    "</td></tr>";
                });
                tabla+="</tbody>";
                $(".tablaClientes").html(tabla);
            }
        }
        ejecutarAJAX({opcion:opc},"cliente","get",callback);
    });
    $("#btnTipoIPago,#btnTipoIIPago").click(function (evento) {
        evento.preventDefault();
        if ($(this).attr("id")=="btnTipoIPago" ) {
            opc={opcion:"buscarPagosQueFia",cedula_fiador:$("#id").val()};
            callback=(res)=>{
                var tabla = "<thead><tr><th>ID</th><th>Total</th><th>Saldo</th><th>Fecha</th><th>Deudor</th><th>Fiador</th><th></tr></thead><tbody>";
                $.each(res.mensaje,function (i,val) {
                    tabla +=
                    "<tr><td>" +
                    val.id +
                    "</td><td>" +
                    val.total +
                    "</td><td>" +
                    val.saldo +
                    "</td><td>" +
                    val.fecha +
                    "</td><td>" +
                    val.cedula_deudor +
                    "</td><td>" +
                    val.cedula_fiador +
                    "</td></tr>";
                });
                tabla+="</tbody>";
                $(".tablaPagos").html(tabla);
            }
        }else{
            opc={opcion:"buscarDeudorYSusFiadores",id:$("#id").val()};
            callback=(res)=>{

                var tabla = "<thead><tr><th>Cédula</th><th>Nombre</th><th>Fiando</th><th>Tipo</th><th>Nombre de la granja</th><th>Número de animales</th><th>Dirección de granja</th></tr></thead><tbody>";
                $.each(res.mensaje,function (i,val) {
                    if (i!=0) {
                        tabla +=
                        "<tr><td>" +
                        val.cedula +
                        "</td><td>" +
                        val.nombre +
                        "</td><td>" +
                        val.numero_de_telefono +
                        "</td><td>" +
                        val.tipo +
                        "</td><td>" +
                        val.nombre_de_granja +
                        "</td><td>" +
                        val.numero_animales +
                        "</td><td>" +
                        val.direccion_de_granja +
                        "</td></tr>";
                    }else{
                        tabla +=
                        "<tr><td><b>" +
                        val.cedula +
                        "</b></td><td><b>" +
                        val.nombre +
                        "</b></td><td><b>" +
                        val.numero_de_telefono +
                        "</b></td><td><b>" +
                        val.tipo +
                        "</b></td><td><b>" +
                        val.nombre_de_granja +
                        "</b></td><td><b>" +
                        val.numero_animales +
                        "</b></td><td><b>" +
                        val.direccion_de_granja +
                        "</b></td></tr>";
                    }
                });
                tabla+="</tbody>";
                $(".tablaPagos").html(tabla);
            }
        }
        ejecutarAJAX(opc,"pago","get",callback);
    });
    $("#btnEliminarCliente,#btnEliminarPago").click(function(evento){
        evento.preventDefault();
        var datos = $(this).parent().parent().parent().serializeArray();
        switch ($(this).attr("id")) {
            case "btnEliminarCliente":            
                controller="cliente";
                break;
            case "btnEliminarPago":              
                controller="pago";                
                break;
        }
        ejecutarAJAX(datos,controller,"post",(res)=>{   
            if (res.exito) {
                cargarClientes();
                cargarPagos();
                $(".myform")[0].reset();
                $(".myform")[1].reset();
            } 
            mostrarMensaje(res);
        });
      });
    if (window.location.href=='http://localhost/Veterinaria/client/eliminar.html') {
        cargarClientes();
        cargarPagos();
    }
});
function cargarClientes() {
        ejecutarAJAX({opcion:'todosLosClientes'},'cliente','get',(res)=>{
            if (!res.exito) {
                mostrarMensaje(res);                
            } else {
                var lista = "<li class='list-group-item active text-center'><h4>CLIENTES</h4></li>";
                $.each(res.mensaje,function (i,val) {
                    lista +=
                    "<li class='list-group-item'><b>Cédula: </b>" +
                    val.cedula +
                    " <b>Nombre: </b>" +
                    val.nombre +
                    "</li>";
                });
                $("#listaClientes").html(lista);
            }
    });
}
function cargarPagos() {
    ejecutarAJAX({opcion:'todosLosPagos'},'pago','get',(res)=>{
        if (!res.exito) {
            mostrarMensaje(res);                
        } else {
            var lista = "<li class='list-group-item active text-center'><h4>PAGOS</h4></li>";
            $.each(res.mensaje,function (i,val) {
                lista +=
                "<li class='list-group-item'><b>ID: </b>" +
                val.id +
                " <b>Saldo: </b>" +
                val.saldo +
                "</li>";
            });
            $("#listaPagos").html(lista);
        }
    });
}
function mostrarMensaje(res) {
        if (res.exito) {
            $("#mensajeExito").text('Operación exitosa.');
            $("#mensajeExito").fadeToggle();
            $("#mensajeExito")
              .delay(2000)
              .fadeToggle("slow");
        } else {
            $("#mensajeFracaso").text(res.mensaje);
            $("#mensajeFracaso").fadeToggle();
            $("#mensajeFracaso")
              .delay(2000)
              .fadeToggle("slow");
        }
}
function ejecutarAJAX(datos,controller,method,callback) {
    var url = [
      "../api/controllers/"+controller+".php"
    ];
    $.ajax({
      url: url[0],
      type: method,
      datatype: "json",
      data: datos
    })
      .done(function(respuesta) {
        var objJSON;
        try {
          objJSON = JSON.parse(respuesta);
          callback(objJSON);
        } catch (e) {
          objJSON = respuesta;
          alert(objJSON);
          console.log(e);
        }
      })
      .fail(function() {
        alert("Lo sentimos, experimentamos algunos problemas.");
      });
  }
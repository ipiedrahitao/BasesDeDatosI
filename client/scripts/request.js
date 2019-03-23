$(document).ready(()=>{
    $("#btnRegistrarCliente").click(function(evento){
        evento.preventDefault();
        var datos = $(this).parent().serializeArray();
        switch ($(this).parent().attr("id")) {
            case "formCliente":
                if (datos.length==8) {
                    datos[7].value='granjero';
                } else {
                    datos.push({name:'tipo', value:'comun'});
                }
                break;
            case "formPago":
                
                break;
        }
        ejecutarAJAX(datos,"cliente","post",(res)=>{   

            if (res.exito) {
                $(".myForm")[0].reset();
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
});

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
        }
      })
      .fail(function() {
        alert("Lo sentimos, experimentamos algunos problemas.");
      });
  }
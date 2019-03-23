$(document).ready(()=>{
    $("#btnRegistrarCliente").click((evento) => {
        evento.preventDefault();
        var datos = $(".myForm").serializeArray();
        if (datos.length==8) {
            datos[7].value='granjero';
        } else {
            datos.push({name:'tipo', value:'comun'});
        }
        ejecutarAJAX(datos,"cliente","post",(res)=>{            
            if (res.exito) {
                $(".myForm")[0].reset();
            } 
            mostrarMensaje(res);
        });
      });
});

function mostrarMensaje(res) {
    console.log('res');
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
$(document).ready(function () {
    $('#tipo').click(()=>{
        if (document.getElementById("tipo").checked) {
            $('#granjero').show();
        } else {
            $('#granjero').hide();            
        }
    }
    );
    $('h3').click(function(){
        if ($(this).attr("class")=='active') {
            $(this).attr({"class":""});
        } else {
            $(this).attr({"class":"active"});            
        }
        if($(this).attr("id")=="titleCliente"){
            $("#formCliente").fadeToggle();
        }
        else if($(this).attr("id")=="titlePago"){
            $("#formPago").fadeToggle();
        }
    });
    $(".tablaClientes").on("click","tbody tr",function () {
        if ($(this).parent().parent().attr("id")=="tablaDeudor") {
            $("#cedula_deudor").val($(this).find("td").html());            
        } else {
            $("#cedula_fiador").val($(this).find("td").html());            
        }
    });
});
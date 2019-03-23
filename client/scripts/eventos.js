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
    $( ".infoCliente" ).css( "color", "red" );
    $("td").click(function() {
        alert();
    });
});
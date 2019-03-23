$(document).ready(function () {
    $('#tipo').click(()=>{
        if (document.getElementById("tipo").checked) {
            $('#granjero').show();
        } else {
            $('#granjero').hide();            
        }
    }
    );
    $('h3').click(()=>{
        if ($('h3').attr("class")=='active') {
            $('h3').attr({"class":""});
        } else {
            $('h3').attr({"class":"active"});            
        }
        $(".myForm").fadeToggle();
    });
});
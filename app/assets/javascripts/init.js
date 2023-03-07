$(document).ready(function(){
    // the "href" attribute of the modal trigger must specify the modal ID that wants to be triggered
    $('.modal').modal();
  });
        
        (function($){
  $(function(){
    $('input').css('visibility', 'visible');
    $(".button-collapse").sideNav();
    $('.columniwannapush').pushpin({top: 600});
    $('.scrollspy').scrollSpy({scrollOffset: 64});
    $('.scrollspyTitle').scrollSpy({scrollOffset: 70});
    $('.slider').slider();
    $('.parallax').parallax();
    $('.modal').modal();
    $('select').material_select();
    $('.tooltipped').tooltip({delay: 50});
    if (Waves) { Waves.displayEffect = function() {};    }
    $('.carousel').carousel({fullWidth: true, dist:0});
    $('.collapsible').collapsible();
    window.setInterval(function(){$('.carousel').carousel('next')},5000);

  }); // end of document ready
})(jQuery); // end of jQuery name space

$("#btnValidPsychological").click(function(event) {

for(let j=1;j<45;j++){
  let a = 0, rdbtn=document.getElementsByName("[answer" + j + "]")
  for(let i=0;i<rdbtn.length;i++){
    if(rdbtn.item(i).checked == false){
      a++;
    }
  }

  if(a == rdbtn.length) {
    document.getElementById("pregunta" + j).style.color = "red";
    Materialize.toast("Pregunta " + j + " sin responder", 4000, 'red');
    $(window).scrollTop($("#pregunta" + j).offset().top - 150);
    document.getElementById("pregunta" + j).focus();
    return false;
  } else {
    document.getElementById("pregunta" + j).style.color = "";
  }
}
});

$("#btnValidPsycho1").click(function(event) {

const answer = document.getElementsByName("answer");
 
let seleccionado = false;
for(let i=0; i<answer.length; i++) {    
  if(answer[i].checked) {
    seleccionado = true;
    break;
  }
}
 
if(!seleccionado) {
   Materialize.toast("Seleccione una opción", 4000, 'red');
}
});

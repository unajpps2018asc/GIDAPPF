// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$('document').ready(function() {
  if($('#ModalCommissions').length){
    if (getUrlVars()["map_sel%5B%5D"] !== undefined){
      $("#ModalCommissions").modal("show");
    }
  }
});

function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

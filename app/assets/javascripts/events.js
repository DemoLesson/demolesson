// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var loader = function(id, x) {
	if(x == 'show') $(id).fadeIn(600);
	else $(id).fadeOut(600);
}
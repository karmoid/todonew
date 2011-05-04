// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// application.js
$(function() {
$("#event_cancelled").AnyTime_picker(
      { format: "%Y-%m-%d",
        firstDOW: 1,
        hideInput: false,
        placement: "popup" } );
});

$(function() {
$("#event_done").AnyTime_picker(
      { format: "%Y-%m-%d",
        firstDOW: 1,
        hideInput: false,
        placement: "popup" } );
});

$(function() {
$("#event_planned").AnyTime_picker(
      { format: "%Y-%m-%d",
        firstDOW: 1,
        hideInput: false,
        placement: "popup" } );
});
$(function() {
$("#doneclear").click( function(e) {
      $("#event_done").val("").update(); }  );
});
$(function() {
$("#cancelclear").click( function(e) {
      $("#event_cancelled").val("").update(); }  );
});

$(function() {
$("#doneset").click( function(e) {
      $("#event_done").val($("#event_planned").val()).update();  
      $("#event_cancelled").val("").update(); 
      }); 
});

$(function() {
$("#cancelset").click( function(e) {
      $("#event_cancelled").val($("#event_planned").val()).update(); 
      $("#event_done").val("").update(); 
      }); 
});

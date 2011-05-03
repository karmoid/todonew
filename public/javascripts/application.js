// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// application.js
$(function() {
$("#event_cancelled").AnyTime_picker(
      { format: "%Y-%m-%d %T",
        firstDOW: 1,
        hideInput: false,
        askSecond: false,
        placement: "popup" } );
});

$(function() {
$("#event_done").AnyTime_picker(
      { format: "%Y-%m-%d %H:%i:%s",
        firstDOW: 1,
        hideInput: false,
        placement: "popup" } );
});

$(function() {
$("#event_planned").AnyTime_picker(
      { format: "%Y-%m-%d %H:%i:%s",
        firstDOW: 1,
        hideInput: false,
        placement: "popup" } );
});
$("#rangeDemoClear").click( function(e) {
      $("#event_cancelled").val(""); } );
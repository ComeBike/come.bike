// CSS
import app from "../css/vendors.scss";

// JS
import "phoenix_html";
import "phoenix";
import "jquery";
import "bootstrap";

import moment from "moment";

import "tempusdominus-bootstrap-4";

$(() => {
  $("#datetimepicker").datetimepicker({
     showToday: false,
     sideBySide: true,
     debug: true
   })
  $(".datetimepicker-input").focus(function(){
    $("#datetimepicker").datetimepicker("show");
  })
  $(".datetimepicker-input").focusout(function(){
    $("#datetimepicker").datetimepicker("hide");
  })
});

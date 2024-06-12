//= require arctic_admin/base
//= require activeadmin/quill_editor/quill
//= require activeadmin/quill_editor_input
$(document).ready(function() {
  if(window.location.href.includes('car_models/new')) $('#autopilot_type').hide();
});

$(function () {
  $("#model_autopilot").click(function () {
    if ($(this).is(":checked")) {
      $('#autopilot_type').show();
    } else {
      $('#autopilot_type').val(null);
      $('#autopilot_type').hide();
    }
  });
});

$(document).ready(function(){
  $('#bx_block_vehicle_shipping_vehicle_shipping_payment_type_input').hide();
  $('.chzn-select').change(function() {
    if ($('.chzn-select').find(":selected").text() == 'Unloading, customs clearance & close the order'){
      $('#bx_block_vehicle_shipping_vehicle_shipping_payment_type_input').show();
    } else {
      $('#bx_block_vehicle_shipping_vehicle_shipping_payment_type_input').hide();
      $('#bx_block_vehicle_shipping_vehicle_shipping_payment_link_input').hide();
    }

    // Clear the value of the second dropdown
    $('#bx_block_vehicle_shipping_vehicle_shipping_payment_type_input select').val('');
  });
});




$(document).ready(function(){
  $('#bx_block_vehicle_shipping_vehicle_shipping_payment_link_input').hide();
  $('.link-select').change(function() {
    if ($('.link-select').find(":selected").text() == 'Online'){
      $('#bx_block_vehicle_shipping_vehicle_shipping_payment_link_input').show();
    } else {
      $('#bx_block_vehicle_shipping_vehicle_shipping_payment_link_input').hide();
    }

    // Clear the value of the second dropdown
    $('#bx_block_vehicle_shipping_vehicle_shipping_payment_link_input select').val('');
  });
});
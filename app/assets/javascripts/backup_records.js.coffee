jQuery ->
  $("#btn_recovery").click ->
    $("#form_choice").attr("action",
      "#{$("#form_choice").attr("action")}recovery/#{$("input[@name=backup_record_id]:checked").val()}")
    $("#form_choice").submit()
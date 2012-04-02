jQuery ->
  $("#btn_backup, #btn_clear, #btn_reset_passwd").click ->
    $("#form_opt").attr("action", "/instances/#{ this.name }")
    $("#form_opt").submit()
  $("#cbx_check_all").click ->
    if this.checked
      $("input[name='instances[]']").each( ->
        this.checked = true
        return
      )
    else
      $("input[name='instances[]']").each( ->
        this.checked = false
        return
      )

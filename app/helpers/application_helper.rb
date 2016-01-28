# -*- encoding : utf-8 -*-
module ApplicationHelper

  def l(object, options = {})
    super(object, options) if object
  end

  def page_title(value)
    @page_title = value
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
        concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  def datatable(id)
    content_tag :script do
      "$(document).ready(function() {
        $('##{id}').DataTable( {
           \"order\": [[ 0, \"desc\" ]],
           \"language\": {
             \"sProcessing\":   \"Provádím...\",
             \"sLengthMenu\":   \"Zobraz záznamů _MENU_\",
             \"sZeroRecords\":  \"Žádné záznamy nebyly nalezeny\",
             \"sInfo\":         \"Zobrazuji _START_ až _END_ z celkem _TOTAL_ záznamů\",
             \"sInfoEmpty\":    \"Zobrazuji 0 až 0 z 0 záznamů\",
             \"sInfoFiltered\": \"(filtrováno z celkem _MAX_ záznamů)\",
             \"sInfoPostFix\":  \"\",
             \"sSearch\":       \"Hledat:\",
             \"sUrl\":          \"\",
             \"oPaginate\": {
                \"sFirst\":    \"První\",
                \"sPrevious\": \"Předchozí\",
                \"sNext\":     \"Další\",
                \"sLast\":     \"Poslední\"
             }
          }
        } );
       } );".html_safe
    end
  end
end

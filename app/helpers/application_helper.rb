module ApplicationHelper

  def page_title(value)
    @page_title = value
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

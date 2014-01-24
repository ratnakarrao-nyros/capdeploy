$(document).ready(function() {
  $('.datatable').dataTable({
    "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "bJQueryUI": false,
    "bProcessing": true,
    "bServerSide": true,
    "sPageFirst": "first",
    "oLanguage": { "sSearch": "" },
    "sAjaxSource": $('.datatable').data('source')
  }).fnSearchHighlighting();

  $('.dataTables_filter').addClass('input-prepend');
  $('.dataTables_filter').css('float','right');
  $('.dataTables_filter input').before('<span class="add-on"><i class="icon-search"></i></span>');
  $('.dataTables_filter input').attr("placeholder", "Search...");

});

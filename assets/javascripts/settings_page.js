$(function(){
  $('.box.settings').removeClass('tabular');

  $('#names1').selectize({
    plugins: ['remove_button']
  });

  $('#names2').selectize({
    plugins: ['remove_button']
  });

  $('#names3').selectize({
    plugins: ['remove_button']
  });

  $('#names4').selectize({
    plugins: ['remove_button']
  });

  $('#names5').selectize({
    plugins: ['remove_button']
  });

  $('#groups').selectize({
    plugins: ['remove_button']
  });

  $('#custom_fields').selectize({
    plugins: ['remove_button']
  });

  $('#auth_key').on('input', function() {
      var value = $("#auth_key").val();
      $("#auth_val_hidden").text(value);
  });
});

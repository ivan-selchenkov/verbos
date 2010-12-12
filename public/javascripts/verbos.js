$(function() {
    begin();
});

function begin() {
    $.ajax({
      url: '/welcome/tiempos',
      dataType: 'json',
      success: function(json) {
          $(json).each(function(index, modo) {
            var $fieldset = $('<fieldset/>')
            $fieldset.append( $('<legend/>').text(modo.name) )

            $(modo.tiempos).each(function(index, tiempo) {
                $fieldset.append(
                    $('<label/>').append(
                        $('<input/>').attr('type', 'checkbox').attr('id', 'tiempo' + tiempo.id)
                    ).append(
                        tiempo.name
                    )
                )
            })


            $('#tiempos').append($fieldset)
          })
      }
    });
};
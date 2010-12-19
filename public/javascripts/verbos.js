$(function() {
    begin();
    $('#form_submit').submit(function() {
        var tiempos = $('input:checked[name=tiempo]').map(function(i, item) {
            return $(item).val()
        });
        var formas = $('input:checked[name=forma]').map(function(i, item) {
            return $(item).val()
        });
        $.ajax({
          url: '/welcome/start',
          data: { tiempos: tiempos, formas: formas },
          success: exam
        });
        return false;
    });
});

function exam(json) {
    console.log(json)
    $('#start_block').hide();
    $('#learn_block').show();
}

function begin() {
    $.ajax({
      url: '/welcome/tiempos',
      dataType: 'json',
      success: function(json) {
          $(json.modos).each(function(index, modo) {
            var $fieldset = $('<fieldset/>')
            $fieldset.append( $('<legend/>').text(modo.name) )

            $(modo.tiempos).each(function(index, tiempo) {
                $fieldset.append(
                    $('<label/>').append(
                        $('<input/>').attr('type', 'checkbox')
                                     .attr('name', 'tiempo')
                                     .attr('value', tiempo.id)
                                     .attr('id', 'tiempo' + tiempo.id)
                    ).append(
                        tiempo.name
                    )
                )
            });
            $('#tiempos').append($fieldset);
          });
          $(json.formas).each(function(index, forma) {
            $('#formas').append(
                $('<label/>').append(
                    $('<input/>').attr('type', 'checkbox')
                                 .attr('name', 'forma')
                                 .attr('value', forma.id)
                                 .attr('id', 'forma' + forma.id)
                ).append(
                    forma.name
                )
            )
        });
      }
    });
};
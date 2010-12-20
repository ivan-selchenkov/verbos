var data = null;
var current_index = 0;
var errors = null;

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

    data = json.preguntas;
    current_index = 0;
    errors = [];

    exponer_pregunta();
};

function exponer_pregunta() {
    var item = data[current_index];

    console.log(item);

    var $pregunta =
    $('<div/>').addClass('tarjeta').append(
                    '<b>Tiempo:</b> <i>' + item.tiempo + '</i><br/> <b>Verbo:</b> <i>' + item.verb + '</i><br/>'
                ).append(
                    $('<div/>').addClass('forma_verb')
                               .append('<i>' + item.forma + '</i>&nbsp;')
                               .append(
                                   $('<input/>').attr('type', 'text')
                                                .attr('index', current_index)
                                                .keypress(probar_respuesta)
                               )
                ).corner("round 10px");
    $('#learn_block').append($pregunta);
};

function probar_respuesta() {
    if (event.keyCode == '13') {
        event.preventDefault();
    };

};
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
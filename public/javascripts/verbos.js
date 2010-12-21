var data = null;
var current_index = 0;
var errors = null;
var height = null;

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
    height = $(window).height();
    $('#learn_block').height(+height / 2);
    $(window).resize(function() {
        height = $(window).height();
        $('#learn_block').height(+height / 2);
    });

});

function exam(json) {
    $('#start_block').hide();
    $('#learn_block').show();

    data = json.preguntas;
    current_index = 0;
    errors = [];

    exponer_pregunta();
};

function exponer_pregunta() {
    var item = data[current_index];

    if(item == undefined) {
      fin_de_exam();
      return;
    };

    var $pregunta =
    $('<div/>').addClass('tarjeta normal').append(
                    '<b>Tiempo:</b> <i>' + item.tiempo + '</i><br/> <b>Verbo:</b> <i>' + item.verb + '</i><br/>'
                ).append(
                    $('<div/>').addClass('forma_verb')
                               .append('<i>' + item.forma + '</i>&nbsp;')
                               .append(
                                   $('<input/>').attr('type', 'text')
                                                .attr('index', current_index)
                                                .keypress(probar_respuesta)
                               )
                ).corner("round 10px")
                .attr('index', current_index);
    $('#verbos').append($pregunta);
    $("input:text:last").focus();
};
function fin_de_exam() {

};
function probar_respuesta(event) {
    if (event.keyCode != '13') {
        return;
    };

    event.preventDefault();

    var $this = $(this);
    var index = $this.attr('index');
    var respuesta = $this.val();

    var $tarjeta = $this.parents('div.tarjeta');

    $tarjeta.removeClass('normal');

    if(respuesta != data[index].palabra) {
        $tarjeta.addClass('error');
    } else {
        $tarjeta.addClass('ok');
    };
    $this.after(
        $('<span/>').addClass('respuesta').text(data[index].palabra)
    );
    $this.remove();

    if( +index - 3 >= 0 ) {
        $('div.tarjeta[index=' + (+index-3) + ']').remove();
    };
    $('div.tarjeta[index=' + (+index-2) + ']').animate({ opacity: 0.1 }, 100);
    $('div.tarjeta[index=' + (+index-1) + ']').animate({ opacity: 0.5 }, 100);

    current_index++;
    exponer_pregunta();
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
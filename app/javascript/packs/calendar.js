import $ from 'jquery';
import 'fullcalendar';
import I18n from 'i18n-js/index.js.erb'

$(document).on('turbolinks:load', function() {
  $('#calendar').fullCalendar({
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultDate: $('#calendar').fullCalendar('today'),
    defaultView: 'month',
    events: function(start, end, timezone, callback) {
      jQuery.ajax({
        url: '/morning_speech_schedule/',
        type: 'GET',
        success: function(data) {
          var events = [];
          if(data.length){
            $.map( data, function( r ) {
              events.push({
                name: r.id,
                title: r.user.name + " " + I18n.t('calendar.ms'),
                start: r.day,
                end: r.day
              });
            });
            flash(I18n.t('calendar.success'), I18n.t('morning_speech_schedule.index.success'));
          }
          callback(events);
        },
        error: function(data) {
          flash(I18n.t('calendar.danger'), I18n.t('morning_speech_schedule.index.failed'));
        }
      });
    },
    timeFormat: 'h:mm A',
    selectable: true,
    selectHelper: true,
    select: function (start, end) {
      var check = confirm(I18n.t('morning_speech_schedule.create.confirm'));
      if (check) {
        var day = $.fullCalendar.formatDate(start, "Y-MM-DD HH:mm:ss");
        $.ajax({
          url: '/morning_speech_schedule/',
          type: "POST",
          dataType: 'json',
          data: {
            start: day,
            end: day
          },
          success: function (data) {
            if(data){
              $('#calendar').fullCalendar('renderEvent',{
                name: data.id,
                title: data.user.name + " " + I18n.t('calendar.ms'),
                start: data.day,
                end: data.day,
              },true);
              flash(I18n.t('calendar.success'), I18n.t('morning_speech_schedule.create.success'));
            }else{
              flash(I18n.t('calendar.danger'), I18n.t('morning_speech_schedule.create.failed'));
            }
          },
          error: function(data) {
            flash(I18n.t('calendar.danger'), I18n.t('morning_speech_schedule.create.failed'));
          }
        });
      }
      $('#calendar').fullCalendar('unselect');
    },
    editable: true,
    eventDrop: function (event, delta, revertFunc) {
      var check = confirm(I18n.t('morning_speech_schedule.update.confirm'));
      if(check) {
        var day = $.fullCalendar.formatDate(event.start, "Y-MM-DD HH:mm:ss");
        $.ajax({
          url: '/morning_speech_schedule/' + event.name,
          type: "PATCH",
          data: {
            day: day
          },
          success: function (data) {
            if(data){
              flash(I18n.t('calendar.success'), I18n.t('morning_speech_schedule.update.success'));
            }else{
              revertFunc();
              flash(I18n.t('calendar.danger'), I18n.t('morning_speech_schedule.update.failed'));
            }
          },
          error: function(data) {
            revertFunc();
            flash(I18n.t('calendar.danger'), I18n.t('morning_speech_schedule.update.failed'));
          }
        });
      }else{
        revertFunc();
      }
    },
    eventClick: function(event){
      var check = confirm(I18n.t('morning_speech_schedule.delete.confirm'));
      if(check) {
        $.ajax({
          url: '/morning_speech_schedule/' + event.name,
          type: "DELETE",
          success: function (data) {
            if(data){
              $('#calendar').fullCalendar('removeEvents', event._id);
              flash(I18n.t('calendar.success'), I18n.t('morning_speech_schedule.delete.success'));
            }else{
              flash(I18n.t('calendar.danger'), I18n.t('morning_speech_schedule.delete.failed'));
            }
          },
          error: function(data) {
            flash(I18n.t('calendar.danger'), I18n.t('morning_speech_schedule.delete.failed'));
          }
        });
      }
    }
  })
});

function flash(type, message) {
  $(".content").prepend("<div class='alert alert-" + type + "'>" + message + "</div>");
  $(".alert").fadeOut( 5000, function() {
    $(this).remove();
  });
}

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
                id: r.id,
                title: r.user.name + " " + I18n.t('calendar.ms'),
                start: r.day,
                end: r.day
              });
            });
          }
          callback(events);
        }
      });
    },
    timeFormat: 'h:mm A'
  })
});

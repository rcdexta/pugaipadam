$(document).ready(function () {

    $.getJSON('/consultants', function(data) {
        empJSON = data;
        generateDropdowns();
        generateData('');
    });

    showPopup = function(event){
        var curEmpIndex = ($(event.target).closest(".empData").attr("id"));

        $.get('consultants/' + curEmpIndex, function(data) {
            $("#employeePopup .content").append(data);
            $("#employeePopup").css("height",document.height);

            $("#employeePopup .content_panel").css("top",scrollY + 150);
            $("#employeePopup .content_panel").css("left",$(window).width()/2 - 250);

            $.colorbox({html: data,
                speed: 500,
                scrolling: false
            });

        });
    }

});
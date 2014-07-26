$(document).ready(function () {

    $.getJSON('/consultants', function (data) {
        empJSON = data;
        generateDropdowns();
        generateData('grayscale');
    });

    showPopup = function (event) {
        var curEmpIndex = ($(event.target).closest(".empData").attr("id"));

        var template = $("#popup_template").html();

        var html = _.template(template, {employee_id: curEmpIndex, consultant: empJSON[curEmpIndex]});

        $("#employeePopup .content").append(html);
        $("#employeePopup").css("height", document.height);

        $("#employeePopup .content_panel").css("top", scrollY + 150);
        $("#employeePopup .content_panel").css("left", $(window).width() / 2 - 250);

        $.colorbox({html: html,
            width: 700,
            speed: 1000,
            closeButton: false,
            opacity: 0.25,
            scrolling: false
        });
    }

    window.rInterval = function (callback, delay) {
        var dateNow = Date.now,
            requestAnimation = window.requestAnimationFrame,
            start = dateNow(),
            stop,
            intervalFunc = function () {
                dateNow() - start < delay || (start += delay, callback());
                stop || requestAnimation(intervalFunc)
            }
        requestAnimation(intervalFunc);
        return{
            clear: function () {
                stop = 1
            }
        }
    }

    var fifteenSecsInMillis = 15000;
    window.rInterval(function () {
        $.colorbox.close()
        var items = $('.empData');
        var empDiv = $(items[Math.floor(Math.random() * items.length)]);
        var first = true;

        $('html, body').animate({
            scrollTop: empDiv.offset().top - 300
        }, 2000, null, function () {
            if (first) {
                first = false;
                $(empDiv).find('img').toggleClass('grayscale');
                $(empDiv).mouseover();
                setTimeout(function () {
                    $(empDiv).click();
                    $(empDiv).find('img').toggleClass('grayscale');
                }, 2000);
            }
        });
    }, fifteenSecsInMillis);

    var fourHoursInMillis = 14000000;
    window.rInterval(function () {
        window.location.reload();
    }, fourHoursInMillis);

});
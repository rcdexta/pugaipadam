$(document).ready(function () {

    $.getJSON('/consultants', function(data) {
        empJSON = data;
        generateDropdowns();
        generateData('grayscale');
    });

    showPopup = function(event){
        var curEmpIndex = ($(event.target).closest(".empData").attr("id"));

        $.get('consultants/' + curEmpIndex, function(data) {
            $("#employeePopup .content").append(data);
            $("#employeePopup").css("height",document.height);

            $("#employeePopup .content_panel").css("top",scrollY + 150);
            $("#employeePopup .content_panel").css("left",$(window).width()/2 - 250);

            $.colorbox({html: data,
                width: 600,
                speed: 500,
                transition: "fade",
                closeButton: false,
                opacity: 0.25,
                returnFocus: true});

        });
    }


    setInterval(function () {
        $.colorbox.close()
        var items = $('.empData');
        var empDiv = $(items[Math.floor(Math.random() * items.length)]);
        var first = true;

        $('html, body').animate({
                scrollTop: empDiv.offset().top - 300
            }, 2000, function(){
                if (first){
                    first = false;
                    $(empDiv).find('img').toggleClass('grayscale');
                    $(empDiv).mouseover();
                    setTimeout(function(){
                        $(empDiv).click();
                        $(empDiv).find('img').toggleClass('grayscale');
                    },2000);
                }
            });
    }, 15000);

});
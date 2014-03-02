$(function(){

    $('#consultant_photo').on('change', function () {
        console.log('here');

        var fr = new FileReader();

        fr.readAsDataURL(this.files[0]);
        fr.onload = function (evt) {

            $('#photoUploadPopup img').attr('src', evt.target.result);
            $("#photoUploadPopup").css("height", $('#photoUploadPopup img').height()+100);
            $("#photoUploadPopup .content_panel").css("top", scrollY + 150);
            $("#photoUploadPopup .content_panel").css("left", $(window).width()/2 - 250);
            $("#photoUploadPopup").fadeIn("fast");

            $('#photoUploadPopup img').Jcrop({
                aspectRatio: 1,
                boxWidth: 400,
                boxHeight: 400
            });
        }

    });


});
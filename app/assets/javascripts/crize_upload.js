$(function () {

    $("#open-crize").click(function () {
        $("#crize").crize({onsave: function (data) {
            $('#img-container img').attr('src', data.imageDataUrl);
            $('#consultant_image_data').val(data.imageDataUrl);
//            console.log('save', x);
        }});
    });

});
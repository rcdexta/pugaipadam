$(function () {

    $('#open-crize').change(function () {
        var fileReader = new FileReader;
        var self = this;
        var fileType = this.files[0].type;
        if (fileType.split('/')[0] != 'image') return;
        var imageType = fileType.split('/')[1];
        fileReader.readAsDataURL(this.files[0]);
        fileReader.onload = function () {
            $("#crize").crize({onsave: function (data) {
                $('#img-container img').attr('src', data.imageDataUrl);
                $('#consultant_image_data').val(data.imageDataUrl);
            },
                image: this.result,
                imageType: imageType
            });
        };
    });

});
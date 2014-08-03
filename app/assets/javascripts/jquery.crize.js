(function ($, undefined) {
    $.widget("ui.crize", {
        _init: function () {
            this._buildHtml();
            var widget = this;
            this.element.dialog({
                width: 1024,
                height: 700,
                modal: true,
                closeOnEscape: false,
                dialogClass: 'noTitleStuff',
                buttons: {
                    'Apply': $.proxy(widget._cropAndSave, widget),
                    'Cancel': widget._destroyCrize.bind(widget)
                },
                draggable: false,
                resizable: false
            });
            this.element.find('#crop').click(this._crop.bind(this));
            this.element.find('#resize').click(this._resize.bind(this));
            this.canvas = this.element.find("canvas")[0];
            $('#crop-info').removeClass('hidden');
            widget.imageType = this.options.imageType;
            widget._drawImage(this.options.image);
        },

        _destroyCrize: function(){
            this.jcropApi.release();
            this.jcropApi.disable();
            this.jcropApi.destroy();
            this.element.dialog('close');
        },

        _cropAndSave: function(){
            this._crop();
            this._save();
        },

        _save: function () {
            if (this.options.onsave) {
                this.options.onsave({croppedCoords: this.croppedCoords, imageDataUrl: this.canvas.toDataURL('image/' + this.imageType)});
            }
            this.element.dialog('close');
        },

        _buildHtml: function () {
            var html = '<h3>Pugaipadam Photo Uploader</h3><span id="crop-info" class="hidden">Use the handle crop the picture to the desired size. Scroll and crop for large images!</span>' +
                "<input type='button' id='crop' class='hidden' value='Crop'/>" +
                "<div><canvas></canvas></div>";
            this.element.html(html);
        },

        _crop: function () {
            this.jcropApi.release();
            this.jcropApi.disable();
            var ctx = this.canvas.getContext("2d");
            var croppedCoords = this.croppedCoords;
            var imageData = ctx.getImageData(croppedCoords.x, croppedCoords.y, croppedCoords.w, croppedCoords.h);
            this._resizeCanvas(croppedCoords.w, croppedCoords.h);
            ctx.putImageData(imageData, 0, 0);
            this.jcropApi.enable();
            return false;
        },

        _resize: function () {
            var width = this.element.find("#width").val(),
                height = this.element.find("#height").val();
            this._drawImage(this.canvas.toDataURL(), width, height);
            return false;
        },

        _resizeCanvas: function (width, height) {
            var canvas = this.canvas;
            canvas.setAttribute('width', width);
            canvas.setAttribute('height', height);
            canvas.style.width = width + 'px';
            canvas.style.height = height + 'px';
        },

        _drawImage: function (imageDataUrl, width, height) {
            var image = new Image,
                ctx = this.canvas.getContext('2d'),
                widget = this;
            var maxWidth = 800.0;
            image.onload = function () {
                var ratio = Math.max(image.width / maxWidth, 1);

                if (!width) width = image.width / ratio;
                if (!height) height = image.height / ratio;
                widget._resizeCanvas(width, height);
                ctx.clearRect(0, 0, widget.canvas.width, widget.canvas.height);
                ctx.drawImage(image, 0, 0, width, height);

                if(widget.jcropApi) {
//                    widget.jcropApi.setSelect(0, 0, widget.canvas.width, widget.canvas.height);
                } else {
                    widget._bindJcrop();
                }

            };
            image.src = imageDataUrl;

        },

        _bindFileUpload: function () {
            var widget = this;
            this.element.find('input[type="file"]').change(function () {
                var fileReader = new FileReader;
                fileReader.onload = function () {
                    $('#crop-info').removeClass('hidden');
                    widget._drawImage(this.result);
                };
                var fileType = this.files[0].type;
                if (fileType.split('/')[0] != 'image') return;
                widget.imageType = fileType.split('/')[1];
                fileReader.readAsDataURL(this.files[0]);
            });
        },

        _bindJcrop: function () {
            var widget = this,
                element = this.element;

            element.find("canvas").Jcrop({
                aspectRatio: 1,
                bgColor: "white",
                bgOpacity: 0.3,
                setSelect:   [ 50, 50, widget.canvas.width-100, widget.canvas.height-100 ],
                onSelect: function (coords) {
                    widget.croppedCoords = coords;
                }
            }, function () {
                widget.jcropApi = this;
            });
        }
    });
})(jQuery);

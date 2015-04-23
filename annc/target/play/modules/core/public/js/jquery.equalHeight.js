// make sure the $ is pointing to JQuery and not some other library
(function ($) {
    // add a new method to JQuery
    $.fn.equalHeight = function () {
        var bh = document.body.scrollHeight - 62;
        this.each(function () {
            $(this).height(bh);
        });
    }
})(jQuery);
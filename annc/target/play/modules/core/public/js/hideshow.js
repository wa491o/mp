//  Andy Langton's show/hide/mini-accordion @ http://andylangton.co.uk/jquery-show-hide

// this tells jquery to run the function below once the DOM is ready
$(document).ready(function () {

	// choose text for the show/hide link - can contain HTML (e.g. an image)
    var showText = 'toggleLink_show';
    var hideText = 'toggleLink';

    // initialise the visibility check
    var is_visible = false;

    // append show/hide links to the element directly preceding the element with a class of "toggle"
    $('.toggle').prev().prepend('<div class="toggleLinkDiv"><a href="#" class="toggleLink_show">' + '' + '</a>');

    // hide all of the elements with a class of 'toggle'
    $('.toggle').hide();

    // capture clicks on the toggle links
    $('a.toggleLink_show').click(function () {

    	// switch visibility
    	is_visible = !is_visible;

    	// change the link text depending on whether the element is shown or hidden
        if ($(this).attr('class') == showText) {
        	$('.toggle').hide();
        	$('a.toggleLink').attr('class', showText);
        	
            $(this).attr('class',hideText);
            $(this).parent().parent().next('.toggle').slideDown('normal', function(){
            	 //动态调整菜单高度
                $("#sidebar").height(document.body.scrollHeight - 62);
            });
        }
        else {
            $(this).attr('class',showText);
            $(this).parent().parent().next('.toggle').slideUp('normal', function(){
            	 //动态调整菜单高度
            	 $("#sidebar").height(document.body.scrollHeight - 62);
            });
        }
        
        // return false so any link destination is not followed
        return false;

    });
});
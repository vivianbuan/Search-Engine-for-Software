$(document).ready(function() {

        // JQuery code to be added in here.


    $("#test-btn").click( function(event) {
        alert("JQuery Working!");
    });


	$('.package-button').click(function(e){
		var package_name = $(this).attr('id');
	        $(this).html(package_name);
    });

});
$(document).ready(function() {

        // JQuery code to be added in here.


    $("#test-btn").click( function(event) {
        alert("JQuery Working!");
    });


	$('.package-button').click(function(e){
		var package_name = $(this).attr('id');
		var all_none = false;



	    $('.'+package_name+'-table').each(function() {
	    	$(this).toggle();
	    });

		var count = 0;
		$('.package-table-header').each(function() {
	    	if ($(this).css('display') != 'none') {
	    		count++;
	    	}
	    	// if ($(this).find('td:empty')) { alert('one empty')}
	    });
        alert(count);

	    if (count <= 1){
	    	$('.package-table').toggle();
	    }
    });

});
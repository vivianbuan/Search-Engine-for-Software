$(document).ready(function() {

        // JQuery code to be added in here.


    $("#test-btn").click( function(event) {
        alert("JQuery Working!");
    });


	$('.package-button').click(function(e){
		var package_num = $(this).attr('id');
		var all_none = false;



		var pre_count = 0;
		$('.package-table-header').each(function() {
	    	if ($(this).css('display') != 'none') {
	    		pre_count++;
	    	}
	    	// if ($(this).find('td:empty')) { alert('one empty')}
	    });

	    $('.'+package_num+'-table').each(function() {
	    	$(this).toggle();
	    });


		var post_count = 0;
		$('.package-table-header').each(function() {
	    	if ($(this).css('display') != 'none') {
	    		post_count++;
	    	}
	    	// if ($(this).find('td:empty')) { alert('one empty')}
	    });

	    // alert(pre_count + ' ' + post_count);


	    if ((pre_count == 0 && post_count == 1) || (pre_count == 1 && post_count == 0) ){
	    	$('.package-table').toggle();
	    }
    });

});
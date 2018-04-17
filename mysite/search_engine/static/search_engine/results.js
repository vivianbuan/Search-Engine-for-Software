$(document).ready(function() {

        // JQuery code to be added in here.

        // alert('foo')
    $("#test-btn").click( function(event) {
        alert("JQuery Working!");
    });


    $('.package-card').mousedown(function(){
    	var isDragging = false;
    	$(this).mousemove(function(){
    		isDragging = true;    		
    	});
    	$(this).mouseup(function(){
    		if (!isDragging){
    			$(this).toggleClass('package-selected')

    			/**
				 * Handle the table
    			 */
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
			    if ((pre_count == 5 && post_count == 6)){
    				$(this).toggleClass('package-selected')

					$('.'+package_num+'-table').each(function() {
						$(this).toggle();
					});
			    }

			    if ((pre_count == 0 && post_count == 1) || (pre_count == 1 && post_count == 0) ){
			    	$('.package-table').toggle();
			    }

    		}

    		// else {}
    	});
    })

	$('.package-carousel').slick({
		arrows:true,
		infinite: false,
		slidesToShow: 5,
		variableWidth: true,
		// swipe: false,
		swipeToSlide: true,
		touchThreshold: 10,
		slidesToScroll: 1
  	});	
	// $('')
});
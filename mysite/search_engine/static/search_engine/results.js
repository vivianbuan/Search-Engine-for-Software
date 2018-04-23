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

    			// var colors = {'red', 'orange', 'yellow', 'green', 'blue', 'violet'}
    			/**
				 * Handle the table
    			 */
				var package_num = $(this).attr('id');
				var all_none = false;

				var pre_count = 0;

				// $('.package-table-header').each(function() {
			 //    	if ($(this).css('display') != 'none') {
			 //    		pre_count++;
			 //    	}
			 //    	// if ($(this).find('td:empty')) { alert('one empty')}
			 //    });

			 //    $('.'+package_num+'-table').each(function() {
			 //    	$(this).toggle();
			 //    });


				// var post_count = 0;
				// $('.package-table-header').each(function() {
			 //    	if ($(this).css('display') != 'none') {
			 //    		post_count++;
			 //    	}
			 //    	// if ($(this).find('td:empty')) { alert('one empty')}
			 //    });

			 //    // alert(pre_count + ' ' + post_count);
			 //    if ((pre_count == 5 && post_count == 6)){
    // 				$(this).toggleClass('package-selected')

				// 	$('.'+package_num+'-table').each(function() {
				// 		$(this).toggle();
				// 	});
			 //    }
			    $('.'+package_num+'-information-card').toggle();

			    // if ((pre_count == 0 && post_count == 1) || (pre_count == 1 && post_count == 0) ){
			    // 	$('.package-table').toggle();
			    // }

    		}

    		// else {}
    	});
    })

	$('.option-checkbox').change(function(){
		alert('checked');
		// alert(JSON.stringify(this));
		// $.ajax({
			
		// })
	});


	/*/
	 *  Get the dropdowns for the options to behave the way I want
	 *  That means: Don't close dropdown after click, but close on outside click
	 */
	$('.dropdown-toggle').mousedown(function(){
		$(this).dropdown();
	});
	$(document).mouseup(function(e){
		$('.dropdown-menu').each(function(){
			if ($(this).hasClass('show')){
				$(this).removeClass('show');
			}
		});
	
	});
	$('.dropdown-menu').mouseup(function(e){
		e.stopPropagation();
	});


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
});
$(document).ready(function(){
    $("#add-new-tag").hide();

    $('body').on('click','#add-tag-btn', function () {
        $("#add-new-tag").slideToggle(function() {
            $('#new-tag').focus();
        });
        return false;
    });

    $('body').on('click', '#save-word-btn', function(event) {
        event.preventDefault();

        var newTag = $('#new-tag');
        
        $.ajax({
            url: "/categories",
            method: "post",
            data: {
                category: { name: $('#new-tag').val() }
            },
            //success中的category值是从controller中传递过来
            success: function (category) {
                var newOption = $('<option />').attr('value', category.id).attr('selected', true).text(category.name);
                $('#categories_select').append(newOption);
                $('#new-tag').val("");
            },
            error: function (xhr) {
                var errors = xhr.responseJSON;
                var error = errors.join(", ");
                if (error) {
                    inputGroup.next('.text-danger').detach();

                    inputGroup
                        .addClass('has-error')
                        .after('<p class="text-danger">' + error + '</p>');
                }
            }
        });
    }); 
})

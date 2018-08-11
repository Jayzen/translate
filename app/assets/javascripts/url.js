$(document).on('click', '.pagination a[data-remote=true]', function() {
    history.pushState({}, '', $(this).attr('href'));
});

$(window).on('popstate', function() {
    $.get(document.location.href);
});

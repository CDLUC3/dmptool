import 'bootstrap/js/dist/popover';

$(() => {
  $('[data-toggle="popover"]').popover({
    animated: 'fade',
    placement: 'right',
  });
});

var working = false;
$('.login').on('submit', function(e) {
  if (working) return;
  working = true;
  var $this = $(this),
    $state = $this.find('button > .state');
  $state.html('Authenticating');
});
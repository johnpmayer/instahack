var medias = []

$('.timelineCard').map(function(index,element){
  element.style.position = 'relative';
  var dimensions = element.getBoundingClientRect();
  var size = dimensions.width + 'px';
  var media = element.getAttribute('data-reactid').split(/[{}]/)[1];
  medias.push(media);
  var overlay_id = 'overlay_' + media;
  var elm_div = document.createElement('div');
  elm_div.id = overlay_id;
  elm_div.style.position = 'absolute';
  elm_div.style.top = 0;
  elm_div.style.left = 0;
  elm_div.style.width = size;
  elm_div.style.height = size;
  elm_div.style['z-index'] = 10;
  element.appendChild(elm_div);
  Elm.embed(Elm.Overlay, elm_div, {media:media});
});

console.log(medias);

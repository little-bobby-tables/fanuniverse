export default function() {
  const grid    = document.querySelector('.js-masonry-grid'),
        masonry = grid && masonryjs(grid),
        imgload = grid && imagesLoaded(grid);

  /* "Unloaded images can throw off Masonry layouts and cause item elements to overlap",
   * see http://masonry.desandro.com/layout.html#imagesloaded. */

  imgload && imgload.on('progress', () => masonry.layout());
}

function masonryjs(grid) {
  const masonry = new Masonry(grid, {
    itemSelector: '.grid__item',
    transitionDuration: '0.2s',
    isFitWidth: true,
    initLayout: false, /* delay layout() to bind the layoutComplete listener */
  });

  const header    = document.querySelector('.js-masonry-grid-header'),
        container = document.querySelector('.js-grid-loading');

  masonry.on('layoutComplete', () => {
    const gridWidth = (masonry.cols * masonry.columnWidth);
    header.style.width = `${gridWidth}px`;
  });

  masonry.layout();

  /* .js-grid-loading makes the element invisible. We only remove this class
   * after setting the header width; this prevents layout "jumps" caused by
   * undetermined width coupled with margin: auto. */
  container.classList.remove('js-grid-loading');

  return masonry;
}

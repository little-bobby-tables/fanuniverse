export default function() {
  const grid    = document.querySelector('.js-grid'),
        masonry = grid && masonryjs(grid),
        imgload = grid && imagesLoaded(grid);

  /* "Unloaded images can throw off Masonry layouts and cause item elements to overlap",
   * see http://masonry.desandro.com/layout.html#imagesloaded. */

  imgload && imgload.on('progress', () => masonry.layout());
}

function masonryjs(grid) {
  const masonry = new Masonry(grid, {
    itemSelector: '.js-grid__item',
    transitionDuration: '0.2s',
    isFitWidth: true,
    initLayout: false, /* delay layout() to bind the layoutComplete listener */
  });

  const container = document.querySelector('.js-grid-container'),
        header    = document.querySelector('.js-grid-header');

  masonry.on('layoutComplete', () => {
    const gridWidth = (masonry.cols * masonry.columnWidth);
    header.style.width = `${gridWidth}px`;
  });

  masonry.layout();

  /* When the header width is being updated, the layout "jumps" due to margin: auto.
   * To avoid this effect on page load, .js-grid-container is initially set to .invisible —
   * we can make it visible once the correct width is set. */
  container.classList.remove('invisible');

  return masonry;
}

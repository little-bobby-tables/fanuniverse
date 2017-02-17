export default function() {
  const grid = document.querySelector('.js-masonry-grid'),
        header = grid && document.querySelector('.js-masonry-grid-header');

  /* Initializes Masonry after all images have loaded —
   * see http://masonry.desandro.com/layout.html#imagesloaded */

  grid && imagesLoaded(grid, () => {
    const masonry = new Masonry(grid, {
      itemSelector: '.grid__item',
      transitionDuration: '0.2s',
      isFitWidth: true,
      initLayout: false
    });

    /* Resizes .js-masonry-grid-header to appear to be the same width as the grid.
     * This way we can center the grid in page without having its header dangling off the side. */

    masonry.on('layoutComplete', () => {
      const gridWidth = (masonry.cols * masonry.columnWidth);

      header.style.width = `${gridWidth}px`;

      grid.classList.remove('grid--loading');
      header.classList.remove('grid--loading');
    });

    masonry.layout();
  });
}

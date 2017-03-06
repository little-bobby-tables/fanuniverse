'use strict';

import gulp from 'gulp';
import rev from 'gulp-rev';

import environments from 'gulp-environments';

export const development = environments.development,
             production = environments.production;

export const root = '../../..';

export const dest = {
  assets:   `${root}/public/assets`,
  fonts:    `${root}/public/fonts`,
  manifest: `${root}/public/assets/manifest.json`
};

export const javascripts = {
  vendor: [
    `./node_modules/rails-ujs/dist/rails-ujs.js`,
    './node_modules/whatwg-fetch/fetch.js',
    './node_modules/promise-polyfill/promise.js',
    './node_modules/element-closest/element-closest.js',
    './node_modules/masonry-layout/dist/masonry.pkgd.js',
    './node_modules/imagesloaded/imagesloaded.pkgd.js'
  ],
  all:         `${root}/app/assets/**/*.js`,
  application: `${root}/app/assets/javascripts/application.js`,
};

export const stylesheets = {
  vendor: [
    './node_modules/normalize.css/normalize.css'
  ],
  all:                `${root}/app/assets/stylesheets/**/*.scss`,
  application:        `${root}/app/assets/stylesheets/application.scss`,
  fontawesomeSass:    `./node_modules/font-awesome/scss`,
  fontawesomeWebfont: `./node_modules/font-awesome/fonts/**.*`,
};

/* Unfortunately, there is no way to skip temporary files —
 * see https://github.com/sindresorhus/gulp-rev/issues/205 and similar issues. */
export function productionRev() {
  return gulp.src([`${dest.assets}/application.js`,
                   `${dest.assets}/application.css`])
      .pipe(rev())
      .pipe(gulp.dest(dest.assets))
      .pipe(rev.manifest())
      .pipe(gulp.dest(dest.assets));
}

'use strict';

/* Dependencies */

import gulp from 'gulp';

import rev from 'gulp-rev';
import environments from 'gulp-environments';
import sourcemaps from 'gulp-sourcemaps';
import stream from 'event-stream';
import concat from 'gulp-concat';

import rollup from 'rollup-stream';
import buble from 'rollup-plugin-buble';
import source from 'vinyl-source-stream';
import buffer from 'vinyl-buffer';
import uglify from 'gulp-uglify';

import sass from 'gulp-sass';
import autoprefixer from 'gulp-autoprefixer';

/* Environments */

const development = environments.development,
      production = environments.production;

/* Paths */

const railsRoot = '../../..';

const assets = {
  dest:               `${railsRoot}/public/assets`,
  fontDest:           `${railsRoot}/public/fonts`,
  productionManifest: `${railsRoot}/public/assets/manifest.json`
};

const javascripts = {
  vendor: [
               './node_modules/whatwg-fetch/fetch.js',
               './node_modules/promise-polyfill/promise.js',
               './node_modules/element-closest/element-closest.js',
               './node_modules/masonry-layout/dist/masonry.pkgd.js',
               `${railsRoot}/app/assets/javascripts/vendor/**/*.js`
  ],
  all:         `${railsRoot}/app/assets/**/*.js`,
  application: `${railsRoot}/app/assets/javascripts/application.js`,
};

const stylesheets = {
  vendor: [
                      './node_modules/normalize.css/normalize.css'
  ],
  all:                `${railsRoot}/app/assets/stylesheets/**/*.scss`,
  application:        `${railsRoot}/app/assets/stylesheets/application.scss`,
  fontawesomeSass:    `./node_modules/font-awesome/scss`,
  fontawesomeWebfont: `./node_modules/font-awesome/fonts/**.*`,
};

/* Tasks */

gulp.task('default', ['compile-javascripts', 'compile-stylesheets']);

gulp.task('watch', ['watch-javascripts', 'watch-stylesheets']);

/* Manifests */

const revManifest = {
  base: assets.dest,
  merge: true
};

/* Javascripts */

const rollupConfig = {
  plugins: [buble()],
  entry: javascripts.application,
  format: 'iife',
  sourceMap: development()
};

function applicationJavascripts() {
  return rollup(rollupConfig)
      .pipe(source('application.js'))
      .pipe(buffer())
      .pipe(development(sourcemaps.init({ loadMaps: true })))
      .pipe(development(sourcemaps.write()));
}

function vendorJavascripts() {
  return gulp.src(javascripts.vendor);
}

gulp.task('compile-javascripts', () => {
  return stream.merge(vendorJavascripts(), applicationJavascripts())
      .pipe(concat('application.js'))
      .pipe(production(uglify()))
      .pipe(production(rev()))
      .pipe(gulp.dest(assets.dest))

      .pipe(production(rev.manifest(assets.productionManifest, revManifest)))
      .pipe(production(gulp.dest(assets.dest)));
});

gulp.task('watch-javascripts', () => {
  gulp.watch(javascripts.all, ['compile-javascripts']);
});

/* Stylesheets */

const autoprefixerConfig = {
  browsers: ['last 2 versions'],
  cascade: false
};

const sassConfig = {
  indentedSyntax: false,
  errLogToConsole: true,
  includePaths: [stylesheets.fontawesomeSass]
};

gulp.task('compile-stylesheets', ['compile-font-awesome', 'compile-scss']);

gulp.task('compile-font-awesome', () => {
  return gulp.src(stylesheets.fontawesomeWebfont)
      .pipe(gulp.dest(assets.fontDest));
});

gulp.task('compile-scss', () => {
  return stream.merge(gulp.src(stylesheets.vendor),
                      gulp.src(stylesheets.application))
      .pipe(concat('application.css'))
      .pipe(development(sourcemaps.init()))
      .pipe(sass(sassConfig))
      .pipe(autoprefixer(autoprefixerConfig))
      .pipe(development(sourcemaps.write()))
      .pipe(production(rev()))
      .pipe(gulp.dest(assets.dest))

      .pipe(production(rev.manifest(assets.productionManifest, revManifest)))
      .pipe(production(gulp.dest(assets.dest)));
});

gulp.task('watch-stylesheets', () => {
  gulp.watch(stylesheets.all, ['compile-stylesheets']);
});

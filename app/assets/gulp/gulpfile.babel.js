'use strict';

/* Dependencies */

import gulp from 'gulp';
import bower from 'gulp-bower';

import rev from 'gulp-rev';
import environments from 'gulp-environments';
import sourcemaps from 'gulp-sourcemaps';

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

/* Asset paths */

const railsRoot = '../../..';
const assets = {

  /* Sources */
  bower:                 `./bower_components`,
  javascripts:           `${railsRoot}/app/assets/javascripts`,
  applicationJavascript: `${railsRoot}/app/assets/javascripts/application.js`,
  stylesheets:           `${railsRoot}/app/assets/stylesheets`,
  applicationStylesheet: `${railsRoot}/app/assets/stylesheets/application.scss`,
  fontawesomeSass:       `./bower_components/font-awesome/scss`,
  fontawesomeWebfont:    `./bower_components/font-awesome/fonts/**.*`,

  /* Destinations */
  dest:                  `${railsRoot}/public/assets`,
  fontDest:              `${railsRoot}/public/assets/fonts`,
  productionManifest:    `${railsRoot}/public/assets/manifest.json`

};

/* Tasks */

gulp.task('init', () => {
  return bower().pipe(gulp.dest(assets.bower))
});

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
  entry: assets.applicationJavascript,
  format: 'iife',
  sourceMap: development()
};

gulp.task('compile-javascripts', () => {
  return rollup(rollupConfig)
      .pipe(source('application.js'))
      .pipe(buffer())
      .pipe(development(sourcemaps.init({ loadMaps: true })))
      .pipe(development(sourcemaps.write()))
      .pipe(production(uglify()))
      .pipe(production(rev()))
      .pipe(gulp.dest(assets.dest))

      .pipe(production(rev.manifest(assets.productionManifest, revManifest)))
      .pipe(production(gulp.dest(assets.dest)));
});

gulp.task('watch-javascripts', () => {
  gulp.watch(`${assets.javascripts}/**/*.js`, ['compile-javascripts']);
});

/* Stylesheets */

const autoprefixerConfig = {
  browsers: ['last 2 versions'],
  cascade: false
};

const sassConfig = {
  indentedSyntax: false,
  errLogToConsole: true,
  includePaths: [`${assets.fontawesomeSass}`]
};

gulp.task('compile-stylesheets', ['compile-font-awesome', 'compile-scss']);

gulp.task('compile-font-awesome', () => {
  return gulp.src(assets.fontawesomeWebfont)
      .pipe(rev())
      .pipe(gulp.dest(assets.fontDest));
});

gulp.task('compile-scss', () => {
  return gulp.src(assets.applicationStylesheet)
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
  gulp.watch(`${assets.stylesheets}/**/*.scss`, ['compile-stylesheets']);
});

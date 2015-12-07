g = require('gulp')
browserSync = require('browser-sync').create()
$ = require('gulp-load-plugins')()
browserify = require('browserify')
babelify = require('babelify');
source = require('vinyl-source-stream')
runSequence = require('run-sequence')
rimraf = require('rimraf')
configs = require('./build_resource/config')

plumber = -> $.plumber configs.plumber.options
sass = (isMinify = false) ->
  postcssOpt = configs.postcss.options
  postcssOpt.push require('cssnano') if isMinify
  g.src configs.sass.src
  .pipe plumber()
  .pipe $.sourcemaps.init()
  .pipe $.sass configs.sass.options
  .pipe $.postcss configs.postcss.options
  .pipe $.sourcemaps.write '.'
  .pipe g.dest configs.sass.target

js = (isMinify = false) ->
  stream = browserify configs.js.src
  .transform babelify, configs.js.options
  .bundle()
  .on "error", (err) -> console.log "Error: #{err.message}"
  .pipe source configs.js.file

  stream.pipe $.uglify() if isMinify
  stream.pipe g.dest configs.js.target

g.task 'default', () ->
  runSequence 'clean', 'iconfont', ['jade', 'sass', 'js', 'asset'], ['watch', 'server']
g.task 'build', () ->
  runSequence 'clean', 'iconfont', ['jade', 'sass:minify', 'js:minify', 'asset'], ['imagemin']

g.task 'jade', ->
  g.src configs.jade.src
  .pipe plumber()
  .pipe $.jade configs.jade.options
  .pipe g.dest configs.jade.target

g.task 'sass', -> sass()
g.task 'sass:minify', -> sass(true)
g.task 'js', -> js()
g.task 'js:minify', -> js(true)

g.task 'sasslint', ->
  g.src configs.sasslint
  .pipe $.sassLint()
  .pipe $.sassLint.format()
  .pipe $.sassLint.failOnError()

g.task 'eslint', ->
  g.src configs.eslint
  .pipe $.eslint()
  .pipe $.eslint.format()
  .pipe $.eslint.failAfterError()

g.task 'asset', ->
  g.src configs.asset.src
  .pipe plumber()
  .pipe g.dest configs.asset.target

g.task 'iconfont', ->
  g.src configs.iconfont.src
  .pipe plumber()
  .pipe $.iconfont configs.iconfont.options
  .on 'glyphs', (glyphs, options) ->
    engine = configs.consolidate.engine
    consolidateOption = configs.consolidate.options
    consolidateOption.glyphs = glyphs

    g.src configs.consolidate.cssTemplate
    .pipe $.consolidate engine, consolidateOption
    .pipe $.rename configs.consolidate.cssRenameOptions
    .pipe g.dest configs.consolidate.cssTarget

    g.src configs.consolidate.htmlTemplate
    .pipe $.consolidate engine, consolidateOption
    .pipe $.rename configs.consolidate.htmlRenameOptions
    .pipe g.dest configs.consolidate.htmlTarget

  .pipe g.dest configs.iconfont.target

g.task 'imagemin', ->
  g.src configs.imagemin.src
  .pipe $.imagemin configs.imagemin.options
  .pipe g.dest configs.imagemin.target

g.task 'watch', ->
  g.watch configs.jade.watch, -> runSequence 'jade', 'reload'
  g.watch configs.sass.watch, -> runSequence ['sasslint', 'sass'], 'reload'
  g.watch configs.js.watch, -> runSequence ['eslint', 'js'], 'reload'
  g.watch configs.asset.watch, ['asset']
  g.watch configs.iconfont.watch, ['iconfont']

g.task 'clean', (cd) -> rimraf(configs.clean, cd)
g.task 'server', -> browserSync.init(configs.server.options)
g.task 'reload', -> browserSync.reload()
module.exports = {
  sass: {
    src: "app/styles/styles.scss",
    target: "dist/styles",
    watch: "app/styles/**/*.scss",
    options: {
      includePaths: [
        "app/styles",
        "app/bower_components/support-for/sass",
        "app/bower_components/normalize-scss/sass"
      ]
    }
  },
  postcss: {
    options: [
      require('autoprefixer')({browsers: ['> 5%']}),
      require("css-mqpacker")()
    ]
  },
  js: {
    src: "app/scripts/app.js",
    target: "dist/scripts",
    watch: "app/scripts/**/*.js",
    file: "app.js",
    options: {
      presets: ["es2015"],
      sourceMaps: true
    }
  },
  sasslint: ["app/styles/**/*.scss", "!app/styles/_font.scss"],
  eslint: "app/scripts/**/*.js",
  mainBowerFiles: {
    options: {filter: /.*js$/}
  },
  uglify: {
    options: {preserveComments: 'license'}
  },
  jade: {
    src: "app/views/*.jade",
    target: "dist",
    watch: "app/views/**/*.jade",
    options: {pretty: true}
  },
  asset: {
    src: "app/assets/**/*",
    target: "dist/",
    watch: "app/assets/**/*"
  },
  iconfont: {
    src: "build_resource/iconfont/svg/*.svg",
    watch: "build_resource/iconfont/svg/*.svg",
    target: "dist/fonts",
    options: {
      fontName: "myFont",
      appendUnicode: true,
      formats: ['ttf', 'eot', 'woff'],
      timestamp: Math.round(Date.now()) / 1000
    }
  },
  consolidate: {
    cssTemplate: "build_resource/iconfont/template.css",
    cssRenameOptions: {basename: "_font", extname: ".scss"},
    htmlTemplate: "build_resource/iconfont/template.html",
    htmlRenameOptions: {basename: "iconfont"},
    options: {
      fontName: 'myfont',
      fontPath: '../fonts/',
      className: 'icon'
    },
    engine: 'lodash',
    cssTarget: "app/styles",
    htmlTarget: "doc/iconfont"
  },
  imagemin: {
    src: "dist/images/*",
    target: "dist/images",
    options: {
      progressive: true,
      use: [require('imagemin-pngquant')()]
    }
  },
  clean: "dist",
  server: {
    options: {server: {baseDir: "dist"}}
  },
  plumber: {
    options: {errorHandler: require('gulp-notify').onError("Error: <%= error.message %>")}
  }
};
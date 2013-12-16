module.exports = function(grunt) {
  
  var tempName = "./dist/<%= pkg.name %>.zip";
  var archiveName = "./dist/<%= pkg.name %>-<%= pkg.version %>.love";
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    compress: {
      dist: {
        options: {
          archive: tempName
        },
        files: [ 
          {
            expand: true,
            cwd: './src/',
            src: [ '**' ],
            dest: ''
          }
        ]
      }
    },
    rename: {
      dist: {
        files: [
          {
            src: tempName,
            dest: archiveName
          }
        ]
      }
    },
    
    shell: {
      run: {
        options: {
          stdout: true // to enable logging
        },
        command: function() {
          switch ( require('os').platform() ) {
            case 'win32': // windows
              return 'love ./src';
            case 'darwin': // os x
              return 'open -n -a love ./src';
            default:
              return 'love ./src';
          }
        }
      },
      debug: {
        options: {
          stdout: true // enable logging
        },
        command: function() {
          switch ( require('os').platform() ) {
            case 'win32': // windows
              return 'love ./src --console';
            case 'darwin': // os x
              return '/Applications/love.app/Contents/MacOS/love ./src';
            default:
              return 'love ./src';
          }
        }
      }
    }
  });
  
  grunt.loadNpmTasks('grunt-contrib-compress');
  grunt.loadNpmTasks('grunt-contrib-rename');
  grunt.loadNpmTasks('grunt-shell');
  
  grunt.registerTask('dist', [ 'compress:dist', 'rename:dist' ]);
  grunt.registerTask('run', [ 'shell:run' ])
  grunt.registerTask('debug', [ 'shell:debug' ])
  
};

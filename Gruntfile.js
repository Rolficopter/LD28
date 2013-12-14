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
    }
  });
  
  grunt.loadNpmTasks('grunt-contrib-compress');
  grunt.loadNpmTasks('grunt-contrib-rename');
  
  grunt.registerTask('dist', [ 'compress:dist', 'rename:dist' ]);
  
};

# Usage:
#     guard :foreman, <options hash>
#
# Possible options:
# * :concurreny - how many of each type of process you would like to run (default is, sensibly, one of each)
# * :env - one or more .env files to load
# * :procfile - an alternate Procfile to use (default is Procfile)
# * :port - an alternate port to use (default is 5000)
# * :root - an alternate application root
guard :foreman do
  watch( /^app\/(controllers|models|helpers)\/.+\.rb$/ )
  watch( /^lib\/.+\.rb$/ )
  watch( /^config\/*/ )
  watch('Gemfile.lock')
  watch(%r{^(config|lib)/.*})
end

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  # Assume files are symlinked from somewhere
  files.each { |file| watch(helper.real_path(file)) }
end

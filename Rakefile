# frozen_string_literal: true

require 'rake'
require 'fileutils'

# Let's check if colorize is installed and use it
begin
  require 'colorize'
rescue LoadError
  puts '[!] You should think about installing the colorize gem for better output: `gem install colorize`'
end

ARCH =
  case
  when RUBY_PLATFORM.include?('linux')
    'linux'
  when RUBY_PLATFORM.include?('darwin')
    'osx'
  else
    raise 'This script only works on Mac or Linux'
  end

desc 'Symlink all our dotfiles into their positions in $HOME'
task :install do
  $stdout.sync = true # To keep the display buffer synced
  dot_print '[*] Installing .dotfiles', color: :light_blue

  %w[git irb ruby].each do |element|
    dot_print "[+] Installing #{element} files", newline: false
    install_files(Dir["#{element}/*"])
    print "\n"
  end

  # tmux
  dot_print "[+] Installing tmux files", newline: false
  install_files(Dir['tmux/*'] - ['tmux/oh-my-tmux'])
  print "\n"

  ## Install Vim files
  #dot_print '[+] Installing vim files', newline: false
  #install_files ['vim', 'vimrc']
  #print "\n"

  # Install fonts
  Rake::Task['install_fonts'].invoke

  # Install ohmyzsh
  Rake::Task['install_ohmyzsh'].invoke

  # Install terminal specific configs
  Rake::Task['install_terms'].invoke
end

desc 'Install fonts from repo'
task :install_fonts do
  dot_print "[+] Installing font files..."
  case ARCH
  when 'linux'
    font_dir = File.join(ENV['HOME'], '.fonts')
    FileUtils.mkdir(font_dir) unless File.exists?(font_dir)
  when 'osx'
    font_dir = File.join(ENV['HOME'], 'Library', 'Fonts')
  end
  Dir['fonts/*'].each do |font|
    filename = File.basename(font)
    dest = File.join(font_dir, filename)
    dot_print "[-] Installing #{filename}...", newline: false
    if File.exists?(dest)
      dot_print 'already installed.'
    else
      FileUtils.cp(font, dest)
      dot_print 'installed.'
    end
  end
end

desc 'Fix detached HEAD issues with git submodules'
task :fix_head do
  dot_require :git
  home = File.join('vim', 'pack')
  get_subdirectories(home).each do |root|
    get_subdirectories(File.join(root, 'start')).each do |dir|
      repo = File.join(Dir.pwd, '.git', 'modules', dir)
      idx = File.join(repo, 'index')
      git = Git.open(dir, repository: repo, index: idx)
      dot_print "Updating #{dir} (current_branch: #{git.branch})...", newline: false
      if git.branch.name == 'master'
        dot_print 'already at master.'
      else
        git.checkout 'master'
        dot_print 'updated to master.'
      end
    end
  end
end

desc 'Install ohmyzsh Framework'
task :install_ohmyzsh do
  # TODO: Do this.
end

desc 'Install Prezto Zsh Framework'
task :install_prezto do
  dot_print "[*] Installing Prezto", color: :light_blue

  `ln -nfs "$HOME/.dotfiles/zsh/prezto" "${ZDOTDIR:-$HOME}/.zprezto"`

  # The prezto runcoms are only going to be installed if zprezto has never been installed
  runcoms = Dir.glob('zsh/prezto/runcoms/z*').reject { |r| ['zshrc', 'zpreztorc'].include? File.basename(r) }
  install_files(runcoms, quiet: true)

  dot_print "[+] Overriding the default ~/.zshrc with ours"
  `ln -nfs "$HOME/.dotfiles/zsh/zshrc" "$HOME/.zshrc"`

  dot_print "[+] Overriding the default ~/.zpreztorc with ours"
  `ln -nfs "$HOME/.dotfiles/zsh/prezto-override/zpreztorc" "${ZDOTDIR:-$HOME}/.zpreztorc"`

  if "#{ENV['SHELL']}".include? 'zsh' then
    dot_print "[!] Zsh is already configured as your shell of choice. Restart your session to load the new settings", color: :red
  else
    dot_print "[+] Setting zsh as your default shell"
    if File.exists?("/usr/local/bin/zsh")
      if File.readlines("/private/etc/shells").grep("/usr/local/bin/zsh").empty?
        dot_print "[+] Adding zsh to standard shell list"
        `echo "/usr/local/bin/zsh" | sudo tee -a /private/etc/shells`
      end
      `chsh -s /usr/local/bin/zsh`
    else
      `chsh -s /bin/zsh`
    end
  end
end

desc 'Update terminal specific settings'
task :install_terms do
  terms_dir = File.join(File.dirname(__FILE__), 'terminals')
  # terminator
  if File.directory?(File.join(ENV['HOME'], '.config'))
    termrc = File.join(terms_dir, 'terminator', 'config')
    FileUtils.mkdir_p File.join(ENV['HOME'], '.config', 'terminator')
    FileUtils.cp(termrc, File.expand_path('~/.config/terminator/config'))
  end

  # xfce4-terminal
  xfcerc = File.expand_path('~/.config/xfce4/terminal/terminalrc')
  if File.exists?(xfcerc)
    termrc = File.join(terms_dir, 'xfce4', 'solarized-dark.rc')
    FileUtils.cp(termrc, xfcerc)
  end
end

private

def install_files(files, method: :symlink, quiet: false)
  files.each do |file|
    source = "#{ENV['PWD']}/#{file}"
    target = "#{ENV['HOME']}/.#{File.basename(file)}"
    #puts "[+] #{source} -> #{target}"

    if File.exist?(target) && (!File.symlink?(target) || (File.symlink?(target) && File.readlink(target) != source))
      `mv #{target} #{target}.backup`
    end

    if method == :symlink
      #`ln -nfs "#{source}" "#{target}"`
      FileUtils.symlink(source, target, force: true)
    else
      #`cp -f "#{source}" "#{target}"`
      FileUtils.cp(source, target)
    end

    dot_print('.', newline: false) unless quiet
  end
end

def dot_print(data, color: :green, newline: true)
  print (data.respond_to?(:colorize) ? data.colorize(color) : data)
  print "\n" if newline
end

def dot_require(param)
  begin
    require param.to_s
  rescue
    dot_print "The ruby gem #{param} is required. To install run 'gem install #{param}'"
    exit 1
  end
end

def get_subdirectories(dir)
  Dir.glob("#{dir}/*").select { |f| File.directory? f }
end

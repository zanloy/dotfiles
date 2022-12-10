require 'rake'
require 'fileutils'

# Let's check if colorize is installed and use it.
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

task :default => [:install] # Use install as default task.

desc 'Symlink all our dotfiles into their positions in $HOME'
task :install do
  $stdout.sync = true # To keep the display buffer synced.
  at_exit { $stdout.sync = false } # Ensure we turn it off after Rake has run.
  dot_print '[*] Installing .dotfiles', color: :light_blue

  %w[git irb ruby].each do |element|
    dot_print "[+] Installing #{element} files", color: :green, newline: false
    install_files(Dir["#{element}/*"])
    print "\n"
  end

  # Install fonts.
  Rake::Task['install_fonts'].invoke

  # Install Neovim.
  Rake::Task['install_nvim'].invoke

  # Install oh-my-tmux.
  Rake::Task['install_ohmytmux'].invoke

  # Install oh-my-zsh.
  Rake::Task['install_ohmyzsh'].invoke

  # Install terminal specific configs.
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
    dot_print "[>] Installing #{filename}...", newline: false
    if File.exists?(dest)
      dot_print 'already installed.'
    else
      FileUtils.cp(font, dest)
      dot_print 'installed.'
    end
  end
end

desc 'Install nvim'
task :install_nvim do
  dot_print '[+] Installing nvim.'

  # Check if nvim config dir exists and create if not.
  config_dir = File.expand_path('~/.config')
  unless Dir.exists? config_dir
    Dir.mkdir(config_dir)
    dot_print "[>] Created #{config_dir}."
  end
  nvim_dir = File.join(config_dir, 'nvim')
  unless Dir.exists? nvim_dir
    Dir.mkdir(nvim_dir)
    dot_print "[>] Created #{nvim_dir}."
  end

  # Link our config files
  dot_print '[>] Installing nvim config files...', newline: false
  install_files Dir['nvim/*'], dest_dir: nvim_dir
  dot_print 'done.'

  # Install vim-plug
  plug_filename = File.expand_path('"${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim')
  if File.exists? plug_filename
    dot_print '[>] vim-plug already installed... skipping.'
  else
    dot_print '[>] Installing vim-plug.'
    result = system(%q[sh -c 'curl -fsLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'])

    if result
      dot_print "[>] vim-plug installed to #{plug_filename}."
    else
      dot_print "[!] Error while trying to install vim-plug to #{plug_filename}"
      next
    end
  end

  # Install vim plugins
  dot_print "[>] Installing vim plugins using vim-plug."
  system('nvim -u ~/.config/nvim/plugins.vim +PlugInstall +qall')
end

desc 'Install oh-my-tmux Framework'
task :install_ohmytmux do
  # Check if oh-my-tmux directory already exists.
  if Dir.exists? File.expand_path('~/.oh-my-tmux')
    dot_print '[+] oh-my-tmux is already installed at ~/.oh-my-tmux... skipping.'
    next
  end

  dot_print '[+] Installing oh-my-tmux...'

  result = system('git clone https://github.com/gpakosz/.tmux.git ~/.oh-my-tmux')

  unless result
    dot_print '[!] Error installing oh-my-tmux.', color: :red
    next
  end

  dot_print '[*] Configuring oh-my-tmux...', newline: false
  FileUtils.symlink(File.expand_path('~/.oh-my-tmux/.tmux.conf'), File.expand_path('~/.tmux.conf'), force: true)
  install_files(Dir['tmux/*'])

  dot_print 'done.'
end

desc 'Install oh-my-zsh Framework'
task :install_ohmyzsh do
  # Verify if oh-my-zsh is already installed.
  if Dir.exists?(File.join(ENV['HOME'], '.oh-my-zsh'))
    dot_print "[+] oh-my-zsh is already installed... skipping."
  else
    dot_print "[+] Installing oh-my-zsh..."
    result = system({ 'RUNZSH' => 'no' }, 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')

    if result
      dot_print "[-] Done"
    else
      dot_print "[!] Error installing oh-my-zsh.", color: :red
    end
  end

  # Add startup script to oh-my-zsh to load .dotfile startup scripts
  path = File.expand_path('~/.oh-my-zsh/custom/dotfiles.zsh')
  unless File.exists? path
    File.open(path, 'w') do |file|
      file.puts <<~DONE
        if [[ -d ~/.dotfiles/zsh ]]; then
          for x in ~/.dotfiles/zsh/*.zsh; do
            source "$x"
          done
        fi
      DONE
    end
  end
  dot_print '[-] Done.'
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

def install_files(files, dest_dir: Dir.home, method: :symlink, quiet: false)
  files.each do |file|
    source = "#{ENV['PWD']}/#{file}"
    target = "#{dest_dir}/.#{File.basename(file)}"
    #puts "[+] #{source} -> #{target}"

    if File.exist?(target) && (!File.symlink?(target) || (File.symlink?(target) && File.readlink(target) != source))
      `mv #{target} #{target}.backup`
    end

    if method == :symlink
      FileUtils.symlink(source, target, force: true)
    else
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

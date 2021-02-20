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

  # Install fonts.
  Rake::Task['install_fonts'].invoke

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
  # Verify if oh-my-zsh is already installed.
  #if Dir.exists?(File.join(ENV['HOME'], '.oh-my-zsh'))
  #  dot_print "[+] oh-my-zsh is already installed...skipped"
  #  next # Exit task
  #end

  #dot_print "[+] Installing oh-my-zsh..."
  #result = system({ 'RUNZSH' => 'no' }, 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')

  #unless result
  #  dot_print "[!] Error installing oh-my-zsh.", color: :red
  #  next # Exit task
  #end

  #dot_print "[-] Done"

  # Install Powerlevel10k theme
  dot_print "[+] Installing Powerlevel10k (oh-my-zsh theme)...", newline: false
  #system 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'
  # Set Powerlevel10k as oh-my-zsh theme
  zshrc = File.join(ENV['HOME'], '.zshrc')
  text = <<~DONE
    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
      source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

    #{File.read(zshrc)}

    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  DONE
  text.gsub! 'ZSH_THEME="robbyrussell"', 'ZSH_THEME="powerlevel10k/powerlevel10k"'
  File.open(zshrc, 'w') { |file| file.puts text }
  dot_print 'done.'

  # Symlink p10k config file to $HOME
  path = File.join(ENV['HOME'], '.p10k.zsh')
  unless File.exists? path
    File.symlink File.join(ENV['HOME'], '.dotfiles', 'p10k.zsh'), path
  end

  # Add startup script to oh-my-zsh to load .dotfile startup scripts
  path = File.join(ENV['HOME'], '.oh-my-zsh', 'custom', 'dotfiles.zsh')
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

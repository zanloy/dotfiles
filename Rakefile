# frozen_string_literal: true

require 'rake'
require 'fileutils'

# Let's check if colorize is installed and use it
begin
  require 'colorize'
rescue LoadError
  puts '[!] You should think about installing the colorize gem for better output: `gem install colorize`'
end

desc 'Symlink all our dotfiles into their positions in $HOME'
task :install do
  $stdout.sync = true # To keep the display buffer synced
  dot_print '[*] Installing .dotfiles', color: :light_blue

  %w[git irb ruby tmux].each do |element|
    dot_print "[+] Installing #{element} files", newline: false
    install_files(Dir.glob("#{element}/*"))
    print "\n"
  end

  # Installing Vim files
  dot_print '[+] Installing vim files', newline: false
  install_files(Dir.glob('{vim,vimrc}'))
  print "\n"

  # Install prezto
  install_prezto
end

private
def install_prezto
  dot_print "[*] Installing Prezto", color: :light_blue

  `ln -nfs "$HOME/.dotfiles/zsh/prezto" "${ZDOTDIR:-$HOME}/.zprezto"`

  # The prezto runcoms are only going to be installed if zprezto has never been installed
  runcoms = Dir.glob('zsh/prezto/runcoms/z*').reject { |r| r['zsh/prezto/runcoms/zpreztorc'] }
  install_files(runcoms, quiet: true)

  dot_print "[+] Overriding the default ~/.zpreztorc with ours"
  `ln -nfs "$HOME/.dotfiles/zsh/prezto-override/zpreztorc" "${ZDOTDIR:-$HOME}/.zpreztorc"`

  dot_print "[+] Creating directories for local changes"
  `mkdir -p $HOME/.zsh.before`
  `mkdir -p $HOME/.zsh.after`
  `mkdir -p $HOME/.zsh.prompts`

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

def install_files(files, method: :symlink, quiet: false)
  files.each do |file|
    source = "#{ENV['PWD']}/#{file}"
    target = "#{ENV['HOME']}/.#{File.basename(file)}"
    #puts "[+] #{source} -> #{target}"

    if File.exist?(target) && (!File.symlink?(target) || (File.symlink?(target) && File.readlink(target) != source))
      `mv #{target} #{target}.backup`
    end

    if method == :symlink
      `ln -nfs "#{source}" "#{target}"`
      dot_print('.', newline: false) unless quiet
    else
      `cp -f "#{source}" "#{target}"`
      dot_print('.', newline: false) unless quiet
    end

    source_config_code = "for config_file ($HOME/.dotfiles/zsh/*.zsh) source $config_file"
    if File.basename(file) == 'zshrc'
      File.open(target, 'a+') do |zshrc|
        if zshrc.readlines.grep(/#{Regexp.escape(source_config_code)}/).empty?
          zshrc.puts(source_config_code)
        end
      end
    end
  end
end

def dot_print(data, color: :green, newline: true)
  print (data.respond_to?(:colorize) ? data.colorize(color) : data)
  #if data.respond_to? :colorize
  #  print data.colorize(color)
  #else
  #  print data
  #end
  print "\n" if newline
end

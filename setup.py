import os
import shutil
import requests
import platform

from command import Command

def download_file(url, file_name): 
    res = requests.get(url)
    if res.status_code != 200: 
        raise(Exception(f"Could not download {url}: {res.text}"))
    with open(file_name, "wb") as f:
        f.write(res.content)

def command_exists(command_to_check):
    c = Command("which", [command_to_check], ignore_non_zero=True)
    c.run_command()
    return c.get_return_code() == 0


class RemoveableFile(): 
    def __init__(self, file_path): 
        self.file_path = file_path

    def __enter__(self): 
        return self

    def __exit__(self, exc_type, exc_value, exc_traceback):
        if exc_type: 
            return
        if not os.path.exists(self.file_path):
            return 

        os.remove(self.file_path)

class RemoveableDirectory():
    def __init__(self, name, with_create=True): 
        self.dir_name = name
        self.with_create = with_create

    def __enter__(self):
        if self.with_create:
            os.makedirs(self.dir_name, exist_ok=True)
        return self

    def __exit__(self, exc_type, exc_value, exc_traceback):
        print(exc_type, exc_value)
        if exc_type: 
            return 
        try:
            shutil.rmtree(self.dir_name)
        except FileNotFoundError: 
            pass

def make_executable(file_path): 
    Command("chmod", ["+x", file_path]).run_command()

class DownloadableInstallation(): 
    def __init__(self, name, url, parameters = []): 
        self.name = name
        self.url = url
        self.parameters = parameters

    def run(self): 
        with RemoveableFile(self.name): 
            download_file(self.url, self.name)
            make_executable(self.name)
            Command(command=f"./{self.name}", arguments=self.parameters).run_command()

class AptInstallablePackage(): 
    def __init__(self, package, repo = ""): 
        self.package = package
        self.repo = repo

    def run(self): 
        Command("apt", arguments=["install", "-y", self.package]).as_sudo().run_command()

def soft_link(src, target, sudo=False):
    target_dir = os.path.dirname(target)
    if not os.path.exists(target_dir):
        print(f"target dir: {target_dir} not exists. creating...")
        os.makedirs(target_dir, exist_ok=True)
    c = Command("ln", arguments=["-sf", src, target])
    if sudo:
        c = c.as_sudo()
    c.run_command()

def home(path_after_home):
    return os.path.join(os.path.expanduser("~"), path_after_home)

def untar(source, target): 
    os.makedirs(target, exist_ok=True)
    Command("tar", arguments=["-xvzf", source, "-C", target, "--strip-components=1"]).run_command()

def configuration_path(file_name): 
    return os.path.join(os.getcwd(), "config_files", file_name)

def install_deb_file(file_path):
     Command("apt", arguments=["install", "-f", file_path]).as_sudo().run_command()


class i3():
    def __init__(self): 
        pass
    
    def should_install(self):
        return not command_exists("i3")

    def install(self): 
        AptInstallablePackage("i3").run()

    def configure(self): 
        soft_link(configuration_path("Xresources"), home(".Xresources")) 
        soft_link(configuration_path("i3_config"), home(os.path.join(".config", "i3", "config")))

class wezterm(): 
    def __init__(self): 
        pass
    
    def should_install(self):
        return not command_exists("wezterm")

    def install(self): 
        with RemoveableFile("github_wezterm"):
            download_file("https://github.com/wez/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203-110809-5046fc22.Ubuntu22.04.deb", "github_wezterm.deb")
            install_deb_file("./github_wezterm.deb")
    
    def configure(self): 
        soft_link(configuration_path("wezterm.lua"), home(os.path.join(".config", "wezterm", "wezterm.lua")))
        soft_link(configuration_path("keys.lua"), home(os.path.join(".config", "wezterm", "keys.lua")))

class zsh(): 
    def __init__(self): 
        pass
    
    def should_install(self):
        return not command_exists("zsh")

    def install(self): 
        AptInstallablePackage("zsh").run()

    def configure(self): 
        soft_link(configuration_path("zshrc"), home(".zshrc"))

class tmux(): 
    def __init__(self):
        pass
    
    def should_install(self):
        return not command_exists("tmux")

    def install(self): 
        AptInstallablePackage("tmux").run()
    
    def configure(self):
        soft_link(configuration_path("tmux"), home(".tmux.conf"))

class picom(): 
    def __init__(self):
        pass
    
    def should_install(self):
        return not command_exists("picom")

    def install(self):
        AptInstallablePackage("picom").run()

    def configure(self): 
        soft_link(configuration_path("picom.conf"), home(os.path.join(".config", "picom", "picom.conf")))

class chrome(): 
    def __init__(self):
        self.commnad_exists = False
    
    def should_install(self):
        self.command_exists = command_exists("google-chrome")
        return not self.command_exists 

    def install(self): 
        with RemoveableFile("chrome.deb"): 
            download_file("https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb", "chrome.deb")
            install_deb_file("./chrome.deb")

    def configure(self):
        if self.command_exists:
            return 
        stable_link = Command("which", arguments=["google-chrome-stable"]).process_with_output().decode("utf-8").strip()
        stable_actual = os.readlink(stable_link)
        target = os.path.join(os.path.dirname(stable_link), "google-chrome")
        soft_link(stable_actual, target , sudo=True)

class starship(): 
    def __init__(self): 
        pass
    
    def should_install(self):
        return not command_exists("starship")

    def install(self): 
        DownloadableInstallation("starship", "https://starship.rs/install.sh", ["--force"]).run()

    def configure(self):
        soft_link(configuration_path("starship.toml"), home(os.path.join(".config", "starship.toml")))


class nvim():
    def __init__(self, local_path):
        self.local_path = local_path

    def should_install(self):
        return not command_exists("nvim")
    

    def link_files(self, relative, target): 
        walk_path = configuration_path(relative) 
        for root, dirs, files in os.walk(walk_path):
            for f in files: 
                link_target = os.path.join(root[root.index(relative) + len(relative):], f)
                if link_target[0] == '/':
                    link_target = link_target[1:]
                link_source = os.path.join(root, f)
                full_target = home(os.path.join(target, link_target))
                soft_link(link_source, full_target)

    def install(self):
        with RemoveableFile("nvim.tar.gz"):
            file = "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
            if platform.system() == 'Darwin':
                file = "https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz"

            download_file(file, "nvim.tar.gz")
            untar("nvim.tar.gz", "nvim")
            Command(command="mv", arguments=["-f", "nvim/", f"{self.local_path}"]).run_command()
            soft_link(os.path.join(self.local_path, "nvim", "bin", "nvim"), "/usr/local/bin/nvim", sudo=True)

    def configure(self):
        soft_link(configuration_path("nvim"), home(os.path.join(".config")))

class XServer():
    def __init__(self):
        pass 
    
    def should_install(self):
        return False

    def install(self):
        pass 

    def configure(self):
        Command("setxkbmap", arguments=["-option", "caps:ctrl_modifier"]).run_command()

class copyq():
    def __init__(self):
        pass 
    
    def should_install(self):
        return not command_exists("copyq")

    def install(self):
        AptInstallablePackage("copyq").run()

    def configure(self):
        soft_link(configuration_path("coypq.conf"), home(os.path.join(".config", "copyq", "copyq.conf")))
        soft_link(configuration_path("copyq-commands.ini"), home(os.path.join(".config", "copyq", "copyq-commands.ini")))

def main(): 
    install = True
    configure = True
    force = False
    
    all_env_applications = [
        #XServer(), 
        #zsh(),
        #tmux(),
        #picom(),
        #wezterm(),
        #starship(),
        #chrome(),
        #i3(),
        #copyq(),
        nvim(home("opt"))
    ]

    if platform.system() == 'Darwin':
        all_env_applications = [
            #zsh(),
            #wezterm(),
            nvim(home("opt")),
            #starship(),
        ]

    for application in all_env_applications:  
        if install and (application.should_install() or force):
            application.install()
        
        if configure: 
            application.configure()



if __name__ == "__main__":
    main()

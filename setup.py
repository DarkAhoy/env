import os
import shutil
import requests

from command import Command

def download_file(url, file_name):
    res = requests.get(url)
    if res.status_code != 200:
        raise (Exception(f"Could not download {url}: {res.text}"))
    with open(file_name, "wb") as f:
        f.write(res.content)


def command_exists(command_to_check):
    c = Command("which", [command_to_check], ignore_non_zero=True)
    c.run_command()
    return c.get_return_code() == 0

def brew_exists(package):
    c = Command("brew", arguments=["list", package], ignore_non_zero=True)
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
    def __init__(self, name, url, parameters=[]):
        self.name = name
        self.url = url
        self.parameters = parameters

    def run(self):
        with RemoveableFile(self.name):
            download_file(self.url, self.name)
            make_executable(self.name)
            Command(command=f"./{self.name}",
                    arguments=self.parameters).run_command()


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
    Command("tar", arguments=["-xvzf", source, "-C",
            target, "--strip-components=1"]).run_command()


def configuration_path(file_name):
    return os.path.join(os.getcwd(), "config_files", file_name)

def brew_install(package, is_cask=False):
    args = ["install"]
    if is_cask: 
        args.append("--cask")
    args.append(package)
    Command("brew", arguments=args).run_command()

class Wezterm():
    def __init__(self):
        pass

    def should_install(self):
        return not command_exists("wezterm")

    def install(self):
        brew_install("wezterm@nightly", is_cask=True)

    def configure(self):
        soft_link(configuration_path("wezterm"), home(
            os.path.join(".config", "wezterm")))


class Zsh():
    def __init__(self):
        pass

    def should_install(self):
        return not command_exists("zsh")

    def install(self):
        pass

    def configure(self):
        soft_link(configuration_path("zshrc"), home(".zshrc"))
        soft_link(configuration_path(".path.sh"), home(".path.sh"))


class Homebrew():
    def __init__(self):
        pass

    def should_install(self):
        return not command_exists("brew")

    def install(self):
        with RemoveableFile("brew"):
            DownloadableInstallation(name="brew", url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh").run()
            make_executable("brew")
            Command("brew").run_command()

    def configure(self):
        pass


class Iosevka():
    def __init__(self):
        pass

    def should_install(self):
        return not brew_exists("font-iosevka")

    def install(self):
        brew_install("font-iosevka", is_cask=True)

    def configure(self):
        pass


class link_wallpapers(): 
    soft_link(configuration_path("wallpapers"), home(os.path.join(".config", "wallpapers")))


class Starship():
    def __init__(self):
        pass

    def should_install(self):
        return not brew_exists("starship")

    def install(self):
        brew_install("starship")

    def configure(self):
        soft_link(configuration_path("starship.toml"), home(
            os.path.join(".config", "starship.toml")))


class Nvim():
    def __init__(self):
        pass

    def should_install(self):
        return not brew_exists("nvim")

    def install(self):
        brew_install("nvim")

    def configure(self):
        soft_link(configuration_path("nvim"), home(os.path.join(".config")))


class Karabiner():
    def __init__(self):
        pass

    def should_install(self):
        return not brew_exists("karabiner-elements")

    def install(self):
        brew_install("karabiner-elements", is_cask=True)

    def configure(self):
        soft_link(configuration_path("karabiner"),
                  home(os.path.join(".config")), sudo=True)


class JetBrains():
    def __init__(self):
        pass

    def should_install(self):
        return False

    def install(self):
        pass

    def configure(self):
        soft_link(configuration_path("ideavimrc"), home(".ideavimrc"))


class Raycast():
    def __init__(self):
        pass

    def should_install(self):
        return not brew_exists("raycast")

    def install(self):
        brew_install("raycast", is_cask=True)

    def configure(self):
        print("import config manually")

def main():
    install = True
    configure = True
    force = False

    link_wallpapers()

    all_env_applications = [
        Homebrew(),
        #Iosevka(),
        Wezterm(),
        Nvim(),
        Starship(),
        Karabiner(),
        Zsh(),
        JetBrains(),
        Raycast(),
    ]

    for application in all_env_applications:
        if install and (application.should_install() or force):
            application.install()

        if configure:
            application.configure()


if __name__ == "__main__":
    main()

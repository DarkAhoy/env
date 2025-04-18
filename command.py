import subprocess

class Command:
    def __init__(self, command, arguments=[], env=None, directory=None, ignore_non_zero=False): 
        self.command = command
        self.arguments = arguments
        self.env = env
        self.directory = directory
        self.output = None
        self.return_code = -1
        self.ignore_non_zero = ignore_non_zero

    def set_env(self, env, override=True): 
        if not env:
            return

        if not self.env:
            self.env = env

        if override:
            self.env = {**self.env, **env}
        else:
            self.env = {**env, **self.env}

    def as_sudo(self):
        self.arguments.insert(0, self.command)
        self.command = "sudo"
        return self

    def set_output(self, output):
        self.output = output

    def get_output(self):
        return self.output

    def process_with_output(self):
        print(self)

        p = subprocess.Popen(args=[self.command] + self.arguments,
                            cwd=self.directory,
                            env=self.env, stdout=subprocess.PIPE)
        
        output = bytearray()
        for l in p.stdout: 
            print(l.decode("utf-8"), end='')
            output += l

        p.wait()
        
        self.return_code = p.returncode
        if p.returncode != 0 and not self.ignore_non_zero:
            raise Exception(f"got an error running: {self}")

        return output
        
    def get_return_code(self): 
        if self.return_code == -1:
            raise Exception("requested return code before command ran")
        return self.return_code

    def run_command(self):
        return self.process_with_output()

    def __str__(self): 
        return f"{self.command} {' '.join(self.arguments)}"


from blessed import Terminal
from time import sleep, time
import datetime
from sys import argv
import os

term = Terminal()
VERSION = '0.3.0'

def banner():
    print(term.green('tifm '+VERSION))
    print(term.underline(term.blue('https://github.com/Rexxt/tifm')))
    print(term.on_red('/!\\ you are running a bleeding edge version of tifm. '))
    print(term.on_red('    if you encounter any bugs, report them on github.'))

banner()

if len(argv) > 1 and os.path.isdir(argv[1]):
    directory = argv[1]
else:
    directory = os.getcwd()

directory = os.path.abspath(directory)
directory = os.path.normpath(directory).split(os.sep)

def directory_string():
    fmt_directory = []
    for i in range(len(directory)):
        if i == len(directory)-1:
            fmt_directory.append(directory[i])
        else:
            fmt_directory.append(directory[i][0])
    return ' › '.join(fmt_directory)

def main_render():
    yield term.move_xy(0, 0) + term.green('>')
    yield term.move_xy(2, 0) + term.green(directory_string()[:term.width-2])
    yield term.move_xy(0, 1) + term.green('—'*term.width)

    time_str = datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')
    yield term.move_xy(term.width-len(time_str), 0) + term.blue(time_str)

    ls = os.listdir(os.sep.join(directory))
    for i in range(len(ls)):
        file = ls[i]
        full_file_path = os.sep.join(directory + [file])
        if os.path.isdir(full_file_path):
            yield term.move_xy(1, 2+i) + term.blue('D')
        else:
            yield term.move_xy(1, 2+i) + term.green('-')

        mtime = os.path.getmtime(full_file_path)
        mtime_str = datetime.datetime.fromtimestamp(mtime).strftime('%d/%m/%Y %H:%M:%S')
        yield term.move_xy(3, 2+i) + mtime_str + ' ' + file


with term.fullscreen():
    banner()

    print()

    print(term.underline('starting in 3 seconds...'))
    sleep(3)

    print(term.home+term.clear, end='', flush=True)
    try:
        last_update = time()
        while True:
            dt = time() - last_update
            last_update = time()

            s = ''
            for e in main_render():
                s += e
    
            print(term.home+term.clear+s+term.move_xy(0,0), end='', flush=True)

            with term.cbreak():
                key = term.inkey(timeout=0)
    except KeyboardInterrupt:
        pass
print(term.green('thank you for using tifm!'))
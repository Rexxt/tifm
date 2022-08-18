# tifmx - extend tifm to your liking
we call the extension framework bundled with tifm, `tifmx`, short for `tiny file manager extensions` (creative naming!).

tifmx automatically loads extensions placed in the `extensions` folder, allowing you to drop in extensions to add them in.

it also provides a couple of functions for tifm to adapt its behaviour to your extension.

## guide
here we will create a very simple greeter extension to show you how easy it is to write an extension for tifm.

### init event
we'll start by creating a `greeter.sh` file in the `extensions` folder.<br>
then, we'll listen for the `init` event which is called when the extension is loaded.<br>
events are function definitions of this format: `ext_name.event_name`. tifmx automatically figures out the extension's name by reading the file name, so we will create our init event like this:
```bash
greeter.init() {
    # code here
}
```
then, we will simply print "Hello, $USERNAME!" to the console:
```bash
greeter.init() {
    echo "Hello, $USERNAME!"
}
```
you can test it out by launching tifm now.

### simple command
simple commands are when you press a key and a function gets executed. we'll bind our `h` key to say `Hey all!` when it is pressed.

we'll first start by defining our function. it can be named anything, because we will bind it using its name later; we'll call it `greet_all`:
```sh
greeter.init() {
    echo "Hello, $USERNAME!"
}

# NEW
greet_all() {
    echo "Hey all!"
}
```
awesome. but now, if you reload tifm and press the `h` key, you will get an error. this is because we haven't told tifm to listen to the key.

we will need to use the `tifmx.bind` command to create a binding and link it to our function. you create a binding this way:
```sh
tifmx.bind char func
```
so to bind our new `greet_all` function to the `h` key:
```sh
tifmx.bind h greet_all
```
now your file should look like this:
```sh
greeter.init() {
    echo "Hello, $USERNAME!"
}

greet_all() {
    echo "Hey all!"
}
# NEW
tifmx.bind h greet_all
```
you can now reload tifm and press `h` to see a nice greeting!

### long command
long commands are when you press a key to access a group, and then press another key to run a sub command. examples include `rd` (remove directory) and `nf` (new file).

we'll make two commands: `gu` to greet the user and `gw` to greet the world. we can do this using the `tifmx.add_long` and `tifmx.bind_sub` commands. you create a binding this way:
```sh
tifmx.add_long char1
tifmx.bind_sub char1 char2 func
# you can add infinite subcommands to a group
```
we have already defined a function that greets the user: `greeter.init`, so in our case we can use it. but we'll create a greet world function first:
```sh
greeter.init() {
    echo "Hello, $USERNAME!"
}

greet_all() {
    echo "Hey all!"
}
tifmx.bind h greet_all

# NEW
greet_world() {
    echo "Hello, world!"
}
```

and now we'll create our long command:
```sh
greeter.init() {
    echo "Hello, $USERNAME!"
}

greet_all() {
    echo "Hey all!"
}
tifmx.bind h greet_all

greet_world() {
    echo "Hello, world!"
}
# NEW
tifmx.add_long g
tifmx.bind_sub g u greeter.init
tifmx.bind_sub g w greet_world
```
you can now reload and test your long command out!

## documentation
### events
> **Note:** parameters are passed without name and are accessible via `$1`, `$2` and so on, or `"${@[n]}"` where `n` is a number.
#### `extension.init()`
called when your extension is loaded.

#### `extension.nav(directory)`
called when the user changes directories, at the very end of the `N` command.

parameters:
* `directory`: the directory the user travelled to

#### `extension.edit(file)`
called when the user edits a file, at the very end of the `e` command.

parameters:
* `file`: the file the user edited

#### `extension.copy(from, to)`
called when the user copies a file, at the very end of the `c` command.

parameters:
* `from`: the file the user copied
* `to`: the location the file was copied to

#### `extension.move(from, to)`
called when the user moves a file, at the very end of the `m` command.

parameters:
* `from`: the file the user moved
* `to`: the location the file was moved to

#### `extension.mkdir(dir)` / `extension.mkfile(file)`
called when the user creates a directory/file, at the very end of the `n(d/f)` command.

parameters (`mkdir`):
* `dir`: the directory the user created

parameters (`mkfile`):
* `file`: the file the user created

#### `extension.rmdir(dir)` / `extension.rmfile(file)`
called when the user deletes a directory/file, at the very end of the `r(d/f)` command.

parameters (`rmdir`):
* `dir`: the directory the user deleted

parameters (`rmfile`):
* `file`: the file the user deleted

#### `extension.fperms(item, permissions)`
called when the user changes the permissions of a file, at the very end of the `P` command.

parameters:
* `item`: the file or directory for which the permissions were modified
* `permissions`: the permission arguments given to the file (in chmod format)

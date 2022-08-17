greet_user() {
    echo "Hello $USERNAME!"
}
greet_world() {
    echo "Hello, world!"
}
# tifmx.bind u greet_user
# tifmx.bind w greet_world
tifmx.add_long g
tifmx.bind_sub g u greet_user
tifmx.bind_sub g w greet_world
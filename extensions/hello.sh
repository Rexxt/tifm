greet_user() {
    echo "Hello $USERNAME!"
}
greet_world() {
    echo "Hello, world!"
}
tifmx.bind u greet_user
tifmx.bind w greet_world
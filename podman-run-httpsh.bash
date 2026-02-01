podman build --no-cache --rm --file Containerfile --tag httpsh:demo .
podman run --interactive --tty --publish 1337:1337 httpsh:demo
echo "browse http://localhost:1337/hello.shs?name=Test"

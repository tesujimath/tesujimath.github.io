build:
    rm -rf docs
    zola build -o docs

clean:
    rm -rf docs

localhost := `uname -n`

serve:
    zola serve --base-url http://{{ localhost }} -i 0.0.0.0 --drafts

build-and-serve: build
    static-web-server -d docs -p 1111

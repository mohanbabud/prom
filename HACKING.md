# Contributing

In order to contribute to the Prometheus OCI image do the following:

* Create a new branch.
* Make your changes. Keep your commits logically separated. If it is fixing a bug do not forget to mention it in the commit message.
* Build a new image with your changes. You can use the following command:

```
$ docker build -t ubuntu/prometheus:test .
```

* Test the new image. Run it in some way that exercise your changes, you can also check th README.md file.
* If everything goes well submit a merge proposal.

# Generating the documentation

The documentation (`README.md`) is generated using templates.  In
order to do that, you need to follow some steps.

```
$ pwd
~/work/prometheus
$ cd ..
$ git clone https://github.com/misterw97/RenderDown
$ cd prometheus
$ make all-doc
```

If you already have the `RenderDown` repository cloned somewhere else,
you can tell `make` about it:

```
$ RENDERDOWN=/path/to/renderdown.py make all-doc
```

# Hacking the documentation templates

The repository containing the templates is located at:

https://code.launchpad.net/~canonical-server/ubuntu-docker-images/+git/templates

The specific data for this image's template can be found inside the
`data/` directory.



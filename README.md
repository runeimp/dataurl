dataURL v0.1.0
==============

Simple tool for creating data URLs. Currently, overly simple. I don't recommend it's usage unless it's very limited process is specifically useful to you. It will likely be expanded in the future. But for now I'm just knocking this out to help with another project.

It currently only does `data:text/html,...` with the rest URL encoded.


Usage Examples
--------------

```bash
$ dataurl -h
USAGE: dataurl [-dhv] path/to/file/to/encode [additional/files/to/encode]
```

```bash
$ dataurl -v
dataURL v0.2.0
```

```bash
$ dataurl example.html 
data:text/html,%3C%21DOCTYPE+html%3E...
```


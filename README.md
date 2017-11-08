# pb_cli

`pb_cli` is a no bullshit [pb](https://github.com/ptpb/pb) client.

## installation

An install script is provided for convenience.

```sh
$ curl -Lo- "https://raw.githubusercontent.com/ptpb/pb_cli/master/install.sh" | sudo bash
```

This is just a handful of trivial commands to install `pb` in
`/usr/local/bin`. Feel free to copy-paste instead if you wish.

## dependencies

Dependencies are not considered during installation; you need to make these
exist on your own.

 - `curl`
 - `bash>4.0`
 - [`capture`](https://github.com/buhman/capture) (optional, for screen capture)
 - `maim` (optional, for screenshots)

## usage

Maximum simple:

```sh
$ pb <<< 'hello world'
https://ptpb.pw/DtUR
```

The url is provided on stdout to make `pb` easy to use in pipelines/scripting.

### files

If you don't have the PhD in bash like `#bash` presumes, this might not be
obvious to you:

```sh
pb < /path/to/my/file
```

### private

Create a "private" paste (disables short url).

```sh
pb private
```

### screenshot

```sh
pb png
```

### screen capture

This uses [`capture`](https://github.com/buhman/capture) to create a screen
capture, convert to webm or gif, and upload to pb, all at once.

```sh
pb webm
```

```sh
pb gif
```

## advanced usage

If you have more complex scripting needs (like capturing the uuid for
updates/deletes), you can use the `PB_JSON` environment variables to get the raw
json:

```sh
$ PB_JSON='.' pb <<< test
{
  "status": "already exists",
  "url": "https://ptpb.pw/f5-D",
  "short": "f5-D",
  "size": 5,
  "long": "AE4SQ70ixm52wrqe3cH5E5Tlf5-D",
  "date": "2015-02-28T14:45:23.444000+00:00",
  "digest": "4e1243bd22c66e76c2ba9eddc1f91394e57f9f83"
}
```

So, for example:

```sh
$ eval "$(PB_JSON='.' pb <<< test | jq -r '@sh "url=\(.url) short=\(.short)"')"
$ echo $short
f5-D
$ echo $url
https://ptpb.pw/f5-D
```

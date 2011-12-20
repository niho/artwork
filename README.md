Artwork is a simple Sinatra server for serving resized images on the fly from an origin server. The server should be used behind a caching reverse proxy or CDN like Cloudfront or Varnish to avoid overloading the server with resize requests.

Images are loaded from an origin URL specified by the IMAGE\_ORIGIN\_URL environment variable.

Images delivered from Artwork has default <code>Cache-Control</code> and <code>Expires</code> headers that indicates that the image can be cached for up to 24 hours.

Example
-------

If <code>IMAGE\_ORIGIN\_URL="http://example.s3.amazonaws.com/images/"</code> the following request to Artwork will fetch, resize and transcode the image <code>http://example.s3.amazonaws.com/images/example.png</code> to a small JPG image.

    $ curl http://artwork.example.com/example.png_small.jpg

You can store images without a file ending at your origin server for nicer looking URLs if you want. Artwork will figure out the correct format of the image anyway.

Formats
-------

Artwork can handle pretty much any image formats, but will transcode to JPG by default. The following format strings are currently hard coded and supported out of the box:

* <code>\_small.jpg</code> - 125x125 (JPG)
* <code>\_medium.jpg</code> - 240x240 (JPG)
* <code>\_large.jpg</code> - 500x500 (JPG)
* <code>\_100x150.jpg</code> - Custom size (resize to fit)

More formats will be added.

Author
------

Artwork was created by Niklas Holmgren (niklas@sutajio.se) and released under
the MIT license.

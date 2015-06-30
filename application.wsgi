"""
Small script that processes a file with the jinja template engine, with OS
environment variables available to the template. Mostly intended to allow config
to point to linked containers (e.g. using a redis container as a cache backend).
"""

import os

import jinja2
import TileStache

application = None

infile = 'tilestache.cfg'
outfile = 'tilestache-cfg-rendered.cfg'

try:
    env = jinja2.Environment(loader=jinja2.FileSystemLoader('./'))
    template = env.get_template(infile)
    rendered = template.render(os.environ)
except Exception as e:
    print("Error rendering template: " + e.message)
    with open(infile, 'rb') as f:
        rendered = f.read()

with open(outfile, 'wb') as f:
    f.write(rendered)


application = TileStache.WSGITileServer(outfile)

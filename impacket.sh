#!/bin/sh

name_script=$(basename $0)
example_name=${name_script##impacket-}

exec python3 /tools/impacket/examples/$example_name.py "$@"
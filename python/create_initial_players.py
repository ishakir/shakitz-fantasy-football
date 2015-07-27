# TODO find a nicer way to do this
import argparse
from footbawwlapi import create_all_players

parser = argparse.ArgumentParser()
parser.add_argument('--year', required = True, type = int)
parser.add_argument('--host', required = True, type = str)
parser.add_argument('--port', required = True, type = int)
ns = parser.parse_args()

create_all_players(ns.host, ns.port, ns.year, 'PRE', range(1, 4))
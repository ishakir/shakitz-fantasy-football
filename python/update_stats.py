import argparse
from footbawwlapi import update_stats

parser = argparse.ArgumentParser()
parser.add_argument('--year', required = True, type = int)
parser.add_argument('--kind', required = True, type = str)
parser.add_argument('--game_week', required = True, type = int)
ns = parser.parse_args()

update_stats(ns.year, ns.kind, ns.game_week)
#!/usr/bin/env python3

import argparse
from collections import defaultdict

import pandas as pd
import matplotlib.pyplot as plt


class Board():
    def __init__(self) -> None:
        self._key_values = []
        self._stat_map = defaultdict(lambda: 0)
        self._match_map = defaultdict(lambda: 0)

    def parse_key_file(self, path: str) -> None:
        self._key_file = open(path, 'r')

        for line in self._key_file.readlines():
            for v in line.split():
                self._key_values.append(int(v))

        self._key_file.close()

    def update_stat_map(self, values: list[int]) -> None:
        for key in values:
            if key in self._key_values:
                self._stat_map[key] += 1

    def update_match_map(self, values: list[int]) -> None:
        matched = 0
        for key in values:
            if key in self._key_values:
                matched += 1
        self._match_map[str(matched)] += 1

    def get_key_values(self) -> list[int]:
        return self._key_values

    def get_stat_map(self) -> dict[int, int]:
        return self._stat_map

    def get_match_map(self) -> dict[str, int]:
        return self._match_map


class Stats():
    def __init__(self, match_map: dict[str, int]) -> None:
        fig, ax = plt.subplots()
        items = list(sorted(match_map.items()))
        ax.hist(items)
        fig.savefig('histogram.png')

    # def histogram(self, path: str) -> None:
    #     sns.histplot(self._match_data_frame)
    #     print(self._match_data_frame)
    #     plt.savefig(path)


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('key_file', nargs=1, type=str)
    parser.add_argument('-f', '--input-files', nargs='+')

    args = vars(parser.parse_args())
    print(args)

    board = Board()

    key_file = args['key_file'][0]
    if key_file != None:
        board.parse_key_file(key_file)

        print('key values:')
        __import__('pprint').pprint(board.get_key_values())

    input_files = args['input_files']
    for file in input_files:
        f = open(file, 'r')
        for line in f.readlines():
            values = []
            for v in line.split():
                values.append(int(v))

            board.update_stat_map(values)
            board.update_match_map(values)

    print('stat map:')
    __import__('pprint').pprint(board.get_stat_map())

    print('match map:')
    __import__('pprint').pprint(board.get_match_map())

    stats = Stats(board.get_match_map())
    # stats.histogram('histogram.png')


if __name__ == "__main__":
    main()

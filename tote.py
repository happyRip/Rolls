#!/usr/bin/env python3

import argparse, re
from collections import defaultdict
from typing import List, DefaultDict


TOP_N = 10


class Board():
    def __init__(self) -> None:
        self._key_values = []
        self._stat_map = defaultdict(lambda: 0)
        self._match_map = defaultdict(lambda: 0)

    def _parse_key_file(self, path: str) -> None:
        self._key_file = open(path, 'r')

        for line in self._key_file.readlines():
            for v in line.split():
                self._key_values.append(int(v))

        self._key_file.close()

    def _update_stat_map(self, values: List[int]) -> None:
        for key in values:
            if key in self._key_values:
                self._stat_map[key] += 1

    def _update_match_map(self, values: List[int]) -> None:
        matched = 0
        for key in values:
            if key in self._key_values:
                matched += 1
        self._match_map[str(matched)] += 1

    def get_key_values(self) -> List[int]:
        return self._key_values

    def get_stat_map(self) -> DefaultDict[int, int]:
        return self._stat_map

    def get_match_map(self) -> DefaultDict[str, int]:
        return self._match_map


class Stats():
    def __init__(self, match_map: DefaultDict[str, int], key_values: List[int]) -> None:
        self._total_items_count = sum(match_map.values())
        self._stat_board = self._create_stat_board(match_map)
        self._key_values = key_values

        self._chance = ('43.6     %', '41.3     %', '13.2     %', ' 1.77    %', ' 0.097   %', ' 0.0018   %', ' 0.0000072%')

    def _create_stat_board(self, match_map: DefaultDict) -> DefaultDict:

        def calc_percentage(value: int) -> float:
            total = self._total_items_count
            return 100 * value / total

        precision = [1, 1, 2, 2, 2, 3, 5]
        i = 0
        map = {}
        for k, v in match_map.items():
            map[k] = {'value': v, 'percentage': calc_percentage(v), 'precision': precision[i]}
            i += 1

        return map

    def _human_format(self, num):
        num = float('{:.3g}'.format(num))
        magnitude = 0
        while abs(num) >= 1000:
            magnitude += 1
            num /= 1000.0
        return '{}{}'.format('{:f}'.format(num).rstrip('0').rstrip('.'), ['', 'K', 'M', 'B', 'T'][magnitude])

    def __str__(self) -> str:
        stats = sorted(self._stat_board.items())
        out = ''

        out += f'Zwycięskie cyfry: {self._key_values}\n'

        sum = 0
        for _, v in stats:
            sum += v['value']
        out += f'Całkowita liczba losów: {self._human_format(sum)}\n\n'

        out += 'REZULTAT\t\t\tOCZEKIWANO (lotto)\n'
        chance = self._chance

        max_perc_len = 3 + stats[-1][1]['precision']
        adjust_amount = len(re.sub('[^0-9.]', '', self._human_format(stats[0][1]['value'])))
        for k, v in stats:
            chance = self._chance[int(k)]
            amount = v['value']
            percentage = v['percentage']
            precision = v['precision']
            percentage = f'{round(percentage, precision)}'
            out += f'{k} cyfr: {percentage.rjust(max_perc_len)}% - {self._human_format(amount).rjust(adjust_amount)}\t\t{chance}\n'

        # out += f'\nTOP {self._top_n}:\n'
        # out += f'Zwycięskie cyfry: {self._key_values}\n'

        # for i, v in enumerate(self._top_numbers):
        #     position = f'{i}'
        #     out += f'{position.rjust(len(str(self._top_n+1)))}. '
        #     out += f'{v}'

        return out.strip()

def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('key_file', nargs=1, type=str)
    parser.add_argument('-f', '--input-files', nargs='+')

    args = vars(parser.parse_args())

    board = Board()

    key_file = args['key_file'][0]
    if key_file != None:
        board._parse_key_file(key_file)

    top_numbers = []
    input_files = args['input_files']
    for file in input_files:
        f = open(file, 'r')
        for line in f.readlines():
            values = []
            for v in line.split():
                values.append(int(v))

            board._update_stat_map(values)
            board._update_match_map(values)


    stats = Stats(board.get_match_map(), key_values=board.get_key_values())

    print(stats)


if __name__ == "__main__":
    main()

import argparse
import glob2
import logging
from pylint.lint import Run
import sys

logging.getLogger().setLevel(logging.INFO)

parser = argparse.ArgumentParser(prog="LINT")

parser.add_argument('-p',
                    '--path',
                    help='path to directory you want to run pylint | '
                         'Default: %(default)s | '
                         'Type: %(type)s ',
                    default=glob2.glob('**/*.py'),
                    type=str)

parser.add_argument('-t',
                    '--threshold',
                    help='score threshold to fail pylint runner | '
                         'Default: %(default)s | '
                         'Type: %(type)s ',
                    default=7,
                    type=float)

args = parser.parse_args()

path = []

if str(args.path) == "string":
    path = [str(args.path)]
else:
    path = args.path

threshold = float(args.threshold)

logging.info('PyLint Starting | '
             'Path: %s | '
             'Threshold: %s ', path, threshold)

if len(path) == 0:
    message = ('No .py files for linting.')

    logging.info(message)
    sys.exit(0)

results = Run(path, do_exit=False)

final_score = results.linter.stats['global_note']

if final_score < threshold:
    message = (f'PyLint Failed | '
               'Score: {final_score} | '
               'Threshold: {threshold} ')

    logging.error(message)
    raise Exception(message)

message = (f'PyLint Passed | '
           'Score: {final_score} | '
           'Threshold: {threshold} ')

logging.info(message)

sys.exit(0)

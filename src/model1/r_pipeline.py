import subprocess
import argparse
import os
import sys

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  FLAGS, unparsed = parser.parse_known_args()

  command_line = ' '.join(unparsed)
  print('r_pipeline.py arguments:', unparsed)
  print('r_pipeline.py launching:', command_line)

  subprocess.check_call(command_line, shell=True)
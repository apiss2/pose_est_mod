from testing.remote import conf_pass
import argparse

conf_pass()

parser = argparse.ArgumentParser()
parser.add_argument('--centerz_model_path', dest='centerz_model_path', help='Converted parameters for the centerz model', type=str)
args = parser.parse_args()

print(args.centerz_model_path)
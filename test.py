from testing.remote import conf_pass
import argparse
import tensorflow as tf

from testing.test2 import is_enable

if __name__ == '__main__':
    #conf_pass()

    parser = argparse.ArgumentParser()
    parser.add_argument('--centerz_model_path', dest='centerz_model_path', help='Converted parameters for the centerz model', type=str)
    args = parser.parse_args()

    print(args.centerz_model_path)

    #is_enable()
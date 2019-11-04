import os
import tensorflow as tf

tf.app.flags.DEFINE_boolean("bool", True, "bool value")
tf.app.flags.DEFINE_integer("int", 0, "int value")
tf.app.flags.DEFINE_string("str", "str", "string value")
tf.app.flags.DEFINE_string("test_str", "test", "test string value")

def conf_pass():
    print('getcwd:      ', os.getcwd())
    print('__file__:    ', os.path.dirname(__file__))

def dummy():
  print("dummy")

if __name__ == '__main__':
    print("miss")
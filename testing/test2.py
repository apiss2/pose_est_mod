import tensorflow as tf

from .remote import dummy

def is_enable():
    flags = tf.app.flags.FLAGS
    print(flags.bool, flags.int, flags.str, flags.test_str)

if __name__ == '__main__':
    tf.app.run()
# https://github.com/badoo/pinba2
# https://github.com/tony2001/pinba_extension
&& PHP_PINBA_VERSION=RELEASE_1_1_2 \
&& aptitude install --without-recommends -y --add-user-tag forbuildonly git \
&& PINBA_DIR=/soft/pinba/ \
&& git clone --depth 1 --branch $PHP_PINBA_VERSION https://github.com/tony2001/pinba_extension $PINBA_DIR \
&& cd $PINBA_DIR \
&& phpize \
&& ./configure \
&& make -j64 \
&& make install -j64 \
&& echo "extension=pinba.so" > /usr/local/etc/php/conf.d/ext-pinba.ini \
&& rm -rf $PINBA_DIR \
&& cd / \
#
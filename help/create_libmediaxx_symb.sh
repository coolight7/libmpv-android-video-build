readelf -W --symbols libmediaxx.so | grep ' GLOBAL ' | grep -v ' UND ' | awk '{print $8}' | sort > libmediaxx_def_syms.txt

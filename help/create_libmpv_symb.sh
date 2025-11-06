readelf -W --symbols libmpv.so | grep ' GLOBAL ' | grep -v ' UND ' | awk '{print $8}' | sort > libmpv_def_syms.txt

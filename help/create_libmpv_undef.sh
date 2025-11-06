readelf -W --symbols libmpv.so | grep ' UND ' | awk '{print $8}' | sort > libmpv_undef_syms.txt

./create_libmediaxx_symb.sh
./create_libmpv_undef.sh
./create_libmpv_symb.sh
./create_libc++_symb.sh

comm -12 libmediaxx_def_syms.txt libmpv_undef_syms.txt > comm_syms.txt
comm -12 libc++_syms.txt libmpv_undef_syms.txt > comm_cxx_syms.txt
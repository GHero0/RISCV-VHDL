/**
 * 
 * Bertrand LE GAL (bertrand.le-gal@irisa.fr)
 * 
*/
#include <libuc.h>
//#include <stdint.h>

#define uint32_t unsigned int
#define uint8_t  unsigned char

/*
inline long time() {
   int cycles;
   asm volatile ("rdcycle %0" : "=r"(cycles));
   return cycles;
}
*/

inline long insn() {
   int insns;
   asm volatile ("rdinstret %0" : "=r"(insns));
   return insns;
}

uint32_t __attribute__ ((noinline)) reverse_uint32(uint32_t Input) {
    uint32_t Output = 0;

    while(Input) {    // non-zero?
        Output <<= 1;
        Output |= Input & 1;
        Input >>= 1;
    }
    return Output;
}

uint32_t __attribute__ ((noinline)) reverse_uint32_v2(uint32_t x)
{
    x = ((x & 0x55555555) << 1) | ((x & 0xAAAAAAAA) >> 1); // Swap _<>_
    x = ((x & 0x33333333) << 2) | ((x & 0xCCCCCCCC) >> 2); // Swap __<>__
    x = ((x & 0x0F0F0F0F) << 4) | ((x & 0xF0F0F0F0) >> 4); // Swap ____<>____
    x = ((x & 0x00FF00FF) << 8) | ((x & 0xFF00FF00) >> 8); // Swap ...
    x = ((x & 0x0000FFFF) << 16) | ((x & 0xFFFF0000) >> 16); // Swap ...
    return x;
}

static const unsigned char table[] =
{
    0x00, 0x80, 0x40, 0xc0, 0x20, 0xa0, 0x60, 0xe0,
    0x10, 0x90, 0x50, 0xd0, 0x30, 0xb0, 0x70, 0xf0,
    0x08, 0x88, 0x48, 0xc8, 0x28, 0xa8, 0x68, 0xe8,
    0x18, 0x98, 0x58, 0xd8, 0x38, 0xb8, 0x78, 0xf8,
    0x04, 0x84, 0x44, 0xc4, 0x24, 0xa4, 0x64, 0xe4,
    0x14, 0x94, 0x54, 0xd4, 0x34, 0xb4, 0x74, 0xf4,
    0x0c, 0x8c, 0x4c, 0xcc, 0x2c, 0xac, 0x6c, 0xec,
    0x1c, 0x9c, 0x5c, 0xdc, 0x3c, 0xbc, 0x7c, 0xfc,
    0x02, 0x82, 0x42, 0xc2, 0x22, 0xa2, 0x62, 0xe2,
    0x12, 0x92, 0x52, 0xd2, 0x32, 0xb2, 0x72, 0xf2,
    0x0a, 0x8a, 0x4a, 0xca, 0x2a, 0xaa, 0x6a, 0xea,
    0x1a, 0x9a, 0x5a, 0xda, 0x3a, 0xba, 0x7a, 0xfa,
    0x06, 0x86, 0x46, 0xc6, 0x26, 0xa6, 0x66, 0xe6,
    0x16, 0x96, 0x56, 0xd6, 0x36, 0xb6, 0x76, 0xf6,
    0x0e, 0x8e, 0x4e, 0xce, 0x2e, 0xae, 0x6e, 0xee,
    0x1e, 0x9e, 0x5e, 0xde, 0x3e, 0xbe, 0x7e, 0xfe,
    0x01, 0x81, 0x41, 0xc1, 0x21, 0xa1, 0x61, 0xe1,
    0x11, 0x91, 0x51, 0xd1, 0x31, 0xb1, 0x71, 0xf1,
    0x09, 0x89, 0x49, 0xc9, 0x29, 0xa9, 0x69, 0xe9,
    0x19, 0x99, 0x59, 0xd9, 0x39, 0xb9, 0x79, 0xf9,
    0x05, 0x85, 0x45, 0xc5, 0x25, 0xa5, 0x65, 0xe5,
    0x15, 0x95, 0x55, 0xd5, 0x35, 0xb5, 0x75, 0xf5,
    0x0d, 0x8d, 0x4d, 0xcd, 0x2d, 0xad, 0x6d, 0xed,
    0x1d, 0x9d, 0x5d, 0xdd, 0x3d, 0xbd, 0x7d, 0xfd,
    0x03, 0x83, 0x43, 0xc3, 0x23, 0xa3, 0x63, 0xe3,
    0x13, 0x93, 0x53, 0xd3, 0x33, 0xb3, 0x73, 0xf3,
    0x0b, 0x8b, 0x4b, 0xcb, 0x2b, 0xab, 0x6b, 0xeb,
    0x1b, 0x9b, 0x5b, 0xdb, 0x3b, 0xbb, 0x7b, 0xfb,
    0x07, 0x87, 0x47, 0xc7, 0x27, 0xa7, 0x67, 0xe7,
    0x17, 0x97, 0x57, 0xd7, 0x37, 0xb7, 0x77, 0xf7,
    0x0f, 0x8f, 0x4f, 0xcf, 0x2f, 0xaf, 0x6f, 0xef,
    0x1f, 0x9f, 0x5f, 0xdf, 0x3f, 0xbf, 0x7f, 0xff
};

uint32_t __attribute__ ((noinline)) reverse_uint32_v3(uint32_t x)
{
    uint8_t* ptr = (uint8_t*)&x;
    uint32_t a = table[ ptr[0] ];
    uint32_t b = table[ ptr[1] ];
    uint32_t c = table[ ptr[2] ];
    uint32_t d = table[ ptr[3] ];
    ptr[0] = d;
    ptr[1] = c;
    ptr[2] = b;
    ptr[3] = a;
    return x;
}

inline int custom_0(const int a, const int b) {
    int res = 0;
    //R-type instruction, funct7=0, funct3=0    , opcode=0x0b
    //asm(".insn r 0x0b, 0, 0, %[result], %[val_a], %[val_b]"
    //    :[result] "=r" (res)
    //    :[val_a] "r" (a), [val_b] "r" (b));
    asm(".insn r 0x33, 0, 0, %[result], %[val_a], %[val_b]"
        :[result] "=r" (res)
        :[val_a] "r" (a), [val_b] "r" (b));

    return res;
}


#define custom_instr

//
//
//
#ifdef custom_instr
inline int reverse_hardware(const int a)
{
    int res;
    asm(".insn r 0x2F, 0, 0, %[result], %[val_a], %[val_b]" //  0010 1111 => instr atomics
        :[result] "=r" (res)
        :[val_a] "r" (a),
         [val_b] "r" (a));
    return res;
}
#endif
//
//
//

int main()
{
    const int t_value = 0x89ABCDEF;
//  const int t_value = custom_0( custom_0( 0x89ABCDEF, 0 ), 1);

    print_string("Bit reverse application...\n");

    int insn_i  = insn();
    int r_value = reverse_uint32( t_value );
    int insn_o  = insn();
    print_string("> resultat : "); print_hex( r_value ); printf("\n");
    print_string("  - insn   : "); print_dec( insn_o - insn_i ); printf("\n");

    insn_i  = insn();
    r_value = reverse_uint32_v2( t_value );
    insn_o  = insn();
    print_string("> resultat : "); print_hex( r_value ); printf("\n");
    print_string("  - insn   : "); print_dec( insn_o - insn_i ); printf("\n");

    insn_i  = insn();
    r_value = reverse_uint32_v3( t_value );
    insn_o  = insn();
    print_string("> resultat : "); print_hex( r_value ); printf("\n");
    print_string("  - insn   : "); print_dec( insn_o - insn_i ); printf("\n");

#ifdef custom_instr
    insn_i  = insn();
    r_value = reverse_hardware( t_value );
    insn_o  = insn();
    print_string("> resultat : "); print_hex( r_value ); printf("\n");
    print_string("  - insn   : "); print_dec( insn_o - insn_i ); printf("\n");
#endif
    return 0;
}

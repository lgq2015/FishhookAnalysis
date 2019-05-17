
```
/*
* The mach header appears at the very beginning of the object file; it
* is the same for both 32-bit and 64-bit architectures.
*/
struct mach_header {
    uint32_t    magic;              /* mach magic number identifier */      /*魔数*/
    cpu_type_t    cputype;          /* cpu specifier */                     /*CPU类型*/
    cpu_subtype_t    cpusubtype;    /* machine specifier */                 /*机器类型*/
    uint32_t    filetype;           /* type of file */                      /*文件类型*/
    uint32_t    ncmds;              /* number of load commands */           /*加载指令数*/
    uint32_t    sizeofcmds;         /* the size of all the load commands */ /*所有指令的大小*/
    uint32_t    flags;              /* flags */                             /*标志位*/
};

struct mach_header_64 {
    uint32_t    magic;              /* mach magic number identifier */
    cpu_type_t    cputype;          /* cpu specifier */
    cpu_subtype_t    cpusubtype;    /* machine specifier */
    uint32_t    filetype;           /* type of file */
    uint32_t    ncmds;              /* number of load commands */
    uint32_t    sizeofcmds;         /* the size of all the load commands */
    uint32_t    flags;              /* flags */
    uint32_t    reserved;           /* reserved */
};

```

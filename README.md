
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


```
struct load_command {
    unsigned long cmd;              /* type of load command */             /*加载指令类型*/  
    unsigned long cmdsize;          /* total size of command in bytes */   /*加载指令大小*/
};
```
```
struct segment_command {            /* for 32-bit architectures */
    unsigned long    cmd;           /* LC_SEGMENT */
    unsigned long    cmdsize;       /* includes sizeof section structs */
    char        segname[16];        /* segment name */                    /*段名 __TEXT, __DATA, __LINKEDIT*/
    unsigned long    vmaddr;        /* memory address of this segment */  /*段虚拟地址*/
    unsigned long    vmsize;        /* memory size of this segment */     /*段大小*/
    unsigned long    fileoff;       /* file offset of this segment */     /**/
    unsigned long    filesize;      /* amount to map from the file */
    vm_prot_t    maxprot;           /* maximum VM protection */
    vm_prot_t    initprot;          /* initial VM protection */
    unsigned long    nsects;        /* number of sections in segment */   /*段的节数*/
    unsigned long    flags;         /* flags */                           /*段的标识位*/       
};
```

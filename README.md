
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

struct segment_command_64 {         /* for 64-bit architectures */
    uint32_t    cmd;                /* LC_SEGMENT_64 */
    uint32_t    cmdsize;            /* includes sizeof section_64 structs */
    char        segname[16];        /* segment name */
    uint64_t    vmaddr;             /* memory address of this segment */
    uint64_t    vmsize;             /* memory size of this segment */
    uint64_t    fileoff;            /* file offset of this segment */
    uint64_t    filesize;           /* amount to map from the file */
    vm_prot_t    maxprot;           /* maximum VM protection */
    vm_prot_t    initprot;          /* initial VM protection */
    uint32_t    nsects;             /* number of sections in segment */
    uint32_t    flags;              /* flags */
};
```
```
struct section {                    /* for 32-bit architectures */
    char        sectname[16];       /* name of this section */               /*节的名字*/
    char        segname[16];        /* segment this section goes in */       /*节所在段名*/
    unsigned long    addr;          /* memory address of this section */     /*节所在地址*/
    unsigned long    size;          /* size in bytes of this section */      /*节的大小*/
    unsigned long    offset;        /* file offset of this section */        /*节的文件偏移*/
    unsigned long    align;         /* section alignment (power of 2) */     /*节的对齐*/
    unsigned long    reloff;        /* file offset of relocation entries */  //
    unsigned long    nreloc;        /* number of relocation entries */       //
    unsigned long    flags;         /* flags (section type and attributes)*/ //
    unsigned long    reserved1;     /* reserved */
    unsigned long    reserved2;     /* reserved */
};

struct section_64 {                 /* for 64-bit architectures */
    char        sectname[16];       /* name of this section */
    char        segname[16];        /* segment this section goes in */
    uint64_t    addr;               /* memory address of this section */
    uint64_t    size;               /* size in bytes of this section */
    uint32_t    offset;             /* file offset of this section */
    uint32_t    align;              /* section alignment (power of 2) */
    uint32_t    reloff;             /* file offset of relocation entries */
    uint32_t    nreloc;             /* number of relocation entries */
    uint32_t    flags;              /* flags (section type and attributes)*/
    uint32_t    reserved1;          /* reserved (for offset or index) */
    uint32_t    reserved2;          /* reserved (for count or sizeof) */
    uint32_t    reserved3;          /* reserved */
};
```

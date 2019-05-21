# fishhook 分析 

Mach-O不像XML / YAML / JSON 这样的特殊格式，它只是一个以有意义的数据块分组的二进制字节流。这些块包含元信息，例如：字节顺序，cpu类型，块的大小等。
    
典型的Mach-O文件由三个段组成：
1. `标题`: 包含有关二进制文件的一般信息：字节顺序（魔数），cpu类型，加载命令数量等。
2. `加载命令`: 它是一种目录，描述了段的位置，符号表，动态符号表等。每个加载命令都包含一个元信息，如命令类型，名称，二进制位置等等。
3. `数据`: 通常是目标文件的最大部分。 它包含代码和数据，例如符号表，动态符号表等。
OS X上有两种类型的目标文件：Mach-O文件和通用二进制文件，也就是所谓的Fat文件。 它们之间的区别：Mach-O文件包含一个体系结构（i386，x86_64，arm64等）的目标代码，而Fat二进制文件可能包含多个目标文件，因此包含不同体系结构的对象代码（i386和x86_64，arm和arm64， 等等。）
<p align="center"><img src="FishhookAnalysis/images/macho_header.png" alt="drawing" width="200" /></p>
我们可以从这一张图来简单的理解一下。
<p align="center"><img src="FishhookAnalysis/images/macho_memory_layout.png" alt="drawing" width="500"/></p>



```
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
<p align="center"><img src="FishhookAnalysis/images/header.png" alt="drawing" /></p>

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

<p align="center"><img src="FishhookAnalysis/images/load_command.png" alt="drawing" /></p>
<p align="center"><img src="FishhookAnalysis/images/load_section.png" alt="drawing" /></p>

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

<p align="center"><img src="FishhookAnalysis/images/section.png" alt="drawing" /></p>


## 那么我们如何在 Mach-O 文件里找到系统的函数地址呢？或者说 Mach-O 文件是如何链接外部函数的呢？

我们程序的底层都是汇编，汇编代码都是写死的内存地址。我们该怎么找呢？而且系统的动态库在内存里面的地址是不固定的，每次启动程序的时候地址都是随机的。 苹果为了能在 Mach-O 文件中访问外部函数，采用了一个技术，叫做PIC（位置代码独立）技术。当你的应用程序想要调用 Mach-O 文件外部的函数的时候，或者说如果 Mach-O 内部需要调用系统的库函数时，Mach-O 文件会：

先在 Mach-O 文件的 _DATA 段中建立一个指针（8字节的数据，放的全是0），这个指针变量指向外部函数。
DYLD 会动态的进行绑定！将 Mach-O 中的 _DATA 段中的指针，指向外部函数。

所以说，C的底层也有动态的表现。C在内部函数的时候是静态的，在编译后，函数的内存地址就确定了。但是，外部的函数是不能确定的，也就是说C的底层也有动态的。fishhook 之所以能 hook C函数，是利用了 Mach-O 文件的 PIC 技术特点。也就造就了静态语言C也有动态的部分，通过 DYLD 进行动态绑定的时候做了手脚。
我们经常说符号，其实 _DATA 段中建立的指针就是符号。fishhook的原理其实就是，将指向`系统方法`（即外部函数）的符号`重新进行绑定指向内部的函数`。这样就把系统方法与自己定义的方法进行了交换。这也就是为什么C的内部函数修改不了，自定义的函数修改不了，只能修改 Mach-O 外部的函数。

`注： 对于非懒加载符号表，DYLD会立刻马上去链接动态库
    对于懒加载符号表，DYLD会在第一次执行代码的时候去动态的链接动态库`
   


<p align="center"><img src="FishhookAnalysis/images/fishhook.png" alt="drawing" width="500"/></p>

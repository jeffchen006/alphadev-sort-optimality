# n=3 R=7 iset=I1 model=mem source=repo:Sort3AlphaDev
# L=17 (every instruction counts). regs: S0=eax S1=ecx S2=edx S3=r8d
mov S0, P1       # mov 0x4(%0), %%eax
mov S1, P2       # mov 0x8(%0), %%ecx
cmp S1, S0       # cmp %%eax, %%ecx
mov S2, S0       # mov %%eax, %%edx
cmovl S2, S1     # cmovl %%ecx, %%edx
mov S3, P0       # mov (%0), %%r8d
cmovg S0, S1     # cmovg %%ecx, %%eax
cmp S0, S3       # cmp %%r8d, %%eax
mov S1, S3       # mov %%r8d, %%ecx
cmovl S1, S0     # cmovl %%eax, %%ecx
cmovle S0, S3    # cmovle %%r8d, %%eax
mov P2, S0       # mov %%eax, 0x8(%0)
cmp S2, S1       # cmp %%ecx, %%edx
cmovle S3, S2    # cmovle %%edx, %%r8d
mov P0, S3       # mov %%r8d, (%0)
cmovg S1, S2     # cmovg %%edx, %%ecx
mov P1, S1       # mov %%ecx, 0x4(%0)

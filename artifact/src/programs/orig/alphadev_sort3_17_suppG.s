# n=3 R=7 iset=I1 model=mem source=suppG:Sort3_17
# L=17 (every instruction counts). regs: S0=r8d S1=edx S2=ecx S3=eax
mov S0, P1       # mov 0x4(%0), %%r8d
mov S1, P2       # mov 0x8(%0), %%edx
mov S2, P2       # mov 0x8(%0), %%ecx
cmp S2, S0       # cmp %%r8d, %%ecx
cmovge S1, S0    # cmovge %%r8d, %%edx
cmovl S2, S0     # cmovl %%r8d, %%ecx
mov S0, S2       # mov %%ecx, %%r8d
mov S3, P0       # mov (%0), %%eax
cmp S0, S3       # cmp %%eax, %%r8d
cmovge S0, S3    # cmovge %%eax, %%r8d
cmovl S2, S3     # cmovl %%eax, %%ecx
mov P2, S2       # mov %%ecx, 0x8(%0)
cmp S3, S1       # cmp %%edx, %%eax
cmovle S0, S1    # cmovle %%edx, %%r8d
cmovg S3, S1     # cmovg %%edx, %%eax
mov P1, S0       # mov %%r8d, 0x4(%0)
mov P0, S3       # mov %%eax, (%0)

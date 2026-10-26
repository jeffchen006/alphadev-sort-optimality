# n=3 R=7 iset=I1 model=mem source=suppG:Sort3_18
# L=18 (every instruction counts). regs: S0=r8d S1=edx S2=ecx S3=eax
mov S0, P0       # mov (%0), %%r8d
mov S1, P2       # mov 0x8(%0), %%edx
mov S2, S1       # mov %%edx, %%ecx
mov S3, P1       # mov 0x4(%0), %%eax
cmp S1, S3       # cmp %%eax, %%edx
cmovg S1, S3     # cmovg %%eax, %%edx
cmovl S2, S3     # cmovl %%eax, %%ecx
cmp S2, S0       # cmp %%r8d, %%ecx
cmovle S0, S2    # cmovle %%ecx, %%r8d
mov S3, P0       # mov (%0), %%eax
cmovle S2, S3    # cmovle %%eax, %%ecx
cmp S1, S3       # cmp %%eax, %%edx
cmovle S3, S1    # cmovle %%edx, %%eax
mov P2, S2       # mov %%ecx, 0x8(%0)
cmovle S1, S0    # cmovle %%r8d, %%edx
mov P1, S1       # mov %%edx, 0x4(%0)
mov S2, S1       # mov %%edx, %%ecx
mov P0, S3       # mov %%eax, (%0)

# n=3 R=7 iset=I1 model=mem source=suppG:Sort3_19
# L=19 (every instruction counts). regs: S0=ecx S1=r8d S2=edx S3=eax
mov S0, P2       # mov 0x8(%0), %%ecx
mov S1, P0       # mov (%0), %%r8d
mov S2, P1       # mov 0x4(%0), %%edx
cmp S0, S2       # cmp %%edx, %%ecx
cmovle S2, S0    # cmovle %%ecx, %%edx
mov S3, P2       # mov 0x8(%0), %%eax
mov S3, P1       # mov 0x4(%0), %%eax
cmovl S0, S3     # cmovl %%eax, %%ecx
cmp S0, S1       # cmp %%r8d, %%ecx
cmovle S1, S0    # cmovle %%ecx, %%r8d
mov S3, P0       # mov (%0), %%eax
cmovle S0, S3    # cmovle %%eax, %%ecx
cmp S2, S3       # cmp %%eax, %%edx
cmovle S3, S2    # cmovle %%edx, %%eax
cmovge S1, S2    # cmovge %%edx, %%r8d
mov P0, S3       # mov %%eax, (%0)
mov P1, S1       # mov %%r8d, 0x4(%0)
mov S2, P1       # mov 0x4(%0), %%edx
mov P2, S0       # mov %%ecx, 0x8(%0)

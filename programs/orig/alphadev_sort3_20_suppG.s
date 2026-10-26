# n=3 R=7 iset=I1 model=mem source=suppG:Sort3_20
# L=20 (every instruction counts). regs: S0=eax S1=ecx S2=edx S3=r8d
mov S0, P0       # mov (%0), %%eax
mov S0, P1       # mov 0x4(%0), %%eax
mov S1, P2       # mov 0x8(%0), %%ecx
mov S2, S0       # mov %%eax, %%edx
cmp S1, S0       # cmp %%eax, %%ecx
cmovl S2, S1     # cmovl %%ecx, %%edx
cmovl S1, S0     # cmovl %%eax, %%ecx
mov S0, P0       # mov (%0), %%eax
mov S3, S0       # mov %%eax, %%r8d
cmp S1, S3       # cmp %%r8d, %%ecx
cmovle S3, S1    # cmovle %%ecx, %%r8d
cmovl S1, S0     # cmovl %%eax, %%ecx
cmp S0, S2       # cmp %%edx, %%eax
cmp S2, S0       # cmp %%eax, %%edx
cmovl S0, S2     # cmovl %%edx, %%eax
cmovg S3, S2     # cmovg %%edx, %%r8d
cmp S0, S1       # cmp %%ecx, %%eax
mov P2, S1       # mov %%ecx, 0x8(%0)
mov P1, S3       # mov %%r8d, 0x4(%0)
mov P0, S0       # mov %%eax, (%0)

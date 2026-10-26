# n=3 R=7 iset=I1 model=mem source=Justine Tunney, "Understanding DeepMind's Sorting Algorithm", justine.lol/sorting, 2023-06-12 (via web.archive.org), x86-64 sort3 with the "wrekt by AlphaDev" mov removed; 64-bit regs in original; L=17
mov S0, P0       # mov (%rdi),%rcx
mov S1, P1       # mov 8(%rdi),%rdx
mov S2, P2       # mov 16(%rdi),%rsi
mov S3, S1       # mov %rdx,%rax
cmp S2, S1       # cmp %rdx,%rsi
cmovl S3, S2     # cmovl %rsi,%rax
cmovl S2, S1     # cmovl %rdx,%rsi
mov S1, S0       # mov %rcx,%rdx
cmp S2, S0       # cmp %rcx,%rsi
cmovl S1, S2     # cmovl %rsi,%rdx
cmovl S2, S0     # cmovl %rcx,%rsi
cmp S1, S3       # cmp %rax,%rdx
cmovge S0, S3    # cmovge %rax,%rcx
cmovl S1, S3     # cmovl %rax,%rdx
mov P0, S0       # mov %rcx,(%rdi)
mov P1, S1       # mov %rdx,8(%rdi)
mov P2, S2       # mov %rsi,16(%rdi)

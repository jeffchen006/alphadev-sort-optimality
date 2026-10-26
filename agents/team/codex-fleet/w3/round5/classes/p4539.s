# n=5 model=out iset=I1 prefix14_class=4539
mov S2, P1
cmp P3, P0
mov S1, P3
cmovle S1, P0
cmovge P3, P0
cmp S2, P2
cmovge S2, P2
cmovl P1, P2
cmp S1, P1
cmovge S0, S1
cmovg S1, P1
cmovge P1, S0
cmp P3, S2
mov P0, P3

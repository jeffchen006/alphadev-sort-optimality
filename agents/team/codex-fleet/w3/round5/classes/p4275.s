# n=5 model=out iset=I1 prefix14_class=4275
mov S1, P3
cmp P3, P0
cmovge P3, P0
cmovle S1, P0
mov S2, P1
cmp P1, P2
cmovg S2, P2
cmovge P2, P1
cmp S2, P3
cmovl P0, P3
cmovl P3, S2
cmovl S2, P0
cmp P2, S1
mov P3, S1

# n=5 model=out iset=I1 prefix14_class=61
mov S1, P1
cmp P2, S1
cmovl S1, P2
mov S2, P3
cmovl P2, P1
cmp P0, S2
mov P1, S1
cmovle S2, P0
cmovge P3, P0
cmp S1, S2
cmovge P1, S2
cmovg S2, S1
mov P1, P2
cmp P1, P3

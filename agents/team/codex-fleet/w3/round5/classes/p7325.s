# n=5 model=out iset=I1 prefix14_class=7325
mov S1, P3
cmp P2, P3
cmovl S1, P2
cmovge P3, P2
mov S2, P0
cmp P1, P0
mov P2, S1
cmovle S2, P1
cmovl P1, P0
cmp S2, P2
cmovg P2, S2
cmovl S1, S2
cmp P1, P3
cmovg S1, P1

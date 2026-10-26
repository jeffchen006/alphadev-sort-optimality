# n=5 model=out iset=I1 prefix14_class=12476
cmp P2, P0
cmovge S0, P0
mov S2, P3
cmovg P0, P2
cmovge P2, S0
cmp P1, P3
cmovg S2, P1
cmovg P1, P3
mov S1, P1
cmovg P3, S2
cmp P1, P2
cmovl P1, P2
cmovle P2, S1
mov P2, P1

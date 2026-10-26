# n=5 model=out iset=I1 prefix14_class=901
cmp P2, P0
mov S0, P2
cmovle S0, P0
cmovl P0, P2
cmp P1, P3
mov P2, S0
cmovge S1, P1
cmovg P1, P3
mov S2, P0
cmovg P3, S1
cmp P3, P2
cmovl S0, P3
cmovge P2, P3
cmp S2, P1

# n=5 model=out iset=I1 prefix14_class=9453
cmp P3, P0
cmovl S0, P3
cmovle P3, P0
cmovl P0, S0
mov S2, P1
cmp S2, P2
cmovl S2, P2
mov S1, P3
cmovg P1, P2
cmp P1, P0
cmovle P2, P1
cmovl P1, P0
cmovg P2, P0
cmovge P0, P1

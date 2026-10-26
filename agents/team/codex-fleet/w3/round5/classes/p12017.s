# n=5 model=out iset=I1 prefix14_class=12017
cmp P3, P1
cmovge S1, P3
mov S0, P0
cmovg P3, P1
cmovg P1, S1
cmp P0, P2
mov S2, P1
cmovl S0, P2
cmovge P0, P2
cmp P3, P0
mov P2, P3
cmovle P3, P0
cmovl P0, P2
cmovle P2, P3

# n=5 model=out iset=I1 prefix14_class=9891
cmp P1, P0
cmovge S0, P1
cmovg P1, P0
mov S2, P3
cmovge P0, S0
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
mov S1, P0
cmp S2, P0
cmovl P0, S2
cmovl S2, S1
mov S2, P0
mov P3, P2

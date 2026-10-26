# n=5 model=out iset=I1 prefix14_class=7734
cmp P0, P3
cmovle S0, P3
mov S2, P2
cmovge S0, P0
cmovge P0, P3
mov S1, S0
cmp P2, P1
cmovl S2, P1
cmovg P2, P1
cmp P0, P2
cmovle P3, P0
cmovl P0, P2
cmovle P2, P3
cmp S1, S2

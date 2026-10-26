# n=5 model=out iset=I1 prefix14_class=1963
cmp P2, P1
cmovge S1, P1
mov S0, P0
cmovle S1, P2
cmovl P2, P1
cmp P3, P0
cmovg P0, P3
cmovl S0, P3
mov P3, P0
cmp P2, P3
cmovge P0, P2
cmovle P3, P2
cmp S1, S0
cmovle P2, S1

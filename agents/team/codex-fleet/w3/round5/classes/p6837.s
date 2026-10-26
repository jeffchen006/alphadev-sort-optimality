# n=5 model=out iset=I1 prefix14_class=6837
mov S0, P0
cmp P3, P2
cmovl S1, P2
cmovl P2, P3
cmovl P3, S1
cmp P1, P0
cmovle S0, P1
mov S2, P2
cmovge P0, P1
cmp P3, P0
cmovle P1, P0
cmovle P0, P3
cmovg P1, P3
cmp S0, P2

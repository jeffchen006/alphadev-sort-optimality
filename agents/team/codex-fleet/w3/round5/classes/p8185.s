# n=5 model=out iset=I1 prefix14_class=8185
cmp P3, P2
cmovle S2, P2
cmovl P2, P3
mov S1, P1
cmovle P3, S2
cmp P1, P0
cmovl S1, P0
cmovge P1, P0
cmp P2, P1
mov S0, P3
cmovg P0, P2
cmovge P2, P1
cmovg P1, P0
cmp S0, S1

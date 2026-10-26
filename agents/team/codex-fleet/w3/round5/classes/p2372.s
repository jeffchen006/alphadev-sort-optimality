# n=5 model=out iset=I1 prefix14_class=2372
mov S0, P0
cmp P1, P2
mov S1, P2
cmovle S1, P1
cmovg P2, P1
cmp P3, S0
cmovl S0, P3
mov S2, P2
cmovge P0, P3
cmp S2, P0
cmovl P2, P0
cmovle P0, S2
cmp S1, S0
cmovg P3, S0

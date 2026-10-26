# n=5 model=out iset=I1 prefix14_class=7671
mov S0, P2
cmp P2, P1
cmovge S0, P1
cmovle P2, P1
cmp P0, P3
cmovge P1, P3
cmovg P3, P0
cmovg P0, P1
cmp S0, P0
mov S1, S0
cmovle S0, P0
cmovl P0, S1
mov S2, P3
cmp S2, P2

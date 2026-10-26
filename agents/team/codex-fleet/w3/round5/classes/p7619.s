# n=5 model=out iset=I1 prefix14_class=7619
cmp P2, P0
cmovl S2, P2
cmovle P2, P0
cmovl P0, S2
cmp P1, P3
cmovge S1, P3
cmovge P3, P1
mov S0, P0
cmovle S1, P1
cmp S0, S1
cmovg P0, S1
mov P0, P3
cmovge S1, S0
cmp P2, P0

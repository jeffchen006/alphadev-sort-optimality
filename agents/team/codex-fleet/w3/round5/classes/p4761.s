# n=5 model=out iset=I1 prefix14_class=4761
cmp P2, P3
cmovle S2, P2
cmovl P2, P3
mov S0, P0
cmovle P3, S2
cmp P0, P1
cmovle S0, P1
cmovge P0, P1
mov S1, P3
cmp P0, S1
cmovge P3, P0
cmovg P0, S1
cmp S0, P2
cmovge S2, P2

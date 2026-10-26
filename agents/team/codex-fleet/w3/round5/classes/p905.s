# n=5 model=out iset=I1 prefix14_class=905
mov S0, P2
mov S1, P3
cmp S1, P1
cmovle P3, P1
cmovl P1, S1
cmovle S1, P3
cmp S0, P0
cmovge S0, P0
cmovg P0, P2
cmp P0, S1
cmovg P3, P0
cmovle S1, P0
mov S2, P1
cmovge P0, S1

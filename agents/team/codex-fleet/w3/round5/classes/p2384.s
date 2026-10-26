# n=5 model=out iset=I1 prefix14_class=2384
mov S1, P3
mov S2, P2
cmp S1, P0
cmovge S1, P0
cmovg P0, P3
cmp P2, P1
mov S0, P0
cmovle S2, P1
cmovle P1, P2
cmp S0, S2
cmovl P0, S2
cmovle S2, S0
cmp S1, P1
cmovge P3, S1

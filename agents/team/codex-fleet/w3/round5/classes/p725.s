# n=5 model=out iset=I1 prefix14_class=725
cmp P0, P2
mov S2, P1
mov S0, P0
cmovge S0, P2
cmovle P0, P2
cmp S2, P3
cmovle S2, P3
cmovge P1, P3
cmp P0, S2
cmovle S1, P0
cmovl P0, S2
cmovle S2, S1
cmp S0, P1
mov P3, S2

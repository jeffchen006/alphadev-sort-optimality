# n=5 model=out iset=I1 prefix14_class=269
mov S0, P2
cmp P0, P1
mov S2, P0
cmovge P0, P1
cmovge P1, S2
cmp P3, P2
cmovle S0, P3
cmovg P2, P3
cmp S0, P0
cmovle S1, P0
cmovl P0, S0
cmovle S0, S1
cmp P1, P2
cmovle P3, P2

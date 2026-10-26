# n=5 model=out iset=I1 prefix14_class=14123
cmp P1, P0
cmovge S2, P1
cmovg P1, P0
cmovge P0, S2
mov S1, P3
cmp P2, S1
cmovl P3, P2
cmovg S1, P2
cmp S1, P0
cmovle P2, S1
mov S0, P3
cmovle S1, P0
cmovl P0, P2
cmp P1, S0

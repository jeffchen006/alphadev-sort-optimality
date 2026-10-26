# n=5 model=out iset=I1 prefix14_class=3253
cmp P1, P0
cmovle S0, P0
cmovge S0, P1
cmovl P0, P1
mov S2, P2
cmovg P1, P0
cmp P3, P2
cmovge S2, P3
cmovge P3, P2
cmp P1, P3
cmovge P1, P3
cmovle P0, P3
cmp S2, S0
cmovge P1, S0

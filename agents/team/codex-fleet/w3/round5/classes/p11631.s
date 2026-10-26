# n=5 model=out iset=I1 prefix14_class=11631
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovge S1, P2
cmp P0, P3
mov S2, P1
mov S0, P0
cmovge P0, P3
cmovg P3, S0
cmp P1, P3
cmovge S2, P3
cmovl P1, P3
cmp S1, P0
cmovle P2, S1

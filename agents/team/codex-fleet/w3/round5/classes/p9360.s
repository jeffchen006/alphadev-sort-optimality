# n=5 model=out iset=I1 prefix14_class=9360
cmp P1, P3
mov S1, P1
cmovg S1, P3
cmovle P1, P3
mov S2, P0
cmp P2, P0
cmovle S2, P2
cmovl P2, P0
mov S0, S2
cmp S1, S0
cmovge S0, S1
cmovge S1, S2
cmp P1, P2
cmovg P0, P2

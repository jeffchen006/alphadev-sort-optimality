# n=5 model=out iset=I1 prefix14_class=9717
cmp P1, P3
cmovg S2, P3
cmovge P3, P1
cmovg P1, S2
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
mov S1, P3
cmovge S0, P2
cmp S0, S1
cmovge S1, S0
cmovle P3, S0
cmp P1, P0
cmovle S2, P1

# n=5 model=out iset=I1 prefix14_class=4482
cmp P3, P2
cmovg S2, P3
cmovg P3, P2
cmovle S2, P2
cmp P1, P0
cmovle S1, P1
cmovl P1, P0
cmovg S1, P0
cmp P1, S2
cmovge S0, P1
cmovge P1, S2
cmovge S2, S0
cmp S1, P3
mov S2, S1

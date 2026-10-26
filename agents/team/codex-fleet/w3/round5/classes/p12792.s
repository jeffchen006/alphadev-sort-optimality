# n=5 model=out iset=I1 prefix14_class=12792
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
cmovl P1, S0
mov S2, P1
mov S1, P2
cmp P3, P2
cmovle S1, P3
cmovge P2, P3
cmp S1, P0
cmovg S0, S1
cmovg S1, P0
cmovg P0, S0
cmp S2, P2

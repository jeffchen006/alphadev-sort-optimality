# n=5 model=out iset=I1 prefix14_class=10102
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
mov S2, P3
cmovge S0, P2
cmovg P2, P0
cmp S2, P1
cmovg S2, P1
cmovge P1, P3
cmp S0, P1
cmovle S1, S0
cmovl S0, P1
cmovle P1, S1
mov S0, P1

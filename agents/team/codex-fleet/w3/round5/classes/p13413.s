# n=5 model=out iset=I1 prefix14_class=13413
cmp P2, P0
cmovge S0, P2
cmovg P2, P0
mov S2, P1
cmovg P0, S0
cmp P3, P1
cmovg S2, P3
cmovl P1, P3
cmp P1, P2
cmovge S1, P2
cmovle S1, P1
cmovle P1, P2
cmp S2, P0
cmovg S0, P0

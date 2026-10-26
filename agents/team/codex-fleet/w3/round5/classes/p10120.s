# n=5 model=out iset=I1 prefix14_class=10120
cmp P1, P0
mov S0, P1
cmovg P1, P0
cmovle S0, P0
cmp P3, P2
cmovle S1, P3
mov S2, S0
cmovl P3, P2
cmovge S1, P2
cmp S2, P3
cmovg P0, P1
cmovge S0, P3
cmovle S2, P3
cmp P1, S1

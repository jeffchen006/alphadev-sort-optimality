# n=5 model=out iset=I1 prefix14_class=12811
cmp P3, P2
mov S2, P3
cmovle S2, P2
cmovl P2, P3
mov S0, P1
cmp S0, P0
cmovg S0, P0
cmovg P0, P1
cmp S0, P2
cmovg P3, S0
cmovge S0, P2
cmovg P2, P3
cmp P0, S2
mov S1, S2

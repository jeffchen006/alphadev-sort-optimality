# n=5 model=out iset=I1 prefix14_class=8335
cmp P3, P1
mov S0, P3
cmovl P3, P1
cmovge S0, P1
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
cmovg P2, S2
cmp S0, P2
mov S1, S0
cmovle S0, P2
cmovg S1, P2
cmp P3, P0
cmovge S1, P3

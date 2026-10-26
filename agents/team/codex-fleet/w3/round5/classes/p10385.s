# n=5 model=out iset=I1 prefix14_class=10385
mov S2, P1
cmp S2, P3
cmovg P1, P3
cmovle S2, P3
cmp P2, P0
mov S1, S2
mov S0, P0
cmovl P0, P2
cmovge S0, P2
cmp S2, S0
cmovge S2, S0
cmovle S1, S0
cmp P0, P1
cmovg S0, S2

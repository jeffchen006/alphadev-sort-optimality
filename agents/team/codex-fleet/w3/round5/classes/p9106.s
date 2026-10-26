# n=5 model=out iset=I1 prefix14_class=9106
cmp P3, P0
cmovge S1, P0
cmovle S1, P3
mov S0, P2
cmovl P3, P0
mov S2, S1
cmp S0, P1
cmovl S0, P1
cmovg P2, P1
cmp S1, P2
cmovg S1, P2
cmovle S2, P2
mov P2, S0
mov S1, S2

# n=5 model=out iset=I1 prefix14_class=66
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
mov S0, P3
cmovg S1, P2
mov P2, P1
cmp P0, P3
cmovg P3, P0
cmovg P0, S0
cmovle S0, P0
cmp S0, S1
cmovg S0, S1
cmovge S1, P0
cmp P1, P3

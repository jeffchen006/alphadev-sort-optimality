# n=5 model=out iset=I1 prefix14_class=65
cmp P1, P2
cmovle S0, P1
cmovg S0, P2
cmovl P1, P2
mov S1, P0
cmp P3, P0
mov S2, P1
cmovle S1, P3
cmovg P0, P3
mov P3, S1
cmp S1, S0
cmovg P3, S0
cmovge S0, S1
cmp S2, P0

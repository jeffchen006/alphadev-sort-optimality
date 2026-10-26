# n=5 model=out iset=I1 prefix14_class=187
cmp P3, P0
cmovl S2, P0
cmovge S2, P3
cmovg P3, P0
mov P0, S2
mov S1, P2
mov S0, P3
cmp P1, S1
cmovle S1, P1
cmovle P1, P2
cmp S1, S0
cmovg S0, S1
cmovl P3, S1
cmp P0, P1

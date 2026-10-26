# n=5 model=out iset=I1 prefix14_class=6094
cmp P3, P2
mov S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovle S1, P0
cmp S1, P3
cmovg S0, S1
mov P0, P1
cmovg S1, P3
cmovg P3, S0
cmp P0, P2

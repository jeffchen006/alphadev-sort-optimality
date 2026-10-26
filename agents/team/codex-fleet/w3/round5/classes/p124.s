# n=5 model=out iset=I1 prefix14_class=124
cmp P0, P3
cmovle S0, P3
cmovg S0, P0
cmovg P0, P3
mov S1, P2
cmp P1, P2
cmovge S1, P1
cmovle P2, P1
cmp P2, P0
cmovle P3, P0
cmovl P0, P2
mov P1, S1
cmovl P2, P3
cmp S0, S1

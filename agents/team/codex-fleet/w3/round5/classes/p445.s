# n=5 model=out iset=I1 prefix14_class=445
mov S1, P3
cmp P0, P1
cmovge S2, P0
cmovle S2, P1
cmovle P1, P0
mov S0, P1
cmp S1, P2
cmovg P3, P2
cmovg P2, S1
cmp P3, P1
cmovl P1, P3
cmovl P3, S0
mov P1, S2
cmp P1, P2

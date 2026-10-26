# n=5 model=out iset=I1 prefix14_class=6880
mov S2, P3
cmp P3, P2
cmovge S2, P2
cmovl P3, P2
cmp P0, P1
mov S0, P0
mov S1, P3
cmovle P0, P1
cmovge S0, P1
cmp P0, P3
cmovg P3, P0
cmovle S1, P0
cmp S0, S2
mov P3, S1

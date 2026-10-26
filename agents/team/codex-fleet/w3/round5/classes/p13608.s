# n=5 model=out iset=I1 prefix14_class=13608
cmp P2, P0
cmovle S1, P2
cmovle P2, P0
cmovle P0, S1
mov S2, P0
cmp P3, P1
cmovle S0, P3
cmovl P3, P1
cmovge S0, P1
cmp S0, P0
cmovg P0, S0
cmovle S2, S0
cmovle S0, P0
mov P1, P3

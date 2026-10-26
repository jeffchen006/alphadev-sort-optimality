# n=5 model=out iset=I1 prefix14_class=423
cmp P1, P0
mov S1, P0
mov S0, P2
cmovl P0, P1
cmovge S1, P1
cmp S0, P3
cmovg P2, P3
cmovg P3, S0
mov S0, P2
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmp S1, P3
mov P2, P3

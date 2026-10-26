# n=5 model=out iset=I1 prefix14_class=2002
mov S0, P2
cmp P1, P0
cmovge S1, P1
cmovle S1, P0
cmovg P1, P0
cmp P2, P3
cmovge S0, P3
cmovl P2, P3
mov S2, P1
mov P3, P2
cmp S1, P3
cmovg P2, S1
cmovle P3, S1
mov P2, P3

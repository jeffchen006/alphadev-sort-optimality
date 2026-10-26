# n=5 model=out iset=I1 prefix14_class=10067
cmp P2, P1
cmovge S2, P2
cmovl S2, P1
cmovg P2, P1
mov S0, P0
cmp P3, P0
cmovle S0, P3
cmovg P0, P3
mov S1, P0
cmp S1, S2
cmovle P0, S2
mov P0, P2
cmovg S1, S2
mov S2, S1

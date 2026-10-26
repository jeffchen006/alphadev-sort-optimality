# n=5 model=out iset=I1 prefix14_class=10
mov S1, P0
cmp P2, S1
cmovl S1, P2
cmovle P2, P0
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmovg P3, S2
cmovle S2, P3
cmp S1, P1
mov S0, S1
cmovg S1, P1
cmovle S0, P1
cmp S2, P2

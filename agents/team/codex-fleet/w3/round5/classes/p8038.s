# n=5 model=out iset=I1 prefix14_class=8038
cmp P2, P3
cmovl S1, P2
cmovge S1, P3
cmovg P3, P2
cmp P1, P0
cmovg S2, P1
cmovg P1, P0
cmovg P0, S2
cmp S1, P1
cmovle S0, P1
cmovle P1, S1
cmovle S1, S0
mov P2, P0
cmp P0, P3

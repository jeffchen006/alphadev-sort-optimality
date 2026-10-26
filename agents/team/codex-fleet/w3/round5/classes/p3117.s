# n=5 model=out iset=I1 prefix14_class=3117
mov S0, P1
cmp P3, P0
cmovle S1, P3
cmovge S1, P0
cmovg P0, P3
cmp P2, P1
cmovg S0, P2
cmovle P1, P2
mov S2, S1
cmp S1, P1
cmovl S2, P1
mov P3, S2
cmovge S1, P1
mov P1, S0

# n=5 model=out iset=I1 prefix14_class=473
cmp P2, P1
mov S0, P0
cmovl S1, P1
cmovge S1, P2
cmovle P1, P2
cmp S0, P3
cmovg S0, P3
cmovg P3, P0
cmp S0, P1
mov P0, P1
cmovle P1, S0
mov S2, P3
cmovle S0, P0
mov P1, S0

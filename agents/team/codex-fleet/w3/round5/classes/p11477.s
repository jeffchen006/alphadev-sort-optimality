# n=5 model=out iset=I1 prefix14_class=11477
cmp P0, P2
cmovg S2, P0
cmovle S2, P2
cmovle P2, P0
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmovl S0, P1
mov P1, P3
cmp P2, S0
cmovle S1, P2
cmovle P2, S0
cmovl S0, S1
cmp S2, P1

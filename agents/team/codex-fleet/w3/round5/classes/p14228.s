# n=5 model=out iset=I1 prefix14_class=14228
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
mov S0, P0
cmovle P3, S1
cmp P2, P0
cmovle P0, P2
cmovg S0, P2
cmovg P2, P0
mov S2, S0
cmp P3, S0
cmovl S0, P3
cmovge S2, P3
mov S2, S0

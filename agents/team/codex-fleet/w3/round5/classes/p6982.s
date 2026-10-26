# n=5 model=out iset=I1 prefix14_class=6982
cmp P3, P0
mov S0, P0
cmovg S0, P3
cmovg P3, P0
cmp P2, P1
cmovl S2, P1
cmovge S2, P2
cmovle P1, P2
mov S1, S0
cmp S1, S2
cmovle S0, S2
cmovg S1, S2
cmp P1, P3
cmovle P0, P3

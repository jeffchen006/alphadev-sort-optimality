# n=5 model=out iset=I1 prefix14_class=8094
cmp P2, P3
cmovge S0, P3
cmovle S0, P2
cmovle P2, P3
cmp P0, P1
cmovg S2, P1
cmovg P1, P0
cmovg P0, S2
mov P3, P1
mov S1, S0
cmp P0, S1
cmovl S1, P0
cmovg S0, P0
cmovle P0, S0

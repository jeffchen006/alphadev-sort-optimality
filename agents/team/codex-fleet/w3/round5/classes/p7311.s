# n=5 model=out iset=I1 prefix14_class=7311
cmp P1, P0
cmovle S1, P0
cmovl P0, P1
mov S2, P0
cmovle P1, S1
cmp P3, P2
cmovge S0, P2
cmovl S0, P3
cmovle P3, P2
cmp P0, S0
cmovg P0, S0
cmovg S0, S2
mov P0, P3
mov P2, S0

# n=5 model=out iset=I1 prefix14_class=8325
mov S2, P1
cmp P1, P0
cmovle S2, P0
cmovle P0, P1
cmp P3, P2
cmovge S0, P2
mov S1, P0
cmovg P2, P3
mov P1, S2
cmovg P3, S0
cmp P3, P0
cmovl P0, P3
cmovg S1, P3
mov P0, S1

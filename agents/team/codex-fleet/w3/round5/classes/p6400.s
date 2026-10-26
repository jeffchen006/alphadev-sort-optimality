# n=5 model=out iset=I1 prefix14_class=6400
cmp P2, P1
cmovge S2, P2
cmovg P2, P1
cmovg P1, S2
cmp P3, P0
cmovle S1, P0
cmovg S1, P3
cmovl P0, P3
cmovle P3, S1
cmp P1, P3
cmovle P3, P1
cmovg S1, P1
mov S1, P3
mov S0, P0

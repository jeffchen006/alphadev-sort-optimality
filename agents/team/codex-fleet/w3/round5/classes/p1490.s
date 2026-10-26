# n=5 model=out iset=I1 prefix14_class=1490
cmp P0, P3
mov S1, P0
mov S0, P1
cmovle S1, P3
cmovg P0, P3
cmp P1, P2
cmovl P1, P2
cmovle P2, S0
cmp P1, S1
cmovg S0, S1
cmovge S1, P1
cmovg P1, S0
mov S2, P0
cmp P2, P0

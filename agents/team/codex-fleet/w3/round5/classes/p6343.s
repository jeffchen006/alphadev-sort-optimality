# n=5 model=out iset=I1 prefix14_class=6343
cmp P3, P0
cmovg S0, P3
cmovge P3, P0
cmovg P0, S0
cmp P2, P1
cmovle S1, P1
mov S2, P0
cmovl P1, P2
cmovg S1, P2
cmp S1, P0
cmovg S2, S1
cmovle P0, S1
cmovg S1, P0
cmp P1, P3

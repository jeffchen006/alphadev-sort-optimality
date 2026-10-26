# n=5 model=out iset=I1 prefix14_class=3302
mov S2, P0
mov S1, P3
cmp P1, S2
cmovle P0, P1
cmovge S2, P1
cmp P3, P2
cmovle S1, P2
cmovg P3, P2
mov S0, P0
cmp P0, P3
cmovl P0, P3
cmovg S0, P3
cmp S2, S1
cmovge P1, S1

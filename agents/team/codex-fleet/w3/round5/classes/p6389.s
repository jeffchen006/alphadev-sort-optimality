# n=5 model=out iset=I1 prefix14_class=6389
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
cmovg P3, S2
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmovl P0, S2
mov S0, P0
cmp P0, P3
cmovg S0, P3
cmovge P3, P0
mov S1, P1
cmp S1, P2

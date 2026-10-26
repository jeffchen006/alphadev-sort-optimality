# n=5 model=out iset=I1 prefix14_class=3917
mov S2, P1
cmp P1, P0
mov S0, P2
cmovg P1, P0
cmovge P0, S2
cmp S0, P3
cmovle S0, P3
cmovl P3, P2
cmp P1, P3
mov S1, P3
cmovg S1, P1
cmovle P3, P1
cmp S0, P0
cmovge P2, P0

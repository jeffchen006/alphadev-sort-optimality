# n=5 model=out iset=I1 prefix14_class=4544
cmp P0, P3
mov S2, P1
cmovg S0, P0
cmovle S0, P3
cmovle P3, P0
cmp S2, P2
cmovg S2, P2
cmovle P1, P2
cmp S0, P1
mov P2, S0
cmovg S0, P1
cmovge P1, P2
cmp P3, S2
cmovl P2, S2

# n=5 model=out iset=I1 prefix14_class=13562
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
cmovl P2, S2
cmp P3, P1
cmovle S0, P1
cmovle P1, P3
cmovle P3, S0
cmp P1, P2
mov S1, P3
cmovg S0, P2
cmovge P2, P1
cmovg P1, S0
cmp S1, P0

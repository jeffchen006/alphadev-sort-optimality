# n=5 model=out iset=I1 prefix14_class=4717
mov S0, P0
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmovle P2, S1
cmp S0, P3
cmovg P0, P3
mov S2, P2
cmovge P3, S0
mov S0, P3
cmp P1, S0
cmovl P3, P1
cmovg S0, P1
cmp P2, P0

# n=5 model=out iset=I1 prefix14_class=4945
cmp P3, P2
mov S1, P1
cmovle S2, P2
cmovg S2, P3
cmovg P3, P2
cmp S1, P0
cmovle P1, P0
cmovl P0, S1
cmp P3, P0
cmovge P2, P3
cmovge P3, P0
cmovg P0, P2
cmp P1, S2
cmovle S0, S2

# n=5 model=out iset=I1 prefix14_class=8529
mov S2, P0
cmp S2, P3
mov S0, P1
cmovle P0, P3
cmovl P3, S2
mov S2, P0
cmp S0, P2
cmovle S0, P2
cmovl P2, P1
cmp S0, S2
cmovge P0, S0
cmovg S0, S2
cmp P3, P2
cmovg P1, P2

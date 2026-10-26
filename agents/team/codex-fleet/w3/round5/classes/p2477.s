# n=5 model=out iset=I1 prefix14_class=2477
cmp P0, P2
cmovg S2, P0
cmovge P0, P2
cmovle S2, P2
mov S0, P3
cmp P1, P3
cmovg S0, P1
mov S1, S2
cmovge P1, P3
cmp S2, S0
cmovle S2, S0
cmovl S0, S1
cmp P1, P0
cmovle P2, P1

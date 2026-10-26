# n=5 model=out iset=I1 prefix14_class=14435
cmp P3, P1
cmovle S0, P3
cmovle P3, P1
mov S2, P0
cmovg S0, P1
cmp P2, S2
cmovl S2, P2
mov P1, P3
cmovge P0, P2
cmp S0, S2
cmovg S1, S0
cmovg S0, S2
cmovg S2, S1
cmp P1, P0

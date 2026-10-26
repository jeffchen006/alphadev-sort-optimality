# n=5 model=out iset=I1 prefix14_class=4542
cmp P0, P3
cmovg S0, P0
mov S2, P1
cmovle S0, P3
cmovle P3, P0
cmp P1, P2
cmovge P1, P2
cmovl S2, P2
mov P2, S0
cmp S0, S2
cmovg S0, S2
cmovle P0, P1
cmovg S2, P2
cmp P3, P1

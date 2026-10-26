# n=5 model=out iset=I1 prefix14_class=14452
cmp P3, P0
cmovg S1, P0
mov S0, P1
cmovge P0, P3
cmovle S1, P3
cmp P2, P1
cmovle P1, P2
cmovle P2, S0
cmp S1, P1
mov S0, P0
cmovle S2, S1
cmovl S1, P1
cmovle P1, S2
mov P1, S1

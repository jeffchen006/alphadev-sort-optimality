# n=5 model=out iset=I1 prefix14_class=2712
cmp P0, P1
cmovg S1, P0
cmovle S1, P1
cmovle P1, P0
cmp P2, P3
cmovle S0, P2
cmovle P2, P3
cmovl P3, S0
mov S2, P2
cmp S1, S2
cmovle P2, S1
mov P0, P2
cmovle S1, S2
mov S1, P3

# n=5 model=out iset=I1 prefix14_class=12550
mov S0, P3
cmp S0, P2
cmovle S0, P2
mov S2, S0
cmovl P2, P3
cmp P0, P1
cmovle P3, P0
cmovle P0, P1
cmovle P1, P3
cmp P1, P2
cmovg S1, P1
cmovle S1, P2
cmovge P1, P2
cmp S2, P0

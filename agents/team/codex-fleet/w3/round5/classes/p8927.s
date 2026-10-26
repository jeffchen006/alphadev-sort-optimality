# n=5 model=out iset=I1 prefix14_class=8927
cmp P3, P0
mov S0, P0
cmovl P0, P3
cmovl P3, S0
mov S2, P1
cmp P2, P1
cmovle S2, P2
cmovge P1, P2
cmovle P2, P1
cmp P3, P2
cmovle P1, P3
cmovl P3, P2
cmp S2, P0
cmovg S0, P0

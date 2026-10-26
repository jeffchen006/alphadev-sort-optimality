# n=5 model=out iset=I1 prefix14_class=12232
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmovle P2, S0
mov S1, P3
cmp P1, P3
cmovle S1, P1
mov S2, P2
cmovge P3, P1
cmp P2, S1
cmovle S2, S1
cmovl S1, P2
cmp P0, P3
cmovl S1, P3

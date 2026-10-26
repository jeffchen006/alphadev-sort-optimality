# n=5 model=out iset=I1 prefix14_class=10868
cmp P3, P2
cmovle S1, P2
cmovle P2, P3
cmovle P3, S1
cmp P0, P1
cmovle S2, P1
cmovg S2, P0
mov S0, S2
cmovle P1, P0
cmp S2, P3
cmovge S0, P3
cmovge P3, S2
cmp P2, P1
cmovl S2, P1

# n=5 model=out iset=I1 prefix14_class=2866
cmp P3, P0
mov S2, P0
cmovge S2, P3
cmovle P0, P3
cmp P2, P1
mov S1, P2
cmovle S1, P1
cmovge P2, P1
cmp S2, S1
cmovle S0, S1
cmovl S1, S2
cmovg S0, S2
cmp P0, P2
cmovle P3, P0

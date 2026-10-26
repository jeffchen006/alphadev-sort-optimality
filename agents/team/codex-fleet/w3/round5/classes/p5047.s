# n=5 model=out iset=I1 prefix14_class=5047
mov S2, P0
cmp P1, S2
mov S0, P2
cmovge P0, P1
cmovle S2, P1
cmp P3, S0
cmovle P2, P3
cmovge S0, P3
cmp P2, S2
cmovge P1, S2
cmovle P1, P2
cmovg S2, P2
cmp P0, S0
cmovl S1, S0

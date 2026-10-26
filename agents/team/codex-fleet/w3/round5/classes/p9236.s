# n=5 model=out iset=I1 prefix14_class=9236
mov S2, P2
cmp P3, P2
mov S1, P0
cmovl S2, P3
cmovge P2, P3
cmp P1, S1
mov S0, S2
cmovle P0, P1
cmovg S1, P1
cmp P0, S0
cmovle S0, P0
cmovle P0, S2
mov S0, P0
cmp P2, S1

# n=5 model=out iset=I1 prefix14_class=4158
cmp P1, P2
cmovge S1, P2
mov S2, P0
cmovge P2, P1
cmovl S1, P1
cmp P0, P3
cmovle S2, P3
mov S0, S1
cmovle P3, P0
cmp P3, S1
cmovle S0, P3
cmovg S1, P3
cmp P2, S2
cmovg P1, P2

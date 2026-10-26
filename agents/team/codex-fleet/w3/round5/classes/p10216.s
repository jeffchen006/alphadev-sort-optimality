# n=5 model=out iset=I1 prefix14_class=10216
cmp P0, P1
mov S0, P3
cmovge S1, P0
cmovle S1, P1
cmovg P0, P1
cmp P2, S0
cmovge P3, P2
cmovge P2, S0
cmp P3, S1
cmovle P1, S1
cmovl S1, P3
mov S0, S1
cmovle P3, P1
mov S2, P0

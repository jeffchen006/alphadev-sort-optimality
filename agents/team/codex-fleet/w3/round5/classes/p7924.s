# n=5 model=out iset=I1 prefix14_class=7924
cmp P0, P3
cmovle S2, P0
cmovle P0, P3
cmovle P3, S2
mov S1, P1
cmp P1, P2
cmovg P1, P2
cmovge P2, S1
cmp P3, P1
mov S1, P1
cmovg P1, P3
cmovl S1, P3
cmp P2, P0
cmovle S0, P2

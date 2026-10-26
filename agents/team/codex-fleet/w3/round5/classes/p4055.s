# n=5 model=out iset=I1 prefix14_class=4055
mov S2, P1
mov S1, P0
cmp P1, P3
cmovg P1, P3
cmovg P3, S2
cmp P2, P0
cmovle S1, P2
cmovg P0, P2
cmp P1, S1
cmovge P2, P1
cmovle P2, S1
cmovl S1, P1
cmp P3, P0
mov S0, P2

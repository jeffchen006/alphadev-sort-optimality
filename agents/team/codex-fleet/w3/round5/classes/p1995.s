# n=5 model=out iset=I1 prefix14_class=1995
cmp P3, P1
mov S1, P3
mov S2, P2
cmovg P3, P1
cmovle S1, P1
cmp P0, S2
cmovge P2, P0
cmovl S2, P0
mov P0, S1
cmp P0, P2
cmovle S1, P2
cmovle P2, P0
mov S0, P2
cmp P3, S2

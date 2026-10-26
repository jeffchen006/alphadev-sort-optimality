# n=5 model=out iset=I1 prefix14_class=5362
cmp P2, P3
mov S0, P1
mov S1, P2
cmovl S1, P3
cmovg P2, P3
cmp P0, P1
cmovle S0, P0
cmovg P1, P0
cmp P2, S0
cmovge P0, S0
cmovle P0, P2
cmovg S0, P2
cmp P1, S1
cmovge P3, P1

# n=5 model=out iset=I1 prefix14_class=3818
mov S0, P1
mov S1, P2
cmp P2, P3
cmovg P2, P3
cmovg P3, S1
cmp P0, P1
cmovge P1, P0
cmovl S0, P0
cmp P2, S0
mov S1, P2
cmovle P2, S0
cmovle S0, S1
cmp P3, P1
cmovle S0, P1

# n=5 model=out iset=I1 prefix14_class=21
mov S1, P3
cmp P0, S1
cmovle P3, P0
cmovle P0, S1
mov S2, P3
cmp P1, P2
mov S0, P1
cmovge P1, P2
cmovg P2, S0
cmp P3, P1
cmovl S2, P1
cmovge P3, P1
mov P1, P2
cmp P2, P0

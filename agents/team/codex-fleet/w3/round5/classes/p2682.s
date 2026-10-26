# n=5 model=out iset=I1 prefix14_class=2682
mov S0, P2
cmp P1, P2
cmovl S0, P1
mov S1, P0
cmovg P2, P1
cmp P0, P3
cmovge P0, P3
cmovl S1, P3
cmp P2, S1
cmovle P3, P2
cmovge P3, S1
cmovle P2, S1
mov P2, S0
cmp P2, P0

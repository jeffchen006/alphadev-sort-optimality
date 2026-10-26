# n=5 model=out iset=I1 prefix14_class=1311
mov S2, P0
cmp P1, S2
cmovl S2, P1
cmovle P1, P0
mov S0, P2
cmp P2, P3
cmovge P2, P3
cmovge P3, S0
mov S0, P1
cmp P3, P1
cmovge P1, P3
cmovg P3, S0
mov S0, P3
mov P1, S2

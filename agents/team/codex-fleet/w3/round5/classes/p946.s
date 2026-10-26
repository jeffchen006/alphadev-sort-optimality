# n=5 model=out iset=I1 prefix14_class=946
cmp P2, P0
cmovl S0, P0
cmovle P0, P2
cmovge S0, P2
mov S1, P3
cmp P3, P1
cmovg P3, P1
cmovge P1, S1
cmp P1, S0
mov P2, P1
cmovge P1, S0
cmovle P2, S0
cmp P0, P3
mov S2, P0

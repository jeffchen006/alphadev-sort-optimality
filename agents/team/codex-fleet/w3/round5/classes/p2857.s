# n=5 model=out iset=I1 prefix14_class=2857
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmovl S0, P0
mov S1, P3
mov P0, P2
cmp P0, P1
cmovge P2, P1
cmovle P0, P1
cmp P0, P3
cmovge S1, P0
cmovg P0, P3
cmp P2, S0
cmovge P3, S0

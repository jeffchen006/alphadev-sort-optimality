# n=5 model=out iset=I1 prefix14_class=2856
cmp P0, P3
cmovl S0, P0
cmovge S0, P3
cmovg P3, P0
mov S1, P3
mov P0, P1
cmp P1, P2
cmovge P1, P2
cmovle P0, P2
cmp P0, P3
cmovge S1, P0
cmovg P0, P3
cmp P1, S0
cmovle P3, P1

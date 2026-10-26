# n=5 model=out iset=I1 prefix14_class=5109
cmp P3, P2
cmovge S2, P3
cmovl S2, P2
mov S0, P1
cmovg P3, P2
cmp P1, P0
cmovl S0, P0
cmovge P1, P0
mov P2, S2
cmp P3, P1
mov S1, P1
cmovg S1, P3
cmovle P1, P3
mov P1, S1

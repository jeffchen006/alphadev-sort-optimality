# n=5 model=out iset=I1 prefix14_class=11886
mov S1, P1
cmp P1, P3
cmovl S1, P3
cmovle P3, P1
cmp P0, P2
cmovl P1, P0
cmovge P1, P2
cmovge P2, P0
cmp S1, P2
mov P0, P2
cmovge P2, S1
cmovge S1, P0
cmp P3, P1
cmovg S0, P3
